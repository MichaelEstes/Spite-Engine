package RenderAssetDef

import HandleSet

state AssetDefHandle
{
    handle: uint32
}

state RenderAssetDefRegistry
{
    assetDefs := HandleSet<AssetDef>(),
    assetDefNameToHandle := Map<string, AssetDefHandle>()
}

assetDefRegistry := RenderAssetDefRegistry();

InitializeRenderAssetDefs()
{
    assetDefs := ParseRenderAssetDefs();
    defer delete assetDefs;

    compiler := InitShaderCompiler();
    defer delete compiler;

    for (assetDef in assetDefs.Values())
    {
        assetDef.Compile(compiler);
        handleValue := assetDefRegistry.assetDefs.GetNext();
        handleValue.value~ = assetDef;
        assetDefRegistry.assetDefNameToHandle.Insert(
            assetDef.name, 
            handleValue.handle as AssetDefHandle
        );
    }
}