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
			::bool(builder: *RenderPassBuilder<VulkanRenderer>, param: *void) 
			{
				//log "Vulkan Color pass init";
				renderer := builder.Renderer();
				builder.Write(renderer.swapchainHandle);

				return true;
			},
			::(context: *RenderPassContext<VulkanRenderer>, param: *void) 
			{
				//log "Vulkan Color pass exec";

			},
			RenderPassStage.Graphics,
			null
		);
	}
);