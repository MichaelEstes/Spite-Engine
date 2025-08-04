package VulkanRenderer

*VkBuffer_T CreateVkBuffer(device: *VkDevice_T, createInfo: VkBufferCreateInfo)
{
	buffer: *VkBuffer_T = null;
	CheckResult(
		vkCreateBuffer(device, createInfo@, null, buffer@),
		"Error creating Vulkan buffer"
	);

	return buffer;
}