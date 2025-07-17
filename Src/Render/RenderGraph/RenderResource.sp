package RenderGraph

import SDL

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
	resource: *void,
	kind: ResourceKind
}