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
	propertyFlags: uint32
	index: uint16
}

VulkanBlock::AvailableSize() => this.size - this.currentOffset;

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

VulkanAllocator::AllocBuffer(buffer: VulkanBuffer, propertyFlags: uint32)
{
	memoryRequirements := VkMemoryRequirements();
	vkGetBufferMemoryRequirements(this.device, buffer.buffer, memoryRequirements@);

	block := this.FindBlock(memoryRequirements.size, propertyFlags);
	if (!block)
	{
		block := this.CreateBlock(memoryRequirements.size, propertyFlags);
	}

	alloc := VulkanAllocation();
	alloc.size = memoryRequirements.size;
	alloc.offset = block.currentOffset;
	alloc.blockIndex = block.index;
	block.currentOffset += memoryRequirements.size;
	block.allocations.Add(alloc);

	CheckResult(
		vkBindBufferMemory(this.device, buffer.buffer, block.memory, alloc.offset),
		"Error binding buffer memory"
	);
}

*VulkanBlock VulkanAllocator::FindBlock(size: uint32, propertyFlags: uint32)
{
	for (block in this.blocks)
	{
		if (size <= block.AvailableSize() && (propertyFlags & block.propertyFlags) == block.propertyFlags)
		{
			return block@;
		}
	}

	return null;
}

*VulkanBlock VulkanAllocator::CreateBlock(size: uint32)
{
	return null;
}

