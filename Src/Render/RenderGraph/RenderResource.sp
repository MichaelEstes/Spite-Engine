package RenderGraph

import SDL

enum ResourceKind: uint32
{
	Texture,
	Buffer,
	Null
}

state ResourceDesc<TextureInfo, BufferInfo>
{
	desc: ?{
		texture: TextureInfo,
		buffer: BufferInfo,
	},
	kind: ResourceKind
}

state RenderResource<Texture, Buffer>
{
	resource: ?{
		texture: *Texture,
		buffer: *Buffer
	},
	kind: ResourceKind
}

ref RenderResource RenderResource::FromTexture(texture: *Texture)
{
	this.resource = texture;
	this.kind = ResourceKind.Texture;

	return this;
}

ref RenderResource RenderResource::FromBuffer(buffer: *Buffer)
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