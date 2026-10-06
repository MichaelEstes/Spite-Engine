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
import Assets

gltfModeToTopologyKindTable := [
	TopologyKind.PointList,
	TopologyKind.LineList,
	TopologyKind.LineLoop,
	TopologyKind.LineStrip,
	TopologyKind.TriangleList,
	TopologyKind.TraiangleStrip,
	TopologyKind.TriangleFan,
];

state GLTFResourceArg
{
	file: string
}

state GLTFAccessorArg
{
	gltf: *GLTF,
	data: *byte,
	bufferView: uint32,
	accessor: uint32
}

state GLTFDeinterleavedAccessor
{
	mem: Allocator<byte>,
	count: uint
}

GLTFDeinterleavedAccessor::delete
{
	this.mem.Dealloc(this.count);
}

state GLTFTangentsArg
{
	meshIndex: uint32,
	primitiveIndex: uint32,
	primitive: *Mesh,
	positionView: ArrayView<byte>,
	normalView: ArrayView<byte>,
	uvView: ArrayView<byte>
}

state GLTFGeneratedTangents
{
	mem: Allocator<Vec4>,
	count: uint
}

GLTFGeneratedTangents::delete
{
	this.mem.Dealloc(this.count);
}

state GLTFNodeResource
{
	transform: Transform,
	meshes: Array<Mesh>,
	children: Array<GLTFNodeResource>
}

GLTFNodeResource::delete
{
	delete this.meshes;
	delete this.children;
}

state GLTFSceneResource
{
	nodes: Array<GLTFNodeResource>
}

GLTFSceneResource::delete
{
	delete this.nodes;
}

state GLTFResource
{
	gltf: GLTF,
	scenes: Array<GLTFSceneResource>,
	handle: ResourceHandle
}

GLTFResource::delete
{
	delete this.gltf;
	delete this.scenes;
}

GLTFResourceManager := Resource.CreateResourceManager<GLTFResourceArg>(
	['g', 'l', 't', 'f'],
	::(manager: *ResourceManager<GLTFResourceArg>) {
		manager.RegisterResourceType<GLTFResource>(CreateGLTFKey, GLTFManagerLoad);
		manager.RegisterSubResourceType<GLTFDeinterleavedAccessor>(CreateDeinterleavedAccessorKey, DeinterleavedAccessorLoad);
		manager.RegisterSubResourceType<GLTFGeneratedTangents>(CreateGeneratedTangentsKey, GeneratedTangentsLoad);
	},
	::*_Type(param: *GLTFResourceArg) => return #typeof GLTFResource,
	::(handle: ResourceHandle) {
		resource := Resource.GetResource<GLTFResource>(handle);
		gltfResource := resource.data;
	}
);

ResourceKey CreateGLTFKey(param: *GLTFResourceArg) => ResourceKey(param.file.Copy());

ResourceKey CreateDeinterleavedAccessorKey(param: *GLTFAccessorArg) => ResourceKey(param.accessor);

ResourceKey CreateGeneratedTangentsKey(param: *GLTFTangentsArg) => ResourceKey((param.meshIndex as uint << 32) | param.primitiveIndex);

GLTFManagerLoad(resourceArg: *ResourceArg<GLTFResourceArg>, resource: *Resource<GLTFResource>)
{
	param := resourceArg.arg;

	file := param.file;

	gltf := LoadGLTF(file);
	
	gltfData := resource.data;
	gltfData.gltf = gltf;
	gltfData.scenes = Array<GLTFSceneResource>(gltf.scenes.count);
	gltfData.handle = resourceArg.handle;

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

	resource.result = ResourceResult.Loaded;
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
		sceneMesh := scene.GetComponent<Mesh>(meshEntity);
		if (!mesh.gpuResourceID)
		{
			mesh.gpuResourceID = sceneMesh.gpuResourceID;
		}
	}

	for (child in nodeResource.children)
	{
		AssignGLTFNodeToECS(child@, scene, nodeEntity);
	}
}

