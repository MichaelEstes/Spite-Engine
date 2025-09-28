package RenderComponents

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
	color: TextureMap,
	normal: TextureMap,
	metallicRoughness: TextureMap,
	occlusion: TextureMap,
	emissive: TextureMap,

	vertShader: string,
	fragShader: string,

	baseColor: Color,
	emissiveFactor: Vec3,

	normalScale := float32(1.0),
	metallicFactor := float32(1.0),
	roughnessFactor := float32(1.0),
	occlusionStrength := float32(1.0),
	alphaCutoff := float32(0.5),

	alphaMode: AlphaMode = AlphaMode.Opaque,
	cullMode: CullModeFlags = CullModeFlags.Back,
	polygonMode: PolygonMode = PolygonMode.Fill
}

Material::delete
{

}