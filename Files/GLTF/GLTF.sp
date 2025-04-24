package GLTF

import Array
import Matrix
import Vec
import Quaternion
import Color
import Arena
import StrArena
import JSON

state GLTF
{
    mem := Arena()
    strMem := StrArena();

    asset: GLTFAsset

    scenes: Array<GLTFScene>,
    nodes: Array<GLTFNode>,
    meshes: Array<GLTFMesh>,
    materials: Array<GLTFMaterial>,
    animations: Array<GLTFAnimation>,
    cameras: Array<GLTFCamera>,
    skins: Array<GLTFSkin>,
    textures: Array<GLTFTexture>,
    images: Array<GLTFImage>,
    samplers: Array<GLTFSampler>,
    buffers: Array<GLTFBuffer>,
    bufferViews: Array<GLTFBufferView>,
    accessors: Array<GLTFAccessor>,
	
    scene: uint32
}

state GLTFAsset
{
	version: string,
	generator: *string,
	copyright: *string,
	minVersion: *string
}

state GLTFScene
{
	nodes: Array<uint32>,
	name: *string
}

state GLTFTRS
{
	translation: Vec3,
	rotation: Quaternion,
	scale: Vec3
}

state GLTFNode
{
    name: *string,
    
    children: Array<uint32>,
    weights: Array<float32>,
    
    transform: ?{
        matrix: Matrix4,
        trs: GLTFTRS
    },
    
    camera: uint32,
    mesh: uint32,
    skin: uint32,

    trs: bool
}

state GLTFMesh
{
	primitives: Array<GLTFPrimitive>,
	weights: Array<float32>,
}

state GLTFPrimitive
{
    attributes: Map<string, uint32>,
    targets: Array<Map<string, uint32>>,

    indices: uint32,
    material: uint32,
    mode: uint32
}

state GLTFTextureInfo
{
    index: uint32,
    texCoord: uint32
}

state GLTFMaterialPBRMetallicRoughness
{
    baseColorFactor: Color,
    baseColorTexture: *GLTFTextureInfo,
    
	metallicRoughnessTexture: *GLTFTextureInfo

    metallicFactor: float32,
    roughnessFactor: float32,
}

state GLTFNormalTextureInfo
{
	info: GLTFTextureInfo,
    scale: float32
}

state GLTFOcclusionTextureInfo
{
    info: GLTFTextureInfo,
    strength: float32
}

state GLTFMaterial
{
    name: *string,
    
    pbrMetallicRoughness: *GLTFMaterialPBRMetallicRoughness,
    normalTexture: *GLTFNormalTextureInfo,
    occlusionTexture: *GLTFOcclusionTextureInfo,
    emissiveTexture: *GLTFTextureInfo,

    emissiveFactor: Vec3,
    alphaMode: string,

    alphaCutoff: float32,
    doubleSided: bool
}

state GLTFCamera
{
    name: *string,
    
    camera: ?{
        perspective: GLTFCameraPerspective,
        orthographic: GLTFCameraOrthographic
    },

    type: string
}

state GLTFCameraPerspective
{
    aspectRatio: float32,
    yfov: float32,
    zfar: float32,
    znear: float32
}

state GLTFCameraOrthographic
{
    xmag: float32,
    ymag: float32,
    znear: float32,
    zfar: float32
}

state GLTFBuffer
{
    name: *string,

    uri: *string,
    byteLength: uint32
}

state GLTFBufferView
{
    name: *string,

    buffer: uint32,
    byteOffset: uint32,
    byteLength: uint32,
    byteStride: uint32,
    target: uint32
}

state GLTFAccessorSparseIndices
{
    bufferView: uint32,
    componentType: uint32,
    byteOffset: uint32
}

state GLTFAccessorSparseValues
{
    bufferView: uint32,
    byteOffset: uint32
}

state GLTFAccessorSparse
{
    indices: GLTFAccessorSparseIndices,
    values: GLTFAccessorSparseValues,
    count: uint32
}

state GLTFAccessor
{
    name: *string,

    max: Array<float32>,
    min: Array<float32>,
    
	type: string,
    sparse: *GLTFAccessorSparse,

    bufferView: uint32,
    byteOffset: uint32,
    componentType: uint32,
    count: uint32,
    
    normalized: bool
}

state GLTFTexture
{
    name: *string,
    
    sampler: uint32,
    source: uint32
}

state GLTFSampler
{
    name: *string,

    magFilter: uint32,
    minFilter: uint32,
    wrapS: uint32,
    wrapT: uint32
}

state GLTFImage
{
    name: *string,
    
    uri: *string,
    mimeType: *string,
    
    bufferView: uint32
}

state GLTFAnimation
{
    name: *string,
    
    channels: Array<GLTFAnimationChannel>,
    samplers: Array<GLTFAnimationSampler>
}

state GLTFAnimationChannel
{
    target: GLTFAnimationChannelTarget,
    sampler: uint32,
}

state GLTFAnimationChannelTarget
{
    path: string,  // "translation", "rotation", "scale", or "weights"
    node: uint32
}

state GLTFAnimationSampler
{
    interpolation: string  // "LINEAR", "STEP", "CUBICSPLINE"

    input: uint32,   
    output: uint32,  
}

state GLTFSkin
{
    name: *string,
    
    joints: Array<uint32>,

    inverseBindMatrices: uint32,
    skeleton: uint32
}

GLTF LoadGLTF(file: string)
{
    gltf := GLTF();

    json := ParseJSONFile(file);
    defer delete json;

    root := json.root.Object();

    ParseGLTFAsset(gltf, root);


    log gltf;
    return gltf;
}

ParseGLTFAsset(gltf: GLTF, root: *JSONObject)
{
    assetValue := root.GetMember("asset");
    if (!assetValue) return;

    assetObj := assetValue.Object();
    if (!assetObj) return;

    versionValue := assetObj.GetMember("version");
    if (versionValue)
    {
        version := versionValue.String().value
        gltf.asset.version = gltf.strMem.Copy(version);
    }

    generatorValue := assetObj.GetMember("generator");
    if (generatorValue)
    {
        str := gltf.mem.Emplace<string>();
        generator := generatorValue.String().value;
        str~ = gltf.strMem.Copy(generator);
        gltf.asset.generator = str;
    }
    copyrightValue := assetObj.GetMember("copyright");
    if (copyrightValue)
    {
        str := gltf.mem.Emplace<string>();
        copyright := copyrightValue.String().value;
        str~ = gltf.strMem.Copy(copyright);
        gltf.asset.copyright = str;
    }
    minVersionValue := assetObj.GetMember("minVersion");
    if (minVersionValue)
    {
        str := gltf.mem.Emplace<string>();
        minVersion := minVersionValue.String().value;
        str~ = gltf.strMem.Copy(minVersion);
        gltf.asset.minVersion = str;
    }
}

