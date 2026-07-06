package RenderComponents

import Array
import ECS
import Event

MeshCreatedEvent := RegisterEvent<*Mesh>();
MeshRemovedEvent := RegisterEvent<*Mesh>();

MeshEntityAddedEvent := RegisterEvent<SceneEntity>();
MeshEntityRemovedEvent := RegisterEvent<SceneEntity>();


state Mesh
{
    primitives: Array<Primitive>,
}

Mesh::delete
{
	delete this.primitives;
}

MeshComponent := ECS.RegisterComponent<Mesh>(
	ComponentKind.Sparse,
	::(entity: Entity, mesh: *Mesh, scene: Scene)
	{
		ECS.instance.events.Emit<SceneEntity>(MeshEntityRemovedEvent, SceneEntity(scene@, entity));
		ECS.instance.events.Emit<*Mesh>(MeshRemovedEvent, mesh);
		delete mesh~;
	}
	::(entity: Entity, mesh: *Mesh, scene: Scene)
	{
		log "Adding mesh component";
		ECS.instance.events.Emit<*Mesh>(MeshCreatedEvent, mesh);
		ECS.instance.events.Emit<SceneEntity>(MeshEntityAddedEvent, SceneEntity(scene@, entity));
	}
);