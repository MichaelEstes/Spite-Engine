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

VulkanPipelineKey CreateAssetPassPipelineKey(meshState: VulkanPipelineMeshState, renderPass: *VkRenderPass_T)
{
	key := VulkanPipelineKey();
	key.meshState = meshState;
	key.renderPass = renderPass;

	return key;
}

assetPassName := "AssetPass";

frameGlobalPool: *VkDescriptorPool_T = null;
frameGlobalSet: *VkDescriptorSet_T = null;

*VkDescriptorSet_T GetFrameGlobalSet(assetDefHandle: AssetDefHandle,
									 context: *RenderPassContext<VulkanRenderer>,
									 renderer: *VulkanRenderer, lightCull: *LightCullState)
{
	if (frameGlobalSet) return frameGlobalSet;

	device := vulkanInstance.device;

	poolSizes := [VkDescriptorPoolSize(), VkDescriptorPoolSize()];
	poolSizes[0].type = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
	poolSizes[0].descriptorCount = 1;
	poolSizes[1].type = VkDescriptorType.VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
	poolSizes[1].descriptorCount = 4;

	poolInfo := VkDescriptorPoolCreateInfo();
	poolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
	poolInfo.poolSizeCount = 2;
	poolInfo.pPoolSizes = fixed poolSizes;
	poolInfo.maxSets = 1;

	CheckResult(
		vkCreateDescriptorPool(device, poolInfo@, null, frameGlobalPool@),
		"AssetPass Error creating frame-global descriptor pool"
	);

	descSets := vulkanInstance.pipelineLayoutCache.descLayoutSetMap.Find(PipelineLayoutKey(assetDefHandle))~;

	allocInfo := VkDescriptorSetAllocateInfo();
	allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
	allocInfo.descriptorPool = frameGlobalPool;
	allocInfo.descriptorSetCount = 1;
	allocInfo.pSetLayouts = descSets[0]@;

	CheckResult(
		vkAllocateDescriptorSets(device, allocInfo@, frameGlobalSet@),
		"AssetPass Error allocating frame-global descriptor set"
	);

	resourceManager := vulkanInstance.resourceManager;
	resourceManager.WriteUBOSet(frameGlobalSet, renderer.sceneShared.buffer);
	resourceManager.WriteStorageSetBuffer(frameGlobalSet, 1, UseRenderPassBuffer<VulkanRenderer, VkBuffer_T>(context, lightCull.lightsHandle));
	resourceManager.WriteStorageSetBuffer(frameGlobalSet, 2, UseRenderPassBuffer<VulkanRenderer, VkBuffer_T>(context, lightCull.lightGridHandle));
	resourceManager.WriteStorageSetBuffer(frameGlobalSet, 3, UseRenderPassBuffer<VulkanRenderer, VkBuffer_T>(context, lightCull.lightIndexHandle));
	resourceManager.WriteStorageSetBuffer(frameGlobalSet, 4, UseRenderPassBuffer<VulkanRenderer, VkBuffer_T>(context, lightCull.clusterInfoHandle));

	return frameGlobalSet;
}

