package RenderGraph

import Array

enum ResourceAccess: uint32
{
	Read,
	Write
}

state RenderResourceUsage
{
	resource: RenderResource,
	access: ResourceAccess
}

state RenderNode
{
	resources: Array<RenderResourceUsage>,
	data: *any
}

state RenderNodeBuilder
{
	renderGraph: *RenderGraph,
	node: RenderNode
}

RenderNodeBuilder::Read(target: RenderResource)
{
	this.node.resources.Add({ target, ResourceAccess.Read });
}

RenderNodeBuilder::Write(target: RenderResource)
{
	this.node.resources.Add({ target, ResourceAccess.Write });
}

RenderResourceHandle RenderNodeBuilder::Create(name: string, desc: ResourceDesc)
{
	return this.renderGraph.RegisterResourceToCreate(name, desc);
}