ResourceHandle UseGLTFResource(
	file: string, scene: *Scene,
	onLoad: ::(*Scene, Entity, *any) = null, arg: *any = null
)
{
	gltfArg := GLTFResourceArg();
	gltfArg.file = file;

	resourceHandle := GLTFResourceManager.LoadResource(gltfArg);

	gltfResource := GLTFResourceManager.ReferenceResource<GLTFResource>(resourceHandle);
	gltfData := gltfResource.data;

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

	if (onLoad)
	{
		onLoad(scene, rootEntity, arg);
	}

	return resourceHandle;
}

ResourceHandle useGLTFAssetResource(
	asset: Asset, scene: *Scene, 
	onLoad: ::(*Scene, Entity, *any) = null, arg: *any = null
)
{
	assetPath := GetAssetPath(asset);
	if (!assetPath) return ResourceHandle();
	return UseGLTFResource(assetPath, scene, onLoad, arg);
}

ResourceHandle GetBufferHandle(gltfData: GLTFResource, buffer: uint32)
{
	gltf := gltfData.gltf;
	gltfBuffer := gltf.buffers[buffer];

	uri := gltfBuffer.uri~;
	return LoadURIResource(uri, gltf.path);
}

DeinterleavedAccessorLoad(resourceArg: *ResourceArg<GLTFAccessorArg>, subResource: *SubResource<GLTFDeinterleavedAccessor>)
{
	param := resourceArg.arg;

	gltf := param.gltf;
	gltfBufferView := gltf.bufferViews[param.bufferView];
	gltfAccessor := gltf.accessors[param.accessor];

	byteStride := gltfBufferView.byteStride;

	itemByteLength := GetAccessorItemByteLength(gltfAccessor);
	itemByteCount := GetAccessorItemByteCount(gltfAccessor);
	itemByteSize := itemByteLength * itemByteCount;
	totalByteSize := gltfAccessor.count * itemByteSize;

	deinterleaved := subResource.data;
	deinterleaved.mem = Allocator<byte>();
	deinterleaved.mem.Alloc(totalByteSize);
	deinterleaved.count = totalByteSize;

	start := param.data + gltfAccessor.byteOffset;

	for (i .. gltfAccessor.count)
	{
		itemOffset := i * byteStride;
		itemStart := start + itemOffset;

		for (j .. itemByteSize)
		{
			itemByte := itemStart + j;
			deinterleaved.mem[(i * itemByteSize) + j]~ = itemByte~;
		}
	}
}

ArrayView<byte> GetDeinterleavedBufferData(gltfData: GLTFResource, data: *byte, bufferView: uint32, accessor: uint32)
{
	accessorArg := GLTFAccessorArg();
	accessorArg.gltf = gltfData.gltf@;
	accessorArg.data = data;
	accessorArg.bufferView = bufferView;
	accessorArg.accessor = accessor;

	handle := GLTFResourceManager.CreateSubResource<GLTFDeinterleavedAccessor>(gltfData.handle, accessorArg@);
	deinterleaved := GLTFResourceManager.GetSubResource<GLTFDeinterleavedAccessor>(handle).data;

	return ArrayView<byte>(deinterleaved.mem[0], deinterleaved.count);
}

ArrayView<byte> GetBufferViewData(gltfData: GLTFResource, bufferView: uint32, accessor: uint32 = InvalidGLTFIndex)
{
	gltf := gltfData.gltf;
	gltfBufferView := gltf.bufferViews[bufferView];
	gltfBuffer := gltf.buffers[gltfBufferView.buffer];

	data: *byte = null;
	if (gltfBuffer.uri)
	{
		handle := GetBufferHandle(gltfData, gltfBufferView.buffer);
		AddSubResource(gltfData.handle, handle);

		data = URIResourceManager.GetResource<URIResource>(handle).data.buffer;
	}
	else
	{
		data = gltfBuffer.data[0];
	}

	data = data + gltfBufferView.byteOffset;
	
	if (gltfBufferView.byteStride != 0)
	{
		return GetDeinterleavedBufferData(gltfData, data, bufferView, accessor);
	}
	else
	{
		if (accessor != InvalidGLTFIndex)
		{
			gltfAccessor := gltf.accessors[accessor];
			data = data + gltfAccessor.byteOffset;
		}
		return ArrayView<byte>(data, gltfBufferView.byteLength);
	}
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

	data := GetBufferViewData(gltfData, gltfAccessor.bufferView, accessor)[0]@;

	return ArrayView<byte>(data, gltfAccessor.count);
}

