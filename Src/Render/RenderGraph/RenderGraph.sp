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
	device: *GPUDevice
}

RenderGraph::AddPass(name: string, init: ::(RenderNodeBuilder), exec: ::(RenderPassContext, *any),
					 data: *any = null)
{
	pass := RenderGraphPass()
	pass.name = name;
	pass.exec = exec;
	pass.data = data;

	builder := RenderNodeBuilder();
	builder.renderGraph = this@;
	init(builder);

	pass.node = builder.node;

	this.passes.Add(pass);
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

