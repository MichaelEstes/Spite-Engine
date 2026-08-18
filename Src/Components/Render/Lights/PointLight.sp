package RenderComponents

import ECS
import Common
import Vec

state PointLight
{
	data: LightData,
	radius: float32
}

PointLightComponent := ECS.RegisterComponent<PointLight>(
	ComponentKind.Sparse
);
