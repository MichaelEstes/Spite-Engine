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
				
				materialShared := renderer.materialShared;
				materialDescSet := materialShared.GetDescSet(frame);

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

						materialShared.Update(frame, mat.matData);

						vkCmdBindDescriptorSets(
							commandBuffer,
							VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS,
							pipelineLayout,
							uint32(1),
							uint32(3),
							fixed [modelDescSet, materialDescSet, mat.textureDescSet],
							uint32(0),
							null
						);

						geoAttrFlags := geo.GetAttributesFlags();

						vertexAlloc := allocator.GetAllocation(geo.vertexHandle);
						indexAlloc := allocator.GetAllocation(geo.indexHandle);

						vertexBuf := vertexAlloc.data.buffer;

						normalBuf := geo.GetNormalBuffer(renderer);
						tangentsBuf := geo.GetTagentBuffer(renderer);
						colorBuf := geo.GetColorBuffer(renderer);
						uv0Buf := geo.GetUVBuffer(0, renderer);
						uv1Buf := geo.GetUVBuffer(1, renderer);
						uv2Buf := geo.GetUVBuffer(2, renderer);
						uv3Buf := geo.GetUVBuffer(3, renderer);

						vertexBuffers := [
							vertexBuf,
							normalBuf,
							tangentsBuf,
							colorBuf,
							uv0Buf,
							uv1Buf,
							uv2Buf,
							uv3Buf
						];
						offsets:= uint64:[0, 0, 0, 0, 0, 0, 0, 0];

						vkCmdBindVertexBuffers(
							commandBuffer, 
							uint32(0), 
							uint32(8), 
							fixed vertexBuffers, 
							fixed offsets
						);
						
						if (indexAlloc)
						{
							indexBuf := indexAlloc.data.buffer;
							vkCmdBindIndexBuffer(
								commandBuffer,
								indexBuf,
								0,
								geo.indexKind
							);

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