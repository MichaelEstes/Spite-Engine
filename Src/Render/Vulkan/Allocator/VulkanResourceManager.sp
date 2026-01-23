package VulkanRenderer


state VulkanResourceHandle
{
	handle: uint32
}

state VulkanRenderTarget
{
	image: *VkImage_T,
	imageView: *VkImageView_T,
	handle: VulkanAllocHandle
}

state VulkanResourceManager
{
	renderTargetMap := Map<*VkImage_T, VulkanRenderTarget>();
}