package VulkanRenderer

import Resource
import OS
import SpirvReflect
import FixedArray

state ShaderResource
{
	device: *VkDevice_T,
	shaderModule: *VkShaderModule_T,
	reflectModule: SpvReflectShaderModule,
	reflectDescSet: FixedArray<*SpvReflectDescriptorSet>
	shaderStageInfo: VkPipelineShaderStageCreateInfo,
	descSetLayouts: FixedArray<*VkDescriptorSetLayout_T>,
	pipelineLayout: *VkPipelineLayout_T
}

state ShaderParam
{
	device: *VkDevice_T,
	path: string
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
		resourceData := resource.data;
		
		shaderFile := ReadFile(path);

		result := spvReflectCreateShaderModule(shaderFile.count, shaderFile[0], resourceData.reflectModule@);
		if (result != SpvReflectResult.SPV_REFLECT_RESULT_SUCCESS)
		{
			log "VulkanShaderManager Unable to create reflection module";
		}
		FindOrCreateDescriptorSet(
			device, resourceData.reflectModule@, 
			resourceData.reflectDescSet@,
			resourceData.descSetLayouts@,
			resourceData.pipelineLayout@,
		);

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
        shaderStageInfo.module = resourceData.shaderModule;
        shaderStageInfo.stage = resourceData.reflectModule.shader_stage;
        shaderStageInfo.pName = resourceData.reflectModule.entry_point_name;

		resourceData.shaderStageInfo = shaderStageInfo;
		resourceData.device = device;

		shaderResourceParam.onResourceLoad(shaderResourceParam, ResourceResult.Loaded)
	},
	::(handle: ResourceHandle) 
	{
		resource := Resource.GetResource<ShaderResource>(handle).data;
		spvReflectDestroyShaderModule(resource.reflectModule@);
		vkDestroyShaderModule(resource.device, resource.shaderModule, null);
	}
);

ShaderResourceManagerID := Resource.RegisterResourceManager(ShaderResourceManager@);

ResourceHandle UseShader(device: *VkDevice_T, path: string)
{
	shaderParam := ShaderParam();
	shaderParam.device = device;
	shaderParam.path = path;

	return ShaderResourceManager.LoadResource(shaderParam);
}