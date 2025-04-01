package VulkanRenderer

import OS
import Math
import Vulkan
import SDL

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

CheckResult(result: VkResult, errorMsg: string)
{
	if (result != VkResult.VK_SUCCESS)
	{
		log errorMsg;
	}
}

state VulkanInstance
{
	instance: *VkInstance_T,
	extensionNames: **byte,
	physicalDevices: Allocator<*VkPhysicalDevice_T>,

	physicalDeviceCount: uint32,
	extensionCount: uint32,
}

vulkanInstance := VulkanInstance();

InitializeVulkanInstance()
{
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
}

state VulkanRenderer
{
	vkInstance: *VulkanInstance,
	
	window: *SDL.Window,
	device: *VkDevice_T,
	surface: *VkSurfaceKHR_T,
	swapChain: *VkSwapchainKHR_T,
	pipelineLayout: *VkPipelineLayout_T,
	renderPass: *VkRenderPass_T,
	pipeline: *VkPipeline_T,
	commandPool: *VkCommandPool_T,
	commandBuffer: *VkCommandBuffer_T,

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

	swapChainImages: Allocator<*VkImage_T>,
	swapChainExtent: VkExtent2D,
	swapChainImageFormat: VkFormat,

	swapChainImageViews: Allocator<*VkImageView_T>,

	frameBuffers: Allocator<*VkFramebuffer_T>,

	imageAvailableSemaphore: *VkSemaphore_T,
	renderFinishedSemaphore: *VkSemaphore_T,
	inFlightFence: *VkFence_T,

	queueFamilyCount: uint32,
	graphicsQueueCount: uint32,
	presentationQueueCount: uint32,
	surfaceFormatCount: uint32,
	presentModeCount: uint32,
	swapChainImageCount: uint32,
	swapChainImageViewCount: uint32,
	frameBufferCount: uint32,
}

*VkQueue_T VulkanRenderer::GraphicsQueue() => this.graphicsQueues[0]~;
*VkQueue_T VulkanRenderer::PresentationQueue() => this.presentationQueues[0]~;

