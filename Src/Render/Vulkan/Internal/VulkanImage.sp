package VulkanRenderer


*VkImage_T CreateVkImage(device: *VkDevice_T, createInfo: VkImageCreateInfo)
{
	image: *VkImage_T = null;
	CheckResult(
		vkCreateImage(device, createInfo@, null, image@),
		"Error creating Vulkan image"
	);

	return image;
}

*VkImageView_T CreateVkImageView(device: *VkDevice_T, createInfo: VkImageViewCreateInfo)
{
	imageView: *VkImageView_T = null;
	CheckResult(
		vkCreateImageView(device, createInfo@, null, imageView@),
		"Error creating Vulkan image view"
	);

	return imageView;
}

*VkDeviceMemory_T CreateDedicatedVkImage(device: *VkDevice_T, physicalDevice: *VkPhysicalDevice_T, 
										 createInfo: VkImageCreateInfo, memoryFlags: uint32)
{
	image := CreateVkImage(device, createInfo);

	memoryRequirements := VkMemoryRequirements();
	vkGetImageMemoryRequirements(device, image, memoryRequirements@);

	allocInfo := VkMemoryAllocateInfo();
	allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
	allocInfo.allocationSize = memoryRequirements.size;
	allocInfo.memoryTypeIndex = FindMemoryType(
		physicalDevice,
		memoryRequirements.memoryTypeBits,
		memoryFlags
	);

	memory: *VkDeviceMemory_T = null;

	CheckResult(
		vkAllocateMemory(device, allocInfo@, null, memory@),
		"Error allocating Vulkan image memory"
	);

	CheckResult(
		vkBindImageMemory(device, image, memory, 0),
		"Error binding Vulkan image memory"
	);

	return memory;
}

imageViewTypesTable := [
	VkImageViewType.VK_IMAGE_VIEW_TYPE_1D,
	VkImageViewType.VK_IMAGE_VIEW_TYPE_2D,
	VkImageViewType.VK_IMAGE_VIEW_TYPE_3D
];

imageViewArrTypesTable := [
	VkImageViewType.VK_IMAGE_VIEW_TYPE_1D_ARRAY,
	VkImageViewType.VK_IMAGE_VIEW_TYPE_2D_ARRAY,
	VkImageViewType.VK_IMAGE_VIEW_TYPE_2D_ARRAY
];

VkImageViewCreateInfo DefaultImageView(image: *VkImage_T, imageInfo: VkImageCreateInfo)
{
	viewCreateInfo := VkImageViewCreateInfo();
	viewCreateInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
	viewCreateInfo.image = image;
	viewCreateInfo.format = imageInfo.format;

	if (imageInfo.arrayLayers > 1)
	{
		viewCreateInfo.viewType = imageViewArrTypesTable[imageInfo.imageType];
	}
	else
	{
		viewCreateInfo.viewType = imageViewTypesTable[imageInfo.imageType];
	}

	aspectMask := VkImageAspectFlagBits.VK_IMAGE_ASPECT_COLOR_BIT;
	if (IsDepthFormat(imageInfo.format)) 
	{
	    aspectMask = VkImageAspectFlagBits.VK_IMAGE_ASPECT_DEPTH_BIT;
	    if (HasStencilComponent(imageInfo.format)) 
			aspectMask |= VkImageAspectFlagBits.VK_IMAGE_ASPECT_STENCIL_BIT;
	}

	viewCreateInfo.subresourceRange.aspectMask = aspectMask;
	viewCreateInfo.subresourceRange.baseMipLevel = 0;
	viewCreateInfo.subresourceRange.levelCount = imageInfo.mipLevels;
	viewCreateInfo.subresourceRange.baseArrayLayer = 0;
	viewCreateInfo.subresourceRange.layerCount = imageInfo.arrayLayers;

	return viewCreateInfo;
}

