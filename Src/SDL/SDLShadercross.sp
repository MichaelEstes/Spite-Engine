package SDL

extern
{
	#link windows "./extern/SDL3_shadercross";
    //#link linux "./extern/libSDL3_image";

	bool SDL_ShaderCross_Init();
	void SDL_ShaderCross_Quit();
    *GraphicsShaderMetadata SDL_ShaderCross_ReflectGraphicsSPIRV(bytecode: *ubyte, 
                                                                 bytecode_size: uint, 
                                                                 props: uint32);
}

enum IOVarType: uint32 
{
    UNKNOWN,
    INT8,
    UINT8,
    INT16,
    UINT16,
    INT32,
    UINT32,
    INT64,
    UINT64,
    FLOAT16,
    FLOAT32,
    FLOAT64
}

state IOVarMetadata
{
    name: *byte,                    // The UTF-8 name of the variable.
    location: uint32,               // The location of the variable.
    offset: uint32,                 // The byte offset of the variable.
    vector_type: IOVarType,         // The vector type of the variable.
    vector_size: uint32             // The number of components in the vector type of the variable.
}

state GraphicsShaderMetadata
{
	num_samplers: uint32,           // The number of samplers defined in the shader.
    num_storage_textures: uint32,   // The number of storage textures defined in the shader.
    num_storage_buffers: uint32,    // The number of storage buffers defined in the shader.
    num_uniform_buffers: uint32,    // The number of uniform buffers defined in the shader.
    num_inputs: uint32,             // The number of inputs defined in the shader.
    inputs: *IOVarMetadata,         // The inputs defined in the shader.
    num_outputs: uint32,            // The number of outputs defined in the shader.
    outputs: *IOVarMetadata         // The outputs defined in the shader.
}

bool ShaderCross_Init() => SDL_ShaderCross_Init();
ShaderCross_Quit() => SDL_ShaderCross_Quit();

*GraphicsShaderMetadata ReflectGraphicsSPIRV(bytecode: *ubyte, bytecode_size: uint, props: uint32)
    => SDL_ShaderCross_ReflectGraphicsSPIRV(bytecode, bytecode_size, props);
