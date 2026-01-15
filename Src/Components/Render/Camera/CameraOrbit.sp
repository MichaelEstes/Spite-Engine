package RenderComponents

import Input
import WindowComponent

state CameraOrbit
{
	scrollDamping: float32 = 0.1
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

		mousePos := QueryInput(Mouse.device, Mouse.Position).value.axis;
		//if (mousePos.x && mousePos.y) log "Mouse Position: ", mousePos;

		wheelDelta := QueryInput(Mouse.device, Mouse.Wheel, window).value.axis;
		if (wheelDelta.y)
		{
			forward := camera.Forward();
			amount := wheelDelta.y * cameraOrbit.scrollDamping * -1.0;
			delta := forward * amount;
			camera.position = camera.position + delta;
			//log "Scroll Wheel input";
		}
	}	
});