package Core

import ECS
import Time
import Window
import SDL
import Event
import VulkanRenderer

running := false;

SDLEventEmitter := Event.Emitter();

Initialize()
{
	InitializeTime();
	Fiber.InitalizeFibers();

	SDL.Init(SDL.InitFlags.VIDEO);
	SDL.VulkanLoadLibrary(null);
	mainWindow := InitializeMainWindow();

	VulkanRenderer.InitializeVulkanRenderer(mainWindow);

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

	currEvent := SDL.Event();
	while (running)
	{
		while (SDL.PollEvent(currEvent@)) HandleSDLEvent(currEvent);
		
		ECS.instance.Update();
		VulkanRenderer.DrawFrame();
	}

	ECS.instance.Stop();
	VulkanRenderer.DestroyVulkanRenderer();
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