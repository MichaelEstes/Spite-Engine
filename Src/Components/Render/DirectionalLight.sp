package RenderComponents

import ECS
import Common
import Vec

state DirectionalLight
{
	direction: Vec3,
	color: Color,
	intensity: float32,
	castShadow: bool
}

DirectionalLightComponent := ECS.RegisterComponent<DirectionalLight>(
	ComponentKind.Sparse
);
