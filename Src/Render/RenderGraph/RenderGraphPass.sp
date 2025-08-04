package RenderGraph

import RenderCommon
import Array

enum RenderPassStage
{
	Graphics,
	Compute
}

enum ResourceAccess: uint32
{
	Read,
	Write
}

state RenderResourceUsage
{
	resource: RenderResourceHandle,
	access: ResourceAccess
}

state RenderGraphPass<Renderer>
{
	name: string,
	resources: Array<RenderResourceUsage>,
	exec: ::(*RenderPassContext<Renderer>, *any),
	stage: RenderPassStage,
	data: *any
}

state RenderPassBuilder<Renderer>
{
	renderGraph: *RenderGraph<Renderer>,
	resources: Array<RenderResourceUsage>
}

RenderPassBuilder::Read(target: RenderResourceHandle)
{
	this.resources.Add({ target, ResourceAccess.Read });
}

RenderPassBuilder::Write(target: RenderResourceHandle)
{
	this.resources.Add({ target, ResourceAccess.Write });
}

RenderResourceHandle RenderPassBuilder::Create(name: string, desc: ResourceDesc)
{
	return this.renderGraph.RegisterResourceToCreate(name, desc);
}

RenderResourceHandle RenderPassBuilder::CreateTexture(name: string, texture: TextureDesc)
{
	desc := ResourceDesc();
	desc.kind = ResourceKind.Texture;
	desc.desc.texture = texture;

	return this.Create(name, desc);
}

RenderResourceHandle RenderPassBuilder::CreateBuffer(name: string, buffer: BufferDesc)
{
	desc := ResourceDesc();
	desc.kind = ResourceKind.Buffer;
	desc.desc.buffer = buffer;

	return this.renderGraph.RegisterResourceToCreate(name, desc);
}