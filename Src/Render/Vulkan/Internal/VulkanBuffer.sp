package VulkanRenderer

import Vec
import Common

state BufferHandle
{
	buffer: *VkBuffer_T,
	handle: VulkanAllocHandle
}

*VkBuffer_T CreateVkBuffer(device: *VkDevice_T, createInfo: VkBufferCreateInfo)
{
	buffer: *VkBuffer_T = null;
	CheckResult(
		vkCreateBuffer(device, createInfo@, null, buffer@),
		"Error creating Vulkan buffer"
	);

	return buffer;
}

VkBufferCreateInfo VertexBufferCreateInfo(size: uint32)
{
	createInfo := VkBufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.usage = VkBufferUsageFlagBits.VK_BUFFER_USAGE_STORAGE_BUFFER_BIT |
					   VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_DST_BIT;
	createInfo.size = size;
	createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

	return createInfo;
}

VkBufferCreateInfo IndexBufferCreateInfo(size: uint32)
{
	createInfo := VkBufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.usage = VkBufferUsageFlagBits.VK_BUFFER_USAGE_INDEX_BUFFER_BIT |
					   VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_DST_BIT;
	createInfo.size = size;
	createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

	return createInfo;
}

VkBufferCreateInfo UniformBufferCreateInfo(size: uint32)
{
	createInfo := VkBufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.usage = VkBufferUsageFlagBits.VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT |
						VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_DST_BIT |
						VkBufferUsageFlagBits.VK_BUFFER_USAGE_SHADER_DEVICE_ADDRESS_BIT;
	createInfo.size = size;
	createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

	return createInfo;
}

uint64 GetBufferDeviceAddress(buffer: *VkBuffer_T)
{
	if (!buffer) return uint64(0);

	info := VkBufferDeviceAddressInfo();
	info.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_DEVICE_ADDRESS_INFO;
	info.buffer = buffer;

	return vkGetBufferDeviceAddress(vulkanInstance.device, info@);
}

VkBufferCreateInfo StorageBufferCreateInfo(size: uint32)
{
	createInfo := VkBufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.usage = VkBufferUsageFlagBits.VK_BUFFER_USAGE_STORAGE_BUFFER_BIT |
					   VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_DST_BIT;
	createInfo.size = size;
	createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

	return createInfo;
}

VkBufferCreateInfo AddressableStorageBufferCreateInfo(size: uint32)
{
	createInfo := VkBufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.usage = VkBufferUsageFlagBits.VK_BUFFER_USAGE_STORAGE_BUFFER_BIT |
					   VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_DST_BIT |
					   VkBufferUsageFlagBits.VK_BUFFER_USAGE_SHADER_DEVICE_ADDRESS_BIT;
	createInfo.size = size;
	createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

	return createInfo;
}

VkBufferCreateInfo IndirectBufferCreateInfo(size: uint32)
{
	createInfo := VkBufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.usage = VkBufferUsageFlagBits.VK_BUFFER_USAGE_INDIRECT_BUFFER_BIT |
						VkBufferUsageFlagBits.VK_BUFFER_USAGE_STORAGE_BUFFER_BIT;
	createInfo.size = size;
	createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

	return createInfo;
}

BufferHandle UploadBuffer(createInfo: VkBufferCreateInfo, data: *byte, size: uint)
{
	device := vulkanInstance.device;
	allocator := vulkanInstance.allocator;
	stagingBuffer := vulkanInstance.GetStagingBuffer();
	queue := vulkanInstance.queues.transferQueue;
	commands := vulkanInstance.transferCommands;

	memoryFlags := VulkanMemoryFlags.GPU;
	if (createInfo.usage & VkBufferUsageFlagBits.VK_BUFFER_USAGE_SHADER_DEVICE_ADDRESS_BIT)
	{
		memoryFlags |= VulkanMemoryFlags.Addressable;
	}

	buffer := CreateVkBuffer(device, createInfo);
	handle := allocator.AllocBuffer(buffer, memoryFlags);
	stagingBuffer.StagedBufferCopy(device, data, size, buffer, commands, queue);

	bufferHandle := BufferHandle();
	bufferHandle.buffer = buffer;
	bufferHandle.handle = handle;
	return bufferHandle;
}

BufferHandle CreateDeviceStorageBuffer(size: uint32)
{
	device := vulkanInstance.device;
	allocator := vulkanInstance.allocator;

	buffer := CreateVkBuffer(device, StorageBufferCreateInfo(size));
	handle := allocator.AllocBuffer(buffer, VulkanMemoryFlags.GPU);

	bufferHandle := BufferHandle();
	bufferHandle.buffer = buffer;
	bufferHandle.handle = handle;
	return bufferHandle;
}

BufferHandle CreateAddressableStorageBuffer(size: uint32)
{
	device := vulkanInstance.device;
	allocator := vulkanInstance.allocator;

	buffer := CreateVkBuffer(device, AddressableStorageBufferCreateInfo(size));
	handle := allocator.AllocBuffer(buffer, VulkanMemoryFlags.GPU | VulkanMemoryFlags.Addressable);

	bufferHandle := BufferHandle();
	bufferHandle.buffer = buffer;
	bufferHandle.handle = handle;
	return bufferHandle;
}

BufferHandle CreateMappedStorageBuffer(size: uint32)
{
	device := vulkanInstance.device;
	allocator := vulkanInstance.allocator;

	buffer := CreateVkBuffer(device, StorageBufferCreateInfo(size));
	handle := allocator.AllocBuffer(
		buffer,
		VulkanMemoryFlags.Shared | VulkanMemoryFlags.Coherent | VulkanMemoryFlags.Mapped
	);

	bufferHandle := BufferHandle();
	bufferHandle.buffer = buffer;
	bufferHandle.handle = handle;
	return bufferHandle;
}

BufferHandle CreateDeviceIndirectBuffer(size: uint32)
{
	device := vulkanInstance.device;
	allocator := vulkanInstance.allocator;

	buffer := CreateVkBuffer(device, IndirectBufferCreateInfo(size));
	handle := allocator.AllocBuffer(buffer, VulkanMemoryFlags.GPU);

	bufferHandle := BufferHandle();
	bufferHandle.buffer = buffer;
	bufferHandle.handle = handle;
	return bufferHandle;
}

BufferHandle CreateMappedIndirectBuffer(size: uint32)
{
	device := vulkanInstance.device;
	allocator := vulkanInstance.allocator;

	buffer := CreateVkBuffer(device, IndirectBufferCreateInfo(size));
	handle := allocator.AllocBuffer(
		buffer,
		VulkanMemoryFlags.Shared | VulkanMemoryFlags.Coherent | VulkanMemoryFlags.Mapped
	);

	bufferHandle := BufferHandle();
	bufferHandle.buffer = buffer;
	bufferHandle.handle = handle;
	return bufferHandle;
}