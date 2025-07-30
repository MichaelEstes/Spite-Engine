package RenderGraph

import SDL
import Array

enum RenderPassStage
{
	Graphics,
	Compute
}

state RenderPassContext
{
	commandBuffer: *SDL.GPUCommandBuffer,
	device: *SDL.GPUDevice,
	window: *SDL.Window,
	handles: *RenderResourceHandles
}

*SDL.GPUTexture RenderPassContext::UseTexture(handle: RenderResourceHandle)
{
	return this.handles.UseResource(handle, this.device).resource.texture;
}

*SDL.GPUBuffer RenderPassContext::UseBuffer(handle: RenderResourceHandle)
{
	return this.handles.UseResource(handle, this.device).resource.buffer;
}

*SDL.GPUTexture RenderPassContext::WaitAndAcquireSwapchain(outWidth: *uint32 = null, outHeight: *uint32 = null)
{
	texture: *SDL.GPUTexture = null;
	SDL.Check(
		SDL.WaitAndAcquireGPUSwapchainTexture(
			this.commandBuffer,
			this.window,
			texture@,
			outWidth,
			outHeight
		), 
		::(err: *byte) 
		{
			log "Error acquiring swapchain texture";
			puts(err);
		}
	);

	return texture;
}

state RenderGraphPass
{
	name: string,
	node: RenderNode,
	exec: ::(RenderPassContext, *any),
	stage: RenderPassStage,
	data: *any
}

state RenderGraph
{
	passes: Array<RenderGraphPass>,
	device: *SDL.GPUDevice,
	window: *SDL.Window,
	handles: RenderResourceHandles
}

RenderGraph::AddPass(name: string, init: ::bool(RenderNodeBuilder, *any), exec: ::(RenderPassContext, *any),
					 stage: RenderPassStage, data: *any = null)
{
	builder := RenderNodeBuilder();
	builder.renderGraph = this@;
	if (init(builder, data))
	{
		pass := RenderGraphPass()
		pass.name = name;
		pass.node = builder.node;
		pass.exec = exec;
		pass.stage = stage;
		pass.data = data;
		this.passes.Add(pass);
	}
}

RenderResourceHandle RenderGraph::RegisterResourceToCreate(name: string, desc: ResourceDesc)
{
	return this.handles.CreateHandle(name, desc);
}

RenderPassContext RenderGraph::CreateContext(commandBuffer: *GPUCommandBuffer)
{
	context := RenderPassContext();
	context.commandBuffer = commandBuffer;
	context.device = this.device;
	context.window = this.window;
	context.handles = this.handles@;

	return context;
}

RenderGraph::Compile()
{

}

RenderGraph::Execute(context: RenderPassContext)
{
	for (pass in this.passes)
	{
		pass.exec(context, pass.data);
	}

	this.Clear();
}

RenderGraph::Clear()
{
	this.passes.Clear();
	this.handles.Clear();
}

