package VulkanRenderer

state VulkanTexture
{
	image: *VkImage_T,
	imageView: *VkImageView_T,
	sampler: *VkSampler_T,
	
	layout: VkImageLayout,
	imageAlloc: VulkanAllocHandle
}

state VulkanRenderTarget
{
	image: *VkImage_T,
	imageView: *VkImageView_T,
	handle: VulkanAllocHandle
}

state VulkanRenderBuffer
{
	handle: VulkanAllocHandle
}

state DefaultTextureKey
{
	pixel: [4]ubyte,
	colorSpace: ColorSpace
}

uint HashSamplerInfo(info: VkSamplerCreateInfo)
{
	return MHash<VkSamplerCreateInfo>(info);
}

uint HashValue(value: Value)
{
	return MHash<Value>(value);
}

uint HashDefaultTextureKey(key: DefaultTextureKey)
{
	return MHash<DefaultTextureKey>(key);
}

VkFilter TextureFilterToVk(filter: TextureFilter)
{
	switch (filter)
	{
		case (TextureFilter.Nearest)              return VkFilter.VK_FILTER_NEAREST;
		case (TextureFilter.NearestMipmapNearest) return VkFilter.VK_FILTER_NEAREST;
		case (TextureFilter.NearestMipmapLinear)  return VkFilter.VK_FILTER_NEAREST;
	}

	return VkFilter.VK_FILTER_LINEAR;
}

VkSamplerAddressMode TextureWrapToVk(wrap: TextureWrap)
{
	switch (wrap)
	{
		case (TextureWrap.Clamp)  return VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE;
		case (TextureWrap.Mirror) return VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_MIRRORED_REPEAT;
	}

	return VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_REPEAT;
}

BufferHandle UploadVariableSet(variables: VariableSet, data: *void)
{
	variableSize := variables.GetSetsValueSize();
	if (variableSize)
	{
		return UploadBuffer(UniformBufferCreateInfo(variableSize), data as *byte, variableSize);
	}

	return BufferHandle();
}

BufferHandle UploadBindlessSlots<Type>(data: *Type, count: uint32)
{
	if (!count) return BufferHandle();

	size := count * #sizeof Type;
	return UploadBuffer(UniformBufferCreateInfo(size), data as *byte, size);
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

// bool IsBindlessReflectSet(reflSet: *SpvReflectDescriptorSet)
// {
// 	for (i .. reflSet.binding_count)
// 	{
// 		// Runtime sized descriptor arrays only exist in the bindless set
// 		binding := reflSet.bindings[i];
// 		if (binding.array.dims_count && binding.array.dims[0] == 0)
// 		{
// 			return true;
// 		}
// 	}
// 	return false;
// }

// MaterialsPerPool := uint32(64);

// VulkanResourceManager::AddUBOPool(descriptors: *VulkanUBODescriptors)
// {
// 	totalSets := descriptors.setLayouts.count * MaterialsPerPool;

// 	poolSize := VkDescriptorPoolSize();
// 	poolSize.type = VkDescriptorType.VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
// 	poolSize.descriptorCount = totalSets;

// 	poolInfo := VkDescriptorPoolCreateInfo();
// 	poolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
// 	poolInfo.poolSizeCount = 1;
// 	poolInfo.pPoolSizes = poolSize@;
// 	poolInfo.maxSets = totalSets;

// 	pool: *VkDescriptorPool_T = null;
// 	CheckResult(
// 		vkCreateDescriptorPool(vulkanInstance.device, poolInfo@, null, pool@),
// 		"AddUBOPool Error creating UBO descriptor pool"
// 	);
// 	descriptors.pools.Add(pool);
// }

// *VulkanUBODescriptors VulkanResourceManager::GetUBODescriptors(cache: *SparseSet<VulkanUBODescriptors>,
// 															   assetDefHandle: AssetDefHandle,
// 															   shaderItem: *ShaderItem,
// 															   stageFlag: VkShaderStageFlagBits)
// {
// 	key := assetDefHandle.handle;

// 	existing := cache.Get(key);
// 	if (existing) return existing;

// 	descriptors := cache.Emplace(key);
// 	device := vulkanInstance.device;

// 	for (reflSet in shaderItem.reflectDescSet)
// 	{
// 		if (reflSet.set == 0 || IsBindlessReflectSet(reflSet)) continue;

// 		bindingCount := reflSet.binding_count;
// 		bindings := ECS.instance.frameAllocator.AllocArray<VkDescriptorSetLayoutBinding>(bindingCount);
// 		for (i .. bindingCount)
// 		{
// 			reflBinding := reflSet.bindings[i];

// 			binding := VkDescriptorSetLayoutBinding();
// 			binding.binding = reflBinding.binding;
// 			binding.descriptorType = reflBinding.descriptor_type;
// 			binding.descriptorCount = 1;
// 			for (dim .. reflBinding.array.dims_count)
// 			{
// 				binding.descriptorCount *= reflBinding.array.dims[dim];
// 			}
// 			binding.stageFlags = stageFlag;
// 			bindings[i] = binding;
// 		}

// 		layoutInfo := VkDescriptorSetLayoutCreateInfo();
// 		layoutInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
// 		layoutInfo.bindingCount = bindingCount;
// 		layoutInfo.pBindings = bindings[0]@;

// 		layout: *VkDescriptorSetLayout_T = null;
// 		CheckResult(
// 			vkCreateDescriptorSetLayout(device, layoutInfo@, null, layout@),
// 			"GetUBODescriptors Error creating UBO descriptor set layout"
// 		);

// 		uboSet := VulkanUBOSet();
// 		uboSet.set = reflSet.set;
// 		uboSet.layout = layout;
// 		descriptors.setLayouts.Add(uboSet);
// 	}

// 	if (descriptors.setLayouts.count) this.AddUBOPool(descriptors);
// 	return descriptors;
// }