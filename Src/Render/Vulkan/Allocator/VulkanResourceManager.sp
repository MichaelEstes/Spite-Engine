package VulkanRenderer


state VulkanRenderTarget
{
	image: *VkImage_T,
	imageView: *VkImageView_T
}

state VulkanResourceManager
{
	renderTargetMap := Map<*VkImage_T, VulkanRenderTarget>();
}