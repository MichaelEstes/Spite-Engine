package Image

import SDL

*SDL.Surface LoadTextureImage(file: string)
{
	surface := SDL.LoadImage(file);

	return SDL.ConvertSurface(surface, SDL.PixelFormat.RGBA8888);
}