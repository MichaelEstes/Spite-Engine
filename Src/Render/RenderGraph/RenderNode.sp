package RenderGraph

import Array

state RenderNode
{
	name: string,
	reads: Array<RenderResource>,
	writes: Array<RenderResource>,
	init: ::()
}