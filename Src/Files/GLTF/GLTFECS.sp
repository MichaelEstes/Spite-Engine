package GLTF

import Render

FlushGLTFToECS(gltf: GLTF)
{
	meshes := gltf.meshes;
	

	mesh := Mesh();

	log "Mesh count: ", meshes.count;
	for (mesh in meshes)
	{
		log "Primitive count: ", mesh.primitives.count;
		for (meshPrim in mesh.primitives)
		{
			primitive := Primitive();
			for (attrKV in meshPrim.attributes)
			{
				attrName := attrKV.key;
				attrAccessor := attrKV.value;

				log "ATTRIBUTE NAME: ", attrName;
				log "ATTRIBUTE ACCESSOR: ", attrAccessor;
			}
		}
	}

}