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

layoutBufferSetStart := "\nlayout(std430, set = ";
storageBinding := ", binding = 0) readonly buffer ";

layoutVarStart := "\nlayout(location = ";
varIn := ") in "
varOut := ") out "

string WriteVariableSet(shader: string, varSet: VariableSet, structName: string,
                        addressField: string, indexName: string, writeDefines: bool = true)
{
    if (!varSet.sets.count) return shader;

    shader.AppendIn("\nlayout(buffer_reference, std430, buffer_reference_align = 4) readonly buffer ");
    shader.AppendIn(structName);
    shader.AppendIn("\n{\n");

    for (var in varSet.sets)
    {
        typeStr := VariableDefToTypeName(var.def);
        defer delete typeStr;

        shader.AppendIn("\t");
        shader.AppendIn(typeStr);
        shader.AppendIn(" ");
        shader.AppendIn(var.name);
        shader.AppendIn(";\n");
    }

    shader.AppendIn("};\n");

    if (writeDefines)
    {
        for (var in varSet.sets)
        {
            shader.AppendIn("#define ");
            shader.AppendIn(var.name);
            shader.AppendIn(" ");
            shader.AppendIn(structName);
            shader.AppendIn("(PtrArray(pushConstants.");
            shader.AppendIn(addressField);
            shader.AppendIn(").ptrs[");
            shader.AppendIn(indexName);
            shader.AppendIn("]).");
            shader.AppendIn(var.name);
            shader.AppendIn("\n");
        }
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
                     bindlessSet: uint32, writeDefines: bool = true)
{
    if (!textures.count) return shader;

    textureArraySetStr := UIntToString(bindlessSet);
    defer delete textureArraySetStr;

    shader.AppendIn("\nlayout(buffer_reference, std430, buffer_reference_align = 4) readonly buffer MaterialTextureSlotsData\n{\n");

    for (texture in textures)
    {
        shader.AppendIn("\tuint ");
        shader.AppendIn(texture.name);
        shader.AppendIn("Index;\n");

        shader.AppendIn("\tuint ");
        shader.AppendIn(texture.name);
        shader.AppendIn("SamplerIndex;\n");
    }
    shader.AppendIn("};\n");

    // Sampler array
    shader.AppendIn(layoutSetStart);
    shader.AppendIn(textureArraySetStr);
    shader.AppendIn(", binding = 0) uniform sampler samplers[];\n");

    // Texture array
    shader.AppendIn(layoutSetStart);
    shader.AppendIn(textureArraySetStr);
    shader.AppendIn(", binding = 1) uniform texture2D textures[];\n");

    if (writeDefines)
    {
        for (texture in textures)
        {
            shader.AppendIn("#define ");
            shader.AppendIn(texture.name);
            shader.AppendIn(" sampler2D(textures[nonuniformEXT(MaterialTextureSlotsData(PtrArray(pushConstants.materialTextureSlotsAddress).ptrs[drawIndex]).");
            shader.AppendIn(texture.name);
            shader.AppendIn("Index)], samplers[nonuniformEXT(MaterialTextureSlotsData(PtrArray(pushConstants.materialTextureSlotsAddress).ptrs[drawIndex]).");
            shader.AppendIn(texture.name);
            shader.AppendIn("SamplerIndex)])");
            shader.AppendIn("\n");
        }
    }

    return shader;
}

uint32 VariableTypeComponentCount(kind: VariableType)
{
    switch (kind)
    {
        case (VariableType.Float) return 1;
        case (VariableType.FVec2) return 2;
        case (VariableType.FVec3) return 3;
        case (VariableType.FVec4) return 4;
    }

    assert false, "VariableTypeComponentCount unsupported vertex attribute type";
    return 0;
}

string WriteVertexAttributes(shader: string, vars: Array<Variable>, bindlessSet: uint32)
{
    if (!vars.count) return shader;

    bindlessSetStr := UIntToString(bindlessSet);
    defer delete bindlessSetStr;

    shader.AppendIn("\nlayout(buffer_reference, std430, buffer_reference_align = 4) readonly buffer GeometryAttributeSlotsData\n{\n");

    for (var in vars)
    {
        shader.AppendIn("\tuint ");
        shader.AppendIn(var.name);
        shader.AppendIn("Index;\n");

        shader.AppendIn("\tuint ");
        shader.AppendIn(var.name);
        shader.AppendIn("Stride;\n");
    }
    shader.AppendIn("};\n");

    // Vertex buffer array
    shader.AppendIn(layoutBufferSetStart);
    shader.AppendIn(bindlessSetStr);
    shader.AppendIn(", binding = 2) readonly buffer VertexBuffers { float data[]; } vertexBuffers[];\n");

    for (var in vars)
    {
        componentCount := VariableTypeComponentCount(var.def.kind);

        shader.AppendIn("#define ");
        shader.AppendIn(var.name);
        shader.AppendIn(" ");

        if (componentCount > 1)
        {
            typeStr := VariableDefToTypeName(var.def);
            shader.AppendIn(typeStr);
            shader.AppendIn("(");
            delete typeStr;
        }

        for (component .. componentCount)
        {
            if (component) shader.AppendIn(", ");

            componentStr := UIntToString(component);
            shader.AppendIn("vertexBuffers[GeometryAttributeSlotsData(PtrArray(pushConstants.geometryAttributeSlotsAddress).ptrs[gl_InstanceIndex]).");
            shader.AppendIn(var.name);
            shader.AppendIn("Index].data[GeometryAttributeSlotsData(PtrArray(pushConstants.geometryAttributeSlotsAddress).ptrs[gl_InstanceIndex]).");
            shader.AppendIn(var.name);
            shader.AppendIn("Stride * gl_VertexIndex + ");
            shader.AppendIn(componentStr);
            shader.AppendIn("]");
            delete componentStr;
        }

        if (componentCount > 1) shader.AppendIn(")");
        shader.AppendIn("\n");
    }

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
#extension GL_EXT_nonuniform_qualifier : require
#extension GL_EXT_buffer_reference : require
#extension GL_EXT_shader_explicit_arithmetic_types_int64 : require

layout(set = 0, binding = 0) uniform SceneUBO
{
    mat4 view;
    mat4 proj;
    vec2 screenSize;
} scene;

layout(buffer_reference, std430, buffer_reference_align = 16) readonly buffer ModelBuffer
{
    mat4 models[];
};

layout(buffer_reference, std430, buffer_reference_align = 8) readonly buffer PtrArray
{
    uint64_t ptrs[];
};

layout(push_constant) uniform DrawPushConstants
{
    uint64_t modelBufferAddress;
    uint64_t geometryVariablesAddress;
    uint64_t geometryAttributeSlotsAddress;
    uint64_t materialVariablesAddress;
    uint64_t materialTextureSlotsAddress;
} pushConstants;

#define model ModelBuffer(pushConstants.modelBufferAddress).models[gl_InstanceIndex]
`;

shaderMainStart := `
void main() 
{
`

string WriteVertexShader(assetDef: AssetDef)
{
    vertexStage := assetDef.vertex;
    vertexShader := vertexShaderStart.Copy();

    vertexShader = WriteVariableSet(
        vertexShader, vertexStage.variables,
        "GeometryVariablesData", "geometryVariablesAddress", "gl_InstanceIndex"
    );
    vertexShader = WriteVertexAttributes(
        vertexShader,
        vertexStage.attributes,
        assetDef.GetBindlessTextureSetIndex()
    );
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

    drawIndexLocationStr := UIntToString(vertexStage.out.count + sharedVars.count);
    defer delete drawIndexLocationStr;
    vertexShader.AppendIn(layoutVarStart);
    vertexShader.AppendIn(drawIndexLocationStr);
    vertexShader.AppendIn(") flat out uint outDrawIndex;\n");

    functions := WriteShaderNodes(vertexStage.functions);
    defer delete functions;
    vertexShader.AppendIn(functions);

    code := WriteShaderNodes(vertexStage.nodes);
    defer delete code;

    outAssignments := WriteVertexShaderOutAssignments(sharedVars, outPrefix);
    defer delete outAssignments;

    vertexShader.AppendIn(shaderMainStart);
    vertexShader.AppendIn("\toutDrawIndex = gl_InstanceIndex;\n");
    vertexShader.AppendIn(outAssignments);
    vertexShader.AppendIn(code);
    vertexShader.AppendIn("}");

    return vertexShader;
}

fragmentShaderStart := `
#version 460
#pragma shader_stage(fragment)
#extension GL_EXT_nonuniform_qualifier : require
#extension GL_EXT_buffer_reference : require
#extension GL_EXT_shader_explicit_arithmetic_types_int64 : require

layout(buffer_reference, std430, buffer_reference_align = 8) readonly buffer PtrArray
{
    uint64_t ptrs[];
};

layout(push_constant) uniform DrawPushConstants
{
    uint64_t modelBufferAddress;
    uint64_t geometryVariablesAddress;
    uint64_t geometryAttributeSlotsAddress;
    uint64_t materialVariablesAddress;
    uint64_t materialTextureSlotsAddress;
} pushConstants;
`

fragmentLightCullDecls := `
struct ClusterLight {
    vec4 positionRadius;
    vec4 colorIntensity;
    uint kind; // 0 = directional, 1 = point
    uint shadowIndex;
};

layout(std430, set = 0, binding = 2) readonly buffer ClusterLights {
    ClusterLight clusterLights[];
};

layout(std430, set = 0, binding = 3) readonly buffer ClusterLightGrid {
    uvec2 lightGrid[];
};

layout(std430, set = 0, binding = 4) readonly buffer ClusterLightIndices {
    uint lightIndices[];
};

layout(std430, set = 0, binding = 5) readonly buffer ClusterInfo {
    mat4 invProj;
    mat4 invView;
    vec4 screenAndTile; // xy = screen px, zw = tile px
    uvec4 clusterDims; // xyz = grid dims
    vec4 zParams; // x = near, y = far
} clusterInfo;
`

fragmentDirectionalShadowDecls := `
#define SHADOWED_DIRECTIONAL_LIGHTS 4
#define SHADOW_CASCADE_COUNT 4
#define NO_SHADOW_INDEX 0xFFFFFFFFu
#define SHADOW_AMBIENT 0.3
#define SHADOW_BIAS 0.0045
#define SHADOW_PCF_FILTER_SIZE 3

layout(set = 0, binding = 1) uniform sampler2DShadow directionalShadowAtlas;

const mat4 shadowBiasMat = mat4(
    0.5, 0.0, 0.0, 0.0,
    0.0, 0.5, 0.0, 0.0,
    0.0, 0.0, 1.0, 0.0,
    0.5, 0.5, 0.0, 1.0
);

struct DirectionalCascade {
    mat4 view;
    mat4 proj;
    vec4 tile; // xy = atlas uv offset, zw = atlas uv scale
    vec4 params; // x = ortho depth range in world units
};

layout(set = 0, binding = 6) uniform DirectionalShadowData {
    DirectionalCascade cascades[SHADOWED_DIRECTIONAL_LIGHTS * SHADOW_CASCADE_COUNT];
    vec4 cascadeSplits;
    uint shadowedLightCount;
} shadowData;

uint DirectionalShadowCascade(float viewDepth)
{
    uint cascade = 0u;
    for (uint i = 0u; i < uint(SHADOW_CASCADE_COUNT) - 1u; i++)
    {
        if (viewDepth > shadowData.cascadeSplits[i]) cascade = i + 1u;
    }

    return cascade;
}

float SampleShadowMap(vec2 baseUv, float u, float v, vec2 shadowMapSizeInv, vec4 tile, float depth)
{
    vec2 uv = baseUv + vec2(u, v) * shadowMapSizeInv;

    return texture(directionalShadowAtlas, vec3(tile.xy + uv * tile.zw, depth));
}

float DirectionalShadowPCF(vec4 shadowCoord, vec4 tile)
{
    vec2 shadowMapSize = vec2(textureSize(directionalShadowAtlas, 0)) * tile.zw;

    float lightDepth = shadowCoord.z - SHADOW_BIAS;

    vec2 uv = shadowCoord.xy * shadowMapSize; // 1 unit - 1 texel

    vec2 shadowMapSizeInv = 1.0 / shadowMapSize;

    vec2 baseUv;
    baseUv.x = floor(uv.x + 0.5);
    baseUv.y = floor(uv.y + 0.5);

    float s = (uv.x + 0.5 - baseUv.x);
    float t = (uv.y + 0.5 - baseUv.y);

    baseUv -= vec2(0.5, 0.5);
    baseUv *= shadowMapSizeInv;

    float sum = 0.0;

#if SHADOW_PCF_FILTER_SIZE == 2

    return texture(directionalShadowAtlas, vec3(tile.xy + shadowCoord.xy * tile.zw, lightDepth));

#elif SHADOW_PCF_FILTER_SIZE == 3

    float uw0 = (3.0 - 2.0 * s);
    float uw1 = (1.0 + 2.0 * s);

    float u0 = (2.0 - s) / uw0 - 1.0;
    float u1 = s / uw1 + 1.0;

    float vw0 = (3.0 - 2.0 * t);
    float vw1 = (1.0 + 2.0 * t);

    float v0 = (2.0 - t) / vw0 - 1.0;
    float v1 = t / vw1 + 1.0;

    sum += uw0 * vw0 * SampleShadowMap(baseUv, u0, v0, shadowMapSizeInv, tile, lightDepth);
    sum += uw1 * vw0 * SampleShadowMap(baseUv, u1, v0, shadowMapSizeInv, tile, lightDepth);
    sum += uw0 * vw1 * SampleShadowMap(baseUv, u0, v1, shadowMapSizeInv, tile, lightDepth);
    sum += uw1 * vw1 * SampleShadowMap(baseUv, u1, v1, shadowMapSizeInv, tile, lightDepth);

    return sum * (1.0 / 16.0);

#elif SHADOW_PCF_FILTER_SIZE == 5

    float uw0 = (4.0 - 3.0 * s);
    float uw1 = 7.0;
    float uw2 = (1.0 + 3.0 * s);

    float u0 = (3.0 - 2.0 * s) / uw0 - 2.0;
    float u1 = (3.0 + s) / uw1;
    float u2 = s / uw2 + 2.0;

    float vw0 = (4.0 - 3.0 * t);
    float vw1 = 7.0;
    float vw2 = (1.0 + 3.0 * t);

    float v0 = (3.0 - 2.0 * t) / vw0 - 2.0;
    float v1 = (3.0 + t) / vw1;
    float v2 = t / vw2 + 2.0;

    sum += uw0 * vw0 * SampleShadowMap(baseUv, u0, v0, shadowMapSizeInv, tile, lightDepth);
    sum += uw1 * vw0 * SampleShadowMap(baseUv, u1, v0, shadowMapSizeInv, tile, lightDepth);
    sum += uw2 * vw0 * SampleShadowMap(baseUv, u2, v0, shadowMapSizeInv, tile, lightDepth);

    sum += uw0 * vw1 * SampleShadowMap(baseUv, u0, v1, shadowMapSizeInv, tile, lightDepth);
    sum += uw1 * vw1 * SampleShadowMap(baseUv, u1, v1, shadowMapSizeInv, tile, lightDepth);
    sum += uw2 * vw1 * SampleShadowMap(baseUv, u2, v1, shadowMapSizeInv, tile, lightDepth);

    sum += uw0 * vw2 * SampleShadowMap(baseUv, u0, v2, shadowMapSizeInv, tile, lightDepth);
    sum += uw1 * vw2 * SampleShadowMap(baseUv, u1, v2, shadowMapSizeInv, tile, lightDepth);
    sum += uw2 * vw2 * SampleShadowMap(baseUv, u2, v2, shadowMapSizeInv, tile, lightDepth);

    return sum * (1.0 / 144.0);

#else // SHADOW_PCF_FILTER_SIZE == 7

    float uw0 = (5.0 * s - 6.0);
    float uw1 = (11.0 * s - 28.0);
    float uw2 = -(11.0 * s + 17.0);
    float uw3 = -(5.0 * s + 1.0);

    float u0 = (4.0 * s - 5.0) / uw0 - 3.0;
    float u1 = (4.0 * s - 16.0) / uw1 - 1.0;
    float u2 = -(7.0 * s + 5.0) / uw2 + 1.0;
    float u3 = -s / uw3 + 3.0;

    float vw0 = (5.0 * t - 6.0);
    float vw1 = (11.0 * t - 28.0);
    float vw2 = -(11.0 * t + 17.0);
    float vw3 = -(5.0 * t + 1.0);

    float v0 = (4.0 * t - 5.0) / vw0 - 3.0;
    float v1 = (4.0 * t - 16.0) / vw1 - 1.0;
    float v2 = -(7.0 * t + 5.0) / vw2 + 1.0;
    float v3 = -t / vw3 + 3.0;

    sum += uw0 * vw0 * SampleShadowMap(baseUv, u0, v0, shadowMapSizeInv, tile, lightDepth);
    sum += uw1 * vw0 * SampleShadowMap(baseUv, u1, v0, shadowMapSizeInv, tile, lightDepth);
    sum += uw2 * vw0 * SampleShadowMap(baseUv, u2, v0, shadowMapSizeInv, tile, lightDepth);
    sum += uw3 * vw0 * SampleShadowMap(baseUv, u3, v0, shadowMapSizeInv, tile, lightDepth);

    sum += uw0 * vw1 * SampleShadowMap(baseUv, u0, v1, shadowMapSizeInv, tile, lightDepth);
    sum += uw1 * vw1 * SampleShadowMap(baseUv, u1, v1, shadowMapSizeInv, tile, lightDepth);
    sum += uw2 * vw1 * SampleShadowMap(baseUv, u2, v1, shadowMapSizeInv, tile, lightDepth);
    sum += uw3 * vw1 * SampleShadowMap(baseUv, u3, v1, shadowMapSizeInv, tile, lightDepth);

    sum += uw0 * vw2 * SampleShadowMap(baseUv, u0, v2, shadowMapSizeInv, tile, lightDepth);
    sum += uw1 * vw2 * SampleShadowMap(baseUv, u1, v2, shadowMapSizeInv, tile, lightDepth);
    sum += uw2 * vw2 * SampleShadowMap(baseUv, u2, v2, shadowMapSizeInv, tile, lightDepth);
    sum += uw3 * vw2 * SampleShadowMap(baseUv, u3, v2, shadowMapSizeInv, tile, lightDepth);

    sum += uw0 * vw3 * SampleShadowMap(baseUv, u0, v3, shadowMapSizeInv, tile, lightDepth);
    sum += uw1 * vw3 * SampleShadowMap(baseUv, u1, v3, shadowMapSizeInv, tile, lightDepth);
    sum += uw2 * vw3 * SampleShadowMap(baseUv, u2, v3, shadowMapSizeInv, tile, lightDepth);
    sum += uw3 * vw3 * SampleShadowMap(baseUv, u3, v3, shadowMapSizeInv, tile, lightDepth);

    return sum * (1.0 / 2704.0);

#endif
}

float SampleDirectionalShadow(uint shadowIndex, vec3 worldPos, float viewDepth)
{
    if (shadowIndex == NO_SHADOW_INDEX || shadowIndex >= shadowData.shadowedLightCount) return 1.0;

    uint cascade = DirectionalShadowCascade(viewDepth);

    DirectionalCascade shadowCascade = shadowData.cascades[shadowIndex * uint(SHADOW_CASCADE_COUNT) + cascade];

    vec4 shadowCoord = (shadowBiasMat * shadowCascade.proj * shadowCascade.view) * vec4(worldPos, 1.0);

    return mix(SHADOW_AMBIENT, 1.0, DirectionalShadowPCF(shadowCoord / shadowCoord.w, shadowCascade.tile));
}
`

string WriteFragmentShader(assetDef: AssetDef)
{
    fragmentStage := assetDef.fragment;
    fragmentShader := fragmentShaderStart.Copy();

    if (assetDef.flags & AssetDefFlags.UseLighting)
    {
        fragmentShader.AppendIn(fragmentLightCullDecls);
        fragmentShader.AppendIn(fragmentDirectionalShadowDecls);
    }

    fragmentShader = WriteVariableSet(
        fragmentShader, fragmentStage.variables,
        "MaterialVariablesData", "materialVariablesAddress", "drawIndex"
    );
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

    drawIndexLocationStr := UIntToString(inVars.count);
    defer delete drawIndexLocationStr;
    fragmentShader.AppendIn(layoutVarStart);
    fragmentShader.AppendIn(drawIndexLocationStr);
    fragmentShader.AppendIn(") flat in uint drawIndex;\n");

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