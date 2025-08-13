package SDLRenderer

import RenderGraph
import ECS

state SDLRenderPass
{
	onDraw: ::(RenderGraph<SDLRenderer>, *Scene)
}

nameToRenderPass := Map<string, SDLRenderPass>();

SDLRenderPass RegisterRenderPass(name: string, onDraw: ::(RenderGraph<SDLRenderer>, *Scene))
{
	pass := SDLRenderPass();
	pass.onDraw = onDraw;

	nameToRenderPass.Insert(name, pass);

	return pass;
}

*SDLRenderPass GetRenderPass(name: string) => nameToRenderPass[name];