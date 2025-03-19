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
	
	extensionNames: **byte,

	physicalDevices: Allocator<*VkPhysicalDevice_T>,
	currentPhysicalDevice: *VkPhysicalDevice_T,
	currentDeviceFeatures: VkPhysicalDeviceFeatures,
	currentDeviceProperties: VkPhysicalDeviceProperties,

	queueFamilies: Allocator<VkQueueFamilyProperties>,
	graphicsQueueIndices: Allocator<uint32>,

	extensionCount: uint32,
	physicalDeviceCount: uint32,
	queueFamilyCount: uint32,
	graphicsQueueCount: uint32,
}

vulkanRenderer := VulkanRenderer();

InitializeVulkanRenderer()
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

    InitializeCurrentDevice();
	InitializeQueues();

	log "Device name: ", string(256, fixed vulkanRenderer.currentDeviceProperties.deviceName);
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

	BuildQueueFamilyIndices(
		VkQueueFlagBits.VK_QUEUE_GRAPHICS_BIT, 
		vulkanRenderer.graphicsQueueCount@,
		vulkanRenderer.graphicsQueueIndices@
	);

	queuePriorities := float32(1.0);
	graphicsQueueCreateInfo := VkDeviceQueueCreateInfo();
	graphicsQueueCreateInfo.queueFamilyIndex = vulkanRenderer.graphicsQueueIndices[0]~;
	graphicsQueueCreateInfo.queueCount = 1;
	graphicsQueueCreateInfo.pQueuePriorities = queuePriorities@;
}

BuildQueueFamilyIndices(flag: VkQueueFlagBits, count: *uint32, indices: *Allocator<uint32>)
{
	count~ = uint32(0);
	for (i .. vulkanRenderer.queueFamilyCount)
	{
		queueFamily := vulkanRenderer.queueFamilies[i];
		if (queueFamily.queueFlags & flag) {
			count~ += 1;
		}
    }

	indices.Alloc(count~);
	index := 0;
	for (i .. vulkanRenderer.queueFamilyCount)
	{
		queueFamily := vulkanRenderer.queueFamilies[i];
		if (queueFamily.queueFlags & flag) {
			indices~[index]~ = i;
			index += 1;
		}
    }
}

*VkSurfaceKHR_T InitializeSurface(window: *SDL.Window)
{
	vkSurface := null as *VkSurfaceKHR_T;
	surfaceResult := SDL.VulkanCreateSurface(window, vulkanRenderer.vkInstance, null, vkSurface@);
	assert surfaceResult, "Error creating Vulkan surface";

	return vkSurface;
}