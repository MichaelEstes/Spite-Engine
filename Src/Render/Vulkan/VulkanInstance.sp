package VulkanRenderer

import ArrayView

state VulkanInstance
{
	instance: *VkInstance_T,
	extensionNames: **byte,
	physicalDevices: Allocator<*VkPhysicalDevice_T>,
	resourceTables: ResourceTables,

	physicalDeviceCount: uint32,
	extensionCount: uint32,
	initialized := false
}

ArrayView<*VkPhysicalDevice_T> VulkanInstance::PhysicalDevices()
{
	return ArrayView<*VkPhysicalDevice_T>(this.physicalDevices[0], this.physicalDeviceCount);
}

vulkanInstance := VulkanInstance();

InitializeVulkanInstance()
{
	if (vulkanInstance.initialized) return;

	vulkanInstance.initialized = true;
	vulkanInstance.extensionNames = SDL.VulkanGetInstanceExtensions(vulkanInstance.extensionCount@);
    instanceCreateInfo := {
        VkStructureType.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO, 
        null,													
        uint32(0),												
        appInfo@,													
        validationCount,										
        fixed validationLayers,												
        vulkanInstance.extensionCount,											
        vulkanInstance.extensionNames,											
    } as VkInstanceCreateInfo;

	CheckResult(
		vkCreateInstance(instanceCreateInfo@, null, vulkanInstance.instance@),
		"Error creating Vulkan instance"
	);

	vkEnumeratePhysicalDevices(vulkanInstance.instance, vulkanInstance.physicalDeviceCount@, null);
	vulkanInstance.physicalDevices.Alloc(vulkanInstance.physicalDeviceCount);
    CheckResult(
		vkEnumeratePhysicalDevices(
			vulkanInstance.instance, 
			vulkanInstance.physicalDeviceCount@, 
			vulkanInstance.physicalDevices[0]
		),
		"Error finding device for Vulkan"
	);

	vulkanInstance.resourceTables = ResourceTables(
		::*VkImage_T(createDesc: TextureDesc, device: *VkDevice_T) {
			return CreateVkImage(device, TextureDescToCreateInfo(createDesc));
		},
		::*VkBuffer_T(createDesc: BufferDesc, device: *VkDevice_T) {
			return CreateVkBuffer(device, BufferDescToCreateInfo(createDesc));
		}
	)

	SDLEventEmitter.On(SDL.EventType.WINDOW_RESIZED, ::(event: SDL.Event) {
		windowID := event.data.window.windowID;

		for (scene in ECS.Scenes())
		{
			if (scene.HasSingleton<VulkanRenderer>())
			{
				renderer := scene.GetSingleton<VulkanRenderer>();
				if (renderer.window.id == windowID)
				{
					//renderer.RecreateSwapchain();
				}
			}
		}
	});
}