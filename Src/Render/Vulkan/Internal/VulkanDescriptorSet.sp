package VulkanRenderer

import FixedArray
import SpirvReflect
import MurmurHash

FindOrCreateDescriptorLayout(device: *VkDevice_T,
							 module: *SpvReflectShaderModule, 
							 outReflDescSet: *FixedArray<*SpvReflectDescriptorSet>)
{
	count := uint32(0);
	result := spvReflectEnumerateDescriptorSets(module, count@, null);
	assert result == SpvReflectResult.SPV_REFLECT_RESULT_SUCCESS;

	outReflDescSet~ = FixedArray<*SpvReflectDescriptorSet>(count);
	result = spvReflectEnumerateDescriptorSets(module, count@, outReflDescSet~[0]);
	assert result == SpvReflectResult.SPV_REFLECT_RESULT_SUCCESS;
}

*VkDescriptorSetLayout_T CreateEmptyDescriptorSetLayout(device: *VkDevice_T)
{
	createInfo := VkDescriptorSetLayoutCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;

	out: *VkDescriptorSetLayout_T = null; 

	CheckResult(
		vkCreateDescriptorSetLayout(device, createInfo@, null, out@),
		"CreateEmptyDescriptorSetLayout Error creating empty Vulkan descriptor set layout"
	);

	return out;
}

state SharedUBO<Type>
{
	pool: *VkDescriptorPool_T,
	descLayout: *VkDescriptorSetLayout_T,
	descSets: [FrameCount]*VkDescriptorSet_T,
	buffers: [FrameCount]VulkanAllocHandle,
	UBOs: [FrameCount]*Type,
}

SharedUBO::Init(device: *VkDevice_T, allocator: *VulkanAllocator, binding: uint32)
{
	poolSizes := [VkDescriptorPoolSize(),];
	poolSizes[0].type = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
	poolSizes[0].descriptorCount = FrameCount;
	poolInfo := VkDescriptorPoolCreateInfo();
	poolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
	poolInfo.poolSizeCount = 1;
	poolInfo.pPoolSizes = fixed poolSizes;
	poolInfo.maxSets = FrameCount;

	CheckResult(
		vkCreateDescriptorPool(device, poolInfo@, null, this.pool@),
		"SharedUBO::Init Error allocating Vulkan descriptor pool"
	);

	layoutBinding := VkDescriptorSetLayoutBinding();
	layoutBinding.binding = 0;
	layoutBinding.descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
	layoutBinding.descriptorCount = 1;
	layoutBinding.stageFlags = VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT;
							   //| VkShaderStageFlagBits.VK_SHADER_STAGE_FRAGMENT_BIT;
	
	layoutInfo := VkDescriptorSetLayoutCreateInfo();
	layoutInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
	layoutInfo.bindingCount = 1;
	layoutInfo.pBindings = layoutBinding@;

	CheckResult(
		vkCreateDescriptorSetLayout(device, layoutInfo@, null, this.descLayout@),
		"SharedUBO::Init Error creating Vulkan descriptor set layout"
	);

	uboSize := #sizeof Type;
	for (i .. FrameCount)
	{
		createInfo := VkBufferCreateInfo();
		createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
		createInfo.usage = VkBufferUsageFlagBits.VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT;
		createInfo.size = uboSize;
		createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

		buf := CreateVkBuffer(device, createInfo);
		bufHandle := allocator.AllocBuffer(
			buf, 
			VulkanMemoryFlags.Shared | VulkanMemoryFlags.Coherent | VulkanMemoryFlags.Mapped
		);
		this.buffers[i] = bufHandle;

		alloc := allocator.GetAllocation(bufHandle);
		block := allocator.GetAllocationBlock(bufHandle);
		this.UBOs[i] = (block.mappedPtr + alloc.offset) as *Type;
		this.UBOs[i]~ = Type();
	}

	layouts := [FrameCount]*VkDescriptorSetLayout_T;
	for (i .. FrameCount) layouts[i] = this.descLayout;

	allocInfo := VkDescriptorSetAllocateInfo();
	allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
	allocInfo.descriptorPool = this.pool;
	allocInfo.descriptorSetCount = FrameCount;
	allocInfo.pSetLayouts = fixed layouts;

	CheckResult(
		vkAllocateDescriptorSets(device, allocInfo@, fixed this.descSets),
		"SharedUBO::Init Error allocating scene Vulkan descriptor sets"
	);

	for (i .. FrameCount) 
	{
		buf := allocator.GetAllocation(this.buffers[i]);

		bufferInfo := VkDescriptorBufferInfo();
		bufferInfo.buffer = buf.data.buffer;
		bufferInfo.offset = 0;
		bufferInfo.range = uboSize;

		descriptorWrites := [VkWriteDescriptorSet(),];
		descriptorWrites[0].sType = VkStructureType.VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
		descriptorWrites[0].dstSet = this.descSets[i];
		descriptorWrites[0].dstBinding = binding;
		descriptorWrites[0].dstArrayElement = 0;
		descriptorWrites[0].descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
		descriptorWrites[0].descriptorCount = 1;
		descriptorWrites[0].pBufferInfo = bufferInfo@;

		vkUpdateDescriptorSets(device, 1, fixed descriptorWrites, 0, null);
    }
}

SharedUBO::Update(frame: uint32, value: Type)
{
	this.UBOs[frame]~ = value;
}

*VkDescriptorSet_T SharedUBO::GetDescSet(frame: uint32)
{
	return this.descSets[frame];
}