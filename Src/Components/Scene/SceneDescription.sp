package SceneDescription

import ECS
import Window
import SDL
import SDLRenderer
import Scene
import ThreadParamAllocator
import Fiber

windowComponent := ECS.RegisterComponent<*SDL.Window>(
	ComponentKind.Singleton
);

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

state SceneDescParam { sceneDesc: *SceneDesc, scene: *Scene }

SceneDescComponent := ECS.RegisterComponent<SceneDesc>(
	ComponentKind.Singleton,
	::(sceneDesc: *SceneDesc, scene: Scene) {
		log "Scene description removed";
	},
	::(sceneDesc: *SceneDesc, scene: Scene) {
		log "Scene description added";

		param := AllocThreadParam<SceneDescParam>();
		param.sceneDesc = sceneDesc;
		param.scene = scene@;

		Fiber.RunOnMainFiber(::(param: *SceneDescParam) 
		{
		    defer DeallocThreadParam<SceneDescParam>(param);
			sceneDesc := param.sceneDesc;
			scene := param.scene;

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

			scene.SetSingleton<*SDL.Window>(window);
			scene.SetSingleton<SDLRenderer>(renderer);
		}, param);
	}
);