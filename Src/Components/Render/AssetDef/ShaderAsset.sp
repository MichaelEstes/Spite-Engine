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