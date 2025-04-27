package Transform

import Vec

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