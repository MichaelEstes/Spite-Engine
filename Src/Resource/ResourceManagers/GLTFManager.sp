package GLTFManager

import Resource
import Fiber
import ThreadParamAllocator
import GLTF
import Scene
import Entity
import Render
import Array
import URIManager

state GLTFResource
{
	buffers: Array<ResourceHandle>,
}

state GLTFLoadParam
{
	file: string,
	scene: *Scene,
	outEntities: *Array<Entity>
}

GLTFResourceManager := Resource.CreateResourceManager<GLTFResource, GLTFLoadParam>(
	['g', 'l', 't', 'f'],
	GetGLTFKey, 
	GLTFManagerLoad,
	::(handle: ResourceHandle) {
		log "RELEASING GLTF RESOURCE", handle;
		resource := Resource.GetResource<GLTFResource>(handle);
		gltfResource := resource.data;

		for (bufferHandle in gltfResource.buffers) Resource.ReleaseResourceRef(bufferHandle);
	}
);

GLTFResourceManagerID := Resource.RegisterResourceManager(GLTFResourceManager@);

string GetGLTFKey(param: GLTFLoadParam) => param.file;

GLTFManagerLoad(param: *ResourceParam<GLTFResource, GLTFLoadParam>)
{
	Fiber.RunOnMainFiber(::(resourceParam: *ResourceParam<GLTFResource, GLTFLoadParam>) 
	{
		param := resourceParam.param;
		resource := resourceParam.resource.data@;
	
		file := param.file;
		scene := param.scene;
		outEntities := param.outEntities;

		gltf := LoadGLTF(file);

		for (gltfScene in gltf.scenes)
		{
			for (nodeIndex in gltfScene.nodes)
			{
				FlushNodeToECS(resource, gltf, scene, nodeIndex, nullEntity, outEntities);
			}
		}

		resourceParam.onResourceLoad(resourceParam);
	}, param);
}

ResourceHandle LoadGLTFResource(file: string, scene: *Scene, onLoad: ::(ResourceHandle), outEntities: *Array<Entity> = null)
{
	gltfParam := GLTFLoadParam();
	gltfParam.file = file;
	gltfParam.scene = scene;
	gltfParam.outEntities = outEntities;
	
	return GLTFResourceManager.LoadResource(gltfParam, onLoad);
}

ResourceHandle GetBufferHandle(gltf: GLTF, buffer: uint32)
{
	gltfBuffer := gltf.buffers[buffer];

	uri := gltfBuffer.uri.uri~;
	return LoadURIResource(uri, gltf.path);
}

*byte GetBufferViewData(resource: *GLTFResource, gltf: GLTF, bufferView: uint32)
{
	gltfBufferView := gltf.bufferViews[bufferView];

	handle := GetBufferHandle(gltf, gltfBufferView.buffer);
	resource.buffers.Add(handle);

	data := URIResourceManager.TakeResourceRef(handle).data.buffer;
	data = data + gltfBufferView.byteOffset;

	return data;
}

ArrayView<byte> GetAccessorData(resource: *GLTFResource, gltf: GLTF, accessor: uint32)
{
	gltfAccessor := gltf.accessors[accessor];

	data := GetBufferViewData(resource, gltf, gltfAccessor.bufferView);
	data = data + gltfAccessor.byteOffset;

	return ArrayView<byte>(data, gltfAccessor.count);
}

AssignPositionToPrimitive(resource: *GLTFResource, gltf: GLTF, accessor: uint32, primitive: Primitive)
{
	view := GetAccessorData(resource, gltf, accessor);
	vertices := ArrayView<Vec3>(view[0]@, view.count);
	
	primitive.geometry.vertices = vertices;
}

AssignNormalToPrimitive(resource: *GLTFResource, gltf: GLTF, accessor: uint32, primitive: Primitive)
{
	view := GetAccessorData(resource, gltf, accessor);
	normals := ArrayView<Vec3>(view[0]@, view.count);
	
	primitive.geometry.normals = normals;
}

AssignTangentToPrimitive(resource: *GLTFResource, gltf: GLTF, accessor: uint32, primitive: Primitive)
{
	view := GetAccessorData(resource, gltf, accessor);
	tangents := ArrayView<Vec4>(view[0]@, view.count);
	
	primitive.geometry.tangents = tangents;
}

AssignAttributeToPrimitive(resource: *GLTFResource, gltf: GLTF, attrName: string, accessor: uint32, primitive: Primitive)
{
	if (attrName == "POSITION")
	{
		AssignPositionToPrimitive(resource, gltf, accessor, primitive);
	}
	else if (attrName == "NORMAL")
	{
		AssignNormalToPrimitive(resource, gltf, accessor, primitive);
	}
	else if (attrName == "TANGENT")
	{
		AssignTangentToPrimitive(resource, gltf, accessor, primitive);
	}
}

AssignIndiciesToPrimitive(resource: *GLTFResource, gltf: GLTF, accessor: uint32, primitive: Primitive)
{
	view := GetAccessorData(resource, gltf, accessor);
	indices := ArrayView<uint16>(view[0]@, view.count);

	primitive.geometry.indices = indices;
}

FlushMeshToECS(resource: *GLTFResource, gltf: GLTF, scene: *Scene, meshIndex: uint32, entity: Entity)
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

			AssignAttributeToPrimitive(resource, gltf, attrName, attrAccessor, primitive);
		}

		if (gltfPrim.indices != InvalidGLTFIndex)
		{
			AssignIndiciesToPrimitive(resource, gltf, gltfPrim.indices, primitive);
		}

		mesh.primitives.Add(primitive);
	}

	scene.SetComponent<Mesh>(entity, mesh);
}

FlushNodeToECS(resource: *GLTFResource, gltf: GLTF, scene: *Scene, nodeIndex: uint32, parentEntity: Entity, outEntities: *Array<Entity> = null)
{
	gltfNode := gltf.nodes[nodeIndex];

	entity := scene.CreateEntity();
	if (outEntities) outEntities.Add(entity);

	if (gltfNode.mesh != InvalidGLTFIndex)
	{
		FlushMeshToECS(resource, gltf, scene, gltfNode.mesh, entity);
	}

	for (childIndex in gltfNode.children)
	{
		FlushNodeToECS(resource, gltf, scene, childIndex, entity, outEntities);
	}
}