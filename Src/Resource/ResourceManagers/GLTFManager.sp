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

state GLTFLoadData
{
	scene: *Scene,
	resource: *GLTFResource,
	handle: ResourceHandle,
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
	},
	::(handle: ResourceHandle, child: ResourceHandle) {
		resource := Resource.GetResource<GLTFResource>(handle);
		if (resource.result == ResourceResult.Released) return;

		gltfResource := resource.data;
	}
);

GLTFResourceManagerID := Resource.RegisterResourceManager(GLTFResourceManager@);

string GetGLTFKey(param: GLTFLoadParam) => param.file.Copy();

GLTFManagerLoad(param: *ResourceParam<GLTFResource, GLTFLoadParam>)
{
	Fiber.RunOnMainFiber(::(resourceParam: *ResourceParam<GLTFResource, GLTFLoadParam>) 
	{
		param := resourceParam.param;
		handle := resourceParam.handle;
		resourceManager := resourceParam.manager;
		resource := resourceManager.GetResource(handle).data@;
	
		file := param.file;
		scene := param.scene;
		outEntities := param.outEntities;

		gltf := LoadGLTF(file);

		gltfData := GLTFLoadData();
		gltfData.scene = scene;
		gltfData.resource = resource;
		gltfData.handle = handle;

		for (gltfScene in gltf.scenes)
		{
			for (nodeIndex in gltfScene.nodes)
			{
				FlushNodeToECS(gltfData, gltf, scene, nodeIndex, nullEntity, outEntities);
			}
		}

		resourceParam.onResourceLoad(resourceParam, ResourceResult.Loaded);
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

ResourceHandle GetBufferHandle(gltfData: GLTFLoadData, gltf: GLTF, buffer: uint32)
{
	gltfBuffer := gltf.buffers[buffer];

	uri := gltfBuffer.uri.uri~;
	return LoadURIResource(uri, gltf.path, gltfData.handle);
}

*byte GetBufferViewData(gltfData: GLTFLoadData, gltf: GLTF, bufferView: uint32)
{
	gltfBufferView := gltf.bufferViews[bufferView];

	handle := GetBufferHandle(gltfData, gltf, gltfBufferView.buffer);
	gltfData.resource.buffers.Add(handle);

	data := URIResourceManager.TakeResourceRef(handle).data.buffer;
	data = data + gltfBufferView.byteOffset;

	return data;
}

ArrayView<byte> GetAccessorData(gltfData: GLTFLoadData, gltf: GLTF, accessor: uint32)
{
	gltfAccessor := gltf.accessors[accessor];

	data := GetBufferViewData(gltfData, gltf, gltfAccessor.bufferView);
	data = data + gltfAccessor.byteOffset;

	return ArrayView<byte>(data, gltfAccessor.count);
}

AssignPositionToPrimitive(gltfData: GLTFLoadData, gltf: GLTF, accessor: uint32, primitive: Primitive)
{
	view := GetAccessorData(gltfData, gltf, accessor);
	vertices := ArrayView<Vec3>(view[0]@, view.count);
	
	primitive.geometry.vertices = vertices;
}

AssignNormalToPrimitive(gltfData: GLTFLoadData, gltf: GLTF, accessor: uint32, primitive: Primitive)
{
	view := GetAccessorData(gltfData, gltf, accessor);
	normals := ArrayView<Vec3>(view[0]@, view.count);
	
	primitive.geometry.normals = normals;
}

AssignTangentToPrimitive(gltfData: GLTFLoadData, gltf: GLTF, accessor: uint32, primitive: Primitive)
{
	view := GetAccessorData(gltfData, gltf, accessor);
	tangents := ArrayView<Vec4>(view[0]@, view.count);
	
	primitive.geometry.tangents = tangents;
}

AssignAttributeToPrimitive(gltfData: GLTFLoadData, gltf: GLTF, attrName: string, accessor: uint32, primitive: Primitive)
{
	if (attrName == "POSITION")
	{
		AssignPositionToPrimitive(gltfData, gltf, accessor, primitive);
	}
	else if (attrName == "NORMAL")
	{
		AssignNormalToPrimitive(gltfData, gltf, accessor, primitive);
	}
	else if (attrName == "TANGENT")
	{
		AssignTangentToPrimitive(gltfData, gltf, accessor, primitive);
	}
}

AssignIndiciesToPrimitive(gltfData: GLTFLoadData, gltf: GLTF, accessor: uint32, primitive: Primitive)
{
	view := GetAccessorData(gltfData, gltf, accessor);
	indices := ArrayView<uint16>(view[0]@, view.count);

	primitive.geometry.indices = indices;
}

FlushMeshToECS(gltfData: GLTFLoadData, gltf: GLTF, scene: *Scene, meshIndex: uint32, entity: Entity)
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

			AssignAttributeToPrimitive(gltfData, gltf, attrName, attrAccessor, primitive);
		}

		if (gltfPrim.indices != InvalidGLTFIndex)
		{
			AssignIndiciesToPrimitive(gltfData, gltf, gltfPrim.indices, primitive);
		}

		mesh.primitives.Add(primitive);
	}

	scene.SetComponent<Mesh>(entity, mesh);
}

FlushNodeToECS(gltfData: GLTFLoadData, gltf: GLTF, scene: *Scene, nodeIndex: uint32, parentEntity: Entity, outEntities: *Array<Entity> = null)
{
	gltfNode := gltf.nodes[nodeIndex];

	entity := scene.CreateEntity();
	if (outEntities) outEntities.Add(entity);

	if (gltfNode.mesh != InvalidGLTFIndex)
	{
		FlushMeshToECS(gltfData, gltf, scene, gltfNode.mesh, entity);
	}

	for (childIndex in gltfNode.children)
	{
		FlushNodeToECS(gltfData, gltf, scene, childIndex, entity, outEntities);
	}
}