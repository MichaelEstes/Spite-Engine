package RenderComponents

import RenderAssetDef
import Vec
import Common

state MaterialVariableUpdate
{
    material: *Material,
    index: uint32
}

state MaterialTextureUpdate
{
    material: *Material,
    index: uint32
}

MaterialVariableUpdateEvent := RegisterEvent<MaterialVariableUpdate>();
MaterialTextureUpdateEvent := RegisterEvent<MaterialTextureUpdate>();

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

    gpuResourceID: uint32,

    alphaMode: AlphaMode,
    cullMode: CullModeFlags,
    polygonMode: PolygonMode
}

Material::(defHandle: AssetDefHandle)
{
    this.defHandle = defHandle;
	this.variables = AllocateFragmentVariableSet(defHandle);

    texCount := GetAssetDefFragmentTextureCount(defHandle);
    this.textures.SizeTo(texCount);
    for (i .. texCount) this.textures.Add(TextureMap());
}

Material::delete
{
    delete this.textures;
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

bool Material::SetVariable<T>(name: string, value: T, update: bool = true)
{
	index := this.GetVariableIndex(name);
	if (index == uint32(-1)) return false;

	this.GetVariableValue<T>(index)~ = value;
	if (update) this.UpdatedVariableSet(index);
    return true;
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

bool Material::SetTexture(name: string, texture: TextureMap, update: bool = true)
{
    index := this.GetTextureIndex(name);
	if (index == uint32(-1)) return false;

	this.GetTextureValue(index)~ = texture;
	if (update) this.UpdatedTexture(index);
	return true;
}

Material::UpdatedVariableSet(index: uint32)
{
    event := MaterialVariableUpdate();
    event.material = this@;
    event.index = index;
    ECS.instance.events.Emit<MaterialVariableUpdate>(MaterialVariableUpdateEvent, event);
}

Material::UpdatedTexture(index: uint32)
{
	event := MaterialTextureUpdate();
    event.material = this@;
    event.index = index;
    ECS.instance.events.Emit<MaterialVariableUpdate>(MaterialTextureUpdateEvent, event);
}