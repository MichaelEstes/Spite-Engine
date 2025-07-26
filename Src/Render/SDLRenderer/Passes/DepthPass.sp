package SDLRenderPass

import SDLRenderer
import RenderGraph
import ECS

depthPassName := "DepthPass";

state DepthPassParam
{
	scene: *Scene
}

depthPass := RegisterRenderPass(
	depthPassName,
	::(graph: RenderGraph, renderer: SDLRenderer, scene: *Scene) {
		graph.AddPass(
			depthPassName,
			::(builder: RenderNodeBuilder, scene: *Scene) {
				log "Initializing Depth Pass";

			},
			::(context: RenderPassContext, scene: *Scene) {

			},
			scene
		);
	}
);