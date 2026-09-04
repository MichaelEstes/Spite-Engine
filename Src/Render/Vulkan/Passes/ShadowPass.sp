package VulkanRenderPass

import VulkanRenderer
import RenderGraph
import ECS
import Array
import Matrix
import Vec
import RenderComponents
import Transform
import Common
import ShaderTools
import UniformBufferObject
import Math

MaxShadowedDirectionalLights := 4;
DirectionalShadowAtlasWidth := uint32(8192);
DirectionalShadowAtlasHeight := uint32(8192);
CascadeCount := 4;

CascadeSplitLambda := float32(0.95);
ShadowRadiusQuantum := float32(16.0);

MaxShadowedPointLights := 16;
PointShadowAtlasWidth := uint32(8192);
PointShadowAtlasHeight := uint32(8192);

NoShadowIndex := uint32(-1);

state DirectionalLightData
{
	cascadeUBOs: [CascadeCount]SharedUBO<SceneUBO>,
}

state PointLightData
{
	lightUBOs: [6]SharedUBO<SceneUBO>,
}

state DirectionalCascade
{
	view: Matrix4,
	projection: Matrix4,
	tile: Vec4,
	params: Vec4
}

state DirectionalShadowData
{
	cascades: [MaxShadowedDirectionalLights * CascadeCount]DirectionalCascade,
	cascadeSplits: Vec4,
	lightCount: uint32
}

state ShadowPassState
{
    directionalLights: [MaxShadowedDirectionalLights]DirectionalLightData,
	pointLights: [MaxShadowedPointLights]PointLightData,

	directionalLightEntities: [MaxShadowedDirectionalLights]Entity,
	pointLightEntities: [MaxShadowedPointLights]Entity,

	pointLightAtlas: [6]RenderResourceHandle,
	directionalLightAtlas: RenderResourceHandle,

	shadowData: SharedUBO<DirectionalShadowData>,
	atlasSampler: *VkSampler_T,

	directionalLightCount: uint32,
	pointLightCount: uint32
}

uint32 DirectionalShadowIndex(shadow: *ShadowPassState, entity: Entity)
{
	if (!shadow) return NoShadowIndex;

	for (i .. shadow.directionalLightCount)
	{
		if (shadow.directionalLightEntities[i].id == entity.id) return i;
	}

	return NoShadowIndex;
}

*VkSampler_T CreateShadowAtlasSampler(device: *VkDevice_T)
{
	samplerInfo := VkSamplerCreateInfo();
	samplerInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO;
	samplerInfo.magFilter = VkFilter.VK_FILTER_LINEAR;
	samplerInfo.minFilter = VkFilter.VK_FILTER_LINEAR;
	samplerInfo.addressModeU = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_BORDER;
	samplerInfo.addressModeV = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_BORDER;
	samplerInfo.addressModeW = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_BORDER;
	samplerInfo.borderColor = VkBorderColor.VK_BORDER_COLOR_FLOAT_OPAQUE_WHITE;
	samplerInfo.anisotropyEnable = VkFalse;
	samplerInfo.unnormalizedCoordinates = VkFalse;
	samplerInfo.compareEnable = VkTrue;
	samplerInfo.compareOp = VkCompareOp.VK_COMPARE_OP_LESS_OR_EQUAL;
	samplerInfo.mipmapMode = VkSamplerMipmapMode.VK_SAMPLER_MIPMAP_MODE_NEAREST;
	samplerInfo.mipLodBias = 0.0;
	samplerInfo.minLod = 0.0;
	samplerInfo.maxLod = 0.0;

	sampler: *VkSampler_T = null;
	CheckResult(
		vkCreateSampler(device, samplerInfo@, null, sampler@),
		"CreateShadowAtlasSampler Error creating shadow atlas sampler"
	);

	return sampler;
}

VkRect2D ShadowAtlasTile(atlasWidth: uint32, atlasHeight: uint32, tilesPerRow: uint32, tileIndex: uint32)
{
	tileWidth := atlasWidth / tilesPerRow;
	tileHeight := atlasHeight / tilesPerRow;

	tile := VkRect2D();
	tile.offset = {
		int32((tileIndex % tilesPerRow) * tileWidth),
		int32((tileIndex / tilesPerRow) * tileHeight)
	};
	tile.extent = {tileWidth, tileHeight};

	return tile;
}

