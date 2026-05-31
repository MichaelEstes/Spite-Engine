package RenderAssetDef

import OS
import JSON

VariableType ParseVariableType(varName: string)
{
    if (varName == "bool")                  return VariableType.Bool;
    else if (varName == "float")            return VariableType.Float;
    else if (varName == "int")              return VariableType.Int;
    else if (varName == "uint")             return VariableType.Uint;
    else if (varName == "bvec2")            return VariableType.BVec2;
    else if (varName == "bvec3")            return VariableType.BVec3;
    else if (varName == "bvec4")            return VariableType.BVec4;
    else if (varName == "vec2")             return VariableType.FVec2;
    else if (varName == "vec3")             return VariableType.FVec3;
    else if (varName == "vec4")             return VariableType.FVec4;
    else if (varName == "ivec2")            return VariableType.IVec2;
    else if (varName == "ivec3")            return VariableType.IVec3;
    else if (varName == "ivec4")            return VariableType.IVec4;
    else if (varName == "uvec2")            return VariableType.UVec2;
    else if (varName == "uvec3")            return VariableType.UVec3;
    else if (varName == "uvec4")            return VariableType.UVec4;
    else if (varName == "mat3")             return VariableType.Mat3;
    else if (varName == "mat4")             return VariableType.Mat4;
    return VariableType.Float;
}

TextureType ParseTextureType(textureName: string)
{
    if (textureName == "sampler2D")             return TextureType.Sampler2D;
    else if (textureName == "sampler2DArray")   return TextureType.Sampler2DArray;
    else if (textureName == "samplerCubemap")   return TextureType.SamplerCubemap;
    return TextureType.Sampler2D;
}

VariablePrecision ParseVariablePrecision(name: string)
{
    if (name == "low")      return VariablePrecision.Low;
    else if (name == "medium")  return VariablePrecision.Medium;
    else if (name == "high")    return VariablePrecision.High;
    return VariablePrecision.Default;
}

SamplerFormat ParseSamplerFormat(name: string)
{
    if (name == "int") return SamplerFormat.Int;
    return SamplerFormat.Float;
}

AlphaMode ParseAlphaMode(name: string)
{
    if (name == "mask")         return AlphaMode.Mask;
    else if (name == "blend")   return AlphaMode.Blend;
    return AlphaMode.Opaque;
}

CullModeFlags ParseCullMode(name: string)
{
    if (name == "front")        return CullModeFlags.Front;
    else if (name == "back")    return CullModeFlags.Back;
    else if (name == "both")    return CullModeFlags.Both;
    return CullModeFlags.None;
}

PolygonMode ParsePolygonMode(name: string)
{
    if (name == "line")         return PolygonMode.Line;
    else if (name == "point")   return PolygonMode.Point;
    return PolygonMode.Fill;
}

