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

state ShaderResourceArg
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

ShaderResourceManager := Resource.CreateResourceManager<ShaderResourceArg>(
	['v', 'k', 's', 'h'],
	::(manager: *ResourceManager<ShaderResourceArg>) {
		manager.RegisterResourceType<ShaderResource>(CreateShaderKey, ShaderManagerLoad);
	},
	::*_Type(param: *ShaderResourceArg) => return #typeof ShaderResource,
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

ResourceKey CreateShaderKey(param: *ShaderResourceArg) => ResourceKey(param.assetDefHandle.handle as uint);

ShaderManagerLoad(resourceArg: *ResourceArg<ShaderResourceArg>, resource: *Resource<ShaderResource>)
{
	param := resourceArg.arg;

	device := vulkanInstance.device;
	assetDef := GetAssetDefWithHandle(param.assetDefHandle);

	CreateShaderItem(device, assetDef.vertex.compiled, resource.data.vertex@);
	CreateShaderItem(device, assetDef.fragment.compiled, resource.data.fragment@);

	resource.result = ResourceResult.Loaded;
}

ResourceHandle UseAssetDefShader(assetDefHandle: AssetDefHandle)
{
	shaderParam := ShaderResourceArg();
	shaderParam.assetDefHandle = assetDefHandle;

	return ShaderResourceManager.LoadResource(shaderParam);
}

state ComputeShaderResource
{
	shader: ShaderItem
}

state ComputeShaderResourceArg
{
	name: string,
	source: string
}

ComputeShaderResourceManager := Resource.CreateResourceManager<ComputeShaderResourceArg>(
	['v', 'k', 'c', 's'],
	::(manager: *ResourceManager<ComputeShaderResourceArg>) {
		manager.RegisterResourceType<ComputeShaderResource>(CreateComputeShaderKey, ComputeShaderManagerLoad);
	},
	::*_Type(param: *ComputeShaderResourceArg) => return #typeof ComputeShaderResource,
	::(handle: ResourceHandle)
	{
		device := vulkanInstance.device;
		resource := Resource.GetResource<ComputeShaderResource>(handle).data;

		spvReflectDestroyShaderModule(resource.shader.reflectModule@);
		vkDestroyShaderModule(device, resource.shader.shaderModule, null);
	}
);

ResourceKey CreateComputeShaderKey(param: *ComputeShaderResourceArg) => ResourceKey(param.name.Copy());

ComputeShaderManagerLoad(resourceArg: *ResourceArg<ComputeShaderResourceArg>, resource: *Resource<ComputeShaderResource>)
{
	param := resourceArg.arg;

	device := vulkanInstance.device;

	compiler := InitShaderCompiler();
	defer delete compiler;

	spirv := CompileShader(param.source, compiler, param.name);
	if (!spirv.count)
	{
		log "ComputeShaderResourceManager failed to compile compute shader: ", param.name;
		resource.result = ResourceResult.LoadFailed;
		return;
	}

	CreateShaderItem(device, spirv, resource.data.shader@);

	resource.result = ResourceResult.Loaded;
}

ResourceHandle UseComputeShader(name: string, source: string)
{
	param := ComputeShaderResourceArg();
	param.name = name;
	param.source = source;

	return ComputeShaderResourceManager.LoadResource(param);
}
