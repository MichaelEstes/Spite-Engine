package VulkanRenderer

state VulkanSwapchain
{
	swapchain: *VkSwapchainKHR_T,
	images: Allocator<*VkImage_T>,
	imageViews: Allocator<*VkImageView_T>,

	extent: VkExtent2D,

	imageCount: uint32,
	imageViewCount: uint32,
}

VkFormat VulkanSwapchain::SelectFormat(renderer: *VulkanRenderer)
{
	return VkFormat.VK_FORMAT_B8G8R8A8_UNORM;
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

	this.imageCount = surfaceCapabilities.minImageCount;
	if (surfaceCapabilities.maxImageCount && this.imageCount > surfaceCapabilities.maxImageCount)
	{
		this.imageCount = surfaceCapabilities.maxImageCount;
	}

	createInfo := VkSwapchainCreateInfoKHR();
	createInfo.surface = renderer.surface;
	createInfo.minImageCount = this.imageCount;
	createInfo.imageFormat = this.SelectFormat(renderer);
}