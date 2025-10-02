package VulkanRenderer

import Array
import HandleSet

enum VulkanMemoryFlags: uint32
{
	GPU = VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT,
	Shared = VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT,
	Coherent = VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_COHERENT_BIT,
	Cached = VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_CACHED_BIT,
	GPULazy = VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_LAZILY_ALLOCATED_BIT,

	// Allocator specific flags
	Mapped = 1 << 16,
}

state VulkanAllocHandle
{
	handle: uint32
}

state VulkanAllocation
{
	data: ?{
		buffer: *VkBuffer_T,
		image: *VkImage_T
	},
	size: uint64
	offset: uint64,
	index: uint64,
	blockIndex: uint16,
	freed: bool
}

state VulkanBlock
{
	memory: *VkDeviceMemory_T,
	mappedPtr: *void,
	size: uint64,
	currentOffset: uint64,
	allocations: Array<VulkanAllocHandle>,
	memoryFlags: uint32
	index: uint16
}

uint64 VulkanBlock::AvailableSize() => this.size - this.currentOffset;

defaultBlockSize: uint64 = 256 * 1024 * 1024;

state VulkanAllocator
{
	device: *VkDevice_T,
	memoryProps: VkPhysicalDeviceMemoryProperties,
	blocks: Array<VulkanBlock>,
	allocationHandles := HandleSet<VulkanAllocation>()
}

*VulkanAllocation VulkanAllocator::GetAllocation(allocHandle: VulkanAllocHandle)
{
	return this.allocationHandles.Get(allocHandle.handle);
}

*VulkanBlock VulkanAllocator::GetAllocationBlock(allocHandle: VulkanAllocHandle)
{
	alloc := this.GetAllocation(allocHandle);
	if (!alloc) return null;

	return this.blocks[alloc.blockIndex]@;
}

VulkanAllocator::Create(device: *VkDevice_T, physicalDevice: *VkPhysicalDevice_T)
{
	this.device = device;
	vkGetPhysicalDeviceMemoryProperties(physicalDevice, this.memoryProps@);
	log "Found device memory properties";
}

VulkanAllocHandle VulkanAllocator::AllocBuffer(buffer: *VkBuffer_T, memoryFlags: uint32)
{
	memoryRequirements := VkMemoryRequirements();
	vkGetBufferMemoryRequirements(this.device, buffer, memoryRequirements@);

	block := this.FindBlock(memoryRequirements.size, memoryFlags);
	if (!block)
	{
		block = this.CreateBlock(memoryFlags, memoryRequirements);
	}

	block.currentOffset = align_up(block.currentOffset, memoryRequirements.alignment);
	alloc := VulkanAllocation();
	alloc.data.buffer = buffer;
	alloc.size = memoryRequirements.size;
	alloc.offset = block.currentOffset;
	alloc.index = block.allocations.count;
	alloc.blockIndex = block.index;

	CheckResult(
		vkBindBufferMemory(this.device, buffer, block.memory, alloc.offset),
		"Error binding buffer memory"
	);

	allocHandleValue := this.allocationHandles.GetNext();
	handle := allocHandleValue.handle as VulkanAllocHandle;
	allocHandleValue.value~ = alloc;

	block.currentOffset += memoryRequirements.size;
	block.allocations.Add(handle);

	return handle;
}

VulkanAllocHandle VulkanAllocator::AllocImage(image: *VkImage_T, memoryFlags: uint32)
{
	memoryRequirements := VkMemoryRequirements();
	vkGetImageMemoryRequirements(this.device, image, memoryRequirements@);

	block := this.FindBlock(memoryRequirements.size, memoryFlags);
	if (!block)
	{
		block = this.CreateBlock(memoryFlags, memoryRequirements);
	}

	block.currentOffset = align_up(block.currentOffset, memoryRequirements.alignment);
	alloc := VulkanAllocation();
	alloc.data.image = image;
	alloc.size = memoryRequirements.size;
	alloc.offset = block.currentOffset;
	alloc.index = block.allocations.count;
	alloc.blockIndex = block.index;

	CheckResult(
		vkBindImageMemory(this.device, image, block.memory, alloc.offset),
		"Error binding image memory"
	);

	allocHandleValue := this.allocationHandles.GetNext();
	handle := allocHandleValue.handle as VulkanAllocHandle;
	allocHandleValue.value~ = alloc;

	block.currentOffset = block.currentOffset + memoryRequirements.size;
	block.allocations.Add(handle);

	return handle;
}

*VulkanBlock VulkanAllocator::FindBlock(size: uint32, memoryFlags: uint32)
{
	for (block in this.blocks)
	{
		if (size <= block.AvailableSize() && (memoryFlags & block.memoryFlags) == block.memoryFlags)
		{
			return block@;
		}
	}

	return null;
}

int32 VulkanAllocator::FindMemoryTypeIndex(memoryFlags: uint16, memoryTypeIndexBits: uint32)
{
	for (i .. this.memoryProps.memoryTypeCount)
	{
		if (memoryTypeIndexBits & (1 << i) && 
			(this.memoryProps.memoryTypes[i].propertyFlags & memoryFlags) == memoryFlags)
		{
			return i;
		}
	}

	return -1;
}

*VulkanBlock VulkanAllocator::CreateBlock(memoryFlags: uint32, memoryRequirements: VkMemoryRequirements, 
										  size: uint64 = defaultBlockSize)
{
	while (size < memoryRequirements.size) size *= 2;

	memoryTypeIndex := this.FindMemoryTypeIndex(memoryFlags as uint16, memoryRequirements.memoryTypeBits);
	assert memoryTypeIndex != -1, "Failed to find memory type";

	allocInfo := VkMemoryAllocateInfo();
	allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
	allocInfo.allocationSize = size;
	allocInfo.memoryTypeIndex = memoryTypeIndex;

	block := VulkanBlock();
	block.size = size;
	block.memoryFlags = memoryFlags;
	block.index = this.blocks.count;

	CheckResult(
		vkAllocateMemory(this.device, allocInfo@, null, block.memory@),
		"Error allocating Vulkan block memory"
	);

	if (memoryFlags & VulkanMemoryFlags.Mapped)
	{
		vkMapMemory(this.device, block.memory, 0, size, 0, block.mappedPtr@);
	}

	index := this.blocks.Add(block);
	return this.blocks[index]@;
}

