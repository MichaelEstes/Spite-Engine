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
	projection: Matrix4
}

state ModelUBO
{
	model: Matrix4
}

state MaterialUBO
{
	baseColor: Color,
	emissiveFactor: Vec3,

	normalScale: float32,
	metallicFactor: float32,
	roughnessFactor: float32,
	occlusionStrength: float32,
	alphaCutoff: float32
}