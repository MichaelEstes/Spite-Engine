package VulkanRenderer

import ArrayView

UINT64_MAX := uint64(-1);
VkFalse := uint32(0);
VkTrue := uint32(1);

appInfo := {
	VkStructureType.VK_STRUCTURE_TYPE_APPLICATION_INFO,
	null,
	"Spite Engine"[0],
	uint32(0),
	"Spite Engine"[0],
	uint32(0),
	uint32(0),
} as VkApplicationInfo;

validationLayers := ["VK_LAYER_KHRONOS_validation"[0],];
validationCount := #compile uint32 => (#typeof validationLayers).FixedArrayCount();

requiredDeviceExtensions := ["VK_KHR_swapchain"[0],];
requiredDeviceExtensionCount := #compile uint32 => (#typeof requiredDeviceExtensions).FixedArrayCount();

state VulkanInstance
{
	instance: *VkInstance_T,
	extensionNames: **byte,
	physicalDevices: Allocator<*VkPhysicalDevice_T>,
	devices: Allocator<*VkDevice_T>,
	deviceFeatures: Allocator<VkPhysicalDeviceFeatures>,
	deviceProperties: Allocator<VkPhysicalDeviceProperties>,
	queues: Allocator<VulkanQueues>,

	resourceTables: Allocator<ResourceTables<VulkanRenderer>>,
	resourceManagers: Allocator<VulkanResourceManager>,

	renderPassCaches: Allocator<VulkanRenderPassCache>,
	frameBufferCaches: Allocator<VulkanFrameBufferCache>,
	pipelineCaches: Allocator<VulkanPipelineCache>,
	pipelineLayoutCaches: Allocator<VulkanPipelineLayoutCache>,

	allocators: Allocator<VulkanAllocator>,
	stagingBuffers: Allocator<VulkanStagingBuffer>,

	devicesInitialized: ZeroedAllocator<bool>,

	physicalDeviceCount: uint32,
	defaultDevice: uint32,
	extensionCount: uint32,
	initialized := false
}

ArrayView<*VkPhysicalDevice_T> VulkanInstance::PhysicalDevices()
{
	return ArrayView<*VkPhysicalDevice_T>(this.physicalDevices[0], this.physicalDeviceCount);
}

VulkanInstance::InitializeDevice(deviceIndex: uint32)
{
	i := deviceIndex;
	if (vulkanInstance.devicesInitialized[i]~) return;
	vulkanInstance.resourceTables[i]~ = ResourceTables<VulkanRenderer>(
		::*VkImage_T(createDesc: TextureDesc, renderer: *VulkanRenderer) {
			imageCreateInfo := TextureDescToCreateInfo(createDesc, renderer);
			image := CreateVkImage(renderer.device, imageCreateInfo);
			imageViewInfo := DefaultImageView(image, imageCreateInfo);
			imageView := CreateVkImageView(renderer.device, imageViewInfo);

			renderTarget := VulkanRenderTarget();
			renderTarget.image = image;
			renderTarget.imageView = imageView;

			resourceManager := vulkanInstance.resourceManagers[renderer.deviceIndex];
			resourceManager.renderTargetMap.Insert(image, renderTarget);

			return image;
		},
		::*VkBuffer_T(createDesc: BufferDesc, renderer: *VulkanRenderer) {
			return CreateVkBuffer(renderer.device, BufferDescToCreateInfo(createDesc));
		}
	)
	vulkanInstance.resourceManagers[i]~ = VulkanResourceManager();
	vulkanInstance.renderPassCaches[i]~ = VulkanRenderPassCache();
	vulkanInstance.frameBufferCaches[i]~ = VulkanFrameBufferCache();
	vulkanInstance.pipelineCaches[i]~ = VulkanPipelineCache();
	vulkanInstance.pipelineLayoutCaches[i]~ = VulkanPipelineLayoutCache();
	vulkanInstance.stagingBuffers[i]~ = VulkanStagingBuffer();

	physicalDevice := vulkanInstance.physicalDevices[i]~;

	deviceFeatures := vulkanInstance.deviceFeatures[i];
	deviceProperties := vulkanInstance.deviceProperties[i];
	vkGetPhysicalDeviceFeatures(physicalDevice, deviceFeatures);
	vkGetPhysicalDeviceProperties(physicalDevice, deviceProperties);

	queues := vulkanInstance.queues[i];
	queues~ = VulkanQueues();
	queues.Create(physicalDevice);

	queueCreateInfos := queues.DeviceQueueCreateInfo();
	defer delete queueCreateInfos;

	createInfo := VkDeviceCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
	createInfo.queueCreateInfoCount = queueCreateInfos.count;
	createInfo.pQueueCreateInfos = queueCreateInfos[0]@;
	createInfo.enabledExtensionCount = requiredDeviceExtensionCount;
	createInfo.ppEnabledExtensionNames = requiredDeviceExtensions[0]@;
	createInfo.pEnabledFeatures = vulkanInstance.deviceFeatures[i];

	device := vulkanInstance.devices[i];
	CheckResult(
		vkCreateDevice(physicalDevice, createInfo@, null, device),
		"Error creating Vulkan device"
	);

	queues.GetQueues(device~, physicalDevice, vulkanInstance.instance);
	
	vulkanInstance.allocators[i]~ = VulkanAllocator();
	vulkanInstance.allocators[i].Create(device~, physicalDevice);
	vulkanInstance.devicesInitialized[i]~ = true;
}