TransitionImageLayout(device: *VkDevice_T, commandPool: *VkCommandPool_T,
					  queue: *VkQueue_T, image: *VkImage_T,  
					  oldLayout: VkImageLayout, newLayout: VkImageLayout,
					  format: VkFormat)
{
	commandBuffer := BeginCommands(device, commandPool);

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

	if (newLayout == VkImageLayout.VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL) 
	{
		barrier.subresourceRange.aspectMask = VkImageAspectFlagBits.VK_IMAGE_ASPECT_DEPTH_BIT;
	
		if (HasStencilComponent(format)) 
		{
		    barrier.subresourceRange.aspectMask |= VkImageAspectFlagBits.VK_IMAGE_ASPECT_STENCIL_BIT;
		}
	} 
	else 
	{
		barrier.subresourceRange.aspectMask = VkImageAspectFlagBits.VK_IMAGE_ASPECT_COLOR_BIT;
	}

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
	else if (oldLayout == VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED && 
			 newLayout == VkImageLayout.VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL)
	{
	    barrier.srcAccessMask = 0;
		barrier.dstAccessMask = VkAccessFlagBits.VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_READ_BIT | 
								VkAccessFlagBits.VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT;
	
		sourceStage = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT;
		destinationStage = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT;
	}
	else if (oldLayout == VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED &&
			 newLayout == VkImageLayout.VK_IMAGE_LAYOUT_GENERAL)
	{
		barrier.srcAccessMask = 0;
		barrier.dstAccessMask = VkAccessFlagBits.VK_ACCESS_SHADER_READ_BIT |
		                        VkAccessFlagBits.VK_ACCESS_SHADER_WRITE_BIT;
	
		sourceStage = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT;
		destinationStage = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT;
	}
	else if (oldLayout == VkImageLayout.VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL &&
			 newLayout == VkImageLayout.VK_IMAGE_LAYOUT_PRESENT_SRC_KHR)
	{
	    barrier.srcAccessMask = VkAccessFlagBits.VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;
	    barrier.dstAccessMask = 0;
	
	    sourceStage = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
	    destinationStage = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT;
	}
	else 
	{
	    log "Unsupported layout transition, old: ", oldLayout, " new: ", newLayout;
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

	EndCommands(device, commandPool, commandBuffer, queue);
}

VulkanTexture CreateVulkanTexture(pixels: *byte, size: uint, width: uint32, height: uint32, format: VkFormat)
{
	vulkanTexture := VulkanTexture();

	device := vulkanInstance.device;
	graphicsQueue := vulkanInstance.queues.graphicsQueue;
	allocator := vulkanInstance.allocator;
	stagingBuffer := vulkanInstance.GetStagingBuffer();
	commands := vulkanInstance.graphicsCommands;
	commandPool := vulkanInstance.graphicsCommands.commandPool;

	imageInfo := VkImageCreateInfo();
	imageInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO;
	imageInfo.imageType = VkImageType.VK_IMAGE_TYPE_2D;
	imageInfo.extent.width = width;
	imageInfo.extent.height = height;
	imageInfo.extent.depth = 1;
	imageInfo.mipLevels = 1;
	imageInfo.arrayLayers = 1;
	imageInfo.format = format;
	imageInfo.tiling = VkImageTiling.VK_IMAGE_TILING_OPTIMAL;
	imageInfo.initialLayout = VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED;
	imageInfo.usage = VkImageUsageFlagBits.VK_IMAGE_USAGE_TRANSFER_DST_BIT |
					  VkImageUsageFlagBits.VK_IMAGE_USAGE_SAMPLED_BIT;
	imageInfo.samples = VkSampleCountFlagBits.VK_SAMPLE_COUNT_1_BIT;
	imageInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

	vulkanImage := CreateVkImage(device, imageInfo);
	vulkanImageHandle := allocator.AllocImage(vulkanImage, VulkanMemoryFlags.GPU);

	TransitionImageLayout(
		device, commandPool, graphicsQueue, vulkanImage,
		VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED, VkImageLayout.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL,
		format
	);

	stagingBuffer.StagedImageCopy(device, pixels, size, vulkanImage, width, height, commands, graphicsQueue);

	TransitionImageLayout(
		device, commandPool, graphicsQueue, vulkanImage,
		VkImageLayout.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, VkImageLayout.VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL,
		format
	);

	imageViewCreateInfo := VkImageViewCreateInfo();
	imageViewCreateInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO;
	imageViewCreateInfo.image = vulkanImage;
	imageViewCreateInfo.viewType = VkImageViewType.VK_IMAGE_VIEW_TYPE_2D;
	imageViewCreateInfo.format = format;
	imageViewCreateInfo.subresourceRange.aspectMask = VkImageAspectFlagBits.VK_IMAGE_ASPECT_COLOR_BIT;
	imageViewCreateInfo.subresourceRange.levelCount = uint32(1);
	imageViewCreateInfo.subresourceRange.layerCount = uint32(1);

	vulkanTexture.image = vulkanImage;
	vulkanTexture.imageView = CreateVkImageView(device, imageViewCreateInfo);
	vulkanTexture.layout = VkImageLayout.VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
	vulkanTexture.imageAlloc = vulkanImageHandle;

	return vulkanTexture;
}