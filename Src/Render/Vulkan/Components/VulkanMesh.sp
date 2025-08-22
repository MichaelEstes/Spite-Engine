package VulkanRenderer

import Render

state VulkanMesh
{
	vertexHandle: VulkanAllocHandle,
	indexHandle: VulkanAllocHandle,
}

VulkanMeshComponent := ECS.RegisterComponent<VulkanMesh>(
	ComponentKind.Sparse, 
	::(entity: Entity, mesh: *VulkanMesh, scene: Scene) 
	{
		log "Removing Vulkan mesh", entity;
	}
	::(entity: Entity, mesh: *VulkanMesh, scene: Scene) 
	{
		log "Vulkan mesh added: ", entity;
	}
);

UploadMesh(sceneEntity: SceneEntity, mesh: *Mesh, renderer: *VulkanRenderer)
{
	scene := sceneEntity.scene;
	entity := sceneEntity.entity;

	log "Uploading mesh: ", entity;

	for (primitive in mesh.primitives)
	{
		geo := primitive.geometry;
		mat := primitive.material;

		UploadGeometry(sceneEntity, geo, renderer);

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

UploadGeometry(sceneEntity: SceneEntity, geo: Geometry, renderer: *VulkanRenderer)
{
	scene := sceneEntity.scene;
	entity := sceneEntity.entity;

	device := renderer.device;
	commands := renderer.transferCommands;
	queue := renderer.queues.transferQueue;

	vulkanMesh := VulkanMesh();

	vertexSize := uint(geo.vertices.count * (#sizeof Vec3));
	indexSize := uint(geo.indices.count * (#sizeof uint16));

	normalSize := uint(geo.normals.count * (#sizeof Vec3));
	tangentSize := uint(geo.tangents.count * (#sizeof Vec4));
	
	vertexBuffer := CreateVkBuffer(device, VertexBufferCreateInfo(vertexSize));
	vertexBufferHandle := renderer.allocator.AllocBuffer(vertexBuffer, VulkanMemoryFlags.GPU);
	renderer.stagingBuffer.StagedCopy(
		renderer.device,
		geo.vertices[0]@ as *byte
		vertexSize,
		vertexBuffer,
		commands,
		queue
	);
	vulkanMesh.vertexHandle = vertexBufferHandle;

	if (indexSize)
	{
		indexBuffer := CreateVkBuffer(device, VertexBufferCreateInfo(vertexSize));
		indexBufferHandle := renderer.allocator.AllocBuffer(indexBuffer, VulkanMemoryFlags.GPU);
		renderer.stagingBuffer.StagedCopy(
			renderer.device,
			geo.indices[0]@ as *byte
			indexSize,
			indexBuffer,
			commands,
			queue
		);
		vulkanMesh.indexHandle = indexBufferHandle;
	}

	scene.SetComponentDirect<VulkanMesh>(entity, vulkanMesh, VulkanMeshComponent);
}


