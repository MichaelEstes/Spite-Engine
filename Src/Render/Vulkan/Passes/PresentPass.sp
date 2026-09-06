package VulkanRenderPass

import VulkanRenderer
import RenderGraph
import ECS

presentPassName := "PresentPass";

presentPass := RegisterRenderPass(
	presentPassName,
	::(graph: RenderGraph<VulkanRenderer>, scene: *Scene, self: *VulkanRenderPass)
	{
		graph.AddPass(
			presentPassName,
			::bool(builder: *RenderPassBuilder<VulkanRenderer>, _: *void)
			{
				renderer := builder.Renderer();

                assetState := renderer.GetRenderPassByName(assetPassName).data as *AssetPassState;
				builder.Read(assetState.assetPassResource, ResourceUsageFlags.TransferSrc);

				builder.Read(renderer.swapchainHandle, ResourceUsageFlags.TransferDst);
				builder.Write(renderer.swapchainHandle, ResourceUsageFlags.TransferDst);

				return true;
			},
			::(context: *RenderPassContext<VulkanRenderer>, _: *void)
			{
				renderer := context.renderer;
				commandBuffer := renderer.GetCommandBuffer(CommandBufferKind.Graphics);
                
                assetState := renderer.GetRenderPassByName(assetPassName).data as *AssetPassState;

				assetImage := UseRenderPassTexture<VulkanRenderer, VkImage_T>(
					context, assetState.assetPassResource
				);
				swapchainImage := renderer.GetSwapchainImage();

				width := renderer.swapchain.extent.width as int32;
				height := renderer.swapchain.extent.height as int32;

				blit := VkImageBlit();
				blit.srcSubresource.aspectMask = VkImageAspectFlagBits.VK_IMAGE_ASPECT_COLOR_BIT;
				blit.srcSubresource.mipLevel = 0;
				blit.srcSubresource.baseArrayLayer = 0;
				blit.srcSubresource.layerCount = 1;
				blit.dstSubresource.aspectMask = VkImageAspectFlagBits.VK_IMAGE_ASPECT_COLOR_BIT;
				blit.dstSubresource.mipLevel = 0;
				blit.dstSubresource.baseArrayLayer = 0;
				blit.dstSubresource.layerCount = 1;

				blit.srcOffsets[0].x = 0;
				blit.srcOffsets[0].y = 0;
				blit.srcOffsets[0].z = 0;
				blit.srcOffsets[1].x = width;
				blit.srcOffsets[1].y = height;
				blit.srcOffsets[1].z = 1;

				blit.dstOffsets[0].x = 0;
				blit.dstOffsets[0].y = 0;
				blit.dstOffsets[0].z = 0;
				blit.dstOffsets[1].x = width;
				blit.dstOffsets[1].y = height;
				blit.dstOffsets[1].z = 1;

				vkCmdBlitImage(
					commandBuffer,
					assetImage, VkImageLayout.VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL,
					swapchainImage, VkImageLayout.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL,
					1, blit@,
					VkFilter.VK_FILTER_NEAREST
				);
			},
			RenderPassStage.Graphics,
			null,
			RenderPassFlags.SelfManagedRenderPass
		);
	}
);
