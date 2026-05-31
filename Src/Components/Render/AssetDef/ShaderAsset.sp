package RenderAssetDef

state ShaderDef
{
    attributes: Array<Variable>,
    variables: VariableSets,
    textures: Array<TextureDefinition>,
    using: Array<string>,
    out: Array<Variable>,
    nodes: Array<ShaderNode>
}

string VariableDefToTypeName(varDef: VariableDefinition)
{
    typeName := "";
    switch (varDef.kind)
    {
        case (VariableType.Bool)   typeName = "bool";
        case (VariableType.Float)  typeName = "float";
        case (VariableType.Int)    typeName = "int";
        case (VariableType.Uint)   typeName = "uint";
        case (VariableType.BVec2)  typeName = "bvec2";
        case (VariableType.BVec3)  typeName = "bvec3";
        case (VariableType.BVec4)  typeName = "bvec4";
        case (VariableType.FVec2)  typeName = "vec2";
        case (VariableType.FVec3)  typeName = "vec3";
        case (VariableType.FVec4)  typeName = "vec4";
        case (VariableType.IVec2)  typeName = "ivec2";
        case (VariableType.IVec3)  typeName = "ivec3";
        case (VariableType.IVec4)  typeName = "ivec4";
        case (VariableType.UVec2)  typeName = "uvec2";
        case (VariableType.UVec3)  typeName = "uvec3";
        case (VariableType.UVec4)  typeName = "uvec4";
        case (VariableType.Mat3)   typeName = "mat3";
        case (VariableType.Mat4)   typeName = "mat4";
    }

    typeName = typeName.Copy();

    if (varDef.count > 1)
    {
        varCountStr := UIntToString(varDef.count);
        typeName.AppendIn("[");
        typeName.AppendIn(varCountStr);
        typeName.AppendIn("]");

        delete varCountStr;
    }

    return typeName;
}

vertexShaderStart := `
#version 450
#pragma shader_stage(vertex)

layout(set = 0, binding = 0) uniform SceneUBO 
{
    mat4 view;
    mat4 proj;
} scene;

layout(push_constant) uniform Model 
{
    mat4 model;
} model;

layout(location = 0) in vec3 position;
`;

vertexAttrStart := "\nlayout(location = ";
vertexAttrAfterLocation := ") in "

string CreateVertexAttribute(location: uint32, var: Variable)
{
    locationStr := UIntToString(location + 1);
    typeStr := VariableDefToTypeName(var.def);
    varStr := vertexAttrStart.Copy();

    varStr.AppendIn(locationStr);
    varStr.AppendIn(vertexAttrAfterLocation);
    varStr.AppendIn(typeStr);
    varStr.AppendIn(" ");
    varStr.AppendIn(var.name);
    varStr.AppendIn(";");

    delete typeStr;
    delete locationStr;

    return varStr;
}

string CreateVertexShader(vertexStage: VertexStage)
{
    vertexShader := vertexShaderStart.Copy();

    for (location .. vertexStage.attributes.count)
    {
        var := vertexStage.attributes[location];
        varStr := CreateVertexAttribute(location, var);
        vertexShader.AppendIn(varStr)
        delete varStr;
    }

    return vertexShader;
}

WriteVertexShader(assetDef: AssetDef)
{
    vertexShader := CreateVertexShader(assetDef.vertex);
    log "VERTEX SHADER: ", vertexShader;
}

WriteShaderForAssetDef(assetDef: AssetDef)
{
    WriteVertexShader(assetDef);
}