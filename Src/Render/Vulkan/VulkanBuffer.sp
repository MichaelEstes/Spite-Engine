package VulkanRenderer

state VulkanBuffer
{
	buffer: *VkBuffer_T,
	memory: *VkDeviceMemory_T
}

VulkanBuffer::Create(size: uint64, usage: uint32, sharingMode: VkSharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE)
{
	createInfo := VkBufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.size = size;
	createInfo.usage = usage;
	createInfo.sharingMode = sharingMode;


}