VulkanRenderer::DebugLogExtensions()
{
	extCount := uint32(0);
	vkEnumerateDeviceExtensionProperties(this.currentPhysicalDevice, null, extCount@, null);
	log "Device ext count: ", extCount;
	extProps := Allocator<VkExtensionProperties>();
	extProps.Alloc(extCount);
	vkEnumerateDeviceExtensionProperties(this.currentPhysicalDevice, null, extCount@, extProps[0]);
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

VulkanRenderer CreateVulkanRenderer(window: *SDL.Window)
{
	vulkanRenderer := VulkanRenderer();
	vulkanRenderer.vkInstance = vulkanInstance@;

	vulkanRenderer.window = window;

	vulkanRenderer.InitializeSurface();
    vulkanRenderer.InitializeCurrentDevice();

	//vulkanRenderer.DebugLogExtensions();

	vulkanRenderer.InitializeQueues();
	vulkanRenderer.BuildQueueFamilyIndices();
	vulkanRenderer.InitializeLogicalDevice();
	vulkanRenderer.InitializeSwapchain();
	vulkanRenderer.InitializeImageViews();
	vulkanRenderer.InitializeRenderPass();
	vulkanRenderer.InitializePipeline();
	vulkanRenderer.InitializeFrameBuffers();
	vulkanRenderer.InitializeCommandPool();
	vulkanRenderer.InitializeCommandBuffer();
	vulkanRenderer.InitializeSyncObjects();

	log "Device name: ", string(256, fixed vulkanRenderer.currentDeviceProperties.deviceName);
	return vulkanRenderer;
}

VulkanRenderer::InitializeSurface()
{
	if (!SDL.VulkanCreateSurface(this.window, this.vkInstance.instance, null, this.surface@))
	{
		puts(SDL.GetError());
		log "Error creating Vulkan surface";
	}
}

VulkanRenderer::InitializeCurrentDevice()
{
	this.currentPhysicalDevice = this.vkInstance.physicalDevices[0]~;
	vkGetPhysicalDeviceFeatures(this.currentPhysicalDevice, this.currentDeviceFeatures@);
	vkGetPhysicalDeviceProperties(this.currentPhysicalDevice, this.currentDeviceProperties@);
}

VulkanRenderer::InitializeQueues()
{
	vkGetPhysicalDeviceQueueFamilyProperties(this.currentPhysicalDevice, this.queueFamilyCount@, null);
	this.queueFamilies.Alloc(this.queueFamilyCount);
    vkGetPhysicalDeviceQueueFamilyProperties(
		this.currentPhysicalDevice, 
		this.queueFamilyCount@, 
		this.queueFamilies[0]
	);
}

VulkanRenderer::BuildQueueFamilyIndices()
{
	for (i .. this.queueFamilyCount)
	{
		queueFamily := this.queueFamilies[i];
		if (queueFamily.queueFlags & VkQueueFlagBits.VK_QUEUE_GRAPHICS_BIT) 
		{
			this.graphicsQueueCount += 1;
		}

		presentationSupport := uint32(0);
		vkGetPhysicalDeviceSurfaceSupportKHR(
			this.currentPhysicalDevice, 
			i, 
			this.surface, 
			presentationSupport@
		);
		if (presentationSupport)
		{
			this.presentationQueueCount += 1;
		}

    }

	this.graphicsQueueIndices.Alloc(this.graphicsQueueCount);
	this.presentationQueueIndices.Alloc(this.presentationQueueCount)
	graphicsIndex := 0;
	presentationIndex := 0;
	for (i .. this.queueFamilyCount)
	{
		queueFamily := this.queueFamilies[i];
		if (queueFamily.queueFlags & VkQueueFlagBits.VK_QUEUE_GRAPHICS_BIT) 
		{
			this.graphicsQueueIndices[graphicsIndex]~ = i;
			graphicsIndex += 1;
		}

		presentationSupport := uint32(0);
		vkGetPhysicalDeviceSurfaceSupportKHR(
			this.currentPhysicalDevice, 
			i, 
			this.surface, 
			presentationSupport@
		);
		if (presentationSupport)
		{
			this.presentationQueueIndices[presentationIndex]~ = i;
			presentationIndex += 1;
		}
    }
}

{queues: Allocator<uint32>, count: uint32} VulkanRenderer::GetUniqueQueues()
{
	queues := Allocator<uint32>();
	queues.Alloc(this.graphicsQueueCount + this.presentationQueueCount);

	count := uint32(0);
	for (i .. this.presentationQueueCount)
	{
		queues[i]~ = this.presentationQueueIndices[i]~;
		count += 1;
	}

	for (i .. this.graphicsQueueCount)
	{
		queue := this.graphicsQueueIndices[i]~;
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

VulkanRenderer::InitializeLogicalDevice()
{
	queuePriority := float32(1.0);

	uniqueQueues := this.GetUniqueQueues();
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
	deviceCreateInfo.pEnabledFeatures = this.currentDeviceFeatures@;

	CheckResult(
		vkCreateDevice(this.currentPhysicalDevice, deviceCreateInfo@, null, this.device@),
		"Error creating a logical Vulkan device"
	);

	this.GetDeviceQueues(
		this.graphicsQueueCount,
		this.graphicsQueueIndices,
		this.graphicsQueues@
	)

	this.GetDeviceQueues(
		this.presentationQueueCount,
		this.presentationQueueIndices,
		this.presentationQueues@
	)
}

VulkanRenderer::GetDeviceQueues(count: uint32, indices: Allocator<uint32>, queues: *Allocator<*VkQueue_T>)
{
	queues.Alloc(count);
	for (i .. count)
	{
		vkGetDeviceQueue(
			this.device,
			indices[i]~,
			0,
			queues~[i]
		);
	}
}

VulkanRenderer::InitializeSwapchain()
{
	CheckResult(
		vkGetPhysicalDeviceSurfaceCapabilitiesKHR(
			this.currentPhysicalDevice, 
			this.surface, 
			this.surfaceCapabilities@
		),
		"Error getting device surface capabilities"
	);

	vkGetPhysicalDeviceSurfaceFormatsKHR(
		this.currentPhysicalDevice, 
		this.surface,
		this.surfaceFormatCount@, 
		null
	);
	if (this.surfaceFormatCount)
	{
		this.surfaceFormats.Alloc(this.surfaceFormatCount);
		vkGetPhysicalDeviceSurfaceFormatsKHR(
			this.currentPhysicalDevice, 
			this.surface,
			this.surfaceFormatCount@, 
			this.surfaceFormats[0]
		);
	}

	vkGetPhysicalDeviceSurfacePresentModesKHR(
		this.currentPhysicalDevice, 
		this.surface,
		this.presentModeCount@, 
		null
	);
	if (this.presentModeCount)
	{
		this.presentModes.Alloc(this.presentModeCount);
		vkGetPhysicalDeviceSurfacePresentModesKHR(
			this.currentPhysicalDevice, 
			this.surface,
			this.presentModeCount@, 
			this.presentModes[0]
		);
	}

	selectedFormat := this.SelectSwapSurfaceFormat();
	selectedPresentMode := this.SelectSwapPresentMode();
	selectedExtent := this.SelectSwapExtent();

	imageCount: uint32 = this.surfaceCapabilities.minImageCount + 1;
	if (this.surfaceCapabilities.maxImageCount > 0 && 
		imageCount > this.surfaceCapabilities.maxImageCount) 
	{
		imageCount = this.surfaceCapabilities.maxImageCount;
	}

	swapchainCreateInfo := VkSwapchainCreateInfoKHR();
	swapchainCreateInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
	swapchainCreateInfo.surface = this.surface;
	swapchainCreateInfo.minImageCount = imageCount;
	swapchainCreateInfo.imageFormat = selectedFormat.format;
	swapchainCreateInfo.imageColorSpace = selectedFormat.colorSpace;
	swapchainCreateInfo.imageExtent = selectedExtent;
	swapchainCreateInfo.imageArrayLayers = 1;
	swapchainCreateInfo.imageUsage = VkImageUsageFlagBits.VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT;

	queueIndices := [this.graphicsQueueIndices[0]~, this.presentationQueueIndices[0]~];
	if (this.GraphicsQueue() != this.PresentationQueue())
	{
		swapchainCreateInfo.imageSharingMode = VkSharingMode.VK_SHARING_MODE_CONCURRENT;
		swapchainCreateInfo.queueFamilyIndexCount = 2
		swapchainCreateInfo.pQueueFamilyIndices = fixed queueIndices;
	}
	else
	{
		swapchainCreateInfo.imageSharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;
		swapchainCreateInfo.queueFamilyIndexCount = 0
		swapchainCreateInfo.pQueueFamilyIndices = null;
	}

	swapchainCreateInfo.preTransform = this.surfaceCapabilities.currentTransform;
	swapchainCreateInfo.compositeAlpha = VkCompositeAlphaFlagBitsKHR.VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;
	swapchainCreateInfo.presentMode = selectedPresentMode;
	swapchainCreateInfo.clipped = uint32(1);
	swapchainCreateInfo.oldSwapchain = this.swapChain;

	CheckResult(
		vkCreateSwapchainKHR(this.device, swapchainCreateInfo@, null, this.swapChain@),
		"Error creating Vulkan swap chain"
	)

	vkGetSwapchainImagesKHR(
		this.device,
		this.swapChain,
		this.swapChainImageCount@,
		null
	);
	this.swapChainImages.Alloc(this.swapChainImageCount);
	vkGetSwapchainImagesKHR(
		this.device,
		this.swapChain,
		this.swapChainImageCount@,
		this.swapChainImages[0]
	);

	this.swapChainImageFormat = selectedFormat.format;
	this.swapChainExtent = selectedExtent;
}

*VkSurfaceFormatKHR VulkanRenderer::SelectSwapSurfaceFormat()
{
	for (i .. this.surfaceFormatCount)
	{
		surfaceFormat := this.surfaceFormats[i];
		if (surfaceFormat.format == VkFormat.VK_FORMAT_B8G8R8A8_SRGB &&
			surfaceFormat.colorSpace == VkColorSpaceKHR.VK_COLOR_SPACE_SRGB_NONLINEAR_KHR)
			return surfaceFormat;
	}

	return this.surfaceFormats[0];
}

VkPresentModeKHR VulkanRenderer::SelectSwapPresentMode()
{
	for (i .. this.presentModeCount)
	{
		presentMode := this.presentModes[i]~;
		if (presentMode == VkPresentModeKHR.VK_PRESENT_MODE_MAILBOX_KHR)
			return presentMode;
	}

	return VkPresentModeKHR.VK_PRESENT_MODE_FIFO_KHR;
}

VkExtent2D VulkanRenderer::SelectSwapExtent()
{
	capabilities := this.surfaceCapabilities;
	if(capabilities.currentExtent.width != uint32(-1))
		return capabilities.currentExtent;
	else
	{
		width := uint32(0);
		height := uint32(0);
		SDL.GetWindowSizeInPixels(
			this.window,
			width@,
			height@
		);

		extent := VkExtent2D();
		extent.width = Math.Clamp(width, capabilities.minImageExtent.width, capabilities.maxImageExtent.width);
		extent.height = Math.Clamp(height, capabilities.minImageExtent.height, capabilities.maxImageExtent.height);
		return extent;
	}
}

VulkanRenderer::InitializeImageViews()
{
	this.swapChainImageViews.Alloc(this.swapChainImageCount);

	for (i .. this.swapChainImageCount)
	{
		imageViewCreateInfo := VkImageViewCreateInfo();
		imageViewCreateInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
		imageViewCreateInfo.image = this.swapChainImages[i]~;
		imageViewCreateInfo.viewType = VkImageViewType.VK_IMAGE_VIEW_TYPE_2D;
		imageViewCreateInfo.format = this.swapChainImageFormat;
		imageViewCreateInfo.components.r = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_IDENTITY;
		imageViewCreateInfo.components.g = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_IDENTITY;
		imageViewCreateInfo.components.b = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_IDENTITY;
		imageViewCreateInfo.components.a = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_IDENTITY;
		imageViewCreateInfo.subresourceRange.aspectMask = VkImageAspectFlagBits.VK_IMAGE_ASPECT_COLOR_BIT;
		imageViewCreateInfo.subresourceRange.baseMipLevel = uint32(0);
		imageViewCreateInfo.subresourceRange.levelCount = uint32(1);
		imageViewCreateInfo.subresourceRange.baseArrayLayer = uint32(0);
		imageViewCreateInfo.subresourceRange.layerCount = uint32(1);

		CheckResult(
			vkCreateImageView(this.device, imageViewCreateInfo@, null, this.swapChainImageViews[i]),
			"Error creating Vulkan image view"
		);
	}
}

VulkanRenderer::InitializeRenderPass()
{
	colorAttachment := VkAttachmentDescription();
    colorAttachment.format = this.swapChainImageFormat;
    colorAttachment.samples = VkSampleCountFlagBits.VK_SAMPLE_COUNT_1_BIT;
	colorAttachment.loadOp = VkAttachmentLoadOp.VK_ATTACHMENT_LOAD_OP_CLEAR;
	colorAttachment.storeOp = VkAttachmentStoreOp.VK_ATTACHMENT_STORE_OP_STORE;
	colorAttachment.stencilLoadOp = VkAttachmentLoadOp.VK_ATTACHMENT_LOAD_OP_DONT_CARE;
	colorAttachment.stencilStoreOp = VkAttachmentStoreOp.VK_ATTACHMENT_STORE_OP_DONT_CARE;
	colorAttachment.initialLayout = VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED;
	colorAttachment.finalLayout = VkImageLayout.VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;

	colorAttachmentRef := VkAttachmentReference();
	colorAttachmentRef.attachment = uint32(0);
	colorAttachmentRef.layout = VkImageLayout.VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;

	subpass := VkSubpassDescription();
	subpass.pipelineBindPoint = VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS;
	subpass.colorAttachmentCount = uint32(1);
	subpass.pColorAttachments = colorAttachmentRef@;

	dependency := VkSubpassDependency();
	dependency.srcSubpass = VK_SUBPASS_EXTERNAL;
	dependency.dstSubpass = uint32(0);
	dependency.srcStageMask = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
	dependency.srcAccessMask = uint32(0);
	dependency.dstStageMask = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
	dependency.dstAccessMask = VkAccessFlagBits.VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;

	renderPassInfo := VkRenderPassCreateInfo();
	renderPassInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
	renderPassInfo.attachmentCount = uint32(1);
	renderPassInfo.pAttachments = colorAttachment@;
	renderPassInfo.subpassCount = uint32(1);
	renderPassInfo.pSubpasses = subpass@;
	renderPassInfo.dependencyCount = 1;
	renderPassInfo.pDependencies = dependency@;

	CheckResult(
		vkCreateRenderPass(this.device, renderPassInfo@, null, this.renderPass@),
		"Error creating Vulkan render pass"
	);
}

VulkanRenderer::InitializePipeline()
{
	vertShader := ReadFile("C:\\Users\\Flynn\\Documents\\Spite Engine\\Render\\Shaders\\vert.spv");
	fragShader := ReadFile("C:\\Users\\Flynn\\Documents\\Spite Engine\\Render\\Shaders\\frag.spv");

	vertShaderModule := this.CreateShaderModule(vertShader);
	fragShaderModule := this.CreateShaderModule(fragShader);

	vertShaderStageInfo := VkPipelineShaderStageCreateInfo();
	vertShaderStageInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
	vertShaderStageInfo.stage = VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT;
	vertShaderStageInfo.module = vertShaderModule;
	vertShaderStageInfo.pName = "main"[0];

	fragShaderStageInfo := VkPipelineShaderStageCreateInfo();
	fragShaderStageInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
	fragShaderStageInfo.stage = VkShaderStageFlagBits.VK_SHADER_STAGE_FRAGMENT_BIT;
	fragShaderStageInfo.module = fragShaderModule;
	fragShaderStageInfo.pName = "main"[0];

	shaderStages := [vertShaderStageInfo, fragShaderStageInfo];

	vertexInputInfo := VkPipelineVertexInputStateCreateInfo();
	vertexInputInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;
	vertexInputInfo.vertexBindingDescriptionCount = uint32(0);
	vertexInputInfo.pVertexBindingDescriptions = null;
	vertexInputInfo.vertexAttributeDescriptionCount = uint32(0);
	vertexInputInfo.pVertexAttributeDescriptions = null;

	inputAssembly := VkPipelineInputAssemblyStateCreateInfo();
	inputAssembly.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO;
	inputAssembly.topology = VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST;
	inputAssembly.primitiveRestartEnable = VkFalse;

	viewport := VkViewport();
	viewport.x = float32(0.0);
	viewport.y = float32(0.0);
	viewport.width = this.swapChainExtent.width as float32;
	viewport.height = this.swapChainExtent.height as float32;
	viewport.minDepth = float32(0.0);
	viewport.maxDepth = float32(1.0);

	scissor := VkRect2D();
	scissor.offset = {int32(0), int32(0)};
	scissor.extent = this.swapChainExtent;

	viewportState := VkPipelineViewportStateCreateInfo();
	viewportState.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO;
	viewportState.viewportCount = uint32(1);
	viewportState.scissorCount = uint32(1);
	viewportState.pScissors = scissor@;

	rasterizer := VkPipelineRasterizationStateCreateInfo();
	rasterizer.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO;
	rasterizer.depthClampEnable = VkFalse;
	rasterizer.rasterizerDiscardEnable = VkFalse;
	rasterizer.polygonMode = VkPolygonMode.VK_POLYGON_MODE_FILL;
	rasterizer.lineWidth = float32(1.0);
	rasterizer.cullMode = VkCullModeFlagBits.VK_CULL_MODE_BACK_BIT;
	rasterizer.frontFace = VkFrontFace.VK_FRONT_FACE_CLOCKWISE;
	rasterizer.depthBiasEnable = VkFalse;
	rasterizer.depthBiasConstantFactor = float32(0.0); 
	rasterizer.depthBiasClamp = float32(0.0);
	rasterizer.depthBiasSlopeFactor = float32(0.0);

	multisampling := VkPipelineMultisampleStateCreateInfo();
	multisampling.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO;
	multisampling.sampleShadingEnable = VkFalse;
	multisampling.rasterizationSamples = VkSampleCountFlagBits.VK_SAMPLE_COUNT_1_BIT;
	multisampling.minSampleShading = float32(1.0); 
	multisampling.pSampleMask = null; 
	multisampling.alphaToCoverageEnable = VkFalse; 
	multisampling.alphaToOneEnable = VkFalse; 

	colorBlendAttachment := VkPipelineColorBlendAttachmentState();
	colorBlendAttachment.colorWriteMask = VkColorComponentFlagBits.VK_COLOR_COMPONENT_R_BIT | 
			VkColorComponentFlagBits.VK_COLOR_COMPONENT_G_BIT | 
			VkColorComponentFlagBits.VK_COLOR_COMPONENT_B_BIT | 
			VkColorComponentFlagBits.VK_COLOR_COMPONENT_A_BIT;
	colorBlendAttachment.blendEnable = VkFalse;
	colorBlendAttachment.srcColorBlendFactor = VkBlendFactor.VK_BLEND_FACTOR_ONE; // Optional
	colorBlendAttachment.dstColorBlendFactor = VkBlendFactor.VK_BLEND_FACTOR_ZERO; // Optional
	colorBlendAttachment.colorBlendOp = VkBlendOp.VK_BLEND_OP_ADD; // Optional
	colorBlendAttachment.srcAlphaBlendFactor = VkBlendFactor.VK_BLEND_FACTOR_ONE; // Optional
	colorBlendAttachment.dstAlphaBlendFactor = VkBlendFactor.VK_BLEND_FACTOR_ZERO; // Optional
	colorBlendAttachment.alphaBlendOp = VkBlendOp.VK_BLEND_OP_ADD; // Optional

	colorBlending := VkPipelineColorBlendStateCreateInfo();
	colorBlending.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO;
	colorBlending.logicOpEnable = VkFalse;
	colorBlending.logicOp = VkLogicOp.VK_LOGIC_OP_COPY; // Optional
	colorBlending.attachmentCount = uint32(1);
	colorBlending.pAttachments = colorBlendAttachment@;
	colorBlending.blendConstants[0] = float32(0.0); // Optional
	colorBlending.blendConstants[1] = float32(0.0); // Optional
	colorBlending.blendConstants[2] = float32(0.0); // Optional
	colorBlending.blendConstants[3] = float32(0.0); // Optional

	pipelineLayoutInfo := VkPipelineLayoutCreateInfo();
	pipelineLayoutInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
	pipelineLayoutInfo.setLayoutCount = uint32(0); // Optional
	pipelineLayoutInfo.pSetLayouts = null; // Optional
	pipelineLayoutInfo.pushConstantRangeCount = uint32(0); // Optional
	pipelineLayoutInfo.pPushConstantRanges = null; // Optional

	CheckResult(
		vkCreatePipelineLayout(this.device, pipelineLayoutInfo@, null, this.pipelineLayout@),
		"Error creating Vulkan pipeline layout"
	);

	dynamicStates := [VkDynamicState.VK_DYNAMIC_STATE_VIEWPORT, VkDynamicState.VK_DYNAMIC_STATE_SCISSOR];
	dynamicState := VkPipelineDynamicStateCreateInfo();
	dynamicState.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO;
	dynamicState.dynamicStateCount = uint32(2);
	dynamicState.pDynamicStates = fixed dynamicStates;

	pipelineInfo := VkGraphicsPipelineCreateInfo();
	pipelineInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO;
	pipelineInfo.stageCount = uint32(2);
	pipelineInfo.pStages = fixed shaderStages;
	pipelineInfo.pVertexInputState = vertexInputInfo@;
	pipelineInfo.pInputAssemblyState = inputAssembly@;
	pipelineInfo.pViewportState = viewportState@;
	pipelineInfo.pRasterizationState = rasterizer@;
	pipelineInfo.pMultisampleState = multisampling@;
	pipelineInfo.pDepthStencilState = null; // Optional
	pipelineInfo.pColorBlendState = colorBlending@;
	pipelineInfo.pDynamicState = dynamicState@;
	pipelineInfo.layout = this.pipelineLayout;
	pipelineInfo.renderPass = this.renderPass;
	pipelineInfo.subpass = uint32(0);
	pipelineInfo.basePipelineHandle = null; // Optional
	pipelineInfo.basePipelineIndex = int32(-1); // Optional

	CheckResult(
		vkCreateGraphicsPipelines(this.device, null, uint32(1), pipelineInfo@, null, this.pipeline@),
		"Error creating Vulkan pipeline"
	);
}

*VkShaderModule_T VulkanRenderer::CreateShaderModule(byteCode: string)
{
	shaderCreateInfo := VkShaderModuleCreateInfo();
	shaderCreateInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
	shaderCreateInfo.codeSize = byteCode.count;
	shaderCreateInfo.pCode = byteCode[0] as *uint32;

	shaderModule := null as *VkShaderModule_T;
	CheckResult(
		vkCreateShaderModule(this.device, shaderCreateInfo@, null, shaderModule@),
		"Error creating Vulkan shader module"
	);
	return shaderModule;
}

VulkanRenderer::InitializeFrameBuffers()
{
	this.frameBufferCount = this.swapChainImageCount;
	this.frameBuffers.Alloc(this.frameBufferCount);

	for (i .. this.frameBufferCount)
	{
		framebufferInfo := VkFramebufferCreateInfo();
		framebufferInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO;
		framebufferInfo.renderPass = this.renderPass;
		framebufferInfo.attachmentCount = uint32(1);
		framebufferInfo.pAttachments = this.swapChainImageViews[i];
		framebufferInfo.width = this.swapChainExtent.width;
		framebufferInfo.height = this.swapChainExtent.height;
		framebufferInfo.layers = uint32(1);

		CheckResult(
			vkCreateFramebuffer(this.device, framebufferInfo@, null, this.frameBuffers[i]),
			"Error creating Vulkan frame buffer"
		);
	}
}

VulkanRenderer::InitializeCommandPool()
{
	poolInfo := VkCommandPoolCreateInfo();
	poolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
	poolInfo.flags = VkCommandPoolCreateFlagBits.VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
	poolInfo.queueFamilyIndex = this.graphicsQueueIndices[0]~;

	CheckResult(
		vkCreateCommandPool(this.device, poolInfo@, null, this.commandPool@),
		"Error creating Vulkan command pool"
	);
}

VulkanRenderer::InitializeCommandBuffer()
{
	allocInfo := VkCommandBufferAllocateInfo();
	allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
	allocInfo.commandPool = this.commandPool;
	allocInfo.level = VkCommandBufferLevel.VK_COMMAND_BUFFER_LEVEL_PRIMARY;
	allocInfo.commandBufferCount = uint32(1);

	CheckResult(
		vkAllocateCommandBuffers(this.device, allocInfo@, this.commandBuffer@),
		"Error creating Vulkan command buffer"
	);
}

VulkanRenderer::InitializeSyncObjects()
{
	semaphoreInfo := VkSemaphoreCreateInfo();
	semaphoreInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;

	fenceInfo := VkFenceCreateInfo();
	fenceInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
	fenceInfo.flags = VkFenceCreateFlagBits.VK_FENCE_CREATE_SIGNALED_BIT;

	imageResult := vkCreateSemaphore(this.device, semaphoreInfo@, null, this.imageAvailableSemaphore@);
	renderResult := vkCreateSemaphore(this.device, semaphoreInfo@, null, this.renderFinishedSemaphore@);
	inFlightResult := vkCreateFence(this.device, fenceInfo@, null, this.inFlightFence@);

	errMsg := "Error creating Vulkan synchronization objects";
	CheckResult(imageResult, errMsg);
	CheckResult(renderResult, errMsg);
	CheckResult(inFlightResult, errMsg);
}

VulkanRenderer::RecordCommandBuffer(commandBuffer: *VkCommandBuffer_T, imageIndex: uint32)
{
	beginInfo := VkCommandBufferBeginInfo();
	beginInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
	beginInfo.flags = uint32(0); // Optional
	beginInfo.pInheritanceInfo = null; // Optional

	CheckResult(
		vkBeginCommandBuffer(commandBuffer, beginInfo@), 
		"Error beginning Vulkan command buffer recording"
	);

	renderPassInfo := VkRenderPassBeginInfo();
	renderPassInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO;
	renderPassInfo.renderPass = this.renderPass;
	renderPassInfo.framebuffer = this.frameBuffers[imageIndex]~;
	renderPassInfo.renderArea.offset = {uint32(0), uint32(0)};
	renderPassInfo.renderArea.extent = this.swapChainExtent;

	clearColor := [float32(0.0), float32(0.0), float32(0.0), float32(0.0)]
	renderPassInfo.clearValueCount = uint32(1);
	renderPassInfo.pClearValues = clearColor@;

	vkCmdBeginRenderPass(commandBuffer, renderPassInfo@, VkSubpassContents.VK_SUBPASS_CONTENTS_INLINE);

	{
		vkCmdBindPipeline(
			commandBuffer, 
			VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS, 
			this.pipeline
		);

		viewport := VkViewport();
		viewport.x = float32(0.0);
		viewport.y = float32(0.0);
		viewport.width = this.swapChainExtent.width as float32;
		viewport.height = this.swapChainExtent.height as float32;
		viewport.minDepth = float32(0.0);
		viewport.maxDepth = float32(1.0);
		vkCmdSetViewport(commandBuffer, uint32(0), uint32(1), viewport@);

		scissor := VkRect2D();
        scissor.offset = {uint32(0), uint32(0)};
        scissor.extent = this.swapChainExtent;
        vkCmdSetScissor(commandBuffer, uint32(0), uint32(1), scissor@);

		vkCmdDraw(commandBuffer, uint32(3), uint32(1), uint32(0), uint32(0));
	}

	vkCmdEndRenderPass(commandBuffer);
	CheckResult(vkEndCommandBuffer(commandBuffer), "Error recording Vulkan command buffer");
}

UINT64_MAX := uint64(-1);

VulkanRenderer::DrawFrame()
{
	vkWaitForFences(this.device, uint32(1), this.inFlightFence@, VkTrue, UINT64_MAX);
	vkResetFences(this.device, uint32(1), this.inFlightFence@);

	imageIndex := uint32(0);
    vkAcquireNextImageKHR(
		this.device, 
		this.swapChain, 
		UINT64_MAX, 
		this.imageAvailableSemaphore, 
		null, 
		imageIndex@
	);

	vkResetCommandBuffer(this.commandBuffer, uint32(0));
	this.RecordCommandBuffer(this.commandBuffer, imageIndex);

	waitSemaphores := [this.imageAvailableSemaphore,];
	waitStages := [VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,];
	signalSemaphores := [this.renderFinishedSemaphore,];
	swapChains := [this.swapChain,];

	submitInfo := VkSubmitInfo();
	submitInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SUBMIT_INFO;
	submitInfo.waitSemaphoreCount = 1;
	submitInfo.pWaitSemaphores = fixed waitSemaphores;
	submitInfo.pWaitDstStageMask = fixed waitStages;
	submitInfo.commandBufferCount = 1;
	submitInfo.pCommandBuffers = this.commandBuffer@;
	submitInfo.signalSemaphoreCount = 1;
	submitInfo.pSignalSemaphores = fixed signalSemaphores;

	CheckResult(
		vkQueueSubmit(this.GraphicsQueue(), uint32(1), submitInfo@, this.inFlightFence),
		"Error submitting Vulkan draw command buffer"
	);

	presentInfo := VkPresentInfoKHR();
	presentInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_PRESENT_INFO_KHR;
	presentInfo.waitSemaphoreCount = 1;
	presentInfo.pWaitSemaphores = fixed signalSemaphores;
	presentInfo.swapchainCount = 1;
	presentInfo.pSwapchains = fixed swapChains;
	presentInfo.pImageIndices = imageIndex@;
	presentInfo.pResults = null; // Optional

	vkQueuePresentKHR(this.PresentationQueue(), presentInfo@);
}

VulkanRenderer::Destroy()
{
	vkDeviceWaitIdle(this.device);

	vkDestroySemaphore(this.device, this.imageAvailableSemaphore, null);
    vkDestroySemaphore(this.device, this.renderFinishedSemaphore, null);
    vkDestroyFence(this.device, this.inFlightFence, null);

	vkDestroyCommandPool(this.device, this.commandPool, null);

	for (i .. this.frameBufferCount)
	{
		vkDestroyFramebuffer(this.device, this.frameBuffers[i]~, null);
	}

	vkDestroyPipeline(this.device, this.pipeline, null);
	vkDestroyPipelineLayout(this.device, this.pipelineLayout, null);
	vkDestroyRenderPass(this.device, this.renderPass, null);

	for (i .. this.swapChainImageCount) 
	{
		vkDestroyImageView(this.device, this.swapChainImageViews[i]~, null);
	}

	vkDestroySwapchainKHR(this.device, this.swapChain, null);
	vkDestroyDevice(this.device, null);

	vkDestroySurfaceKHR(this.vkInstance.instance, this.surface, null);
	vkDestroyInstance(this.vkInstance.instance, null);
}