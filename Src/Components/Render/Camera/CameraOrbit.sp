package RenderComponents

state CameraOrbit
{
	damping: float32
}

CameraOrbitComponent := ECS.RegisterComponent<CameraOrbit>(
	ComponentKind.Singleton
);

CameraOrbitSystem := ECS.RegisterSystem(::(scene: Scene, dt: float) {
	if (scene.HasSingleton<CameraOrbit>()) return;

	cameraOrbit := scene.GetSingleton<CameraOrbit>();
	
});