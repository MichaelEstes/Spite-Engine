package RenderComponents

import Input
import WindowComponent
import Math
import Quaternion

state CameraOrbit
{
	orbitCenter: Vec3 = Vec3(0.0, 0.0, 0.0),
	orbitUp: Vec3 = Vec3(0.0, 1.0, 0.0),
	scrollDamping: float32 = 0.1,
	panDamping: float32 = 0.0025,
	rotateDamping: float32 = 0.005
}

CameraOrbitComponent := ECS.RegisterComponent<CameraOrbit>(
	ComponentKind.Sparse
);

CameraOrbitSystem := ECS.RegisterSystem(::(scene: Scene, dt: float) {

	for (ec in scene.Iterate<CameraOrbit>())
	{
		entity := ec.entity;
		cameraOrbit := ec.component;
		camera := scene.GetComponent<Camera>(entity);
		window := scene.GetComponent<WindowData>(entity).window;

		mouseDelta := QueryInput(Mouse.device, Mouse.Delta, window).value.axis;

		wheelDelta := QueryInput(Mouse.device, Mouse.Wheel, window).value.axis;
		if (wheelDelta.y)
		{
			forward := camera.Forward();
			amount := wheelDelta.y * cameraOrbit.scrollDamping * -1.0;
			delta := forward * amount;
			camera.position = camera.position + delta;
		}

		middleMouseDown := QueryInput(Mouse.device, Mouse.Middle, window).value.down;
		if (middleMouseDown)
		{
			delta := Vec3(mouseDelta.x * -1.0, mouseDelta.y, 0.0) * cameraOrbit.panDamping;
			camera.position = camera.position + delta;
			cameraOrbit.orbitCenter = cameraOrbit.orbitCenter + delta;
		}

		leftMouseDown := QueryInput(Mouse.device, Mouse.Left, window).value.down;
		if (leftMouseDown)
		{
			toCamera := camera.position - cameraOrbit.orbitCenter;
			if (toCamera.SqrLength() == 0.0) continue;

			yawAngle := mouseDelta.x * cameraOrbit.rotateDamping;
			pitchAngle := mouseDelta.y * cameraOrbit.rotateDamping;

			worldUp := Vec3(0.0, 1.0, 0.0);
			right := cameraOrbit.orbitUp.Cross(toCamera);
			if (!right.SqrLength()) right = worldUp.Cross(toCamera);
			if (!right.SqrLength()) right = Vec3(1.0, 0.0, 0.0).Cross(toCamera);

			if (yawAngle != 0.0)
			{
				orbitUpNorm := cameraOrbit.orbitUp.Normalize();
				yawRot := Quaternion(orbitUpNorm, yawAngle).ToRotationMatrix();
				toCamera = yawRot * toCamera;
				cameraOrbit.orbitUp = yawRot * cameraOrbit.orbitUp;
			}

			if (right.SqrLength())
			{
				rightNorm := right.Normalize();
				if (pitchAngle != 0.0)
				{
					pitchRot := Quaternion(rightNorm, pitchAngle).ToRotationMatrix();
					toCamera = pitchRot * toCamera;
					cameraOrbit.orbitUp = pitchRot * cameraOrbit.orbitUp;
				}
			}

			viewDir := (toCamera * -1.0).Normalize().vec;
			right = viewDir.Cross(cameraOrbit.orbitUp);
			if (!right.SqrLength())
			{
				auxUp := Vec3(1.0, 0.0, 0.0);
				if (Math.FAbs(viewDir.x) > 0.99) auxUp = Vec3(0.0, 0.0, 1.0);
				right = viewDir.Cross(auxUp);
			}
			cameraOrbit.orbitUp = right.Cross(viewDir).Normalize().vec;

			camera.position = cameraOrbit.orbitCenter + toCamera;
			camera.LookAt(cameraOrbit.orbitCenter, cameraOrbit.orbitUp);
		}
	}	
});
