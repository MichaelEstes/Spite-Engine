package VulkanRenderer

import ECS
import Transform
import RenderAssetDef

drawListComputeSource := `
#version 460
#pragma shader_stage(compute)

#extension GL_EXT_shader_explicit_arithmetic_types_int64 : require
#extension GL_EXT_buffer_reference : require

layout(local_size_x = 128) in;

struct DrawIndexedIndirectCommand 
{
	uint indexCount;
	uint instanceCount;
	uint firstIndex;
	int  vertexOffset;
	uint firstInstance;
};

struct DrawIndirectCommand 
{
	uint vertexCount;
	uint instanceCount;
	uint firstVertex;
	uint firstInstance;
};

layout(buffer_reference, std430) readonly buffer IndexedDraws {
    DrawIndexedIndirectCommand indexedDraws[];
};

layout(buffer_reference, std430) readonly buffer Draws 
{
    DrawIndirectCommand draws[];
};

layout(buffer_reference, std430) buffer CulledIndexedDraws
{
    DrawIndexedIndirectCommand culledIndexedDraws[];
};

layout(buffer_reference, std430) buffer CulledDraws
{
    DrawIndirectCommand culledDraws[];
};

layout(buffer_reference, std430) buffer CulledIndexedCountBuffer {
    uint culledIndexedCount;
};

layout(buffer_reference, std430) buffer CulledCountBuffer {
    uint culledCount;
};

layout(push_constant) uniform Params {
	IndexedDraws indexedDrawCommands;
	Draws drawCommands;

	CulledIndexedDraws culledIndexedDrawCommands;
	CulledDraws culledDrawCommands;
	CulledIndexedCountBuffer culledIndexedDrawCount;
	CulledCountBuffer culledDrawCount;

	uint indexedDrawCount;
	uint drawCount;
} params;

void main()
{
	uint index = gl_GlobalInvocationID.x;

	bool visible = true;

	if (params.indexedDrawCount > 0)
	{
		if (index >= params.indexedDrawCount) return;

		if (visible)
		{
			uint dst = atomicAdd(params.culledIndexedDrawCount.culledIndexedCount, 1);
			params.culledIndexedDrawCommands.culledIndexedDraws[dst] = params.indexedDrawCommands.indexedDraws[index];
		}
	}
	else
	{
		if (index >= params.drawCount) return;

		if (visible)
		{
			uint dst = atomicAdd(params.culledDrawCount.culledCount, 1);
			params.culledDrawCommands.culledDraws[dst] = params.drawCommands.draws[index];
		}
	}
}
`;

state DrawComputePush
{
	indexedDrawCommandsAddress: uint64,
	drawCommandsAddress: uint64,
	culledIndexedDrawCommandsAddress: uint64,
	culledDrawCommandsAddress: uint64,
	culledIndexedDrawCountAddress: uint64,
	culledDrawCountAddress: uint64,

	indexedDrawCount: uint32,
	drawCount: uint32
}

ComputeVulkanDrawList(renderer: VulkanRenderer, scene: *Scene)
{
	device := vulkanInstance.device;
	pipeline := FindOrCreateComputePipeline("VulkanDrawListCompute", drawListComputeSource);
	commandBuffer := renderer.GetCommandBuffer(CommandBufferKind.Graphics);
	bindPoint := VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_COMPUTE;

	for (batch in renderer.drawList.batchMap.Values())
	{
		meshes := batch.meshes;
		if (!meshes.count) continue;

		drawBuffers := batch.buffers;

		UpdateBufferCopy(
			commandBuffer, drawBuffers.culledIndexedDrawCount.buffer,
			uint32(0)@ as *byte, #sizeof uint32, 0
		);
		UpdateBufferCopy(
			commandBuffer, drawBuffers.culledDrawCount.buffer,
			uint32(0)@ as *byte, #sizeof uint32, 0
		);
	}

	uploadBarrier := VkMemoryBarrier();
	uploadBarrier.sType = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_BARRIER;
	uploadBarrier.srcAccessMask = VkAccessFlagBits.VK_ACCESS_TRANSFER_WRITE_BIT;
	uploadBarrier.dstAccessMask = VkAccessFlagBits.VK_ACCESS_SHADER_READ_BIT |
								  VkAccessFlagBits.VK_ACCESS_SHADER_WRITE_BIT;
	vkCmdPipelineBarrier(
		commandBuffer,
		VkPipelineStageFlagBits.VK_PIPELINE_STAGE_TRANSFER_BIT,
		VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
		0,
		1, uploadBarrier@,
		0, null,
		0, null
	);

	vkCmdBindPipeline(commandBuffer, bindPoint, pipeline.pipeline);

	for (batch in renderer.drawList.batchMap.Values())
	{
		meshes := batch.meshes;
		if (!meshes.count) continue;

		drawBuffers := batch.buffers;

		push := DrawComputePush();
		push.indexedDrawCommandsAddress = drawBuffers.indexedDrawCommandsAddress;
		push.drawCommandsAddress = drawBuffers.drawCommandsAddress;
		push.culledIndexedDrawCommandsAddress = drawBuffers.culledIndexedDrawCommandsAddress;
		push.culledDrawCommandsAddress = drawBuffers.culledDrawCommandsAddress;
		push.culledIndexedDrawCountAddress = drawBuffers.culledIndexedDrawCountAddress;
		push.culledDrawCountAddress = drawBuffers.culledDrawCountAddress;
		push.indexedDrawCount = batch.indexedCount;
		push.drawCount = uint32(0);

		vkCmdPushConstants(
			commandBuffer, pipeline.layout,
			uint32(VkShaderStageFlagBits.VK_SHADER_STAGE_COMPUTE_BIT),
			0, #sizeof DrawComputePush, push@
		);
		vkCmdDispatch(commandBuffer, (batch.indexedCount + 127) / 128, 1, 1);

		push.indexedDrawCount = uint32(0);
		push.drawCount = batch.nonIndexedCount;

		vkCmdPushConstants(
			commandBuffer, pipeline.layout,
			uint32(VkShaderStageFlagBits.VK_SHADER_STAGE_COMPUTE_BIT),
			0, #sizeof DrawComputePush, push@
		);
		vkCmdDispatch(commandBuffer, (batch.nonIndexedCount + 127) / 128, 1, 1);
	}

	barrier := VkMemoryBarrier();
	barrier.sType = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_BARRIER;
	barrier.srcAccessMask = VkAccessFlagBits.VK_ACCESS_SHADER_WRITE_BIT;
	barrier.dstAccessMask = VkAccessFlagBits.VK_ACCESS_INDIRECT_COMMAND_READ_BIT |
							 VkAccessFlagBits.VK_ACCESS_SHADER_READ_BIT;
	vkCmdPipelineBarrier(
		commandBuffer,
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
