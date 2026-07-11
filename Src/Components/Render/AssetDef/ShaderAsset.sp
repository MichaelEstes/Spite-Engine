package RenderAssetDef

import ShaderTools

string WriteShaderNodes(nodes: Array<ShaderNode>)
{
    shader := string();
    count := nodes.count;
    if (!count) return shader;

    written := Array<bool>();
    for (i .. count) written.Add(false);
    defer delete written;

    writtenCount := uint32(0);
    while (writtenCount < count)
    {
        madeProgress := false;

        for (i .. count)
        {
            if (written[i]) continue;

            canWrite := true;

            if (nodes[i].after != "")
            {
                for (j .. count)
                {
                    if (nodes[j].name == nodes[i].after && !written[j])
                    {
                        canWrite = false;
                        break;
                    }
                }
            }

            if (canWrite)
            {
                for (j .. count)
                {
                    if (j != i && nodes[j].before != "" && 
                        nodes[j].before == nodes[i].name && !written[j])
                    {
                        canWrite = false;
                        break;
                    }
                }
            }

            if (!canWrite) continue;

            code := nodes[i].code;
            for (line in code.Lines())
            {
                line.RemovePrecedingWhiteSpace();
                if (line.count)
                {
                    shader.AppendIn("\t");
                    shader.AppendIn(line.AsString());
                }
            }

            written[i] = true;
            writtenCount += 1;
            madeProgress = true;
        }

        if (!madeProgress) break;
    }

    return shader;
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

layoutSetStart := "\nlayout(set = ";
variableBinding := ", binding = 0) uniform ";
variableUniform := ") uniform ";

layoutVarStart := "\nlayout(location = ";
varIn := ") in "
varOut := ") out "

string WriteVariableSets(shader: string, varSets: VariableSets, setOffset: uint32, writeDefines: bool = true)
{
    if (!varSets.sets.count) return shader;

    for (setIndex .. varSets.sets.count)
    {
        set := varSets.sets[setIndex];
        
        setIndexStr := UIntToString(setIndex + setOffset);
        defer delete setIndexStr;

        setStr := layoutSetStart.Copy();
        defer delete setStr;

        setStr.AppendIn(setIndexStr);
        setStr.AppendIn(variableBinding);
        setStr.AppendIn("Set");
        setStr.AppendIn(setIndexStr);
        setStr.AppendIn("\n{\n");
        
        for (varIndex .. set.count)
        {
            var := set[varIndex];

            typeStr := VariableDefToTypeName(var.def);
            defer delete typeStr;

            setStr.AppendIn("\t");
            setStr.AppendIn(typeStr);
            setStr.AppendIn(" ");
            setStr.AppendIn(var.name);
            setStr.AppendIn(";\n");
        }

        setStr.AppendIn("} set");
        setStr.AppendIn(setIndexStr);
        setStr.AppendIn(";\n");

        if (writeDefines) 
        {
            for (var in set)
            {
                setStr.AppendIn("#define ");
                setStr.AppendIn(var.name);
                setStr.AppendIn(" set");
                setStr.AppendIn(setIndexStr);
                setStr.AppendIn(".");
                setStr.AppendIn(var.name);
                setStr.AppendIn("\n");
            }
        }

        shader.AppendIn(setStr);
    }

    shader.AppendIn("\n");
    return shader;
}

string WriteOutVariables(shader: string, vars: Array<Variable>, 
                         namePrefix: string = "", locationOffset: uint32 = 0)
{
    if (!vars.count) return shader;

    for (location .. vars.count)
    {
        var := vars[location];
        
        locationStr := UIntToString(location + locationOffset);
        typeStr := VariableDefToTypeName(var.def);
        defer {
            delete locationStr;
            delete varStr;
        }

        varStr := layoutVarStart.Copy();
        varStr.AppendIn(locationStr);
        varStr.AppendIn(varOut);
        varStr.AppendIn(typeStr);
        varStr.AppendIn(" ");
        varStr.AppendIn(namePrefix);
        varStr.AppendIn(var.name);
        varStr.AppendIn(";");

        shader.AppendIn(varStr);
    }

    shader.AppendIn("\n");
    return shader;
}

string WriteInVariables(shader: string, vars: Array<Variable>, 
                         namePrefix: string = "", locationOffset: uint32 = 0)
{
    if (!vars.count) return shader;

    for (location .. vars.count)
    {
        var := vars[location];
        
        locationStr := UIntToString(location + locationOffset);
        typeStr := VariableDefToTypeName(var.def);
        defer {
            delete locationStr;
            delete varStr;
        }

        varStr := layoutVarStart.Copy();
        varStr.AppendIn(locationStr);
        varStr.AppendIn(varIn);
        varStr.AppendIn(typeStr);
        varStr.AppendIn(" ");
        varStr.AppendIn(namePrefix);
        varStr.AppendIn(var.name);
        varStr.AppendIn(";");

        shader.AppendIn(varStr);
    }

    shader.AppendIn("\n");
    return shader;
}

string WriteTextures(shader: string, textures: Array<TextureDefinition>, 
                     set: uint32, writeDefines: bool = true)
{
    if (!textures.count) return shader;

    textureArraySetStr := UIntToString(set);
    textureIndexSetStr := UIntToString(set + 1);
    defer delete textureIndexSetStr;
    defer delete textureArraySetStr;

    // Sampler array
    shader.AppendIn(layoutSetStart);
    shader.AppendIn(textureArraySetStr);
    shader.AppendIn(", binding = 0) uniform sampler samplers[];\n");

    // Texture array
    shader.AppendIn(layoutSetStart);
    shader.AppendIn(textureArraySetStr);
    shader.AppendIn(", binding = 1) uniform texture2D textures[];\n");

    shader.AppendIn(layoutSetStart);
    shader.AppendIn(textureIndexSetStr);
    shader.AppendIn(variableBinding);
    shader.AppendIn("TextureSet");
    shader.AppendIn(textureIndexSetStr);
    shader.AppendIn("\n{\n");

    for (texture in textures)
    {
        shader.AppendIn("\tuint ");
        shader.AppendIn(texture.name);
        shader.AppendIn("Index;\n");

        shader.AppendIn("\tuint ");
        shader.AppendIn(texture.name);
        shader.AppendIn("SamplerIndex;\n");
    }
    shader.AppendIn("} textureSet");
    shader.AppendIn(textureIndexSetStr);
    shader.AppendIn(";\n");

    if (writeDefines)
    {
        for (texture in textures)
        {
            shader.AppendIn("#define ");
            shader.AppendIn(texture.name);
            shader.AppendIn(" sampler2D(textures[nonuniformEXT(textureSet");
            shader.AppendIn(textureIndexSetStr);
            shader.AppendIn(".");
            shader.AppendIn(texture.name);
            shader.AppendIn("Index)], samplers[nonuniformEXT(textureSet");
            shader.AppendIn(textureIndexSetStr);
            shader.AppendIn(".");
            shader.AppendIn(texture.name);
            shader.AppendIn("SamplerIndex)])");
            shader.AppendIn("\n");
        }
    }

    return shader;
}

string WriteVertexAttributes(shader: string, vars: Array<Variable>)
{
    for (location .. vars.count)
    {
        var := vars[location];
        locationStr := UIntToString(location);
        typeStr := VariableDefToTypeName(var.def);

        varStr := layoutVarStart.Copy();
        varStr.AppendIn(locationStr);
        varStr.AppendIn(varIn);
        varStr.AppendIn(typeStr);
        varStr.AppendIn(" ");
        varStr.AppendIn(var.name);
        varStr.AppendIn(";");

        shader.AppendIn(varStr);

        delete typeStr;
        delete locationStr;
        delete varStr;
    }
    
    shader.AppendIn("\n");
    return shader;
}

string WriteVertexShaderOutAssignments(shared: Array<Variable>, outPrefix: string)
{
    assignments := string("\n").Copy();

    for (var in shared)
    {
        name := var.name;
        assignments.AppendIn("\t");
        assignments.AppendIn(outPrefix);
        assignments.AppendIn(name);
        assignments.AppendIn(" = ");
        assignments.AppendIn(name);
        assignments.AppendIn(";\n");
    }

    return assignments;
}

vertexShaderStart := `
#version 460
#pragma shader_stage(vertex)

layout(set = 0, binding = 0) uniform SceneUBO
{
    mat4 view;
    mat4 proj;
    vec2 screenSize;
} scene;

layout(push_constant) uniform Model 
{
    mat4 model;
} model;
`;

shaderMainStart := `
void main() 
{
`

string WriteVertexShader(assetDef: AssetDef)
{
    vertexStage := assetDef.vertex;
    vertexShader := vertexShaderStart.Copy();

    vertexShader = WriteVertexAttributes(vertexShader, vertexStage.attributes);
    vertexShader = WriteVariableSets(vertexShader, vertexStage.variables, 1);
    vertexShader = WriteOutVariables(vertexShader, vertexStage.out);

    outPrefix := "out";
    sharedVars := Array<Variable>();
    defer sharedVars.Free();
    for (using in assetDef.fragment.using)
    {
        var := FindVariableByName(vertexStage.attributes, using);
        assert var, "WriteVertexShader fragment shader is using a variable not found in vertex attributes";

        sharedVars.Add(var~);
    }

    vertexShader = WriteOutVariables(vertexShader, sharedVars, outPrefix, vertexStage.out.count);

    functions := WriteShaderNodes(vertexStage.functions);
    defer delete functions;
    vertexShader.AppendIn(functions);

    code := WriteShaderNodes(vertexStage.nodes);
    defer delete code;

    outAssignments := WriteVertexShaderOutAssignments(sharedVars, outPrefix);
    defer delete outAssignments;

    vertexShader.AppendIn(shaderMainStart);
    vertexShader.AppendIn(outAssignments);
    vertexShader.AppendIn(code);
    vertexShader.AppendIn("}");

    return vertexShader;
}

fragmentShaderStart := `
#version 460
#pragma shader_stage(fragment)
#extension GL_EXT_nonuniform_qualifier : require
`

fragmentLightCullDecls := `
struct ClusterLight {
    vec4 positionRadius;
    vec4 colorIntensity;
    uint kind;   // 0 = directional, 1 = point
};

layout(std430, set = 0, binding = 1) readonly buffer ClusterLights {
    ClusterLight clusterLights[];
};

layout(std430, set = 0, binding = 2) readonly buffer ClusterLightGrid {
    uvec2 lightGrid[];
};

layout(std430, set = 0, binding = 3) readonly buffer ClusterLightIndices {
    uint lightIndices[];
};

layout(std430, set = 0, binding = 4) readonly buffer ClusterInfo {
    mat4 invProj;
    mat4 invView;
    vec4 screenAndTile;   // xy = screen px, zw = tile px
    uvec4 clusterDims;    // xyz = grid dims
    vec4 zParams;         // x = near, y = far
} clusterInfo;
`

string WriteFragmentShader(assetDef: AssetDef)
{
    fragmentStage := assetDef.fragment;
    fragmentShader := fragmentShaderStart.Copy();

    if (assetDef.flags & AssetDefFlags.UseLightCulling)
    {
        fragmentShader.AppendIn(fragmentLightCullDecls);
    }
    
    fragmentShader = WriteVariableSets(fragmentShader, fragmentStage.variables, assetDef.vertex.variables.sets.count + 1);
    fragmentShader = WriteTextures(
        fragmentShader,
        fragmentStage.textures,
        assetDef.GetBindlessTextureSetIndex()
    );

    inVars := Array<Variable>();
    defer inVars.Free();
    for (using in fragmentStage.using)
    {
        var := FindVariableByName(assetDef.vertex.attributes, using);
        assert var, "WriteFragmentShader fragment shader is using a variable not found in vertex attributes";

        inVars.Add(var~);
    }

    fragmentShader = WriteInVariables(fragmentShader, inVars);
    fragmentShader = WriteOutVariables(fragmentShader, fragmentStage.out);

    functions := WriteShaderNodes(fragmentStage.functions);
    defer delete functions;
    fragmentShader.AppendIn(functions);

    code := WriteShaderNodes(fragmentStage.nodes);
    defer delete code;

    fragmentShader.AppendIn(shaderMainStart);
    fragmentShader.AppendIn(code);
    fragmentShader.AppendIn("}");

    return fragmentShader;
}

bool CompileVertexShader(assetDef: AssetDef, compiler: ShaderCompiler)
{
    vertexShaderSource := WriteVertexShader(assetDef);
    // log "VERTEX SHADER", vertexShaderSource;
    spirv := CompileShader(vertexShaderSource, compiler, assetDef.name);
    assetDef.vertex.compiled = spirv;
    return spirv.count > 0;
}

bool CompileFragmentShader(assetDef: AssetDef, compiler: ShaderCompiler)
{
    fragmentShaderSource := WriteFragmentShader(assetDef);
    // log "FRAGMENT SHADER", fragmentShaderSource;
    spirv := CompileShader(fragmentShaderSource, compiler, assetDef.name);
    assetDef.fragment.compiled = spirv;
    return spirv.count > 0;
}

CompileShadersForAssetDef(assetDef: AssetDef, compiler: ShaderCompiler)
{
    success := true;
    success = success & CompileVertexShader(assetDef, compiler);
    success = success & CompileFragmentShader(assetDef, compiler);

    assert success, "Asset Definition Compilition FAILED";
    log "Compiled Asset Definition", assetDef.name;
}