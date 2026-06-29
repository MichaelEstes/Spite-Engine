package RenderAssetDef

import BlockAllocator
import HandleSet
import SparseSet

state AssetDefHandle
{
    handle: uint32 = uint32(0)
}

state RenderAssetVariableAllocator
{
    vertexAllocator: BlockAllocator,
    fragmentAllocator: BlockAllocator
}

state RenderAssetDefRegistry
{
    assetDefs := HandleSet<AssetDef>(),
    assetDefNameToHandle := Map<string, AssetDefHandle>(),
    assetDefAllocators := SparseSet<RenderAssetVariableAllocator>()
}

assetDefRegistry := RenderAssetDefRegistry();

RenderAssetVariableAllocator CreateAssetDefAllocator(assetDef: AssetDef)
{
    vertexSetSize := assetDef.vertex.variables.GetSetsValueSize();
    fragmentSetSize := assetDef.fragment.variables.GetSetsValueSize();
    itemCount := 128; 
    allocator := RenderAssetVariableAllocator();
    allocator.vertexAllocator = BlockAllocator(
        vertexSetSize * itemCount,
        vertexSetSize
    );
    allocator.fragmentAllocator = BlockAllocator(
        fragmentSetSize * itemCount,
        fragmentSetSize
    );

    return allocator;
}

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

        assetDefAllocator := CreateAssetDefAllocator(assetDef);
        assetDefRegistry.assetDefAllocators.Insert(
            handleValue.handle,
            assetDefAllocator
        );
    }
}

*AssetDef GetAssetDefWithHandle(handle: AssetDefHandle)
{
    return assetDefRegistry.assetDefs[handle.handle];
}

AssetDefHandle AssetDefNameToHandle(name: string)
{
    handlePtr := assetDefRegistry.assetDefNameToHandle.Find(name);
    if (!handlePtr) return AssetDefHandle();
    return handlePtr~;
}

*void AllocateVertexVariableSet(defHandle: AssetDefHandle)
{
    allocator := assetDefRegistry.assetDefAllocators.Get(defHandle.handle);
    mem := allocator.vertexAllocator.Alloc();
    return mem;
}

*void AllocateFragmentVariableSet(defHandle: AssetDefHandle)
{
    allocator := assetDefRegistry.assetDefAllocators.Get(defHandle.handle);
    mem := allocator.fragmentAllocator.Alloc();
    return mem;
}

uint32 GetAssetDefFragmentTextureCount(defHandle: AssetDefHandle)
{
    assetDef := GetAssetDefWithHandle(defHandle);
    fragment := assetDef.fragment;
    return fragment.textures.count;
}

uint32 GetAssetDefVertexAttributeCount(defHandle: AssetDefHandle)
{
    assetDef := GetAssetDefWithHandle(defHandle);
    vertex := assetDef.vertex;
    return vertex.attributes.count;
}