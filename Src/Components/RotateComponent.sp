package RotateComponent

import Quaternion
import Transform

state RotateOverTime
{
	axis: Norm<Vec3>,
	speed: float32
}

RotateOverTimeComponent := ECS.RegisterComponent<RotateOverTime>(
	ComponentKind.Sparse
);

RotateOverTimeSystem := ECS.RegisterSystem(::(scene: Scene, dt: float) 
{
	for (entityComponent in scene.Iterate<RotateOverTime>())
	{
		entity := entityComponent.entity;
		rotate := entityComponent.component;
		transform := scene.GetComponent<Transform>(entity);
		if (!transform) continue;
		
		angle := rotate.speed * dt;
		delta := Quaternion(rotate.axis, angle);
		transform.rotation = delta * transform.rotation;
		transform.rotation.Normalize();
		SetTransformDirty(scene, entity);
	}
});