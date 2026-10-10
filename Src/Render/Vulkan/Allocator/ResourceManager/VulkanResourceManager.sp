package VulkanRenderer

import HandleSet
import SparseSet
import RenderComponents
import RenderAssetDef
import Transform
import Array
import Atomic

MaxModelCount := uint32(4096);
MaxSharedIndexCount := uint32(1 << 22);

DebugTextureSize := uint32(16);
DebugTextureSquare := uint32(4);

state VulkanResourceManager
{
	renderTargetMap := Map<*VkImage_T, VulkanRenderTarget>(),
	renderBufferMap := Map<*VkBuffer_T, VulkanRenderBuffer>(),

	bindless: VulkanBindlessResources,

	meshes := HandleSet<VulkanMesh>(),

	defaultBuffers := Map<Value, BufferHandle, HashValue>(),

	retiredResources: Array<VulkanRetiredResource>,

	sharedIndexBuffer: BufferHandle,
	sharedIndexCount: uint32
}

VulkanResourceManager::()
{
	this.bindless.Init();
	this.CreateDebugTexture();

	device := vulkanInstance.device;
	allocator := vulkanInstance.allocator;

	indexBuffer := CreateVkBuffer(device, IndexBufferCreateInfo(MaxSharedIndexCount * #sizeof uint16));
	this.sharedIndexBuffer.buffer = indexBuffer;
	this.sharedIndexBuffer.handle = allocator.AllocBuffer(indexBuffer, VulkanMemoryFlags.GPU);
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

	defaultTextureSlot := this.bindless.images.Emplace(debugTexture);
	this.bindless.RegisterTexture(defaultTextureSlot, debugTexture.imageView);

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
	this.bindless.RegisterSampler(sampler);
}

BufferHandle VulkanResourceManager::GetDefaultBuffer(value: Value, size: uint32)
{
	cached := this.defaultBuffers.Find(value);
	if (cached) return cached~;

	bufferHandle := UploadBuffer(VertexBufferCreateInfo(size), value.val@ as *byte, size);
	this.defaultBuffers.Insert(value, bufferHandle);

	return bufferHandle;
}

VulkanResourceManager::UploadMesh(mesh: *Mesh)
{
	if (mesh.gpuResourceID) 
	{
		return;
	}
	
	handleValue := this.meshes.GetNext();
	resourceID := handleValue.handle;
	vulkanMesh := handleValue.value;

	mesh.gpuResourceID = resourceID;

	this.UploadGeometry(mesh.geometry@, vulkanMesh.geometry@);
	this.UploadMaterial(mesh.material@, vulkanMesh.material@);
}

VulkanResourceManager::UploadGeometry(geometry: *Geometry, vulkanGeometry: *VulkanGeometry)
{
	vulkanGeometry~ = VulkanGeometry();

	assetDef := GetAssetDefWithHandle(geometry.defHandle);

	attributeCount := geometry.attributes.count;

	attributeSlots := ECS.FrameAllocArray<VulkanGeometryAttrSlot>(attributeCount);

	if (attributeCount)
	{
		vulkanGeometry.attributes = Array<VulkanAllocHandle>(attributeCount);
		vulkanGeometry.attributeBufferSlots = Array<uint32>(attributeCount);

		vertexAttr := geometry.attributes[0];
		attrDef := assetDef.vertex.attributes[0].def;
		vulkanGeometry.vertexCount = uint32(vertexAttr.count / attrDef.ValueSize());

		geometry.ComputeBounds();
	}

	for (i .. attributeCount)
	{
		attribute := geometry.attributes[i];
		attrDef := assetDef.vertex.attributes[i].def;
		
		bufferHandle := BufferHandle();
		attrSlot := VulkanGeometryAttrSlot();

		if (attribute.count)
		{
			bufferHandle = UploadBuffer(VertexBufferCreateInfo(attribute.count), attribute.start, attribute.count);
			attrSlot.index = this.bindless.RegisterBuffer(bufferHandle.buffer);
			attrSlot.stride = attrDef.ValueSize() / #sizeof uint32;
		}
		else
		{
			bufferHandle = this.GetDefaultBuffer(attrDef.defaultValue, attrDef.ValueSize());
			attrSlot.index = this.bindless.RegisterBuffer(bufferHandle.buffer);
			attrSlot.stride = uint32(0);
		}

		vulkanGeometry.attributes.Add(bufferHandle.handle);
		vulkanGeometry.attributeBufferSlots.Add(attrSlot.index);
		attributeSlots.Add(attrSlot);
	}

	stagingBuffer := vulkanInstance.GetStagingBuffer();

	if (geometry.indexKind != IndexKind.None)
	{
		indices := geometry.indices;
		indexSize := indices.count * #sizeof uint16;

		vulkanGeometry.firstIndex = this.sharedIndexCount;
		vulkanGeometry.indexCount = indices.count;

		stagingBuffer.StagedBufferCopy(
			vulkanInstance.device,
			indices.start as *byte,
			indexSize,
			this.sharedIndexBuffer.buffer,
			vulkanInstance.transferCommands,
			vulkanInstance.queues.transferQueue,
			this.sharedIndexCount * #sizeof uint16
		);
		this.sharedIndexCount += indices.count;
	}

	vulkanGeometry.attributeSlots = UploadBindlessSlots<VulkanGeometryAttrSlot>(attributeSlots[0]@, attributeSlots.count);
	vulkanGeometry.variables = UploadVariableSet(assetDef.vertex.variables, geometry.variables);
}

VulkanResourceManager::UploadMaterial(material: *Material, vulkanMaterial: *VulkanMaterial)
{
	vulkanMaterial~ = VulkanMaterial();

	assetDef := GetAssetDefWithHandle(material.defHandle);

	textureCount := material.textures.count;
	textureSlots := ECS.FrameAllocArray<VulkanMaterialTextureSlot>(textureCount);

	for (i .. textureCount)
	{
		textureSlot := VulkanMaterialTextureSlot();
		textureMap := material.textures[i];
		textureDef := assetDef.fragment.textures[i];
		if (!textureMap)
		{
			textureSlot.textureIndex = this.bindless.UploadDefaultTexture(textureDef);
			textureSlot.samplerIndex = this.bindless.UploadSampler(Texture());
		}
		else
		{
			textureSlot.textureIndex = this.bindless.UploadTexture(textureMap, textureDef);
			textureSlot.samplerIndex = this.bindless.UploadSampler(textureMap.texture);
		}

		textureSlots.Add(textureSlot);
	}

	vulkanMaterial.textureSlots = UploadBindlessSlots<VulkanMaterialTextureSlot>(textureSlots[0]@, textureSlots.count);
	vulkanMaterial.variables = UploadVariableSet(assetDef.fragment.variables, material.variables);
}

bool VulkanResourceManager::UpdateGeometryVariable(mesh: *Mesh, variableIndex: uint32)
{
	if (!mesh.gpuResourceID) return false;

	vulkanMesh := this.meshes.Get(mesh.gpuResourceID);

	assetDef := GetAssetDefWithHandle(mesh.geometry.defHandle);
	variables := assetDef.vertex.variables;
	offset := FindVariableSetOffsetAtIndex(variables, variableIndex);
	size := variables.sets[variableIndex].def.ValueSize();

	stagingBuffer := vulkanInstance.GetStagingBuffer();
	stagingBuffer.StagedBufferCopy(
		vulkanInstance.device,
		(mesh.geometry.variables + offset) as *byte,
		size,
		vulkanMesh.geometry.variables.buffer,
		vulkanInstance.transferCommands,
		vulkanInstance.queues.transferQueue,
		offset
	);
	return true;
}

bool VulkanResourceManager::UpdateGeometryAttribute(mesh: *Mesh, attributeIndex: uint32)
{
	if (!mesh.gpuResourceID) return false;

	vulkanMesh := this.meshes.Get(mesh.gpuResourceID);
	vulkanGeometry := vulkanMesh.geometry;

	assetDef := GetAssetDefWithHandle(mesh.geometry.defHandle);
	attribute := mesh.geometry.attributes[attributeIndex];
	attrDef := assetDef.vertex.attributes[attributeIndex].def;

	oldAlloc := vulkanGeometry.attributes[attributeIndex];
	defaultBuffer := this.defaultBuffers.Find(attrDef.defaultValue);
	if (!defaultBuffer || defaultBuffer.handle.handle != oldAlloc.handle) this.RetireAlloc(oldAlloc);
	this.RetireSlot(VulkanRetiredKind.BindlessBuffer, vulkanGeometry.attributeBufferSlots[attributeIndex]);

	bufferHandle := BufferHandle();
	attrSlot := VulkanGeometryAttrSlot();

	if (attribute.count)
	{
		bufferHandle = UploadBuffer(VertexBufferCreateInfo(attribute.count), attribute.start, attribute.count);
		attrSlot.index = this.bindless.RegisterBuffer(bufferHandle.buffer);
		attrSlot.stride = attrDef.ValueSize() / #sizeof uint32;
	}
	else
	{
		bufferHandle = this.GetDefaultBuffer(attrDef.defaultValue, attrDef.ValueSize());
		attrSlot.index = this.bindless.RegisterBuffer(bufferHandle.buffer);
		attrSlot.stride = uint32(0);
	}

	vulkanGeometry.attributes[attributeIndex] = bufferHandle.handle;
	vulkanGeometry.attributeBufferSlots[attributeIndex] = attrSlot.index;

	slotSize := #sizeof VulkanGeometryAttrSlot;
	stagingBuffer := vulkanInstance.GetStagingBuffer();
	stagingBuffer.StagedBufferCopy(
		vulkanInstance.device,
		attrSlot@ as *byte,
		slotSize,
		vulkanGeometry.attributeSlots.buffer,
		vulkanInstance.transferCommands,
		vulkanInstance.queues.transferQueue,
		attributeIndex * slotSize
	);

	if (attributeIndex == 0)
	{
		vulkanGeometry.vertexCount = uint32(attribute.count / attrDef.ValueSize());
		mesh.geometry.ComputeBounds();
	}

	return true;
}

bool VulkanResourceManager::UpdateMaterialVariable(mesh: *Mesh, variableIndex: uint32)
{
	if (!mesh.gpuResourceID) return false;

	vulkanMesh := this.meshes.Get(mesh.gpuResourceID);

	assetDef := GetAssetDefWithHandle(mesh.material.defHandle);
	variables := assetDef.fragment.variables;
	offset := FindVariableSetOffsetAtIndex(variables, variableIndex);
	size := variables.sets[variableIndex].def.ValueSize();

	stagingBuffer := vulkanInstance.GetStagingBuffer();
	stagingBuffer.StagedBufferCopy(
		vulkanInstance.device,
		(mesh.material.variables + offset) as *byte,
		size,
		vulkanMesh.material.variables.buffer,
		vulkanInstance.transferCommands,
		vulkanInstance.queues.transferQueue,
		offset
	);
	return true;
}

bool VulkanResourceManager::UpdateMaterialTexture(mesh: *Mesh, textureIndex: uint32)
{
	if (!mesh.gpuResourceID) return false;

	vulkanMesh := this.meshes.Get(mesh.gpuResourceID);

	assetDef := GetAssetDefWithHandle(mesh.material.defHandle);
	textureMap := mesh.material.textures[textureIndex];
	textureDef := assetDef.fragment.textures[textureIndex];

	textureSlot := VulkanMaterialTextureSlot();
	if (!textureMap)
	{
		textureSlot.textureIndex = this.bindless.UploadDefaultTexture(textureDef);
		textureSlot.samplerIndex = this.bindless.UploadSampler(Texture());
	}
	else
	{
		textureSlot.textureIndex = this.bindless.UploadTexture(textureMap, textureDef);
		textureSlot.samplerIndex = this.bindless.UploadSampler(textureMap.texture);
	}

	slotSize := #sizeof VulkanMaterialTextureSlot;
	stagingBuffer := vulkanInstance.GetStagingBuffer();
	stagingBuffer.StagedBufferCopy(
		vulkanInstance.device,
		textureSlot@ as *byte,
		slotSize,
		vulkanMesh.material.textureSlots.buffer,
		vulkanInstance.transferCommands,
		vulkanInstance.queues.transferQueue,
		textureIndex * slotSize
	);
	return true;
}

bool VulkanResourceManager::RemoveMesh(mesh: *Mesh)
{
	resourceID := mesh.gpuResourceID;
	if (!this.meshes.Has(resourceID)) return false;

	vulkanMesh := this.meshes.Get(resourceID);

	vulkanGeometry := vulkanMesh.geometry;
	for (i .. vulkanGeometry.attributes.count)
	{
		if (mesh.geometry.attributes[i].count) this.RetireAlloc(vulkanGeometry.attributes[i]);
		this.RetireSlot(VulkanRetiredKind.BindlessBuffer, vulkanGeometry.attributeBufferSlots[i]);
	}
	delete vulkanGeometry.attributes;
	delete vulkanGeometry.attributeBufferSlots;

	this.RetireBuffer(vulkanGeometry.attributeSlots);
	this.RetireBuffer(vulkanGeometry.variables);
	this.RetireBuffer(vulkanMesh.material.textureSlots);
	this.RetireBuffer(vulkanMesh.material.variables);

	this.meshes.Remove(resourceID);
	return true;
}

bool VulkanResourceManager::RemoveImage(id: uint32)
{
	imageHandleCache := this.bindless.imageHandleCache;
	if (!imageHandleCache.Has(id)) return false;

	slot := imageHandleCache.Get(id)~;
	vulkanTexture := this.bindless.images.Get(slot);

	this.RetireImageView(vulkanTexture.imageView);
	this.RetireAlloc(vulkanTexture.imageAlloc);
	this.RetireSlot(VulkanRetiredKind.BindlessImage, slot);

	imageHandleCache.Remove(id);
	return true;
}

VulkanResourceManager::Retire(retired: VulkanRetiredResource)
{
	retired.submitValue = vulkanInstance.submitValue;
	this.retiredResources.Add(retired);
}

VulkanResourceManager::RetireAlloc(alloc: VulkanAllocHandle)
{
	retired := VulkanRetiredResource();
	retired.kind = VulkanRetiredKind.Alloc;
	retired.data.alloc = alloc;
	this.Retire(retired);
}

VulkanResourceManager::RetireBuffer(bufferHandle: BufferHandle)
{
	if (!bufferHandle.buffer) return;
	this.RetireAlloc(bufferHandle.handle);
}

VulkanResourceManager::RetireImageView(imageView: *VkImageView_T)
{
	retired := VulkanRetiredResource();
	retired.kind = VulkanRetiredKind.ImageView;
	retired.data.imageView = imageView;
	this.Retire(retired);
}

VulkanResourceManager::RetireSlot(kind: VulkanRetiredKind, slot: uint32)
{
	retired := VulkanRetiredResource();
	retired.kind = kind;
	retired.data.slot = slot;
	this.Retire(retired);
}

VulkanResourceManager::DestroyRetired(retired: VulkanRetiredResource)
{
	switch (retired.kind)
	{
		case (VulkanRetiredKind.Alloc) vulkanInstance.allocator.FreeAlloc(retired.data.alloc);
		case (VulkanRetiredKind.ImageView) vkDestroyImageView(vulkanInstance.device, retired.data.imageView, null);
		case (VulkanRetiredKind.BindlessImage) this.bindless.images.Remove(retired.data.slot);
		case (VulkanRetiredKind.BindlessBuffer) this.bindless.buffers.Remove(retired.data.slot);
	}
}

VulkanResourceManager::ReleaseRetired()
{
	completed := vulkanInstance.CompletedSubmitValue();

	kept := uint32(0);
	for (i .. this.retiredResources.count)
	{
		retired := this.retiredResources[i];
		if (retired.submitValue <= completed)
		{
			this.DestroyRetired(retired);
		}
		else
		{
			this.retiredResources[kept] = retired;
			kept += 1;
		}
	}
	this.retiredResources.count = kept;
}