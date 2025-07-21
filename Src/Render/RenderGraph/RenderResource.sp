package RenderGraph

import SDL

enum ResourceKind: uint32
{
	Texture,
	Buffer,
	Null
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
	resource: ?{
		texture: *GPUTexture,
		buffer: *GPUBuffer
	},
	kind: ResourceKind
}

ref RenderResource RenderResource::FromTexture(texture: *GPUTexture)
{
	this.resource = texture;
	this.kind = ResourceKind.Texture;

	return this;
}

ref RenderResource RenderResource::FromBuffer(buffer: *GPUBuffer)
{
	this.resource = buffer;
	this.kind = ResourceKind.Buffer;

	return this;
}

ref RenderResource RenderResource::Null()
{
	this.resource = null;
	this.kind = ResourceKind.Null;

	return this;
}