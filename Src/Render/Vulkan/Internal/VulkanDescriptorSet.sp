package VulkanRenderer

import FixedArray
import SpirvReflect
import MurmurHash

state DescriptorSetLayoutData
{
	setNumber: uint32,
	createInfo: VkDescriptorSetLayoutCreateInfo,
	bindings: FixedArray<VkDescriptorSetLayoutBinding>
}

uint HashDescriptorSetLayoutData(key: DescriptorSetLayoutData)
{
	layoutSize := #sizeof VkDescriptorSetLayoutBinding;
	return MHashDirect(key.bindings[0], layoutSize * key.bindings.count) ^ uint(key.setNumber);
}

state VulkanDescriptorSets
{
	descLayoutCache := Map<DescriptorSetLayoutData, *VkDescriptorSetLayout_T, HashDescriptorSetLayoutData>(),

}

FindOrCreateDescriptorLayout(device: *VkDevice_T, layoutData: DescriptorSetLayoutData, 
							 descCache: VulkanDescriptorSets)
{

}

FindOrCreateDescriptorSet(device: *VkDevice_T,
						  module: *SpvReflectShaderModule, 
						  outReflDescSet: *FixedArray<*SpvReflectDescriptorSet>,
						  outDescSetLayouts: *FixedArray<*VkDescriptorSetLayout_T>,
						  outPipelineLayout: **VkPipelineLayout_T)
{
	count := uint32(0);
	result := spvReflectEnumerateDescriptorSets(module, count@, null);
	assert result == SpvReflectResult.SPV_REFLECT_RESULT_SUCCESS;

	outReflDescSet~ = FixedArray<*SpvReflectDescriptorSet>(count);
	sets := outReflDescSet~;
	result = spvReflectEnumerateDescriptorSets(module, count@, sets[0]);

	assert result == SpvReflectResult.SPV_REFLECT_RESULT_SUCCESS;

	setLayouts := FixedArray<DescriptorSetLayoutData>(count, DescriptorSetLayoutData());
	outDescSetLayouts~ = FixedArray<*VkDescriptorSetLayout_T>(count);

	for (setIndex .. count)
	{
		descSet := sets[setIndex];
		layout := setLayouts[setIndex];

		bindingCount := descSet.binding_count;
		layout.bindings = FixedArray<VkDescriptorSetLayoutBinding>(bindingCount);
		for (bindingIndex .. bindingCount)
		{
			descBinding := descSet.bindings[bindingIndex];
			layoutBinding := layout.bindings[bindingIndex];

			layoutBinding.binding = descBinding.binding;
			layoutBinding.descriptorType = descBinding.descriptor_type;
			layoutBinding.descriptorCount = 1;

			for (dimIndex .. descBinding.array.dims_count)
			{
				layoutBinding.descriptorCount *= descBinding.array.dims[dimIndex];
			}

			layoutBinding.stageFlags = module.shader_stage;
		}

		layout.setNumber = descSet.set;
		layout.createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
		layout.createInfo.bindingCount = descSet.binding_count;
		layout.createInfo.pBindings = layout.bindings[0];

		CheckResult(
			vkCreateDescriptorSetLayout(device, layout.createInfo@, null, outDescSetLayouts~[setIndex]),
			"FindOrCreateDescriptorSet Error creating Vulkan descriptor set layout"
		);
	}

	pipelineLayoutInfo := VkPipelineLayoutCreateInfo();
	pipelineLayoutInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
	pipelineLayoutInfo.setLayoutCount = count;
	pipelineLayoutInfo.pSetLayouts = outDescSetLayouts~[0];
	//pipelineLayoutInfo.pushConstantRangeCount = uint32(0);
	//pipelineLayoutInfo.pPushConstantRanges = null;

	CheckResult(
		vkCreatePipelineLayout(device, pipelineLayoutInfo@, null, outPipelineLayout),
		"FindOrCreateDescriptorSet Error creating Vulkan pipeline layout"
	);
}