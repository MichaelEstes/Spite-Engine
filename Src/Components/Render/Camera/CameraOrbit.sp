package RenderComponents

import Input

state CameraOrbit
{
	damping: float32
}

CameraOrbitComponent := ECS.RegisterComponent<CameraOrbit>(
	ComponentKind.Singleton
);

CameraOrbitSystem := ECS.RegisterSystem(::(scene: Scene, dt: float) {
	if (!scene.HasSingleton<CameraOrbit>()) return;

	cameraOrbit := scene.GetSingleton<CameraOrbit>();
	
	aButtonDown := QueryInput(Keyboard.device, Keyboard.A).value.down;
	if (aButtonDown) log "A Button Down";

	mousePos :=  QueryInput(Mouse.device, Mouse.Position).value.axis;
	log "Mouse Position: ", mousePos;
});