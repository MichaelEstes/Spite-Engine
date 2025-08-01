package RenderGraph

import SDL
import Array

enum RenderPassStage
{
	Graphics,
	Compute
}

state RenderPassContext<Device, CommandBuffer, Texture, Buffer>
{
	commandBuffer: *CommandBuffer,
	device: *Device,
	window: *SDL.Window,
	handles: *RenderResourceHandles<Texture, Buffer>
}

*Texture RenderPassContext::UseTexture(handle: RenderResourceHandle)
{
	return this.handles.UseResource(handle, this.device).resource.texture;
}

*SDL.GPUBuffer RenderPassContext::UseBuffer(handle: RenderResourceHandle)
{
	return this.handles.UseResource(handle, this.device).resource.buffer;
}

state RenderGraphPass<Device, CommandBuffer, Texture, Buffer>
{
	name: string,
	node: RenderNode,
	exec: ::(RenderPassContext<Device, CommandBuffer, Texture, Buffer>, *any),
	stage: RenderPassStage,
	data: *any
}

state RenderGraph<Device, CommandBuffer, Texture, Buffer, TextureInfo, BufferInfo>
{
	passes: Array<RenderGraphPass<Device, CommandBuffer, Texture, Buffer>>,
	device: *Device,
	window: *SDL.Window,
	handles: RenderResourceHandles<Device, Texture, Buffer, TextureInfo, BufferInfo>
}

RenderGraph::AddPass(name: string, 
					 init: ::bool(RenderNodeBuilder<Device, CommandBuffer, Texture, Buffer, TextureInfo, BufferInfo>, *any), 
					 exec: ::(RenderPassContext<Device, CommandBuffer, Texture, Buffer>, *any),
					 stage: RenderPassStage, data: *any = null)
{
	builder := RenderNodeBuilder<Device, CommandBuffer, Texture, Buffer, TextureInfo, BufferInfo>();
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

RenderResourceHandle RenderGraph::RegisterResourceToCreate(name: string, desc: ResourceDesc<TextureInfo, BufferInfo>)
{
	return this.handles.CreateHandle(name, desc);
}

RenderPassContext<Device, CommandBuffer, Texture, Buffer> RenderGraph::CreateContext(commandBuffer: *CommandBuffer)
{
	context := RenderPassContext<Device, CommandBuffer, Texture, Buffer>();
	context.commandBuffer = commandBuffer;
	context.device = this.device;
	context.window = this.window;
	context.handles = this.handles@;

	return context;
}

RenderGraph::Compile()
{

}

RenderGraph::Execute(context: RenderPassContext<Device, CommandBuffer, Texture, Buffer>)
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

