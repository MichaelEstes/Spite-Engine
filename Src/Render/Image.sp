package Image

import OS
import SDL

*SDL.Surface LoadTextureImage(file: string)
{
	path := GetAbsolutePath(file);
    defer delete path;

	surface := SDL.LoadImage(path);
	return SDL.ConvertSurface(surface, SDL.PixelFormat.ABGR8888);
}