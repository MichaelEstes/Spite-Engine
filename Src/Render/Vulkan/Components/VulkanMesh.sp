package VulkanRenderer

import Render
import Array

enum GeometryAttributeFlags: uint16
{
	None = 0,
	Tangent = 1 << 0,
    Color = 1 << 1,
    UV0 = 1 << 2,
    UV1 = 1 << 3,
    UV2 = 1 << 4,
    UV3= 1 << 5,
}

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

	geoKind: GeometryKind,
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

state VulkanMaterial
{
	test: uint
}

state VulkanMesh
{
	geos: Allocator<VulkanGeometry>,
	mats: Allocator<VulkanMaterial>,
	count: uint32
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

	primCount := mesh.primitives.count;
	vulkanMesh := VulkanMesh();
	vulkanMesh.geos.Alloc(primCount);
	vulkanMesh.mats.Alloc(primCount);
	vulkanMesh.count = primCount;

	for (i .. primCount)
	{
		primitive := mesh.primitives[i];
		geo := primitive.geometry;
		mat := primitive.material;

		vulkanGeo := UploadGeometry(geo, renderer);
		vulkanMesh.geos[i]~ = vulkanGeo;
	}
	
	scene.SetComponentDirect<VulkanMesh>(entity, vulkanMesh, VulkanMeshComponent);
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

VulkanGeometry UploadGeometry(geo: Geometry, renderer: *VulkanRenderer)
{
	device := renderer.device;
	commands := renderer.transferCommands;
	queue := renderer.queues.transferQueue;

	vulkanGeo := VulkanGeometry();

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
	vulkanGeo.vertexHandle = vertexBufferHandle;

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
		vulkanGeo.indexHandle = indexBufferHandle;

		if (geo.indexKind == IndexKind.I32)
		{
			vulkanGeo.indexKind = VkIndexType.VK_INDEX_TYPE_UINT32;
		}
	}

	return vulkanGeo;
}


