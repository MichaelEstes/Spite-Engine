package Transform

import Matrix
import Vec
import ECS
import Quaternion

state Transform
{
	rotation: Quaternion,
	position: Vec3,
	scale: Vec3
}

Transform::(pos: Vec3, rot: Quaternion = Quaternion(), scale: Vec3 = Vec3(1.0, 1.0, 1.0))
{
	this.position = pos;
	this.rotation = rot;
	this.scale = scale;
}

TransformComponent := ECS.RegisterComponent<Transform>(
	ComponentKind.Common, 
	::(entity: Entity, transform: *Transform, scene: Scene) 
	{
		log "Removing transform: ", transform;
	}
);
