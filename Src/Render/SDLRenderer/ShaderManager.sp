package SDLRenderer

import Resource
import OS

state ShaderResource
{
	shader: *GPUShader,
	metadata: *GraphicsShaderMetadata
}

state ShaderResourceArg
{
	uri: string,
	stage: GPUShaderStage,
	entry: string
}

ShaderResourceManager := Resource.CreateResourceManager<ShaderResourceArg>(
	['s', 'h', 'd', 'r'],
	::(manager: *ResourceManager<ShaderResourceArg>) {
		manager.RegisterResourceType<ShaderResource>(CreateShaderKey, ShaderManagerLoad);
	},
	::*_Type(param: *ShaderResourceArg) => return #typeof ShaderResource,
	::(handle: ResourceHandle)
	{
		resource := Resource.GetResource<ShaderResource>(handle);
		ReleaseGPUShader(instance.device, resource.data.shader);
		delete resource.data.metadata;
	}
);

ResourceKey CreateShaderKey(param: *ShaderResourceArg) => ResourceKey(param.uri.Copy());

ShaderManagerLoad(resourceArg: *ResourceArg<ShaderResourceArg>, resource: *Resource<ShaderResource>)
{
	param := resourceArg.arg;

	uri := param.uri;
	stage := param.stage;
	entry := param.entry;
	resourceData := resource.data;

	shaderFile := ReadFile(uri);
	metadata := ReflectGraphicsSPIRV(shaderFile[0] as *ubyte, shaderFile.count, 0);

	createInfo := GPUShaderCreateInfo();
	createInfo.code_size = shaderFile.count;
	createInfo.code = shaderFile[0] as *ubyte;
	createInfo.entrypoint = entry[0];
	createInfo.format = GPUShaderFormat.SPIRV;
	createInfo.stage = stage;
	createInfo.num_samplers = metadata.num_samplers;
	createInfo.num_storage_textures = metadata.num_storage_textures;
	createInfo.num_storage_buffers = metadata.num_storage_buffers;
	createInfo.num_uniform_buffers = metadata.num_uniform_buffers;

	shader := CreateGPUShader(instance.device, createInfo@);

	resourceData.shader = shader;
	resourceData.metadata = metadata;

	resource.result = ResourceResult.Loaded;
}

ResourceHandle UseShader(uri: string, stage: GPUShaderStage, entry: string)
{
	shaderParam := ShaderResourceArg();
	shaderParam.uri = uri;
	shaderParam.stage = stage;
	shaderParam.entry = entry;

	return ShaderResourceManager.LoadResource(shaderParam);
}