float32 CascadeSplitRatio(near: float32, far: float32, split: uint32)
{
	clipRange := far - near;
	ratio := far / near;

	p := (split + 1) as float32 / CascadeCount as float32;

	logSplit := near * Math.Powf(ratio, p);
	uniformSplit := near + clipRange * p;
	splitDistance := uniformSplit + CascadeSplitLambda * (logSplit - uniformSplit);

	return (splitDistance - near) / clipRange;
}

SceneUBO CascadeSceneUBO(cameraView: Matrix4, cameraProjection: Matrix4, lightDir: Vec3,
						 splitDist: float32, lastSplitDist: float32, depthRange: *float32)
{
	cameraInv := (cameraView * cameraProjection).Inverse();

	corners := Vec3:[
		Vec3(-1.0, 1.0, 0.0),
		Vec3(1.0, 1.0, 0.0),
		Vec3(1.0, -1.0, 0.0),
		Vec3(-1.0, -1.0, 0.0),
		Vec3(-1.0, 1.0, 1.0),
		Vec3(1.0, 1.0, 1.0),
		Vec3(1.0, -1.0, 1.0),
		Vec3(-1.0, -1.0, 1.0)
	];
	
	for (i .. 8)
	{
		corner := cameraInv * Vec4(corners[i].x, corners[i].y, corners[i].z, 1.0);
		corners[i] = Vec3(corner / corner.w);
	}

	for (i .. 4)
	{
		edge := corners[i + 4] - corners[i];
		corners[i + 4] = corners[i] + edge * splitDist;
		corners[i] = corners[i] + edge * lastSplitDist;
	}

	center := Vec3(0.0, 0.0, 0.0);
	for (i .. 8) center = center + corners[i];
	center = center / 8.0;

	radius := float32(0.0);
	for (i .. 8)
	{
		cornerDistance := (corners[i] - center).Length();
		if (cornerDistance > radius) radius = cornerDistance;
	}

	quantized := radius * ShadowRadiusQuantum;
	radius = (quantized as int32) as float32;
	if (radius < quantized) radius += 1.0;
	radius = radius / ShadowRadiusQuantum;

	lightUp := Vec3(0.0, 1.0, 0.0);
	if (Math.FAbs(lightDir.Dot(lightUp)) > 0.999) lightUp = Vec3(0.0, 0.0, 1.0);

	lightView := Matrix4();
	lightView.LookAt(center - lightDir * radius, center, lightUp);

	depthRange~ = radius * 2.0;

	sceneUBO := SceneUBO();
	sceneUBO.view = lightView;
	sceneUBO.projection.Orthographic(radius * -1.0, radius, radius * -1.0, radius, 0.0, depthRange~);
	sceneUBO.projection[1][1] *= -1;

	mapSize := DirectionalShadowAtlasWidth as float32 / CascadeCount as float32;
	shadowMat := sceneUBO.view * sceneUBO.projection;
	shadowOrigin := Vec3(shadowMat * Vec4(0.0, 0.0, 0.0, 1.0));
	shadowOrigin = shadowOrigin * (mapSize / 2.0);
	roundedOrigin := Vec3(
		Math.Round(shadowOrigin.x),
		Math.Round(shadowOrigin.y),
		Math.Round(shadowOrigin.z)
	);
	roundOffset := roundedOrigin - shadowOrigin;
	roundOffset = roundOffset * (2.0 / mapSize);
	roundOffset.z = 0.0;

	sceneUBO.projection[3][0] = sceneUBO.projection[3][0] + roundOffset.x;
	sceneUBO.projection[3][1] = sceneUBO.projection[3][1] + roundOffset.y;

	return sceneUBO;
}

