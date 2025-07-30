package SDLRenderPass

import SDLRenderer
import RenderGraph
import ECS
import SDL


clearPassName := "ClearPass";

clearPass := RegisterRenderPass(
	clearPassName,
	::(graph: RenderGraph, renderer: SDLRenderer, scene: *Scene) {
		graph.AddPass(
			clearPassName,
			::bool(builder: RenderNodeBuilder, param: *void) {
				return true;
			},
			::(context: RenderPassContext, param: *void) {
				log "Clearing Screen";
				swapchain := context.WaitAndAcquireSwapchain();
			},
			RenderPassStage.Graphics,
			null
		);
	}
);