assetPass := RegisterRenderPass(
	assetPassName,
	::(graph: RenderGraph<VulkanRenderer>, scene: *Scene, self: *VulkanRenderPass) 
	{
		graph.AddPass(
			assetPassName,
			::bool(builder: *RenderPassBuilder<VulkanRenderer>, scene: *Scene) 
			{
				renderer := builder.Renderer();
				
				// log "Vulkan Asset pass init";
				builder.Read(renderer.swapchainHandle, ResourceUsageFlags.Sampled | ResourceUsageFlags.LoadUndefined);
				builder.Write(renderer.swapchainHandle, ResourceUsageFlags.DefaultWrite);
				
				depthTexture := TextureDesc();
				depthTexture.format = renderer.swapchain.depthFormat;
				depthTexture.usage = GPUTextureUsage.DepthStencil;
				depthTexture.depth = 1;
				depthTexture.layerCount = 1;
				depthTexture.mipLevels = 1;
				depthTexture.flags = GPUTextureFlags.SizeSwapchainRelative;
				depthTexture.layout = GPUTextureLayout.Undefined;
				
				depthHandle := builder.CreateTexture("depth", depthTexture);
				builder.Read(depthHandle, ResourceUsageFlags.Sampled | ResourceUsageFlags.LoadUndefined);
				builder.Write(depthHandle, ResourceUsageFlags.Depth | ResourceUsageFlags.Store);
				builder.SetDepthStencilColor(depthHandle, DepthStencilClear(1.0, 0));

				lightCullPass := renderer.GetRenderPassByName(lightCullPassName);
				if (lightCullPass)
				{
					lightCull := lightCullPass.data as *LightCullState;
					builder.Read(lightCull.lightGridHandle, ResourceUsageFlags.StorageRead);
					builder.Read(lightCull.lightIndexHandle, ResourceUsageFlags.StorageRead);
					builder.Read(lightCull.lightsHandle, ResourceUsageFlags.StorageRead);
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

				sceneDescSet := renderer.sceneShared.GetDescSet(frame);
								
				commandBuffer := renderer.GetCommandBuffer(CommandBufferKind.Graphics);

				resourceManager := vulkanInstance.resourceManager;
				bindPoint := VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS;

				lightCull: *LightCullState = null;
				lightCullPass := renderer.GetRenderPassByName(lightCullPassName);
				if (lightCullPass) lightCull = lightCullPass.data as *LightCullState;

				offsets := uint64:[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

				for (kv in renderer.drawList.pipelineMap)
				{
					meshState := kv.key~;
					meshArr := kv.value~;
					if (!meshArr.count) continue;

					vulkanPipeline := FindOrCreatePipeline(
						device,
						CreateAssetPassPipelineKey(meshState, renderPass),
						vulkanInstance.pipelineCache,
						vulkanInstance.pipelineLayoutCache
					);
					pipelineLayout := vulkanPipeline.layout;

					vkCmdBindPipeline(commandBuffer, bindPoint, vulkanPipeline.pipeline);
					renderer.SetViewportAndScissor(commandBuffer);

					assetDef := GetAssetDefWithHandle(meshState.assetDefHandle);

					if (lightCull && (assetDef.flags & AssetDefFlags.UseLightCulling))
					{
						set0 := GetFrameGlobalSet(meshState.assetDefHandle, context, renderer, lightCull);
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

					bindlessSet := uint32(1) + assetDef.vertex.variables.sets.count + assetDef.fragment.variables.sets.count;
					vkCmdBindDescriptorSets(
						commandBuffer, bindPoint, pipelineLayout,
						bindlessSet, uint32(1), resourceManager.textures.set@, uint32(0), null
					);

					geomDescriptors := resourceManager.GetGeometryDescriptors(meshState.assetDefHandle);
					matDescriptors := resourceManager.GetMaterialDescriptors(meshState.assetDefHandle);

					for (mesh in meshArr)
					{
						worldTransform := scene.GetComponentDirect<WorldTransform>(mesh.entity, WorldTransformComponent);
						if (!worldTransform) continue;

						geometry := resourceManager.geometries.Get(mesh.geometry);
						material := resourceManager.materials.Get(mesh.material);

						for (i .. geometry.descriptorSets.count)
						{
							vkCmdBindDescriptorSets(
								commandBuffer, bindPoint, pipelineLayout,
								geomDescriptors.setLayouts[i].set, uint32(1),
								geometry.descriptorSets[i]@, uint32(0), null
							);
						}

						for (i .. material.descriptorSets.count)
						{
							vkCmdBindDescriptorSets(
								commandBuffer, bindPoint, pipelineLayout,
								matDescriptors.setLayouts[i].set, uint32(1),
								material.descriptorSets[i]@, uint32(0), null
							);
						}

						attrCount := geometry.attributes.count;
						vkCmdBindVertexBuffers2(
							commandBuffer, uint32(0), attrCount,
							geometry.attributeBuffers[0]@, fixed offsets, null, geometry.strides[0]@
						);

						// Model matrix push constant.
						modelUBO := ModelUBO();
						modelUBO.model = worldTransform.mat;
						vkCmdPushConstants(
							commandBuffer, pipelineLayout,
							uint32(VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT),
							0, #sizeof ModelUBO, modelUBO@
						);

						vkCmdSetCullMode(commandBuffer, material.cullMode);

						if (geometry.indexCount)
						{
							vkCmdBindIndexBuffer(commandBuffer, geometry.indexBuffer, 0, geometry.indexKind);
							vkCmdDrawIndexed(commandBuffer, geometry.indexCount, uint32(1), uint32(0), uint32(0), uint32(0));
						}
					}
				}

			},
			RenderPassStage.Graphics,
			scene
		);
	},
	::(renderer: VulkanRenderer, self: *VulkanRenderPass) 
	{
		log "Color pass added";
	}
);