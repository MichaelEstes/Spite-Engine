package VulkanRenderer

state VulkanAllocator
{
	memoryProps: VkPhysicalDeviceMemoryProperties
}

VulkanAllocator::Create(renderer: *VulkanRenderer)
{
	vkGetPhysicalDeviceMemoryProperties(renderer.device.GetPhysicalDevice(), this.memoryProps@);
	log "Device memory props: ", this.memoryProps;
}