package Render

import Vec
import Common

enum AlphaMode: ubyte
{
	Opaque,
	Mask,
	Blend
}

enum CullModeFlags: ubyte
{
	None = 0,
	Front = 1 << 0,
	Back = 1 << 1,
	Both = CullModeFlags.Front | CullModeFlags.Back
}

enum PolygonMode: ubyte
{
	Fill,
	Line,
	Point
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

	color := ubyte(-1),
	normal := ubyte(-1),
	metallicRoughness := ubyte(-1),
	occlusion := ubyte(-1),
	emissive := ubyte(-1),

	alphaMode: AlphaMode = AlphaMode.Opaque,
	cullMode: CullModeFlags = CullModeFlags.Back,
	polygonMode: PolygonMode = PolygonMode.Fill
}

Material::delete
{
	delete this.maps;
}