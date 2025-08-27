package VulkanRenderer

VkFormat FindSupportedFormat(physicalDevice: *VkPhysicalDevice_T, candidates: []VkFormat, 
                             tiling: VkImageTiling, features: uint32)
{
	for (format in candidates)
	{
		props := VkFormatProperties();
		vkGetPhysicalDeviceFormatProperties(physicalDevice, format, props@);
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

VkFormat FindDepthFormat(physicalDevice: *VkPhysicalDevice_T)
{
	return FindSupportedFormat(
        physicalDevice,
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

bool IsDepthFormat(format: VkFormat) {
    switch (format) 
    {
        case (VkFormat.VK_FORMAT_D16_UNORM) continue;
        case (VkFormat.VK_FORMAT_X8_D24_UNORM_PACK32) continue;
        case (VkFormat.VK_FORMAT_D32_SFLOAT) continue;
        case (VkFormat.VK_FORMAT_D16_UNORM_S8_UINT) continue;
        case (VkFormat.VK_FORMAT_D24_UNORM_S8_UINT) continue;
        case (VkFormat.VK_FORMAT_D32_SFLOAT_S8_UINT) return true;
    }
    
    return false;
}

bool HasStencilComponent(format: VkFormat) {
    return format == VkFormat.VK_FORMAT_D32_SFLOAT_S8_UINT || 
	       format == VkFormat.VK_FORMAT_D24_UNORM_S8_UINT ||
           format == VkFormat.VK_FORMAT_D16_UNORM_S8_UINT ||
           format == VkFormat.VK_FORMAT_S8_UINT;
}

VkImageType GPUTextureTypeToVkImageType(type: GPUTextureType)
{
    if (type == GPUTextureType.TEX_3D) return VkImageType.VK_IMAGE_TYPE_3D;
    
	return VkImageType.VK_IMAGE_TYPE_2D;
}

formatTable := [
    VkFormat.VK_FORMAT_UNDEFINED,                   // INVALID
    VkFormat.VK_FORMAT_R8_UNORM,                    // A8_UNORM
    VkFormat.VK_FORMAT_R8_UNORM,                    // R8_UNORM
    VkFormat.VK_FORMAT_R8G8_UNORM,                  // R8G8_UNORM
    VkFormat.VK_FORMAT_R8G8B8A8_UNORM,              // R8G8B8A8_UNORM
    VkFormat.VK_FORMAT_R16_UNORM,                   // R16_UNORM
    VkFormat.VK_FORMAT_R16G16_UNORM,                // R16G16_UNORM
    VkFormat.VK_FORMAT_R16G16B16A16_UNORM,          // R16G16B16A16_UNORM
    VkFormat.VK_FORMAT_A2B10G10R10_UNORM_PACK32,    // R10G10B10A2_UNORM
    VkFormat.VK_FORMAT_R5G6B5_UNORM_PACK16,         // B5G6R5_UNORM
    VkFormat.VK_FORMAT_A1R5G5B5_UNORM_PACK16,       // B5G5R5A1_UNORM
    VkFormat.VK_FORMAT_B4G4R4A4_UNORM_PACK16,       // B4G4R4A4_UNORM
    VkFormat.VK_FORMAT_B8G8R8A8_UNORM,              // B8G8R8A8_UNORM
    VkFormat.VK_FORMAT_BC1_RGBA_UNORM_BLOCK,        // BC1_UNORM
    VkFormat.VK_FORMAT_BC2_UNORM_BLOCK,             // BC2_UNORM
    VkFormat.VK_FORMAT_BC3_UNORM_BLOCK,             // BC3_UNORM
    VkFormat.VK_FORMAT_BC4_UNORM_BLOCK,             // BC4_UNORM
    VkFormat.VK_FORMAT_BC5_UNORM_BLOCK,             // BC5_UNORM
    VkFormat.VK_FORMAT_BC7_UNORM_BLOCK,             // BC7_UNORM
    VkFormat.VK_FORMAT_BC6H_SFLOAT_BLOCK,           // BC6H_FLOAT
    VkFormat.VK_FORMAT_BC6H_UFLOAT_BLOCK,           // BC6H_UFLOAT
    VkFormat.VK_FORMAT_R8_SNORM,                    // R8_SNORM
    VkFormat.VK_FORMAT_R8G8_SNORM,                  // R8G8_SNORM
    VkFormat.VK_FORMAT_R8G8B8A8_SNORM,              // R8G8B8A8_SNORM
    VkFormat.VK_FORMAT_R16_SNORM,                   // R16_SNORM
    VkFormat.VK_FORMAT_R16G16_SNORM,                // R16G16_SNORM
    VkFormat.VK_FORMAT_R16G16B16A16_SNORM,          // R16G16B16A16_SNORM
    VkFormat.VK_FORMAT_R16_SFLOAT,                  // R16_FLOAT
    VkFormat.VK_FORMAT_R16G16_SFLOAT,               // R16G16_FLOAT
    VkFormat.VK_FORMAT_R16G16B16A16_SFLOAT,         // R16G16B16A16_FLOAT
    VkFormat.VK_FORMAT_R32_SFLOAT,                  // R32_FLOAT
    VkFormat.VK_FORMAT_R32G32_SFLOAT,               // R32G32_FLOAT
    VkFormat.VK_FORMAT_R32G32B32A32_SFLOAT,         // R32G32B32A32_FLOAT
    VkFormat.VK_FORMAT_B10G11R11_UFLOAT_PACK32,     // R11G11B10_UFLOAT
    VkFormat.VK_FORMAT_R8_UINT,                     // R8_UINT
    VkFormat.VK_FORMAT_R8G8_UINT,                   // R8G8_UINT
    VkFormat.VK_FORMAT_R8G8B8A8_UINT,               // R8G8B8A8_UINT
    VkFormat.VK_FORMAT_R16_UINT,                    // R16_UINT
    VkFormat.VK_FORMAT_R16G16_UINT,                 // R16G16_UINT
    VkFormat.VK_FORMAT_R16G16B16A16_UINT,           // R16G16B16A16_UINT
    VkFormat.VK_FORMAT_R32_UINT,                    // R32_UINT
    VkFormat.VK_FORMAT_R32G32_UINT,                 // R32G32_UINT
    VkFormat.VK_FORMAT_R32G32B32A32_UINT,           // R32G32B32A32_UINT
    VkFormat.VK_FORMAT_R8_SINT,                     // R8_INT
    VkFormat.VK_FORMAT_R8G8_SINT,                   // R8G8_INT
    VkFormat.VK_FORMAT_R8G8B8A8_SINT,               // R8G8B8A8_INT
    VkFormat.VK_FORMAT_R16_SINT,                    // R16_INT
    VkFormat.VK_FORMAT_R16G16_SINT,                 // R16G16_INT
    VkFormat.VK_FORMAT_R16G16B16A16_SINT,           // R16G16B16A16_INT
    VkFormat.VK_FORMAT_R32_SINT,                    // R32_INT
    VkFormat.VK_FORMAT_R32G32_SINT,                 // R32G32_INT
    VkFormat.VK_FORMAT_R32G32B32A32_SINT,           // R32G32B32A32_INT
    VkFormat.VK_FORMAT_R8G8B8A8_SRGB,               // R8G8B8A8_UNORM_SRGB
    VkFormat.VK_FORMAT_B8G8R8A8_SRGB,               // B8G8R8A8_UNORM_SRGB
    VkFormat.VK_FORMAT_BC1_RGBA_SRGB_BLOCK,         // BC1_UNORM_SRGB
    VkFormat.VK_FORMAT_BC2_SRGB_BLOCK,              // BC3_UNORM_SRGB
    VkFormat.VK_FORMAT_BC3_SRGB_BLOCK,              // BC3_UNORM_SRGB
    VkFormat.VK_FORMAT_BC7_SRGB_BLOCK,              // BC7_UNORM_SRGB
    VkFormat.VK_FORMAT_D16_UNORM,                   // D16_UNORM
    VkFormat.VK_FORMAT_X8_D24_UNORM_PACK32,         // D24_UNORM
    VkFormat.VK_FORMAT_D32_SFLOAT,                  // D32_FLOAT
    VkFormat.VK_FORMAT_D24_UNORM_S8_UINT,           // D24_UNORM_S8_UINT
    VkFormat.VK_FORMAT_D32_SFLOAT_S8_UINT,          // D32_FLOAT_S8_UINT
    VkFormat.VK_FORMAT_ASTC_4x4_UNORM_BLOCK,        // ASTC_4x4_UNORM
    VkFormat.VK_FORMAT_ASTC_5x4_UNORM_BLOCK,        // ASTC_5x4_UNORM
    VkFormat.VK_FORMAT_ASTC_5x5_UNORM_BLOCK,        // ASTC_5x5_UNORM
    VkFormat.VK_FORMAT_ASTC_6x5_UNORM_BLOCK,        // ASTC_6x5_UNORM
    VkFormat.VK_FORMAT_ASTC_6x6_UNORM_BLOCK,        // ASTC_6x6_UNORM
    VkFormat.VK_FORMAT_ASTC_8x5_UNORM_BLOCK,        // ASTC_8x5_UNORM
    VkFormat.VK_FORMAT_ASTC_8x6_UNORM_BLOCK,        // ASTC_8x6_UNORM
    VkFormat.VK_FORMAT_ASTC_8x8_UNORM_BLOCK,        // ASTC_8x8_UNORM
    VkFormat.VK_FORMAT_ASTC_10x5_UNORM_BLOCK,       // ASTC_10x5_UNORM
    VkFormat.VK_FORMAT_ASTC_10x6_UNORM_BLOCK,       // ASTC_10x6_UNORM
    VkFormat.VK_FORMAT_ASTC_10x8_UNORM_BLOCK,       // ASTC_10x8_UNORM
    VkFormat.VK_FORMAT_ASTC_10x10_UNORM_BLOCK,      // ASTC_10x10_UNORM
    VkFormat.VK_FORMAT_ASTC_12x10_UNORM_BLOCK,      // ASTC_12x10_UNORM
    VkFormat.VK_FORMAT_ASTC_12x12_UNORM_BLOCK,      // ASTC_12x12_UNORM
    VkFormat.VK_FORMAT_ASTC_4x4_SRGB_BLOCK,         // ASTC_4x4_UNORM_SRGB
    VkFormat.VK_FORMAT_ASTC_5x4_SRGB_BLOCK,         // ASTC_5x4_UNORM_SRGB
    VkFormat.VK_FORMAT_ASTC_5x5_SRGB_BLOCK,         // ASTC_5x5_UNORM_SRGB
    VkFormat.VK_FORMAT_ASTC_6x5_SRGB_BLOCK,         // ASTC_6x5_UNORM_SRGB
    VkFormat.VK_FORMAT_ASTC_6x6_SRGB_BLOCK,         // ASTC_6x6_UNORM_SRGB
    VkFormat.VK_FORMAT_ASTC_8x5_SRGB_BLOCK,         // ASTC_8x5_UNORM_SRGB
    VkFormat.VK_FORMAT_ASTC_8x6_SRGB_BLOCK,         // ASTC_8x6_UNORM_SRGB
    VkFormat.VK_FORMAT_ASTC_8x8_SRGB_BLOCK,         // ASTC_8x8_UNORM_SRGB
    VkFormat.VK_FORMAT_ASTC_10x5_SRGB_BLOCK,        // ASTC_10x5_UNORM_SRGB
    VkFormat.VK_FORMAT_ASTC_10x6_SRGB_BLOCK,        // ASTC_10x6_UNORM_SRGB
    VkFormat.VK_FORMAT_ASTC_10x8_SRGB_BLOCK,        // ASTC_10x8_UNORM_SRGB
    VkFormat.VK_FORMAT_ASTC_10x10_SRGB_BLOCK,       // ASTC_10x10_UNORM_SRGB
    VkFormat.VK_FORMAT_ASTC_12x10_SRGB_BLOCK,       // ASTC_12x10_UNORM_SRGB
    VkFormat.VK_FORMAT_ASTC_12x12_SRGB_BLOCK,       // ASTC_12x12_UNORM_SRGB
    VkFormat.VK_FORMAT_ASTC_4x4_SFLOAT_BLOCK_EXT,   // ASTC_4x4_FLOAT
    VkFormat.VK_FORMAT_ASTC_5x4_SFLOAT_BLOCK_EXT,   // ASTC_5x4_FLOAT
    VkFormat.VK_FORMAT_ASTC_5x5_SFLOAT_BLOCK_EXT,   // ASTC_5x5_FLOAT
    VkFormat.VK_FORMAT_ASTC_6x5_SFLOAT_BLOCK_EXT,   // ASTC_6x5_FLOAT
    VkFormat.VK_FORMAT_ASTC_6x6_SFLOAT_BLOCK_EXT,   // ASTC_6x6_FLOAT
    VkFormat.VK_FORMAT_ASTC_8x5_SFLOAT_BLOCK_EXT,   // ASTC_8x5_FLOAT
    VkFormat.VK_FORMAT_ASTC_8x6_SFLOAT_BLOCK_EXT,   // ASTC_8x6_FLOAT
    VkFormat.VK_FORMAT_ASTC_8x8_SFLOAT_BLOCK_EXT,   // ASTC_8x8_FLOAT
    VkFormat.VK_FORMAT_ASTC_10x5_SFLOAT_BLOCK_EXT,  // ASTC_10x5_FLOAT
    VkFormat.VK_FORMAT_ASTC_10x6_SFLOAT_BLOCK_EXT,  // ASTC_10x6_FLOAT
    VkFormat.VK_FORMAT_ASTC_10x8_SFLOAT_BLOCK_EXT,  // ASTC_10x8_FLOAT
    VkFormat.VK_FORMAT_ASTC_10x10_SFLOAT_BLOCK_EXT, // ASTC_10x10_FLOAT
    VkFormat.VK_FORMAT_ASTC_12x10_SFLOAT_BLOCK_EXT, // ASTC_12x10_FLOAT
    VkFormat.VK_FORMAT_ASTC_12x12_SFLOAT_BLOCK      // ASTC_12x12_FLOAT
];
formatCount := #compile uint32 => (#typeof formatTable).FixedArrayCount();

VkFormat GPUTextureFormatToVkFormat(format: GPUTextureFormat) => formatTable[format];

GPUTextureFormat VkFormatToGPUTextureFormat(format: VkFormat)
{
    for (i .. formatCount)
    {
        if (formatTable[i] == format) return i as GPUTextureFormat;
    }

    return GPUTextureFormat.INVALID;
}

VkImageUsageFlagBits GPUTextureUsageToVkUsage(usage: GPUTextureUsageFlags)
{
    usageFlags := VkImageUsageFlagBits.VK_IMAGE_USAGE_TRANSFER_SRC_BIT |
                  VkImageUsageFlagBits.VK_IMAGE_USAGE_TRANSFER_DST_BIT;
    
    if (usage & (GPUTextureUsageFlags.SAMPLER |
                 GPUTextureUsageFlags.GRAPHICS_STORAGE_READ |
                 GPUTextureUsageFlags.COMPUTE_STORAGE_READ)) 
    {
        usageFlags |= VkImageUsageFlagBits.VK_IMAGE_USAGE_SAMPLED_BIT;
    }
    if (usage & GPUTextureUsageFlags.COLOR_TARGET) 
    {
        usageFlags |= VkImageUsageFlagBits.VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT;
    }
    if (usage & GPUTextureUsageFlags.DEPTH_STENCIL_TARGET) 
    {
        usageFlags |= VkImageUsageFlagBits.VK_IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT;
    }
    if (usage & (GPUTextureUsageFlags.COMPUTE_STORAGE_WRITE |
                 GPUTextureUsageFlags.COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE)) 
    {
        usageFlags |= VkImageUsageFlagBits.VK_IMAGE_USAGE_STORAGE_BIT;
    }

    return usageFlags;
}

layoutTable := [
    VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED,
    VkImageLayout.VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL,
    VkImageLayout.VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL,
    VkImageLayout.VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL,
    VkImageLayout.VK_IMAGE_LAYOUT_GENERAL,
    VkImageLayout.VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL,
    VkImageLayout.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL,
    VkImageLayout.VK_IMAGE_LAYOUT_PRESENT_SRC_KHR
];

VkImageLayout GPUTextureLayoutToVkLayout(layout: GPUTextureLayout) => layoutTable[layout];

VkImageCreateInfo TextureDescToCreateInfo(createDesc: TextureDesc, renderer: *VulkanRenderer)
{
	createInfo := VkImageCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO;
	createInfo.imageType = GPUTextureTypeToVkImageType(createDesc.type);
	createInfo.format = createDesc.format;

    if (createDesc.flags & GPUTextureFlags.SizeSwapchainRelative)
    {
        createInfo.extent.width = renderer.swapchain.extent.width;
        createInfo.extent.height = renderer.swapchain.extent.height;
    }
    else
    {
	    createInfo.extent.width = createDesc.width;
	    createInfo.extent.height = createDesc.height;
    }
	createInfo.extent.depth = createDesc.depth;

	createInfo.mipLevels = createDesc.mipLevels;
	createInfo.arrayLayers = createDesc.layerCount;
	createInfo.samples = VkSampleCountFlagBits.VK_SAMPLE_COUNT_1_BIT;
	createInfo.tiling = createDesc.tiling as VkImageTiling;
	createInfo.usage = GPUTextureUsageToVkUsage(createDesc.usage);

    if (createDesc.shared)
    {
        createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_CONCURRENT;
    }
    else
    {
        createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;
    }
	
	createInfo.initialLayout = GPUTextureLayoutToVkLayout(createDesc.layout);

	return createInfo;
}

samplesTable := [
   VkSampleCountFlagBits.VK_SAMPLE_COUNT_1_BIT,
   VkSampleCountFlagBits.VK_SAMPLE_COUNT_2_BIT,
   VkSampleCountFlagBits.VK_SAMPLE_COUNT_4_BIT,
   VkSampleCountFlagBits.VK_SAMPLE_COUNT_8_BIT
];

VkFormat GPUTextureSamplesToVkSamples(samples: GPUSampleCount) => samplesTable[samples];

VkBufferCreateInfo BufferDescToCreateInfo(createDesc: BufferDesc)
{
	createInfo := VkBufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.usage = createDesc.usage;
	createInfo.size = createDesc.size;

    if (createDesc.shared)
    {
        createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_CONCURRENT;
    }
    else
    {
        createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;
    }

	return createInfo;
}

*VkFence_T CreateFence(device: *VkDevice_T)
{
    createInfo := VkFenceCreateInfo();
    createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_FENCE_CREATE_INFO;
    createInfo.flags = VkFenceCreateFlagBits.VK_FENCE_CREATE_SIGNALED_BIT;

    fence: *VkFence_T = null;
    CheckResult(vkCreateFence(device, createInfo@, null, fence@), "Error creating Vulkan fence");
    return fence;
}

*VkSemaphore_T CreateSemaphore(device: *VkDevice_T)
{
    createInfo := VkSemaphoreCreateInfo();
    createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;

    semaphore: *VkSemaphore_T = null;
    CheckResult(vkCreateSemaphore(device, createInfo@, null, semaphore@), "Error creating Vulkan semaphore");
    return semaphore;
}