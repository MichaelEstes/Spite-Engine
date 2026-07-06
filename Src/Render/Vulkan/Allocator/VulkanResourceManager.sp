package VulkanRenderer

import HandleSet
import SparseSet
import RenderComponents
import RenderAssetDef
import ImageManager
import Array
import ArrayView
import SpirvReflect
import SDL

state VulkanResourceHandle
{
	handle: uint32
}

state HandleBuffer
{
	buffer: *VkBuffer_T,
	handle: VulkanAllocHandle
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

MaxBindlessTextures := uint32(4096);
MaxBindlessSamplers := uint32(64);

BindlessSamplersBinding := uint32(0);
BindlessTexturesBinding := uint32(1);

MaterialsPerPool := uint32(64);
MaxMaterialSets := uint32(1024);

DebugTextureSize := uint32(16);
DebugTextureSquare := uint32(4);

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

state VulkanBindlessTextures
{
	images := Array<VulkanTexture>(),
	imageHandleCache := SparseSet<uint32>(),

	samplerCache := Map<VkSamplerCreateInfo, uint32, HashSamplerInfo>(),

	layout: *VkDescriptorSetLayout_T,
	pool: *VkDescriptorPool_T,
	set: *VkDescriptorSet_T,

	defaultTextures := Map<DefaultTextureKey, uint32, HashDefaultTextureKey>()

	nextSampler: uint32
}

VulkanBindlessTextures::RegisterTexture(slot: uint32, imageView: *VkImageView_T)
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

uint32 VulkanBindlessTextures::UploadTexture(textureMap: TextureMap, textureDef: TextureDefinition)
{
	imageHandle := textureMap.texture.imageHandle;

	if (this.imageHandleCache.Has(imageHandle.id)) 
		return this.imageHandleCache.Get(imageHandle.id)~;

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

	slot := this.images.Add(vulkanTexture);
	this.imageHandleCache.Insert(imageHandle.id, slot);
	this.RegisterTexture(slot, vulkanTexture.imageView);

	return slot;
}

uint32 VulkanBindlessTextures::UploadDefaultTexture(textureDef: TextureDefinition)
{
	if (!textureDef.hasDefault) return 0;

	key := DefaultTextureKey();
	key.pixel = textureDef.defaultValue;
	key.colorSpace = textureDef.colorSpace;

	if (this.defaultTextures.Has(key)) return this.defaultTextures.Find(key)~;

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

	slot := this.images.Add(vulkanTexture);
	this.defaultTextures.Insert(key, slot);
	this.RegisterTexture(slot, vulkanTexture.imageView);

	return slot;
}

uint32 VulkanBindlessTextures::RegisterSampler(sampler: *VkSampler_T)
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

uint32 VulkanBindlessTextures::UploadSampler(texture: Texture)
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

state VulkanUBOSet
{
	set: uint32,
	layout: *VkDescriptorSetLayout_T
}

state VulkanUBODescriptors
{
	setLayouts := Array<VulkanUBOSet>(),
	pools := Array<*VkDescriptorPool_T>()
}

state VulkanResourceManager
{
	renderTargetMap := Map<*VkImage_T, VulkanRenderTarget>(),
	renderBufferMap := Map<*VkBuffer_T, VulkanRenderBuffer>(),

	textures: VulkanBindlessTextures,

	geometries := HandleSet<VulkanGeometry>(),
	materials := HandleSet<VulkanMaterial>(),

	geometryDescriptors := SparseSet<VulkanUBODescriptors>(),
	materialDescriptors := SparseSet<VulkanUBODescriptors>(),

	defaultBuffers := Map<Value, HandleBuffer, HashValue>()
}

VulkanResourceManager::()
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

	bindings := [samplerBinding, textureBinding];

	bindingFlag := VkDescriptorBindingFlagBits.VK_DESCRIPTOR_BINDING_PARTIALLY_BOUND_BIT |
				   VkDescriptorBindingFlagBits.VK_DESCRIPTOR_BINDING_UPDATE_AFTER_BIND_BIT;
	bindingFlags := [bindingFlag, bindingFlag];

	bindingFlagsInfo := VkDescriptorSetLayoutBindingFlagsCreateInfo();
	bindingFlagsInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_BINDING_FLAGS_CREATE_INFO;
	bindingFlagsInfo.bindingCount = 2;
	bindingFlagsInfo.pBindingFlags = fixed bindingFlags;

	layoutInfo := VkDescriptorSetLayoutCreateInfo();
	layoutInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
	layoutInfo.pNext = bindingFlagsInfo@;
	layoutInfo.flags = VkDescriptorSetLayoutCreateFlagBits.VK_DESCRIPTOR_SET_LAYOUT_CREATE_UPDATE_AFTER_BIND_POOL_BIT;
	layoutInfo.bindingCount = 2;
	layoutInfo.pBindings = fixed bindings;

	CheckResult(
		vkCreateDescriptorSetLayout(device, layoutInfo@, null, this.textures.layout@),
		"VulkanResourceManager Error creating bindless descriptor set layout"
	);

	samplerPoolSize := VkDescriptorPoolSize();
	samplerPoolSize.type = VkDescriptorType.VK_DESCRIPTOR_TYPE_SAMPLER;
	samplerPoolSize.descriptorCount = MaxBindlessSamplers;

	texturePoolSize := VkDescriptorPoolSize();
	texturePoolSize.type = VkDescriptorType.VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE;
	texturePoolSize.descriptorCount = MaxBindlessTextures;

	poolSizes := [samplerPoolSize, texturePoolSize];

	poolInfo := VkDescriptorPoolCreateInfo();
	poolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
	poolInfo.flags = VkDescriptorPoolCreateFlagBits.VK_DESCRIPTOR_POOL_CREATE_UPDATE_AFTER_BIND_BIT;
	poolInfo.poolSizeCount = 2;
	poolInfo.pPoolSizes = fixed poolSizes;
	poolInfo.maxSets = 1;

	CheckResult(
		vkCreateDescriptorPool(device, poolInfo@, null, this.textures.pool@),
		"VulkanResourceManager Error creating bindless descriptor pool"
	);

	allocInfo := VkDescriptorSetAllocateInfo();
	allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
	allocInfo.descriptorPool = this.textures.pool;
	allocInfo.descriptorSetCount = 1;
	allocInfo.pSetLayouts = this.textures.layout@;

	CheckResult(
		vkAllocateDescriptorSets(device, allocInfo@, this.textures.set@),
		"VulkanResourceManager Error allocating bindless descriptor set"
	);

	this.CreateDebugTexture();
}

