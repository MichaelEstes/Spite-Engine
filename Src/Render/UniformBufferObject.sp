package UniformBufferObject

import Matrix

state UniformBufferObject
{
	model: Matrix4,
	view: Matrix4,
	projection: Matrix4
}

state SceneUBO
{
	view: Matrix4,
	projection: Matrix4
}

state ModelUBO
{
	model: Matrix4
}