Value ParseVariableDefault(kind: VariableType, jsonValue: *JSONValue)
{
    val := Value();
    switch (kind)
    {
        case (VariableType.Bool)   val.val.b = jsonValue.Boolean().value;
        case (VariableType.Float)  val.val.f = jsonValue.Number().value.f;
        case (VariableType.Int)    val.val.i = int32(jsonValue.Number().value.i);
        case (VariableType.Uint)   val.val.u = uint32(jsonValue.Number().value.i);
        case (VariableType.BVec2)
        {
            arr := jsonValue.Array();
            val.val.bVec2[0] = arr.GetValue(0).Boolean().value;
            val.val.bVec2[1] = arr.GetValue(1).Boolean().value;
        }
        case (VariableType.BVec3)
        {
            arr := jsonValue.Array();
            val.val.bVec3[0] = arr.GetValue(0).Boolean().value;
            val.val.bVec3[1] = arr.GetValue(1).Boolean().value;
            val.val.bVec3[2] = arr.GetValue(2).Boolean().value;
        }
        case (VariableType.BVec4)
        {
            arr := jsonValue.Array();
            val.val.bVec4[0] = arr.GetValue(0).Boolean().value;
            val.val.bVec4[1] = arr.GetValue(1).Boolean().value;
            val.val.bVec4[2] = arr.GetValue(2).Boolean().value;
            val.val.bVec4[3] = arr.GetValue(3).Boolean().value;
        }
        case (VariableType.FVec2)
        {
            arr := jsonValue.Array();
            val.val.fVec2[0] = arr.GetValue(0).Number().value.f;
            val.val.fVec2[1] = arr.GetValue(1).Number().value.f;
        }
        case (VariableType.FVec3)
        {
            arr := jsonValue.Array();
            val.val.fVec3[0] = arr.GetValue(0).Number().value.f;
            val.val.fVec3[1] = arr.GetValue(1).Number().value.f;
            val.val.fVec3[2] = arr.GetValue(2).Number().value.f;
        }
        case (VariableType.FVec4)
        {
            arr := jsonValue.Array();
            val.val.fVec4[0] = arr.GetValue(0).Number().value.f;
            val.val.fVec4[1] = arr.GetValue(1).Number().value.f;
            val.val.fVec4[2] = arr.GetValue(2).Number().value.f;
            val.val.fVec4[3] = arr.GetValue(3).Number().value.f;
        }
        case (VariableType.IVec2)
        {
            arr := jsonValue.Array();
            val.val.iVec2[0] = int32(arr.GetValue(0).Number().value.i);
            val.val.iVec2[1] = int32(arr.GetValue(1).Number().value.i);
        }
        case (VariableType.IVec3)
        {
            arr := jsonValue.Array();
            val.val.iVec3[0] = int32(arr.GetValue(0).Number().value.i);
            val.val.iVec3[1] = int32(arr.GetValue(1).Number().value.i);
            val.val.iVec3[2] = int32(arr.GetValue(2).Number().value.i);
        }
        case (VariableType.IVec4)
        {
            arr := jsonValue.Array();
            val.val.iVec4[0] = int32(arr.GetValue(0).Number().value.i);
            val.val.iVec4[1] = int32(arr.GetValue(1).Number().value.i);
            val.val.iVec4[2] = int32(arr.GetValue(2).Number().value.i);
            val.val.iVec4[3] = int32(arr.GetValue(3).Number().value.i);
        }
        case (VariableType.UVec2)
        {
            arr := jsonValue.Array();
            val.val.uVec2[0] = uint32(arr.GetValue(0).Number().value.i);
            val.val.uVec2[1] = uint32(arr.GetValue(1).Number().value.i);
        }
        case (VariableType.UVec3)
        {
            arr := jsonValue.Array();
            val.val.uVec3[0] = uint32(arr.GetValue(0).Number().value.i);
            val.val.uVec3[1] = uint32(arr.GetValue(1).Number().value.i);
            val.val.uVec3[2] = uint32(arr.GetValue(2).Number().value.i);
        }
        case (VariableType.UVec4)
        {
            arr := jsonValue.Array();
            val.val.uVec4[0] = uint32(arr.GetValue(0).Number().value.i);
            val.val.uVec4[1] = uint32(arr.GetValue(1).Number().value.i);
            val.val.uVec4[2] = uint32(arr.GetValue(2).Number().value.i);
            val.val.uVec4[3] = uint32(arr.GetValue(3).Number().value.i);
        }
        case (VariableType.Mat3)
        {
            arr := jsonValue.Array();
            val.val.mat3[0][0] = arr.GetValue(0).Array().GetValue(0).Number().value.f;
            val.val.mat3[0][1] = arr.GetValue(0).Array().GetValue(1).Number().value.f;
            val.val.mat3[0][2] = arr.GetValue(0).Array().GetValue(2).Number().value.f;
            val.val.mat3[1][0] = arr.GetValue(1).Array().GetValue(0).Number().value.f;
            val.val.mat3[1][1] = arr.GetValue(1).Array().GetValue(1).Number().value.f;
            val.val.mat3[1][2] = arr.GetValue(1).Array().GetValue(2).Number().value.f;
            val.val.mat3[2][0] = arr.GetValue(2).Array().GetValue(0).Number().value.f;
            val.val.mat3[2][1] = arr.GetValue(2).Array().GetValue(1).Number().value.f;
            val.val.mat3[2][2] = arr.GetValue(2).Array().GetValue(2).Number().value.f;
        }
        case (VariableType.Mat4)
        {
            arr := jsonValue.Array();
            val.val.mat4[0][0] = arr.GetValue(0).Array().GetValue(0).Number().value.f;
            val.val.mat4[0][1] = arr.GetValue(0).Array().GetValue(1).Number().value.f;
            val.val.mat4[0][2] = arr.GetValue(0).Array().GetValue(2).Number().value.f;
            val.val.mat4[0][3] = arr.GetValue(0).Array().GetValue(3).Number().value.f;
            val.val.mat4[1][0] = arr.GetValue(1).Array().GetValue(0).Number().value.f;
            val.val.mat4[1][1] = arr.GetValue(1).Array().GetValue(1).Number().value.f;
            val.val.mat4[1][2] = arr.GetValue(1).Array().GetValue(2).Number().value.f;
            val.val.mat4[1][3] = arr.GetValue(1).Array().GetValue(3).Number().value.f;
            val.val.mat4[2][0] = arr.GetValue(2).Array().GetValue(0).Number().value.f;
            val.val.mat4[2][1] = arr.GetValue(2).Array().GetValue(1).Number().value.f;
            val.val.mat4[2][2] = arr.GetValue(2).Array().GetValue(2).Number().value.f;
            val.val.mat4[2][3] = arr.GetValue(2).Array().GetValue(3).Number().value.f;
            val.val.mat4[3][0] = arr.GetValue(3).Array().GetValue(0).Number().value.f;
            val.val.mat4[3][1] = arr.GetValue(3).Array().GetValue(1).Number().value.f;
            val.val.mat4[3][2] = arr.GetValue(3).Array().GetValue(2).Number().value.f;
            val.val.mat4[3][3] = arr.GetValue(3).Array().GetValue(3).Number().value.f;
        }
    }
    return val;
}

