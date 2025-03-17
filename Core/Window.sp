package Window

import SDL
import SparseSet

mainWindow: *SDL.Window = null;
windowMap := SparseSet<*SDL.Window>();

*SDL.Window InitializeMainWindow()
{
	mainWindow := CreateWindow(null, 1000, 1000, 
								SDL.WindowFlags.Vulkan | SDL.WindowFlags.Resizable);
	return mainWindow;
}

*SDL.Window CreateWindow(title: *byte, width: int32, height: int32, flags: uint)
{
	window := SDL.CreateWindow(title, width, height, flags);
	windowMap.Insert(window.id, window);
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
}