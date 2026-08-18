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

gltfModeToTopologyKindTable := [
	TopologyKind.PointList,
	TopologyKind.LineList,
	TopologyKind.LineLoop,
	TopologyKind.LineStrip,
	TopologyKind.TriangleList,
	TopologyKind.TraiangleStrip,
	TopologyKind.TriangleFan,
];

state GLTFLoadParam
{
	file: string,
	scene: *Scene,
	data: *any
}

state GLTFResources
{
	buffers: Array<ResourceHandle>,
	images: Array<ResourceHandle>,
	generatedBuffers: Array<Allocator<byte>>
}

state GLTFNodeResource
{
	transform: Transform,
	meshes: Array<Mesh>,
	children: Array<GLTFNodeResource>
}

state GLTFSceneResource
{
	nodes: Array<GLTFNodeResource>
}

state GLTFResource
{
	gltf: GLTF,
	scenes: Array<GLTFSceneResource>,
	resources: GLTFResources,
}

GLTFResourceManager := Resource.CreateResourceManager<GLTFResource, GLTFLoadParam>(
	['g', 'l', 't', 'f'],
	GetGLTFKey, 
	GLTFManagerLoad,
	::(handle: ResourceHandle) {
		resource := Resource.GetResource<GLTFResource>(handle);
		gltfResource := resource.data;
	},
	::(handle: ResourceHandle, child: ResourceHandle) {
		resource := Resource.GetResource<GLTFResource>(handle);
	}
);

GLTFResourceManagerID := Resource.RegisterResourceManager(GLTFResourceManager@);

ResourceKey GetGLTFKey(param: GLTFLoadParam) => ResourceKey(param.file.Copy());

GLTFManagerLoad(resourceParam: *ResourceParam<GLTFResource, GLTFLoadParam>)
{
	param := resourceParam.param;
	handle := resourceParam.handle;
	resourceManager := resourceParam.manager;
	resource := resourceManager.GetResource(handle);
	
	file := param.file;

	gltf := LoadGLTF(file);
	
	gltfData := resource.data;
	gltfData.gltf = gltf;
	gltfData.scenes = Array<GLTFSceneResource>(gltf.scenes.count);
	gltfData.resources = GLTFResources();

	for (sceneIndex .. gltf.scenes.count)
	{
		gltfScene := gltf.scenes[sceneIndex];
		sceneResourceIndex := gltfData.scenes.Add(GLTFSceneResource());
		sceneResource := gltfData.scenes[sceneResourceIndex];
		sceneResource.nodes = Array<GLTFNodeResource>(gltfScene.nodes.count);
		for (nodeIndex in gltfScene.nodes)
		{
			nodeResourceIndex := sceneResource.nodes.Add(GLTFNodeResource());
			NodeToNodeResource(gltfData, nodeIndex, sceneResource.nodes[nodeResourceIndex]@);
		}
	}
	
	resourceParam.onResourceLoad(resourceParam, ResourceResult.Loaded);
}

AssignGLTFNodeToECS(nodeResource: *GLTFNodeResource, scene: *Scene, parent: Entity)
{
	nodeEntity := scene.CreateEntity();
	scene.SetComponent<Hierarchy>(nodeEntity, Hierarchy());
	scene.SetComponent<Transform>(nodeEntity, nodeResource.transform);
	ParentEntity(parent, nodeEntity, scene);

	for (mesh in nodeResource.meshes)
	{
		meshEntity := scene.CreateEntity();
		scene.SetComponent<Hierarchy>(meshEntity, Hierarchy());
		scene.SetComponent<Transform>(meshEntity, Transform());
		ParentEntity(nodeEntity, meshEntity, scene);

		scene.SetComponent<Mesh>(meshEntity, mesh);
		if (!mesh.gpuResourceID)
		{
			mesh.gpuResourceID = scene.GetComponent<Mesh>(meshEntity).gpuResourceID;
		}
	}

	for (child in nodeResource.children)
	{
		AssignGLTFNodeToECS(child@, scene, nodeEntity);
	}
}

state GLTFParamData
{
	onLoad: ::(*Scene, Entity, *any),
	arg: *any
}

