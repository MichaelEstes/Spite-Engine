package VulkanRenderer

import RenderComponents
import Array
import Resource
import ImageManager
import Matrix
import Common

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

