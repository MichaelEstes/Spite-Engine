package SceneDescription

import ECS
import SDL
import SDLRenderer
import VulkanRenderer
import ThreadParamAllocator
import Fiber
import WindowComponent

enum RendererFlags: uint
{
	SDL = 1 << 0,
	Vulkan = 1 << 1
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
	::(entity: Entity, sceneDesc: *SceneDesc, scene: Scene) 
	{
		log "Scene description removed";
	},
	::(entity: Entity, sceneDesc: *SceneDesc, scene: Scene) 
	{
		log "Scene description entered";
		param := AllocThreadParam<SceneDescParam>();
		param.sceneDesc = sceneDesc;
		param.scene = scene@;

		handle: *JobHandle = null;
		Fiber.RunOnMainThread(::(param: *SceneDescParam)
		{
			log "Creating scene description";
		    defer DeallocThreadParam<SceneDescParam>(param);
			sceneDesc := param.sceneDesc;
			scene := param.scene;

		    windowDesc := sceneDesc.window;
			rendererDesc := sceneDesc.renderer;

			sceneEntity := scene.CreateEntity();

			CreateWindowComponent(windowDesc, scene, sceneEntity);

			if (rendererDesc.flags & RendererFlags.Vulkan)
			{
				VulkanRenderer.InitializeVulkanInstance();
				VulkanRenderer.CreateVulkanRenderer(scene, sceneEntity, rendererDesc.passes);
			}
			else
			{
				sceneWindow := scene.GetComponent<WindowData>(sceneEntity);
				SDLRenderer.InitializeSDLGPUInstance();
				renderer := SDLRenderer.CreateSDLRenderer(
					sceneWindow.window,
					GetSDLInstanceDevice(),
					rendererDesc.passes
				);
				scene.SetSingleton<SDLRenderer>(renderer);
			}
		}, param, handle@);
		WaitForHandle(handle);
		log "Scene description added";
	}
);