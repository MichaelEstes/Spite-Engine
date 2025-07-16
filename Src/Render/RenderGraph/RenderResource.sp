package RenderGraph

import SDL

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

state RenderResource
{
	handle: RenderResourceHandle,
	kind: ResourceKind
}