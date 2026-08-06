package VulkanRenderer

import HandleSet
import SparseSet
import RenderComponents
import ImageManager
import SDL

MaxBindlessTextures := uint32(4096);
MaxBindlessSamplers := uint32(64);
MaxBindlessBuffers := uint32(4096);

BindlessSamplersBinding := uint32(0);
BindlessTexturesBinding := uint32(1);
BindlessBuffersBinding := uint32(2);

state VulkanBindlessResources
{
	images := HandleSet<VulkanTexture, 0>(),
	imageHandleCache := SparseSet<uint32>(),

	buffers := HandleSet<*VkBuffer_T, 0>(),

	samplerCache := Map<VkSamplerCreateInfo, uint32, HashSamplerInfo>(),
	defaultTextures := Map<DefaultTextureKey, uint32, HashDefaultTextureKey>()

	layout: *VkDescriptorSetLayout_T,
	pool: *VkDescriptorPool_T,
	set: *VkDescriptorSet_T,

	nextSampler: uint32
}

VulkanBindlessResources::Init()
{
	device := vulkanInstance.device;

	samplerBinding := VkDescriptorSetLayoutBinding();
	samplerBinding.binding = BindlessSamplersBinding;
	samplerBinding.descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_SAMPLER;
	samplerBinding.descriptorCount = MaxBindlessSamplers;
	samplerBinding.stageFlags = VkShaderStageFlagBits.VK_SHADER_STAGE_FRAGMENT_BIT;

	textureBinding := VkDescriptorSetLayoutBinding();
	textureBinding.binding = BindlessTexturesBinding;
	textureBinding.descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE;
	textureBinding.descriptorCount = MaxBindlessTextures;
	textureBinding.stageFlags = VkShaderStageFlagBits.VK_SHADER_STAGE_FRAGMENT_BIT;

	bufferBinding := VkDescriptorSetLayoutBinding();
	bufferBinding.binding = BindlessBuffersBinding;
	bufferBinding.descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
	bufferBinding.descriptorCount = MaxBindlessBuffers;
	bufferBinding.stageFlags = VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT;

	bindings := [samplerBinding, textureBinding, bufferBinding];

	bindingFlag := VkDescriptorBindingFlagBits.VK_DESCRIPTOR_BINDING_PARTIALLY_BOUND_BIT |
				   VkDescriptorBindingFlagBits.VK_DESCRIPTOR_BINDING_UPDATE_AFTER_BIND_BIT;
	bindingFlags := [bindingFlag, bindingFlag, bindingFlag];

	bindingFlagsInfo := VkDescriptorSetLayoutBindingFlagsCreateInfo();
	bindingFlagsInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_BINDING_FLAGS_CREATE_INFO;
	bindingFlagsInfo.bindingCount = 3;
	bindingFlagsInfo.pBindingFlags = fixed bindingFlags;

	layoutInfo := VkDescriptorSetLayoutCreateInfo();
	layoutInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
	layoutInfo.pNext = bindingFlagsInfo@;
	layoutInfo.flags = VkDescriptorSetLayoutCreateFlagBits.VK_DESCRIPTOR_SET_LAYOUT_CREATE_UPDATE_AFTER_BIND_POOL_BIT;
	layoutInfo.bindingCount = 3;
	layoutInfo.pBindings = fixed bindings;

	CheckResult(
		vkCreateDescriptorSetLayout(device, layoutInfo@, null, this.layout@),
		"VulkanResourceManager Error creating bindless descriptor set layout"
	);

	samplerPoolSize := VkDescriptorPoolSize();
	samplerPoolSize.type = VkDescriptorType.VK_DESCRIPTOR_TYPE_SAMPLER;
	samplerPoolSize.descriptorCount = MaxBindlessSamplers;

	texturePoolSize := VkDescriptorPoolSize();
	texturePoolSize.type = VkDescriptorType.VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE;
	texturePoolSize.descriptorCount = MaxBindlessTextures;

	bufferPoolSize := VkDescriptorPoolSize();
	bufferPoolSize.type = VkDescriptorType.VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
	bufferPoolSize.descriptorCount = MaxBindlessBuffers;

	poolSizes := [samplerPoolSize, texturePoolSize, bufferPoolSize];

	poolInfo := VkDescriptorPoolCreateInfo();
	poolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
	poolInfo.flags = VkDescriptorPoolCreateFlagBits.VK_DESCRIPTOR_POOL_CREATE_UPDATE_AFTER_BIND_BIT;
	poolInfo.poolSizeCount = 3;
	poolInfo.pPoolSizes = fixed poolSizes;
	poolInfo.maxSets = 1;

	CheckResult(
		vkCreateDescriptorPool(device, poolInfo@, null, this.pool@),
		"VulkanResourceManager Error creating bindless descriptor pool"
	);

	allocInfo := VkDescriptorSetAllocateInfo();
	allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
	allocInfo.descriptorPool = this.pool;
	allocInfo.descriptorSetCount = 1;
	allocInfo.pSetLayouts = this.layout@;

	CheckResult(
		vkAllocateDescriptorSets(device, allocInfo@, this.set@),
		"VulkanResourceManager Error allocating bindless descriptor set"
	);
}

VulkanBindlessResources::RegisterTexture(slot: uint32, imageView: *VkImageView_T)
{
	imageInfo := VkDescriptorImageInfo();
	imageInfo.imageView = imageView;
	imageInfo.imageLayout = VkImageLayout.VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;

	write := VkWriteDescriptorSet();
	write.sType = VkStructureType.VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
	write.dstSet = this.set;
	write.dstBinding = BindlessTexturesBinding;
	write.dstArrayElement = slot;
	write.descriptorCount = 1;
	write.descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE;
	write.pImageInfo = imageInfo@;

	vkUpdateDescriptorSets(vulkanInstance.device, 1, write@, 0, null);
}

