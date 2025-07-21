package SDLRenderer

import RenderGraph

state RenderPass
{
	onDraw: ::(RenderGraph, SDLRenderer)
}

nameToRenderPass := Map<string, RenderPass>();

RenderPass RegisterRenderPass(name: string, onDraw: ::(RenderGraph, SDLRenderer))
{
	pass := RenderPass();
	pass.onDraw = onDraw;

	nameToRenderPass.Insert(name, pass);

	return pass;
}