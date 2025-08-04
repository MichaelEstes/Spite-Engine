package VulkanRenderer


*VkImage_T CreateVkImage(device: *VkDevice_T, createInfo: VkImageCreateInfo)
{
	image: *VkImage_T = null;
	CheckResult(
		vkCreateImage(device, createInfo@, null, image@),
		"Error creating Vulkan image"
	);

	return image;
}

*VkDeviceMemory_T CreateDedicatedVkImage(vulkanDevice: VulkanDevice, createInfo: VkImageCreateInfo, memoryFlags: uint32)
{
	device := vulkanDevice.device;
	image := CreateVkImage(device, createInfo);

	memoryRequirements := VkMemoryRequirements();
	vkGetImageMemoryRequirements(device, image, memoryRequirements@);

	allocInfo := VkMemoryAllocateInfo();
	allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
	allocInfo.allocationSize = memoryRequirements.size;
	allocInfo.memoryTypeIndex = FindMemoryType(
		vulkanDevice.GetPhysicalDevice(),
		memoryRequirements.memoryTypeBits,
		memoryFlags
	);

	memory: *VkDeviceMemory_T = null;

	CheckResult(
		vkAllocateMemory(device, allocInfo@, null, memory@),
		"Error allocating Vulkan image memory"
	);

	CheckResult(
		vkBindImageMemory(device, image, memory, 0),
		"Error binding Vulkan image memory"
	);

	return memory;
}