package SDLRenderPass

import SDLRenderer
import RenderGraph
import ECS

clearPassName := "ClearPass";

clearPass := RegisterRenderPass(
	clearPassName,
	::(graph: RenderGraph<SDLRenderer>, scene: *Scene) 
	{
		graph.AddPass(
			clearPassName,
			::bool(builder: *RenderPassBuilder<SDLRenderer>, param: *void) 
			{
				log "Clear pass init";
				return true;
			},
			::(context: *RenderPassContext<SDLRenderer>, param: *void) 
			{
				log "Clear pass exec";
				//swapchain := context.WaitAndAcquireSwapchain();
			},
			RenderPassStage.Graphics,
			null
		);
	}
);