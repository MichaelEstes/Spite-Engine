package VulkanRenderer

state VulkanFrameBuffer
{
	frameBuffer: *VkFramebuffer_T
}

VulkanFrameBuffer::Create(renderer: *VulkanRenderer, renderPass: VulkanRenderPass, attachments: []*VkImageView_T)
{
	device := renderer.device.device;

	createInfo := VkFramebufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO;

	createInfo.renderPass = renderPass.renderPass;
	createInfo.width = renderer.swapchain.extent.width;
	createInfo.height = renderer.swapchain.extent.height;
	createInfo.layers = 1;

	createInfo.attachmentCount = attachments.count;
	createInfo.pAttachments = attachments[0]@;

	CheckResult(
		vkCreateFramebuffer(device, createInfo@, null, this.frameBuffer@),
		"Error creating Vulkan frame buffer"
	);
}