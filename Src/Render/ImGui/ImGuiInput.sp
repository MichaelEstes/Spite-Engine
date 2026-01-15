package ImGui

import SDL

UpdateMousePos(event: SDL.Event, data: *void) 
{
	io := ImGui_GetIO();
	x := event.data.motion.x;
	y := event.data.motion.y;

	source := ImGuiMouseSource_.ImGuiMouseSource_Mouse;
	if (event.data.motion.mouseID == uint32(-1))
	{
		source = ImGuiMouseSource_.ImGuiMouseSource_TouchScreen;
	}

	ImGuiIO_AddMouseSourceEvent(io, source);
	ImGuiIO_AddMousePosEvent(io, x, y);
}

UpdateMouseWheel(event: SDL.Event, data: *void) 
{
	io := ImGui_GetIO();
	x := -event.data.wheel.x;
	y := event.data.wheel.y;

	source := ImGuiMouseSource_.ImGuiMouseSource_Mouse;
	if (event.data.motion.mouseID == uint32(-1))
	{
		source = ImGuiMouseSource_.ImGuiMouseSource_TouchScreen;
	}

	ImGuiIO_AddMouseSourceEvent(io, source);
	ImGuiIO_AddMouseWheelEvent(io, x, y);
}

UpdateMouseButton(event: SDL.Event, data: *void) 
{
	io := ImGui_GetIO();
	mouseButton := int32(-1);
	
	switch (event.data.button.button as uint32)
	{
		case (SDL.MouseButton.Left) mouseButton = 0;
		case (SDL.MouseButton.Right) mouseButton = 1;
		case (SDL.MouseButton.Middle) mouseButton = 2;
		case (SDL.MouseButton.X1) mouseButton = 3;
		case (SDL.MouseButton.X2) mouseButton = 4;
	}
	if (mouseButton == -1) return;

	source := ImGuiMouseSource_.ImGuiMouseSource_Mouse;
	if (event.data.motion.mouseID == uint32(-1))
	{
		source = ImGuiMouseSource_.ImGuiMouseSource_TouchScreen;
	}

	ImGuiIO_AddMouseSourceEvent(io, source);
	ImGuiIO_AddMouseButtonEvent(io, mouseButton, event.data.button.down);
}