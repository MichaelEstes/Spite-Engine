package VulkanRenderer

state VulkanQueues
{
	queueFamilyProperties: Allocator<VkQueueFamilyProperties>,
	queueFamilyQueueCount: Allocator<uint32>,

	graphicsQueueIndicies: Allocator<uint32>,
	computeQueueIndicies: Allocator<uint32>,
	transferQueueIndicies: Allocator<uint32>,

	createQueueIndicies: Allocator<uint32>,

	queueFamilyCount: uint32,
	graphicsQueueCount: uint32,
	computeQueueCount: uint32,
	transferQueueCount: uint32,
	createQueueCount: uint32
}

VulkanQueues::Initialize(physicalDevice: *VkPhysicalDevice_T)
{
	vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, this.queueFamilyCount@, null);

	this.queueFamilyProperties.Alloc(this.queueFamilyCount);
	this.queueFamilyQueueCount.Alloc(this.queueFamilyCount);

	vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, this.queueFamilyCount@, this.queueFamilyProperties[0]);

	for (i .. this.queueFamilyCount)
	{
		queueFamily := this.queueFamilyProperties[i];

		this.queueFamilyQueueCount[i]~ = queueFamily.queueCount;

		hasFlag := false;

		if (queueFamily.queueFlags & VkQueueFlagBits.VK_QUEUE_GRAPHICS_BIT)
		{
			this.graphicsQueueCount += 1;
			hasFlag = true;
		}

		if (queueFamily.queueFlags & VkQueueFlagBits.VK_QUEUE_COMPUTE_BIT)
		{
			this.computeQueueCount += 1;
			hasFlag = true;
		}

		if (queueFamily.queueFlags & VkQueueFlagBits.VK_QUEUE_TRANSFER_BIT)
		{
			this.transferQueueCount += 1;
			hasFlag = true;
		}

		if (hasFlag) this.createQueueCount += 1;
	}

	this.graphicsQueueIndicies.Alloc(this.graphicsQueueCount);
	this.computeQueueIndicies.Alloc(this.computeQueueCount);
	this.transferQueueIndicies.Alloc(this.transferQueueCount);
	this.createQueueIndicies.Alloc(this.createQueueCount);

	graphicsIndex := uint32(0);
	computeIndex := uint32(0);
	transferIndex := uint32(0);
	createIndex := uint32(0);
	for (i .. this.queueFamilyCount)
	{
		queueFamily := this.queueFamilyProperties[i];

		hasFlag := false;

		if (queueFamily.queueFlags & VkQueueFlagBits.VK_QUEUE_GRAPHICS_BIT)
		{
			this.graphicsQueueIndicies[graphicsIndex]~ = i;
			graphicsIndex += 1;
			hasFlag = true;
		}

		if (queueFamily.queueFlags & VkQueueFlagBits.VK_QUEUE_COMPUTE_BIT)
		{
			this.computeQueueIndicies[computeIndex]~ = i;
			computeIndex += 1;
			hasFlag = true;
		}

		if (queueFamily.queueFlags & VkQueueFlagBits.VK_QUEUE_TRANSFER_BIT)
		{
			this.transferQueueIndicies[transferIndex]~ = i;
			transferIndex += 1;
			hasFlag = true;
		}

		if (hasFlag)
		{
			this.createQueueIndicies[createIndex]~ = i;
			createIndex += 1;
		}
	}
}

Array<VkDeviceQueueCreateInfo> VulkanQueues::DeviceQueueCreateInfo()
{
	arr := Array<VkDeviceQueueCreateInfo>();

	for (i .. this.createQueueCount)
	{
		createInfo := VkDeviceQueueCreateInfo();
		createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
		createInfo.queueFamilyIndex = this.createQueueIndicies[i]~;
		createInfo.queueCount = this.queueFamilyQueueCount[createInfo.queueFamilyIndex]~;

		priorities := Allocator<float32>();
		priorities.Alloc(createInfo.queueCount);
	}

	return arr;
}