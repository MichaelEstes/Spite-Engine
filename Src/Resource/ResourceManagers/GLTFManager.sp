package GLTFManager

import Resource
import Fiber
import ThreadParamAllocator
import GLTF
import ECS
import RenderComponents
import Array
import URIManager
import ImageManager
import SceneComponents
import Transform
import RenderAssetDef

import RotateComponent

state GLTFResource
{
	buffers: Array<ResourceHandle>,
	images: Array<ResourceHandle>
}

state GLTFLoadParam
{
	file: string,
	scene: *Scene,
	rootEntity: Entity
}

state GLTFLoadData
{
	scene: *Scene,
	resource: *GLTFResource,
	handle: ResourceHandle
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

GLTFManagerLoad(resourceParam: *ResourceParam<GLTFResource, GLTFLoadParam>)
{
	param := resourceParam.param;
	handle := resourceParam.handle;
	resourceManager := resourceParam.manager;
	resource := resourceManager.GetResource(handle).data@;
	
	file := param.file;
	scene := param.scene;
	
	gltf := LoadGLTF(file);
	
	gltfData := GLTFLoadData();
	gltfData.scene = scene;
	gltfData.resource = resource;
	gltfData.handle = handle;
	
	if (!param.rootEntity)
	{
		param.rootEntity = scene.CreateEntity();
		scene.SetComponent<Hierarchy>(param.rootEntity, Hierarchy());
	}
	
	rootEntity := param.rootEntity;

	for (gltfScene in gltf.scenes)
	{
		sceneEntity := scene.CreateEntity();
		scene.SetComponent<Hierarchy>(sceneEntity, Hierarchy());
		ParentEntity(rootEntity, sceneEntity, scene);

		log "Loading GLTF scene with ", gltfScene.nodes.count, "nodes";
		for (nodeIndex in gltfScene.nodes)
		{
			NodeToECS(gltfData, gltf, scene, nodeIndex, sceneEntity);
		}
	}
	
	resourceParam.onResourceLoad(resourceParam, ResourceResult.Loaded);
}

ResourceHandle LoadGLTFResource(file: string, scene: *Scene, onLoad: ::(ResourceHandle, *GLTFLoadParam) = null, rootEntity: Entity = NullEntity)
{
	gltfParam := GLTFLoadParam();
	gltfParam.file = file;
	gltfParam.scene = scene;
	gltfParam.rootEntity = rootEntity;

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

uint GetAccessorItemByteLength(accessor: GLTFAccessor)
{
	switch (accessor.componentType)
	{
		case (5120) return 1;
		case (5121) return 1;
		case (5122) return 2;
		case (5123) return 2;
		case (5125) return 4;
		case (5126) return 4;
	}

	return 1;
}

uint GetAccessorItemByteCount(accessor: GLTFAccessor)
{
	itemByteCount := 1;
	if (accessor.type == "VEC2") itemByteCount = 2;
	else if (accessor.type == "VEC3") itemByteCount = 3;
	else if (accessor.type == "VEC4") itemByteCount = 4;
	else if (accessor.type == "MAT2") itemByteCount = 4;
	else if (accessor.type == "MAT3") itemByteCount = 9;
	else if (accessor.type == "MAT4") itemByteCount = 16;

	return itemByteCount;
}

uint GetAccessorByteCount(accessor: GLTFAccessor)
{
	count := accessor.count;

	itemByteLength := GetAccessorItemByteLength(accessor);
	itemByteCount := GetAccessorItemByteCount(accessor);
	
	return count * itemByteLength * itemByteCount;
}

ArrayView<byte> GetAccessorData(gltfData: GLTFLoadData, gltf: GLTF, accessor: uint32)
{
	gltfAccessor := gltf.accessors[accessor];

	data := GetBufferViewData(gltfData, gltf, gltfAccessor.bufferView)[0]@;
	data = data + gltfAccessor.byteOffset;

	return ArrayView<byte>(data, gltfAccessor.count);
}

ArrayView<byte> GetAccessorByteView(gltfData: GLTFLoadData, gltf: GLTF, accessor: uint32)
{
	gltfAccessor := gltf.accessors[accessor];

	data := GetBufferViewData(gltfData, gltf, gltfAccessor.bufferView)[0]@;
	data = data + gltfAccessor.byteOffset;

	return ArrayView<byte>(data, GetAccessorByteCount(gltfAccessor));
}

string GLTFAttributeToAssetAttribute(attrName: string)
{
	if (attrName == "POSITION")        return "position";
	else if (attrName == "NORMAL")     return "normal";
	else if (attrName == "TANGENT")    return "tangents";
	else if (attrName == "COLOR_0")    return "color";
	else if (attrName == "TEXCOORD_0") return "uv0";

	return "";
}

AssignAttributeToPrimitive(gltfData: GLTFLoadData, gltf: GLTF, attrName: string, accessor: uint32, primitive: Primitive)
{
	assetAttr := GLTFAttributeToAssetAttribute(attrName);
	if (assetAttr == "") return;

	index := primitive.geometry.GetAttributeIndex(assetAttr);
	if (index == uint32(-1)) return;

	view := GetAccessorByteView(gltfData, gltf, accessor);
	primitive.geometry.GetAttributeValue(index)~ = view;
}

AssignIndiciesToPrimitive(gltfData: GLTFLoadData, gltf: GLTF, accessor: uint32, primitive: Primitive)
{
	view := GetAccessorData(gltfData, gltf, accessor);

	count := view.count;
	gltfAccessor := gltf.accessors[accessor];
	itemLength := GetAccessorItemByteLength(gltfAccessor);

	if (itemLength == 2)
	{
		primitive.geometry.indexKind = IndexKind.I16;
	}
	else if (itemLength == 4)
	{
		primitive.geometry.indexKind = IndexKind.I32;
		count = count * 2;
	}
	else
	{
		log "AssignIndiciesToPrimitive Invalid item length for index buffer";
	}

	indices := ArrayView<uint16>(view[0]@, count);
	primitive.geometry.indices = indices;
}

TextureMap LoadTexture(gltfData: GLTFLoadData, gltf: GLTF, textureIndex: uint32)
{
	gltfTexture := gltf.textures[textureIndex];
	imageIndex := gltfTexture.source;
	gltfImage := gltf.images[imageIndex];

	texture := Texture();
	texture.wrapU = TextureWrap.Repeat;
	texture.wrapV = TextureWrap.Repeat;

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

	if (gltfMaterial.pbrMetallicRoughness)
	{
		pbr := gltfMaterial.pbrMetallicRoughness;

		primitive.material.SetVariable<Color>("baseColor", pbr.baseColorFactor, false);
		primitive.material.SetVariable<float32>("metallicFactor", pbr.metallicFactor, false);
		primitive.material.SetVariable<float32>("roughnessFactor", pbr.roughnessFactor, false);

		if (pbr.baseColorTexture)
		{
			colorTextureMap := LoadTexture(gltfData, gltf, pbr.baseColorTexture.index);
			primitive.material.SetTexture("colorTexture", colorTextureMap, false);
		}

		if (pbr.metallicRoughnessTexture)
		{
			metallicRoughnessTextureMap := LoadTexture(gltfData, gltf, pbr.metallicRoughnessTexture.index);
			primitive.material.SetTexture("metallicRoughnessTexture", metallicRoughnessTextureMap, false);
		}
	}

	if (gltfMaterial.normalTexture)
	{
		primitive.material.SetVariable<float32>(
			"normalScale", 
			gltfMaterial.normalTexture.scale, 
			false
		);
		normalTextureMap := LoadTexture(gltfData, gltf, gltfMaterial.normalTexture.info.index);
		primitive.material.SetTexture("normalTexture", normalTextureMap, false);
	}

	if (gltfMaterial.occlusionTexture)
	{
		primitive.material.SetVariable<float32>(
			"occlusionStrength",
			gltfMaterial.occlusionTexture.strength,
			false
		);
		occlusionTextureMap := LoadTexture(gltfData, gltf, gltfMaterial.occlusionTexture.info.index);
		primitive.material.SetTexture("occlusionTexture", occlusionTextureMap, false);
	}

	if (gltfMaterial.emissiveTexture)
	{
		emissiveTextureMap := LoadTexture(gltfData, gltf, gltfMaterial.emissiveTexture.index);
		primitive.material.SetTexture("emissiveTexture", emissiveTextureMap, false);
	}

	primitive.material.SetVariable<Vec3>(
		"emissiveFactor", 
		gltfMaterial.emissiveFactor, 
		false
	);
	primitive.material.SetVariable<float32>(
		"alphaCutoff", 
		gltfMaterial.alphaCutoff, 
		false
	);
}

MeshToECS(gltfData: GLTFLoadData, gltf: GLTF, scene: *Scene, meshIndex: uint32, entity: Entity)
{
	gltfMesh := gltf.meshes[meshIndex];
	mesh := Mesh()

	litHandle := AssetDefNameToHandle("Lit");

	mesh.primitives.SizeTo(gltfMesh.primitives.count);
	for (gltfPrim in gltfMesh.primitives)
	{
		primitive := Primitive(litHandle);

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

		if (gltfPrim.material != InvalidGLTFIndex)
		{
			AssignMaterialToPrimitive(gltfData, gltf, gltfPrim.material, primitive);
		}

		mesh.primitives.Add(primitive);
	}

	scene.SetComponent<Mesh>(entity, mesh);
}

NodeToECS(gltfData: GLTFLoadData, gltf: GLTF, scene: *Scene, nodeIndex: uint32, parentEntity: Entity)
{
	gltfNode := gltf.nodes[nodeIndex];

	entity := scene.CreateEntity();
	scene.SetComponent<Hierarchy>(entity, Hierarchy());
	ParentEntity(parentEntity, entity, scene);

	if (gltfNode.trs)
	{
		trs := gltfNode.transform.trs;
		scene.SetComponent<Transform>(entity, Transform(trs.translation, trs.rotation, trs.scale));
	}
	else
	{
		matrix := gltfNode.transform.matrix;
		pos := Vec3();
		rot := Quaternion();
		scale := Vec3();
		matrix.Decompose(pos@, rot@, scale@);
		scene.SetComponent<Transform>(entity, Transform(pos, rot, scale));
	}

	if (gltfNode.mesh != InvalidGLTFIndex)
	{
		MeshToECS(gltfData, gltf, scene, gltfNode.mesh, entity);
	}

	for (childIndex in gltfNode.children)
	{
		NodeToECS(gltfData, gltf, scene, childIndex, entity);
	}
}