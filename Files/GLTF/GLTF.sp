package GLTF

import Array
import Matrix
import Vec
import Quaternion

state GLTF
{
	scene: uint32,
	scenes: Array<Scene>,
	nodes: Array<Node>,
	meshes: Array<Mesh>,
	materials: Array<Material>,
}

state Scene
{
	nodes: Array<uint32>
}

state TRS
{
	translation: Vec3,
	scale: Vec3,
	rotation: Quaternion
}

state Node
{
	children: Array<uint32>,
	weights: Array<uint32>,

	transform: ?{
		matrix: Matrix4,
		trs: TRS
	}
	
	camera: uint32,
	mesh: uint32,
	skin: uint32,

	trs: bool,
}

state Mesh
{
	primitives: Array<Primitives>,
	weights: Array<uint32>,
}

state Primitive
{
	attributes: Map<string, uint32>,
	targets: Array<Map<string, uint32>>,

	indices: uint32,
	material: uint32,
	mode: uint32 = 4,
}

state MaterialPBRMetallicRoughness
{

}

state Material
{

}