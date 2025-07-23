package SceneDescription

import ECS
import Window
import SDL
import SDLRenderer

state WindowDesc
{
	title: string,
	flags: SDL.WindowFlags,
	width: uint32,
	height: uint32
}

enum RendererFlags: uint
{
	SDL = 0,
	Vulkan = 1
}

state RendererDesc
{
	passes: Array<string>
	flags: RendererFlags
}

state SceneDesc
{
	window: WindowDesc,
	renderer: RendererDesc
}

SceneDescComponent := ECS.RegisterComponent<SceneDesc>(
	ComponentKind.Singleton,
	::(sceneDesc: *SceneDesc, scene: Scene) {
		log "Scene description removed";
	},
	::(sceneDesc: *SceneDesc, scene: Scene) {
		log "Scene description added";

		windowDesc := sceneDesc.window;
		rendererDesc := sceneDesc.renderer;

		window := CreateWindow(
			windowDesc.title[0],
			windowDesc.width,
			windowDesc.height,
			windowDesc.flags,
		);

		renderPasses := Array<RenderPass>();
		for (passName in rendererDesc.passes)
		{
			renderPasses.Add(GetRenderPass(passName));
		}

		renderer := SDLRenderer.CreateSDLRenderer(
			window, 
			GetSDLInstanceDevice(),
			renderPasses
		);
	}
);