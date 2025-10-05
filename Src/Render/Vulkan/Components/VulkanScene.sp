package VulkanRenderer

import RenderComponents
import Array
import Resource
import ImageManager
import Matrix


MaxMaterialTextures := 8;

geometryKindToTopologyTable := [
	VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST,
	VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP,
	VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_FAN,

	VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_LINE_LIST,
	VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_LINE_STRIP,
	VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_LINE_STRIP,

	VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_POINT_LIST,
];

indexKindToByteCount := [
	1,
	2,
	4
];

state VulkanGeometry
{
	vertexHandle: VulkanAllocHandle,
	indexHandle: VulkanAllocHandle,
	normals: VulkanAllocHandle,

	tangents: VulkanAllocHandle,

	color: VulkanAllocHandle,

	uvs: [4]VulkanAllocHandle = [
		VulkanAllocHandle(),
		VulkanAllocHandle(),
		VulkanAllocHandle(),
		VulkanAllocHandle()
	],


	indexCount: uint32,
	topology: VkPrimitiveTopology,
	indexKind: VkIndexType,
}

GeometryAttributeFlags VulkanGeometry::GetAttributesFlags()
{
	mask := GeometryAttributeFlags.None;
	if (this.tangents.handle) mask |= GeometryAttributeFlags.Tangent;
	if (this.color.handle) mask |= GeometryAttributeFlags.Color;

	for (i .. 4)
	{
		if (this.uvs[i].handle)
		{
			mask |= (GeometryAttributeFlags.UV0 << i);
		}
	}

	return mask;
}

state VulkanTexture
{
	image: *VkImage_T,
	imageView: *VkImageView_T,
	sampler: *VkSampler_T,
	
	layout: VkImageLayout,
	imageAlloc: VulkanAllocHandle
}

state VulkanMaterial
{
	textures: [MaxMaterialTextures]VulkanTexture,
	textureDescSet: *VkDescriptorSet_T,

	vertShaderHandle: ResourceHandle,
	fragShaderHandle: ResourceHandle,

	polygonMode: VkPolygonMode,
	cullMode: VkCullModeFlagBits,
	alphaMode: VulkanAlphaMode
}

VulkanMaterial::()
{
	for (i .. MaxMaterialTextures)
	{
		this.textures[i] = VulkanTexture();
	}
}

state VulkanMesh
{
	geometry: VulkanGeometry,
	material: VulkanMaterial,
	entity: Entity
}

VulkanMesh::delete
{
	log "Removing Vulkan mesh";
}

VulkanPipelineMeshState VulkanMesh::GetPipelineMeshState()
{
	meshState := VulkanPipelineMeshState();

	meshState.vertShaderHandle = this.material.vertShaderHandle;
	meshState.fragShaderHandle = this.material.fragShaderHandle;

	meshState.geometryFlags = this.geometry.GetAttributesFlags();

	meshState.SetTopology(this.geometry.topology);

	meshState.SetPolygonMode(this.material.polygonMode);
	meshState.SetAlphaMode(this.material.alphaMode);
	meshState.SetCullMode(this.material.cullMode);

	return meshState;
}

meshGroupsByScene := SparseSet<Map<VulkanPipelineMeshState, Array<VulkanMesh>, HashPipelineMeshState>>();

bool AddSceneCallbacks()
{
	ECS.OnSceneCreated(
		::(scene: *Scene) 
		{
			//log "Scene Created";
			sceneID := scene.id;
			meshGroupsByScene.Insert(sceneID, Map<VulkanPipelineMeshState, Array<VulkanMesh>>());
		}
	);

	ECS.OnSceneRemoved(
		::(scene: *Scene) 
		{
			//log "Scene Removed";
			sceneID := scene.id;
			map := meshGroupsByScene.Get(sceneID)~;
			for (meshArr in map.Values()) 
			{
				delete meshArr;
			}
			delete map;
			meshGroupsByScene.Remove(sceneID);
		}
	);

	return true;
}
_ := AddSceneCallbacks();

