package VulkanRenderer

state VulkanSwapchain
{
	swapchain: *VkSwapchainKHR_T,
	images: Allocator<*VkImage_T>,
	imageViews: Allocator<*VkImageView_T>,

	extent: VkExtent2D,

	imageFormat: VkFormat,
	colorSpace: VkColorSpaceKHR,

	imageCount: uint32,
	imageViewCount: uint32,
}

VulkanSwapchain::SelectFormat(renderer: *VulkanRenderer)
{
	this.imageFormat = VkFormat.VK_FORMAT_B8G8R8A8_UNORM;
}

VulkanSwapchain::SelectColorSpace(renderer: *VulkanRenderer)
{
	this.colorSpace = VkColorSpaceKHR.VK_COLOR_SPACE_SRGB_NONLINEAR_KHR;
}

VulkanSwapchain::Initialize(renderer: *VulkanRenderer)
{
	surfaceCapabilities := VkSurfaceCapabilitiesKHR();
	CheckResult(
		vkGetPhysicalDeviceSurfaceCapabilitiesKHR(
			renderer.device.GetPhysicalDevice(),
			renderer.surface,
			surfaceCapabilities@
		),
		"Error querying physical device surface capabilities"
	);

	log "Surface capabilities: ", surfaceCapabilities;

	this.SelectFormat(renderer);
	this.SelectColorSpace(renderer);

	this.imageCount = surfaceCapabilities.minImageCount;
	if (surfaceCapabilities.maxImageCount && this.imageCount > surfaceCapabilities.maxImageCount)
	{
		this.imageCount = surfaceCapabilities.maxImageCount;
	}

	queueFamilyIndices := [renderer.device.queues.presentQueueIndex, renderer.device.queues.graphicsQueueIndex];

	createInfo := VkSwapchainCreateInfoKHR();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
	createInfo.surface = renderer.surface;
	createInfo.minImageCount = this.imageCount;
	createInfo.imageFormat = this.imageFormat;
	createInfo.imageColorSpace = this.colorSpace;
	createInfo.imageExtent = surfaceCapabilities.currentExtent;
	createInfo.imageArrayLayers = 1;
	createInfo.imageUsage = VkImageUsageFlagBits.VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT;

	if (renderer.device.queues.presentQueueIndex == renderer.device.queues.graphicsQueueIndex)
	{
		createInfo.imageSharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;
	}
	else
	{
		createInfo.imageSharingMode = VkSharingMode.VK_SHARING_MODE_CONCURRENT;
		createInfo.queueFamilyIndexCount = 2;
		createInfo.pQueueFamilyIndices = fixed queueFamilyIndices;
	}

	createInfo.preTransform = surfaceCapabilities.currentTransform;
	createInfo.compositeAlpha = VkCompositeAlphaFlagBitsKHR.VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR;
	createInfo.presentMode = VkPresentModeKHR.VK_PRESENT_MODE_FIFO_KHR;
	createInfo.clipped = VkTrue;

	CheckResult(
		vkCreateSwapchainKHR(renderer.device.device, createInfo@, null, this.swapchain@),
		"Error creating swapchain"
	);
	log "Created swapchain";

	vkGetSwapchainImagesKHR(renderer.device.device, this.swapchain, this.imageCount@, null);
	this.images.Alloc(this.imageCount);
	vkGetSwapchainImagesKHR(renderer.device.device, this.swapchain, this.imageCount@, this.images[0]);

	this.imageViews.Alloc(this.imageCount);
	for (i .. this.imageCount)
	{
		image := this.images[i]~;

		viewInfo := VkImageViewCreateInfo();
		viewInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
		viewInfo.image = image;
		viewInfo.viewType = VkImageViewType.VK_IMAGE_VIEW_TYPE_2D;
		viewInfo.format = this.SelectFormat(renderer);
		
		viewInfo.components.r = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_IDENTITY;
        viewInfo.components.g = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_IDENTITY;
        viewInfo.components.b = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_IDENTITY;
        viewInfo.components.a = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_IDENTITY;
		
		viewInfo.subresourceRange.aspectMask = VkImageAspectFlagBits.VK_IMAGE_ASPECT_COLOR_BIT;
		viewInfo.subresourceRange.baseMipLevel = 0;
		viewInfo.subresourceRange.levelCount = 1;
		viewInfo.subresourceRange.baseArrayLayer = 0;
		viewInfo.subresourceRange.layerCount = 1;

		CheckResult(
			vkCreateImageView(renderer.device.device, viewInfo@, null, this.imageViews[i]),
			"Error creating image view"
		);
	}
	log "Created image views";
}