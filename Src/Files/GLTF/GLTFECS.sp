package GLTF

import Render
import ArrayView

*byte GetBufferData(gltf: GLTF, buffer: uint32)
{
	gltfBuffer := gltf.buffers[buffer];
	return gltfBuffer.uri.data;
}

*byte GetBufferViewData(gltf: GLTF, bufferView: uint32)
{
	gltfBufferView := gltf.bufferViews[bufferView];

	log "Buffer View", gltfBufferView;

	data := GetBufferData(gltf, gltfBufferView.buffer);
	data = data + gltfBufferView.byteOffset;

	return data;
}

ArrayView<byte> GetAccessorData(gltf: GLTF, accessor: uint32)
{
	gltfAccessor := gltf.accessors[accessor];

	log "Accessor", gltfAccessor;

	data := GetBufferViewData(gltf, gltfAccessor.bufferView);
	data = data + gltfAccessor.byteOffset;

	return ArrayView(data, gltfAccessor.count);
}

AssignPositionToPrimitive(gltf: GLTF, accessor: uint32, primitive: Primitive)
{
	view := GetAccessorData(gltf, accessor);

}

AssignAttributeToPrimitive(gltf: GLTF, attrName: string, accessor: uint32, primitive: Primitive)
{
	if (attrName == "POSITION")
	{
		AssignPositionToPrimitive(gltf, accessor, primitive);
	}
}


FlushGLTFToECS(gltf: GLTF)
{
	meshes := gltf.meshes;
	
	for (mesh in meshes)
	{
		log "Primitive count: ", meshes[0].primitives.count;
		for (gltfPrim in mesh.primitives)
		{
			primitive := Primitive();
			for (attrKV in gltfPrim.attributes)
			{
				attrName := attrKV.key~;
				attrAccessor := attrKV.value~;

				AssignAttributeToPrimitive(gltf, attrName, attrAccessor, primitive);
			}
		}
	}
}