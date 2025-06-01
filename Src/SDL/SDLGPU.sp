package SDL

extern
{
	#link windows "./extern/SDL3";
    #link linux "./extern/libSDL3";

	*GPUDevice SDL_CreateGPUDevice(format_flags: uint32, debug_mode: bool, name: *byte);
	bool SDL_ClaimWindowForGPUDevice(device: *GPUDevice, window: *Window);

	*GPUShader SDL_CreateGPUShader(device: *GPUDevice, createinfo: *GPUShaderCreateInfo);
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

enum GPUShaderStage: uint32
{
	VERTEX,
	FRAGMENT
}

state GPUDevice
{
	opaque: *void
}

state GPUShader
{
	opaque: *void
}

state GPUShaderCreateInfo
{
	code_size: uint,				// The size in bytes of the code pointed to. 
    code: *ubyte,					// A pointer to shader code. 
    entrypoint: *byte,				// A pointer to a null-terminated UTF-8 string specifying the entry point function name for the shader. 
    format: GPUShaderFormat,		// The format of the shader code. 
    stage: GPUShaderStage,			// The stage the shader program corresponds to. 
    num_samplers: uint32,			// The number of samplers defined in the shader. 
    num_storage_textures: uint32,	// The number of storage textures defined in the shader. 
    num_storage_buffers: uint32,	// The number of storage buffers defined in the shader. 
    num_uniform_buffers: uint32,	// The number of uniform buffers defined in the shader. 

    props: uint32				    // A properties ID for extensions. Should be 0 if no extensions are needed. 
}

*GPUDevice CreateGPUDevice(format_flags: uint32, debug_mode: bool, name: *byte) 
		=> SDL_CreateGPUDevice(format_flags, debug_mode, name);

bool ClaimWindowForGPUDevice(device: *GPUDevice, window: *Window) 
		=> SDL_ClaimWindowForGPUDevice(device, window);

*GPUShader CreateGPUShader(device: *GPUDevice, createinfo: *GPUShaderCreateInfo)
		=> SDL_CreateGPUShader(device, createinfo);