ResourceHandle UseGLTFResource(
	file: string, scene: *Scene, 
	onLoad: ::(*Scene, Entity, *any) = null, arg: *any = null
)
{
	data := AllocThreadParam<GLTFParamData>();
	data.onLoad = onLoad;
	data.arg = arg;

	gltfParam := GLTFLoadParam();
	gltfParam.file = file;
	gltfParam.scene = scene;
	gltfParam.data = data as *any;
	
	return GLTFResourceManager.LoadResource(
		gltfParam, 
		::(resourceHandle: ResourceHandle, params: *GLTFLoadParam)
		{
			paramData := params.data as *GLTFParamData;
			defer DeallocThreadParam<GLTFParamData>(paramData);
			gltfResource := GLTFResourceManager.TakeResourceRef(resourceHandle);
			gltfResult := gltfResource.result;
			gltfData := gltfResource.data;

			scene := params.scene;
			rootEntity := scene.CreateEntity();
			scene.SetComponent<Hierarchy>(rootEntity, Hierarchy());
			scene.SetComponent<Transform>(rootEntity, Transform());

			for (sceneResource in gltfData.scenes)
			{
				sceneEntity := scene.CreateEntity();
				scene.SetComponent<Hierarchy>(sceneEntity, Hierarchy());
				scene.SetComponent<Transform>(sceneEntity, Transform());
				ParentEntity(rootEntity, sceneEntity, scene);

				for (nodeResource in sceneResource.nodes)
				{
					AssignGLTFNodeToECS(nodeResource@, scene, sceneEntity);
				}
			}

			if (paramData.onLoad)
			{
				paramData.onLoad(scene, rootEntity, paramData.arg);
			}
		});
}

ResourceHandle GetBufferHandle(gltfData: GLTFResource, buffer: uint32)
{
	gltf := gltfData.gltf;
	gltfBuffer := gltf.buffers[buffer];

	uri := gltfBuffer.uri.uri~;
	return LoadURIResource(uri, gltf.path);
}

