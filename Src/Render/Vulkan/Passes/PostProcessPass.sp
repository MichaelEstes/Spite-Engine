package VulkanRenderPass

import VulkanRenderer
import RenderGraph
import ECS

PostProcessGroupSize := uint32(16);

state PostProcessParams
{
	imageWidth: uint32,
	imageHeight: uint32
}

postProcessSource := `
#version 460
#pragma shader_stage(compute)

layout(local_size_x = 16, local_size_y = 16) in;

layout(set = 0, binding = 0, rgba16f) uniform image2D colorImage;

layout(push_constant) uniform Params {
	uvec2 imageSize;
} params;

// sRGB => XYZ => D65_2_D60 => AP1 => RRT_SAT
const mat3 ACESInputMat = mat3(
	0.59719, 0.35458, 0.04823,
	0.07600, 0.90834, 0.01566,
	0.02840, 0.13383, 0.83777
);

// ODT_SAT => XYZ => D60_2_D65 => sRGB
const mat3 ACESOutputMat = mat3(
	 1.60475, -0.53108, -0.07367,
	-0.10208,  1.10813, -0.00605,
	-0.00327, -0.07276,  1.07602
);

vec3 RRTAndODTFit(vec3 v)
{
	vec3 a = v * (v + 0.0245786f) - 0.000090537f;
	vec3 b = v * (0.983729f * v + 0.4329510f) + 0.238081f;
	return a / b;
}

vec3 ACESFitted(vec3 color)
{
	color = color * ACESInputMat;

	// Apply RRT and ODT
	color = RRTAndODTFit(color);
	color = color * ACESOutputMat;
	// Clamp to [0, 1]
	color = clamp(color, 0.0, 1.0);

	return color;
}

void main()
{
	uvec2 texel = gl_GlobalInvocationID.xy;
	if (texel.x >= params.imageSize.x || texel.y >= params.imageSize.y) return;

	ivec2 coord = ivec2(texel);
	vec4 color = imageLoad(colorImage, coord);

	color.rgb = ACESFitted(color.rgb);

	imageStore(colorImage, coord, color);
}
`;

state PostProcessFrame
{
	set: *VkDescriptorSet_T
}

state PostProcessState
{
	pipeline: *VulkanComputePipeline,
	pool: *VkDescriptorPool_T,
	frames: VulkanFrameResource<PostProcessFrame>
}

postProcessPassName := "PostProcessPass";

postProcessPass := RegisterRenderPass(
	postProcessPassName,
	::(graph: RenderGraph<VulkanRenderer>, scene: *Scene, self: *VulkanRenderPass)
	{
		graph.AddPass(
			postProcessPassName,
			::bool(builder: *RenderPassBuilder<VulkanRenderer>, data: *PostProcessState)
			{
				renderer := builder.Renderer();

				assetState := renderer.GetRenderPassByName(assetPassName).data as *AssetPassState;
				builder.Read(assetState.assetPassResource, ResourceUsageFlags.StorageRead);
				builder.Write(assetState.assetPassResource, ResourceUsageFlags.StorageWrite);

				return true;
			},
			::(context: *RenderPassContext<VulkanRenderer>, data: *PostProcessState)
			{
				renderer := context.renderer;
				device := vulkanInstance.device;
				commandBuffer := renderer.GetCommandBuffer(CommandBufferKind.Graphics);
				frame := renderer.Frame();
				bindPoint := VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_COMPUTE;

				assetState := renderer.GetRenderPassByName(assetPassName).data as *AssetPassState;
				assetImage := UseRenderPassTexture<VulkanRenderer, VkImage_T>(
					context, assetState.assetPassResource
				);
				assetTarget := vulkanInstance.resourceManager.renderTargetMap.Find(assetImage);

				postProcessFrame := data.frames.frames[frame];

				WriteStorageImageDescriptor(
					device, postProcessFrame.set, 0,
					assetTarget.imageView, VkImageLayout.VK_IMAGE_LAYOUT_GENERAL
				);

				params := PostProcessParams();
				params.imageWidth = renderer.swapchain.extent.width;
				params.imageHeight = renderer.swapchain.extent.height;

				vkCmdBindPipeline(commandBuffer, bindPoint, data.pipeline.pipeline);
				vkCmdBindDescriptorSets(
					commandBuffer, bindPoint, data.pipeline.layout,
					uint32(0), uint32(1), postProcessFrame.set@, uint32(0), null
				);
				vkCmdPushConstants(
					commandBuffer, data.pipeline.layout,
					uint32(VkShaderStageFlagBits.VK_SHADER_STAGE_COMPUTE_BIT),
					0, #sizeof PostProcessParams, params@
				);

				groupsX := (params.imageWidth + (PostProcessGroupSize - uint32(1))) / PostProcessGroupSize;
				groupsY := (params.imageHeight + (PostProcessGroupSize - uint32(1))) / PostProcessGroupSize;
				vkCmdDispatch(commandBuffer, groupsX, groupsY, uint32(1));
			},
			RenderPassStage.Compute,
			self.data as *PostProcessState
		);
	},
	::(renderer: VulkanRenderer, self: *VulkanRenderPass)
	{
		device := vulkanInstance.device;

		postProcess := new PostProcessState();
		postProcess.pipeline = FindOrCreateComputePipeline("PostProcess", postProcessSource);

		poolSize := VkDescriptorPoolSize();
		poolSize.type = VkDescriptorType.VK_DESCRIPTOR_TYPE_STORAGE_IMAGE;
		poolSize.descriptorCount = FrameCount;

		poolInfo := VkDescriptorPoolCreateInfo();
		poolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
		poolInfo.poolSizeCount = 1;
		poolInfo.pPoolSizes = poolSize@;
		poolInfo.maxSets = FrameCount;

		CheckResult(
			vkCreateDescriptorPool(device, poolInfo@, null, postProcess.pool@),
			"PostProcessPass Error creating post process descriptor pool"
		);

		for (i .. FrameCount)
		{
			postProcess.frames.frames[i] = PostProcessFrame();

			allocInfo := VkDescriptorSetAllocateInfo();
			allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
			allocInfo.descriptorPool = postProcess.pool;
			allocInfo.descriptorSetCount = 1;
			allocInfo.pSetLayouts = postProcess.pipeline.descSetLayouts[0]@;

			CheckResult(
				vkAllocateDescriptorSets(device, allocInfo@, postProcess.frames.frames[i].set@),
				"PostProcessPass Error allocating post process descriptor set"
			);
		}

		self.data = postProcess;
	},
	::(renderer: VulkanRenderer, self: *VulkanRenderPass)
	{
		postProcess := self.data as *PostProcessState;
		vkDestroyDescriptorPool(vulkanInstance.device, postProcess.pool, null);
		delete postProcess;
	}
);
