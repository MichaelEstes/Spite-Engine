package VulkanRenderer

state VulkanBuffer
{
	buffer: *VkBuffer_T
}

VulkanBuffer::Create(renderer: *VulkanRenderer, size: uint64, usage: uint32, memoryFlags: VulkanMemoryFlags,
					 sharingMode: VkSharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE)
{
	createInfo := VkBufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.size = size;
	createInfo.usage = usage;
	createInfo.sharingMode = sharingMode;

	CheckResult(
		vkCreateBuffer(renderer.device.device, createInfo@, null, this.buffer@),
		"Error creating Vulkan buffer"
	);

	renderer.allocator.AllocBuffer(this, memoryFlags);
}