package VulkanRenderer

import Render
import Array

geometryKindToTopologyTable := [
	VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST,
	VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP,
	VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_FAN,

	VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_LINE_LIST,
	VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_LINE_STRIP,
	VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_LINE_STRIP,

	VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_POINT_LIST,
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

state VulkanMaterial
{
	test: uint
}

state VulkanMesh
{
	geometry: VulkanGeometry,
	material: VulkanMaterial,
	entity: Entity
}

VulkanPipelineMeshState VulkanMesh::GetPipelineMeshState()
{
	rasterState := VulkanPipelineMeshState();
	rasterState.geometryFlags = this.geometry.GetAttributesFlags();

	return rasterState;
}

meshGroupsByScene := SparseSet<Map<VulkanPipelineMeshState, Array<VulkanMesh>>>();

bool AddSceneCallbacks()
{
	ECS.OnSceneCreated(
		::(scene: *Scene) 
		{
			log "Scene Created";
			sceneID := scene.id;
			meshGroupsByScene.Insert(sceneID, Map<VulkanPipelineMeshState, Array<VulkanMesh>>());
		}
	);

	ECS.OnSceneRemoved(
		::(scene: *Scene) 
		{
			log "Scene Removed";
			sceneID := scene.id;
			map := meshGroupsByScene.Get(sceneID)~;
			for (meshArr in map.Values()) delete meshArr;
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

VulkanGeometry UploadGeometry(geo: Geometry, renderer: *VulkanRenderer)
{
	device := renderer.device;
	commands := renderer.transferCommands;
	queue := renderer.queues.transferQueue;

	vulkanGeo := VulkanGeometry();

	vulkanGeo.topology = geometryKindToTopologyTable[geo.kind];

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


