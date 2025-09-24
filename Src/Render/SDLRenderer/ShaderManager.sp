package SDLRenderer

import Resource
import OS

state ShaderResource
{
	shader: *GPUShader,
	metadata: *GraphicsShaderMetadata
}

state ShaderParam
{
	uri: string,
	stage: GPUShaderStage,
	entry: string
}

ShaderResourceManager := Resource.CreateResourceManager<ShaderResource, ShaderParam>(
	['s', 'h', 'd', 'r'],
	::ResourceKey(param: ShaderParam) => ResourceKey(param.uri.Copy()),
	::(shaderResourceParam: *ResourceParam<ShaderResource, ShaderParam>) 
	{
		handle := shaderResourceParam.handle;
		param := shaderResourceParam.param;
		resourceManager := shaderResourceParam.manager;
		resource := resourceManager.GetResource(handle);

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

		shaderResourceParam.onResourceLoad(shaderResourceParam, ResourceResult.Loaded)
	},
	::(handle: ResourceHandle) 
	{
		resource := Resource.GetResource<ShaderResource>(handle);
		ReleaseGPUShader(instance.device, resource.data.shader);
		delete resource.data.metadata;
	}
);

ShaderResourceManagerID := Resource.RegisterResourceManager(ShaderResourceManager@);

ResourceHandle UseShader(uri: string, stage: GPUShaderStage, entry: string)
{
	shaderParam := ShaderParam();
	shaderParam.uri = uri;
	shaderParam.stage = stage;
	shaderParam.entry = entry;

	return ShaderResourceManager.LoadResource(shaderParam);
}