RenderLightShadowMap(renderer: *VulkanRenderer, commandBuffer: *VkCommandBuffer_T,
					 renderPass: *VkRenderPass_T, lightDescSet: *VkDescriptorSet_T,
					 atlasTile: VkRect2D)
{
	device := vulkanInstance.device;
	resourceManager := vulkanInstance.resourceManager;
	bindPoint := VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS;

	shadowViewport := VkViewport();
	shadowViewport.x = atlasTile.offset.x as float32;
	shadowViewport.y = atlasTile.offset.y as float32;
	shadowViewport.width = atlasTile.extent.width as float32;
	shadowViewport.height = atlasTile.extent.height as float32;
	shadowViewport.minDepth = float32(0.0);
	shadowViewport.maxDepth = float32(1.0);
	vkCmdSetViewport(commandBuffer, uint32(0), uint32(1), shadowViewport@);

	vkCmdSetScissor(commandBuffer, uint32(0), uint32(1), atlasTile@);

	for (batch in renderer.drawList.batchMap.Values())
	{
		if (!batch.meshes.count) continue;

		meshState := batch.meshState;
		if (meshState.GetAlphaMode() != VulkanAlphaMode.Opaque) continue;

		drawBuffers := batch.buffers;

		vulkanPipeline := FindOrCreateDepthPipeline(
			device,
			CreatePipelineKey(meshState, renderPass),
			vulkanInstance.pipelineCache,
			vulkanInstance.pipelineLayoutCache
		);
		pipelineLayout := vulkanPipeline.layout;

		vkCmdBindPipeline(commandBuffer, bindPoint, vulkanPipeline.pipeline);

		vkCmdBindDescriptorSets(
			commandBuffer, bindPoint, pipelineLayout,
			uint32(0), uint32(1), lightDescSet@, uint32(0), null
		);

		push := DrawPushConstants();
		push.modelBufferAddress = drawBuffers.modelBufferAddress;
		push.geometryVariablesAddress = drawBuffers.geometryVariablesAddress;
		push.geometryAttributeSlotsAddress = drawBuffers.geometryAttributeSlotsAddress;
		push.materialVariablesAddress = drawBuffers.materialVariablesAddress;
		push.materialTextureSlotsAddress = drawBuffers.materialTextureSlotsAddress;
		vkCmdPushConstants(
			commandBuffer, pipelineLayout,
			uint32(VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT),
			0, #sizeof DrawPushConstants, push@
		);

		assetDef := GetAssetDefWithHandle(meshState.assetDefHandle);

		if (assetDef.vertex.attributes.count)
		{
			bindlessSet := assetDef.GetBindlessTextureSetIndex();
			vkCmdBindDescriptorSets(
				commandBuffer, bindPoint, pipelineLayout,
				bindlessSet, uint32(1), resourceManager.bindless.set@, uint32(0), null
			);
		}

		vkCmdSetCullMode(commandBuffer, meshState.GetCullMode());

		vkCmdDrawIndexedIndirect(
			commandBuffer,
			drawBuffers.indexedDrawCommands.buffer, 0,
			batch.indexedCount, #sizeof VkDrawIndexedIndirectCommand
		);
		vkCmdDrawIndirect(
			commandBuffer,
			drawBuffers.drawCommands.buffer, 0,
			batch.nonIndexedCount, #sizeof VkDrawIndirectCommand
		);
	}
}

