package RenderComponents

import SDL
import Resource

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
	imageHandle: ResourceHandle,

	magFilter: TextureFilter,
	minFilter: TextureFilter,

	wrapU: TextureWrap,
	wrapV: TextureWrap
}