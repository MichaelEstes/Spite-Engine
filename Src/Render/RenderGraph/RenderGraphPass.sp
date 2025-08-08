package RenderGraph

import RenderCommon
import Array

MaxPassResourceCount := 32;

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
	handle: RenderResourceHandle,
	access: ResourceAccess,
	layout: GPUTextureLayout
}

state RenderGraphPass<Renderer>
{
	name: string,
	resources: [MaxPassResourceCount]RenderResourceUsage,
	count: uint32,
	exec: ::(*RenderPassContext<Renderer>, *any),
	stage: RenderPassStage,
	data: *any
}

state RenderPassBuilder<Renderer>
{
	renderGraph: *RenderGraph<Renderer>,
	resources: [MaxPassResourceCount]RenderResourceUsage,
	index: uint32
}

*Renderer RenderPassBuilder::Renderer()
{
	return this.renderGraph.renderer;
}

RenderPassBuilder::Add(usage: RenderResourceUsage)
{
	assert this.index < MaxPassResourceCount, "Resource limit for render pass reached";
	this.resources[this.index] = usage;
	this.index += 1;
}

RenderPassBuilder::Read(target: RenderResourceHandle,
						layout: GPUTextureLayout = GPUTextureLayout.ShaderRead)
{
	this.Add({ target, ResourceAccess.Read, layout });
}

RenderPassBuilder::Write(target: RenderResourceHandle,
						 layout: GPUTextureLayout = GPUTextureLayout.ShaderWrite)
{
	this.Add({ target, ResourceAccess.Write, layout });
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