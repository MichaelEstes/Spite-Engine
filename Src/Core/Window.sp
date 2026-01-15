package Window

import SDL
import SparseSet
import Vec
import Event

windowMap := SparseSet<*SDL.Window>();

*SDL.Window CreateWindow(title: *byte, width: int32, height: int32, flags: uint)
{
	window := SDL.CreateWindow(title, width, height, flags);
	windowMap.Insert(window.id, window);
	Event.SDLEvents.Insert(window.id, Event.Emitter());
	return window;
}

*SDL.Window GetWindowForID(windowID: uint32)
{
	window := windowMap.Get(windowID);

	if (window) return window~;
	return null;
}

DestroyWindow(window: *SDL.Window)
{
	if (!window) return;

	SDL.DestroyWindow(window);
	windowMap.Remove(window.id);
	Event.SDLEvents.Remove(window.id);
}

{ width: uint32, height: uint32 } GetWindowSize(window: *SDL.Window)
{
	size := { width := uint32(0), height := uint32(0) };
	SDL.GetWindowSize(window, size.width@, size.height@);
	return size;
}

*SDL.Window GetFocusedWindow() => SDL.GetMouseFocus();