ArrayView<byte> GetBufferViewData(gltfData: GLTFResource, bufferView: uint32)
{
	gltf := gltfData.gltf;
	gltfBufferView := gltf.bufferViews[bufferView];

	handle := GetBufferHandle(gltfData, gltfBufferView.buffer);
	gltfData.resources.buffers.Add(handle);

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

ArrayView<byte> GetAccessorData(gltfData: GLTFResource, accessor: uint32)
{
	gltf := gltfData.gltf;
	gltfAccessor := gltf.accessors[accessor];

	data := GetBufferViewData(gltfData, gltfAccessor.bufferView)[0]@;
	data = data + gltfAccessor.byteOffset;

	return ArrayView<byte>(data, gltfAccessor.count);
}

ArrayView<byte> GetAccessorByteView(gltfData: GLTFResource, accessor: uint32)
{
	gltf := gltfData.gltf;
	gltfAccessor := gltf.accessors[accessor];

	data := GetBufferViewData(gltfData, gltfAccessor.bufferView)[0]@;
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

AssignAttributeToPrimitive(gltfData: GLTFResource, attrName: string, accessor: uint32, primitive: Mesh)
{
	gltf := gltfData.gltf;
	assetAttr := GLTFAttributeToAssetAttribute(attrName);
	if (assetAttr == "") return;

	index := primitive.geometry.GetAttributeIndex(assetAttr);
	if (index == uint32(-1)) return;

	view := GetAccessorByteView(gltfData, accessor);
	primitive.geometry.GetAttributeValue(index)~ = view;
}

AssignIndiciesToPrimitive(gltfData: GLTFResource, accessor: uint32, primitive: Mesh)
{
	gltf := gltfData.gltf;
	view := GetAccessorData(gltfData, accessor);

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

GenerateTangentsForPrimitive(gltfData: GLTFResource, primitive: Mesh)
{
	if (primitive.geometry.topologyKind != TopologyKind.TriangleList) return;

	tangentIndex := primitive.geometry.GetAttributeIndex("tangents");
	positionIndex := primitive.geometry.GetAttributeIndex("position");
	normalIndex := primitive.geometry.GetAttributeIndex("normal");
	uvIndex := primitive.geometry.GetAttributeIndex("uv0");

	if (primitive.geometry.GetAttributeValue(tangentIndex)~.count) return;

	positionView := primitive.geometry.GetAttributeValue(positionIndex)~;
	normalView := primitive.geometry.GetAttributeValue(normalIndex)~;
	uvView := primitive.geometry.GetAttributeValue(uvIndex)~;
	if (!positionView.count || !normalView.count || !uvView.count) return;

	vertexCount := positionView.count / (#sizeof Vec3);
	positions := positionView.start as *Vec3;
	normals := normalView.start as *Vec3;
	uvs := uvView.start as *Vec2;

	indices16 := primitive.geometry.indices.start;
	indices32 := primitive.geometry.indices.start as *uint32;
	hasIndices := primitive.geometry.indexKind != IndexKind.None &&
				  primitive.geometry.indices.count > 0;

	indexCount := vertexCount; 
	if (hasIndices)
	{
		indexCount = primitive.geometry.indices.count;
		if (primitive.geometry.indexKind == IndexKind.I32) indexCount = indexCount / 2;
	}

	tanAcc := ZeroedAllocator<Vec3>();
	tanAcc.Alloc(vertexCount);
	bitanAcc := ZeroedAllocator<Vec3>();
	bitanAcc.Alloc(vertexCount);
	defer {
		tanAcc.Dealloc(vertexCount);
		bitanAcc.Dealloc(vertexCount);
	}

	triangleCount := indexCount / 3;
	for (tri .. triangleCount)
	{
		base := tri * 3;
		i0 := base as uint;
		i1 := (base + 1) as uint;
		i2 := (base + 2) as uint;
		if (hasIndices)
		{
			if (primitive.geometry.indexKind == IndexKind.I32)
			{
				i0 = indices32[base]~ as uint;
				i1 = indices32[base + 1]~ as uint;
				i2 = indices32[base + 2]~ as uint;
			}
			else
			{
				i0 = indices16[base]~ as uint;
				i1 = indices16[base + 1]~ as uint;
				i2 = indices16[base + 2]~ as uint;
			}
		}
		edge1 := positions[i1]~ - positions[i0]~;
		edge2 := positions[i2]~ - positions[i0]~;
		duv1 := uvs[i1]~ - uvs[i0]~;
		duv2 := uvs[i2]~ - uvs[i0]~;

		invDet := 1.0 / (duv1.x * duv2.y - duv2.x * duv1.y);

		tangent := (edge1 * duv2.y - edge2 * duv1.y) * invDet;
		bitangent := (edge2 * duv1.x - edge1 * duv2.x) * invDet;

		tanAcc[i0]~ = tanAcc[i0]~ + tangent;
		tanAcc[i1]~ = tanAcc[i1]~ + tangent;
		tanAcc[i2]~ = tanAcc[i2]~ + tangent;
		bitanAcc[i0]~ = bitanAcc[i0]~ + bitangent;
		bitanAcc[i1]~ = bitanAcc[i1]~ + bitangent;
		bitanAcc[i2]~ = bitanAcc[i2]~ + bitangent;
	}

	tangentData := Allocator<Vec4>();
	tangentData.Alloc(vertexCount);
	gltfData.resources.generatedBuffers.Add(tangentData as Allocator<byte>);

	for (i .. vertexCount)
	{
		normal := normals[i]~;
		tangent := tanAcc[i]~;

		tangent = tangent - (normal * normal.Dot(tangent));
		tangent.Normalize();

		tangentData[i]~ = Vec4(tangent.x, tangent.y, tangent.z, 1.0);
		if (normal.Cross(tangent).Dot(bitanAcc[i]~) < 0.0) tangentData[i].w = -1.0;
	}

	primitive.geometry.GetAttributeValue(tangentIndex)~ =
		ArrayView<byte>(tangentData.ptr as *byte, vertexCount * (#sizeof Vec4));
}

TextureMap LoadTexture(gltfData: GLTFResource, textureIndex: uint32)
{
	gltf := gltfData.gltf;
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
		imageHandle := LoadImageResource(uri, gltf.path);

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

AssignMaterialToPrimitive(gltfData: GLTFResource, materialIndex: uint32, primitive: Mesh)
{
	gltf := gltfData.gltf;
	gltfMaterial := gltf.materials[materialIndex];

	pbr := GLTFMaterialPBRMetallicRoughness();
	if (gltfMaterial.pbrMetallicRoughness)
	{
		pbr = gltfMaterial.pbrMetallicRoughness~;
	}

	primitive.material.SetVariable<Color>("baseColor", pbr.baseColorFactor, false);
	primitive.material.SetVariable<float32>("metallicFactor", pbr.metallicFactor, false);
	primitive.material.SetVariable<float32>("roughnessFactor", pbr.roughnessFactor, false);

	if (pbr.baseColorTexture)
	{
		colorTextureMap := LoadTexture(gltfData, pbr.baseColorTexture.index);
		primitive.material.SetTexture("colorTexture", colorTextureMap, false);
	}

	if (pbr.metallicRoughnessTexture)
	{
		metallicRoughnessTextureMap := LoadTexture(gltfData, pbr.metallicRoughnessTexture.index);
		primitive.material.SetTexture("metallicRoughnessTexture", metallicRoughnessTextureMap, false);
	}

	if (gltfMaterial.normalTexture)
	{
		primitive.material.SetVariable<float32>(
			"normalScale", 
			gltfMaterial.normalTexture.scale, 
			false
		);
		normalTextureMap := LoadTexture(gltfData, gltfMaterial.normalTexture.info.index);
		primitive.material.SetTexture("normalTexture", normalTextureMap, false);
	}
	else
	{
		normalDefault := GLTFNormalTextureInfo();
		primitive.material.SetVariable<float32>(
			"normalScale", 
			normalDefault.scale, 
			false
		);
	}

	if (gltfMaterial.occlusionTexture)
	{
		primitive.material.SetVariable<float32>(
			"occlusionStrength",
			gltfMaterial.occlusionTexture.strength,
			false
		);
		occlusionTextureMap := LoadTexture(gltfData, gltfMaterial.occlusionTexture.info.index);
		primitive.material.SetTexture("occlusionTexture", occlusionTextureMap, false);
	}
	else
	{
		occlusionDefault := GLTFOcclusionTextureInfo();
		primitive.material.SetVariable<float32>(
			"occlusionStrength",
			occlusionDefault.strength,
			false
		);
	}

	if (gltfMaterial.emissiveTexture)
	{
		emissiveTextureMap := LoadTexture(gltfData, gltfMaterial.emissiveTexture.index);
		primitive.material.SetTexture("emissiveTexture", emissiveTextureMap, false);
	}

	primitive.material.SetVariable<Vec3>(
		"emissiveFactor", 
		gltfMaterial.emissiveFactor, 
		false
	);
	
	primitive.material.alphaMode = GetAlphaMode(gltfMaterial);
	alphaCutoff := float32(0.0);
	if (primitive.material.alphaMode == AlphaMode.Mask) alphaCutoff = gltfMaterial.alphaCutoff;
	primitive.material.SetVariable<float32>("alphaCutoff", alphaCutoff, false);

	if (gltfMaterial.doubleSided) primitive.material.cullMode = CullModeFlags.None;
}

AssignGLTFMesh(gltfData: GLTFResource, meshIndex: uint32, nodeResource: *GLTFNodeResource)
{
	gltf := gltfData.gltf;
	gltfMesh := gltf.meshes[meshIndex];

	// litHandle := AssetDefNameToHandle("Lit");
	litHandle := AssetDefNameToHandle("LitPBR");

	nodeResource.meshes.SizeTo(gltfMesh.primitives.count);
	for (gltfPrim in gltfMesh.primitives)
	{
		primitive := Mesh(litHandle);
		primitive.geometry.topologyKind = gltfModeToTopologyKindTable[gltfPrim.mode];

		for (attrKV in gltfPrim.attributes)
		{
			attrName := attrKV.key~;
			attrAccessor := attrKV.value~;

			AssignAttributeToPrimitive(gltfData, attrName, attrAccessor, primitive);
		}

		if (gltfPrim.indices != InvalidGLTFIndex)
		{
			AssignIndiciesToPrimitive(gltfData, gltfPrim.indices, primitive);
		}

		GenerateTangentsForPrimitive(gltfData, primitive);

		if (gltfPrim.material != InvalidGLTFIndex)
		{
			AssignMaterialToPrimitive(gltfData, gltfPrim.material, primitive);
		}

		nodeResource.meshes.Add(primitive);
	}
}

NodeToNodeResource(gltfData: GLTFResource, nodeIndex: uint32, nodeResource: *GLTFNodeResource)
{
	gltf := gltfData.gltf;
	gltfNode := gltf.nodes[nodeIndex];

	if (gltfNode.trs)
	{
		trs := gltfNode.transform.trs;
		nodeResource.transform = Transform(trs.translation, trs.rotation, trs.scale);
	}
	else
	{
		matrix := gltfNode.transform.matrix;
		pos := Vec3();
		rot := Quaternion();
		scale := Vec3();
		matrix.Decompose(pos@, rot@, scale@);
		nodeResource.transform = Transform(pos, rot, scale);
	}

	if (gltfNode.mesh != InvalidGLTFIndex)
	{
		AssignGLTFMesh(gltfData, gltfNode.mesh, nodeResource);
	}

	if (gltfNode.children.count)
	{
		nodeResource.children = Array<GLTFNodeResource>(gltfNode.children.count);
		for (childIndex in gltfNode.children)
		{
			childResourceIndex := nodeResource.children.Add(GLTFNodeResource());
			NodeToNodeResource(gltfData, childIndex, nodeResource.children[childResourceIndex]@);
		}
	}
}