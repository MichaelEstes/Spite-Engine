package RenderGraph

import SDL

enum RenderTargetKind
{
	Named,
	Direct
}

state RenderResourceHandle
{
	handle: uint
}

enum ResourceKind: uint32
{
	Texture,
	Buffer
}

state ResourceDesc
{
	desc: ?{
		texture: GPUTextureCreateInfo,
		buffer: GPUBufferCreateInfo,
	},
	kind: ResourceKind
}

state RenderTarget
{
	target: ?{
		name: string,
		direct: RenderResourceHandle
	},
	kind: RenderTargetKind
}