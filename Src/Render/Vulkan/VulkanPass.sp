package VulkanRenderer

import RenderGraph
import ECS

import VulkanRenderPass

state RenderPass
{
	onDraw: ::(RenderGraph<VulkanRenderer>, *Scene)
}

nameToRenderPass := Map<string, RenderPass>();

RenderPass RegisterRenderPass(name: string, onDraw: ::(RenderGraph<VulkanRenderer>, *Scene))
{
	pass := RenderPass();
	pass.onDraw = onDraw;

	nameToRenderPass.Insert(name, pass);

	return pass;
}

*RenderPass GetRenderPass(name: string) => nameToRenderPass[name];