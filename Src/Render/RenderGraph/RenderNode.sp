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
	reads: Array<RenderTarget>,
	writes: Array<RenderTarget>,
	creates: Array<{name: string, desc: RenderResourceDesc}>,
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

RenderNodeBuilder::Create(name: string, desc: RenderResourceDesc)
{
	this.creates.Add({
		name,
		desc
	});
}