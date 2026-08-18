package RenderComponents

import Input
import WindowComponent
import Quaternion

state CameraOrbit
{
	orbitCenter: Vec3 = Vec3(0.0, 0.0, 0.0),
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
		windowData := scene.GetComponent<WindowData>(entity);
		if (!windowData) continue;
		window := windowData.window;
		cameraForward := camera.Forward();
		worldUp := Vec3(0.0, 1.0, 0.0);

		mouseDelta := QueryInput(Mouse.device, Mouse.Delta, window).value.axis;

		wheelDelta := QueryInput(Mouse.device, Mouse.Wheel, window).value.axis;
		if (wheelDelta.y)
		{
			amount := wheelDelta.y * cameraOrbit.scrollDamping * -1.0;
			delta := cameraForward * amount;
			camera.position = camera.position + delta;
		}

		middleMouseDown := QueryInput(Mouse.device, Mouse.Middle, window).value.down;
		if (middleMouseDown)
		{
			right := cameraForward.Cross(worldUp);
			if (right.SqrLength())
			{
				rightNorm := right.Normalize().vec;
				upNorm := rightNorm.Cross(cameraForward).Normalize().vec;

				delta := ((rightNorm * mouseDelta.x) + (upNorm * mouseDelta.y)) * cameraOrbit.panDamping;
				camera.position = camera.position + delta;
				cameraOrbit.orbitCenter = cameraOrbit.orbitCenter + delta;
			}
		}

		leftMouseDown := QueryInput(Mouse.device, Mouse.Left, window).value.down;
		if (leftMouseDown)
		{
			toCamera := camera.position - cameraOrbit.orbitCenter;
			if (toCamera.SqrLength() == 0.0) continue;

			yawAngle := mouseDelta.x * cameraOrbit.rotateDamping;
			pitchAngle := mouseDelta.y * cameraOrbit.rotateDamping;

			if (yawAngle != 0.0)
			{
				yawRot := Quaternion(worldUp as Norm<Vec3>, yawAngle).ToRotationMatrix();
				toCamera = yawRot * toCamera;
			}

			right := worldUp.Cross(toCamera);
			if (right.SqrLength())
			{
				rightNorm := right.Normalize();
				if (pitchAngle != 0.0)
				{
					pitchRot := Quaternion(rightNorm, pitchAngle).ToRotationMatrix();
					toCamera = pitchRot * toCamera;
				}
			}

			camera.position = cameraOrbit.orbitCenter + toCamera;
			camera.LookAt(cameraOrbit.orbitCenter, worldUp);
		}
	}	
});
