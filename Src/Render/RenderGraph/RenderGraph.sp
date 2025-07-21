package RenderGraph

import SDL
import Array

state RenderPassContext
{
	commandBuffer: *GPUCommandBuffer,
	device: *GPUDevice
}

state RenderGraphPass
{
	name: string,
	node: RenderNode,
	exec: ::(RenderPassContext, *any),
	data: *any
}

state RenderGraph
{
	passes: Array<RenderGraphPass>,
	device: *GPUDevice,
	handles: RenderResourceHandles
}

RenderGraph::AddPass(name: string, init: ::(RenderNodeBuilder, *any), exec: ::(RenderPassContext, *any),
					 data: *any = null)
{
	pass := RenderGraphPass()
	pass.name = name;
	pass.exec = exec;
	pass.data = data;

	builder := RenderNodeBuilder();
	builder.renderGraph = this@;
	init(builder, data);

	pass.node = builder.node;

	this.passes.Add(pass);
}

RenderResourceHandle RenderGraph::RegisterResourceToCreate(name: string, desc: ResourceDesc)
{
	return this.handles.CreateHandle(name, desc);
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
}

