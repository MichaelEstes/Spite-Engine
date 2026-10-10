package Core

import ECS
import Time
import Window
import SDL
import Event
import SceneRegistry
import Input
import Math
import RenderAssetDef
import Physics

import Tracy

running := false;

pollEventsZone: Tracy.SourceLocationData = Tracy.SourceLocationData("Poll Events"[0], "MainLoop"[0], "Src/Core/Core.sp"[0], 66, 0);
updateInputZone: Tracy.SourceLocationData = Tracy.SourceLocationData("Update Input"[0], "MainLoop"[0], "Src/Core/Core.sp"[0], 70, 0);
preFrameZone: Tracy.SourceLocationData = Tracy.SourceLocationData("PreFrame"[0], "MainLoop"[0], "Src/Core/Core.sp"[0], 74, 0);
frameZone: Tracy.SourceLocationData = Tracy.SourceLocationData("Frame"[0], "MainLoop"[0], "Src/Core/Core.sp"[0], 78, 0);
preDrawZone: Tracy.SourceLocationData = Tracy.SourceLocationData("PreDraw"[0], "MainLoop"[0], "Src/Core/Core.sp"[0], 82, 0);
drawZone: Tracy.SourceLocationData = Tracy.SourceLocationData("Draw"[0], "MainLoop"[0], "Src/Core/Core.sp"[0], 86, 0);
postFrameZone: Tracy.SourceLocationData = Tracy.SourceLocationData("PostFrame"[0], "MainLoop"[0], "Src/Core/Core.sp"[0], 90, 0);

Initialize()
{
	InitializeTime();
	Tracy.StartupProfiler();
	Math.SetRandomSeed(Time.StartTime);
	Fiber.InitalizeFibers();

	SDL.Init(SDL.InitFlags.VIDEO);
	SDL.VulkanLoadLibrary(null);
	SDLEvents.Insert(0, Event.Emitter());
	
	InitializeInput();
	InitializePhysics();
	InitializeRenderAssetDefs();

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
		zone := Tracy.ZoneBegin(pollEventsZone@, 1);
		while (SDL.PollEvent(currEvent@)) HandleSDLEvent(currEvent);
		Tracy.ZoneEnd(zone);

		zone = Tracy.ZoneBegin(updateInputZone@, 1);
		UpdateInput();
		Tracy.ZoneEnd(zone);

		zone = Tracy.ZoneBegin(preFrameZone@, 1);
		ECS.instance.PreFrame();
		Tracy.ZoneEnd(zone);

		zone = Tracy.ZoneBegin(frameZone@, 1);
		ECS.instance.Frame();
		Tracy.ZoneEnd(zone);

		zone = Tracy.ZoneBegin(preDrawZone@, 1);
		ECS.instance.PreDraw();
		Tracy.ZoneEnd(zone);

		zone = Tracy.ZoneBegin(drawZone@, 1);
		ECS.instance.Draw();
		Tracy.ZoneEnd(zone);

		zone = Tracy.ZoneBegin(postFrameZone@, 1);
		ECS.instance.PostFrame();
		Tracy.ZoneEnd(zone);

		Tracy.FrameMark(null);
	}

	ECS.instance.Stop();
}

HandleSDLEvent(event: SDL.Event)
{
	eventWindowID := event.GetWindowID();
	windowEvents := SDLEvents.Get(eventWindowID);
	if (eventWindowID && windowEvents)
	{
		windowEvents.Emit<SDL.Event>(event.type, event);
	}
	SDLEvents.Get(0).Emit<SDL.Event>(event.type, event);
	//log event;
}

Stop()
{
	running = false;
}