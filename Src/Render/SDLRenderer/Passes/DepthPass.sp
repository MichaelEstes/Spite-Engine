package SDLRenderPass

import SDLRenderer
import RenderGraph
import ECS
import SDL

depthPassName := "DepthPass";

state DepthPassParam
{
	scene: *Scene,
	window: *SDL.Window,
	depthTextureHandle: RenderResourceHandle
}

depthPass := RegisterRenderPass(
	depthPassName,
	::(graph: RenderGraph, renderer: SDLRenderer, scene: *Scene) {
		param := ECS.FrameAlloc<DepthPassParam>();
		param.scene = scene;
		param.window = renderer.window;

		graph.AddPass(
			depthPassName,
			::bool(builder: RenderNodeBuilder, param: *DepthPassParam) {
				log "Initializing Depth Pass";
				width := uint32(0);
				height := uint32(0);
				SDL.GetWindowSizeInPixels(param.window, width@, height@);

				textureInfo := GPUTextureCreateInfo();
				textureInfo.width = width;
				textureInfo.height = height;
				textureInfo.format = GPUTextureFormat.D32_FLOAT;
				textureInfo.usage = GPUTextureUsageFlags.DEPTH_STENCIL_TARGET;
				textureInfo.layer_count_or_depth = uint32(1);
				textureInfo.num_levels = uint32(1);

				param.depthTextureHandle = builder.CreateTexture(depthPassName, textureInfo);
				builder.Write(param.depthTextureHandle);
				return true;
			},
			::(context: RenderPassContext, param: *DepthPassParam) {
				log "Executing Depth Pass";

				depthTexture := context.UseTexture(param.depthTextureHandle);
			},
			RenderPassStage.Graphics,
			param
		);
	}
);