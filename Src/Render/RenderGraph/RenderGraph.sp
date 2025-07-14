package RenderGraph

state RenderPassContext
{
	context: int
}

state RenderGraph
{
	graph: int
}

RenderGraph::AddPass<InitData, ExecData>(name: string, 
										 init: ::(RenderNodeBuilder, *InitData), 
										 exec: ::(RenderPassContext, *ExecData))
{

}

