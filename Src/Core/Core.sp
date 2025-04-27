package Core

import ECS
import Time
import Window
import SDL
import Event
import VulkanRenderer

running := false;

Initialize()
{
	InitializeTime();
	Fiber.InitalizeFibers();

	SDL.Init(SDL.InitFlags.VIDEO);
	SDL.VulkanLoadLibrary(null);

	VulkanRenderer.InitializeVulkanInstance();

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

	VulkanRenderer.CreateVulkanRenderer(Window.CreateMainWindow());

	currEvent := SDL.Event();
	while (running)
	{
		ECS.instance.Update();
		VulkanRenderer.Render();
		
		while (SDL.PollEvent(currEvent@)) HandleSDLEvent(currEvent);
	}

	ECS.instance.Stop();
	VulkanRenderer.Destroy();
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