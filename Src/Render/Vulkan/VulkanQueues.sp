package VulkanRenderer

state VulkanQueues
{
	queueFamilyProperties: Allocator<VkQueueFamilyProperties>,
	queueFamilyQueueCount: Allocator<uint32>,

	graphicsQueueIndicies: Allocator<uint32>,
	computeQueueIndicies: Allocator<uint32>,
	transferQueueIndicies: Allocator<uint32>,
	createQueueIndicies: Allocator<uint32>,

	graphicsQueue: *VkQueue_T,
	computeQueue: *VkQueue_T,
	transferQueue: *VkQueue_T,
	presentQueue: *VkQueue_T,

	queueFamilyCount: uint32,
	graphicsQueueCount: uint32,
	computeQueueCount: uint32,
	transferQueueCount: uint32,
	createQueueCount: uint32,

	graphicsQueueIndex: uint32,
	presentQueueIndex: uint32,
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
	arr.SizeTo(this.createQueueCount);
	
	for (i .. this.createQueueCount)
	{
		createInfo := VkDeviceQueueCreateInfo();
		createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
		createInfo.queueFamilyIndex = this.createQueueIndicies[i]~;
		createInfo.queueCount = this.queueFamilyQueueCount[createInfo.queueFamilyIndex]~;

		priorities := Allocator<float32>();
		priorities.Alloc(createInfo.queueCount);
		for (i .. createInfo.queueCount)
		{
			priorities[i]~ = float32(1.0);
		}

		createInfo.pQueuePriorities = priorities[0];

		arr.Add(createInfo);
	}

	return arr;
}

VulkanQueues::GetQueues(device: *VkDevice_T, physicalDevice: *VkPhysicalDevice_T, surface: *VkSurfaceKHR_T)
{
	dedicatedQueueIndicies := Array<uint32>();
	defer delete dedicatedQueueIndicies;
	dedicatedQueueIndicies.SizeTo(this.createQueueCount);

	this.graphicsQueueIndex = this.graphicsQueueIndicies[0]~;
	vkGetDeviceQueue(device, this.graphicsQueueIndex, 0, this.graphicsQueue@);
	dedicatedQueueIndicies.Add(this.graphicsQueueIndex);

	for (i .. this.computeQueueCount)
	{
		computeQueueIndex := this.computeQueueIndicies[i]~;
		if (!dedicatedQueueIndicies.Has(computeQueueIndex))
		{
			vkGetDeviceQueue(device, computeQueueIndex, 0, this.computeQueue@);
			dedicatedQueueIndicies.Add(computeQueueIndex);
			log "Found dedicated compute queue";
			break;
		}
	}
	if (!this.computeQueue) vkGetDeviceQueue(device, this.computeQueueIndicies[0]~, 0, this.computeQueue@);

	for (i .. this.transferQueueCount)
	{
		transferQueueIndex := this.transferQueueIndicies[i]~;
		if (!dedicatedQueueIndicies.Has(transferQueueIndex))
		{
			vkGetDeviceQueue(device, transferQueueIndex, 0, this.transferQueue@);
			dedicatedQueueIndicies.Add(transferQueueIndex);
			log "Found dedicated transfer queue";
			break;
		}
	}
	if (!this.transferQueue) vkGetDeviceQueue(device, this.transferQueueIndicies[0]~, 0, this.computeQueue@);

	for (i .. this.queueFamilyCount)
	{
		presentSupported := uint32(0);
		vkGetPhysicalDeviceSurfaceSupportKHR(physicalDevice, i, surface, presentSupported@);
		if (presentSupported)
		{
			if (!dedicatedQueueIndicies.Has(i))
			{
				vkGetDeviceQueue(device, i, 0, this.presentQueue@);
				this.presentQueueIndex = i;
				log "Found dedicated present queue";
				break;
			}
			
			this.presentQueueIndex = i;
		}
	}
	if (!this.presentQueue) 
	{
		log "Using present queue family: ", this.presentQueueIndex;
		vkGetDeviceQueue(device, this.presentQueueIndex, 0, this.presentQueue@);
	}

	log "Got device queues";
}