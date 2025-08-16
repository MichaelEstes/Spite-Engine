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
				builder.Write(renderer.swapchainHandle);

				return true;
			},
			::(context: *RenderPassContext<VulkanRenderer>, param: *void) 
			{
				log "Vulkan Clear pass exec";
				renderer := context.renderer;
				commandBuffer := renderer.GetCommandBuffer(CommandBufferKind.Graphics);
				image := renderer.GetSwapchainImage();

				clearColor := float32:[0.25, 0.117, 0.132, 0.0];

				imageRange := VkImageSubresourceRange();
				imageRange.aspectMask = VkImageAspectFlagBits.VK_IMAGE_ASPECT_COLOR_BIT;
				imageRange.levelCount = 1;
				imageRange.layerCount = 1;

				vkCmdClearColorImage(
					commandBuffer, 
					image, 
					VkImageLayout.VK_IMAGE_LAYOUT_GENERAL, 
					clearColor@,
					1, 
					imageRange@
				);
			},
			RenderPassStage.Graphics,
			null
		);
	}
);