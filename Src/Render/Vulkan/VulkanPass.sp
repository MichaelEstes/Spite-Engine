package VulkanRenderer

import RenderGraph
import ECS

state VulkanRenderGraph
{
	graph: RenderGraph<VkDevice_T, VkCommandBuffer_T, VkImage_T, 
					   VkBuffer_T, VkImageCreateInfo, VkBufferCreateInfo>
}

state RenderPass
{
	onDraw: ::(VulkanRenderGraph, *VulkanRenderer, *Scene)
}

nameToRenderPass := Map<string, RenderPass>();

RenderPass RegisterRenderPass(name: string, onDraw: ::(VulkanRenderGraph, *VulkanRenderer, *Scene))
{
	pass := RenderPass();
	pass.onDraw = onDraw;

	nameToRenderPass.Insert(name, pass);

	return pass;
}

*RenderPass GetRenderPass(name: string) => nameToRenderPass[name];