package VulkanRenderPass

import VulkanRenderer
import RenderGraph
import ECS

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

			},
			RenderPassStage.Graphics,
			scene
		);
	},
	::(renderer: VulkanRenderer) 
	{
		log "Color pass added";

		device := renderer.device;

		vertShaderHandle := UseShader(device, "./Resource/Shaders/Compiled/vert.spv", GPUShaderStage.VERTEX);
		fragShaderHandle := UseShader(device, "./Resource/Shaders/Compiled/frag.spv", GPUShaderStage.FRAGMENT);

	}
);