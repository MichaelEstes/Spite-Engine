package WindowComponent

import SDL
import ECS
import Window

state WindowData
{
	window: *SDL.Window
}

state WindowDesc
{
	title: string,
	flags: SDL.WindowFlags,
	width: uint32,
	height: uint32
}

WindowData CreateWindowComponent(desc: WindowDesc, scene: *Scene, entity: Entity)
{
	windowData := WindowData();
	windowData.window = Window.CreateWindow(
		desc.title[0],
		desc.width,
		desc.height,
		desc.flags,
	);
	scene.SetComponent<WindowData>(entity, windowData);
	return windowData;
}

WindowComponent := ECS.RegisterComponent<WindowData>(
	ComponentKind.Sparse
);