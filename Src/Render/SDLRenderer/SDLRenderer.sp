package SDLRenderer

import SDL
import OS
import ArrayView

Check(success: bool, errMsg: string)
{
	if (!success)
	{
		log errMsg;
	}
}

state SDLGPUInstance
{
	device: *GPUDevice
}

instance := SDLGPUInstance();

InitializeSDLGPUInstance()
{
	Check(ShaderCross_Init(), "Error initializing Shadercross");
	instance.device = CreateGPUDevice(GPUShaderFormat.SPIRV, true, null);
}

state SDLRenderer
{
	device: *GPUDevice,
}

SDLRenderer CreateSDLRenderer(window: *Window)
{
	renderer := SDLRenderer();

	Check(ClaimWindowForGPUDevice(instance.device, window), "Error claiming window for GPU device");

	return renderer;
}