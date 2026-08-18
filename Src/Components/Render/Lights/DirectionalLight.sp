package RenderComponents

import ECS
import Common
import Vec

state DirectionalLight
{
	data: LightData,
	direction: Vec3
}

DirectionalLightComponent := ECS.RegisterComponent<DirectionalLight>(
	ComponentKind.Sparse
);
