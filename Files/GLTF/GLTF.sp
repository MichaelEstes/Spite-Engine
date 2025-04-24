package GLTF

import Array
import Matrix
import Vec
import Quaternion
import Color

state GLTF
{
    asset: Asset

    scenes: Array<Scene>,
    nodes: Array<Node>,
    meshes: Array<Mesh>,
    materials: Array<Material>,
    animations: Array<Animation>,
    cameras: Array<Camera>,
    skins: Array<Skin>,
    textures: Array<Texture>,
    images: Array<Image>,
    samplers: Array<Sampler>,
    buffers: Array<Buffer>,
    bufferViews: Array<BufferView>,
    accessors: Array<Accessor>,
	
    scene: uint32
}

state Asset
{
	version: string,
	generator: *string,
	copyright: *string,
	minVersion: *string
}

state Scene
{
	nodes: Array<uint32>,
	name: *string
}

state TRS
{
	translation: Vec3,
	rotation: Quaternion,
	scale: Vec3
}

state Node
{
    name: *string,
    
    children: Array<uint32>,
    weights: Array<float32>,
    
    transform: ?{
        matrix: Matrix4,
        trs: TRS
    },
    
    camera: uint32,
    mesh: uint32,
    skin: uint32,

    trs: bool
}

state Mesh
{
	primitives: Array<Primitives>,
	weights: Array<float32>,
}

state Primitive
{
    attributes: Map<string, uint32>,
    targets: Array<Map<string, uint32>>,

    indices: uint32,
    material: uint32,
    mode: uint32
}

state TextureInfo
{
    index: uint32,
    texCoord: uint32
}

state MaterialPBRMetallicRoughness
{
    baseColorFactor: Color,
    baseColorTexture: *TextureInfo,
    
	metallicRoughnessTexture: *TextureInfo

    metallicFactor: float32,
    roughnessFactor: float32,
}

state NormalTextureInfo
{
	info: TextureInfo,
    scale: float32
}

state OcclusionTextureInfo
{
    info: TextureInfo,
    strength: float32
}

state Material
{
    name: *string,
    
    pbrMetallicRoughness: *MaterialPBRMetallicRoughness,
    normalTexture: *NormalTextureInfo,
    occlusionTexture: *OcclusionTextureInfo,
    emissiveTexture: *TextureInfo,

    emissiveFactor: Vec3,
    alphaMode: string,

    alphaCutoff: float32,
    doubleSided: bool
}

state Camera
{
    name: *string,
    
    camera: ?{
        perspective: CameraPerspective,
        orthographic: CameraOrthographic
    },

    type: string
}

state CameraPerspective
{
    aspectRatio: float32,
    yfov: float32,
    zfar: float32,
    znear: float32
}

state CameraOrthographic
{
    xmag: float32,
    ymag: float32,
    znear: float32,
    zfar: float32
}

state Buffer
{
    name: *string,

    uri: *string,
    byteLength: uint32
}

state BufferView
{
    name: *string,

    buffer: uint32,
    byteOffset: uint32,
    byteLength: uint32,
    byteStride: uint32,
    target: uint32
}

state AccessorSparseIndices
{
    bufferView: uint32,
    componentType: uint32,
    byteOffset: uint32
}

state AccessorSparseValues
{
    bufferView: uint32,
    byteOffset: uint32
}

state AccessorSparse
{
    indices: AccessorSparseIndices,
    values: AccessorSparseValues,
    count: uint32
}

state Accessor
{
    name: *string,

    max: Array<float32>,
    min: Array<float32>,
    
	type: string,
    sparse: *AccessorSparse,

    bufferView: uint32,
    byteOffset: uint32,
    componentType: uint32,
    count: uint32,
    
    normalized: bool
}

state Texture
{
    name: *string,
    
    sampler: uint32,
    source: uint32
}

state Sampler
{
    name: *string,

    magFilter: uint32,
    minFilter: uint32,
    wrapS: uint32,
    wrapT: uint32
}

state Image
{
    name: *string,
    
    uri: *string,
    mimeType: *string,
    
    bufferView: uint32
}

state Animation
{
    name: *string,
    
    channels: Array<AnimationChannel>,
    samplers: Array<AnimationSampler>
}

state AnimationChannel
{
    target: AnimationChannelTarget,
    sampler: uint32,
}

state AnimationChannelTarget
{
    path: string,  // "translation", "rotation", "scale", or "weights"
    node: uint32
}

state AnimationSampler
{
    interpolation: string  // "LINEAR", "STEP", "CUBICSPLINE"

    input: uint32,   
    output: uint32,  
}

state Skin
{
    name: *string,
    
    joints: Array<uint32>,

    inverseBindMatrices: uint32,
    skeleton: uint32
}
