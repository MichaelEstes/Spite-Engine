package VulkanRenderer

import Resource
import OS
import SDL

state ShaderResource
{
	device: *VkDevice_T,
	shaderModule: *VkShaderModule_T,
	metadata: *GraphicsShaderMetadata,
	shaderStageInfo: VkPipelineShaderStageCreateInfo
}

state ShaderParam
{
	device: *VkDevice_T,
	path: string,
	stage: GPUShaderStage,
	entry: string
}

vkStageFlagTable := [
	VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT,
	VkShaderStageFlagBits.VK_SHADER_STAGE_FRAGMENT_BIT,
	VkShaderStageFlagBits.VK_SHADER_STAGE_COMPUTE_BIT,
	VkShaderStageFlagBits.VK_SHADER_STAGE_GEOMETRY_BIT
];

ShaderResourceManager := Resource.CreateResourceManager<ShaderResource, ShaderParam>(
	['v', 'k', 's', 'h'],
	::ResourceKey(param: ShaderParam) => ResourceKey(param.path.Copy()), 
	::(shaderResourceParam: *ResourceParam<ShaderResource, ShaderParam>) 
	{
		handle := shaderResourceParam.handle;
		param := shaderResourceParam.param;
		resourceManager := shaderResourceParam.manager;
		resource := resourceManager.GetResource(handle);

		device := param.device;
		path := param.path;
		stage := param.stage;
		entry := param.entry;
		resourceData := resource.data;
		
		shaderFile := ReadFile(path);
		metadata := ReflectGraphicsSPIRV(shaderFile[0] as *ubyte, shaderFile.count, 0);

		createInfo := VkShaderModuleCreateInfo();
		createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
		createInfo.codeSize = shaderFile.count;
		createInfo.pCode = shaderFile[0] as *uint32;

		CheckResult(
			vkCreateShaderModule(device, createInfo@, null, resourceData.shaderModule@),
			"Error creating Vulkan shader module"
		);

		shaderStageInfo := VkPipelineShaderStageCreateInfo();
        shaderStageInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
        shaderStageInfo.stage = vkStageFlagTable[stage];
        shaderStageInfo.module = resourceData.shaderModule;
        shaderStageInfo.pName = entry[0];

		resourceData.shaderStageInfo = shaderStageInfo;
		resourceData.metadata = metadata;
		resourceData.device = device;

		shaderResourceParam.onResourceLoad(shaderResourceParam, ResourceResult.Loaded)
	},
	::(handle: ResourceHandle) 
	{
		resource := Resource.GetResource<ShaderResource>(handle).data;
		delete resource.metadata;
		vkDestroyShaderModule(resource.device, resource.shaderModule, null);
	}
);

ShaderResourceManagerID := Resource.RegisterResourceManager(ShaderResourceManager@);

ResourceHandle UseShader(device: *VkDevice_T, path: string, stage: GPUShaderStage, 
						 entry: string = "main")
{
	shaderParam := ShaderParam();
	shaderParam.device = device;
	shaderParam.path = path;
	shaderParam.stage = stage;
	shaderParam.entry = entry;

	return ShaderResourceManager.LoadResource(shaderParam);
}