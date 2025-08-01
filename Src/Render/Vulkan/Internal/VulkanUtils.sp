package VulkanRenderer

VkFormat VulkanRenderer::FindSupportedFormat(candidates: []VkFormat, tiling: VkImageTiling, features: uint32)
{
	for (format in candidates)
	{
		props := VkFormatProperties();
		vkGetPhysicalDeviceFormatProperties(this.device.GetPhysicalDevice(), format, props@);
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

	log "Error: no supported format found";
	return -1
}

VkFormat VulkanRenderer::FindDepthFormat()
{
	return this.FindSupportedFormat(
		[
			VkFormat.VK_FORMAT_D32_SFLOAT, 
			VkFormat.VK_FORMAT_D32_SFLOAT_S8_UINT, 
			VkFormat.VK_FORMAT_D24_UNORM_S8_UINT
		],
		VkImageTiling.VK_IMAGE_TILING_OPTIMAL,
		VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_DEPTH_STENCIL_ATTACHMENT_BIT
	);
}

uint32 FindMemoryType(physicalDevice: *VkPhysicalDevice_T, typeFilter: uint32, properties: uint32)
{
	memProperties := VkPhysicalDeviceMemoryProperties();
	vkGetPhysicalDeviceMemoryProperties(physicalDevice, memProperties@);

	for (i .. memProperties.memoryTypeCount)
	{
		if (typeFilter & (1 << i) && (memProperties.memoryTypes[i].propertyFlags & properties) == properties)
		{
			return i;
		}
	}

	log "Error: no supported memory type found";
	return -1;
}