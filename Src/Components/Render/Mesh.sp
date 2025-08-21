package Render

import Array
import ECS
import Event

MeshAddedEvent := RegisterEvent<SceneEntity>();

state Mesh
{
    primitives: Array<Primitive>
}

Mesh::delete
{
	delete this.primitives;
}

MeshComponent := ECS.RegisterComponent<Mesh>(
	ComponentKind.Sparse, 
	::(entity: Entity, mesh: *Mesh, scene: Scene) 
	{
		delete mesh~;
	}
	::(entity: Entity, mesh: *Mesh, scene: Scene) 
	{
		ECS.instance.events.Emit<SceneEntity>(MeshAddedEvent, SceneEntity(scene@, entity));
	}
);