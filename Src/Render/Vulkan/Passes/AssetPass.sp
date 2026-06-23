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


VulkanPipelineKey CreateColorPassPipelineKey(meshState: VulkanPipelineMeshState, renderPass: *VkRenderPass_T)
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
				allocator := vulkanInstance.allocator;
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
						CreateColorPassPipelineKey(meshState, renderPass),
						vulkanInstance.pipelineCache,
						vulkanInstance.pipelineLayoutCache
					);
					pipelineLayout := vulkanPipeline.layout;

					vkCmdBindPipeline(commandBuffer, bindPoint, vulkanPipeline.pipeline);
					renderer.SetViewportAndScissor(commandBuffer);

					// Scene UBO at set 0.
					vkCmdBindDescriptorSets(
						commandBuffer, bindPoint, pipelineLayout,
						uint32(0), uint32(1), sceneDescSet@, uint32(0), null
					);

					// Bindless sampler/texture arrays at set 1 + V + F.
					assetDef := GetAssetDefWithHandle(meshState.assetDefHandle);
					bindlessSet := uint32(1) + assetDef.vertex.variables.sets.count +
								   assetDef.fragment.variables.sets.count;
					vkCmdBindDescriptorSets(
						commandBuffer, bindPoint, pipelineLayout,
						bindlessSet, uint32(1), resourceManager.textures.set@, uint32(0), null
					);

					// Set indices for the geometry/material descriptor sets (cached).
					geomDescriptors := resourceManager.GetGeometryDescriptors(meshState.assetDefHandle);
					matDescriptors := resourceManager.GetMaterialDescriptors(meshState.assetDefHandle);

					for (drawMesh in meshArr)
					{
						worldTransform := scene.GetComponentDirect<WorldTransform>(drawMesh.entity, WorldTransformComponent);
						if (!worldTransform) continue;

						geometry := resourceManager.geometries.Get(drawMesh.geometry);
						material := resourceManager.materials.Get(drawMesh.material);

						// Geometry vertex variable sets (1..V).
						for (i .. geometry.descriptorSets.count)
						{
							vkCmdBindDescriptorSets(
								commandBuffer, bindPoint, pipelineLayout,
								geomDescriptors.setLayouts[i].set, uint32(1),
								geometry.descriptorSets[i]@, uint32(0), null
							);
						}

						// Material fragment variable + texture-index sets.
						for (i .. material.descriptorSets.count)
						{
							vkCmdBindDescriptorSets(
								commandBuffer, bindPoint, pipelineLayout,
								matDescriptors.setLayouts[i].set, uint32(1),
								material.descriptorSets[i]@, uint32(0), null
							);
						}

						// One vertex buffer per geometry attribute, bound at bindings 0..N-1.
						// Defaulted attributes carry stride 0 so their single element feeds
						// every vertex (VK_DYNAMIC_STATE_VERTEX_INPUT_BINDING_STRIDE).
						attrCount := geometry.attributes.count;
						vertexBuffers := ECS.instance.frameAllocator.AllocArray<*VkBuffer_T>(attrCount);
						offsets := ECS.instance.frameAllocator.AllocArray<uint64>(attrCount);
						strides := ECS.instance.frameAllocator.AllocArray<uint64>(attrCount);
						for (i .. attrCount)
						{
							vertexBuffers[i] = allocator.GetAllocation(geometry.attributes[i]).data.buffer;
							offsets[i] = 0;
							strides[i] = geometry.strides[i] as uint64;
						}
						vkCmdBindVertexBuffers2(
							commandBuffer, uint32(0), attrCount,
							vertexBuffers[0]@, offsets[0]@, null, strides[0]@
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
							indexBuffer := allocator.GetAllocation(geometry.indexHandle).data.buffer;
							vkCmdBindIndexBuffer(commandBuffer, indexBuffer, 0, geometry.indexKind);
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