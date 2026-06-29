package RenderAssetDef

import Array
import ShaderTools

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

enum TextureType: ubyte
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

enum ColorSpace: ubyte
{
    SRGB,
    UNORM
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
    } = [
		float32:[0.0, 0.0, 0.0, 0.0],
		float32:[0.0, 0.0, 0.0, 0.0],
		float32:[0.0, 0.0, 0.0, 0.0],
		float32:[0.0, 0.0, 0.0, 0.0],
	]
}

state VariableDefinition
{
    defaultValue: Value,

    kind: VariableType,
    precision: VariablePrecision
    count: uint32
}

uint32 VariableDefinition::ValueSize()
{
    typeSize := uint32(0);
    switch (this.kind)
    {
        case (VariableType.Bool)  typeSize = 1;
        case (VariableType.Float) typeSize = 4;
        case (VariableType.Int)   typeSize = 4;
        case (VariableType.Uint)  typeSize = 4;
        case (VariableType.BVec2) typeSize = 2;
        case (VariableType.BVec3) typeSize = 3;
        case (VariableType.BVec4) typeSize = 4;
        case (VariableType.FVec2) typeSize = 8;
        case (VariableType.FVec3) typeSize = 12;
        case (VariableType.FVec4) typeSize = 16;
        case (VariableType.IVec2) typeSize = 8;
        case (VariableType.IVec3) typeSize = 12;
        case (VariableType.IVec4) typeSize = 16;
        case (VariableType.UVec2) typeSize = 8;
        case (VariableType.UVec3) typeSize = 12;
        case (VariableType.UVec4) typeSize = 16;
        case (VariableType.Mat3)  typeSize = 36;
        case (VariableType.Mat4)  typeSize = 64;
    }

    if (this.count) 
    {
        typeSize *= this.count;
    }
    return typeSize;
}

state TextureDefinition
{
    name: string,
    defaultValue: [4]ubyte,
    kind: TextureType,
    precision: VariablePrecision,
    format: SamplerFormat,
    colorSpace: ColorSpace,
    multisample: bool,
    filterable: bool,
    hasDefault: bool = false
}

