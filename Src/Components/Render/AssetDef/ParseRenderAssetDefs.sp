package RenderAssetDef

import OS
import JSON

renderAssetPath := "./Resource/RenderAssets";

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
    textureDef.name = name;
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
    var.name = name;
    var.def = ParseVariableDefinition(value);
    return var;
}

Array<Variable> ParseVariables(obj: *JSONObject)
{
    vars := Array<Variable>();
    for (kv in obj.members)
    {
        name := kv.key~;
        varValue := kv.value~;
        vars.Add(ParseVariable(name, varValue));
    }

    return vars;
}

VariableSets ParseVariableSets(set: *JSONValue)
{
    variableSets := VariableSets();

    arr := set.Array();
    if (arr)
    {
        for (val in arr.values)
        {
            varObj := val.Object();
            assert varObj, "Expected object in variable set array";
            variableSets.sets.Add(ParseVariables(varObj));
        }
    }
    else 
    {
        obj := set.Object();
        assert obj, "Variable sets needs to be an array or an object";
        variableSets.sets.Add(ParseVariables(obj));
    }

    return variableSets;
}

Array<TextureDefinition> ParseTextures(obj: *JSONObject)
{
    textures := Array<TextureDefinition>();
    for (kv in obj.members)
    {
        name := kv.key~;
        textureValue := kv.value~;
        textures.Add(ParseTextureDefinition(name, textureValue));
    }

    return textures;
}

AssetDef ParseRenderAssetDef(assetDefObj: *JSONObject)
{
    assetDef := AssetDef();
    name := assetDefObj.GetMember("name").String().value;
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
                assetDef.vertex.attributes = ParseVariables(attributesObj);
            }
        }

        variablesValue := vertexObj.GetMember("variables");
        if (variablesValue)
        {
            assetDef.vertex.variables = ParseVariableSets(variablesValue);
        }

        outValue := vertexObj.GetMember("out");
        if (outValue)
        {
            outObj := outValue.Object();
            if (outValue)
            {
                assetDef.vertex.out = ParseVariables(outObj);
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
                assetDef.fragment.textures = ParseTextures(texturesObj);
            }
        }

        variablesValue := fragmentObj.GetMember("variables");
        if (variablesValue)
        {
            assetDef.fragment.variables = ParseVariableSets(variablesValue);
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
                assetDef.fragment.using.Add(usingStr.value);
            }
        }

        outValue := fragmentObj.GetMember("out");
        if (outValue)
        {
            outObj := outValue.Object();
            if (outValue)
            {
                assetDef.fragment.out = ParseVariables(outObj);
            }
        }
    }

    return assetDef;
}

AssetDef ParseRenderAssetDefFile(file: string)
{
    assetFilePath := OS.JoinPaths([renderAssetPath, file]);
    defer delete assetFilePath;

    log "Parsing render asset file: ", assetFilePath;
    assetDefJSON := ParseJSONFile(assetFilePath);

    assetDefRoot := assetDefJSON.root;
    assert assetDefRoot != null, "Failed to parse asset definition file" + assetFilePath;

    assetDefObj := assetDefRoot.Object();
    assert assetDefRoot != null, "Asset definition file wasn't an object" + assetFilePath;

    return ParseRenderAssetDef(assetDefObj);
}

Map<string, AssetDef> ParseRenderAssetDefs()
{
    log "Parsing Asset Defs";

    assetDefs := Map<string, AssetDef>();
    files := OS.GetFilesInDirectory(renderAssetPath);
    log "Asset Def Files: ", files;
    defer {
        for (file in files) delete file
        delete files;
    }

    for (file in files)
    {
        assetDef := ParseRenderAssetDefFile(file);
        assetDefs.Insert(assetDef.name, assetDef);
    }

    return assetDefs;
}

_ := #compile void 
{
    ParseRenderAssetDefs();
}
