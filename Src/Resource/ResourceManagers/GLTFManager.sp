package GLTFManager

import Resource
import Fiber
import ThreadParamAllocator
import GLTF
import ECS
import Render
import Array
import URIManager
import ImageManager
import Hierarchy

state GLTFResource
{
	buffers: Array<ResourceHandle>,
	images: Array<ResourceHandle>
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
		resource := Resource.GetResource<GLTFResource>(handle);
		gltfResource := resource.data;

		for (bufferHandle in gltfResource.buffers) Resource.ReleaseResourceRef(bufferHandle);
	},
	::(handle: ResourceHandle, child: ResourceHandle) {
		resource := Resource.GetResource<GLTFResource>(handle);
		if (resource.result == ResourceResult.Released) return;

		gltfResource := resource.data;
		gltfResource.buffers.RemoveAll(child);

		heldResourceCount := gltfResource.buffers.count + gltfResource.images.count;
		if (!gltfResource.buffers.count) Resource.ReleaseResourceRef(handle);
	}
);

GLTFResourceManagerID := Resource.RegisterResourceManager(GLTFResourceManager@);

ResourceKey GetGLTFKey(param: GLTFLoadParam) => ResourceKey(param.file.Copy());

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
			sceneEntity := scene.CreateEntity();
			scene.SetComponent<Hierarchy>(sceneEntity, Hierarchy());

			outEntities.Add(sceneEntity);

			for (nodeIndex in gltfScene.nodes)
			{
				NodeToECS(gltfData, gltf, scene, nodeIndex, sceneEntity, outEntities);
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

ArrayView<byte> GetBufferViewData(gltfData: GLTFLoadData, gltf: GLTF, bufferView: uint32)
{
	gltfBufferView := gltf.bufferViews[bufferView];

	handle := GetBufferHandle(gltfData, gltf, gltfBufferView.buffer);
	gltfData.resource.buffers.Add(handle);

	data := URIResourceManager.TakeResourceRef(handle).data.buffer;
	data = data + gltfBufferView.byteOffset;

	return ArrayView<byte>(data, gltfBufferView.byteLength);
}

ArrayView<byte> GetAccessorData(gltfData: GLTFLoadData, gltf: GLTF, accessor: uint32)
{
	gltfAccessor := gltf.accessors[accessor];

	data := GetBufferViewData(gltfData, gltf, gltfAccessor.bufferView)[0]@;
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

TextureMap LoadTexture(gltfData: GLTFLoadData, gltf: GLTF, textureIndex: uint32)
{
	gltfTexture := gltf.textures[textureIndex];
	imageIndex := gltfTexture.source;
	gltfImage := gltf.images[imageIndex];

	texture := Texture();

	if (gltfImage.bufferView != InvalidGLTFIndex)
	{
		//bufferView := gltf.bufferViews[gltfImage.bufferView];
		//handle := GetBufferHandle(gltfData, gltf, bufferView.buffer);
		//buffer := URIResourceManager.TakeResourceRef(handle).data.buffer;
	}
	else
	{
		uri := gltfImage.uri.uri~;
		imageHandle := LoadImageResource(uri, gltf.path, gltfData.handle);

		texture.imageHandle = imageHandle;
	}


	textureMap := TextureMap();
	textureMap.texture = texture;

	return textureMap;
}

AlphaMode GetAlphaMode(gltfMaterial: GLTFMaterial)
{
	if (gltfMaterial.alphaMode == "BLEND") return AlphaMode.Blend;
	else if (gltfMaterial.alphaMode == "MASK") return AlphaMode.Mask;
	else return AlphaMode.Opaque;
}

AssignMaterialToPrimitive(gltfData: GLTFLoadData, gltf: GLTF, materialIndex: uint32, primitive: Primitive)
{
	gltfMaterial := gltf.materials[materialIndex];
	
	material := Material();

	if (gltfMaterial.pbrMetallicRoughness)
	{
		pbr := gltfMaterial.pbrMetallicRoughness;
		material.baseColor = pbr.baseColorFactor;
		if (pbr.baseColorTexture)
		{
			baseColorTextureMap := LoadTexture(gltfData, gltf, pbr.baseColorTexture.index);
			material.color = material.maps.Add(baseColorTextureMap);
		}

		if (pbr.metallicRoughnessTexture)
		{
			metallicRoughnessTextureMap := LoadTexture(gltfData, gltf, pbr.metallicRoughnessTexture.index);
			material.metallicRoughness = material.maps.Add(metallicRoughnessTextureMap);
		}

		material.metallicFactor = pbr.metallicFactor;
		material.roughnessFactor = pbr.roughnessFactor;
	}

	if (gltfMaterial.normalTexture)
	{
		normalTextureMap := LoadTexture(gltfData, gltf, gltfMaterial.normalTexture.info.index);
		material.normal = material.maps.Add(normalTextureMap);
	}

	if (gltfMaterial.occlusionTexture)
	{
		occlusionTextureMap := LoadTexture(gltfData, gltf, gltfMaterial.occlusionTexture.info.index);
		material.occlusion = material.maps.Add(occlusionTextureMap);
	}

	if (gltfMaterial.emissiveTexture)
	{
		emissiveTextureMap := LoadTexture(gltfData, gltf, gltfMaterial.emissiveTexture.index);
		material.emissive = material.maps.Add(emissiveTextureMap);
	}

	material.emissiveFactor = gltfMaterial.emissiveFactor;
	material.alphaCutoff = gltfMaterial.alphaCutoff;
	if (gltfMaterial.doubleSided)
	{
		material.cullMode = CullModeFlags.None;
	}
	material.alphaMode = GetAlphaMode(gltfMaterial);

	primitive.material = material;
}

MeshToECS(gltfData: GLTFLoadData, gltf: GLTF, scene: *Scene, meshIndex: uint32, entity: Entity)
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

		AssignMaterialToPrimitive(gltfData, gltf, gltfPrim.material, primitive);

		mesh.primitives.Add(primitive);
	}

	scene.SetComponent<Mesh>(entity, mesh);
}

NodeToECS(gltfData: GLTFLoadData, gltf: GLTF, scene: *Scene, nodeIndex: uint32, parentEntity: Entity, outEntities: *Array<Entity> = null)
{
	gltfNode := gltf.nodes[nodeIndex];

	entity := scene.CreateEntity();
	scene.SetComponent<Hierarchy>(entity, Hierarchy());
	ParentEntity(parentEntity, entity, scene);

	if (outEntities) outEntities.Add(entity);

	if (gltfNode.mesh != InvalidGLTFIndex)
	{
		MeshToECS(gltfData, gltf, scene, gltfNode.mesh, entity);
	}

	for (childIndex in gltfNode.children)
	{
		NodeToECS(gltfData, gltf, scene, childIndex, entity, outEntities);
	}
}