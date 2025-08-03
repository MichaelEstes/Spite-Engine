package RenderGraph

import RenderCommon

enum ResourceKind: uint32
{
	Null,
	Texture,
	Buffer
}

state ResourceDesc
{
	desc: ?{
		texture: TextureDesc,
		buffer: BufferDesc,
	},
	kind: ResourceKind
}

state RenderResource
{
	resource: *any,
	kind: ResourceKind
}

ref RenderResource RenderResource::FromTexture(texture: *any)
{
	this.resource = texture;
	this.kind = ResourceKind.Texture;

	return this;
}

ref RenderResource RenderResource::FromBuffer(buffer: *any)
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