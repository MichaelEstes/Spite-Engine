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

				vkCmdBindIndexBuffer(
					commandBuffer, resourceManager.sharedIndexBuffer.buffer,
					0, VkIndexType.VK_INDEX_TYPE_UINT16
				);

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
					renderer.SetViewportAndScissor(commandBuffer);

					vkCmdBindDescriptorSets(
						commandBuffer, bindPoint, pipelineLayout,
						uint32(0), uint32(1), sceneDescSet@, uint32(0), null
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
