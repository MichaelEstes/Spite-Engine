package SDLRenderer

import SDL
import OS

state SDLGPUInstance
{
	device: *GPUDevice
}

instance := SDLGPUInstance();

InitializeSDLGPUInstance()
{
	instance.device = CreateGPUDevice(GPUShaderFormat.SPIRV, true, null);
}

state SDLRenderer
{
	device: *GPUDevice,
	shaderMap := Map<string, *GPUShader>, 
}

Check(success: bool)
{

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

	Check(ClaimWindowForGPUDevice(instance.device, window));

	return renderer;
}