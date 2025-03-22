package VulkanRenderer

import Vulkan
import SDL

appInfo := {
	VkStructureType.VK_STRUCTURE_TYPE_APPLICATION_INFO,
	null,
	"Spite Engine"[0],
	uint32(0),
	"Spite Engine"[0],
	uint32(0),
	uint32(0),
} as VkApplicationInfo;

state VulkanRenderer
{
	vkInstance :*VkInstance_T,
	vkDevice: *VkDevice_T,
	vkSurface: *VkSurfaceKHR_T,
	
	extensionNames: **byte,

	physicalDevices: Allocator<*VkPhysicalDevice_T>,
	currentPhysicalDevice: *VkPhysicalDevice_T,
	currentDeviceFeatures: VkPhysicalDeviceFeatures,
	currentDeviceProperties: VkPhysicalDeviceProperties,

	queueFamilies: Allocator<VkQueueFamilyProperties>,
	graphicsQueueIndices: Allocator<uint32>,
	presentationQueueIndices: Allocator<uint32>,

	deviceQueues: Allocator<*VkQueue_T>,

	extensionCount: uint32,
	physicalDeviceCount: uint32,
	queueFamilyCount: uint32,
	graphicsQueueCount: uint32,
	presentationQueueCount: uint32,
}

vulkanRenderer := VulkanRenderer();

InitializeVulkanRenderer(window: *SDL.Window)
{
	vulkanRenderer.extensionNames = SDL.VulkanGetInstanceExtensions(vulkanRenderer.extensionCount@);
    instanceCreateInfo := {
        VkStructureType.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO, 
        null,													
        uint32(0),												
        appInfo@,													
        uint32(0),												
        null,												
        vulkanRenderer.extensionCount,											
        vulkanRenderer.extensionNames,											
    } as VkInstanceCreateInfo;

    createResult := vkCreateInstance(instanceCreateInfo@, null, vulkanRenderer.vkInstance@);
	assert createResult == VkResult.VK_SUCCESS, "Error creating Vulkan instance";

	InitializeSurface(window);
    InitializeCurrentDevice();
	InitializeQueues();
	BuildQueueFamilyIndices();
	InitializeLogicalDevice();

	log "Device name: ", string(256, fixed vulkanRenderer.currentDeviceProperties.deviceName);
}

InitializeSurface(window: *SDL.Window)
{
	surfaceResult := SDL.VulkanCreateSurface(
		window, 
		vulkanRenderer.vkInstance, 
		null, 
		vulkanRenderer.vkSurface@
	);
	assert surfaceResult, "Error creating Vulkan surface";
}

InitializeCurrentDevice()
{
	vkEnumeratePhysicalDevices(vulkanRenderer.vkInstance, vulkanRenderer.physicalDeviceCount@, null);
	vulkanRenderer.physicalDevices.Alloc(vulkanRenderer.physicalDeviceCount);
    deviceResult := vkEnumeratePhysicalDevices(
		vulkanRenderer.vkInstance, 
		vulkanRenderer.physicalDeviceCount@, 
		vulkanRenderer.physicalDevices[0]
	);
    assert deviceResult == VkResult.VK_SUCCESS, "Error finding device for Vulkan";

	vulkanRenderer.currentPhysicalDevice = vulkanRenderer.physicalDevices[0]~;
	vkGetPhysicalDeviceFeatures(vulkanRenderer.currentPhysicalDevice, vulkanRenderer.currentDeviceFeatures@);
	vkGetPhysicalDeviceProperties(vulkanRenderer.currentPhysicalDevice, vulkanRenderer.currentDeviceProperties@);
}

InitializeQueues()
{
	vkGetPhysicalDeviceQueueFamilyProperties(
		vulkanRenderer.currentPhysicalDevice, 
		vulkanRenderer.queueFamilyCount@, 
		null
	);
	vulkanRenderer.queueFamilies.Alloc(vulkanRenderer.queueFamilyCount);
    vkGetPhysicalDeviceQueueFamilyProperties(
		vulkanRenderer.currentPhysicalDevice, 
		vulkanRenderer.queueFamilyCount@, 
		vulkanRenderer.queueFamilies[0]
	);
}

