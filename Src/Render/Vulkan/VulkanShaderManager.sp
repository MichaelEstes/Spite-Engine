package VulkanRenderer

import Resource
import OS
import SpirvReflect
import FixedArray
import RenderAssetDef
import ShaderTools

state ShaderItem
{
	shaderModule: *VkShaderModule_T,
	reflectModule: SpvReflectShaderModule,
	reflectDescSet: FixedArray<*SpvReflectDescriptorSet>,
	shaderStageInfo: VkPipelineShaderStageCreateInfo
}

state ShaderResource
{
	vertex: ShaderItem,
	fragment: ShaderItem
}

state ShaderParam
{
	assetDefHandle: AssetDefHandle
}

vkStageFlagTable := [
	VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT,
	VkShaderStageFlagBits.VK_SHADER_STAGE_FRAGMENT_BIT,
	VkShaderStageFlagBits.VK_SHADER_STAGE_COMPUTE_BIT,
	VkShaderStageFlagBits.VK_SHADER_STAGE_GEOMETRY_BIT
];

CreateShaderItem(device: *VkDevice_T, compiled: string, item: *ShaderItem)
{
	result := spvReflectCreateShaderModule(compiled.count, compiled[0], item.reflectModule@);
	if (result != SpvReflectResult.SPV_REFLECT_RESULT_SUCCESS)
	{
		log "VulkanShaderManager Unable to create reflection module";
	}
	FindOrCreateDescriptorLayout(
		device,
		item.reflectModule@,
		item.reflectDescSet@
	);

	createInfo := VkShaderModuleCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
	createInfo.codeSize = compiled.count;
	createInfo.pCode = compiled[0] as *uint32;
	CheckResult(
		vkCreateShaderModule(device, createInfo@, null, item.shaderModule@),
		"Error creating Vulkan shader module"
	);

	shaderStageInfo := VkPipelineShaderStageCreateInfo();
	shaderStageInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
	shaderStageInfo.module = item.shaderModule;
	shaderStageInfo.stage = item.reflectModule.shader_stage;
	shaderStageInfo.pName = item.reflectModule.entry_point_name;

	item.shaderStageInfo = shaderStageInfo;
}

ShaderResourceManager := Resource.CreateResourceManager<ShaderResource, ShaderParam>(
	['v', 'k', 's', 'h'],
	::ResourceKey(param: ShaderParam) => ResourceKey(param.assetDefHandle.handle as uint),
	::(shaderResourceParam: *ResourceParam<ShaderResource, ShaderParam>)
	{
		handle := shaderResourceParam.handle;
		param := shaderResourceParam.param;
		resourceManager := shaderResourceParam.manager;
		resource := resourceManager.GetResource(handle);

		device := vulkanInstance.device;
		assetDef := GetAssetDefWithHandle(param.assetDefHandle);

		CreateShaderItem(device, assetDef.vertex.compiled, resource.data.vertex@);
		CreateShaderItem(device, assetDef.fragment.compiled, resource.data.fragment@);

		shaderResourceParam.onResourceLoad(shaderResourceParam, ResourceResult.Loaded)
	},
	::(handle: ResourceHandle)
	{
		device := vulkanInstance.device;
		resource := Resource.GetResource<ShaderResource>(handle).data;

		spvReflectDestroyShaderModule(resource.vertex.reflectModule@);
		spvReflectDestroyShaderModule(resource.fragment.reflectModule@);

		vkDestroyShaderModule(device, resource.vertex.shaderModule, null);
		vkDestroyShaderModule(device, resource.fragment.shaderModule, null);
	}
);

ShaderResourceManagerID := Resource.RegisterResourceManager(ShaderResourceManager@);

ResourceHandle UseAssetDefShader(assetDefHandle: AssetDefHandle)
{
	shaderParam := ShaderParam();
	shaderParam.assetDefHandle = assetDefHandle;

	return ShaderResourceManager.LoadResource(shaderParam);
}

state ComputeShaderResource
{
	shader: ShaderItem
}

state ComputeShaderParam
{
	name: string,
	source: string
}

ComputeShaderResourceManager := Resource.CreateResourceManager<ComputeShaderResource, ComputeShaderParam>(
	['v', 'k', 'c', 's'],
	::ResourceKey(param: ComputeShaderParam) => ResourceKey(param.name.Copy()),
	::(computeResourceParam: *ResourceParam<ComputeShaderResource, ComputeShaderParam>)
	{
		handle := computeResourceParam.handle;
		param := computeResourceParam.param;
		resourceManager := computeResourceParam.manager;
		resource := resourceManager.GetResource(handle);

		device := vulkanInstance.device;

		compiler := InitShaderCompiler();
		defer delete compiler;

		spirv := CompileShader(param.source, compiler, param.name);
		if (!spirv.count)
		{
			log "ComputeShaderResourceManager failed to compile compute shader: ", param.name;
			computeResourceParam.onResourceLoad(computeResourceParam, ResourceResult.LoadFailed);
			return;
		}

		CreateShaderItem(device, spirv, resource.data.shader@);

		computeResourceParam.onResourceLoad(computeResourceParam, ResourceResult.Loaded);
	},
	::(handle: ResourceHandle)
	{
		device := vulkanInstance.device;
		resource := Resource.GetResource<ComputeShaderResource>(handle).data;

		spvReflectDestroyShaderModule(resource.shader.reflectModule@);
		vkDestroyShaderModule(device, resource.shader.shaderModule, null);
	}
);

ComputeShaderResourceManagerID := Resource.RegisterResourceManager(ComputeShaderResourceManager@);

ResourceHandle UseComputeShader(name: string, source: string)
{
	param := ComputeShaderParam();
	param.name = name;
	param.source = source;

	return ComputeShaderResourceManager.LoadResource(param);
}
