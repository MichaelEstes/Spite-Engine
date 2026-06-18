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

vulkanInstance := VulkanInstance();

state VulkanInstance
{
	instance: *VkInstance_T,
	extensionNames: **byte,
	physicalDevices: Allocator<*VkPhysicalDevice_T>,

	device: *VkDevice_T,
	deviceFeatures: VkPhysicalDeviceFeatures,
	deviceProperties: VkPhysicalDeviceProperties,
	queues: VulkanQueues,

	resourceTables: ResourceTables<VulkanRenderer>,
	resourceManager: VulkanResourceManager,

	renderPassCache: VulkanRenderPassCache,
	frameBufferCache: VulkanFrameBufferCache,
	pipelineCache: VulkanPipelineMap,
	pipelineLayoutCache: VulkanPipelineLayoutCache,

	allocator: VulkanAllocator,
	stagingBuffer: VulkanStagingBuffer,

	physicalDeviceCount: uint32,
	currentDevice: uint32,
	extensionCount: uint32,
	initialized := false
}

*VkPhysicalDevice_T VulkanInstance::GetPhysicalDevice()
{
	return this.physicalDevices[this.currentDevice]~;
}

VulkanInstance::InitializeCurrentDevice()
{
	this.resourceTables = ResourceTables<VulkanRenderer>(
		::*VkImage_T(createDesc: TextureDesc, renderer: *VulkanRenderer) {
			device := vulkanInstance.device;
			allocator := vulkanInstance.allocator;
			resourceManager := vulkanInstance.resourceManager;

			imageCreateInfo := TextureDescToCreateInfo(createDesc, renderer);
			image := CreateVkImage(device, imageCreateInfo);
			imageHandle := allocator.AllocImage(image, VulkanMemoryFlags.GPU);
			
			imageViewInfo := DefaultImageView(image, imageCreateInfo);
			imageView := CreateVkImageView(device, imageViewInfo);

			renderTarget := VulkanRenderTarget();
			renderTarget.image = image;
			renderTarget.imageView = imageView;
			renderTarget.handle = imageHandle;

			resourceManager.renderTargetMap.Insert(image, renderTarget);

			return image;
		},
		::*VkBuffer_T(createDesc: BufferDesc, renderer: *VulkanRenderer) {
			device := vulkanInstance.device;
			return CreateVkBuffer(device, BufferDescToCreateInfo(createDesc));
		}
	)
	this.resourceManager = VulkanResourceManager();
	this.renderPassCache = VulkanRenderPassCache();
	this.frameBufferCache = VulkanFrameBufferCache();
	this.pipelineCache = VulkanPipelineMap();
	this.pipelineLayoutCache = VulkanPipelineLayoutCache();
	this.stagingBuffer = VulkanStagingBuffer();

	physicalDevice := this.GetPhysicalDevice();

	vkGetPhysicalDeviceFeatures(physicalDevice, this.deviceFeatures@);
	vkGetPhysicalDeviceProperties(physicalDevice, this.deviceProperties@);

	this.queues = VulkanQueues();
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

	this.queues.GetQueues(this.device, physicalDevice, this.instance);
	
	this.allocator = VulkanAllocator();
	this.allocator.Create(this.device, physicalDevice);
}

ref VulkanStagingBuffer VulkanInstance::GetStagingBuffer()
{
	stagingBuffer := this.stagingBuffer;
	if (!stagingBuffer.buffer)
	{
		device := this.device;
		physicalDevice := this.GetPhysicalDevice();
		stagingBuffer.Create(device, physicalDevice);
	}

	return stagingBuffer;
}

VulkanInstance::SelectDefaultDevice()
{
	if (this.physicalDeviceCount == 1)
	{
		log "Only one physical device found, using it";
		this.currentDevice = 0;
		return;
	}

	log "Selecting default device";

	backupDevice := -1;

	for (i .. this.physicalDeviceCount)
	{
		physicalDevice := this.physicalDevices[i]~;
		deviceProperties := VkPhysicalDeviceProperties();
		vkGetPhysicalDeviceProperties(physicalDevice, deviceProperties@);

		log "Evaluating Device: ", string(256, fixed deviceProperties.deviceName);
		if (deviceProperties.deviceType == VkPhysicalDeviceType.VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU)
		{
			log "Found discrete GPU, using it";
			this.currentDevice = i;
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
		this.currentDevice = backupDevice;
		return;
	}

	log "No backup device found, using first device";
	this.currentDevice = 0;
}

VulkanInstance::DebugLogExtensions()
{
	physicalDevice := this.physicalDevices[this.currentDevice]~;
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

InitializeVulkanInstance()
{
	if (vulkanInstance.initialized) return;

	log "InitializeVulkanInstance";

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
 
	vulkanInstance.SelectDefaultDevice();
	vulkanInstance.InitializeCurrentDevice();

	ECS.instance.events.On(
		MeshAddedEvent, 
		::(sceneEntity: SceneEntity, data: *void)
		{
			log "Mesh Added Vulkan Instance";
			scene := sceneEntity.scene;
			entity := sceneEntity.entity;
			mesh := scene.GetComponent<Mesh>(entity);

			for (ec in scene.Iterate<VulkanRenderer>())
			{
				renderer := ec.component;
				if (renderer.meshCallbacks.onMeshAdded)
				{
					renderer.meshCallbacks.onMeshAdded(sceneEntity, mesh, renderer);
				}
			}
		}
	);

	GetGlobalEventEmitter().On(
		SDL.EventType.WINDOW_RESIZED, 
		::(event: SDL.Event, data: *void) 
		{
			windowID := event.data.window.windowID;

			for (scene in ECS.Scenes())
			{
				for (ec in scene.Iterate<VulkanRenderer>())
				{
					renderer := ec.component;
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