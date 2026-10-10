package RenderComponents

import RenderAssetDef
import Vec
import Common
import Resource

state TextureMap
{
	texture: Texture,
	offset: Vec2,
	scale: Vec2
}

bool TextureMap::operator::!()
{
	return this.texture.imageHandle.id == 0;
}

state Material
{
	textures: Array<TextureMap>,
	variables: *void,
	
    defHandle: AssetDefHandle,
    
    alphaMode: AlphaMode,
    cullMode: CullModeFlags,
    polygonMode: PolygonMode
}

Material::(defHandle: AssetDefHandle)
{
    this.defHandle = defHandle;
	this.Allocate();
}

Material::delete
{
    delete this.textures;
    FreeFragmentVariableSet(this.defHandle, this.variables);
}

Material::Allocate()
{
    defHandle := this.defHandle;
    this.variables = AllocateFragmentVariableSet(defHandle);

    texCount := GetAssetDefFragmentTextureCount(defHandle);
    this.textures.SizeTo(texCount);
    for (i .. texCount) this.textures.Add(TextureMap());
}

uint32 Material::GetVariableIndex(name: string)
{
    assetDef := GetAssetDefWithHandle(this.defHandle);
    fragment := assetDef.fragment;
    return FindVariableIndexByName(fragment.variables.sets, name);
}

ref VariableDefinition Material::GetVariableDef(index: uint32)
{
    assetDef := GetAssetDefWithHandle(this.defHandle);
    fragment := assetDef.fragment;
    var := fragment.variables.sets[index];
    return var.def;
}

*T Material::GetVariableValue<T>(index: uint32)
{
	assetDef := GetAssetDefWithHandle(this.defHandle);
    fragment := assetDef.fragment;
    offset := FindVariableSetOffsetAtIndex(fragment.variables, index);
    return (this.variables + offset) as *T;
}

uint32 Material::SetVariable<T>(name: string, value: T)
{
	index := this.GetVariableIndex(name);
	if (index == uint32(-1)) return index;

	this.GetVariableValue<T>(index)~ = value;
    return index;
}

uint32 Material::GetTextureIndex(name: string)
{
    assetDef := GetAssetDefWithHandle(this.defHandle);
    fragment := assetDef.fragment;
    textures := fragment.textures;
    return FindTextureIndexByName(textures, name);
}

*TextureMap Material::GetTextureValue(index: uint32)
{
    return this.textures[index]@;
}

uint32 Material::SetTexture(name: string, texture: TextureMap)
{
    index := this.GetTextureIndex(name);
	if (index == uint32(-1)) return index;

	this.GetTextureValue(index)~ = texture;
	return index;
}