package VulkanRenderer

import ECS

drawListComputeSource := `
#version 460
#pragma shader_stage(compute)

#extension GL_EXT_shader_explicit_arithmetic_types_int64 : require
#extension GL_EXT_buffer_reference : require

layout(local_size_x = 1) in;

struct ModelUBO {
	mat4 model;
};

struct DrawIndexedIndirectCommand {
	uint indexCount;
	uint instanceCount;
	uint firstIndex;
	int  vertexOffset;
	uint firstInstance;
};

struct DrawIndirectCommand {
	uint vertexCount;
	uint instanceCount;
	uint firstVertex;
	uint firstInstance;
};

layout(std430, set = 0, binding = 0) buffer Models {
	ModelUBO models[];
};

layout(std430, set = 0, binding = 1) buffer IndexedDrawCommands {
	DrawIndexedIndirectCommand indexedDrawCommands[];
};

layout(std430, set = 0, binding = 2) buffer DrawCommands {
	DrawIndirectCommand drawCommands[];
};

layout(std430, set = 0, binding = 3) buffer Counters {
	uint drawIndexCounter;
	uint indexedCounter;
	uint nonIndexedCounter;
};

layout(std430, set = 0, binding = 4) buffer GeometryVariables {
	uint64_t geometryVariables[];
};

layout(std430, set = 0, binding = 5) buffer GeometryAttributeSlots {
	uint64_t geometryAttributeSlots[];
};

layout(std430, set = 0, binding = 6) buffer MaterialVariables {
	uint64_t materialVariables[];
};

layout(std430, set = 0, binding = 7) buffer MaterialTextureSlots {
	uint64_t materialTextureSlots[];
};

layout(buffer_reference, std430, buffer_reference_align = 16) readonly buffer TransformBuffer {
	mat4 transforms[];
};

layout(push_constant) uniform Params {
	uint64_t transformsAddress;
	uint64_t geometryVariablesAddress;
	uint64_t geometryAttributeSlotsAddress;
	uint64_t materialVariablesAddress;
	uint64_t materialTextureSlotsAddress;
	uint meshHandle;
	uint indexCount;
	uint firstIndex;
	uint vertexCount;
} params;

void main()
{
	uint slot = atomicAdd(drawIndexCounter, 1u);

	models[slot].model = TransformBuffer(params.transformsAddress).transforms[params.meshHandle];
	geometryVariables[slot] = params.geometryVariablesAddress;
	geometryAttributeSlots[slot] = params.geometryAttributeSlotsAddress;
	materialVariables[slot] = params.materialVariablesAddress;
	materialTextureSlots[slot] = params.materialTextureSlotsAddress;

	if (params.indexCount > 0u)
	{
		uint cmdSlot = atomicAdd(indexedCounter, 1u);
		DrawIndexedIndirectCommand cmd;
		cmd.indexCount = params.indexCount;
		cmd.instanceCount = 1u;
		cmd.firstIndex = params.firstIndex;
		cmd.vertexOffset = 0;
		cmd.firstInstance = slot;
		indexedDrawCommands[cmdSlot] = cmd;
	}
	else
	{
		uint cmdSlot = atomicAdd(nonIndexedCounter, 1u);
		DrawIndirectCommand cmd;
		cmd.vertexCount = params.vertexCount;
		cmd.instanceCount = 1u;
		cmd.firstVertex = 0u;
		cmd.firstInstance = slot;
		drawCommands[cmdSlot] = cmd;
	}
}
`;

state DrawListPushConstants
{
	transformsAddress: uint64,
	geometryVariablesAddress: uint64,
	geometryAttributeSlotsAddress: uint64,
	materialVariablesAddress: uint64,
	materialTextureSlotsAddress: uint64,
	meshHandle: uint32,
	indexCount: uint32,
	firstIndex: uint32,
	vertexCount: uint32
}

InitDrawListCompute(renderer: *VulkanRenderer)
{
	renderer.drawListCompute.pipeline = FindOrCreateComputePipeline("VulkanDrawListCompute", drawListComputeSource);
	renderer.assetDefDrawSets = SparseSet<VulkanAssetDefDrawSet>();
}

