package VulkanRenderPass

import VulkanRenderer
import RenderGraph
import ECS
import Vec
import Array
import UniformBufferObject
import Transform
import Matrix
import RenderComponents
import RenderAssetDef

state DepthPassState
{
	depthHandle: RenderResourceHandle
}

depthPassName := "DepthPass";
depthPass := RegisterRenderPass(
	depthPassName,
	::(graph: RenderGraph<VulkanRenderer>, scene: *Scene, self: *VulkanRenderPass)
	{
		graph.AddPass(
			depthPassName,
			::bool(builder: *RenderPassBuilder<VulkanRenderer>, scene: *Scene)
			{
				renderer := builder.Renderer();
				depthState := renderer.GetRenderPassByName(depthPassName).data as *DepthPassState;

				depthTexture := TextureDesc();
				depthTexture.format = renderer.swapchain.depthFormat;
				depthTexture.usage = GPUTextureUsage.DepthStencil;
				depthTexture.depth = 1;
				depthTexture.layerCount = 1;
				depthTexture.mipLevels = 1;
				depthTexture.flags = GPUTextureFlags.SizeSwapchainRelative;
				depthTexture.layout = GPUTextureLayout.Undefined;

				depthState.depthHandle = builder.CreateTexture("depth", depthTexture);
				builder.Write(depthState.depthHandle, ResourceUsageFlags.Depth | ResourceUsageFlags.Store);
				builder.SetDepthStencilColor(depthState.depthHandle, DepthStencilClear(1.0, 0));

				return true;
			},
			::(context: *RenderPassContext<VulkanRenderer>, scene: *Scene)
			{
				renderer := context.renderer;

				device := vulkanInstance.device;
				renderPass := renderer.CastDriverRenderPass(context.driverRenderpass);
				frame := renderer.Frame();

				commandBuffer := renderer.GetCommandBuffer(CommandBufferKind.Graphics);
				resourceManager := vulkanInstance.resourceManager;
				bindPoint := VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS;

				sceneDescSet := renderer.sceneShared.GetDescSet(frame);

				offsets := uint64:[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];

				for (kv in renderer.drawList.pipelineMap)
				{
					meshState := kv.key~;
					if (meshState.GetAlphaMode() != VulkanAlphaMode.Opaque) continue;

					meshArr := kv.value~;
					if (!meshArr.count) continue;

					vulkanPipeline := FindOrCreateDepthPipeline(
						device,
						CreatePipelineKey(meshState, renderPass),
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

					geomDescriptors := resourceManager.GetGeometryDescriptors(meshState.assetDefHandle);

					for (mesh in meshArr)
					{
						modelUBO := ModelUBO();
						worldTransform := scene.GetComponentDirect<WorldTransform>(mesh.entity, WorldTransformComponent);
						if (worldTransform)
						{
							modelUBO.model = worldTransform.mat;
						}

						geometry := resourceManager.geometries.Get(mesh.geometryHandle);

						for (i .. geometry.descriptorSets.count)
						{
							vkCmdBindDescriptorSets(
								commandBuffer, bindPoint, pipelineLayout,
								geomDescriptors.setLayouts[i].set, uint32(1),
								geometry.descriptorSets[i]@, uint32(0), null
							);
						}

						attrCount := geometry.attributes.count;
						vkCmdBindVertexBuffers2(
							commandBuffer, uint32(0), attrCount,
							geometry.attributeBuffers[0]@, fixed offsets, null, geometry.strides[0]@
						);

						vkCmdPushConstants(
							commandBuffer, pipelineLayout,
							uint32(VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT),
							0, #sizeof ModelUBO, modelUBO@
						);

						vkCmdSetCullMode(commandBuffer, mesh.cullMode);

						if (geometry.indexCount)
						{
							vkCmdBindIndexBuffer(commandBuffer, geometry.indexBuffer, 0, geometry.indexKind);
							vkCmdDrawIndexed(commandBuffer, geometry.indexCount, uint32(1), uint32(0), uint32(0), uint32(0));
						}
						else
						{
							vkCmdDraw(commandBuffer, geometry.vertexCount, uint32(1), uint32(0), uint32(0));
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
		self.data = new DepthPassState();
	},
	::(renderer: VulkanRenderer, self: *VulkanRenderPass)
	{
		delete self.data as *DepthPassState;
	}
);
