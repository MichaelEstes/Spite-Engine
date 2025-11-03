package RenderComponents

import ECS
import Vec
import Quaternion
import Matrix

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

Camera::LookAt(target: Vec3, up: Vec3 = Vec3(0.0, 0.0, 1.0))
{
	pos := this.position;
	forward := (target - pos).Normalize().vec;
	right := forward.Cross(up).Normalize().vec;
	trueUp := right.Cross(forward);

	lookAtMat := Matrix3([
		float32:[right.x, trueUp.x,	-forward.x],
		float32:[right.y, trueUp.y,	-forward.y],
		float32:[right.z, trueUp.z, -forward.z],
	]);

	this.rotation.FromRotationMatrix(lookAtMat).Normalize();
}

MainCameraComponent := ECS.RegisterComponent<Camera>(
	ComponentKind.Singleton,
	::(entity: Entity, camera: *Camera, scene: Scene) {
		//log "Removing main camera"
	}
	::(entity: Entity, camera: *Camera, scene: Scene) {
		//log "Setting main camera"
	}
);