*VulkanAssetDefDrawSet GetOrCreateAssetDefDrawSet(renderer: *VulkanRenderer, assetDefHandle: AssetDefHandle)
{
	key := assetDefHandle.handle;
	existing := renderer.assetDefDrawSets.Get(key);
	if (existing) return existing;

	device := vulkanInstance.device;

	drawSet := renderer.assetDefDrawSets.Emplace(key);
	drawSet~ = VulkanAssetDefDrawSet();

	poolSize := VkDescriptorPoolSize();
	poolSize.type = VkDescriptorType.VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
	poolSize.descriptorCount = 8 * FrameCount;

	poolInfo := VkDescriptorPoolCreateInfo();
	poolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
	poolInfo.poolSizeCount = 1;
	poolInfo.pPoolSizes = poolSize@;
	poolInfo.maxSets = FrameCount;

	CheckResult(
		vkCreateDescriptorPool(device, poolInfo@, null, drawSet.pool@),
		"VulkanAssetDefDrawSet Error creating descriptor pool"
	);

	pointerArraySize := MaxModelCount * #sizeof uint64;

	for (i .. FrameCount)
	{
		drawSet.frames[i] = VulkanAssetDefDrawFrame();

		drawSet.frames[i].modelBuffer = CreateAddressableStorageBuffer(MaxModelCount * #sizeof ModelUBO);
		drawSet.frames[i].indexedDrawCommands = CreateDeviceIndirectBuffer(MaxModelCount * #sizeof VkDrawIndexedIndirectCommand);
		drawSet.frames[i].drawCommands = CreateDeviceIndirectBuffer(MaxModelCount * #sizeof VkDrawIndirectCommand);
		drawSet.frames[i].counters = CreateMappedIndirectBuffer(#sizeof uint32 * 3);
		drawSet.frames[i].geometryVariables = CreateAddressableStorageBuffer(pointerArraySize);
		drawSet.frames[i].geometryAttributeSlots = CreateAddressableStorageBuffer(pointerArraySize);
		drawSet.frames[i].materialVariables = CreateAddressableStorageBuffer(pointerArraySize);
		drawSet.frames[i].materialTextureSlots = CreateAddressableStorageBuffer(pointerArraySize);

		allocInfo := VkDescriptorSetAllocateInfo();
		allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
		allocInfo.descriptorPool = drawSet.pool;
		allocInfo.descriptorSetCount = 1;
		allocInfo.pSetLayouts = renderer.drawListCompute.pipeline.descSetLayouts[0]@;

		CheckResult(
			vkAllocateDescriptorSets(device, allocInfo@, drawSet.frames[i].set@),
			"VulkanAssetDefDrawSet Error allocating descriptor set"
		);

		WriteStorageBufferDescriptor(device, drawSet.frames[i].set, 0, drawSet.frames[i].modelBuffer.buffer);
		WriteStorageBufferDescriptor(device, drawSet.frames[i].set, 1, drawSet.frames[i].indexedDrawCommands.buffer);
		WriteStorageBufferDescriptor(device, drawSet.frames[i].set, 2, drawSet.frames[i].drawCommands.buffer);
		WriteStorageBufferDescriptor(device, drawSet.frames[i].set, 3, drawSet.frames[i].counters.buffer);
		WriteStorageBufferDescriptor(device, drawSet.frames[i].set, 4, drawSet.frames[i].geometryVariables.buffer);
		WriteStorageBufferDescriptor(device, drawSet.frames[i].set, 5, drawSet.frames[i].geometryAttributeSlots.buffer);
		WriteStorageBufferDescriptor(device, drawSet.frames[i].set, 6, drawSet.frames[i].materialVariables.buffer);
		WriteStorageBufferDescriptor(device, drawSet.frames[i].set, 7, drawSet.frames[i].materialTextureSlots.buffer);
	}

	return drawSet;
}

ComputeVulkanDrawList(renderer: VulkanRenderer, scene: *Scene)
{
	frame := renderer.Frame();
	resourceManager := vulkanInstance.resourceManager;
	pipeline := renderer.drawListCompute.pipeline;

	transformsAddress := GetBufferDeviceAddress(resourceManager.transformBuffer.buffer);

	cmd := renderer.GetCommandBuffer(CommandBufferKind.Graphics);
	bindPoint := VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_COMPUTE;

	vkCmdBindPipeline(cmd, bindPoint, pipeline.pipeline);

	for (kv in renderer.drawList.pipelineMap)
	{
		meshArr := kv.value~;
		if (!meshArr.count) continue;

		meshState := kv.key~;
		drawSet := GetOrCreateAssetDefDrawSet(renderer@, meshState.assetDefHandle);
		frameData := drawSet.frames[frame]@;

		counterPtr := vulkanInstance.allocator.GetAllocationMappedPtr(frameData.counters.handle) as *uint32;
		counterPtr[0]~ = 0;
		counterPtr[1]~ = 0;
		counterPtr[2]~ = 0;

		vkCmdBindDescriptorSets(
			cmd, bindPoint, pipeline.layout,
			uint32(0), uint32(1), frameData.set@, uint32(0), null
		);

		for (mesh in meshArr)
		{
			geometry := resourceManager.geometries.Get(mesh.geometryHandle);
			material := resourceManager.materials.Get(mesh.materialHandle);

			push := DrawListPushConstants();
			push.transformsAddress = transformsAddress;
			push.meshHandle = mesh.meshHandle;
			push.geometryVariablesAddress = GetBufferDeviceAddress(geometry.variables.buffer);
			push.geometryAttributeSlotsAddress = GetBufferDeviceAddress(geometry.attributeSlots.buffer);
			push.materialVariablesAddress = GetBufferDeviceAddress(material.variables.buffer);
			push.materialTextureSlotsAddress = GetBufferDeviceAddress(material.textureSlots.buffer);
			push.indexCount = geometry.indexCount;
			push.firstIndex = geometry.firstIndex;
			push.vertexCount = geometry.vertexCount;

			vkCmdPushConstants(
				cmd, pipeline.layout,
				uint32(VkShaderStageFlagBits.VK_SHADER_STAGE_COMPUTE_BIT),
				0, #sizeof DrawListPushConstants, push@
			);
			vkCmdDispatch(cmd, uint32(1), uint32(1), uint32(1));
		}
	}

	barrier := VkMemoryBarrier();
	barrier.sType = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_BARRIER;
	barrier.srcAccessMask = VkAccessFlagBits.VK_ACCESS_SHADER_WRITE_BIT;
	barrier.dstAccessMask = VkAccessFlagBits.VK_ACCESS_INDIRECT_COMMAND_READ_BIT |
							 VkAccessFlagBits.VK_ACCESS_SHADER_READ_BIT;
	vkCmdPipelineBarrier(
		cmd,
		VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
		VkPipelineStageFlagBits.VK_PIPELINE_STAGE_DRAW_INDIRECT_BIT |
		VkPipelineStageFlagBits.VK_PIPELINE_STAGE_VERTEX_SHADER_BIT |
		VkPipelineStageFlagBits.VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT,
		0,
		1, barrier@,
		0, null,
		0, null
	);
}
