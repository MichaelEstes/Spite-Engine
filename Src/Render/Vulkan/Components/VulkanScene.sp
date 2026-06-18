package VulkanRenderer

import RenderComponents
import Array
import Resource
import ImageManager
import Matrix
import Common

MaxMaterialTextures := 8;
MaxUVs := 4;

SceneSet := 0;
MaterialSet := 1;
TexturesSet := 2;

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
	attributes: Array<VulkanAllocHandle>,
	variables: Array<VulkanAllocHandle>

	indexHandle: VulkanAllocHandle,
	indexCount: uint32,
	
	topology: VkPrimitiveTopology,
	indexKind: VkIndexType,
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
	textures: Array<VulkanTexture>,
	variables: Array<VulkanAllocHandle>,

	polygonMode: VkPolygonMode,
	cullMode: VkCullModeFlagBits,
	alphaMode: VulkanAlphaMode
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

bool AddSceneCallbacks()
{
	ECS.OnSceneCreated(
		::(scene: *Scene, data: *void) 
		{
			//log "Scene Created";
			sceneID := scene.id;
		}
	);

	ECS.OnSceneRemoved(
		::(scene: *Scene, data: *void) 
		{
			//log "Scene Removed";
			sceneID := scene.id;
		}
	);

	return true;
}
_ := AddSceneCallbacks();

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