*VulkanStagingBuffer VulkanInstance::GetStagingBuffer(deviceIndex: uint32)
{
	stagingBuffer := this.stagingBuffers[deviceIndex];
	if (!stagingBuffer.buffer)
	{
		device := this.devices[deviceIndex]~;
		physicalDevice := this.physicalDevices[deviceIndex]~;
		stagingBuffer.Create(device, physicalDevice);
	}

	return stagingBuffer;
}

VulkanInstance::SelectDefaultDevice()
{
	if (this.physicalDeviceCount == 1)
	{
		log "Only one physical device found, using it";
		this.defaultDevice = 0;
		return;
	}

	log "Selecting default device";

	backupDevice := -1;

	for (i .. this.physicalDeviceCount)
	{
		deviceProperties := this.deviceProperties[i];

		log "Evaluating Device: ", string(256, fixed deviceProperties.deviceName);
		if (deviceProperties.deviceType == VkPhysicalDeviceType.VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU)
		{
			log "Found discrete GPU, using it";
			this.defaultDevice = i;
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
		this.defaultDevice = backupDevice;
		return;
	}

	log "No backup device found, using first device";
	this.defaultDevice = 0;
}

VulkanInstance::DebugLogExtensions()
{
	physicalDevice := this.physicalDevices[this.defaultDevice]~;
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

	vulkanInstance.devices.Alloc(vulkanInstance.physicalDeviceCount);
	vulkanInstance.deviceFeatures.Alloc(vulkanInstance.physicalDeviceCount);
	vulkanInstance.deviceProperties.Alloc(vulkanInstance.physicalDeviceCount);
	vulkanInstance.queues.Alloc(vulkanInstance.physicalDeviceCount);
	vulkanInstance.resourceTables.Alloc(vulkanInstance.physicalDeviceCount);
	vulkanInstance.resourceManagers.Alloc(vulkanInstance.physicalDeviceCount);
	vulkanInstance.renderPassCaches.Alloc(vulkanInstance.physicalDeviceCount);
	vulkanInstance.frameBufferCaches.Alloc(vulkanInstance.physicalDeviceCount);
	vulkanInstance.pipelineCaches.Alloc(vulkanInstance.physicalDeviceCount);
	vulkanInstance.pipelineLayoutCaches.Alloc(vulkanInstance.physicalDeviceCount);
	vulkanInstance.allocators.Alloc(vulkanInstance.physicalDeviceCount);
	vulkanInstance.stagingBuffers.Alloc(vulkanInstance.physicalDeviceCount);
	vulkanInstance.devicesInitialized.Alloc(vulkanInstance.physicalDeviceCount);
 
	vulkanInstance.SelectDefaultDevice();

	ECS.instance.events.On(
		MeshAddedEvent, 
		::(sceneEntity: SceneEntity)
		{
			log "Mesh Added";
			scene := sceneEntity.scene;
			entity := sceneEntity.entity;

			if (scene.HasSingleton<VulkanRenderer>())
			{
				renderer := scene.GetSingleton<VulkanRenderer>();
				mesh := scene.GetComponent<Mesh>(entity);
				
				UploadMesh(sceneEntity, mesh, renderer);
			}
		}
	);

	SDLEventEmitter.On(
		SDL.EventType.WINDOW_RESIZED, 
		::(event: SDL.Event) 
		{
			windowID := event.data.window.windowID;

			for (scene in ECS.Scenes())
			{
				if (scene.HasSingleton<VulkanRenderer>())
				{
					renderer := scene.GetSingleton<VulkanRenderer>();
					if (renderer.window.id == windowID)
					{
						log "Window Resized";
						renderer.RecreateSwapchain();
					}
				}
			}
		}
	);
}