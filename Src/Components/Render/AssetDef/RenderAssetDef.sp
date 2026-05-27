package RenderAssetDef

import Optional
import Array

enum RenderStage: uint32
{
    Vertex,
    Fragment,
    Compute
}

enum VariableType: uint32
{
    Bool,
    Float,
    Int,
    Uint,
    BVec2,
    BVec3,
    BVec4,
    FVec2,
    FVec3,
    FVec4,
    IVec2,
    IVec3,
    IVec4,
    UVec2,
    UVec3,
    UVec4,
    Mat3,
    Mat4
}

enum TextureType: uint32
{
    Sampler2D,
    Sampler2DArray,
    SamplerCubemap
}

enum SamplerFormat: ubyte
{
    Float,
    Int
}

enum VariablePrecision: ubyte
{
    Low,
    Medium,
    High,
    Default
}

enum AlphaMode: ubyte
{
	Opaque,
	Mask,
	Blend
}

enum CullModeFlags: ubyte
{
	None = 0,
	Front = 1 << 0,
	Back = 1 << 1,
	Both = CullModeFlags.Front | CullModeFlags.Back
}

enum PolygonMode: ubyte
{
	Fill,
	Line,
	Point
}

state Value 
{
    val: ?{
        b: bool,
        f: float32,
        i: int32,
        u: uint32,
        bVec2: [2]bool,
        bVec3: [3]bool,
        bVec4: [4]bool,
        fVec2: [2]float32,
        fVec3: [3]float32,
        fVec4: [4]float32,
        iVec2: [2]int32,
        iVec3: [3]int32,
        iVec4: [4]int32,
        uVec2: [2]uint32,
        uVec3: [3]uint32,
        uVec4: [4]uint32,
        mat3: [3][3]float32,
        mat4: [4][4]float32,
    }
}

state VariableDefinition
{
    defaultValue: Value,

    kind: VariableType,
    precision: VariablePrecision
    count: uint32
}

state TextureDefinition
{
    name: string,
    kind: TextureType,
    precision: VariablePrecision,
    format: SamplerFormat,
    multisample: bool,
    filterable: bool
}

state Variable
{
    name: string,
    def: VariableDefinition
}

Variable::delete
{
    delete this.name;
}

state ShaderNode
{
    name: string,
    code: string,
    after: string,
    before: string
}

state VariableSets
{
    sets: Array<Array<Variable>>
}

state VertexStage
{
    attributes: Array<Variable>,
    variables: VariableSets,
    out: Array<Variable>
    nodes: Array<ShaderNode>
}

VertexStage::delete
{
    delete this.attributes;
    delete this.variables;
    delete this.out;
    delete this.nodes;
}

state FragmentStage
{
    variables: VariableSets,
    textures: Array<TextureDefinition>,
    using: Array<string>,
    out: Array<Variable>,
    nodes: Array<ShaderNode>,

    alphaMode: AlphaMode,
	cullMode: CullModeFlags,
	polygonMode: PolygonMode
}

FragmentStage::delete
{
    delete this.variables;
    delete this.textures;
    delete this.using;
    delete this.out;
    delete this.nodes;
}

state ComputeStage
{
    variables: VariableSets,
    out: Array<Variable>,
    nodes: Array<ShaderNode>,
}

ComputeStage::delete
{
    delete this.variables;
    delete this.out;
    delete this.nodes;
}

state AssetDef
{
    name: string,
    vertex: VertexStage,
    fragment: FragmentStage,
    compute: ComputeStage
}

AssetDef::delete
{
    delete this.name;
    delete this.vertex;
    delete this.fragment;
    delete this.compute;
}
