package VulkanRenderPass

import VulkanRenderer
import RenderGraph
import ECS
import Vec
import Array
import UniformBufferObject
import Time
import Math
import Transform
import Matrix
import RenderComponents
import RenderAssetDef

state DrawPushConstants
{
	modelBufferAddress: uint64,
	geometryVariablesAddress: uint64,
	geometryAttributeSlotsAddress: uint64,
	materialVariablesAddress: uint64,
	materialTextureSlotsAddress: uint64
}

state AssetFrameGlobal
{
	set: *VkDescriptorSet_T
}

state AssetPassState
{
	frameGlobalPool: *VkDescriptorPool_T,
	frameGlobals: VulkanFrameResource<AssetFrameGlobal>,
	assetPassResource: RenderResourceHandle
}

AssetPassState::Init()
{
	device := vulkanInstance.device;

	poolSizes := [VkDescriptorPoolSize(), VkDescriptorPoolSize()];
	poolSizes[0].type = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
	poolSizes[0].descriptorCount = FrameCount;
	poolSizes[1].type = VkDescriptorType.VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
	poolSizes[1].descriptorCount = 5 * FrameCount;

	poolInfo := VkDescriptorPoolCreateInfo();
	poolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
	poolInfo.poolSizeCount = 2;
	poolInfo.pPoolSizes = fixed poolSizes;
	poolInfo.maxSets = FrameCount;

	CheckResult(
		vkCreateDescriptorPool(device, poolInfo@, null, this.frameGlobalPool@),
		"AssetPass Error creating frame-global descriptor pool"
	);

	for (i .. FrameCount) this.frameGlobals.frames[i] = AssetFrameGlobal();
}

