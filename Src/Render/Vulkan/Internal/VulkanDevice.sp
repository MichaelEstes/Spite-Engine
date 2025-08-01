package VulkanRenderer

state VulkanDevice
{
	deviceFeatures: VkPhysicalDeviceFeatures,
	device: *VkDevice_T,
	queues: VulkanQueues,
	physicalDevice: uint32
}

VulkanDevice::DebugLogExtensions()
{
	physicalDevice := vulkanInstance.physicalDevices[this.physicalDevice]~;
	extCount := uint32(0);
	vkEnumerateDeviceExtensionProperties(physicalDevice, null, extCount@, null);
	log "Device ext count: ", extCount;
	extProps := Allocator<VkExtensionProperties>();
	extProps.Alloc(extCount);
	vkEnumerateDeviceExtensionProperties(physicalDevice, null, extCount@, extProps[0]);
	for (i .. extCount)
	{
		puts(fixed extProps[i].extensionName);
	}
	log "End device ext";

	instExtCount := uint32(0);
	vkEnumerateInstanceExtensionProperties(null, instExtCount@, null);
	log "Instance ext count: ", extCount;
	instExtProps := Allocator<VkExtensionProperties>();
	instExtProps.Alloc(extCount);
	vkEnumerateInstanceExtensionProperties(null, instExtCount@, instExtProps[0]);
	for (i .. instExtCount)
	{
		puts(fixed instExtProps[i].extensionName);
	}
	log "End instance ext";
}

VulkanDevice::SelectDefaultDevice()
{
	if (vulkanInstance.physicalDeviceCount == 1)
	{
		log "Only one physical device found, using it";
		this.physicalDevice = 0;
		return;
	}

	log "Selecting default device";

	backupDevice := -1;

	for (i .. vulkanInstance.physicalDeviceCount)
	{
		physicalDevice := vulkanInstance.physicalDevices[i]~;
		deviceFeatures := VkPhysicalDeviceFeatures()
		deviceProperties := VkPhysicalDeviceProperties();
		vkGetPhysicalDeviceFeatures(physicalDevice, deviceFeatures@);
		vkGetPhysicalDeviceProperties(physicalDevice, deviceProperties@);

		log "Evaluating Device: ", string(256, fixed deviceProperties.deviceName);
		if (deviceProperties.deviceType == VkPhysicalDeviceType.VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU)
		{
			log "Found discrete GPU, using it";
			this.physicalDevice = i;
			return;
		}
		else if (deviceProperties.deviceType == VkPhysicalDeviceType.VK_PHYSICAL_DEVICE_TYPE_INTEGRATED_GPU)
		{
			log "Found integrated GPU, set as backup";
			backupDevice = i;
		}
	}

	if (backupDevice != -1)
	{
		log "No discrete GPU found, using integrated GPU";
		this.physicalDevice = backupDevice;
		return;
	}

	log "No backup device found, using first device";
	this.physicalDevice = 0;
}

VulkanDevice::Create(surface: *VkSurfaceKHR_T)
{
	this.SelectDefaultDevice();
	physicalDevice := vulkanInstance.physicalDevices[this.physicalDevice]~;

	this.queues.Create(physicalDevice);

	queueCreateInfos := this.queues.DeviceQueueCreateInfo();
	defer delete queueCreateInfos;

	createInfo := VkDeviceCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
	createInfo.queueCreateInfoCount = queueCreateInfos.count;
	createInfo.pQueueCreateInfos = queueCreateInfos[0]@;
	createInfo.enabledExtensionCount = requiredDeviceExtensionCount;
	createInfo.ppEnabledExtensionNames = requiredDeviceExtensions[0]@;
	createInfo.pEnabledFeatures = this.deviceFeatures@;

	CheckResult(
		vkCreateDevice(physicalDevice, createInfo@, null, this.device@),
		"Error creating Vulkan device"
	);

	this.queues.GetQueues(this.device, physicalDevice, surface);

	log "Initialized Vulkan device";
}

*VkPhysicalDevice_T VulkanDevice::GetPhysicalDevice() => vulkanInstance.physicalDevices[this.physicalDevice]~;
