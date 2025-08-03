package RenderCommon

import SDL

enum GPUTextureFlags: uint32
{
	SizeSwapchainRelative = (1 << 0)
}

state TextureDesc
{
	type: GPUTextureType,
	format: GPUTextureFormat,
	usage: GPUTextureUsageFlags,
	width: uint32,
	height: uint32,
	depth: uint32,
	layerCount: uint32,
	mipLevels: uint32,
	samples: GPUSampleCount,
	flags: GPUTextureFlags,

	extension: *any
}

state BufferDesc
{
	size: uint,
	usage: GPUBufferUsageFlags,

	extension: *any
}

