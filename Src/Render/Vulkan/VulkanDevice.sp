package VulkanRenderer

state VulkanDevice
{
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

VulkanDevice::Initialize()
{
	this.SelectDefaultDevice();
	physicalDevice := vulkanInstance.physicalDevices[this.physicalDevice]~;

	this.queues.Initialize(physicalDevice);

	createInfo := VkDeviceCreateInfo();

}