VariableDefinition ParseVariableDefinition(value: *JSONValue)
{
    varDef := VariableDefinition();
    varDef.precision = VariablePrecision.Default;

    str := value.String();
    if (str)
    {
        varDef.kind = ParseVariableType(str.value);
    }
    else
    {
        varObj := value.Object();
        assert varObj != null, "Variable definitions need to be either a string or an object";

        typeValue := varObj.GetMember("type");
        assert typeValue != null, "Variable definition object must have a 'type' field";
        varDef.kind = ParseVariableType(typeValue.String().value);

        precisionValue := varObj.GetMember("precision");
        if (precisionValue)
            varDef.precision = ParseVariablePrecision(precisionValue.String().value);

        defaultValue := varObj.GetMember("default");
        if (defaultValue)
            varDef.defaultValue = ParseVariableDefault(varDef.kind, defaultValue);
    }
    return varDef;
}

TextureDefinition ParseTextureDefinition(name: string, value: *JSONValue)
{
    textureDef := TextureDefinition();
    textureDef.name = name.Copy();
    textureDef.precision = VariablePrecision.Default;

    str := value.String();
    if (str)
    {
        textureDef.kind = ParseTextureType(str.value);
    }
    else
    {
        textureObj := value.Object();
        assert textureObj != null, "Texture definitions need to be either a string or an object";

        typeValue := textureObj.GetMember("type");
        assert typeValue != null, "Texture definition object must have a 'type' field";
        textureDef.kind = ParseTextureType(typeValue.String().value);

        precisionValue := textureObj.GetMember("precision");
        if (precisionValue)
            textureDef.precision = ParseVariablePrecision(precisionValue.String().value);

        formatValue := textureObj.GetMember("format");
        if (formatValue)
            textureDef.format = ParseSamplerFormat(formatValue.String().value);

        multisampleValue := textureObj.GetMember("multisample");
        if (multisampleValue)
            textureDef.multisample = multisampleValue.Boolean().value;

        filterableValue := textureObj.GetMember("filterable");
        if (filterableValue)
            textureDef.filterable = filterableValue.Boolean().value;
    }

    return textureDef;
}

Variable ParseVariable(name: string, value: *JSONValue)
{
    var := Variable();
    var.name = name.Copy();
    var.def = ParseVariableDefinition(value);
    return var;
}

ParseVariables(obj: *JSONObject, vars: Array<Variable>)
{
    for (kv in obj.members)
    {
        name := kv.key~;
        varValue := kv.value~;
        vars.Add(ParseVariable(name, varValue));
    }
}

ParseVariableSets(set: *JSONValue, variableSets: VariableSets)
{
    arr := set.Array();
    if (arr)
    {
        for (val in arr.values)
        {
            varObj := val.Object();
            assert varObj, "Expected object in variable set array";
            varSet := Array<Variable>();
            ParseVariables(varObj, varSet);
            variableSets.sets.Add(varSet);
        }
    }
    else 
    {
        obj := set.Object();
        assert obj, "Variable sets needs to be an array or an object";
        varSet := Array<Variable>();
        ParseVariables(obj, varSet);
        variableSets.sets.Add(varSet);
    }
}

