package UniformBufferObject

import Matrix
import Vec
import Common

state UniformBufferObject
{
	model: Matrix4,
	view: Matrix4,
	projection: Matrix4
}

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