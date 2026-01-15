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
	SDLEvents.Insert(0, Event.Emitter());
	
	InitializeInput();
	InitializeImGui();

	globalEvents := GetGlobalEventEmitter();
	globalEvents.On(SDL.EventType.QUIT, ::(event: SDL.Event, data: *void) {
		running = false;
	});

	globalEvents.On(SDL.EventType.WINDOW_CLOSE_REQUESTED, ::(event: SDL.Event, data: *void) {
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
	eventWindowID := event.GetWindowID();
	if (eventWindowID)
	{
		SDLEvents.Get(eventWindowID).Emit<SDL.Event>(event.type, event);
	}
	SDLEvents.Get(0).Emit<SDL.Event>(event.type, event);
	//log event;
}

Stop()
{
	running = false;
}