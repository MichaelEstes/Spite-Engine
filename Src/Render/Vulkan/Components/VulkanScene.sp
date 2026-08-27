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

state VulkanMesh
{
	geometry: VulkanGeometry,
	material: VulkanMaterial
}

state VulkanGeometryAttrSlot
{
	index: uint32,
	stride: uint32
}

state VulkanGeometry
{
	attributes: Array<VulkanAllocHandle>,
	attributeSlots: BufferHandle,

	variables: BufferHandle,

	firstIndex: uint32,
	indexCount: uint32,
	vertexCount: uint32,
}

state VulkanMaterialTextureSlot
{
	textureIndex: uint32,
	samplerIndex: uint32
}

state VulkanMaterial
{
	textureSlots: BufferHandle,
	variables: BufferHandle
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

