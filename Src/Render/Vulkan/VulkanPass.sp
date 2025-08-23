package VulkanRenderer

import RenderGraph
import ECS

state VulkanRenderPass
{
	onDraw: ::(RenderGraph<VulkanRenderer>, *Scene)
	onInit: ::(VulkanRenderer)
}

nameToRenderPass := Map<string, VulkanRenderPass>();

VulkanRenderPass RegisterRenderPass(name: string, 
									onDraw: ::(RenderGraph<VulkanRenderer>, *Scene)
									onInit: ::(VulkanRenderer) = null)
{
	pass := VulkanRenderPass();
	pass.onDraw = onDraw;
	pass.onInit = onInit;

	nameToRenderPass.Insert(name, pass);

	return pass;
}

*VulkanRenderPass GetRenderPass(name: string) => nameToRenderPass[name];