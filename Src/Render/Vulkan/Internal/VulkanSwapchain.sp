package VulkanRenderer

InvalidSwapchainIndex := uint32(-1);

state VulkanSwapchain
{
	swapchain: *VkSwapchainKHR_T,
	images: Allocator<*VkImage_T>,
	imageViews: Allocator<*VkImageView_T>,

	imageSemaphores: [FrameCount]*VkSemaphore_T,

	extent: VkExtent2D,

	imageFormat: VkFormat,
	colorSpace: VkColorSpaceKHR,

	imageCount: uint32
	currentImage: uint32
}

VulkanSwapchain::SelectFormat(renderer: *VulkanRenderer)
{
	surfaceFormats := Allocator<VkSurfaceFormatKHR>();
	surfaceFormatCount := uint32(0);
	vkGetPhysicalDeviceSurfaceFormatsKHR(
		renderer.deviceProps.GetPhysicalDevice(), 
		renderer.surface,
		surfaceFormatCount@, 
		null
	);
	if (surfaceFormatCount)
	{
		surfaceFormats.Alloc(surfaceFormatCount);
		vkGetPhysicalDeviceSurfaceFormatsKHR(
			renderer.deviceProps.GetPhysicalDevice(), 
			renderer.surface,
			surfaceFormatCount@, 
			surfaceFormats[0]
		);
	}

	for (i .. surfaceFormatCount)
	{
		surfaceFormat := surfaceFormats[i];
		if (surfaceFormat.format == VkFormat.VK_FORMAT_B8G8R8A8_SRGB &&
			surfaceFormat.colorSpace == VkColorSpaceKHR.VK_COLOR_SPACE_SRGB_NONLINEAR_KHR)
		{
			this.imageFormat = surfaceFormat.format;
			this.colorSpace = surfaceFormat.colorSpace;
			log "Found preferred swapchain format";
			return;
		}
	}

	log "Using default swapchain format";
	this.imageFormat = VkFormat.VK_FORMAT_B8G8R8A8_UNORM;
	this.colorSpace = VkColorSpaceKHR.VK_COLOR_SPACE_SRGB_NONLINEAR_KHR;
}

VulkanSwapchain::SelectSwapExtent(renderer: *VulkanRenderer, capabilities: VkSurfaceCapabilitiesKHR)
{
	if(capabilities.currentExtent.width != uint32(-1))
	{
		this.extent = capabilities.currentExtent;
		log "Using current swapchain extent";
	}
	else
	{
		width := uint32(0);
		height := uint32(0);
		SDL.GetWindowSizeInPixels(
			renderer.window,
			width@,
			height@
		);

		extent := VkExtent2D();
		extent.width = Math.Clamp(width, capabilities.minImageExtent.width, capabilities.maxImageExtent.width);
		extent.height = Math.Clamp(height, capabilities.minImageExtent.height, capabilities.maxImageExtent.height);
		this.extent = extent;
		log "Using extent from window";
	}
}

VulkanSwapchain::Create(renderer: *VulkanRenderer)
{
	surfaceCapabilities := VkSurfaceCapabilitiesKHR();
	CheckResult(
		vkGetPhysicalDeviceSurfaceCapabilitiesKHR(
			renderer.deviceProps.GetPhysicalDevice(),
			renderer.surface,
			surfaceCapabilities@
		),
		"Error querying physical device surface capabilities"
	);

	//log "Surface capabilities: ", surfaceCapabilities;

	this.SelectFormat(renderer);
	this.SelectSwapExtent(renderer, surfaceCapabilities);

	for (i .. FrameCount)
	{
		this.imageSemaphores[i] = CreateSemaphore(renderer.device);
	}

	queueFamilyIndices := [renderer.deviceProps.queues.presentQueueIndex, renderer.deviceProps.queues.graphicsQueueIndex];

	createInfo := VkSwapchainCreateInfoKHR();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR;
	createInfo.surface = renderer.surface;
	createInfo.minImageCount = FrameCount;
	createInfo.imageFormat = this.imageFormat;
	createInfo.imageColorSpace = this.colorSpace;
	createInfo.imageExtent = this.extent;
	createInfo.imageArrayLayers = 1;
	createInfo.imageUsage = VkImageUsageFlagBits.VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT | 
							VkImageUsageFlagBits.VK_IMAGE_USAGE_TRANSFER_DST_BIT;

	if (renderer.deviceProps.queues.presentQueueIndex == renderer.deviceProps.queues.graphicsQueueIndex)
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
		vkCreateSwapchainKHR(renderer.device, createInfo@, null, this.swapchain@),
		"Error creating swapchain"
	);
	log "Created swapchain";

	vkGetSwapchainImagesKHR(renderer.device, this.swapchain, this.imageCount@, null);
	this.images.Alloc(this.imageCount);
	vkGetSwapchainImagesKHR(renderer.device, this.swapchain, this.imageCount@, this.images[0]);

	this.imageViews.Alloc(this.imageCount);
	for (i .. this.imageCount)
	{
		image := this.images[i]~;

		viewInfo := VkImageViewCreateInfo();
		viewInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
		viewInfo.image = image;
		viewInfo.viewType = VkImageViewType.VK_IMAGE_VIEW_TYPE_2D;
		viewInfo.format = this.imageFormat;
		
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
			vkCreateImageView(renderer.device, viewInfo@, null, this.imageViews[i]),
			"Error creating image view"
		);
	}

	log "Created swapchain image views";
}

VkResult VulkanSwapchain::AcquireNext(device: *VkDevice_T, frame: uint32)
{
	return vkAcquireNextImageKHR(
		device, 
		this.swapchain, 
		UINT64_MAX, 
		this.imageSemaphores[frame], 
		null, 
		this.currentImage@
	);
}

*VkImage_T VulkanSwapchain::GetCurrentSwapchainImage()
{
	return this.images[this.currentImage]~;
}

VkResult VulkanSwapchain::Present(presentQueue: *VkQueue_T, frame: uint32)
{
	presentInfo := VkPresentInfoKHR();
	presentInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_PRESENT_INFO_KHR;
	presentInfo.waitSemaphoreCount = 1;
	presentInfo.pWaitSemaphores = this.imageSemaphores[frame]@;
	presentInfo.swapchainCount = 1;
	presentInfo.pSwapchains = this.swapchain@;
	presentInfo.pImageIndices = this.currentImage@;
	presentInfo.pResults = null; 

	return vkQueuePresentKHR(presentQueue, presentInfo@);
}
