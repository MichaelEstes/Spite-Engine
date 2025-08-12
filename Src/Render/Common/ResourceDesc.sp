package RenderCommon

import SDL

enum GPUTextureFlags: uint32
{
	SizeSwapchainRelative = 1 << 0
}

enum GPUTextureTiling: uint32
{
	Optimal,
	Linear
}

enum GPUTextureLayout: uint32
{
	Undefined,
	RenderTarget,
	DepthStencilTarget,
	ShaderRead,
    ShaderWrite,
    TransferSrc,
    TransferDst,
    Present
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
	tiling: GPUTextureTiling,
	flags: GPUTextureFlags,
	layout: GPUTextureLayout,
	shared: bool,

	extension: *any
}

state BufferDesc
{
	size: uint,
	usage: GPUBufferUsageFlags,
	shared: bool,

	extension: *any
}