uint32 VulkanBindlessResources::UploadTexture(textureMap: TextureMap, textureDef: TextureDefinition)
{
	imageHandle := textureMap.texture.imageHandle;

	if (this.imageHandleCache.Has(imageHandle.id))
	{
		return this.imageHandleCache.Get(imageHandle.id)~;
	}

	image := ImageResourceManager.GetResource(imageHandle).data.image;
	width := image.w as uint32;
	height := image.h as uint32;
	imageSize := height * image.pitch;

	format := VkFormat.VK_FORMAT_R8G8B8A8_SRGB;
	if (textureDef.colorSpace == ColorSpace.UNORM)
	{
		format = VkFormat.VK_FORMAT_R8G8B8A8_UNORM;
	}
	vulkanTexture := CreateVulkanTexture(image.pixels as *byte, imageSize, width, height, format);

	slot := this.images.Emplace(vulkanTexture);
	this.imageHandleCache.Insert(imageHandle.id, slot);
	this.RegisterTexture(slot, vulkanTexture.imageView);

	return slot;
}

uint32 VulkanBindlessResources::UploadDefaultTexture(textureDef: TextureDefinition)
{
	if (!textureDef.hasDefault) return 0;

	key := DefaultTextureKey();
	key.pixel = textureDef.defaultValue;
	key.colorSpace = textureDef.colorSpace;

	if (this.defaultTextures.Has(key)) 
	{
		return this.defaultTextures.Find(key)~;
	}

	image := fixed textureDef.defaultValue;
	width := uint32(1);
	height := uint32(1);
	imageSize := uint(4);

	format := VkFormat.VK_FORMAT_R8G8B8A8_SRGB;
	if (textureDef.colorSpace == ColorSpace.UNORM)
	{
		format = VkFormat.VK_FORMAT_R8G8B8A8_UNORM;
	}
	vulkanTexture := CreateVulkanTexture(image as *byte, imageSize, width, height, format);

	slot := this.images.Emplace(vulkanTexture);
	this.defaultTextures.Insert(key, slot);
	this.RegisterTexture(slot, vulkanTexture.imageView);

	return slot;
}

uint32 VulkanBindlessResources::RegisterBuffer(buffer: *VkBuffer_T)
{
	slot := this.buffers.Emplace(buffer);

	bufferInfo := VkDescriptorBufferInfo();
	bufferInfo.buffer = buffer;
	bufferInfo.offset = 0;
	bufferInfo.range = VK_WHOLE_SIZE;

	write := VkWriteDescriptorSet();
	write.sType = VkStructureType.VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
	write.dstSet = this.set;
	write.dstBinding = BindlessBuffersBinding;
	write.dstArrayElement = slot;
	write.descriptorCount = 1;
	write.descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
	write.pBufferInfo = bufferInfo@;

	vkUpdateDescriptorSets(vulkanInstance.device, 1, write@, 0, null);

	return slot;
}

uint32 VulkanBindlessResources::RegisterSampler(sampler: *VkSampler_T)
{
	index := this.nextSampler;
	this.nextSampler += 1;

	imageInfo := VkDescriptorImageInfo();
	imageInfo.sampler = sampler;

	write := VkWriteDescriptorSet();
	write.sType = VkStructureType.VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
	write.dstSet = this.set;
	write.dstBinding = BindlessSamplersBinding;
	write.dstArrayElement = index;
	write.descriptorCount = 1;
	write.descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_SAMPLER;
	write.pImageInfo = imageInfo@;

	vkUpdateDescriptorSets(vulkanInstance.device, 1, write@, 0, null);

	return index;
}

uint32 VulkanBindlessResources::UploadSampler(texture: Texture)
{
	samplerInfo := VkSamplerCreateInfo();
	samplerInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO;
	samplerInfo.magFilter = TextureFilterToVk(texture.magFilter);
	samplerInfo.minFilter = TextureFilterToVk(texture.minFilter);
	samplerInfo.addressModeU = TextureWrapToVk(texture.wrapU);
	samplerInfo.addressModeV = TextureWrapToVk(texture.wrapV);
	samplerInfo.addressModeW = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_REPEAT;
	samplerInfo.anisotropyEnable = VkTrue;
	samplerInfo.maxAnisotropy = vulkanInstance.deviceProperties.limits.maxSamplerAnisotropy;
	samplerInfo.borderColor = VkBorderColor.VK_BORDER_COLOR_INT_OPAQUE_BLACK;
	samplerInfo.unnormalizedCoordinates = VkFalse;
	samplerInfo.compareEnable = VkFalse;
	samplerInfo.compareOp = VkCompareOp.VK_COMPARE_OP_ALWAYS;
	samplerInfo.mipmapMode = VkSamplerMipmapMode.VK_SAMPLER_MIPMAP_MODE_LINEAR;
	samplerInfo.mipLodBias = 0.0;
	samplerInfo.minLod = 0.0;
	samplerInfo.maxLod = 0.0;

	cached := this.samplerCache.Find(samplerInfo);
	if (cached) return cached~;

	sampler: *VkSampler_T = null;
	CheckResult(
		vkCreateSampler(vulkanInstance.device, samplerInfo@, null, sampler@),
		"UploadSampler Error creating Vulkan sampler"
	);

	index := this.RegisterSampler(sampler);
	this.samplerCache.Insert(samplerInfo, index);

	return index;
}