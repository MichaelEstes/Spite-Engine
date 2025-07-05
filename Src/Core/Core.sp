package Core

import ECS
import Time
import Window
import SDL
import Event
import VulkanRenderer
import SDLRenderer

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

	//mainRenderer := VulkanRenderer.CreateVulkanRenderer(Window.CreateMainWindow());
	mainRenderer := SDLRenderer.CreateSDLRenderer(Window.CreateMainWindow());

	currEvent := SDL.Event();
	while (running)
	{
		ECS.instance.Update();
		//mainRenderer.DrawScenes(ECS.instance.scenes.Values());
		
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