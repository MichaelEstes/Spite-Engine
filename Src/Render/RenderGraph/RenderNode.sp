package RenderGraph

import Array


state RenderNode
{
	name: string,
	reads: Array<RenderResource>,
	writes: Array<RenderResource>,
}

state RenderNodeBuilder
{
	reads: Array<RenderResource>,
	writes: Array<RenderResource>,
	creates: Array<{name: string, desc: RenderTargetDesc}>,
	data: *any
}

RenderNodeBuilder::Read(target: RenderResource)
{
	this.reads.Add(target);
}

RenderNodeBuilder::Write(target: RenderResource)
{
	this.writes.Add(target);
}

RenderNodeBuilder::Create(name: string, desc: RenderTargetDesc)
{
	this.creates.Add({
		name,
		desc
	});
}