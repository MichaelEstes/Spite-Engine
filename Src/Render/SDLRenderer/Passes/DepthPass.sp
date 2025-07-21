package SDLRenderPass

import SDLRenderer
import RenderGraph

depthPass := RegisterRenderPass(
	"DepthPass",
	::(graph: RenderGraph, renderer: SDLRenderer) {
		log "Building Depth Render Pass";
	}
);