shadowPassName: string = "ShadowPass";
shadowPass := RegisterRenderPass(
	shadowPassName,
	::(graph: RenderGraph<VulkanRenderer>, scene: *Scene, self: *VulkanRenderPass)
	{
		renderer := graph.renderer;
		frame := renderer.Frame();

		graph.AddPass(
			shadowPassName,
			::bool(builder: *RenderPassBuilder<VulkanRenderer>, scene: *Scene)
			{
				device := vulkanInstance.device;
				allocator := vulkanInstance.allocator;

				renderer := builder.Renderer();
				shadow := renderer.GetRenderPassByName(shadowPassName).data as *ShadowPassState;

				dirLightAtlas := TextureDesc();
				dirLightAtlas.format = renderer.swapchain.depthFormat;
				dirLightAtlas.usage = GPUTextureUsage.DepthStencil | GPUTextureUsage.Sampler;
				dirLightAtlas.depth = 1;
				dirLightAtlas.layerCount = 1;
				dirLightAtlas.mipLevels = 1;
				dirLightAtlas.width = DirectionalShadowAtlasWidth;
    			dirLightAtlas.height = DirectionalShadowAtlasHeight;
				dirLightAtlas.layout = GPUTextureLayout.Undefined;

				shadow.directionalLightAtlas = builder.CreateTexture("dirlightAtlas", dirLightAtlas);
				builder.Write(shadow.directionalLightAtlas, ResourceUsageFlags.Depth | ResourceUsageFlags.Store);
				builder.SetDepthStencilColor(shadow.directionalLightAtlas, DepthStencilClear(1.0, 0));

				zero_out_bytes(fixed shadow.directionalLightEntities, #sizeof shadow.directionalLightEntities);
				shadow.directionalLightCount = 0;
				for (ec in scene.Iterate<DirectionalLight>())
				{
					if (shadow.directionalLightCount >= MaxShadowedDirectionalLights) break;

					dirLightEntity := ec.entity;

					dirLight := shadow.directionalLights[shadow.directionalLightCount];
					for (cascade .. CascadeCount)
					{
						cascadeUBO := dirLight.cascadeUBOs[cascade];
						if (!cascadeUBO.Valid())
						{
							cascadeUBO.Init(device, allocator, 0, VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT);
						}
					}
					shadow.directionalLightEntities[shadow.directionalLightCount] = dirLightEntity;

					shadow.directionalLightCount += 1;
				}


				return true;
			},
			::(context: *RenderPassContext<VulkanRenderer>, scene: *Scene)
			{
				renderer := context.renderer;
                device := vulkanInstance.device;
				renderPass := renderer.CastDriverRenderPass(context.driverRenderpass);
				frame := renderer.Frame();
				commandBuffer := renderer.GetCommandBuffer(CommandBufferKind.Graphics);
                
                shadow := renderer.GetRenderPassByName(shadowPassName).data as *ShadowPassState;
                
                resourceManager := vulkanInstance.resourceManager;

				vkCmdBindIndexBuffer(
					commandBuffer, resourceManager.sharedIndexBuffer.buffer,
					0, VkIndexType.VK_INDEX_TYPE_UINT16
				);

                camera := scene.GetComponent<Camera>(renderer.self);
				cameraNear := camera.near;
                shadowFar := camera.far;
				
				cameraView := renderer.sceneShared.current.view;
				cameraProj := renderer.sceneShared.current.projection;


                shadowData := DirectionalShadowData();
                shadowData.lightCount = shadow.directionalLightCount;

                for (i .. shadow.directionalLightCount)
                {
					dirLightEntity := shadow.directionalLightEntities[i];

                    dirLight := shadow.directionalLights[i];
                    directionalLight := scene.GetComponentDirect<DirectionalLight>(
                        dirLightEntity, DirectionalLightComponent
                    );

                    lightDir := directionalLight.direction~;
                    lightDir.Normalize();

                    lastSplitDist := float32(0.0);
                    for (cascade .. CascadeCount)
                    {
                        splitDist := CascadeSplitRatio(cameraNear, shadowFar, cascade);

                        cascadeDepthRange := float32(0.0);
                        cascadeSceneUBO := CascadeSceneUBO(
                            cameraView, cameraProj, lightDir, splitDist, lastSplitDist, cascadeDepthRange@
                        );

                        cascadeUBO := dirLight.cascadeUBOs[cascade];
                        cascadeUBO.Update(frame, cascadeSceneUBO);

                        tile := ShadowAtlasTile(
                            DirectionalShadowAtlasWidth, DirectionalShadowAtlasHeight,
                            CascadeCount, i * CascadeCount + cascade
                        );

                        shadowCascade := shadowData.cascades[i * CascadeCount + cascade];
                        shadowCascade.view = cascadeSceneUBO.view;
                        shadowCascade.projection = cascadeSceneUBO.projection;
                        shadowCascade.tile = Vec4(
                            tile.offset.x as float32 / DirectionalShadowAtlasWidth as float32,
                            tile.offset.y as float32 / DirectionalShadowAtlasHeight as float32,
                            tile.extent.width as float32 / DirectionalShadowAtlasWidth as float32,
                            tile.extent.height as float32 / DirectionalShadowAtlasHeight as float32
                        );
                        shadowCascade.params = Vec4(cascadeDepthRange, 0.0, 0.0, 0.0);

                        shadowData.cascadeSplits[cascade] = cameraNear + splitDist * (shadowFar - cameraNear);

                        RenderLightShadowMap(
                            renderer, commandBuffer, renderPass,
                            cascadeUBO.GetDescSet(frame), tile
                        );

                        lastSplitDist = splitDist;
                    }
                }

                shadow.shadowData.Update(frame, shadowData);
			},
			RenderPassStage.Graphics,
			scene
		);
	},
	::(renderer: VulkanRenderer, self: *VulkanRenderPass)
	{
		self.data = new ShadowPassState();
        shadow := self.data as *ShadowPassState;
        shadow.atlasSampler = CreateShadowAtlasSampler(vulkanInstance.device);
        shadow.shadowData.Init(
            vulkanInstance.device, vulkanInstance.allocator, 6,
            VkShaderStageFlagBits.VK_SHADER_STAGE_FRAGMENT_BIT
        );
	},
	::(renderer: VulkanRenderer, self: *VulkanRenderPass)
	{
		delete self.data as *ShadowPassState;
	}
);
