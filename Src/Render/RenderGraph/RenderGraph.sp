package RenderGraph

import Array

state RenderPassContext
{
	context: int
}

state RenderGraphPass
{
	name: string,
	init: ::(RenderNodeBuilder), 
	exec: ::(RenderPassContext)
}

state RenderGraph
{
	passes: Array<RenderGraphPass>
}

RenderGraph::AddPass(name: string, init: ::(RenderNodeBuilder), exec: ::(RenderPassContext))
{
	pass := RenderGraphPass()
	pass.name = name;
	pass.init = init;
	pass.exec = exec;

	this.passes.Add(pass);
}