VulkanResourceManager::CreateDebugTexture()
{
	pixels := [512]uint32;

	pink := uint32(0xFFFF00FF);
	black := uint32(0xFF000000);

	for (y .. DebugTextureSize)
	{
		for (x .. DebugTextureSize)
		{
			cell := (x / DebugTextureSquare + y / DebugTextureSquare) % 2;
			color := black;
			if (cell == 0) color = pink;
			pixels[y * DebugTextureSize + x] = color;
		}
	}

	byteSize := DebugTextureSize * DebugTextureSize * uint32(4);
	debugTexture := CreateVulkanTexture(
		pixels[0]@ as *byte, byteSize,
		DebugTextureSize, DebugTextureSize,
		VkFormat.VK_FORMAT_R8G8B8A8_UNORM
	);

	defaultTextureSlot := this.textures.images.Add(debugTexture);
	this.textures.RegisterTexture(defaultTextureSlot, debugTexture.imageView);

	samplerInfo := VkSamplerCreateInfo();
	samplerInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO;
	samplerInfo.magFilter = VkFilter.VK_FILTER_NEAREST;
	samplerInfo.minFilter = VkFilter.VK_FILTER_NEAREST;
	samplerInfo.addressModeU = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_REPEAT;
	samplerInfo.addressModeV = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_REPEAT;
	samplerInfo.addressModeW = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_REPEAT;
	samplerInfo.mipmapMode = VkSamplerMipmapMode.VK_SAMPLER_MIPMAP_MODE_NEAREST;

	sampler: *VkSampler_T = null;
	CheckResult(
		vkCreateSampler(vulkanInstance.device, samplerInfo@, null, sampler@),
		"CreateDebugTexture Error creating default sampler"
	);
	this.textures.RegisterSampler(sampler);
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

VkBufferCreateInfo VertexBufferCreateInfo(size: uint32)
{
	createInfo := VkBufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.usage = VkBufferUsageFlagBits.VK_BUFFER_USAGE_VERTEX_BUFFER_BIT |
					   VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_DST_BIT;
	createInfo.size = size;
	createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

	return createInfo;
}

VkBufferCreateInfo IndexBufferCreateInfo(size: uint32)
{
	createInfo := VkBufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.usage = VkBufferUsageFlagBits.VK_BUFFER_USAGE_INDEX_BUFFER_BIT |
					   VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_DST_BIT;
	createInfo.size = size;
	createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

	return createInfo;
}

VkBufferCreateInfo UniformBufferCreateInfo(size: uint32)
{
	createInfo := VkBufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.usage = VkBufferUsageFlagBits.VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT;
	createInfo.size = size;
	createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

	return createInfo;
}

VkBufferCreateInfo StorageBufferCreateInfo(size: uint32)
{
	createInfo := VkBufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.usage = VkBufferUsageFlagBits.VK_BUFFER_USAGE_STORAGE_BUFFER_BIT |
					   VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_DST_BIT;
	createInfo.size = size;
	createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

	return createInfo;
}

HandleBuffer UploadBuffer(createInfo: VkBufferCreateInfo, data: *byte, size: uint)
{
	device := vulkanInstance.device;
	allocator := vulkanInstance.allocator;
	stagingBuffer := vulkanInstance.GetStagingBuffer();
	queue := vulkanInstance.queues.transferQueue;
	commands := vulkanInstance.transferCommands;

	buffer := CreateVkBuffer(device, createInfo);
	handle := allocator.AllocBuffer(buffer, VulkanMemoryFlags.GPU);
	stagingBuffer.StagedBufferCopy(device, data, size, buffer, commands, queue);

	handleBuf := HandleBuffer();
	handleBuf.buffer = buffer;
	handleBuf.handle = handle;
	return handleBuf;
}

HandleBuffer CreateDeviceStorageBuffer(size: uint32)
{
	device := vulkanInstance.device;
	allocator := vulkanInstance.allocator;

	buffer := CreateVkBuffer(device, StorageBufferCreateInfo(size));
	handle := allocator.AllocBuffer(buffer, VulkanMemoryFlags.GPU);

	handleBuf := HandleBuffer();
	handleBuf.buffer = buffer;
	handleBuf.handle = handle;
	return handleBuf;
}

HandleBuffer CreateMappedStorageBuffer(size: uint32)
{
	device := vulkanInstance.device;
	allocator := vulkanInstance.allocator;

	buffer := CreateVkBuffer(device, StorageBufferCreateInfo(size));
	handle := allocator.AllocBuffer(
		buffer,
		VulkanMemoryFlags.Shared | VulkanMemoryFlags.Coherent | VulkanMemoryFlags.Mapped
	);

	handleBuf := HandleBuffer();
	handleBuf.buffer = buffer;
	handleBuf.handle = handle;
	return handleBuf;
}

HandleBuffer VulkanResourceManager::GetDefaultBuffer(value: Value, size: uint32)
{
	cached := this.defaultBuffers.Find(value);
	if (cached) return cached~;

	handleBuf := UploadBuffer(VertexBufferCreateInfo(size), value.val@ as *byte, size);
	this.defaultBuffers.Insert(value, handleBuf);

	return handleBuf;
}

Array<VulkanAllocHandle> UploadVariableSets(variables: *void, variableSets: VariableSets)
{
	device := vulkanInstance.device;
	allocator := vulkanInstance.allocator;

	handles := Array<VulkanAllocHandle>(variableSets.sets.count);

	offset := uint32(0);
	for (set in variableSets.sets)
	{
		setSize := uint32(0);
		for (var in set)
		{
			setSize += var.def.ValueSize();
		}

		buffer := CreateVkBuffer(device, UniformBufferCreateInfo(setSize));
		handle := allocator.AllocBuffer(
			buffer,
			VulkanMemoryFlags.Shared | VulkanMemoryFlags.Coherent | VulkanMemoryFlags.Mapped
		);

		mappedPtr := allocator.GetAllocationMappedPtr(handle) as *byte;
		copy_bytes(mappedPtr, (variables as *byte) + offset, setSize);

		handles.Add(handle);
		offset += setSize;
	}

	return handles;
}

uint32 VulkanResourceManager::UploadGeometry(geometry: *Geometry)
{
	if (geometry.gpuResourceID) return geometry.gpuResourceID;

	allocator := vulkanInstance.allocator;
	handleValue := this.geometries.GetNext();
	vulkanGeometry := handleValue.value;
	vulkanGeometry~ = VulkanGeometry();

	assetDef := GetAssetDefWithHandle(geometry.defHandle);

	attributeCount := geometry.attributes.count;
	vulkanGeometry.attributes = Array<VulkanAllocHandle>(attributeCount);
	vulkanGeometry.attributeBuffers = Array<*VkBuffer_T>(attributeCount);
	vulkanGeometry.strides = Array<uint64>(attributeCount);

	if (attributeCount)
	{
		attribute := geometry.attributes[0];
		attrDef := assetDef.vertex.attributes[0].def;
		vulkanGeometry.vertexCount = uint32(attribute.count / attrDef.ValueSize());
	}

	for (i .. attributeCount)
	{
		attribute := geometry.attributes[i];
		attrDef := assetDef.vertex.attributes[i].def;

		if (attribute.count)
		{
			handleBuf := UploadBuffer(VertexBufferCreateInfo(attribute.count), attribute.start, attribute.count);
			vulkanGeometry.attributeBuffers.Add(handleBuf.buffer);
			vulkanGeometry.attributes.Add(handleBuf.handle);
			vulkanGeometry.strides.Add(attrDef.ValueSize());
		}
		else
		{
			handleBuf := this.GetDefaultBuffer(attrDef.defaultValue, attrDef.ValueSize());
			vulkanGeometry.attributeBuffers.Add(handleBuf.buffer);
			vulkanGeometry.attributes.Add(handleBuf.handle);
			vulkanGeometry.strides.Add(0);
		}
	}

	if (geometry.indexKind != IndexKind.None)
	{
		indices := geometry.indices;
		indexSize := indices.count * #sizeof uint16;

		handleBuf := UploadBuffer(
			IndexBufferCreateInfo(indexSize),
			indices.start as *byte,
			indexSize
		);
		vulkanGeometry.indexBuffer = handleBuf.buffer;
		vulkanGeometry.indexHandle = handleBuf.handle;
		vulkanGeometry.indexCount = indices.count;
		vulkanGeometry.indexKind = VkIndexType.VK_INDEX_TYPE_UINT16;
	}

	vulkanGeometry.variables = UploadVariableSets(geometry.variables, assetDef.vertex.variables);

	descriptors := this.GetGeometryDescriptors(geometry.defHandle);
	vulkanGeometry.descriptorSets = Array<*VkDescriptorSet_T>(descriptors.setLayouts.count);
	for (uboSet in descriptors.setLayouts)
	{
		descriptorSet := this.AllocateUBOSet(descriptors, uboSet.layout);
		this.WriteUBOSet(descriptorSet, vulkanGeometry.variables[uboSet.set - 1]);
		vulkanGeometry.descriptorSets.Add(descriptorSet);
	}

	geometry.gpuResourceID = handleValue.handle;
	return handleValue.handle;
}

bool IsBindlessReflectSet(reflSet: *SpvReflectDescriptorSet)
{
	for (i .. reflSet.binding_count)
	{
		type := reflSet.bindings[i].descriptor_type;
		if (type == VkDescriptorType.VK_DESCRIPTOR_TYPE_SAMPLER ||
			type == VkDescriptorType.VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE)
		{
			return true;
		}
	}
	return false;
}

VulkanResourceManager::AddUBOPool(descriptors: *VulkanUBODescriptors)
{
	totalSets := descriptors.setLayouts.count * MaterialsPerPool;

	poolSize := VkDescriptorPoolSize();
	poolSize.type = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
	poolSize.descriptorCount = totalSets;

	poolInfo := VkDescriptorPoolCreateInfo();
	poolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
	poolInfo.poolSizeCount = 1;
	poolInfo.pPoolSizes = poolSize@;
	poolInfo.maxSets = totalSets;

	pool: *VkDescriptorPool_T = null;
	CheckResult(
		vkCreateDescriptorPool(vulkanInstance.device, poolInfo@, null, pool@),
		"AddUBOPool Error creating UBO descriptor pool"
	);
	descriptors.pools.Add(pool);
}

*VulkanUBODescriptors VulkanResourceManager::GetUBODescriptors(cache: *SparseSet<VulkanUBODescriptors>,
															   assetDefHandle: AssetDefHandle,
															   shaderItem: *ShaderItem,
															   stageFlag: VkShaderStageFlagBits)
{
	key := assetDefHandle.handle;

	existing := cache.Get(key);
	if (existing) return existing;

	descriptors := cache.Emplace(key);
	device := vulkanInstance.device;

	for (reflSet in shaderItem.reflectDescSet)
	{
		if (reflSet.set == 0 || IsBindlessReflectSet(reflSet)) continue;

		bindingCount := reflSet.binding_count;
		bindings := ECS.instance.frameAllocator.AllocArray<VkDescriptorSetLayoutBinding>(bindingCount);
		for (i .. bindingCount)
		{
			reflBinding := reflSet.bindings[i];

			binding := VkDescriptorSetLayoutBinding();
			binding.binding = reflBinding.binding;
			binding.descriptorType = reflBinding.descriptor_type;
			binding.descriptorCount = 1;
			for (dim .. reflBinding.array.dims_count)
			{
				binding.descriptorCount *= reflBinding.array.dims[dim];
			}
			binding.stageFlags = stageFlag;
			bindings[i] = binding;
		}

		layoutInfo := VkDescriptorSetLayoutCreateInfo();
		layoutInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
		layoutInfo.bindingCount = bindingCount;
		layoutInfo.pBindings = bindings[0]@;

		layout: *VkDescriptorSetLayout_T = null;
		CheckResult(
			vkCreateDescriptorSetLayout(device, layoutInfo@, null, layout@),
			"GetUBODescriptors Error creating UBO descriptor set layout"
		);

		uboSet := VulkanUBOSet();
		uboSet.set = reflSet.set;
		uboSet.layout = layout;
		descriptors.setLayouts.Add(uboSet);
	}

	if (descriptors.setLayouts.count) this.AddUBOPool(descriptors);
	return descriptors;
}

*VulkanUBODescriptors VulkanResourceManager::GetGeometryDescriptors(assetDefHandle: AssetDefHandle)
{
	shaderRes := ShaderResourceManager.GetResource(UseAssetDefShader(assetDefHandle)).data;
	return this.GetUBODescriptors(
		this.geometryDescriptors@, assetDefHandle, shaderRes.vertex@,
		VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT
	);
}

*VulkanUBODescriptors VulkanResourceManager::GetMaterialDescriptors(assetDefHandle: AssetDefHandle)
{
	shaderRes := ShaderResourceManager.GetResource(UseAssetDefShader(assetDefHandle)).data;
	return this.GetUBODescriptors(
		this.materialDescriptors@, assetDefHandle, shaderRes.fragment@,
		VkShaderStageFlagBits.VK_SHADER_STAGE_FRAGMENT_BIT
	);
}

*VkDescriptorSet_T VulkanResourceManager::AllocateUBOSet(descriptors: *VulkanUBODescriptors,
														layout: *VkDescriptorSetLayout_T)
{
	allocInfo := VkDescriptorSetAllocateInfo();
	allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
	allocInfo.descriptorSetCount = 1;
	allocInfo.pSetLayouts = layout@;
	allocInfo.descriptorPool = descriptors.pools[descriptors.pools.count - 1];

	set: *VkDescriptorSet_T = null;
	result := vkAllocateDescriptorSets(vulkanInstance.device, allocInfo@, set@);

	if (result == VkResult.VK_ERROR_OUT_OF_POOL_MEMORY ||
		result == VkResult.VK_ERROR_FRAGMENTED_POOL)
	{
		this.AddUBOPool(descriptors);
		allocInfo.descriptorPool = descriptors.pools[descriptors.pools.count - 1];
		result = vkAllocateDescriptorSets(vulkanInstance.device, allocInfo@, set@);
	}

	CheckResult(result, "AllocateUBOSet Error allocating material descriptor set");
	return set;
}

VulkanResourceManager::WriteUBOSet(descriptorSet: *VkDescriptorSet_T, buffer: VulkanAllocHandle)
{
	alloc := vulkanInstance.allocator.GetAllocation(buffer);

	bufferInfo := VkDescriptorBufferInfo();
	bufferInfo.buffer = alloc.data.buffer;
	bufferInfo.offset = 0;
	bufferInfo.range = VK_WHOLE_SIZE;

	write := VkWriteDescriptorSet();
	write.sType = VkStructureType.VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
	write.dstSet = descriptorSet;
	write.dstBinding = 0;
	write.dstArrayElement = 0;
	write.descriptorCount = 1;
	write.descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
	write.pBufferInfo = bufferInfo@;

	vkUpdateDescriptorSets(vulkanInstance.device, 1, write@, 0, null);
}

VulkanResourceManager::WriteStorageSetBuffer(descriptorSet: *VkDescriptorSet_T, binding: uint32,
											 buffer: *VkBuffer_T)
{
	bufferInfo := VkDescriptorBufferInfo();
	bufferInfo.buffer = buffer;
	bufferInfo.offset = 0;
	bufferInfo.range = VK_WHOLE_SIZE;

	write := VkWriteDescriptorSet();
	write.sType = VkStructureType.VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
	write.dstSet = descriptorSet;
	write.dstBinding = binding;
	write.dstArrayElement = 0;
	write.descriptorCount = 1;
	write.descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
	write.pBufferInfo = bufferInfo@;

	vkUpdateDescriptorSets(vulkanInstance.device, 1, write@, 0, null);
}

VulkanResourceManager::WriteStorageSet(descriptorSet: *VkDescriptorSet_T, binding: uint32,
									   buffer: VulkanAllocHandle)
{
	alloc := vulkanInstance.allocator.GetAllocation(buffer);

	bufferInfo := VkDescriptorBufferInfo();
	bufferInfo.buffer = alloc.data.buffer;
	bufferInfo.offset = 0;
	bufferInfo.range = VK_WHOLE_SIZE;

	write := VkWriteDescriptorSet();
	write.sType = VkStructureType.VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
	write.dstSet = descriptorSet;
	write.dstBinding = binding;
	write.dstArrayElement = 0;
	write.descriptorCount = 1;
	write.descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
	write.pBufferInfo = bufferInfo@;

	vkUpdateDescriptorSets(vulkanInstance.device, 1, write@, 0, null);
}

uint32 VulkanResourceManager::UploadMaterial(material: *Material)
{
	if (material.gpuResourceID) return material.gpuResourceID;

	handleValue := this.materials.GetNext();
	vulkanMaterial := handleValue.value;
	vulkanMaterial~ = VulkanMaterial();

	assetDef := GetAssetDefWithHandle(material.defHandle);
	vulkanMaterial.variables = UploadVariableSets(material.variables, assetDef.fragment.variables);

	descriptors := this.GetMaterialDescriptors(material.defHandle);
	fragVarSetCount := assetDef.fragment.variables.sets.count;
	vulkanMaterial.descriptorSets = Array<*VkDescriptorSet_T>(descriptors.setLayouts.count);

	for (i .. fragVarSetCount)
	{
		materialSet := descriptors.setLayouts[i];
		descriptorSet := this.AllocateUBOSet(descriptors, materialSet.layout);
		this.WriteUBOSet(descriptorSet, vulkanMaterial.variables[i]);
		vulkanMaterial.descriptorSets.Add(descriptorSet);
	}

	textureCount := material.textures.count;
	if (textureCount)
	{
		indices := ECS.instance.frameAllocator.AllocArray<uint32>(textureCount * 2);
		indices.count = 0;
		for (i .. textureCount)
		{
			textureMap := material.textures[i];
			textureDef := assetDef.fragment.textures[i];
			if (!textureMap)
			{
				indices.Add(this.textures.UploadDefaultTexture(textureDef));
				indices.Add(this.textures.UploadSampler(Texture()));
				continue;
			}
			indices.Add(this.textures.UploadTexture(textureMap, textureDef));
			indices.Add(this.textures.UploadSampler(textureMap.texture));
		}

		setSize := indices.count * #sizeof uint32;
		buffer := CreateVkBuffer(vulkanInstance.device, UniformBufferCreateInfo(setSize));
		vulkanMaterial.textureSet = vulkanInstance.allocator.AllocBuffer(
			buffer,
			VulkanMemoryFlags.Shared | VulkanMemoryFlags.Coherent | VulkanMemoryFlags.Mapped
		);

		mappedPtr := vulkanInstance.allocator.GetAllocationMappedPtr(vulkanMaterial.textureSet) as *byte;
		copy_bytes(mappedPtr, indices.memory.ptr as *byte, setSize);

		materialSet := descriptors.setLayouts[descriptors.setLayouts.count - 1];
		descriptorSet := this.AllocateUBOSet(descriptors, materialSet.layout);
		this.WriteUBOSet(descriptorSet, vulkanMaterial.textureSet);
		vulkanMaterial.descriptorSets.Add(descriptorSet);
	}

	material.gpuResourceID = handleValue.handle;
	return handleValue.handle;
}