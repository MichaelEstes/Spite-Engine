package VulkanRenderer

import OS

state VulkanShader
{
	shaderModule: *VkShaderModule_T,
	shaderCreateInfo: VkPipelineShaderStageCreateInfo
}

VulkanShader::Create(renderer: *VulkanRenderer, file: string, stage: VkShaderStageFlagBits, entry: string)
{
	log "Loading shader file: ", file;
	shaderFile := ReadFile(file);
	device := renderer.device.device;

	createInfo := VkShaderModuleCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO;
	createInfo.codeSize = shaderFile.count;
	createInfo.pCode = shaderFile[0] as *uint32;

	CheckResult(
		vkCreateShaderModule(device, createInfo@, null, this.shaderModule@),
		"Error creating Vulkan shader module"
	);

    this.shaderCreateInfo = VkPipelineShaderStageCreateInfo();
	this.shaderCreateInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO;
	this.shaderCreateInfo.stage = stage;
	this.shaderCreateInfo.module = this.shaderModule;
	this.shaderCreateInfo.pName = entry[0];
}