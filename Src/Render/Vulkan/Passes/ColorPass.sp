package VulkanRenderPass

import VulkanRenderer
import RenderGraph
import ECS
import Vec
import SparseSet

vertShaderHandle := ResourceHandle();
fragShaderHandle := ResourceHandle();

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
				//log "Vulkan Color pass exec";

				renderer := context.renderer;

				//pipelineBuilder := VulkanPipelineBuilder()
				//	.SetVertexShader(vertShaderHandle)
				//	.SetFragmentShader(fragShaderHandle)
				//	.SetVertexInput(
				//		VkVertexInputBindingDescription:
				//			[
				//				{uint32(0), uint32(#sizeof Vec3), VkVertexInputRate.VK_VERTEX_INPUT_RATE_VERTEX},
				//				{uint32(1), uint32(#sizeof Vec3), VkVertexInputRate.VK_VERTEX_INPUT_RATE_VERTEX},
				//				{uint32(2), uint32(#sizeof Vec2), VkVertexInputRate.VK_VERTEX_INPUT_RATE_VERTEX}
				//			],
				//		VkVertexInputAttributeDescription:
				//			[
				//				{uint32(0), uint32(0), VkFormat.VK_FORMAT_R32G32B32_SFLOAT, uint32(0)},
				//				{uint32(1), uint32(1), VkFormat.VK_FORMAT_R32G32B32_SFLOAT, uint32(0)},
				//				{uint32(2), uint32(2), VkFormat.VK_FORMAT_R32G32_SFLOAT, uint32(0)}
				//			]
				//	)
				//	.SetInputAssembly(VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST)
				//	.SetViewportState(1, 1)
				//	.SetRasterizer()
				//	.SetMultisampling()
				//	.SetDepthStencil(VkTrue, VkTrue)
				//	.SetColorBlend(
				//		VkPipelineColorBlendAttachmentState:[ColorBlendAttachment(),]
				//	);

				pipelineMeshMap := meshGroupsByScene.Get(scene.id);
				for (kv in pipelineMeshMap)
				{
					pipelineKey := kv.key~;
					meshArr := kv.value~;

					for (mesh in meshArr)
					{

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

		device := renderer.device;

		vertShaderHandle = UseShader(device, "./Resource/Shaders/Compiled/vert.spv", GPUShaderStage.VERTEX);
		fragShaderHandle = UseShader(device, "./Resource/Shaders/Compiled/frag.spv", GPUShaderStage.FRAGMENT);
	}
);