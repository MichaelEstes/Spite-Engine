package GLTF

import Render
import ArrayView
import Vec

import Scene

*byte GetBufferData(gltf: GLTF, buffer: uint32)
{
	gltfBuffer := gltf.buffers[buffer];
	return gltfBuffer.uri.data;
}

*byte GetBufferViewData(gltf: GLTF, bufferView: uint32)
{
	gltfBufferView := gltf.bufferViews[bufferView];

	data := GetBufferData(gltf, gltfBufferView.buffer);
	data = data + gltfBufferView.byteOffset;

	return data;
}

ArrayView<byte> GetAccessorData(gltf: GLTF, accessor: uint32)
{
	gltfAccessor := gltf.accessors[accessor];

	data := GetBufferViewData(gltf, gltfAccessor.bufferView);
	data = data + gltfAccessor.byteOffset;

	return ArrayView<byte>(data, gltfAccessor.count);
}

AssignPositionToPrimitive(gltf: GLTF, accessor: uint32, primitive: Primitive)
{
	view := GetAccessorData(gltf, accessor);
	vertices := ArrayView<Vec3>(view[0]@, view.count);
	
	primitive.geometry.vertices = vertices;
}

AssignNormalToPrimitive(gltf: GLTF, accessor: uint32, primitive: Primitive)
{
	view := GetAccessorData(gltf, accessor);
	normals := ArrayView<Vec3>(view[0]@, view.count);
	
	primitive.geometry.normals = normals;
}

AssignTangentToPrimitive(gltf: GLTF, accessor: uint32, primitive: Primitive)
{
	view := GetAccessorData(gltf, accessor);
	tangents := ArrayView<Vec4>(view[0]@, view.count);
	
	primitive.geometry.tangents = tangents;
}

AssignAttributeToPrimitive(gltf: GLTF, attrName: string, accessor: uint32, primitive: Primitive)
{
	if (attrName == "POSITION")
	{
		AssignPositionToPrimitive(gltf, accessor, primitive);
	}
	else if (attrName == "NORMAL")
	{
		AssignNormalToPrimitive(gltf, accessor, primitive);
	}
	else if (attrName == "TANGENT")
	{
		AssignTangentToPrimitive(gltf, accessor, primitive);
	}
}

AssignIndiciesToPrimitive(gltf: GLTF, accessor: uint32, primitive: Primitive)
{
	view := GetAccessorData(gltf, accessor);
	indices := ArrayView<uint16>(view[0]@, view.count);

	for (index in indices)
	{
		log index;
	}

	primitive.geometry.indices = indices;
}

FlushMeshToECS(gltf: GLTF, scene: *Scene, meshIndex: uint32, entity: Entity)
{
	gltfMesh := gltf.meshes[meshIndex];
	mesh := Mesh()

	mesh.primitives.SizeTo(gltfMesh.primitives.count);
	for (gltfPrim in gltfMesh.primitives)
	{
		primitive := Primitive();
		for (attrKV in gltfPrim.attributes)
		{
			attrName := attrKV.key~;
			attrAccessor := attrKV.value~;

			AssignAttributeToPrimitive(gltf, attrName, attrAccessor, primitive);
		}

		if (gltfPrim.indices != InvalidGLTFIndex)
		{
			AssignIndiciesToPrimitive(gltf, gltfPrim.indices, primitive);
		}

		mesh.primitives.Add(primitive);
	}

	scene.SetComponent<Mesh>(entity, mesh);
}

FlushNodeToECS(gltf: GLTF, scene: *Scene, nodeIndex: uint32, parentEntity: Entity, outEntities: *Array<Entity> = null)
{
	gltfNode := gltf.nodes[nodeIndex];

	entity := scene.CreateEntity();
	if (outEntities) outEntities.Add(entity);

	if (gltfNode.mesh != InvalidGLTFIndex)
	{
		FlushMeshToECS(gltf, scene, gltfNode.mesh, entity);
	}

	for (childIndex in gltfNode.children)
	{
		FlushNodeToECS(gltf, scene, childIndex, entity, outEntities);
	}
}

FlushGLTFToECS(gltf: GLTF, scene: *Scene, outEntities: *Array<Entity> = null)
{
	gltfMeshes := gltf.meshes;
	
	for (gltfScene in gltf.scenes)
	{
		for (nodeIndex in gltfScene.nodes)
		{
			FlushNodeToECS(gltf, scene, nodeIndex, nullEntity, outEntities);
		}
	}
}