TextureDefinition TextureDefinition::Clone()
{
    clone := this;
    clone.name = this.name.Copy();
    return clone;
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

Variable Variable::Clone()
{
    clone := this;
    clone.name = this.name.Copy();
    return clone;
}

state ShaderNode
{
    name: string,
    code: string,
    after: string,
    before: string
}

ShaderNode::delete
{
    delete this.name;
    delete this.code;
    delete this.after;
    delete this.before;
}

ShaderNode ShaderNode::Clone()
{
    clone := ShaderNode();
    clone.name = this.name.Copy();
    clone.code = this.code.Copy();
    clone.after = this.after.Copy();
    clone.before = this.before.Copy();
    return clone;
}

state VariableSets
{
    sets: Array<Array<Variable>>
}

VariableSets::delete
{
    delete this.sets;
}

uint32 VariableSets::GetSetsValueSize()
{
    size := uint32(0);
    for (set in this.sets)
    {
        for (var in set)
        {
            size += var.def.ValueSize();
        }
    }
    return size;
}

VariableSets VariableSets::Clone()
{
    clone := VariableSets();
    clone.sets = this.sets.Copy(
        ::Array<Variable>(val: Array<Variable>)
        {
            return val.Copy(
                ::Variable(variable: Variable)
                {
                    return variable.Clone();
                }
            );
        }
    )
    return clone;
}

state VertexStage
{
    attributes: Array<Variable>,
    variables: VariableSets,
    out: Array<Variable>,
    nodes: Array<ShaderNode>,

    compiled: string
}

VertexStage::delete
{
    delete this.attributes;
    delete this.variables;
    delete this.out;
    delete this.nodes;
    delete this.compiled;
}

VertexStage VertexStage::Clone()
{
    cloned := VertexStage();
    cloned.attributes = this.attributes.Copy(
        ::Variable(variable: Variable)
        {
            return variable.Clone();
        }
    );
    cloned.variables = this.variables.Clone();
    cloned.out = this.out.Copy(
        ::Variable(variable: Variable)
        {
            return variable.Clone();
        }
    );
    cloned.nodes = this.nodes.Copy(
        ::ShaderNode(node: ShaderNode)
        {
            return node.Clone();
        }
    );
    return cloned;
}

state FragmentStage
{
    variables: VariableSets,
    textures: Array<TextureDefinition>,
    using: Array<string>,
    out: Array<Variable>,
    nodes: Array<ShaderNode>,

    compiled: string,

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
    delete this.compiled;
}

FragmentStage FragmentStage::Clone()
{
    cloned := FragmentStage();
    cloned.variables = this.variables.Clone();
    cloned.textures = this.textures.Copy(
        ::TextureDefinition(texture: TextureDefinition)
        {
            return texture.Clone();
        }
    );
    cloned.using = this.using.Copy(
        ::string(using: string)
        {
            return using.Copy();
        }
    );
    cloned.out = this.out.Copy(
        ::Variable(variable: Variable)
        {
            return variable.Clone();
        }
    );
    cloned.nodes = this.nodes.Copy(
        ::ShaderNode(node: ShaderNode)
        {
            return node.Clone();
        }
    );
    cloned.alphaMode = this.alphaMode;
    cloned.cullMode = this.cullMode;
    cloned.polygonMode = this.polygonMode;
    return cloned;
}

enum AssetDefFlags: uint32
{
    UseLightCulling = 1 << 0,
}

state AssetDef
{
    name: string,
    vertex: VertexStage,
    fragment: FragmentStage,

    compiled: {
        vertex: string,
        fragment: string
    },

    flags: AssetDefFlags
}

AssetDef::delete
{
    delete this.name;
    delete this.vertex;
    delete this.fragment;
}

AssetDef AssetDef::Clone()
{
    cloned := AssetDef();

    cloned.vertex = this.vertex.Clone();
    cloned.fragment = this.fragment.Clone();
    cloned.flags = this.flags;

    return cloned;
}


AssetDef::Compile(compiler: ShaderCompiler)
{
    CompileShadersForAssetDef(this, compiler);
}

*Variable FindVariableByName(vars: Array<Variable>, name: string)
{
    for (var in vars)
    {
        if (var.name == name) return var@;
    }

    return null;
}

uint32 FindVariableIndexByName(vars: Array<Variable>, name: string)
{
    for (i .. vars.count)
    {
        var := vars[i];
        if (var.name == name) return i;
    }

    return -1;
}

state VariableSetIndex
{
    [value]
    setIndex: uint32,
    varIndex: uint32
}

VariableSetIndex::(setIndex: uint32, varIndex: uint32)
{
    this.setIndex = setIndex;
    this.varIndex = varIndex;
}

VariableSetIndex FindVariableSetIndexByName(vars: VariableSets, name: string)
{
    index := VariableSetIndex();
    for (setIndex .. vars.sets.count)
    {
        set := vars.sets[setIndex];
        for (varIndex .. set.count)
        {
            var := set[varIndex];
            if (var.name == name)
            {
                return VariableSetIndex(setIndex, varIndex);
            }
        }
    }

    return VariableSetIndex(-1, -1);
}

uint32 FindVariableSetOffsetAtIndex(vars: VariableSets, index: VariableSetIndex)
{
    offset := uint32(0);
    for (setIndex .. index.setIndex)
    {
        set := vars.sets[setIndex];
        for (var in set)
        {
            offset += var.def.ValueSize();
        }
    }

    set := vars.sets[index.setIndex];
    for (varIndex .. index.varIndex)
    {
        offset += set[varIndex].def.ValueSize();
    }
    
    return offset;
}

uint32 FindTextureIndexByName(textures: Array<TextureDefinition>, name: string)
{
    for (i .. textures.count)
    {
        tex := textures[i];
        if (tex.name == name) return i;
    }

    return -1;
}