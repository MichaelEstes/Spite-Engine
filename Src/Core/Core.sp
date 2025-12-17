package Core

import ECS
import Time
import Window
import SDL
import ImGui
import Event
import SceneRegistry
import Input
import Math

running := false;

Initialize()
{
	InitializeTime();
	Math.SetRandomSeed(Time.StartTime);
	Fiber.InitalizeFibers();

	SDL.Init(SDL.InitFlags.VIDEO);
	SDL.VulkanLoadLibrary(null);
	
	InitializeInput();
	InitializeImGui();

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
	SceneRegistry.LoadScene(0);
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

		UpdateInput();

		ECS.instance.PreFrame();
		ECS.instance.Frame();
		ECS.instance.PreDraw();
		ECS.instance.Draw();
		ECS.instance.PostFrame();
	}

	ECS.instance.Stop();
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