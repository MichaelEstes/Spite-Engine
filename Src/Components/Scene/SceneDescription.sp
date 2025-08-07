package SceneDescription

import ECS
import Window
import SDL
import SDLRenderer
import VulkanRenderer
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
	SDL = 1 << 0,
	Vulkan = 2 << 0
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
		log "Adding scene description";
		param := AllocThreadParam<SceneDescParam>();
		param.sceneDesc = sceneDesc;
		param.scene = scene@;

		Fiber.RunOnMainThread(::(param: *SceneDescParam) 
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
			scene.SetSingleton<*SDL.Window>(window);

			if (rendererDesc.flags & RendererFlags.Vulkan)
			{
				VulkanRenderer.InitializeVulkanInstance();
				renderer := VulkanRenderer.CreateVulkanRenderer(window, rendererDesc.passes);
				scene.SetSingleton<VulkanRenderer>(renderer);
			}
			else
			{
				SDLRenderer.InitializeSDLGPUInstance();
				renderer := SDLRenderer.CreateSDLRenderer(
					window, 
					GetSDLInstanceDevice(),
					rendererDesc.passes
				);
				scene.SetSingleton<SDLRenderer>(renderer);
			}
			
			log "Scene description added";
		}, param);
	}
);