package VulkanRenderer

import Array

state VulkanAllocation
{
	index: uint32,
	offset: uint32,
	size: uint32
}

state VulkanBlock
{
	size: uint32
}

state VulkanAllocator
{
	memoryProps: VkPhysicalDeviceMemoryProperties,
	blocks: Array<VulkanBlock>
}

VulkanAllocator::Create(renderer: *VulkanRenderer)
{
	vkGetPhysicalDeviceMemoryProperties(renderer.device.GetPhysicalDevice(), this.memoryProps@);
	log "Device memory props: ", this.memoryProps;
}