package VulkanRenderer

import Array

state VulkanAllocation
{
	size: uint64
	index: uint64,
	offset: uint64,
	blockIndex: uint16,
	freed: bool
}

state VulkanBlock
{
	memory: *VkDeviceMemory_T,
	size: uint64,
	currentOffset: uint64,
	allocations: Array<VulkanAllocation>,
	index: uint16
}

state VulkanAllocator
{
	device: *VkDevice_T,
	memoryProps: VkPhysicalDeviceMemoryProperties,
	blocks: Array<VulkanBlock>
}

VulkanAllocator::Create(renderer: *VulkanRenderer)
{
	this.device = renderer.device.device;
	vkGetPhysicalDeviceMemoryProperties(renderer.device.GetPhysicalDevice(), this.memoryProps@);
	log "Device memory props: ", this.memoryProps;
}

VulkanAllocator::AllocBuffer(buffer: VulkanBuffer)
{
	memoryRequirements := VkMemoryRequirements();
	vkGetBufferMemoryRequirements(this.device, buffer.buffer, memoryRequirements@);

	
}

VulkanAllocator::CreateBlock(size: uint32)
{

}

