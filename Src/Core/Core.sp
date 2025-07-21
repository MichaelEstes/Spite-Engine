package Core

import ECS
import Time
import Window
import SDL
import Event
import VulkanRenderer
import SDLRenderer
import SDLRenderPass

running := false;

Initialize()
{
	InitializeTime();
	Fiber.InitalizeFibers();

	SDL.Init(SDL.InitFlags.VIDEO);
	SDL.VulkanLoadLibrary(null);

	//VulkanRenderer.InitializeVulkanInstance();
	SDLRenderer.InitializeSDLGPUInstance();

	SDLEventEmitter.On(SDL.EventType.QUIT, ::(event: SDL.Event) {
		running = false;
	});

	SDLEventEmitter.On(SDL.EventType.WINDOW_CLOSE_REQUESTED, ::(event: SDL.Event) {
		windowID := event.data.window.windowID;
		Window.DestroyWindow(Window.GetWindowForID(windowID))
	});
}

Start()
{
	ECS.instance.Start();
	MainLoop();
}

MainLoop()
{
	running = true;

	//renderer := VulkanRenderer.CreateVulkanRenderer(Window.CreateMainWindow());
	renderer := SDLRenderer.CreateSDLRenderer(
		Window.CreateMainWindow(), 
		GetSDLInstanceDevice(),
		Array<RenderPass>([
			depthPass,
		])
	);

	currEvent := SDL.Event();
	while (running)
	{
		ECS.instance.Update();
		//renderer.DrawScenes(ECS.instance.scenes.Values());
		renderer.Draw();
		
		while (SDL.PollEvent(currEvent@)) HandleSDLEvent(currEvent);
	}

	ECS.instance.Stop();
	VulkanRenderer.DestroyAll();
}

HandleSDLEvent(event: SDL.Event)
{
	SDLEventEmitter.Emit<SDL.Event>(event.type, event);
	//log event;
}

Stop()
{
	running = false;
}