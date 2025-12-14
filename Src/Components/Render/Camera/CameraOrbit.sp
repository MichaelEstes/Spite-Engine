package RenderComponents

import Input

state CameraOrbit
{
	scrollDamping: float32 = 0.1
}

CameraOrbitComponent := ECS.RegisterComponent<CameraOrbit>(
	ComponentKind.Singleton
);

CameraOrbitSystem := ECS.RegisterSystem(::(scene: Scene, dt: float) {
	if (!scene.HasSingleton<CameraOrbit>()) return;
	if (!scene.HasSingleton<Camera>()) return;

	cameraOrbit := scene.GetSingleton<CameraOrbit>();
	camera := scene.GetSingleton<Camera>();
	
	aButtonDown := QueryInput(Keyboard.device, Keyboard.A).value.down;
	if (aButtonDown) log "A Button Down";

	mousePos := QueryInput(Mouse.device, Mouse.Position).value.axis;
	//if (mousePos.x && mousePos.y) log "Mouse Position: ", mousePos;

	wheelDelta := QueryInput(Mouse.device, Mouse.Wheel).value.axis;
	if (wheelDelta.y)
	{
		forward := camera.Forward();
		amount := wheelDelta.y * cameraOrbit.scrollDamping * -1.0;
		delta := forward * amount;
		camera.position = camera.position + delta;
	}
});