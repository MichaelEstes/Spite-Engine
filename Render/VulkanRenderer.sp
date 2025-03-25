package VulkanRenderer

import Math
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

requiredDeviceExtensions := ["VK_KHR_swapchain"[0],];
requiredDeviceExtensionCount := #compile uint32 => (#typeof requiredDeviceExtensions).FixedArrayCount();

state VulkanRenderer
{
	window: *SDL.Window,
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

	graphicsQueues: Allocator<*VkQueue_T>,
	presentationQueues: Allocator<*VkQueue_T>,

	surfaceCapabilities: VkSurfaceCapabilitiesKHR,
	surfaceFormats: Allocator<VkSurfaceFormatKHR>,
	presentModes: Allocator<VkPresentModeKHR>,

	extensionCount: uint32,
	physicalDeviceCount: uint32,
	queueFamilyCount: uint32,
	graphicsQueueCount: uint32,
	presentationQueueCount: uint32,
	surfaceFormatCount: uint32,
	presentModeCount: uint32,
}

vulkanRenderer := VulkanRenderer();

DebugLogExtensions()
{
	extCount := uint32(0);
	vkEnumerateDeviceExtensionProperties(vulkanRenderer.currentPhysicalDevice, null, extCount@, null);
	log "Device ext count: ", extCount;
	extProps := Allocator<VkExtensionProperties>();
	extProps.Alloc(extCount);
	vkEnumerateDeviceExtensionProperties(vulkanRenderer.currentPhysicalDevice, null, extCount@, extProps[0]);
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

InitializeVulkanRenderer(window: *SDL.Window)
{
	vulkanRenderer.window = window;
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

	InitializeSurface();
    InitializeCurrentDevice();

	//DebugLogExtensions();

	InitializeQueues();
	BuildQueueFamilyIndices();
	InitializeLogicalDevice();
	InitializeSwapchain();

	log "Device name: ", string(256, fixed vulkanRenderer.currentDeviceProperties.deviceName);
}

InitializeSurface()
{
	surfaceResult := SDL.VulkanCreateSurface(
		vulkanRenderer.window, 
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

{queues: Allocator<uint32>, count: uint32} GetUniqueQueues()
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

	uniqueQueues := GetUniqueQueues();
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
	deviceCreateInfo.enabledExtensionCount = requiredDeviceExtensionCount;
	deviceCreateInfo.ppEnabledExtensionNames = fixed requiredDeviceExtensions;
	deviceCreateInfo.pEnabledFeatures = vulkanRenderer.currentDeviceFeatures@;

	createDeviceResult := vkCreateDevice(
		vulkanRenderer.currentPhysicalDevice, 
		deviceCreateInfo@, 
		null, 
		vulkanRenderer.vkDevice@
	);
	assert createDeviceResult == VkResult.VK_SUCCESS, "Error creating a logical Vulkan device";

	GetDeviceQueues(
		vulkanRenderer.graphicsQueueCount,
		vulkanRenderer.graphicsQueueIndices,
		vulkanRenderer.graphicsQueues@
	)

	GetDeviceQueues(
		vulkanRenderer.presentationQueueCount,
		vulkanRenderer.presentationQueueIndices,
		vulkanRenderer.presentationQueues@
	)
}

GetDeviceQueues(count: uint32, indices: Allocator<uint32>, queues: *Allocator<*VkQueue_T>)
{
	queues.Alloc(count);
	for (i .. count)
	{
		vkGetDeviceQueue(
			vulkanRenderer.vkDevice,
			indices[i]~,
			0,
			queues~[i]
		);
	}
}

InitializeSwapchain()
{
	result := vkGetPhysicalDeviceSurfaceCapabilitiesKHR(
		vulkanRenderer.currentPhysicalDevice, 
		vulkanRenderer.vkSurface,
		vulkanRenderer.surfaceCapabilities@
	);
	assert result == VkResult.VK_SUCCESS, "Error getting device surface capabilities";

	vkGetPhysicalDeviceSurfaceFormatsKHR(
		vulkanRenderer.currentPhysicalDevice, 
		vulkanRenderer.vkSurface,
		vulkanRenderer.surfaceFormatCount@, 
		null
	);
	if (vulkanRenderer.surfaceFormatCount)
	{
		vulkanRenderer.surfaceFormats.Alloc(vulkanRenderer.surfaceFormatCount);
		vkGetPhysicalDeviceSurfaceFormatsKHR(
			vulkanRenderer.currentPhysicalDevice, 
			vulkanRenderer.vkSurface,
			vulkanRenderer.surfaceFormatCount@, 
			vulkanRenderer.surfaceFormats[0]
		);
	}

	vkGetPhysicalDeviceSurfacePresentModesKHR(
		vulkanRenderer.currentPhysicalDevice, 
		vulkanRenderer.vkSurface,
		vulkanRenderer.presentModeCount@, 
		null
	);
	if (vulkanRenderer.presentModeCount)
	{
		vulkanRenderer.presentModes.Alloc(vulkanRenderer.presentModeCount);
		vkGetPhysicalDeviceSurfacePresentModesKHR(
			vulkanRenderer.currentPhysicalDevice, 
			vulkanRenderer.vkSurface,
			vulkanRenderer.presentModeCount@, 
			vulkanRenderer.presentModes[0]
		);
	}

	selectedFormat := SelectSwapSurfaceFormat();
	selectedPresentMode := SelectSwapPresentMode();
	selectedExtent := SelectSwapExtent();

	imageCount: uint32 = vulkanRenderer.surfaceCapabilities.minImageCount + 1;
	if (vulkanRenderer.surfaceCapabilities.maxImageCount > 0 && 
		imageCount > vulkanRenderer.surfaceCapabilities.maxImageCount) 
	{
		imageCount = vulkanRenderer.surfaceCapabilities.maxImageCount;
	}

	swapchainCreateInfo := VkSwapchainCreateInfoKHR();
	swapchainCreateInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
	swapchainCreateInfo.surface = vulkanRenderer.vkSurface;
	swapchainCreateInfo.minImageCount = imageCount;
	swapchainCreateInfo.imageFormat = selectedFormat.format;
	swapchainCreateInfo.imageColorSpace = selectedFormat.colorSpace;
	swapchainCreateInfo.imageExtent = selectedExtent;
	swapchainCreateInfo.imageArrayLayers = 1;
	swapchainCreateInfo.imageUsage = VkImageUsageFlagBits.VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT;
}

*VkSurfaceFormatKHR SelectSwapSurfaceFormat()
{
	for (i .. vulkanRenderer.surfaceFormatCount)
	{
		surfaceFormat := vulkanRenderer.surfaceFormats[i];
		if (surfaceFormat.format == VkFormat.VK_FORMAT_B8G8R8A8_SRGB &&
			surfaceFormat.colorSpace == VkColorSpaceKHR.VK_COLOR_SPACE_SRGB_NONLINEAR_KHR)
			return surfaceFormat;
	}

	return vulkanRenderer.surfaceFormats[0];
}

VkPresentModeKHR SelectSwapPresentMode()
{
	for (i .. vulkanRenderer.presentModeCount)
	{
		presentMode := vulkanRenderer.presentModes[i]~;
		if (presentMode == VkPresentModeKHR.VK_PRESENT_MODE_MAILBOX_KHR)
			return presentMode;
	}

	return VkPresentModeKHR.VK_PRESENT_MODE_FIFO_KHR;
}

VkExtent2D SelectSwapExtent()
{
	capabilities := vulkanRenderer.surfaceCapabilities;
	if(capabilities.currentExtent.width != uint32(-1))
		return capabilities.currentExtent;
	else
	{
		width := uint32(0);
		height := uint32(0);
		SDL.GetWindowSizeInPixels(
			vulkanRenderer.window,
			width@,
			height@
		);

		extent := VkExtent2D();
		extent.width = Math.Clamp(width, capabilities.minImageExtent.width, capabilities.maxImageExtent.width);
		extent.height = Math.Clamp(height, capabilities.minImageExtent.height, capabilities.maxImageExtent.height);
		return extent;
	}
}

DestroyVulkanRenderer()
{
	vkDestroyDevice(vulkanRenderer.vkDevice, null);
	vkDestroySurfaceKHR(vulkanRenderer.vkInstance, vulkanRenderer.vkSurface, null);
	vkDestroyInstance(vulkanRenderer.vkInstance, null);
}