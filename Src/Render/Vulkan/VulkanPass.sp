package VulkanRenderer

import RenderGraph
import ECS

state VulkanRenderPass
{
	name: string,
	onDraw: ::(RenderGraph<VulkanRenderer>, *Scene, *VulkanRenderPass)
	onInit: ::(VulkanRenderer, *VulkanRenderPass),
	onDestroy: ::(VulkanRenderer, *VulkanRenderPass),
	onResize: ::(VulkanRenderer, *VulkanRenderPass),
	data: *any
}

nameToRenderPass := Map<string, VulkanRenderPass>();

VulkanRenderPass RegisterRenderPass(
	name: string,
	onDraw: ::(RenderGraph<VulkanRenderer>, *Scene, *VulkanRenderPass)
	onInit: ::(VulkanRenderer, *VulkanRenderPass) = null
	onDestroy: ::(VulkanRenderer, *VulkanRenderPass) = null
	onResize: ::(VulkanRenderer, *VulkanRenderPass) = null
)
{
	pass := VulkanRenderPass();
	pass.name = name;
	pass.onDraw = onDraw;
	pass.onInit = onInit;
	pass.onDestroy = onDestroy;
	pass.onResize = onResize;

	nameToRenderPass.Insert(name, pass);

	return pass;
}

*VulkanRenderPass GetRenderPass(name: string) => nameToRenderPass[name];
