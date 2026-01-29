package RenderComponents

import Input
import WindowComponent
import Math

state CameraOrbit
{
	rotatePivot: Vec3,
	radius: float32,
	yaw: float32,
	pitch: float32,

	rotateDamping: float32 = 0.1,
	scrollDamping: float32 = 0.1,
	panDamping: float32 = 0.0025
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

		aButtonDown := QueryInput(Keyboard.device, Keyboard.A).value.down;
		if (aButtonDown) log "A Button Down";

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
		}

		leftMouseDown := QueryInput(Mouse.device, Mouse.Left, window).value.down;
		if (leftMouseDown)
		{
			eps := 0.001;

			cameraOrbit.yaw += mouseDelta.x * cameraOrbit.rotateDamping;
			cameraOrbit.pitch += mouseDelta.y * cameraOrbit.rotateDamping;
			cameraOrbit.pitch = Math.Clamp(cameraOrbit.pitch, -Pi * 0.5 + eps, Pi * 0.5 - eps);
		}
	}	
});