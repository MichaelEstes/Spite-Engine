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


ShadowMapWidth := uint32(2048);
ShadowMapHeight := uint32(2048);

ShadowOrthoHalfExtent := float32(20.0);
ShadowNear := float32(0.1);
ShadowFar := float32(50.0);
ShadowDistance := float32(25.0);

state ShadowPassState
{
    lightUBO: SharedUBO<SceneUBO>
    shadowMapHandle: RenderResourceHandle
}

shadowPassName := "ShadowPass";
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
				renderer := builder.Renderer();
				shadow := renderer.GetRenderPassByName(shadowPassName).data as *ShadowPassState;

				shadowMapTexture := TextureDesc();
				shadowMapTexture.format = renderer.swapchain.depthFormat;
				shadowMapTexture.usage = GPUTextureUsage.DepthStencil;
				shadowMapTexture.depth = 1;
				shadowMapTexture.layerCount = 1;
				shadowMapTexture.mipLevels = 1;
				shadowMapTexture.width = ShadowMapWidth;
                shadowMapTexture.height = ShadowMapHeight;
				shadowMapTexture.layout = GPUTextureLayout.Undefined;

				shadow.shadowMapHandle = builder.CreateTexture("shadowmap", shadowMapTexture);
				builder.Write(shadow.shadowMapHandle, ResourceUsageFlags.Depth | ResourceUsageFlags.Store);
				builder.SetDepthStencilColor(shadow.shadowMapHandle, DepthStencilClear(1.0, 0));

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
				bindPoint := VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS;

                directionalLight := null as *DirectionalLight;
                for (ec in scene.Iterate<DirectionalLight>())
                {
                    directionalLight = ec.component;
                    break;
                }

                lightDir := directionalLight.direction~;
                lightDir.Normalize();

                up := Vec3(0.0, 1.0, 0.0);
                if (Math.FAbs(lightDir.Dot(up)) > 0.999) up = Vec3(0.0, 0.0, 1.0);

                target := Vec3(0.0, 0.0, 0.0);
                lightPos := target - lightDir * ShadowDistance;
                sceneUBO := SceneUBO();
                sceneUBO.view.LookAt(lightPos, target, up);
                sceneUBO.projection.Orthographic(
                    -ShadowOrthoHalfExtent, ShadowOrthoHalfExtent,
                    -ShadowOrthoHalfExtent, ShadowOrthoHalfExtent,
                    ShadowNear, ShadowFar
                );
                sceneUBO.projection[1][1] *= -1;
                shadow.lightUBO.Update(frame, sceneUBO);
				sceneDescSet := shadow.lightUBO.GetDescSet(frame);

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

					shadowViewport := VkViewport();
					shadowViewport.x = float32(0.0);
					shadowViewport.y = float32(0.0);
					shadowViewport.width = ShadowMapWidth as float32;
					shadowViewport.height = ShadowMapHeight as float32;
					shadowViewport.minDepth = float32(0.0);
					shadowViewport.maxDepth = float32(1.0);
					vkCmdSetViewport(commandBuffer, uint32(0), uint32(1), shadowViewport@);

					shadowScissor := VkRect2D();
					shadowScissor.offset = {int32(0), int32(0)};
					shadowScissor.extent = {ShadowMapWidth, ShadowMapHeight};
					vkCmdSetScissor(commandBuffer, uint32(0), uint32(1), shadowScissor@);

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
        device := vulkanInstance.device;
        allocator := vulkanInstance.allocator;

		self.data = new ShadowPassState();
        shadow := self.data as *ShadowPassState;
        shadow.lightUBO.Init(device, allocator, 0, VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT);
	},
	::(renderer: VulkanRenderer, self: *VulkanRenderPass)
	{
		delete self.data as *ShadowPassState;
	}
);
