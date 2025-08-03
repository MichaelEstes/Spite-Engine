package SDLRenderPass

import SDLRenderer
import RenderGraph
import ECS
import SDL


clearPassName := "ClearPass";

clearPass := RegisterRenderPass(
	clearPassName,
	::(graph: RenderGraph<SDLRenderer>, scene: *Scene) 
	{
		graph.AddPass(
			clearPassName,
			::bool(builder: *RenderPassBuilder<SDLRenderer>, param: *void) 
			{
				return true;
			},
			::(context: *RenderPassContext<SDLRenderer>, param: *void) 
			{
				log "Clearing Screen";
				//swapchain := context.WaitAndAcquireSwapchain();
			},
			RenderPassStage.Graphics,
			null
		);
	}
);