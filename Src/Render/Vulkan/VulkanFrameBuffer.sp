package VulkanRenderer

state VulkanFrameBuffer
{
	frameBuffers: Allocator<*VkFramebuffer_T>
}

VulkanFrameBuffer::Initialize(renderer: *VulkanRenderer, renderPass: VulkanRenderPass)
{
	device := renderer.device.device;

	createInfo := VkFramebufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO;

	createInfo.renderPass = renderPass.renderPass;
	createInfo.width = renderer.swapchain.extent.width;
	createInfo.height = renderer.swapchain.extent.height;
	createInfo.layers = 1;

	createInfo.attachmentCount = 1;

	imageCount := renderer.swapchain.imageCount;
	this.frameBuffers.Alloc(imageCount);

	for (i .. imageCount)
	{
		createInfo.pAttachments = renderer.swapchain.imageViews[i];
		CheckResult(
			vkCreateFramebuffer(device, createInfo@, null, this.frameBuffers[i]),
			"Error creating Vulkan frame buffer"
		);
	}
}