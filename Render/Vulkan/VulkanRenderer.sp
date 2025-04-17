package VulkanRenderer

import OS
import Math
import Vulkan
import SDL
import Image
import SparseSet
import Event
import Vertex
import UniformBufferObject
import Time
import FixedArray

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
renderersByWindow := SparseSet<VulkanRenderer<>>();

CheckResult(result: VkResult, errorMsg: string)
{
	if (result != VkResult.VK_SUCCESS)
	{
		log errorMsg;
	}
}

Render()
{
	for (renderer in renderersByWindow.Values()) renderer.DrawFrame();
}

Destroy()
{
	for (renderer in renderersByWindow.Values()) renderer.Destroy();
}

state VulkanRenderer<FramesInFlight = 2>
{
	vkInstance: *VulkanInstance,
	
	window: *SDL.Window,
	device: *VkDevice_T,
	surface: *VkSurfaceKHR_T,
	swapChain: *VkSwapchainKHR_T,
	descriptorSetLayout: *VkDescriptorSetLayout_T,
	pipelineLayout: *VkPipelineLayout_T,
	renderPass: *VkRenderPass_T,
	pipeline: *VkPipeline_T,
	graphicsCommandPool: *VkCommandPool_T,
	transferCommandPool: *VkCommandPool_T,
	commandBuffers: [FramesInFlight]*VkCommandBuffer_T,
	vertexBuffer: *VkBuffer_T,
	vertexBufferMemory: *VkDeviceMemory_T,
	indexBuffer: *VkBuffer_T,
	indexBufferMemory: *VkDeviceMemory_T,

	textureImage: *VkImage_T,
	textureImageMemory: *VkDeviceMemory_T,
	textureImageView: *VkImageView_T,
	textureSampler: *VkSampler_T,

	depthImage: *VkImage_T,
	depthImageMemory: *VkDeviceMemory_T,
	depthImageView: *VkImageView_T,

	uniformBuffers: [FramesInFlight]*VkBuffer_T,
	uniformBuffersMemory: [FramesInFlight]*VkDeviceMemory_T,
	uniformBuffersMapped: [FramesInFlight]*void,
	
	descriptorPool: *VkDescriptorPool_T,
	descriptorSets: [FramesInFlight]*VkDescriptorSet_T,

	physicalDevice: *VkPhysicalDevice_T,
	currentDeviceFeatures: VkPhysicalDeviceFeatures,
	currentDeviceProperties: VkPhysicalDeviceProperties,

	queueFamilies: Allocator<VkQueueFamilyProperties>,
	graphicsQueueIndices: Allocator<uint32>,
	presentationQueueIndices: Allocator<uint32>,

	graphicsQueues: Allocator<*VkQueue_T>,
	presentationQueues: Allocator<*VkQueue_T>,
	transferQueue: *VkQueue_T,

	surfaceCapabilities: VkSurfaceCapabilitiesKHR,
	surfaceFormats: Allocator<VkSurfaceFormatKHR>,
	presentModes: Allocator<VkPresentModeKHR>,

	swapChainImages: Allocator<*VkImage_T>,
	swapChainExtent: VkExtent2D,
	swapChainImageFormat: VkFormat,

	swapChainImageViews: Allocator<*VkImageView_T>,

	frameBuffers: Allocator<*VkFramebuffer_T>,

	imageAvailableSemaphores: [FramesInFlight]*VkSemaphore_T,
	renderFinishedSemaphores: [FramesInFlight]*VkSemaphore_T,
	inFlightFences: [FramesInFlight]*VkFence_T,

	queueFamilyCount: uint32,
	graphicsQueueCount: uint32,
	presentationQueueCount: uint32,
	transferQueueIndex: uint32,
	surfaceFormatCount: uint32,
	presentModeCount: uint32,
	swapChainImageCount: uint32,
	swapChainImageViewCount: uint32,
	frameBufferCount: uint32,

	currentFrame: uint32,
}

*VkQueue_T VulkanRenderer::GraphicsQueue() => this.graphicsQueues[0]~;
*VkQueue_T VulkanRenderer::PresentationQueue() => this.presentationQueues[0]~;

