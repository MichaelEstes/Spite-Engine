package VulkanRenderPass

import VulkanRenderer
import RenderGraph
import ECS

clearPassName := "ClearPass";

clearPass := RegisterRenderPass(
	clearPassName,
	::(graph: RenderGraph<VulkanRenderer>, scene: *Scene) 
	{
		graph.AddPass(
			clearPassName,
			::bool(builder: *RenderPassBuilder<VulkanRenderer>, param: *void) 
			{
				//log "Vulkan Clear pass init";
				renderer := builder.Renderer();
				builder.Write(
					renderer.swapchainHandle, 
					ResourceUsageFlags.DefaultWrite | ResourceUsageFlags.Clear
				);
				builder.SetClearColor(renderer.swapchainHandle, Color(0.25, 0.117, 0.132, 0.0));

				return true;
			},
			::(context: *RenderPassContext<VulkanRenderer>, param: *void) 
			{
				//log "Vulkan Clear pass exec";
				renderer := context.renderer;
				commandBuffer := renderer.GetCommandBuffer(CommandBufferKind.Graphics);
				image := renderer.GetSwapchainImage();
			},
			RenderPassStage.Graphics,
			null
		);
	}
);