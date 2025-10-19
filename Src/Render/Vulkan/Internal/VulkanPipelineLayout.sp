package VulkanRenderer

import Array
import SparseSet
import Resource

state PipelineLayoutKey
{
	vertShaderHandle: ResourceHandle,
	fragShaderHandle: ResourceHandle
}

PipelineLayoutKey::(vertShaderHandle: ResourceHandle, fragShaderHandle: ResourceHandle)
{
	this.vertShaderHandle = vertShaderHandle;
	this.fragShaderHandle = fragShaderHandle;
}

uint HashPipelineLayoutKey(key: PipelineLayoutKey)
{
	return MHash<PipelineLayoutKey>(key);
}

state VulkanPipelineLayoutCache
{
	pipelineLayoutMap := Map<PipelineLayoutKey, *VkPipelineLayout_T, HashPipelineLayoutKey>(),
	descLayoutSetMap := Map<PipelineLayoutKey, Array<*VkDescriptorSetLayout_T>, HashPipelineLayoutKey>()
}

MergeShaderStage(reflectDescSet: FixedArray<*SpvReflectDescriptorSet>,
				 mergedSets: SparseSet<SparseSet<VkDescriptorSetLayoutBinding>>,
				 stageFlag: uint32)
{

	for (reflSet in reflectDescSet)
	{
		set := reflSet.set;
		if (!mergedSets.Has(set))
		{
			mergedSets.Emplace(set);
		}
		setMap := mergedSets.Get(set);

		for (i .. reflSet.binding_count)
		{
			reflBinding := reflSet.bindings[i];
			binding := setMap.Get(reflBinding.binding);

			if (!binding)
			{
				vkBinding := VkDescriptorSetLayoutBinding();
				vkBinding.binding = reflBinding.binding;
                vkBinding.descriptorType = reflBinding.descriptor_type;
                vkBinding.descriptorCount = 1;
				for (dimIndex .. reflBinding.array.dims_count)
				{
					vkBinding.descriptorCount *= reflBinding.array.dims[dimIndex];
				}

                vkBinding.stageFlags = stageFlag;
				setMap.Insert(reflBinding.binding, vkBinding);
			}
			else
			{
				binding.stageFlags |= stageFlag
			}
		}
	}
}

MergePushConstants(module: SpvReflectShaderModule, pushConstantRanges: Array<VkPushConstantRange>)
{
	count := module.push_constant_block_count;
	if (!count) return;

	if (count > pushConstantRanges.capacity)
	{
		pushConstantRanges.SizeTo(count);
	}

	for (i .. count)
	{
		if (pushConstantRanges.count > i)
		{
			pushConstantRanges[i].stageFlags |= module.shader_stage;
		}
		else
		{
			block := module.push_constant_blocks[i];

			range := VkPushConstantRange();
			range.offset = block.offset;
			range.size = block.size;
			range.stageFlags = module.shader_stage;
			pushConstantRanges.Add(range);
		}
	}
}

*VkPipelineLayout_T CreatePipelineLayoutFromKey(device: *VkDevice_T, key: PipelineLayoutKey,
												cache: VulkanPipelineLayoutCache)
{
	vertShaderRes := ShaderResourceManager.GetResource(key.vertShaderHandle).data;
	fragShaderRes := ShaderResourceManager.GetResource(key.fragShaderHandle).data;

	mergedSets := SparseSet<SparseSet<VkDescriptorSetLayoutBinding>>();
	defer 
	{
		for (kv in mergedSets) delete kv.value~;
		delete mergedSets;
	}

	vertStageFlag := vertShaderRes.reflectModule.shader_stage;
	fragStageFlag := fragShaderRes.reflectModule.shader_stage;
	MergeShaderStage(vertShaderRes.reflectDescSet, mergedSets, vertStageFlag);
	MergeShaderStage(fragShaderRes.reflectDescSet, mergedSets, fragStageFlag);

	maxSetIndex := 0;

	for (kv in mergedSets) maxSetIndex = kv.key;
	descSets := Array<*VkDescriptorSetLayout_T>(maxSetIndex + 1);

	setLayoutBindingArr := Array<VkDescriptorSetLayoutBinding>();
	defer delete setLayoutBindingArr;

	lastSet := 0;
	for (kv in mergedSets)
	{
		setIndex := kv.key;
		layoutBindingSet := kv.value;

		while (lastSet < setIndex)
		{
			log "Adding empty descriptor set";
			emptyLayout := CreateEmptyDescriptorSetLayout(device);
			descSets.Add(emptyLayout);
			lastSet += 1;
		}
		lastSet += 1;

		for (layoutKV in layoutBindingSet)
		{
			setLayoutBindingArr.Add(layoutKV.value~);
		}

		createInfo := VkDescriptorSetLayoutCreateInfo();
		createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
		createInfo.bindingCount = setLayoutBindingArr.count;
		createInfo.pBindings = setLayoutBindingArr[0]@;

		layout: *VkDescriptorSetLayout_T = null;
		CheckResult(
			vkCreateDescriptorSetLayout(device, createInfo@, null, layout@),
			"CreatePipelineLayoutFromKey Error creating Vulkan descriptor set layout"
		);
		descSets.Add(layout);
		setLayoutBindingArr.Clear();
	}

	pushConstantRanges := Array<VkPushConstantRange>();
	defer delete pushConstantRanges;
	MergePushConstants(vertShaderRes.reflectModule, pushConstantRanges);
	MergePushConstants(fragShaderRes.reflectModule, pushConstantRanges);

	pipelineLayoutInfo := VkPipelineLayoutCreateInfo();
	pipelineLayoutInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
	pipelineLayoutInfo.setLayoutCount = descSets.count;
	pipelineLayoutInfo.pSetLayouts = descSets[0]@;
	pipelineLayoutInfo.pushConstantRangeCount = pushConstantRanges.count;
	pipelineLayoutInfo.pPushConstantRanges = pushConstantRanges[0]@;

	pipelineLayout: *VkPipelineLayout_T = null;
	CheckResult(
		vkCreatePipelineLayout(device, pipelineLayoutInfo@, null, pipelineLayout@),
		"CreatePipelineLayoutFromKey Error creating Vulkan pipeline layout"
	);

	cache.descLayoutSetMap.Insert(key, descSets);
	return pipelineLayout;
}

*VkPipelineLayout_T FindOrCreatePipelineLayout(device: *VkDevice_T, key: PipelineLayoutKey, 
											   cache: VulkanPipelineLayoutCache)
{
	pipelineLayout := cache.pipelineLayoutMap.Find(key);
	if (pipelineLayout) 
	{
		return pipelineLayout~;
	}
	
	createdPipelineLayout := CreatePipelineLayoutFromKey(device, key, cache);
	cache.pipelineLayoutMap.Insert(key, createdPipelineLayout);
	return createdPipelineLayout;
}