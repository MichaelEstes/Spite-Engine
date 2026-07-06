package VulkanRenderer

import RenderComponents
import Array
import Resource
import ImageManager
import Matrix
import Common

indexKindToByteCount := [
	1,
	2,
	4
];

state VulkanGeometry
{
	attributes: Array<VulkanAllocHandle>,
	attributeBuffers: Array<*VkBuffer_T>,
	strides: Array<uint64>,

	variables: Array<VulkanAllocHandle>
	descriptorSets: Array<*VkDescriptorSet_T>,

	indexHandle: VulkanAllocHandle,
	indexBuffer: *VkBuffer_T,
	
	indexCount: uint32,
	indexKind: VkIndexType,
	vertexCount: uint32,
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
	textureSet: VulkanAllocHandle,

	variables: Array<VulkanAllocHandle>,
	descriptorSets: Array<*VkDescriptorSet_T>
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

