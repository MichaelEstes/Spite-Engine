package Render

import SDL

enum TextureFilter: uint16
{
	Nearest,
	Linear,
	NearestMipmapNearest,
	LinearMipmapNearest,
	NearestMipmapLinear,
	LinearMipmapLinear
}

enum TextureWrap: uint16
{
	Clamp,
	Mirror,
	Repeat
}

state Texture
{
	image: *SDL.Surface,

	magFilter: TextureFilter,
	minFilter: TextureFilter,

	wrapU: TextureWrap,
	wrapV: TextureWrap
}