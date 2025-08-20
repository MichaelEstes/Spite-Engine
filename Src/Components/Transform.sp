package Transform

import Vec
import ECS

state Transform
{
	pos: Vec3
}

Transform::(x: float, y: float, z: float)
{
	this.pos.x = x;
	this.pos.y = y;
	this.pos.z = z;
}

TransformComponent := ECS.RegisterComponent<Transform>(
	ComponentKind.Common, 
	::(transform: *Transform, scene: Scene) 
	{
		log "Removing transform: ", transform;
	}
);
