package RenderGraph

state ResourceDesc
{

}

state RenderResource
{
	handle: uint
}

state RenderPassContext
{

}

state RenderGraph
{
	
}

RenderGraph::AddPass<InitData, ExecData>(name: string, 
										 init: ::(RenderNodeBuilder, *InitData), 
										 exec: ::(RenderPassContext, *ExecData)
{

}

