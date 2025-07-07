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

	metadata := GetMetadataForShader("./Resource/Shaders/Compiled/vert.spv");
	log "Shader metadata: ", metadata;

	inputArray := ArrayView<IOVarMetadata>(metadata.inputs, metadata.num_inputs);
	for (input in inputArray)
	{
		log "Input: ", input;
	}

	outputArray := ArrayView<IOVarMetadata>(metadata.outputs, metadata.num_outputs);
	for (output in outputArray)
	{
		log "Output: ", output;
	}
}

*GraphicsShaderMetadata GetMetadataForShader(spirvFile: string)
{
	shaderFile := ReadFile(spirvFile);
	return ReflectGraphicsSPIRV(shaderFile[0] as *ubyte, shaderFile.count, 0);
}

state SDLRenderer
{
	device: *GPUDevice,
	shaderMap := Map<string, *GPUShader>(), 
}

*GPUShader RegisterShader(renderer: SDLRenderer, file: string, entry: string, stage: GPUShaderStage,
						  samplers: uint32, textures: uint32, storageBuffers: uint32, uniformBuffers: uint32)
{
	contents := ReadFile(file);

	createInfo := GPUShaderCreateInfo();
	createInfo.code_size = contents.count;
	createInfo.code = contents[0] as *ubyte;
	createInfo.entrypoint = entry[0];
	createInfo.format = GPUShaderFormat.SPIRV;
	createInfo.stage = stage;
	createInfo.num_samplers = samplers;
	createInfo.num_storage_textures = textures;
	createInfo.num_storage_buffers = storageBuffers;
	createInfo.num_uniform_buffers = uniformBuffers;

	shader := CreateGPUShader(instance.device, createInfo@);

	return shader;
}

SDLRenderer CreateSDLRenderer(window: *Window)
{
	renderer := SDLRenderer();


	Check(ClaimWindowForGPUDevice(instance.device, window), "Error claiming window for GPU device");

	return renderer;
}