package VulkanRenderPass

import VulkanRenderer
import RenderGraph
import ECS

clearPassName := "ClearPass";

clearPass := RegisterRenderPass(
	clearPassName,
	::(graph: RenderGraph, renderer: *VulkanRenderer, scene: *Scene) {
		graph.AddPass(
			clearPassName,
			::bool(builder: RenderNodeBuilder, param: *void) 
			{
				return true;
			},
			::(context: RenderPassContext, param: *void) {
				log "Clearing Screen";
			},
			RenderPassStage.Graphics,
			null
		);
	}
);