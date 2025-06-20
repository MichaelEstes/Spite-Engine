package VulkanRenderer

import Array

enum VulkanMemoryType: uint32
{
	GPU,
	Shared,
	Coherent
}

state VulkanAllocation
{
	size: uint64
	offset: uint64,
	index: uint64,
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

uint64 VulkanBlock::AvailableSize() => this.size - this.currentOffset;

defaultBlockSize: uint64 = 256 * 1024 * 1024;

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
		block := this.CreateBlock(propertyFlags, memoryRequirements);
	}

	alloc := VulkanAllocation();
	alloc.size = memoryRequirements.size;
	alloc.offset = block.currentOffset;
	alloc.index = block.allocations.count;
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

int32 VulkanAllocator::FindMemoryTypeIndex(propertyFlags: uint32, memoryTypeBits: uint32)
{
	for (i .. this.memoryProps.memoryTypeCount)
	{
		if (memoryTypeBits & (1 << i) && 
			(this.memoryProps.memoryTypes[i].propertyFlags & propertyFlags) == propertyFlags)
		{
			return i;
		}
	}

	return -1;
}

*VulkanBlock VulkanAllocator::CreateBlock(propertyFlags: uint32, memoryRequirements: VkMemoryRequirements, 
										  size: uint64 = defaultBlockSize)
{
	while (size < memoryRequirements.size) size *= 2;

	memoryTypeIndex := this.FindMemoryTypeIndex(propertyFlags, memoryRequirements.memoryTypeBits);
	assert memoryTypeIndex != -1, "Failed to find memory type";

	allocInfo := VkMemoryAllocateInfo();
	allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
	allocInfo.allocationSize = size;
	allocInfo.memoryTypeIndex = memoryTypeIndex;

	block := VulkanBlock();
	block.size = size;
	block.propertyFlags = propertyFlags;
	block.index = this.blocks.count;

	CheckResult(
		vkAllocateMemory(this.device, allocInfo@, null, block.memory@),
		"Error allocating Vulkan block memory"
	);

	index := this.blocks.Add(block);
	return this.blocks[index]@;
}

