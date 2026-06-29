package VulkanRenderer

import Array
import SparseSet

state VulkanComputeLayout
{
	layout: *VkPipelineLayout_T,
	descSetLayouts: Array<*VkDescriptorSetLayout_T>
}

state VulkanComputePipeline
{
	pipeline: *VkPipeline_T,
	layout: *VkPipelineLayout_T,
	descSetLayouts: Array<*VkDescriptorSetLayout_T>
}

state VulkanComputePipelineCache
{
	pipelines := SparseSet<VulkanComputePipeline>()
}

*VkPipeline_T CreateComputePipeline(device: *VkDevice_T, stageInfo: VkPipelineShaderStageCreateInfo,
									layout: *VkPipelineLayout_T)
{
	pipelineInfo := VkComputePipelineCreateInfo();
	pipelineInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMPUTE_PIPELINE_CREATE_INFO;
	pipelineInfo.stage = stageInfo;
	pipelineInfo.layout = layout;

	pipeline: *VkPipeline_T = null;
	CheckResult(
		vkCreateComputePipelines(device, null, uint32(1), pipelineInfo@, null, pipeline@),
		"CreateComputePipeline Error creating Vulkan compute pipeline"
	);
	return pipeline;
}

VulkanComputeLayout CreateComputePipelineLayoutFromShader(device: *VkDevice_T, shaderItem: *ShaderItem)
{
	stageFlag := shaderItem.reflectModule.shader_stage;

	descSets := Array<*VkDescriptorSetLayout_T>();

	bindingArr := Array<VkDescriptorSetLayoutBinding>();
	defer delete bindingArr;

	lastSet := 0;
	for (reflSet in shaderItem.reflectDescSet)
	{
		setIndex := reflSet.set;
		while (lastSet < setIndex)
		{
			descSets.Add(CreateEmptyDescriptorSetLayout(device));
			lastSet += 1;
		}
		lastSet += 1;

		bindingArr.Clear();
		for (i .. reflSet.binding_count)
		{
			reflBinding := reflSet.bindings[i];

			binding := VkDescriptorSetLayoutBinding();
			binding.binding = reflBinding.binding;
			binding.descriptorType = reflBinding.descriptor_type;
			binding.descriptorCount = 1;
			for (dim .. reflBinding.array.dims_count)
			{
				binding.descriptorCount *= reflBinding.array.dims[dim];
			}
			binding.stageFlags = stageFlag;
			bindingArr.Add(binding);
		}

		layoutInfo := VkDescriptorSetLayoutCreateInfo();
		layoutInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
		layoutInfo.bindingCount = bindingArr.count;
		layoutInfo.pBindings = bindingArr[0]@;

		layout: *VkDescriptorSetLayout_T = null;
		CheckResult(
			vkCreateDescriptorSetLayout(device, layoutInfo@, null, layout@),
			"CreateComputePipelineLayoutFromShader Error creating descriptor set layout"
		);
		descSets.Add(layout);
	}

	pushConstantRanges := Array<VkPushConstantRange>();
	defer delete pushConstantRanges;
	module := shaderItem.reflectModule;
	for (i .. module.push_constant_block_count)
	{
		block := module.push_constant_blocks[i];

		range := VkPushConstantRange();
		range.offset = block.offset;
		range.size = block.size;
		range.stageFlags = stageFlag;
		pushConstantRanges.Add(range);
	}

	pipelineLayoutInfo := VkPipelineLayoutCreateInfo();
	pipelineLayoutInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
	pipelineLayoutInfo.setLayoutCount = descSets.count;
	pipelineLayoutInfo.pSetLayouts = descSets[0]@;
	pipelineLayoutInfo.pushConstantRangeCount = pushConstantRanges.count;
	pipelineLayoutInfo.pPushConstantRanges = pushConstantRanges[0]@;

	computeLayout := VulkanComputeLayout();
	CheckResult(
		vkCreatePipelineLayout(device, pipelineLayoutInfo@, null, computeLayout.layout@),
		"CreateComputePipelineLayoutFromShader Error creating pipeline layout"
	);
	computeLayout.descSetLayouts = descSets;

	return computeLayout;
}

*VulkanComputePipeline FindOrCreateComputePipeline(name: string, source: string)
{
	device := vulkanInstance.device;
	cache := vulkanInstance.computePipelineCache;

	shaderHandle := UseComputeShader(name, source);

	existing := cache.pipelines.Get(shaderHandle.id);
	if (existing) return existing;

	shaderItem := ComputeShaderResourceManager.GetResource(shaderHandle).data.shader@;

	computeLayout := CreateComputePipelineLayoutFromShader(device, shaderItem);
	pipeline := CreateComputePipeline(device, shaderItem.shaderStageInfo, computeLayout.layout);

	computePipeline := cache.pipelines.Emplace(shaderHandle.id);
	computePipeline.pipeline = pipeline;
	computePipeline.layout = computeLayout.layout;
	computePipeline.descSetLayouts = computeLayout.descSetLayouts;

	return computePipeline;
}