ParseTextures(obj: *JSONObject, textures: Array<TextureDefinition>)
{
    for (kv in obj.members)
    {
        name := kv.key~;
        textureValue := kv.value~;
        textures.Add(ParseTextureDefinition(name, textureValue));
    }
}

ParseShaderNode(obj: *JSONObject, shaderNodes: Array<ShaderNode>)
{
    shaderNode := ShaderNode();

    nameValue := obj.GetMember("name");
    assert nameValue != null, "Shader node must have a 'name' field";
    nameStr := nameValue.String();
    assert nameStr != null, "Shader node 'name' field must be a string";
    shaderNode.name = nameStr.value.Copy();

    codeValue := obj.GetMember("code");
    assert codeValue != null, "Shader node must have a 'code' field";
    codeStr := codeValue.String();
    assert codeStr != null, "Shader node 'code' field must be a string";
    shaderNode.code = codeStr.value.Copy();

    afterValue := obj.GetMember("after");
    if (afterValue)
    {
        afterStr := afterValue.String();
        assert afterStr != null, "Shader node 'after' field must be a string";
        shaderNode.after = afterStr.value.Copy();
    }

    beforeValue := obj.GetMember("before");
    if (beforeValue)
    {
        beforeStr := beforeValue.String();
        assert beforeStr != null, "Shader node 'before' field must be a string";
        shaderNode.before = beforeStr.value.Copy();
    }

    shaderNodes.Add(shaderNode);
}

ParseShaderNodes(value: *JSONValue, shaderNodes: Array<ShaderNode>)
{
    nodesArr := value.Array();
    assert nodesArr, "Shader nodes value must be an array";

    for (nodeValue in nodesArr.values)
    {
        nodeObj := nodeValue.Object();
        assert nodeObj, "Values in shader nodes array must be objects";
        ParseShaderNode(nodeObj, shaderNodes);
    }
}

ParseRenderAssetDef(assetDef: AssetDef, assetDefObj: *JSONObject)
{
    name := assetDefObj.GetMember("name").String().value.Copy();
    log "Parsing asset definition: ", name;

    assetDef.name = name;

    vertexValue := assetDefObj.GetMember("vertex");
    if (vertexValue)
    {
        vertexObj := vertexValue.Object();
        attributesValue := vertexObj.GetMember("attributes");
        if (attributesValue)
        {
            attributesObj := attributesValue.Object();
            if (attributesObj)
            {
                ParseVariables(attributesObj, assetDef.vertex.attributes);
            }
        }

        variablesValue := vertexObj.GetMember("variables");
        if (variablesValue)
        {
            ParseVariableSets(variablesValue, assetDef.vertex.variables);
        }

        nodesValue := vertexObj.GetMember("nodes");
        if (nodesValue)
        {
            ParseShaderNodes(nodesValue, assetDef.vertex.nodes);
        }

        outValue := vertexObj.GetMember("out");
        if (outValue)
        {
            outObj := outValue.Object();
            if (outValue)
            {
                ParseVariables(outObj, assetDef.vertex.out);
            }
        }
    }

    fragmentValue := assetDefObj.GetMember("fragment");
    if (fragmentValue)
    {
        fragmentObj := fragmentValue.Object();
        texturesValue := fragmentObj.GetMember("textures");
        if (texturesValue)
        {
            texturesObj := texturesValue.Object();
            if (texturesObj)
            {
                ParseTextures(texturesObj, assetDef.fragment.textures);
            }
        }

        variablesValue := fragmentObj.GetMember("variables");
        if (variablesValue)
        {
            ParseVariableSets(variablesValue, assetDef.fragment.variables);
        }

        usingValue := fragmentObj.GetMember("using");
        if (usingValue)
        {
            usingArr := usingValue.Array();
            assert usingArr, "using value must be an array";
            for (val in usingArr.values)
            {
                usingStr := val.String();
                assert usingStr, "Values in using array must be strings";
                assetDef.fragment.using.Add(usingStr.value.Copy());
            }
        }

        outValue := fragmentObj.GetMember("out");
        if (outValue)
        {
            outObj := outValue.Object();
            if (outValue)
            {
                ParseVariables(outObj, assetDef.fragment.out);
            }
        }

        nodesValue := fragmentObj.GetMember("nodes");
        if (nodesValue)
        {
            ParseShaderNodes(nodesValue, assetDef.fragment.nodes);
        }

        alphaModeValue := fragmentObj.GetMember("alphaMode");
        if (alphaModeValue)
        {
            alphaModeStr := alphaModeValue.String();
            assert alphaModeStr, "fragment alphaMode must be a string";
            alphaMode := alphaModeStr.value;
            assetDef.fragment.alphaMode = ParseAlphaMode(alphaMode);
        }

        cullModeValue := fragmentObj.GetMember("cullMode");
        if (cullModeValue)
        {
            cullModeStr := cullModeValue.String();
            assert cullModeStr, "fragment cullMode must be a string";
            cullMode := cullModeStr.value;
            assetDef.fragment.cullMode = ParseCullMode(cullMode);
        }

        polygonModeValue := fragmentObj.GetMember("polygonMode");
        if (polygonModeValue)
        {
            polygonModeStr := polygonModeValue.String();
            assert polygonModeStr, "fragment polygonMode must be a string";
            polygonMode := polygonModeStr.value;
            assetDef.fragment.polygonMode = ParsePolygonMode(polygonMode);
        }
    }
}

