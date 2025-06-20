package VulkanRenderer

state VulkanImage
{
	image: *VkImage_T,
	imageView: *VkImageView_T,
	memory: *VkDeviceMemory_T,

	width: uint32,
	height: uint32,
	format: VkFormat
}

VulkanImage::CreateAlloc(renderer: *VulkanRenderer, width: uint32, height: uint32, format: VkFormat, usage: uint32, properties: uint32, 
						 aspectMask: uint32 = VkImageAspectFlagBits.VK_IMAGE_ASPECT_COLOR_BIT,
						 tiling: VkImageTiling = VkImageTiling.VK_IMAGE_TILING_OPTIMAL,
						 sharingMode: VkSharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE)
{
	this.Create(renderer, width, height, format, usage, tiling, sharingMode);
	device := renderer.device.device;

	memoryRequirements := VkMemoryRequirements();
	vkGetImageMemoryRequirements(device, this.image, memoryRequirements@);

	allocInfo := VkMemoryAllocateInfo();
	allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
	allocInfo.allocationSize = memoryRequirements.size;
	allocInfo.memoryTypeIndex = FindMemoryType(
		renderer.device.GetPhysicalDevice(),
		memoryRequirements.memoryTypeBits,
		properties
	);

	CheckResult(
		vkAllocateMemory(device, allocInfo@, null, this.memory@),
		"Error allocating Vulkan image memory"
	);

	CheckResult(
		vkBindImageMemory(device, this.image, this.memory, 0),
		"Error binding Vulkan image memory"
	);

	viewCreateInfo := VkImageViewCreateInfo();
	viewCreateInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
	viewCreateInfo.image = this.image;
	viewCreateInfo.viewType = VkImageViewType.VK_IMAGE_VIEW_TYPE_2D;
	viewCreateInfo.format = format;
	
	viewCreateInfo.components.r = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_IDENTITY;
    viewCreateInfo.components.g = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_IDENTITY;
    viewCreateInfo.components.b = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_IDENTITY;
    viewCreateInfo.components.a = VkComponentSwizzle.VK_COMPONENT_SWIZZLE_IDENTITY;
	
	viewCreateInfo.subresourceRange.aspectMask = aspectMask;
	viewCreateInfo.subresourceRange.baseMipLevel = 0;
	viewCreateInfo.subresourceRange.levelCount = 1;
	viewCreateInfo.subresourceRange.baseArrayLayer = 0;
	viewCreateInfo.subresourceRange.layerCount = 1;

	CheckResult(
		vkCreateImageView(device, viewCreateInfo@, null, this.imageView@),
		"Error creating image view"
	);	
}

VulkanImage::Create(renderer: *VulkanRenderer, width: uint32, height: uint32, format: VkFormat, usage: uint32, 
					 aspectMask: uint32 = VkImageAspectFlagBits.VK_IMAGE_ASPECT_COLOR_BIT,
					 tiling: VkImageTiling = VkImageTiling.VK_IMAGE_TILING_OPTIMAL,
					 sharingMode: VkSharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE)
{
	device := renderer.device.device;

	this.width = width;
	this.height = height;
	this.format = format;

	createInfo := VkImageCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO;
	createInfo.imageType = VkImageType.VK_IMAGE_TYPE_2D;
	createInfo.extent.width = width;
	createInfo.extent.height = height;
	createInfo.extent.depth = 1;
	createInfo.mipLevels = 1;
	createInfo.arrayLayers = 1;
	createInfo.format = format;
	createInfo.tiling = tiling;
	createInfo.usage = usage;
	createInfo.sharingMode = sharingMode;
	createInfo.samples = VkSampleCountFlagBits.VK_SAMPLE_COUNT_1_BIT;
	createInfo.initialLayout = VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED;

	CheckResult(
		vkCreateImage(device, createInfo@, null, this.image@),
		"Error creating Vulkan image"
	);
}