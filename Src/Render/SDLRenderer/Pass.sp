package SDLRenderer

import RenderGraph
import ECS

state RenderPass
{
	onDraw: ::(RenderGraph, SDLRenderer, *Scene)
}

nameToRenderPass := Map<string, RenderPass>();

RenderPass RegisterRenderPass(name: string, onDraw: ::(RenderGraph, SDLRenderer, *Scene))
{
	pass := RenderPass();
	pass.onDraw = onDraw;

	nameToRenderPass.Insert(name, pass);

	return pass;
}

RenderPass GetRenderPass(name: string) => nameToRenderPass[name]~;