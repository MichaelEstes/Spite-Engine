package VulkanRenderer

state VulkanFrameBufferCache
{
	frameBufferMap: *VkFramebuffer_T
}

//VulkanFrameBuffer::Create(device: *VkDevice_T, extent: VkExtent2D, renderPass: VulkanRenderPass, 
//						  attachments: []*VkImageView_T)
//{
//	createInfo := VkFramebufferCreateInfo();
//	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO;
//
//	createInfo.renderPass = renderPass.renderPass;
//	createInfo.width = extent.width;
//	createInfo.height = extent.height;
//	createInfo.layers = 1;
//
//	createInfo.attachmentCount = attachments.count;
//	createInfo.pAttachments = attachments[0]@;
//
//	CheckResult(
//		vkCreateFramebuffer(device, createInfo@, null, this.frameBuffer@),
//		"Error creating Vulkan frame buffer"
//	);
//}