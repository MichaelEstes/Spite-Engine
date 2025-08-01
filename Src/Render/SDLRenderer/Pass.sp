package SDLRenderer

import RenderGraph
import ECS

state SDLRenderGraph
{
	graph: RenderGraph<GPUDevice, GPUCommandBuffer, GPUTexture, 
					   GPUBuffer, GPUTextureCreateInfo, GPUBufferCreateInfo>
}

state RenderPass
{
	onDraw: ::(VulkanRenderGraph, SDLRenderer, *Scene)
}

nameToRenderPass := Map<string, RenderPass>();

RenderPass RegisterRenderPass(name: string, onDraw: ::(VulkanRenderGraph, SDLRenderer, *Scene))
{
	pass := RenderPass();
	pass.onDraw = onDraw;

	nameToRenderPass.Insert(name, pass);

	return pass;
}

RenderPass GetRenderPass(name: string) => nameToRenderPass[name]~;