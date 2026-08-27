package UniformBufferObject

import Matrix
import Vec
import Common

state SceneUBO
{
	view: Matrix4,
	projection: Matrix4,
	screenSize: Vec2,
	_pad: Vec2
}

state ModelUBO
{
	model: Matrix4
}

state ViewProjUBO
{
	view: Matrix4,
	projection: Matrix4,
}