UploadMesh(sceneEntity: SceneEntity, mesh: *Mesh, renderer: *VulkanRenderer)
{
	scene := sceneEntity.scene;
	entity := sceneEntity.entity;

	log "Uploading mesh: ", entity;

	primCount := mesh.primitives.count;

	meshMap := meshGroupsByScene.Get(scene.id);

	for (i .. primCount)
	{
		primitive := mesh.primitives[i];
		geo := primitive.geometry;
		mat := primitive.material;

		vulkanMesh := VulkanMesh();
		vulkanMesh.geometry = UploadGeometry(geo, renderer);
		vulkanMesh.material = UploadMaterial(mat, renderer);
		vulkanMesh.entity = entity;

		pipelineMeshKey := vulkanMesh.GetPipelineMeshState();

		if (!meshMap.Has(pipelineMeshKey))
		{
			meshMap.Insert(pipelineMeshKey, Array<VulkanMesh>())
		}

		meshArr := meshMap.Find(pipelineMeshKey);
		meshArr.Add(vulkanMesh);
	}
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

VulkanGeometry UploadGeometry(geo: Geometry, renderer: *VulkanRenderer)
{
	vulkanGeo := VulkanGeometry();

	device := renderer.device;
	commands := renderer.transferCommands;
	queue := renderer.queues.transferQueue;

	vulkanGeo.topology = geometryKindToTopologyTable[geo.kind];

	vertexSize := uint(geo.vertices.count * (#sizeof Vec3));
	indexSize := uint(geo.indices.count * (#sizeof uint16));

	normalSize := uint(geo.normals.count * (#sizeof Vec3));
	tangentSize := uint(geo.tangents.count * (#sizeof Vec4));
	
	vertexBuffer := CreateVkBuffer(device, VertexBufferCreateInfo(vertexSize));
	vertexBufferHandle := renderer.allocator.AllocBuffer(vertexBuffer, VulkanMemoryFlags.GPU);
	renderer.stagingBuffer.StagedBufferCopy(
		renderer.device,
		geo.vertices[0]@ as *byte
		vertexSize,
		vertexBuffer,
		commands,
		queue
	);
	vulkanGeo.vertexHandle = vertexBufferHandle;

	if (indexSize)
	{
		indexBuffer := CreateVkBuffer(device, IndexBufferCreateInfo(indexSize));
		indexBufferHandle := renderer.allocator.AllocBuffer(indexBuffer, VulkanMemoryFlags.GPU);
		renderer.stagingBuffer.StagedBufferCopy(
			renderer.device,
			geo.indices[0]@ as *byte
			indexSize,
			indexBuffer,
			commands,
			queue
		);
		vulkanGeo.indexHandle = indexBufferHandle;
		
		vulkanGeo.indexCount = indexSize / indexKindToByteCount[geo.indexKind];
		if (geo.indexKind == IndexKind.I32)
		{
			vulkanGeo.indexKind = VkIndexType.VK_INDEX_TYPE_UINT32;
		}
	}

	return vulkanGeo;
}

VulkanTexture UploadTexture(textureMap: TextureMap, renderer: *VulkanRenderer, format: VkFormat)
{
	vulkanTexture := VulkanTexture();

	device := renderer.device;
	commands := renderer.transferCommands;
	transferQueue := renderer.queues.transferQueue;
	commandPool := renderer.graphicsCommands.commandPool;
	graphicsQueue := renderer.queues.graphicsQueue;
	
	image := ImageResourceManager.GetResource(textureMap.texture.imageHandle).data.image;
	
	width := image.w as uint32;
	height := image.h as uint32;
	pixels := image.pixels;
	imageSize: uint32 = height * image.pitch;
	
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
	vulkanImageHandle := renderer.allocator.AllocImage(vulkanImage, VulkanMemoryFlags.GPU);
	
	vkQueueWaitIdle(graphicsQueue);
	
	TransitionImageLayout(
		device, commandPool, graphicsQueue, vulkanImage, 
		VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED, VkImageLayout.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, 
		format
	);

	renderer.stagingBuffer.StagedImageCopy(
		device,
		pixels as *byte,
		imageSize,
		vulkanImage,
		width, 
		height,
		commands,
		transferQueue
	);

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

	vulkanImageView := CreateVkImageView(device, imageViewCreateInfo);

	samplerInfo := VkSamplerCreateInfo();
	samplerInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO;
	samplerInfo.magFilter = VkFilter.VK_FILTER_LINEAR;
	samplerInfo.minFilter = VkFilter.VK_FILTER_LINEAR;
	samplerInfo.addressModeU = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_REPEAT;
	samplerInfo.addressModeV = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_REPEAT;
	samplerInfo.addressModeW = VkSamplerAddressMode.VK_SAMPLER_ADDRESS_MODE_REPEAT;
	samplerInfo.anisotropyEnable = VkTrue;
	samplerInfo.maxAnisotropy = vulkanInstance.deviceProperties[renderer.deviceIndex].limits.maxSamplerAnisotropy;
	samplerInfo.borderColor = VkBorderColor.VK_BORDER_COLOR_INT_OPAQUE_BLACK;
	samplerInfo.unnormalizedCoordinates = VkFalse;
	samplerInfo.compareEnable = VkFalse;
	samplerInfo.compareOp = VkCompareOp.VK_COMPARE_OP_ALWAYS;
	samplerInfo.mipmapMode = VkSamplerMipmapMode.VK_SAMPLER_MIPMAP_MODE_LINEAR;
	samplerInfo.mipLodBias = 0.0;
	samplerInfo.minLod = 0.0;
	samplerInfo.maxLod = 0.0;

	vulkanSampler: *VkSampler_T = null;
	CheckResult(
		vkCreateSampler(device, samplerInfo@, null, vulkanSampler@),
		"UploadTexture Error creating Vulkan texture sampler"
	);

	vulkanTexture.image = vulkanImage;
	vulkanTexture.imageView = vulkanImageView;
	vulkanTexture.sampler = vulkanSampler;
	vulkanTexture.layout = VkImageLayout.VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
	vulkanTexture.imageAlloc = vulkanImageHandle;

	return vulkanTexture;
}

VulkanMaterial UploadMaterial(mat: Material, renderer: *VulkanRenderer)
{
	device := renderer.device;

	vulkanMat := VulkanMaterial();
	vulkanMat.vertShaderHandle = UseShader(device, mat.vertShader);
	vulkanMat.fragShaderHandle = UseShader(device, mat.fragShader);

	if (!!mat.color)
	{
		log "Uploading color texture";
		colorTex := UploadTexture(mat.color, renderer, VkFormat.VK_FORMAT_R8G8B8A8_SRGB);
		vulkanMat.textures[0] = colorTex;
	}

	vulkanMat.polygonMode = mat.polygonMode;
	vulkanMat.cullMode = mat.cullMode;
	vulkanMat.alphaMode = mat.alphaMode;

	CreateMaterialDescSet(vulkanMat, renderer);

	return vulkanMat;
}

CreateMaterialDescSet(mat: VulkanMaterial, renderer: *VulkanRenderer)
{
	device := renderer.device;
	layoutCache := renderer.pipelineLayoutCache~;
	pool := renderer.materialPool;
	
	key := PipelineLayoutKey(mat.vertShaderHandle, mat.fragShaderHandle);

	FindOrCreatePipelineLayout(device, key, layoutCache);

	setLayouts := layoutCache.descLayoutSetMap.Find(key);
	assert setLayouts;

	textureDescSetLayout := setLayouts~[2];

	allocInfo := VkDescriptorSetAllocateInfo();
	allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
	allocInfo.descriptorPool = pool;
	allocInfo.descriptorSetCount = 1;
	allocInfo.pSetLayouts = textureDescSetLayout@;

	CheckResult(
		vkAllocateDescriptorSets(device, allocInfo@, mat.textureDescSet@),
		"CreateMaterialDescSet Error allocating material Vulkan descriptor sets"
	);

	descriptorWrites := [MaxMaterialTextures]VkWriteDescriptorSet;
	imageInfos := [MaxMaterialTextures]VkDescriptorImageInfo;
	descriptorWriteCount := 0;
	for (i .. MaxMaterialTextures)
	{
		texture := mat.textures[i];
		if (!texture.image) break;

		descriptorWriteCount += 1;
		imageInfos[i] = VkDescriptorImageInfo();
		imageInfos[i].sampler = texture.sampler;   
		imageInfos[i].imageView = texture.imageView;
		imageInfos[i].imageLayout = VkImageLayout.VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;

		descriptorWrites[i] = VkWriteDescriptorSet();
		descriptorWrites[i].sType = VkStructureType.VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
		descriptorWrites[i].dstSet = mat.textureDescSet;
		descriptorWrites[i].dstBinding = i;
		descriptorWrites[i].dstArrayElement = 0;
		descriptorWrites[i].descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
		descriptorWrites[i].descriptorCount = 1;
		descriptorWrites[i].pImageInfo = imageInfos[i]@;
	}

	vkUpdateDescriptorSets(device, descriptorWriteCount, fixed descriptorWrites, 0, null);
}