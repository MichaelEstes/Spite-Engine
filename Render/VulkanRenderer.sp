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

state VulkanRenderer
{
	window: *SDL.Window,
	vkInstance :*VkInstance_T,
	vkDevice: *VkDevice_T,
	vkSurface: *VkSurfaceKHR_T,
	vkSwapChain: *VkSwapchainKHR_T,
	vkPipelineLayout: *VkPipelineLayout_T,
	vkRenderPass: *VkRenderPass_T,
	vkPipeline: *VkPipeline_T,
	vkCommandPool: *VkCommandPool_T,
	vkCommandBuffer: *VkCommandBuffer_T,

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

	swapChainImages: Allocator<*VkImage_T>,
	swapChainExtent: VkExtent2D,
	swapChainImageFormat: VkFormat,

	swapChainImageViews: Allocator<*VkImageView_T>,

	frameBuffers: Allocator<*VkFramebuffer_T>,

	extensionCount: uint32,
	physicalDeviceCount: uint32,
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
        validationCount,												
        fixed validationLayers,												
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
	InitializeImageViews();
	InitializeRenderPass();
	InitializePipeline();
	InitializeFrameBuffers();
	InitializeCommandPool();
	InitializeCommandBuffer();

	RecordCommandBuffer(vulkanRenderer.vkCommandBuffer, 0);

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

	queueIndices := [vulkanRenderer.graphicsQueueIndices[0]~, vulkanRenderer.presentationQueueIndices[0]~];
	if (vulkanRenderer.GraphicsQueue() != vulkanRenderer.PresentationQueue())
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

	swapchainCreateInfo.preTransform = vulkanRenderer.surfaceCapabilities.currentTransform;
	swapchainCreateInfo.compositeAlpha = VkCompositeAlphaFlagBitsKHR.VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;
	swapchainCreateInfo.presentMode = selectedPresentMode;
	swapchainCreateInfo.clipped = uint32(1);
	swapchainCreateInfo.oldSwapchain = vulkanRenderer.vkSwapChain;

	swapChainResult := vkCreateSwapchainKHR(
		vulkanRenderer.vkDevice,
		swapchainCreateInfo@,
		null,
		vulkanRenderer.vkSwapChain@
	)
	assert swapChainResult == VkResult.VK_SUCCESS, "Error creating Vulkan swap chain";

	vkGetSwapchainImagesKHR(
		vulkanRenderer.vkDevice,
		vulkanRenderer.vkSwapChain,
		vulkanRenderer.swapChainImageCount@,
		null
	);
	vulkanRenderer.swapChainImages.Alloc(vulkanRenderer.swapChainImageCount);
	vkGetSwapchainImagesKHR(
		vulkanRenderer.vkDevice,
		vulkanRenderer.vkSwapChain,
		vulkanRenderer.swapChainImageCount@,
		vulkanRenderer.swapChainImages[0]
	);

	vulkanRenderer.swapChainImageFormat = selectedFormat.format;
	vulkanRenderer.swapChainExtent = selectedExtent;
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

InitializeImageViews()
{
	vulkanRenderer.swapChainImageViews.Alloc(vulkanRenderer.swapChainImageCount);

	for (i .. vulkanRenderer.swapChainImageCount)
	{
		imageViewCreateInfo := VkImageViewCreateInfo();
		imageViewCreateInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
		imageViewCreateInfo.image = vulkanRenderer.swapChainImages[i]~;
		imageViewCreateInfo.viewType = VkImageViewType.VK_IMAGE_VIEW_TYPE_2D;
		imageViewCreateInfo.format = vulkanRenderer.swapChainImageFormat;
		imageViewCreateInfo.components.r = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_IDENTITY;
		imageViewCreateInfo.components.g = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_IDENTITY;
		imageViewCreateInfo.components.b = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_IDENTITY;
		imageViewCreateInfo.components.a = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_IDENTITY;
		imageViewCreateInfo.subresourceRange.aspectMask = VkImageAspectFlagBits.VK_IMAGE_ASPECT_COLOR_BIT;
		imageViewCreateInfo.subresourceRange.baseMipLevel = uint32(0);
		imageViewCreateInfo.subresourceRange.levelCount = uint32(1);
		imageViewCreateInfo.subresourceRange.baseArrayLayer = uint32(0);
		imageViewCreateInfo.subresourceRange.layerCount = uint32(1);

		imageViewResult := vkCreateImageView(
			vulkanRenderer.vkDevice,
			imageViewCreateInfo@,
			null,
			vulkanRenderer.swapChainImageViews[0]
		)
		assert imageViewResult == VkResult.VK_SUCCESS, "Error creating Vulkan image view";
	}
}

InitializeRenderPass()
{
	colorAttachment := VkAttachmentDescription();
    colorAttachment.format = vulkanRenderer.swapChainImageFormat;
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

	renderPassInfo := VkRenderPassCreateInfo();
	renderPassInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
	renderPassInfo.attachmentCount = uint32(1);
	renderPassInfo.pAttachments = colorAttachment@;
	renderPassInfo.subpassCount = uint32(1);
	renderPassInfo.pSubpasses = subpass@;

	result := vkCreateRenderPass(vulkanRenderer.vkDevice, renderPassInfo@, null, vulkanRenderer.vkRenderPass@);
	assert result == VkResult.VK_SUCCESS, "Error creating Vulkan render pass";
}

InitializePipeline()
{
	vertShader := ReadFile("C:\\Users\\Flynn\\Documents\\Spite Engine\\Render\\Shaders\\vert.spv");
	fragShader := ReadFile("C:\\Users\\Flynn\\Documents\\Spite Engine\\Render\\Shaders\\frag.spv");

	vertShaderModule := CreateShaderModule(vertShader);
	fragShaderModule := CreateShaderModule(fragShader);

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
	viewport.width = vulkanRenderer.swapChainExtent.width as float32;
	viewport.height = vulkanRenderer.swapChainExtent.height as float32;
	viewport.minDepth = float32(0.0);
	viewport.maxDepth = float32(1.0);

	scissor := VkRect2D();
	scissor.offset = {int32(0), int32(0)};
	scissor.extent = vulkanRenderer.swapChainExtent;

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

	result := vkCreatePipelineLayout(
		vulkanRenderer.vkDevice, 
		pipelineLayoutInfo@, 
		null,
		vulkanRenderer.vkPipelineLayout@
	);
	assert result == VkResult.VK_SUCCESS, "Error creating Vulkan pipeline layout";

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
	pipelineInfo.layout = vulkanRenderer.vkPipelineLayout;
	pipelineInfo.renderPass = vulkanRenderer.vkRenderPass;
	pipelineInfo.subpass = uint32(0);
	pipelineInfo.basePipelineHandle = null; // Optional
	pipelineInfo.basePipelineIndex = int32(-1); // Optional

	pipelineResult := vkCreateGraphicsPipelines(
		vulkanRenderer.vkDevice, 
		null, 
		uint32(1), 
		pipelineInfo@, 
		null, 
		vulkanRenderer.vkPipeline@
	);
	assert pipelineResult == VkResult.VK_SUCCESS, "Error creating Vulkan pipeline";
}

*VkShaderModule_T CreateShaderModule(byteCode: string)
{
	shaderCreateInfo := VkShaderModuleCreateInfo();
	shaderCreateInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
	shaderCreateInfo.codeSize = byteCode.count;
	shaderCreateInfo.pCode = byteCode[0] as *uint32;

	shaderModule := null as *VkShaderModule_T;
	result := vkCreateShaderModule(vulkanRenderer.vkDevice, shaderCreateInfo@, null, shaderModule@);
	assert result == VkResult.VK_SUCCESS, "Error creating Vulkan shader module";
	return shaderModule;
}

InitializeFrameBuffers()
{
	vulkanRenderer.frameBufferCount = vulkanRenderer.swapChainImageCount;
	vulkanRenderer.frameBuffers.Alloc(vulkanRenderer.frameBufferCount);

	for (i .. vulkanRenderer.frameBufferCount)
	{
		framebufferInfo := VkFramebufferCreateInfo();
		framebufferInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO;
		framebufferInfo.renderPass = vulkanRenderer.vkRenderPass;
		framebufferInfo.attachmentCount = uint32(1);
		framebufferInfo.pAttachments = vulkanRenderer.swapChainImageViews[i];
		framebufferInfo.width = vulkanRenderer.swapChainExtent.width;
		framebufferInfo.height = vulkanRenderer.swapChainExtent.height;
		framebufferInfo.layers = uint32(1);

		result := vkCreateFramebuffer(
			vulkanRenderer.vkDevice,
			framebufferInfo@,
			null,
			vulkanRenderer.frameBuffers[i]
		);
		assert result == VkResult.VK_SUCCESS, "Error creating Vulkan frame buffer";
	}
}

InitializeCommandPool()
{
	poolInfo := VkCommandPoolCreateInfo();
	poolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
	poolInfo.flags = VkCommandPoolCreateFlagBits.VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
	poolInfo.queueFamilyIndex = vulkanRenderer.graphicsQueueIndices[0]~;

	result := vkCreateCommandPool(
		vulkanRenderer.vkDevice,
		poolInfo@,
		null,
		vulkanRenderer.vkCommandPool@
	);
	assert result == VkResult.VK_SUCCESS, "Error creating Vulkan command pool";
}

InitializeCommandBuffer()
{
	allocInfo := VkCommandBufferAllocateInfo();
	allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
	allocInfo.commandPool = vulkanRenderer.vkCommandPool;
	allocInfo.level = VkCommandBufferLevel.VK_COMMAND_BUFFER_LEVEL_PRIMARY;
	allocInfo.commandBufferCount = uint32(1);

	result := vkAllocateCommandBuffers(
		vulkanRenderer.vkDevice,
		allocInfo@,
		vulkanRenderer.vkCommandBuffer@
	);
	assert result == VkResult.VK_SUCCESS, "Error creating Vulkan command buffer";
}

RecordCommandBuffer(commandBuffer: *VkCommandBuffer_T, imageIndex: uint32)
{
	beginInfo := VkCommandBufferBeginInfo();
	beginInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
	beginInfo.flags = uint32(0); // Optional
	beginInfo.pInheritanceInfo = null; // Optional

	result := vkBeginCommandBuffer(commandBuffer, beginInfo@);
	assert result == VkResult.VK_SUCCESS, "Error beginning Vulkan command buffer recording";

	renderPassInfo := VkRenderPassBeginInfo();
	renderPassInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO;
	renderPassInfo.renderPass = vulkanRenderer.vkRenderPass;
	renderPassInfo.framebuffer = vulkanRenderer.frameBuffers[imageIndex]~;
	renderPassInfo.renderArea.offset = {uint32(0), uint32(0)};
	renderPassInfo.renderArea.extent = vulkanRenderer.swapChainExtent;

	clearColor := [float32(0.0), float32(0.0), float32(0.0), float32(0.0)]
	renderPassInfo.clearValueCount = uint32(1);
	renderPassInfo.pClearValues = clearColor@;

	vkCmdBeginRenderPass(commandBuffer, renderPassInfo@, VkSubpassContents.VK_SUBPASS_CONTENTS_INLINE);

	{
		vkCmdBindPipeline(
			commandBuffer, 
			VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS, 
			vulkanRenderer.vkPipeline
		);

		viewport := VkViewport();
		viewport.x = float32(0.0);
		viewport.y = float32(0.0);
		viewport.width = vulkanRenderer.swapChainExtent.width as float32;
		viewport.height = vulkanRenderer.swapChainExtent.height as float32;
		viewport.minDepth = float32(0.0);
		viewport.maxDepth = float32(1.0);
		vkCmdSetViewport(commandBuffer, uint32(0), uint32(1), viewport@);
		log "Setting cmd viewport";
	}
}

DestroyVulkanRenderer()
{
	vkDestroyCommandPool(vulkanRenderer.vkDevice, vulkanRenderer.vkCommandPool, null);
	for (i .. vulkanRenderer.frameBufferCount)
	{
		vkDestroyFramebuffer(vulkanRenderer.vkDevice, vulkanRenderer.frameBuffers[i]~, null);
	}
	vkDestroyPipeline(vulkanRenderer.vkDevice, vulkanRenderer.vkPipeline, null);
	vkDestroyRenderPass(vulkanRenderer.vkDevice, vulkanRenderer.vkRenderPass, null);
	vkDestroyPipelineLayout(vulkanRenderer.vkDevice, vulkanRenderer.vkPipelineLayout, null);
	for (i .. vulkanRenderer.swapChainImageCount) 
	{
		vkDestroyImageView(vulkanRenderer.vkDevice, vulkanRenderer.swapChainImageViews[i]~, null);
	}
	vkDestroySwapchainKHR(vulkanRenderer.vkDevice, vulkanRenderer.vkSwapChain, null);
	vkDestroyDevice(vulkanRenderer.vkDevice, null);
	vkDestroySurfaceKHR(vulkanRenderer.vkInstance, vulkanRenderer.vkSurface, null);
	vkDestroyInstance(vulkanRenderer.vkInstance, null);
}