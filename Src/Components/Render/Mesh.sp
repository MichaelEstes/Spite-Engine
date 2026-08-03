package RenderComponents

import Array
import ECS
import Event

MeshEntitySetEvent := RegisterEvent<SceneEntity>();
MeshEntityRemovedEvent := RegisterEvent<SceneEntity>();


state Mesh
{
    primitives: Array<Primitive>,
	gpuID: uint32
}

Mesh::delete
{
	delete this.primitives;
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