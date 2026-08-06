package RenderComponents

import Array
import ECS
import Event

MeshEntitySetEvent := RegisterEvent<SceneEntity>();
MeshEntityRemovedEvent := RegisterEvent<SceneEntity>();


state Mesh
{
	geometry: Geometry,
    material: Material,

    defHandle: AssetDefHandle
	gpuResourceID: uint32
}

Mesh::(defHandle: AssetDefHandle)
{
    this.defHandle = defHandle;
    this.geometry = Geometry(defHandle);
    this.material = Material(defHandle);
}

Mesh::delete
{
	delete this.geometry;
    delete this.material;
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
		log "Adding mesh component";
		ECS.instance.events.Emit<SceneEntity>(MeshEntitySetEvent, SceneEntity(scene@, entity));
	}
);