ParseRenderAssetDefFile(
    assetDefJSON: JSON, 
    assetDefs: Map<string, AssetDef>,
    assetDefsJSON: Map<string, JSON>
)
{
    assetDef := AssetDef();

    assetDefRoot := assetDefJSON.root;
    assetDefObj := assetDefRoot.Object();

    importVal := assetDefObj.GetMember("imports");
    if (importVal)
    {
        importStr := importVal.String();
        assert importStr, "Value of imports must be a string";
        importName := importStr.value;

        log "Importing asset def: ", importName;

        if (assetDefs.Has(importName))
        {
            importFrom := assetDefs.Find(importName);
            assetDef = importFrom.Clone();
        }
        else
        {
            toImportJSON := assetDefsJSON.Find(importName)~;
            ParseRenderAssetDefFile(toImportJSON, assetDefs, assetDefsJSON);
            importFrom := assetDefs.Find(importName);
            assetDef = importFrom.Clone();
        }
    }
    
    ParseRenderAssetDef(assetDef, assetDefObj);
    assetDefs.Insert(assetDef.name, assetDef);
}

Map<string, AssetDef> ParseRenderAssetDefs()
{
    log "Parsing Asset Defs";

    renderAssetPath := "./Resource/RenderAssets";

    assetDefs := Map<string, AssetDef>();
    assetDefsJSON := Map<string, JSON>();
    defer {
        for (kv in assetDefsJSON)
        {
            json := kv.value~;
            delete json;
        }

        delete assetDefsJSON;
    }

    files := OS.GetFilesInDirectory(renderAssetPath);
    defer {
        for (file in files) delete file
        delete files;
    }
    log "Asset Def Files: ", files;

    for (file in files)
    {
        assetFilePath := OS.JoinPaths([renderAssetPath, file]);
        defer delete assetFilePath;

        log "Parsing render asset file: ", assetFilePath;
        assetDefJSON := ParseJSONFile(assetFilePath);

        assetDefRoot := assetDefJSON.root;
        assert assetDefRoot != null, "Failed to parse asset definition file" + assetFilePath;

        assetDefObj := assetDefRoot.Object();
        assert assetDefRoot != null, "Asset definition file wasn't an object" + assetFilePath;

        nameVal := assetDefObj.GetMember("name");
        assert nameVal != null, "Asset definitions must declare a name" + assetFilePath;

        nameStr := nameVal.String();
        assert nameStr != null, "Asset definition name must be a string" + assetFilePath;

        name := nameStr.value;
        assert !assetDefsJSON.Has(name), "Each asset definition must have a unique name";
        assetDefsJSON.Insert(name, assetDefJSON);
    }

    for (kv in assetDefsJSON)
    {
        name := kv.key~;
        json := kv.value~;

        if (assetDefs.Has(name)) continue;
        ParseRenderAssetDefFile(json, assetDefs, assetDefsJSON);
    }

    return assetDefs;
}

_ := #compile void 
{
    assetDefs := ParseRenderAssetDefs();

    for (kv in assetDefs)
    {
        assetDef := kv.value~;
        WriteShaderForAssetDef(assetDef);
    }
}
