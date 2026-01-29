package RenderComponents

import ECS
import Vec
import Quaternion
import Matrix
import Math

state Camera
{
	rotation: Quaternion,
	position: Vec3,

	fov: float32,
	aspect: float32,
	near: float32,
	far: float32
}

Matrix4 Camera::GetViewMatrix()
{
	rot := this.rotation.ToRotationMatrix();
	trans := (rot * this.position) * -1.0;

	view := Matrix4(rot);
	view[3] = float32:[trans.x, trans.y, trans.z, 1.0];

	return view;
}

Camera::LookAt(target: Vec3, up: Vec3 = Vec3(0.0, 1.0, 0.0))
{
	pos := this.position;
	forward := (target - pos);

	if (forward.SqrLength() == 0.0)
	{
		forward.z = 1.0;
	}
	forward.Normalize();

	right := forward.Cross(up);
	if (right.SqrLength() == 0.0)
	{
		if (Math.FAbs(up.z) == 1.0)
		{
			forward.x += 0.0001;
		}
		else
		{
			forward.z += 0.0001;
		}

		forward.Normalize();
		right = forward.Cross(up);
	}

	right.Normalize();
	trueUp := right.Cross(forward);

	lookAtMat := Matrix3([
		float32:[right.x, trueUp.x,	-forward.x],
		float32:[right.y, trueUp.y,	-forward.y],
		float32:[right.z, trueUp.z, -forward.z],
	]);

	this.rotation.FromRotationMatrix(lookAtMat).Normalize();
}

Vec3 Camera::Forward()
{
	return this.rotation.Forward();
}

MainCameraComponent := ECS.RegisterComponent<Camera>(
	ComponentKind.Sparse,
	::(entity: Entity, camera: *Camera, scene: Scene) {
		//log "Removing camera"
	}
	::(entity: Entity, camera: *Camera, scene: Scene) {
		//log "Setting camera", entity;
	}
);