BuildQueueFamilyIndices()
{
	for (i .. vulkanRenderer.queueFamilyCount)
	{
		queueFamily := vulkanRenderer.queueFamilies[i];
		if (queueFamily.queueFlags & VkQueueFlagBits.VK_QUEUE_GRAPHICS_BIT) 
		{
			vulkanRenderer.graphicsQueueCount += 1;
		}

		presentationSupport := uint32(0);
		vkGetPhysicalDeviceSurfaceSupportKHR(
			vulkanRenderer.currentPhysicalDevice, 
			i, 
			vulkanRenderer.vkSurface, 
			presentationSupport@
		);
		if (presentationSupport)
		{
			vulkanRenderer.presentationQueueCount += 1;
		}

    }

	vulkanRenderer.graphicsQueueIndices.Alloc(vulkanRenderer.graphicsQueueCount);
	vulkanRenderer.presentationQueueIndices.Alloc(vulkanRenderer.presentationQueueCount)
	graphicsIndex := 0;
	presentationIndex := 0;
	for (i .. vulkanRenderer.queueFamilyCount)
	{
		queueFamily := vulkanRenderer.queueFamilies[i];
		if (queueFamily.queueFlags & VkQueueFlagBits.VK_QUEUE_GRAPHICS_BIT) 
		{
			vulkanRenderer.graphicsQueueIndices[graphicsIndex]~ = i;
			graphicsIndex += 1;
		}

		presentationSupport := uint32(0);
		vkGetPhysicalDeviceSurfaceSupportKHR(
			vulkanRenderer.currentPhysicalDevice, 
			i, 
			vulkanRenderer.vkSurface, 
			presentationSupport@
		);
		if (presentationSupport)
		{
			vulkanRenderer.presentationQueueIndices[presentationIndex]~ = i;
			presentationIndex += 1;
		}
    }
}

{queues: Allocator<uint32>, count: uint32} GetUniquePresentationQueues()
{
	queues := Allocator<uint32>();
	queues.Alloc(vulkanRenderer.graphicsQueueCount + vulkanRenderer.presentationQueueCount);

	count := uint32(0);
	for (i .. vulkanRenderer.presentationQueueCount)
	{
		queues[i]~ = vulkanRenderer.presentationQueueIndices[i]~;
		count += 1;
	}

	for (i .. vulkanRenderer.graphicsQueueCount)
	{
		queue := vulkanRenderer.graphicsQueueIndices[i]~;
		unique := true;
		for (j .. count)
		{
			if (queue == queues[j]~)
			{
				unique = false;
				break;
			}
		}

		if (unique)
		{
			queues[count]~ = queue;
			count += 1;
		}
	}

	return {queues, count};
}

InitializeLogicalDevice()
{
	queuePriority := float32(1.0);

	uniqueQueues := GetUniquePresentationQueues();
	defer uniqueQueues.queues.Dealloc(uniqueQueues.count);

	queueCreateInfos := Allocator<VkDeviceQueueCreateInfo>();
	queueCreateInfos.Alloc(uniqueQueues.count);
	defer queueCreateInfos.Dealloc(uniqueQueues.count);

	for (i .. uniqueQueues.count)
	{
		queueFamilyIndex := uniqueQueues.queues[i]~;
		queueCreateInfo := VkDeviceQueueCreateInfo();
		queueCreateInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
		queueCreateInfo.queueFamilyIndex = queueFamilyIndex;
		queueCreateInfo.queueCount = 1;
		queueCreateInfo.pQueuePriorities = queuePriority@;
		queueCreateInfos[i]~ = queueCreateInfo;
	}

	deviceCreateInfo := VkDeviceCreateInfo();
	deviceCreateInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
	deviceCreateInfo.queueCreateInfoCount = uniqueQueues.count;
	deviceCreateInfo.pQueueCreateInfos = queueCreateInfos[0];
	deviceCreateInfo.pEnabledFeatures = vulkanRenderer.currentDeviceFeatures@;

	createDeviceResult := vkCreateDevice(
		vulkanRenderer.currentPhysicalDevice, 
		deviceCreateInfo@, 
		null, 
		vulkanRenderer.vkDevice@
	);
	assert createDeviceResult == VkResult.VK_SUCCESS, "Error creating a logical Vulkan device";

	vulkanRenderer.deviceQueues.Alloc(uniqueQueues.count);
	for (i .. uniqueQueues.count)
	{
		vkGetDeviceQueue(
			vulkanRenderer.vkDevice,
			uniqueQueues.queues[i]~,
			0,
			vulkanRenderer.deviceQueues[i]
		);
	}
}

InitializePresentationQueue()
{

}


DestroyVulkanRenderer()
{
	vkDestroyDevice(vulkanRenderer.vkDevice, null);
}