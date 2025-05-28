package Render

import Vec
import Color

enum AlphaMode: uint16
{
	Opaque,
	Mask,
	Blend
}

state TextureMap
{
	texture: Texture,
	offset: Vec2,
	scale: Vec2
}

state Material
{
	maps: Array<TextureMap>,

	baseColor: Color,
	emissiveFactor: Vec3,

	normalScale := float32(1.0),
	metallicFactor := float32(1.0),
	roughnessFactor := float32(1.0),
	occlusionStrength := float32(1.0),
	alphaCutoff := float32(0.5),

	color := int16(-1),
	normal := int16(-1),
	metallicRoughness := int16(-1),
	occlusion := int16(-1),
	emissive := int16(-1),

	doubleSided: bool
}

Material::delete
{
	delete this.maps;
}