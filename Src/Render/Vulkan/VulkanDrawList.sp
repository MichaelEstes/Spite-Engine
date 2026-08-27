package VulkanRenderer

import ECS
import Transform
import RenderAssetDef

import Common

drawListComputeSource := `
#version 460
#pragma shader_stage(compute)

#extension GL_EXT_shader_explicit_arithmetic_types_int64 : require
#extension GL_EXT_buffer_reference : require
#extension GL_EXT_control_flow_attributes : require

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

struct AABB
{
	vec4 center;
	vec4 halfLength;
};

layout(buffer_reference, std430, buffer_reference_align = 16) readonly buffer ModelBuffer
{
    mat4 models[];
};

layout(buffer_reference, std430, buffer_reference_align = 16) buffer OutModelBuffer
{
    mat4 models[];
};

layout(buffer_reference, std430) readonly buffer Bounds {
    AABB aabbs[];
};

layout(buffer_reference, std430) readonly buffer IndexedDraws {
    DrawIndexedIndirectCommand indexedDraws[];
};

layout(buffer_reference, std430) readonly buffer Draws 
{
    DrawIndirectCommand draws[];
};

layout(buffer_reference, std430) buffer OutIndexedDraws {
    DrawIndexedIndirectCommand indexedDraws[];
};

layout(buffer_reference, std430) buffer OutDraws 
{
    DrawIndirectCommand draws[];
};

layout(push_constant) uniform Params {
	IndexedDraws indexedDrawCommands;
	Draws drawCommands;

	OutIndexedDraws culledIndexedDrawCommands;
	OutDraws culledDrawCommands;

	ModelBuffer models;
	Bounds bounds;

	uint indexedDrawCount;
	uint drawCount;
} params;

layout(set = 0, binding = 0) uniform FrustumUBO
{
    vec4 planes[6];
} frustum;

bool IsVisible(vec3 worldCenter, vec3 worldExtent, vec4 planes[6])
{
	[[unroll]] for (int i = 0; i < 6; i++)
    {
        float extent = dot(worldExtent, abs(planes[i].xyz));
        if (dot(planes[i].xyz, worldCenter) + planes[i].w + extent < 0.0)
			return false;
    }
    return true;
}

void main()
{
	uint index = gl_GlobalInvocationID.x;
	
	if (params.indexedDrawCount > 0)
	{
		if (index >= params.indexedDrawCount) return;

		DrawIndexedIndirectCommand cmd = params.indexedDrawCommands.indexedDraws[index];
		AABB aabb = params.bounds.aabbs[cmd.firstInstance];
		mat4 model = params.models.models[cmd.firstInstance];
		mat3 linear = mat3(model);
		vec3 worldCenter = (model * aabb.center).xyz;
		vec3 worldExtent = mat3(abs(linear[0]), abs(linear[1]), abs(linear[2])) * aabb.halfLength.xyz;

		bool visible = IsVisible(worldCenter, worldExtent, frustum.planes);

		if (visible == false)
		{
			cmd.instanceCount = 0;
		}
		
		params.culledIndexedDrawCommands.indexedDraws[index] = cmd;
	}
	else
	{
		if (index >= params.drawCount) return;

		DrawIndirectCommand cmd = params.drawCommands.draws[index];
		AABB aabb = params.bounds.aabbs[cmd.firstInstance];
		mat4 model = params.models.models[cmd.firstInstance];
		mat3 linear = mat3(model);
		vec3 worldCenter = (model * aabb.center).xyz;
		vec3 worldExtent = mat3(abs(linear[0]), abs(linear[1]), abs(linear[2])) * aabb.halfLength.xyz;

		bool visible = IsVisible(worldCenter, worldExtent, frustum.planes);

		if (visible == false)
		{
			cmd.instanceCount = 0;
		}

		params.culledDrawCommands.draws[index] = cmd;
	}
}
`;

state DrawComputePush
{
	indexedDrawCommandsAddress: uint64,
	drawCommandsAddress: uint64,

	culledIndexedDrawCommandsAddress: uint64,
	culledDrawCommandsAddress: uint64,

	modelBufferAddress: uint64,
	boundsBufferAddress: uint64,

	indexedDrawCount: uint32,
	drawCount: uint32
}

ComputeVulkanDrawList(renderer: VulkanRenderer, scene: *Scene)
{
	device := vulkanInstance.device;
	pipeline := FindOrCreateComputePipeline("VulkanDrawListCompute", drawListComputeSource);
	commandBuffer := renderer.GetCommandBuffer(CommandBufferKind.Graphics);
	bindPoint := VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_COMPUTE;
	frame := renderer.Frame();

	view := renderer.sceneShared.current.view;
	projection := renderer.sceneShared.current.projection;
	frustum := Frustum().FromViewProjection(view * projection);

	renderer.cullData.frustumUBO.Update(frame, frustum);
	
	frustumDescSet := renderer.cullData.frustumUBO.GetDescSet(frame);

	vkCmdBindPipeline(commandBuffer, bindPoint, pipeline.pipeline);

	vkCmdBindDescriptorSets(
		commandBuffer, bindPoint, pipeline.layout,
		uint32(0), uint32(1), frustumDescSet@, uint32(0), null
	);

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
		
		push.modelBufferAddress = drawBuffers.modelBufferAddress;
		push.boundsBufferAddress = drawBuffers.boundsBufferAddress;
		
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
