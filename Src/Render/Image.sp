package Image

import OS
import SDL

*SDL.Surface LoadTextureImage(file: string, format: SDL.PixelFormat = SDL.PixelFormat.ABGR8888)
{
	path := GetAbsolutePath(file);
    defer delete path;

	surface := SDL.LoadImage(path);
	return SDL.ConvertSurface(surface, format);
}

*SDL.Surface CreateTextureImage()
{
	return null;
}

