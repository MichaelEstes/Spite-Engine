package RenderGraph

import Array

state RenderNode
{
	name: string,
	reads: Array<RenderResource>,
	writes: Array<RenderResource>,
	creates: Array<{name: string, desc: RenderResourceDesc}>,
	data: *any
}

state RenderNodeBuilder
{
	renderGraph: *RenderGraph,
	node: RenderNode
}

RenderNodeBuilder::Read(target: RenderResource)
{
	this.node.reads.Add(target);
}

RenderNodeBuilder::Write(target: RenderResource)
{
	this.node.writes.Add(target);
}

RenderResource RenderNodeBuilder::Create(name: string, desc: RenderResourceDesc)
{
	this.node.creates.Add({
		name,
		desc
	});
}