*VkDescriptorSet_T GetFrameGlobalSet(assetState: *AssetPassState, assetDefHandle: AssetDefHandle,
									 assetDef: *AssetDef, context: *RenderPassContext<VulkanRenderer>,
									 renderer: *VulkanRenderer, lightCull: *LightCullState,
									 shadow: *ShadowPassState, frame: uint32)
{
	globalFrame := assetState.frameGlobals.frames[frame];
	device := vulkanInstance.device;

	if (!globalFrame.set)
	{
		descSets := vulkanInstance.pipelineLayoutCache.descLayoutSetMap.Find(PipelineLayoutKey(assetDefHandle))~;

		allocInfo := VkDescriptorSetAllocateInfo();
		allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
		allocInfo.descriptorPool = assetState.frameGlobalPool;
		allocInfo.descriptorSetCount = 1;
		allocInfo.pSetLayouts = descSets[0]@;

		CheckResult(
			vkAllocateDescriptorSets(device, allocInfo@, globalFrame.set@),
			"AssetPass Error allocating frame-global descriptor set"
		);

		WriteUniformBufferDescriptor(device, globalFrame.set, 0, renderer.sceneShared.buffers[frame], #sizeof SceneUBO);

		if (assetDef.flags & AssetDefFlags.UseLighting)
		{
			atlasImage := UseRenderPassTexture<VulkanRenderer, VkImage_T>(context, shadow.directionalLightAtlas);
			atlasTarget := vulkanInstance.resourceManager.renderTargetMap.Find(atlasImage);

			WriteCombinedImageSamplerDescriptor(
				device, globalFrame.set, 1,
				atlasTarget.imageView, shadow.atlasSampler,
				VkImageLayout.VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL
			);


			WriteStorageBufferDescriptor(device, globalFrame.set, 2, UseRenderPassBuffer<VulkanRenderer, VkBuffer_T>(context, lightCull.lightsHandle, frame));
			WriteStorageBufferDescriptor(device, globalFrame.set, 3, UseRenderPassBuffer<VulkanRenderer, VkBuffer_T>(context, lightCull.lightGridHandle, frame));
			WriteStorageBufferDescriptor(device, globalFrame.set, 4, UseRenderPassBuffer<VulkanRenderer, VkBuffer_T>(context, lightCull.lightIndexHandle, frame));
			WriteStorageBufferDescriptor(device, globalFrame.set, 5, UseRenderPassBuffer<VulkanRenderer, VkBuffer_T>(context, lightCull.clusterInfoHandle, frame));

			WriteUniformBufferDescriptor(device, globalFrame.set, 6, shadow.shadowData.buffers[frame], #sizeof DirectionalShadowData);
		}
	}

	return globalFrame.set;
}

assetPassName: string = "AssetPass";
assetPass := RegisterRenderPass(
	assetPassName,
	::(graph: RenderGraph<VulkanRenderer>, scene: *Scene, self: *VulkanRenderPass) 
	{
		graph.AddPass(
			assetPassName,
			::bool(builder: *RenderPassBuilder<VulkanRenderer>, scene: *Scene) 
			{
				renderer := builder.Renderer();
				
				assetTextureDesc := TextureDesc();
				assetTextureDesc.format = GPUFormat.R16G16B16A16_SFLOAT;
				assetTextureDesc.usage = GPUTextureUsage.Color | 
										 GPUTextureUsage.GraphicsRead |
										 GPUTextureUsage.ComputeWrite;
				assetTextureDesc.flags = GPUTextureFlags.SizeSwapchainRelative;
				assetTextureDesc.layerCount = 1;
				assetTextureDesc.mipLevels = 1;
				assetTextureDesc.depth = 1;
				assetTextureDesc.layout = GPUTextureLayout.Undefined;

				assetState := renderer.GetRenderPassByName(assetPassName).data as *AssetPassState;
				assetState.assetPassResource = builder.CreateTexture("asset", assetTextureDesc);

				builder.Write(assetState.assetPassResource, ResourceUsageFlags.DefaultWrite);
				builder.SetClearColor(assetState.assetPassResource, Color(0.25, 0.117, 0.132, 0.0));

				depthState := renderer.GetRenderPassByName(depthPassName).data as *DepthPassState;
				builder.Read(depthState.depthHandle);
				builder.Write(depthState.depthHandle, ResourceUsageFlags.Depth | ResourceUsageFlags.Store);

				lightCullPass := renderer.GetRenderPassByName(lightCullPassName);
				if (lightCullPass)
				{
					lightCull := lightCullPass.data as *LightCullState;
					builder.Read(lightCull.lightGridHandle, ResourceUsageFlags.StorageRead);
					builder.Read(lightCull.lightIndexHandle, ResourceUsageFlags.StorageRead);
					builder.Read(lightCull.lightsHandle, ResourceUsageFlags.StorageRead);
				}

				shadowPass := renderer.GetRenderPassByName(shadowPassName);
				if (shadowPass)
				{
					shadow := shadowPass.data as *ShadowPassState;
					builder.Read(shadow.directionalLightAtlas, ResourceUsageFlags.Sampled);
				}

				return true;
			},
			::(context: *RenderPassContext<VulkanRenderer>, scene: *Scene) 
			{
				// log "Vulkan Asset pass";
				renderer := context.renderer;

				device := vulkanInstance.device;
				renderPass := renderer.CastDriverRenderPass(context.driverRenderpass);
				frame := renderer.Frame();

				commandBuffer := renderer.GetCommandBuffer(CommandBufferKind.Graphics);

				resourceManager := vulkanInstance.resourceManager;
				bindPoint := VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS;

				assetState := renderer.GetRenderPassByName(assetPassName).data as *AssetPassState;

				lightCull: *LightCullState = null;
				lightCullPass := renderer.GetRenderPassByName(lightCullPassName);
				if (lightCullPass) lightCull = lightCullPass.data as *LightCullState;

				shadow: *ShadowPassState = null;
				shadowPass := renderer.GetRenderPassByName(shadowPassName);
				if (shadowPass) shadow = shadowPass.data as *ShadowPassState;

				sceneDescSet := renderer.sceneShared.GetDescSet(frame);

				vkCmdBindIndexBuffer(
					commandBuffer, resourceManager.sharedIndexBuffer.buffer,
					0, VkIndexType.VK_INDEX_TYPE_UINT16
				);

				for (batch in renderer.drawList.batchMap.Values())
				{
					if (!batch.meshes.count) continue;

					meshState := batch.meshState;
					drawBuffers := batch.buffers;

					vulkanPipeline := FindOrCreatePipeline(
						device,
						CreatePipelineKey(meshState, renderPass),
						vulkanInstance.pipelineCache,
						vulkanInstance.pipelineLayoutCache
					);
					pipelineLayout := vulkanPipeline.layout;

					vkCmdBindPipeline(commandBuffer, bindPoint, vulkanPipeline.pipeline);
					renderer.SetViewportAndScissor(commandBuffer);

					assetDef := GetAssetDefWithHandle(meshState.assetDefHandle);

					if (assetDef.flags & AssetDefFlags.UseLighting)
					{
						set0 := GetFrameGlobalSet(assetState, meshState.assetDefHandle, assetDef, context, renderer, lightCull, shadow, frame);
						vkCmdBindDescriptorSets(
							commandBuffer, bindPoint, pipelineLayout,
							uint32(0), uint32(1), set0@, uint32(0), null
						);
					}
					else
					{
						vkCmdBindDescriptorSets(
							commandBuffer, bindPoint, pipelineLayout,
							uint32(0), uint32(1), sceneDescSet@, uint32(0), null
						);
					}

					push := DrawPushConstants();
					push.modelBufferAddress = drawBuffers.modelBufferAddress;
					push.geometryVariablesAddress = drawBuffers.geometryVariablesAddress;
					push.geometryAttributeSlotsAddress = drawBuffers.geometryAttributeSlotsAddress;
					push.materialVariablesAddress = drawBuffers.materialVariablesAddress;
					push.materialTextureSlotsAddress = drawBuffers.materialTextureSlotsAddress;

					pushStages := uint32(VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT);
					if (assetDef.fragment.variables.sets.count | assetDef.fragment.textures.count)
					{
						pushStages |= uint32(VkShaderStageFlagBits.VK_SHADER_STAGE_FRAGMENT_BIT);
					}

					if (assetDef.vertex.attributes.count | assetDef.fragment.textures.count)
					{
						bindlessSetIndex := assetDef.GetBindlessTextureSetIndex();
						vkCmdBindDescriptorSets(
							commandBuffer, bindPoint, pipelineLayout,
							bindlessSetIndex, uint32(1), resourceManager.bindless.set@, uint32(0), null
						);
					}

					vkCmdPushConstants(
						commandBuffer, pipelineLayout,
						pushStages,
						0, #sizeof DrawPushConstants, push@
					);

					vkCmdSetCullMode(commandBuffer, meshState.GetCullMode());

					vkCmdDrawIndexedIndirect(
						commandBuffer,
						drawBuffers.culledIndexedDrawCommands.buffer, 0,
						batch.indexedCount,
						#sizeof VkDrawIndexedIndirectCommand
					);
					vkCmdDrawIndirect(
						commandBuffer,
						drawBuffers.culledDrawCommands.buffer, 0,
						batch.nonIndexedCount,
						#sizeof VkDrawIndirectCommand
					);
				}
			},
			RenderPassStage.Graphics,
			scene
		);
	},
	::(renderer: VulkanRenderer, self: *VulkanRenderPass)
	{
		assetState := new AssetPassState();
		assetState.Init();
		self.data = assetState;
	},
	::(renderer: VulkanRenderer, self: *VulkanRenderPass)
	{
		assetState := self.data as *AssetPassState;
		vkDestroyDescriptorPool(vulkanInstance.device, assetState.frameGlobalPool, null);
		delete assetState;
	},
	::(renderer: VulkanRenderer, self: *VulkanRenderPass)
	{
		assetState := self.data as *AssetPassState;
		vkResetDescriptorPool(vulkanInstance.device, assetState.frameGlobalPool, 0);
		for (i .. FrameCount) assetState.frameGlobals.frames[i].set = null;
	}
);
