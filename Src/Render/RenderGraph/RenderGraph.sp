package RenderGraph

import SDL
import Array

state RenderPassContext<Renderer>
{
	renderer: *Renderer,
	handles: *RenderResourceHandles<Renderer>
}

*Texture RenderPassContext::UseTexture<Texture>(handle: RenderResourceHandle)
{
	return this.handles.UseResource(handle, this.renderer).resource as *Texture;
}

*Buffer RenderPassContext::UseBuffer<Buffer>(handle: RenderResourceHandle)
{
	return this.handles.UseResource(handle, this.renderer).resource as *Buffer;
}

state RenderGraph<Renderer>
{
	passes: Array<RenderGraphPass<Renderer>>,
	renderer: *Renderer,
	handles: RenderResourceHandles<Renderer>
}

RenderGraph::SetResourceTables(resourceTables: *ResourceTables<Renderer>)
{
	this.handles.resourceTables = resourceTables;
}

RenderGraph::SetRenderer(renderer: *Renderer)
{
	this.renderer = renderer;
}

RenderGraph::AddPass(name: string, 
					 init: ::bool(*RenderPassBuilder<Renderer>, *any), 
					 exec: ::(*RenderPassContext<Renderer>, *any),
					 stage: RenderPassStage, data: *any = null)
{
	builder := RenderPassBuilder<Renderer>();
	builder.renderGraph = this@;
	if (init(builder@, data))
	{
		pass := RenderGraphPass<Renderer>()
		pass.name = name;
		pass.resources = builder.resources;
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
 
RenderPassContext<Renderer> RenderGraph::CreateContext()
{
	context := RenderPassContext<Renderer>();
	context.renderer = this.renderer;
	context.handles = this.handles@;

	return context;
}

RenderGraph::Compile()
{

}

RenderGraph::Execute(context: RenderPassContext<Renderer>)
{
	for (pass in this.passes)
	{
		pass.exec(context@, pass.data);
	}

	this.Clear();
}

RenderGraph::Clear()
{
	this.passes.Clear();
	this.handles.Clear();
}

