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

string CreateVertexShader(vertexStage: VertexStage)
{
    vertexShader := `
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
    `;

    return vertexShader;
}

WriteVertexShader(assetDef: AssetDef)
{
    vertexShader := CreateVertexShader(assetDef.vertex);
}

WriteShaderForAssetDef(assetDef: AssetDef)
{
    WriteVertexShader(assetDef);
}