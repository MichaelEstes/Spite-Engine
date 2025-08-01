package VulkanRenderer

state VulkanDepthBuffer
{
	image: VulkanImage,
	memory: *VkDeviceMemory_T
}

VulkanDepthBuffer::Create(renderer: *VulkanRenderer)
{
	this.memory = this.image.CreateDedicated(
		renderer,
		renderer.swapchain.extent.width,
		renderer.swapchain.extent.height,
		renderer.FindDepthFormat(),
		VkImageUsageFlagBits.VK_IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT,
		VulkanMemoryFlags.GPU,
		VkImageAspectFlagBits.VK_IMAGE_ASPECT_DEPTH_BIT
	)

	log "Created depth buffer";
}