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


offsets := uint64:[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

VulkanPipelineKey CreateAssetPassPipelineKey(meshState: VulkanPipelineMeshState, renderPass: *VkRenderPass_T)
{
	key := VulkanPipelineKey();
	key.meshState = meshState;
	key.renderPass = renderPass;

	return key;
}

assetPassName := "AssetPass";
assetPass := RegisterRenderPass(
	assetPassName,
	::(graph: RenderGraph<VulkanRenderer>, scene: *Scene) 
	{
		graph.AddPass(
			assetPassName,
			::bool(builder: *RenderPassBuilder<VulkanRenderer>, scene: *Scene) 
			{
				renderer := builder.Renderer();
				
				//log "Vulkan Asset pass init";
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

				return true;
			},
			::(context: *RenderPassContext<VulkanRenderer>, scene: *Scene) 
			{
				//log "Vulkan Asset pass";
				renderer := context.renderer;

				device := vulkanInstance.device;
				renderPass := renderer.CastDriverRenderPass(context.driverRenderpass);
				frame := renderer.Frame();

				sceneDescSet := renderer.sceneShared.GetDescSet(frame);
								
				commandBuffer := renderer.GetCommandBuffer(CommandBufferKind.Graphics);

				resourceManager := vulkanInstance.resourceManager;
				bindPoint := VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS;

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

					vkCmdBindDescriptorSets(
						commandBuffer, bindPoint, pipelineLayout,
						uint32(0), uint32(1), sceneDescSet@, uint32(0), null
					);

					assetDef := GetAssetDefWithHandle(meshState.assetDefHandle);
					bindlessSet := uint32(1) + assetDef.vertex.variables.sets.count + assetDef.fragment.variables.sets.count;
					vkCmdBindDescriptorSets(
						commandBuffer, bindPoint, pipelineLayout,
						bindlessSet, uint32(1), resourceManager.textures.set@, uint32(0), null
					);

					geomDescriptors := resourceManager.GetGeometryDescriptors(meshState.assetDefHandle);
					matDescriptors := resourceManager.GetMaterialDescriptors(meshState.assetDefHandle);

					for (drawMesh in meshArr)
					{
						worldTransform := scene.GetComponentDirect<WorldTransform>(drawMesh.entity, WorldTransformComponent);
						if (!worldTransform) continue;

						geometry := resourceManager.geometries.Get(drawMesh.geometry);
						material := resourceManager.materials.Get(drawMesh.material);

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
	::(renderer: VulkanRenderer) 
	{
		log "Color pass added";
	}
);