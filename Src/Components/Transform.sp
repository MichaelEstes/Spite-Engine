package Transform

import ECS
import Vec
import Matrix
import Quaternion
import SceneComponents

state Transform
{
	rotation: Quaternion,
	position: Vec3,
	scale: Vec3
}

Transform::(pos: Vec3, rot: Quaternion = Quaternion(), scale: Vec3 = Vec3(1.0, 1.0, 1.0))
{
	this.position = pos;
	this.rotation = rot;
	this.scale = scale;
}

Transform::RotateAround(axis: Norm<Vec3>, angle: float32)
{
	rot := Quaternion(axis, angle);
	this.rotation = rot * this.rotation;
}

state WorldTransform
{
	mat: Matrix4
}

WorldTransformComponent := ECS.RegisterComponent<WorldTransform>(
	ComponentKind.Common, 
);

TransformDirtyTag := ECS.RegisterTagComponent(
	"TransformDirtyTag"
	ComponentKind.Common
);

TransformUpdatedTag := ECS.RegisterTagComponent(
	"TransformUpdatedTag"
	ComponentKind.Common
);

SetTransformDirty(scene: Scene, entity: Entity) =>
{
	scene.SetTagComponent(entity, TransformDirtyTag);
}

TransformComponent := ECS.RegisterComponent<Transform>(
	ComponentKind.Common, 
	::(entity: Entity, transform: *Transform, scene: Scene) 
	{
		//log "Removing transform: ", transform;
	}
	::(entity: Entity, transform: *Transform, scene: Scene) 
	{
		SetTransformDirty(scene, entity);
	}
);

UpdateWorldTransform(entity: Entity, scene: Scene)
{
	if (!scene.HasTagComponent(entity, TransformDirtyTag)) return;
	transform := scene.GetComponentDirect<Transform>(entity, TransformComponent);
	if (!transform) return;

	worldMatrix := WorldTransform();
	worldMatrix.mat.Compose(transform.position, transform.rotation, transform.scale);
	hierarchy := scene.GetComponentDirect<Hierarchy>(entity, HierarchyComponent);
	if (hierarchy && hierarchy.parent.id)
	{
		UpdateWorldTransform(hierarchy.parent, scene);
		parentWorld := scene.GetComponentDirect<WorldTransform>(
			hierarchy.parent, 
			WorldTransformComponent
		);
		if (parentWorld)
		{
			worldMatrix.mat = parentWorld.mat * worldMatrix.mat;
		}
	}

	scene.RemoveTagComponent(entity, TransformDirtyTag);
	scene.SetComponentDirect<WorldTransform>(entity, worldMatrix, WorldTransformComponent);
	scene.SetTagComponent(entity, TransformUpdatedTag);
}

TransformUpdateSystem := ECS.RegisterSystem(::(scene: Scene, dt: float) 
{
	for (entity in scene.IterateTagComponent(TransformDirtyTag))
	{
		UpdateWorldTransform(entity, scene);
	}
}, SystemStep.PreDraw);

TransformPostSystem := ECS.RegisterSystem(::(scene: Scene, dt: float) 
{
	scene.ClearTagComponent(TransformUpdatedTag);
}, SystemStep.PostFrame);

