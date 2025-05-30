package SDL

extern
{
	#link windows "./extern/SDL3";
    #link linux "./extern/libSDL3";

	*GPUDevice SDL_CreateGPUDevice(format_flags: uint32, debug_mode: bool, name: *byte);
	bool SDL_ClaimWindowForGPUDevice(device: *GPUDevice, window: *Window);
}

enum GPUShaderFormat: uint32
{
	INVALID  = 0
	PRIVATE  = 1  // Shaders for NDA'd platforms. 
	SPIRV    = 2  // SPIR-V shaders for Vulkan. 
	DXBC     = 4  // DXBC SM5_1 shaders for D3D12. 
	DXIL     = 8  // DXIL SM6_0 shaders for D3D12. 
	MSL      = 16 // MSL shaders for Metal. 
	METALLIB = 32 // Precompiled metallib shaders for Metal. 
}

state GPUDevice
{
	opaque: *void
}


*GPUDevice CreateGPUDevice(format_flags: uint32, debug_mode: bool, name: *byte) 
		=> SDL_CreateGPUDevice(format_flags, debug_mode, name);

bool ClaimWindowForGPUDevice(device: *GPUDevice, window: *Window) 
		=> SDL_ClaimWindowForGPUDevice(device, window);