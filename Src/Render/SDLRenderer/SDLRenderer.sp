package SDLRenderer

import SDL

state SDLRenderer
{
	device: *SDL.GPUDevice,
}

Check(success: bool)
{

}

SDLRenderer CreateSDLRenderer<Func>(window: *SDL.Window)
{
	renderer := SDLRenderer();

	renderer.device = SDL.CreateGPUDevice(SDL.GPUShaderFormat.SPIRV, true, null);

	Check(SDL.ClaimWindowForGPUDevice(renderer.device, window));
}