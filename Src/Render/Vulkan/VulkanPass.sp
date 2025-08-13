package VulkanRenderer

import RenderGraph
import ECS

state VulkanRenderPass
{
	onDraw: ::(RenderGraph<VulkanRenderer>, *Scene)
}

nameToRenderPass := Map<string, VulkanRenderPass>();

VulkanRenderPass RegisterRenderPass(name: string, onDraw: ::(RenderGraph<VulkanRenderer>, *Scene))
{
	pass := VulkanRenderPass();
	pass.onDraw = onDraw;

	nameToRenderPass.Insert(name, pass);

	return pass;
}

*VulkanRenderPass GetRenderPass(name: string) => nameToRenderPass[name];