package RenderComponents

import ECS
import Common
import Vec

state PointLight
{
	color: Color,
	intensity: float32,
	radius: float32
}

PointLightComponent := ECS.RegisterComponent<PointLight>(
	ComponentKind.Sparse
);
