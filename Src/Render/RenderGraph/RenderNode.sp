package RenderGraph

import Array

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

state RenderNode
{
	resources: Array<RenderResourceUsage>,
}

state RenderNodeBuilder
{
	renderGraph: *RenderGraph,
	node: RenderNode
}

*SDL.Window RenderNodeBuilder::Window() => this.renderGraph.window;


RenderNodeBuilder::Read(target: RenderResourceHandle)
{
	this.node.resources.Add({ target, ResourceAccess.Read });
}

RenderNodeBuilder::Write(target: RenderResourceHandle)
{
	this.node.resources.Add({ target, ResourceAccess.Write });
}

RenderResourceHandle RenderNodeBuilder::Create(name: string, desc: ResourceDesc)
{
	return this.renderGraph.RegisterResourceToCreate(name, desc);
}

RenderResourceHandle RenderNodeBuilder::CreateTexture(name: string, texture: GPUTextureCreateInfo)
{
	desc := ResourceDesc();
	desc.kind = ResourceKind.Texture;
	desc.desc.texture = texture;

	return this.Create(name, desc);
}

RenderResourceHandle RenderNodeBuilder::CreateBuffer(name: string, buffer: GPUBufferCreateInfo)
{
	desc := ResourceDesc();
	desc.kind = ResourceKind.Buffer;
	desc.desc.buffer = buffer;

	return this.renderGraph.RegisterResourceToCreate(name, desc);
}