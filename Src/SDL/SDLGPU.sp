package SDL

extern
{
	#link windows "./extern/SDL3";
    #link linux "./extern/libSDL3";

	*GPUDevice SDL_CreateGPUDevice(format_flags: uint32, debug_mode: bool, name: *byte);
	bool SDL_ClaimWindowForGPUDevice(device: *GPUDevice, window: *Window);

	*GPUShader SDL_CreateGPUShader(device: *GPUDevice, createinfo: *GPUShaderCreateInfo);
    void SDL_ReleaseGPUShader(device: *GPUDevice, shader: *GPUShader);

    *GPUTexture SDL_CreateGPUTexture(device: *GPUDevice, createinfo: *GPUTextureCreateInfo);

    *GPUBuffer SDL_CreateGPUBuffer(device: *GPUDevice, createinfo: *GPUBufferCreateInfo);

    *GPUCommandBuffer SDL_AcquireGPUCommandBuffer(device: *GPUDevice);
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

enum GPUTextureType: uint32
{
    TEX_2D,         // The texture is a 2-dimensional image. 
    TEX_2D_ARRAY,   // The texture is a 2-dimensional array image. 
    TEX_3D,         // The texture is a 3-dimensional image. 
    CUBE,           // The texture is a cube image. 
    CUBE_ARRAY      // The texture is a cube array image. 
}

enum GPUTextureFormat: uint32
{
    INVALID,

    // Unsigned Normalized Float Color Formats 
    A8_UNORM,
    R8_UNORM,
    R8G8_UNORM,
    R8G8B8A8_UNORM,
    R16_UNORM,
    R16G16_UNORM,
    R16G16B16A16_UNORM,
    R10G10B10A2_UNORM,
    B5G6R5_UNORM,
    B5G5R5A1_UNORM,
    B4G4R4A4_UNORM,
    B8G8R8A8_UNORM,

    // Compressed Unsigned Normalized Float Color Formats 
    BC1_RGBA_UNORM,
    BC2_RGBA_UNORM,
    BC3_RGBA_UNORM,
    BC4_R_UNORM,
    BC5_RG_UNORM,
    BC7_RGBA_UNORM,

    // Compressed Signed Float Color Formats 
    BC6H_RGB_FLOAT,

    // Compressed Unsigned Float Color Formats 
    BC6H_RGB_UFLOAT,

    // Signed Normalized Float Color Formats  
    R8_SNORM,
    R8G8_SNORM,
    R8G8B8A8_SNORM,
    R16_SNORM,
    R16G16_SNORM,
    R16G16B16A16_SNORM,

    // Signed Float Color Formats 
    R16_FLOAT,
    R16G16_FLOAT,
    R16G16B16A16_FLOAT,
    R32_FLOAT,
    R32G32_FLOAT,
    R32G32B32A32_FLOAT,

    // Unsigned Float Color Formats 
    R11G11B10_UFLOAT,

    // Unsigned Integer Color Formats 
    R8_UINT,
    R8G8_UINT,
    R8G8B8A8_UINT,
    R16_UINT,
    R16G16_UINT,
    R16G16B16A16_UINT,
    R32_UINT,
    R32G32_UINT,
    R32G32B32A32_UINT,

    // Signed Integer Color Formats 
    R8_INT,
    R8G8_INT,
    R8G8B8A8_INT,
    R16_INT,
    R16G16_INT,
    R16G16B16A16_INT,
    R32_INT,
    R32G32_INT,
    R32G32B32A32_INT,

    // SRGB Unsigned Normalized Color Formats 
    R8G8B8A8_UNORM_SRGB,
    B8G8R8A8_UNORM_SRGB,

    // Compressed SRGB Unsigned Normalized Color Formats 
    BC1_RGBA_UNORM_SRGB,
    BC2_RGBA_UNORM_SRGB,
    BC3_RGBA_UNORM_SRGB,
    BC7_RGBA_UNORM_SRGB,

    // Depth Formats 
    D16_UNORM,
    D24_UNORM,
    D32_FLOAT,
    D24_UNORM_S8_UINT,
    D32_FLOAT_S8_UINT,

    // Compressed ASTC Normalized Float Color Formats
    ASTC_4x4_UNORM,
    ASTC_5x4_UNORM,
    ASTC_5x5_UNORM,
    ASTC_6x5_UNORM,
    ASTC_6x6_UNORM,
    ASTC_8x5_UNORM,
    ASTC_8x6_UNORM,
    ASTC_8x8_UNORM,
    ASTC_10x5_UNORM,
    ASTC_10x6_UNORM,
    ASTC_10x8_UNORM,
    ASTC_10x10_UNORM,
    ASTC_12x10_UNORM,
    ASTC_12x12_UNORM,

    // Compressed SRGB ASTC Normalized Float Color Formats
    ASTC_4x4_UNORM_SRGB,
    ASTC_5x4_UNORM_SRGB,
    ASTC_5x5_UNORM_SRGB,
    ASTC_6x5_UNORM_SRGB,
    ASTC_6x6_UNORM_SRGB,
    ASTC_8x5_UNORM_SRGB,
    ASTC_8x6_UNORM_SRGB,
    ASTC_8x8_UNORM_SRGB,
    ASTC_10x5_UNORM_SRGB,
    ASTC_10x6_UNORM_SRGB,
    ASTC_10x8_UNORM_SRGB,
    ASTC_10x10_UNORM_SRGB,
    ASTC_12x10_UNORM_SRGB,
    ASTC_12x12_UNORM_SRGB,

    // Compressed ASTC Signed Float Color Formats
    ASTC_4x4_FLOAT,
    ASTC_5x4_FLOAT,
    ASTC_5x5_FLOAT,
    ASTC_6x5_FLOAT,
    ASTC_6x6_FLOAT,
    ASTC_8x5_FLOAT,
    ASTC_8x6_FLOAT,
    ASTC_8x8_FLOAT,
    ASTC_10x5_FLOAT,
    ASTC_10x6_FLOAT,
    ASTC_10x8_FLOAT,
    ASTC_10x10_FLOAT,
    ASTC_12x10_FLOAT,
    ASTC_12x12_FLOAT
}

enum GPUTextureUsageFlags: uint32
{
    SAMPLER                                 = (1 << 0), // Texture supports sampling. 
    COLOR_TARGET                            = (1 << 1), // Texture is a color render target. 
    DEPTH_STENCIL_TARGET                    = (1 << 2), // Texture is a depth stencil target. 
    GRAPHICS_STORAGE_READ                   = (1 << 3), // Texture supports storage reads in graphics stages. 
    COMPUTE_STORAGE_READ                    = (1 << 4), // Texture supports storage reads in the compute stage. 
    COMPUTE_STORAGE_WRITE                   = (1 << 5), // Texture supports storage writes in the compute stage. 
    COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE = (1 << 6)  // Texture supports reads and writes in the same compute shader. This is NOT equivalent to READ | WRITE. 
}

enum GPUSampleCount: uint32
{
    None,    // No multisampling
    MSSA_2,  // MSAA 2x
    MSSA_4,  // MSAA 4x
    MSSA_8   // MSAA 8x
}

enum GPUBufferUsageFlags: uint32
{
    VERTEX                = (1 << 0), // Buffer is a vertex buffer. 
    INDEX                 = (1 << 1), // Buffer is an index buffer. 
    INDIRECT              = (1 << 2), // Buffer is an indirect buffer. 
    GRAPHICS_STORAGE_READ = (1 << 3), // Buffer supports storage reads in graphics stages. 
    COMPUTE_STORAGE_READ  = (1 << 4), // Buffer supports storage reads in the compute stage. 
    COMPUTE_STORAGE_WRITE = (1 << 5)  // Buffer supports storage writes in the compute stage. 
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

state GPUCommandBuffer
{
	opaque: *void
}

state GPUTexture
{
    opaque: *void
}

state GPUBuffer
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

state GPUTextureCreateInfo
{
    type: GPUTextureType,          // The base dimensionality of the texture. 
    format: GPUTextureFormat,      // The pixel format of the texture. 
    usage: GPUTextureUsageFlags,   // How the texture is intended to be used by the client. 
    width: uint32,                 // The width of the texture. 
    height: uint32,                // The height of the texture. 
    layer_count_or_depth: uint32,  // The layer count or depth of the texture. This value is treated as a layer count on 2D array textures, and as a depth value on 3D textures. 
    num_levels: uint32,            // The number of mip levels in the texture. 
    sample_count: GPUSampleCount,  // The number of samples per texel. Only applies if the texture is used as a render target. 

    props: uint32                  // A properties ID for extensions. Should be 0 if no extensions are needed.
}

state GPUBufferCreateInfo
{
    usage: GPUBufferUsageFlags,  // How the buffer is intended to be used by the client. 
    size: uint32,                // The size in bytes of the buffer. 

    props: uint32                // A properties ID for extensions. Should be 0 if no extensions are needed.
}

*GPUDevice CreateGPUDevice(format_flags: uint32, debug_mode: bool, name: *byte) 
		=> SDL_CreateGPUDevice(format_flags, debug_mode, name);

bool ClaimWindowForGPUDevice(device: *GPUDevice, window: *Window) 
		=> SDL_ClaimWindowForGPUDevice(device, window);

*GPUShader CreateGPUShader(device: *GPUDevice, createinfo: *GPUShaderCreateInfo)
		=> SDL_CreateGPUShader(device, createinfo);

void ReleaseGPUShader(device: *GPUDevice, shader: *GPUShader)
        => SDL_ReleaseGPUShader(device, shader);

*GPUTexture CreateGPUTexture(device: *GPUDevice, createinfo: *GPUTextureCreateInfo)
        => SDL_CreateGPUTexture(device, createinfo);

*GPUBuffer CreateGPUBuffer(device: *GPUDevice, createinfo: *GPUBufferCreateInfo)
        => SDL_CreateGPUBuffer(device, createinfo);

*GPUCommandBuffer AcquireGPUCommandBuffer(device: *GPUDevice)
        => SDL_AcquireGPUCommandBuffer(device);
