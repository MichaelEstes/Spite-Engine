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


VulkanPipelineKey CreateColorPassPipelineKey(meshState: VulkanPipelineMeshState, renderPass: *VkRenderPass_T)
{
	key := VulkanPipelineKey();
	key.meshState = meshState;
	key.renderPass = renderPass;

	return key;
}

colorPassName := "ColorPass";
colorPass := RegisterRenderPass(
	colorPassName,
	::(graph: RenderGraph<VulkanRenderer>, scene: *Scene) 
	{
		graph.AddPass(
			colorPassName,
			::bool(builder: *RenderPassBuilder<VulkanRenderer>, scene: *Scene) 
			{
				//log "Vulkan Color pass init";
				renderer := builder.Renderer();
				builder.Read(renderer.swapchainHandle);
				builder.Write(renderer.swapchainHandle);

				return true;
			},
			::(context: *RenderPassContext<VulkanRenderer>, scene: *Scene) 
			{
				if (!scene.HasSingleton<Camera>()) return;
				camera := scene.GetSingleton<Camera>();
				cameraViewMatrix := camera.GetViewMatrix();

				renderer := context.renderer;
				device := renderer.device;

				renderPass := renderer.CastDriverRenderPass(context.driverRenderpass);
				allocator := renderer.allocator;
				frame := renderer.Frame();
				sceneDescSet := renderer.sceneShared.GetDescSet(frame);
				modelShared := renderer.modelShared;
				modelDescSet := modelShared.GetDescSet(frame);

				commandBuffer := renderer.GetCommandBuffer(CommandBufferKind.Graphics);

				pipelineMeshMap := meshGroupsByScene.Get(scene.id);
				for (kv in pipelineMeshMap)
				{
					pipelineMeshState := kv.key~;
					meshArr := kv.value~;

					pipelineKey := CreateColorPassPipelineKey(pipelineMeshState, renderPass);
					vulkanPipeline := FindOrCreatePipeline(
						device,
						pipelineKey, 
						renderer.pipelineCache~
						renderer.pipelineLayoutCache~
					);
					pipeline := vulkanPipeline.pipeline;
					pipelineLayout := vulkanPipeline.layout;

					vkCmdBindPipeline(
						commandBuffer,
						VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS,
						pipeline
					);
					renderer.SetViewportAndScissor(commandBuffer);

					vkCmdBindDescriptorSets(
						commandBuffer, 
						VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS, 
						pipelineLayout, 
						uint32(0), 
						uint32(1), 
						sceneDescSet@, 
						uint32(0), 
						null
					);

					for (mesh in meshArr)
					{
						entity := mesh.entity;
						geo := mesh.geometry;
						mat := mesh.material;

						worldTransform := scene.GetComponentDirect<WorldTransform>(entity, WorldTransformComponent);
						if (!worldTransform) continue;
				
						modelUBO := ModelUBO();
						modelUBO.model = worldTransform.mat;
						modelShared.Update(frame, modelUBO);

						vkCmdBindDescriptorSets(
							commandBuffer,
							VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS,
							pipelineLayout,
							uint32(1),
							uint32(2),
							fixed [modelDescSet, mat.textureDescSet],
							uint32(0),
							null
						);

						vertexAlloc := allocator.GetAllocation(geo.vertexHandle);
						indexAlloc := allocator.GetAllocation(geo.indexHandle);

						vertexBuffers := [vertexAlloc.data.buffer,];
						offsets:= [uint64(0),];
						vkCmdBindVertexBuffers(
							commandBuffer, 
							uint32(0), 
							uint32(1), 
							fixed vertexBuffers, 
							fixed offsets
						);
						
						if (indexAlloc)
						{
							vkCmdBindIndexBuffer(
								commandBuffer, 
								indexAlloc.data.buffer, 
								0, 
								geo.indexKind
							);
						}
						
						if (indexAlloc)
						{
							vkCmdDrawIndexed(commandBuffer, geo.indexCount, uint32(1), uint32(0), uint32(0), uint32(0));
						}
						else
						{
						
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