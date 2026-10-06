package RenderComponents

import Array
import ECS
import Event
import Resource
import ImageManager

MeshEntitySetEvent := RegisterEvent<SceneEntity>();
MeshEntityRemovedEvent := RegisterEvent<SceneEntity>();
MeshDeletedEvent := RegisterEvent<*Mesh>();

state Mesh
{
	geometry: Geometry,
    material: Material,

	resourceHandle: ResourceHandle,
    defHandle: AssetDefHandle,
	gpuResourceID: uint32
}

Mesh::(defHandle: AssetDefHandle)
{
    this.defHandle = defHandle;
    this.geometry = Geometry(defHandle);
    this.material = Material(defHandle);
}

Mesh::(defHandle: AssetDefHandle, resourceHandle: ResourceHandle)
{
    this.defHandle = defHandle;
	this.resourceHandle = resourceHandle;
    this.geometry = Geometry(defHandle);
    this.material = Material(defHandle);
}

Mesh::delete
{
	if (!ResourceHasReference(this.resourceHandle)) 
    {
		ECS.instance.events.Emit<*Mesh>(MeshDeletedEvent, this@);
		delete this.geometry;
		delete this.material;
    }
}

Mesh::Init()
{
	// Mesh resources are owned by a resource manager
	if (this.resourceHandle.Valid()) return;

	for (textureMap in this.material.textures)
	{
		if (textureMap.texture.imageHandle == InvalidResourceHandle) continue;
		TakeResourceRef<ImageResource>(textureMap.texture.imageHandle);
	}
}

MeshComponent := ECS.RegisterComponent<Mesh>(
	ComponentKind.Common,
	::(entity: Entity, mesh: *Mesh, scene: Scene)
	{
		ECS.instance.events.Emit<SceneEntity>(MeshEntityRemovedEvent, SceneEntity(scene@, entity));
		delete mesh~;
	}
	::(entity: Entity, mesh: *Mesh, scene: Scene)
	{
		ECS.instance.events.Emit<SceneEntity>(MeshEntitySetEvent, SceneEntity(scene@, entity));
	}
);