ArrayView<byte> GetAccessorByteView(gltfData: GLTFResource, accessor: uint32)
{
	gltf := gltfData.gltf;
	gltfAccessor := gltf.accessors[accessor];

	data := GetBufferViewData(gltfData, gltfAccessor.bufferView, accessor)[0]@;

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
	}
	else
	{
		log "AssignIndiciesToPrimitive Invalid item length for index buffer";
	}

	indices := ArrayView<uint16>(view[0]@, count);
	primitive.geometry.indices = indices;
}

GeneratedTangentsLoad(resourceArg: *ResourceArg<GLTFTangentsArg>, subResource: *SubResource<GLTFGeneratedTangents>)
{
	param := resourceArg.arg;
	primitive := param.primitive;

	vertexCount := param.positionView.count / (#sizeof Vec3);
	positions := param.positionView.start as *Vec3;
	normals := param.normalView.start as *Vec3;
	uvs := param.uvView.start as *Vec2;

	indices16 := primitive.geometry.indices.start;
	indices32 := primitive.geometry.indices.start as *uint32;
	hasIndices := primitive.geometry.indexKind != IndexKind.None &&
				  primitive.geometry.indices.count > 0;

	indexCount := primitive.geometry.indices.count; 

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

	tangents := subResource.data;
	tangents.mem = Allocator<Vec4>();
	tangents.mem.Alloc(vertexCount);
	tangents.count = vertexCount;

	for (i .. vertexCount)
	{
		normal := normals[i]~;
		tangent := tanAcc[i]~;

		tangent = tangent - (normal * normal.Dot(tangent));
		tangent.Normalize();

		tangents.mem[i]~ = Vec4(tangent.x, tangent.y, tangent.z, 1.0);
		if (normal.Cross(tangent).Dot(bitanAcc[i]~) < 0.0) tangents.mem[i].w = -1.0;
	}
}

GenerateTangentsForPrimitive(gltfData: GLTFResource, meshIndex: uint32, primitiveIndex: uint32, primitive: Mesh)
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

	tangentsArg := GLTFTangentsArg();
	tangentsArg.meshIndex = meshIndex;
	tangentsArg.primitiveIndex = primitiveIndex;
	tangentsArg.primitive = primitive@;
	tangentsArg.positionView = positionView;
	tangentsArg.normalView = normalView;
	tangentsArg.uvView = uvView;

	handle := GLTFResourceManager.CreateSubResource<GLTFGeneratedTangents>(gltfData.handle, tangentsArg@);
	tangents := GLTFResourceManager.GetSubResource<GLTFGeneratedTangents>(handle).data;

	primitive.geometry.GetAttributeValue(tangentIndex)~ =
		ArrayView<byte>(tangents.mem.ptr as *byte, tangents.count * (#sizeof Vec4));
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
		imageView := GetBufferViewData(gltfData, gltfImage.bufferView);
		imageData := string(imageView.count, imageView.start);

		texture.imageHandle = CreateImageResource(imageData, gltf.path);
	}
	else
	{
		uri := gltfImage.uri~;
		imageHandle := LoadImageResource(uri, gltf.path);

		texture.imageHandle = imageHandle;
	}

	AddSubResource(gltfData.handle, texture.imageHandle);


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

AssignMaterialToPrimitive(gltfData: GLTFResource, gltfMaterial: GLTFMaterial, primitive: Mesh)
{
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
	for (primitiveIndex .. gltfMesh.primitives.count)
	{
		gltfPrim := gltfMesh.primitives[primitiveIndex];
		primitive := Mesh(litHandle, gltfData.handle);
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

		GenerateTangentsForPrimitive(gltfData, meshIndex, primitiveIndex, primitive);

		if (gltfPrim.material != InvalidGLTFIndex)
		{
			gltfMaterial := gltf.materials[gltfPrim.material];
			AssignMaterialToPrimitive(gltfData, gltfMaterial, primitive);
		}
		else
		{
			AssignMaterialToPrimitive(gltfData, GLTFMaterial(), primitive);
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