VulkanRenderer::DebugLogExtensions()
{
	extCount := uint32(0);
	vkEnumerateDeviceExtensionProperties(this.physicalDevice, null, extCount@, null);
	log "Device ext count: ", extCount;
	extProps := Allocator<VkExtensionProperties>();
	extProps.Alloc(extCount);
	vkEnumerateDeviceExtensionProperties(this.physicalDevice, null, extCount@, extProps[0]);
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

*VulkanRenderer<> CreateVulkanRenderer(window: *SDL.Window)
{
	vulkanRenderer := renderersByWindow.Emplace(window.id);
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
	vulkanRenderer.InitializeDescriptorSetLayout();
	vulkanRenderer.InitializePipeline();
	vulkanRenderer.InitializeFrameBuffers();
	vulkanRenderer.InitializeCommandPool();
	vulkanRenderer.InitializeDepthResources();
	vulkanRenderer.InitializeTextureImage();
	vulkanRenderer.InitializeTextureImageView();
	vulkanRenderer.InitializeTextureSampler();
	vulkanRenderer.InitializeVertexBuffer();
	vulkanRenderer.InitializeIndexBuffer();
	vulkanRenderer.InitializeUniformBuffers();
	vulkanRenderer.InitializeDescriptorPool();
	vulkanRenderer.InitializeDescriptorSets();
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
	this.physicalDevice = this.vkInstance.physicalDevices[0]~;
	vkGetPhysicalDeviceFeatures(this.physicalDevice, this.currentDeviceFeatures@);
	vkGetPhysicalDeviceProperties(this.physicalDevice, this.currentDeviceProperties@);
}

VulkanRenderer::InitializeQueues()
{
	vkGetPhysicalDeviceQueueFamilyProperties(this.physicalDevice, this.queueFamilyCount@, null);
	this.queueFamilies.Alloc(this.queueFamilyCount);
    vkGetPhysicalDeviceQueueFamilyProperties(
		this.physicalDevice, 
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
			this.physicalDevice, 
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
	transferIndex := -1;
	for (i .. this.queueFamilyCount)
	{
		queueFamily := this.queueFamilies[i];
		if (queueFamily.queueFlags & VkQueueFlagBits.VK_QUEUE_GRAPHICS_BIT) 
		{
			this.graphicsQueueIndices[graphicsIndex]~ = i;
			graphicsIndex += 1;
			if (transferIndex == -1)
			{
				transferIndex = i;
			}
		}
		else if (queueFamily.queueFlags & VkQueueFlagBits.VK_QUEUE_TRANSFER_BIT)
		{
			transferIndex = i;
		}

		presentationSupport := uint32(0);
		vkGetPhysicalDeviceSurfaceSupportKHR(
			this.physicalDevice, 
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
	this.transferQueueIndex = transferIndex;
}

{queues: Allocator<uint32>, count: uint32} VulkanRenderer::GetUniqueQueues()
{
	queuesIndices := Allocator<uint32>();
	queuesIndices.Alloc(this.graphicsQueueCount + this.presentationQueueCount + 1);

	count := uint32(0);
	for (i .. this.presentationQueueCount)
	{
		queuesIndices[i]~ = this.presentationQueueIndices[i]~;
		count += 1;
	}

	for (i .. this.graphicsQueueCount)
	{
		queueIndex := this.graphicsQueueIndices[i]~;
		unique := true;
		for (j .. count)
		{
			if (queueIndex == queuesIndices[j]~)
			{
				unique = false;
				break;
			}
		}

		if (unique)
		{
			queuesIndices[count]~ = queueIndex;
			count += 1;
		}
	}

	hasUniqueTransferQueue := true;
	for (i .. count)
	{
		queueIndex := queuesIndices[i]~;
		if (queueIndex == this.transferQueueIndex)
		{
			hasUniqueTransferQueue = false;
			break;
		}
	}

	if (hasUniqueTransferQueue)
	{
		queuesIndices[count]~ = this.transferQueueIndex;
		count += 1;
	}

	return {queuesIndices, count};
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

	deviceFeatures := VkPhysicalDeviceFeatures();
	deviceFeatures.samplerAnisotropy = VkTrue;

	deviceCreateInfo := VkDeviceCreateInfo();
	deviceCreateInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
	deviceCreateInfo.queueCreateInfoCount = uniqueQueues.count;
	deviceCreateInfo.pQueueCreateInfos = queueCreateInfos[0];
	deviceCreateInfo.enabledExtensionCount = requiredDeviceExtensionCount;
	deviceCreateInfo.ppEnabledExtensionNames = fixed requiredDeviceExtensions;
	deviceCreateInfo.pEnabledFeatures = deviceFeatures@;

	CheckResult(
		vkCreateDevice(this.physicalDevice, deviceCreateInfo@, null, this.device@),
		"Error creating a logical Vulkan device"
	);

	this.GetDeviceQueues(
		this.graphicsQueueCount,
		this.graphicsQueueIndices,
		this.graphicsQueues@
	);

	this.GetDeviceQueues(
		this.presentationQueueCount,
		this.presentationQueueIndices,
		this.presentationQueues@
	);

	vkGetDeviceQueue(this.device, this.transferQueueIndex, 0, this.transferQueue@);
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
			this.physicalDevice, 
			this.surface, 
			this.surfaceCapabilities@
		),
		"Error getting device surface capabilities"
	);

	vkGetPhysicalDeviceSurfaceFormatsKHR(
		this.physicalDevice, 
		this.surface,
		this.surfaceFormatCount@, 
		null
	);
	if (this.surfaceFormatCount)
	{
		this.surfaceFormats.Alloc(this.surfaceFormatCount);
		vkGetPhysicalDeviceSurfaceFormatsKHR(
			this.physicalDevice, 
			this.surface,
			this.surfaceFormatCount@, 
			this.surfaceFormats[0]
		);
	}

	vkGetPhysicalDeviceSurfacePresentModesKHR(
		this.physicalDevice, 
		this.surface,
		this.presentModeCount@, 
		null
	);
	if (this.presentModeCount)
	{
		this.presentModes.Alloc(this.presentModeCount);
		vkGetPhysicalDeviceSurfacePresentModesKHR(
			this.physicalDevice, 
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
	swapchainCreateInfo.oldSwapchain = null;

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

VulkanRenderer::InitializeDescriptorSetLayout()
{
	uboLayoutBinding := VkDescriptorSetLayoutBinding();
    uboLayoutBinding.binding = 0;
    uboLayoutBinding.descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
    uboLayoutBinding.descriptorCount = 1;
	uboLayoutBinding.stageFlags = VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT;
	uboLayoutBinding.pImmutableSamplers = null; // Optional

	samplerLayoutBinding := VkDescriptorSetLayoutBinding();
    samplerLayoutBinding.binding = 1;
    samplerLayoutBinding.descriptorCount = 1;
    samplerLayoutBinding.descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
    samplerLayoutBinding.pImmutableSamplers = null;
    samplerLayoutBinding.stageFlags = VkShaderStageFlagBits.VK_SHADER_STAGE_FRAGMENT_BIT;

	bindings := [uboLayoutBinding, samplerLayoutBinding];
	layoutInfo := VkDescriptorSetLayoutCreateInfo();
	layoutInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
	layoutInfo.bindingCount = 2;
	layoutInfo.pBindings = fixed bindings;
	
	CheckResult(
		vkCreateDescriptorSetLayout(this.device, layoutInfo@, null, this.descriptorSetLayout@),
		"Error creating Vulkan descriptor set layout"
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

	bindingDescription := Vertex3BindingDescription();
	attributeDescriptions := Vertex3AttributeDescriptions();
	defer delete attributeDescriptions;

	vertexInputInfo := VkPipelineVertexInputStateCreateInfo();
	vertexInputInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;
	vertexInputInfo.vertexBindingDescriptionCount = uint32(1);
	vertexInputInfo.vertexAttributeDescriptionCount = attributeDescriptions.count;
	vertexInputInfo.pVertexBindingDescriptions = bindingDescription@;
	vertexInputInfo.pVertexAttributeDescriptions = attributeDescriptions[0];

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
	rasterizer.frontFace = VkFrontFace.VK_FRONT_FACE_COUNTER_CLOCKWISE;
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
	pipelineLayoutInfo.setLayoutCount = uint32(1);
	pipelineLayoutInfo.pSetLayouts = this.descriptorSetLayout@;
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
		vkCreateCommandPool(this.device, poolInfo@, null, this.graphicsCommandPool@),
		"Error creating Vulkan graphics command pool"
	);

	poolInfo.queueFamilyIndex = this.transferQueueIndex;
	CheckResult(
		vkCreateCommandPool(this.device, poolInfo@, null, this.transferCommandPool@),
		"Error creating Vulkan transfer command pool"
	);
}

VkFormat VulkanRenderer::FindSupportedFormat(candidates: []VkFormat, tiling: VkImageTiling, features: uint32)
{
	for (format in candidates)
	{
		props := VkFormatProperties();
		vkGetPhysicalDeviceFormatProperties(this.physicalDevice, format, props@);
		if (tiling == VkImageTiling.VK_IMAGE_TILING_LINEAR && 
			(props.linearTilingFeatures & features) == features) 
		{
            return format;
        } 
		else if (tiling == VkImageTiling.VK_IMAGE_TILING_OPTIMAL && 
					(props.optimalTilingFeatures & features) == features) 
		{
            return format;
        }
	}

	return -1
}

VkFormat VulkanRenderer::FindDepthFormat()
{
	return this.FindSupportedFormat(
		[VkFormat.VK_FORMAT_D32_SFLOAT, VkFormat.VK_FORMAT_D32_SFLOAT_S8_UINT, VkFormat.VK_FORMAT_D24_UNORM_S8_UINT],
		VkImageTiling.VK_IMAGE_TILING_OPTIMAL,
		VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_DEPTH_STENCIL_ATTACHMENT_BIT
	);
}

VulkanRenderer::InitializeDepthResources()
{
	depthFormat := this.FindDepthFormat();

	this.CreateImage(
		this.swapChainExtent.width, 
		this.swapChainExtent.height, 
		depthFormat, 
		VkImageTiling.VK_IMAGE_TILING_OPTIMAL, 
		VkImageUsageFlagBits.VK_IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT, 
		VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT, 
		this.depthImage@, 
		this.depthImageMemory@
	);
    this.depthImageView = this.CreateImageView(this.depthImage, depthFormat, VkImageAspectFlagBits.VK_IMAGE_ASPECT_DEPTH_BIT);
}

VulkanRenderer::CreateImage(width: uint32, height: uint32, format: VkFormat, tiling: VkImageTiling,
							usage: uint32, properties: uint32, image: **VkImage_T, imageMemory: **VkDeviceMemory_T)
{
	imageInfo := VkImageCreateInfo();
    imageInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO;
    imageInfo.imageType = VkImageType.VK_IMAGE_TYPE_2D;
    imageInfo.extent.width = width;
    imageInfo.extent.height = height;
    imageInfo.extent.depth = 1;
    imageInfo.mipLevels = 1;
    imageInfo.arrayLayers = 1;
    imageInfo.format = format;
    imageInfo.tiling = tiling;
    imageInfo.initialLayout = VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED;
    imageInfo.usage = usage;
    imageInfo.samples = VkSampleCountFlagBits.VK_SAMPLE_COUNT_1_BIT;
    imageInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

	CheckResult(
		vkCreateImage(this.device, imageInfo@, null, image),
		"Error creating Vulkan image"
	);

	memRequirements := VkMemoryRequirements();
    vkGetImageMemoryRequirements(this.device, image~, memRequirements@);

	allocInfo := VkMemoryAllocateInfo();
    allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
    allocInfo.allocationSize = memRequirements.size;
    allocInfo.memoryTypeIndex = this.FindMemoryType(memRequirements.memoryTypeBits, properties);

	CheckResult(
		vkAllocateMemory(this.device, allocInfo@, null, imageMemory),
		"Error allocating Vulkan image memory"
	);

	vkBindImageMemory(this.device, image~, imageMemory~, 0);
}

VulkanRenderer::InitializeTextureImage()
{
	imageSurface := Image.LoadTextureImage("C:\\Users\\Flynn\\Documents\\Spite Engine\\Render\\Resource\\test.jpg");
	if (!imageSurface)
	{
		log "Error loading texture image";
		return;
	}
	defer SDL.DestroySurface(imageSurface);

	width := imageSurface.w as uint32;
	height := imageSurface.h as uint32;
	pixels := imageSurface.pixels;
	imageSize: uint32 = width * height * 4;

	stagingBuffer: *VkBuffer_T = null;
	stagingBufferMemory: *VkDeviceMemory_T = null;

	this.CreateBuffer(
		imageSize, 
		VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_SRC_BIT, 
		VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT | VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_COHERENT_BIT,
		stagingBuffer@, 
		stagingBufferMemory@
	);

	data := null;
	vkMapMemory(this.device, stagingBufferMemory, 0, imageSize, 0, data@);
    copy_bytes(data, pixels, imageSize);
	vkUnmapMemory(this.device, stagingBufferMemory);
	
	this.CreateImage(
		width, 
		height, 
		VkFormat.VK_FORMAT_R8G8B8A8_SRGB, 
		VkImageTiling.VK_IMAGE_TILING_OPTIMAL, 
		VkImageUsageFlagBits.VK_IMAGE_USAGE_TRANSFER_DST_BIT | VkImageUsageFlagBits.VK_IMAGE_USAGE_SAMPLED_BIT, 
		VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT, 
		this.textureImage@, 
		this.textureImageMemory@
	);

	this.TransitionImageLayout(this.textureImage, VkFormat.VK_FORMAT_R8G8B8A8_SRGB, VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED, VkImageLayout.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL);
	this.CopyBufferToImage(stagingBuffer, this.textureImage, width, height);
	this.TransitionImageLayout(this.textureImage, VkFormat.VK_FORMAT_R8G8B8A8_SRGB, VkImageLayout.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, VkImageLayout.VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL);

	vkDestroyBuffer(this.device, stagingBuffer, null);
    vkFreeMemory(this.device, stagingBufferMemory, null);
}

VulkanRenderer::InitializeTextureImageView()
{
	viewInfo := VkImageViewCreateInfo();
	viewInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
	viewInfo.image = this.textureImage;
	viewInfo.viewType = VkImageViewType.VK_IMAGE_VIEW_TYPE_2D;
	viewInfo.format = VkFormat.VK_FORMAT_R8G8B8A8_SRGB;
	viewInfo.subresourceRange.aspectMask = VkImageAspectFlagBits.VK_IMAGE_ASPECT_COLOR_BIT;
	viewInfo.subresourceRange.baseMipLevel = 0;
	viewInfo.subresourceRange.levelCount = 1;
	viewInfo.subresourceRange.baseArrayLayer = 0;
	viewInfo.subresourceRange.layerCount = 1;

	CheckResult(
		vkCreateImageView(this.device, viewInfo@, null, this.textureImageView@),
		"Error allocating Vulkan image memory"
	);
}

VulkanRenderer::InitializeTextureSampler()
{
	samplerInfo := VkSamplerCreateInfo();
	samplerInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO;
	samplerInfo.magFilter = VkFilter.VK_FILTER_LINEAR;
	samplerInfo.minFilter = VkFilter.VK_FILTER_LINEAR;

	samplerInfo.addressModeU = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_REPEAT;
	samplerInfo.addressModeV = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_REPEAT;
	samplerInfo.addressModeW = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_REPEAT;

	samplerInfo.anisotropyEnable = VkTrue;
	samplerInfo.maxAnisotropy = this.currentDeviceProperties.limits.maxSamplerAnisotropy;

	samplerInfo.borderColor = VkBorderColor.VK_BORDER_COLOR_INT_OPAQUE_BLACK;
	samplerInfo.unnormalizedCoordinates = VkFalse;

	samplerInfo.compareEnable = VkFalse;
	samplerInfo.compareOp = VkCompareOp.VK_COMPARE_OP_ALWAYS;

	samplerInfo.mipmapMode = VkSamplerMipmapMode.VK_SAMPLER_MIPMAP_MODE_LINEAR;
	samplerInfo.mipLodBias = 0.0;
	samplerInfo.minLod = 0.0;
	samplerInfo.maxLod = 0.0;

	CheckResult(
		vkCreateSampler(this.device, samplerInfo@, null, this.textureSampler@),
		"Error creating Vulkan texture sampler"
	);
}

vertices := Vertex3:[
    {{float32(-0.5), float32(-0.5), float32(0.0)}, {float32(1.0), float32(0.0), float32(0.0)}, {float32(1.0), float32(0.0)}},
    {{float32(0.5), float32(-0.5), float32(0.0)},  {float32(0.0), float32(1.0), float32(0.0)}, {float32(0.0), float32(0.0)}},
    {{float32(0.5), float32(0.5), float32(0.0)},   {float32(0.0), float32(0.0), float32(1.0)}, {float32(0.0), float32(1.0)}},
	{{float32(-0.5), float32(0.5), float32(0.0)},  {float32(1.0), float32(1.0), float32(1.0)}, {float32(1.0), float32(1.0)}},

	{{float32(-0.5), float32(-0.5), float32(-0.5)}, {float32(1.0), float32(0.0), float32(0.0)}, {float32(1.0), float32(0.0)}},
    {{float32(0.5), float32(-0.5), float32(-0.5)},  {float32(0.0), float32(1.0), float32(0.0)}, {float32(0.0), float32(0.0)}},
    {{float32(0.5), float32(0.5), float32(-0.5)},   {float32(0.0), float32(0.0), float32(1.0)}, {float32(0.0), float32(1.0)}},
	{{float32(-0.5), float32(0.5), float32(-0.5)},  {float32(1.0), float32(1.0), float32(1.0)}, {float32(1.0), float32(1.0)}},
];
vertexCount := #compile uint32 => (#typeof vertices).FixedArrayCount();

indices := uint16:[
	0, 1, 2, 2, 3, 0,
	4, 5, 6, 6, 7, 4
];
indexCount := #compile uint32 => (#typeof indices).FixedArrayCount();


VulkanRenderer::CreateBuffer(size: uint64, usage: uint32, properties: uint32, buffer: **VkBuffer_T, bufferMemory: **VkDeviceMemory_T)
{
	bufferInfo := VkBufferCreateInfo();
	bufferInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	bufferInfo.size = size;
	bufferInfo.usage = usage;
	bufferInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_CONCURRENT;
	bufferInfo.queueFamilyIndexCount = 2;
	bufferInfo.pQueueFamilyIndices = fixed [this.graphicsQueueIndices[0]~, this.transferQueueIndex];

	CheckResult(
		vkCreateBuffer(this.device, bufferInfo@, null, buffer),
		"Error creating Vulkan command pool"
	);

	memRequirements := VkMemoryRequirements();
	vkGetBufferMemoryRequirements(this.device, buffer~, memRequirements@);

	allocInfo := VkMemoryAllocateInfo();
	allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
	allocInfo.allocationSize = memRequirements.size;
	allocInfo.memoryTypeIndex = this.FindMemoryType(
		memRequirements.memoryTypeBits, 
		VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT | 
		VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_COHERENT_BIT
	);

	CheckResult(
		vkAllocateMemory(this.device, allocInfo@, null, bufferMemory),
		"Error allocating Vulkan vertex buffer memory"
	);

	vkBindBufferMemory(this.device, buffer~, bufferMemory~, 0);
}

*VkCommandBuffer_T VulkanRenderer::BeginSingleTimeCommands()
{
	allocInfo := VkCommandBufferAllocateInfo();
    allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
    allocInfo.level = VkCommandBufferLevel.VK_COMMAND_BUFFER_LEVEL_PRIMARY;
    allocInfo.commandPool = this.transferCommandPool;
    allocInfo.commandBufferCount = 1;

	commandBuffer: *VkCommandBuffer_T = null;
    vkAllocateCommandBuffers(this.device, allocInfo@, commandBuffer@);

	beginInfo := VkCommandBufferBeginInfo();
	beginInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
	beginInfo.flags = VkCommandBufferUsageFlagBits.VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;
	
	vkBeginCommandBuffer(commandBuffer, beginInfo@);

	return commandBuffer;
}

VulkanRenderer::EndSingleTimeCommands(commandBuffer: *VkCommandBuffer_T)
{
	vkEndCommandBuffer(commandBuffer);

	submitInfo := VkSubmitInfo();
	submitInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SUBMIT_INFO;
	submitInfo.commandBufferCount = 1;
	submitInfo.pCommandBuffers = commandBuffer@;
	
	vkQueueSubmit(this.transferQueue, 1, submitInfo@, null);
	vkQueueWaitIdle(this.transferQueue);

	vkFreeCommandBuffers(this.device, this.transferCommandPool, 1, commandBuffer@);
}

VulkanRenderer::CopyBuffer(srcBuffer: *VkBuffer_T, dstBuffer: *VkBuffer_T, size: uint64)
{
	commandBuffer := this.BeginSingleTimeCommands();
	{
		copyRegion := VkBufferCopy();
		copyRegion.srcOffset = 0; // Optional
		copyRegion.dstOffset = 0; // Optional
		copyRegion.size = size;
		vkCmdCopyBuffer(commandBuffer, srcBuffer, dstBuffer, 1, copyRegion@);
	}
	this.EndSingleTimeCommands(commandBuffer);
}

VulkanRenderer::TransitionImageLayout(image: *VkImage_T, format: VkFormat, oldLayout: VkImageLayout, newLayout: VkImageLayout)
{
	commandBuffer := this.BeginSingleTimeCommands();
	{
		barrier := VkImageMemoryBarrier();
		barrier.sType = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
		barrier.oldLayout = oldLayout;
		barrier.newLayout = newLayout;
		barrier.srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
		barrier.dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
		barrier.image = image;
		barrier.subresourceRange.aspectMask = VkImageAspectFlagBits.VK_IMAGE_ASPECT_COLOR_BIT;
		barrier.subresourceRange.baseMipLevel = 0;
		barrier.subresourceRange.levelCount = 1;
		barrier.subresourceRange.baseArrayLayer = 0;
		barrier.subresourceRange.layerCount = 1;

		sourceStage := uint32(0);
		destinationStage := uint32(0);
		if (oldLayout == VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED && 
			newLayout == VkImageLayout.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL) 
		{
			barrier.srcAccessMask = 0;
			barrier.dstAccessMask = VkAccessFlagBits.VK_ACCESS_TRANSFER_WRITE_BIT;

			sourceStage = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT;
			destinationStage = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_TRANSFER_BIT;
		} 
		else if (oldLayout == VkImageLayout.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL && 
				 newLayout == VkImageLayout.VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL) 
		{
		    barrier.srcAccessMask = VkAccessFlagBits.VK_ACCESS_TRANSFER_WRITE_BIT;
		    barrier.dstAccessMask = VkAccessFlagBits.VK_ACCESS_SHADER_READ_BIT;
		
		    sourceStage = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_TRANSFER_BIT;
		    destinationStage = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT;
		} 
		else 
		{
		    log "Unsupported layout transition"
		}

		vkCmdPipelineBarrier(
            commandBuffer,
            sourceStage, 
			destinationStage,
            0,
            0, 
			null,
            0, 
			null,
            1, 
			barrier@
        );
	}
	this.EndSingleTimeCommands(commandBuffer);
}

VulkanRenderer::CopyBufferToImage(buffer: *VkBuffer_T, image: *VkImage_T, width: uint32, height: uint32)
{
	commandBuffer := this.BeginSingleTimeCommands();
	{
		region := VkBufferImageCopy();
		region.bufferOffset = 0;
		region.bufferRowLength = 0;
		region.bufferImageHeight = 0;

		region.imageSubresource.aspectMask = VkImageAspectFlagBits.VK_IMAGE_ASPECT_COLOR_BIT;
		region.imageSubresource.mipLevel = 0;
		region.imageSubresource.baseArrayLayer = 0;
		region.imageSubresource.layerCount = 1;

		region.imageOffset = {int32(0), int32(0), int32(0)};
		region.imageExtent = {
		    width,
		    height,
		    uint32(1)
		};

		vkCmdCopyBufferToImage(
			commandBuffer,
			buffer,
			image,
			VkImageLayout.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL,
			1,
			region@
		);
	}
	this.EndSingleTimeCommands(commandBuffer);
}

VulkanRenderer::InitializeVertexBuffer()
{
	bufferSize := #sizeof(vertices[0]) * vertexCount;

	stagingBuffer: *VkBuffer_T = null;
	stagingBufferMemory: *VkDeviceMemory_T = null;
	this.CreateBuffer(
		bufferSize, 
		VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_SRC_BIT, 
		VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT | VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_COHERENT_BIT, 
		stagingBuffer@, 
		stagingBufferMemory@
	);

	buf := null;
	vkMapMemory(this.device, stagingBufferMemory, 0, bufferSize, 0, buf@);
	copy_bytes(buf, fixed vertices, bufferSize);
	vkUnmapMemory(this.device, stagingBufferMemory);

	this.CreateBuffer(
		bufferSize, 
		VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_DST_BIT | VkBufferUsageFlagBits.VK_BUFFER_USAGE_VERTEX_BUFFER_BIT, 
		VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT, 
		this.vertexBuffer@, 
		this.vertexBufferMemory@
	);

	this.CopyBuffer(stagingBuffer, this.vertexBuffer, bufferSize);
	vkDestroyBuffer(this.device, stagingBuffer, null);
    vkFreeMemory(this.device, stagingBufferMemory, null);
}

VulkanRenderer::InitializeIndexBuffer()
{
	bufferSize := #sizeof(indices[0]) * indexCount;

	stagingBuffer: *VkBuffer_T = null;
	stagingBufferMemory: *VkDeviceMemory_T = null;
	this.CreateBuffer(
		bufferSize, 
		VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_SRC_BIT, 
		VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT | VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_COHERENT_BIT, 
		stagingBuffer@, 
		stagingBufferMemory@
	);

	buf := null;
	vkMapMemory(this.device, stagingBufferMemory, 0, bufferSize, 0, buf@);
	copy_bytes(buf, fixed indices, bufferSize);
	vkUnmapMemory(this.device, stagingBufferMemory);

	this.CreateBuffer(
		bufferSize, 
		VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_DST_BIT | VkBufferUsageFlagBits.VK_BUFFER_USAGE_INDEX_BUFFER_BIT, 
		VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT, 
		this.indexBuffer@, 
		this.indexBufferMemory@
	);

	this.CopyBuffer(stagingBuffer, this.indexBuffer, bufferSize);
	vkDestroyBuffer(this.device, stagingBuffer, null);
    vkFreeMemory(this.device, stagingBufferMemory, null);
}

VulkanRenderer::InitializeUniformBuffers()
{
	bufferSize := #sizeof UniformBufferObject;

	for (i .. FramesInFlight)
	{
		this.CreateBuffer(
			bufferSize, 
			VkBufferUsageFlagBits.VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT, 
			VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT | VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_COHERENT_BIT, 
			this.uniformBuffers[i]@, 
			this.uniformBuffersMemory[i]@
		);

		vkMapMemory(this.device, this.uniformBuffersMemory[i], 0, bufferSize, 0, this.uniformBuffersMapped[i]@);
	}
}

VulkanRenderer::InitializeDescriptorPool()
{
	poolSizes := [VkDescriptorPoolSize(), VkDescriptorPoolSize()];
	poolSizes[0].type = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
	poolSizes[0].descriptorCount = FramesInFlight;

	poolSizes[1].type = VkDescriptorType.VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
	poolSizes[1].descriptorCount = FramesInFlight;

	poolInfo := VkDescriptorPoolCreateInfo();
	poolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
	poolInfo.poolSizeCount = 2;
	poolInfo.pPoolSizes = fixed poolSizes;
	poolInfo.maxSets = FramesInFlight;

	CheckResult(
		vkCreateDescriptorPool(this.device, poolInfo@, null, this.descriptorPool@),
		"Error allocating Vulkan descriptor pool"
	);
}

VulkanRenderer::InitializeDescriptorSets()
{
	layouts := [FramesInFlight]*VkDescriptorSetLayout_T;
	for (i .. FramesInFlight) layouts[i] = this.descriptorSetLayout;

	allocInfo := VkDescriptorSetAllocateInfo();
	allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
	allocInfo.descriptorPool = this.descriptorPool;
	allocInfo.descriptorSetCount = FramesInFlight;
	allocInfo.pSetLayouts = fixed layouts;

	CheckResult(
		vkAllocateDescriptorSets(this.device, allocInfo@, fixed this.descriptorSets),
		"Error allocating Vulkan descriptor sets"
	);

	for (i .. FramesInFlight) 
	{
		bufferInfo := VkDescriptorBufferInfo();
		bufferInfo.buffer = this.uniformBuffers[i];
		bufferInfo.offset = 0;
		bufferInfo.range = #sizeof UniformBufferObject;

		imageInfo := VkDescriptorImageInfo();
        imageInfo.imageLayout = VkImageLayout.VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
        imageInfo.imageView = this.textureImageView;
        imageInfo.sampler = this.textureSampler;

		descriptorWrites := [VkWriteDescriptorSet(), VkWriteDescriptorSet()];

		descriptorWrites[0].sType = VkStructureType.VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
		descriptorWrites[0].dstSet = this.descriptorSets[i];
		descriptorWrites[0].dstBinding = 0;
		descriptorWrites[0].dstArrayElement = 0;
		descriptorWrites[0].descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
		descriptorWrites[0].descriptorCount = 1;
		descriptorWrites[0].pBufferInfo = bufferInfo@;
		descriptorWrites[0].pImageInfo = null; // Optional
		descriptorWrites[0].pTexelBufferView = null; // Optional

		descriptorWrites[1].sType = VkStructureType.VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
        descriptorWrites[1].dstSet = this.descriptorSets[i];
        descriptorWrites[1].dstBinding = 1;
        descriptorWrites[1].dstArrayElement = 0;
        descriptorWrites[1].descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
        descriptorWrites[1].descriptorCount = 1;
        descriptorWrites[1].pImageInfo = imageInfo@;


		vkUpdateDescriptorSets(this.device, 2, fixed descriptorWrites, 0, null);
    }
}

uint32 VulkanRenderer::FindMemoryType(typeFilter: uint32, properties: uint32) 
{
	memProperties := VkPhysicalDeviceMemoryProperties();
	vkGetPhysicalDeviceMemoryProperties(this.physicalDevice, memProperties@);

	for (i .. memProperties.memoryTypeCount)
	{
		if (typeFilter & (1 << i) && 
			(memProperties.memoryTypes[i].propertyFlags & properties) == properties) 
		{
			return i;
		}
	}

	log "Error finding Vulkan memory type";
	return -1;
}

VulkanRenderer::InitializeCommandBuffer()
{
	allocInfo := VkCommandBufferAllocateInfo();
	allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
	allocInfo.commandPool = this.graphicsCommandPool;
	allocInfo.level = VkCommandBufferLevel.VK_COMMAND_BUFFER_LEVEL_PRIMARY;
	allocInfo.commandBufferCount = uint32(2);

	CheckResult(
		vkAllocateCommandBuffers(this.device, allocInfo@, fixed this.commandBuffers),
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

	errMsg := "Error creating Vulkan synchronization objects";
	for (i .. FramesInFlight)
	{
		imageResult := vkCreateSemaphore(this.device, semaphoreInfo@, null, this.imageAvailableSemaphores[i]@);
		renderResult := vkCreateSemaphore(this.device, semaphoreInfo@, null, this.renderFinishedSemaphores[i]@);
		inFlightResult := vkCreateFence(this.device, fenceInfo@, null, this.inFlightFences[i]@);

		CheckResult(imageResult, errMsg);
		CheckResult(renderResult, errMsg);
		CheckResult(inFlightResult, errMsg);
	}
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

		vertexBuffers := [this.vertexBuffer,];
		offsets:= [uint64(0),];
		vkCmdBindVertexBuffers(commandBuffer, uint32(0), uint32(1), fixed vertexBuffers, fixed offsets);
		vkCmdBindIndexBuffer(commandBuffer, this.indexBuffer, 0, VkIndexType.VK_INDEX_TYPE_UINT16);

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

		vkCmdBindDescriptorSets(
			commandBuffer, 
			VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS, 
			this.pipelineLayout, 
			uint32(0), 
			uint32(1), 
			this.descriptorSets[this.currentFrame]@, 
			uint32(0), 
			null
		);
		vkCmdDrawIndexed(commandBuffer, indexCount, uint32(1), uint32(0), uint32(0), uint32(0));
	}

	vkCmdEndRenderPass(commandBuffer);
	CheckResult(vkEndCommandBuffer(commandBuffer), "Error recording Vulkan command buffer");
}

VulkanRenderer::DrawFrame()
{
	vkWaitForFences(this.device, uint32(1), this.inFlightFences[this.currentFrame]@, VkTrue, UINT64_MAX);

	imageIndex := uint32(0);
    imageResult := vkAcquireNextImageKHR(
		this.device, 
		this.swapChain, 
		UINT64_MAX, 
		this.imageAvailableSemaphores[this.currentFrame], 
		null, 
		imageIndex@
	);
	if (imageResult == VkResult.VK_ERROR_OUT_OF_DATE_KHR) 
	{
		this.RecreateSwapchain();
		return;
	}

	this.UpdateUniformBuffer(this.currentFrame);

	vkResetFences(this.device, uint32(1), this.inFlightFences[this.currentFrame]@);

	vkResetCommandBuffer(this.commandBuffers[this.currentFrame], uint32(0));
	this.RecordCommandBuffer(this.commandBuffers[this.currentFrame], imageIndex);

	waitSemaphores := [this.imageAvailableSemaphores[this.currentFrame],];
	waitStages := [VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,];
	signalSemaphores := [this.renderFinishedSemaphores[this.currentFrame],];
	swapChains := [this.swapChain,];

	submitInfo := VkSubmitInfo();
	submitInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SUBMIT_INFO;
	submitInfo.waitSemaphoreCount = uint32(1);
	submitInfo.pWaitSemaphores = fixed waitSemaphores;
	submitInfo.pWaitDstStageMask = fixed waitStages;
	submitInfo.commandBufferCount = uint32(1);
	submitInfo.pCommandBuffers = this.commandBuffers[this.currentFrame]@;
	submitInfo.signalSemaphoreCount = uint32(1);
	submitInfo.pSignalSemaphores = fixed signalSemaphores;

	CheckResult(
		vkQueueSubmit(this.GraphicsQueue(), uint32(1), submitInfo@, this.inFlightFences[this.currentFrame]),
		"Error submitting Vulkan draw command buffer"
	);

	presentInfo := VkPresentInfoKHR();
	presentInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_PRESENT_INFO_KHR;
	presentInfo.waitSemaphoreCount = uint32(1);
	presentInfo.pWaitSemaphores = fixed signalSemaphores;
	presentInfo.swapchainCount = uint32(1);
	presentInfo.pSwapchains = fixed swapChains;
	presentInfo.pImageIndices = imageIndex@;
	presentInfo.pResults = null; // Optional

	presentResult := vkQueuePresentKHR(this.PresentationQueue(), presentInfo@);
	if (presentResult == VkResult.VK_ERROR_OUT_OF_DATE_KHR || presentResult == VkResult.VK_SUBOPTIMAL_KHR)
	{
		this.RecreateSwapchain();
	}
	this.currentFrame = (this.currentFrame + 1) % FramesInFlight;
}

VulkanRenderer::UpdateUniformBuffer(currentFrame: uint32) 
{
	time := Time.TicksSinceStart() / 10000000.0;

	ubo := UniformBufferObject();
	ubo.model.Rotate(time * Math.Deg2Rad(90.0), Vec3(0.0, 0.0, 1.0) as Norm<Vec3>);
	ubo.view.LookAt(Vec3(2.0, 2.0, 2.0), Vec3(0.0, 0.0, 0.0), Vec3(0.0, 0.0, 1.0));
	ubo.projection.Perspective(
		Math.Deg2Rad(45.0), 
		this.swapChainExtent.width as float / this.swapChainExtent.height as float32, 
		0.1, 
		10.0
	);
	ubo.projection[1][1] *= -1;

	copy_bytes(this.uniformBuffersMapped[currentFrame], ubo@, (#sizeof ubo));
}

VulkanRenderer::RecreateSwapchain()
{
	vkDeviceWaitIdle(this.device);

	this.DestroySwapchain();

	this.InitializeSwapchain();
	this.InitializeImageViews();
	this.InitializeFrameBuffers();
}

VulkanRenderer::DestroySwapchain()
{
	for (i .. this.frameBufferCount)
	{
		vkDestroyFramebuffer(this.device, this.frameBuffers[i]~, null);
	}

	for (i .. this.swapChainImageCount) 
	{
		vkDestroyImageView(this.device, this.swapChainImageViews[i]~, null);
	}

	vkDestroySwapchainKHR(this.device, this.swapChain, null);
}

VulkanRenderer::Destroy()
{
	vkDeviceWaitIdle(this.device);

	this.DestroySwapchain();

	vkDestroyPipeline(this.device, this.pipeline, null);
	vkDestroyPipelineLayout(this.device, this.pipelineLayout, null);
	vkDestroyRenderPass(this.device, this.renderPass, null);

	for (i .. FramesInFlight)
	{
		vkDestroyBuffer(this.device, this.uniformBuffers[i], null);
        vkFreeMemory(this.device, this.uniformBuffersMemory[i], null);
	}

	vkDestroyDescriptorPool(this.device, this.descriptorPool, null);

	vkDestroySampler(this.device, this.textureSampler, null);
	vkDestroyImageView(this.device, this.textureImageView, null);

	vkDestroyImage(this.device, this.textureImage, null);
    vkFreeMemory(this.device, this.textureImageMemory, null);

	vkDestroyDescriptorSetLayout(this.device, this.descriptorSetLayout, null);

	vkDestroyBuffer(this.device, this.indexBuffer, null);
	vkFreeMemory(this.device, this.indexBufferMemory, null);

	vkDestroyBuffer(this.device, this.vertexBuffer, null);
	vkFreeMemory(this.device, this.vertexBufferMemory, null);

	for (i .. FramesInFlight)
	{
		vkDestroySemaphore(this.device, this.imageAvailableSemaphores[i], null);
		vkDestroySemaphore(this.device, this.renderFinishedSemaphores[i], null);
		vkDestroyFence(this.device, this.inFlightFences[i], null);
	}

	vkDestroyCommandPool(this.device, this.graphicsCommandPool, null);
	vkDestroyCommandPool(this.device, this.transferCommandPool, null);

	vkDestroyDevice(this.device, null);

	vkDestroySurfaceKHR(this.vkInstance.instance, this.surface, null);
	vkDestroyInstance(this.vkInstance.instance, null);
}