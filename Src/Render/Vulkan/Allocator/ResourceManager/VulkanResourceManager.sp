package VulkanRenderer

import HandleSet
import SparseSet
import RenderComponents
import RenderAssetDef
import Transform
import Array

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

	defaultBuffers := Map<Value, BufferHandle, HashValue>()

	sharedIndexBuffer: BufferHandle,
	sharedIndexCount: uint32,
	currentMeshIndex: uint32 = 1
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

	attributeSlots := ECS.instance.frameAllocator.AllocArray<VulkanGeometryAttrSlot>(attributeCount);

	if (attributeCount)
	{
		vulkanGeometry.attributes = Array<VulkanAllocHandle>(attributeCount);

		vertexAttr := geometry.attributes[0];
		attrDef := assetDef.vertex.attributes[0].def;
		vulkanGeometry.vertexCount = uint32(vertexAttr.count / attrDef.ValueSize());

		geometry.ComputeBounds();
		vulkanGeometry.bounds = geometry.bounds;
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
	textureSlots := ECS.instance.frameAllocator.AllocArray<VulkanMaterialTextureSlot>(textureCount);

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