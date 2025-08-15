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

TransitionImageLayout(commandBuffer: *VkCommandBuffer_T, image: *VkImage_T,  
					  oldLayout: VkImageLayout, newLayout: VkImageLayout,
					  format: VkFormat)
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
}