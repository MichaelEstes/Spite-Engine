package VulkanRenderPass

import VulkanRenderer
import RenderGraph
import ECS
import Vec
import SparseSet
import UniformBufferObject
import Time
import Math
import Transform

state ColorPassState
{
	pipelineLayout: *VkPipelineLayout_T,
	descriptorSetLayout: *VkDescriptorSetLayout_T,

	descriptorPool: *VkDescriptorPool_T,
	descriptorSets: [FrameCount]*VkDescriptorSet_T,

	uniformBufferHandles: [FrameCount]VulkanAllocHandle,
	uniformBuffersMapped: [FrameCount]*void,

	vertShaderHandle: ResourceHandle,
	fragShaderHandle: ResourceHandle
}

colorStateSet := SparseSet<ColorPassState, 4>();

UpdateColorPassUniformBuffer(currentFrame: uint32, renderer: *VulkanRenderer, colorPassState: ColorPassState) 
{
	time := Time.TicksSinceStart() / 10000000.0;

	width := renderer.swapchain.extent.width;
	height := renderer.swapchain.extent.height;

	ubo := UniformBufferObject();
	ubo.model.Rotate(time * Math.Deg2Rad(90.0), Vec3(0.0, 0.0, 1.0) as Norm<Vec3>);
	ubo.view.LookAt(Vec3(2.0, 2.0, 2.0), Vec3(0.0, 0.0, 0.0), Vec3(0.0, 0.0, 1.0));
	ubo.projection.Perspective(
		Math.Deg2Rad(45.0), 
		width / height as float32, 
		0.1,
		10.0
	);
	ubo.projection[1][1] *= -1;

	copy_bytes(colorPassState.uniformBuffersMapped[currentFrame], ubo@, (#sizeof ubo));
}

VulkanPipelineKey CreateColorPassPipelineKey(meshState: VulkanPipelineMeshState, 
											 renderPass: *VkRenderPass_T,
											 colorPassState: ColorPassState)
{
	key := VulkanPipelineKey();
	key.meshState = meshState;
	key.renderPass = renderPass;
	key.layout = colorPassState.pipelineLayout;
	key.vertexShaderHandle = colorPassState.vertShaderHandle;
	key.fragmentShaderHandle = colorPassState.fragShaderHandle;

	key.vertexInputBindings[0] = {ubyte(0), ubyte(VkVertexInputRate.VK_VERTEX_INPUT_RATE_VERTEX), uint16(#sizeof Vec3)};
	//key.vertexInputBindings[1] = {ubyte(1), ubyte(VkVertexInputRate.VK_VERTEX_INPUT_RATE_VERTEX), uint16(#sizeof Vec3)};
	//key.vertexInputBindings[2] = {ubyte(2), ubyte(VkVertexInputRate.VK_VERTEX_INPUT_RATE_VERTEX), uint16(#sizeof Vec2)};
	
	key.vertexInputAttributes[0] = {ubyte(0), ubyte(0), uint16(VkFormat.VK_FORMAT_R32G32B32_SFLOAT), uint32(0)};
	//key.vertexInputAttributes[1] = {ubyte(1), ubyte(1), uint16(VkFormat.VK_FORMAT_R32G32B32_SFLOAT), uint32(0)};
	//key.vertexInputAttributes[2] = {ubyte(2), ubyte(2), uint16(VkFormat.VK_FORMAT_R32G32_SFLOAT), uint32(0)};

	return key;
}

colorPassName := "ColorPass";
colorPass := RegisterRenderPass(
	colorPassName,
	::(graph: RenderGraph<VulkanRenderer>, scene: *Scene) 
	{
		graph.AddPass(
			colorPassName,
			::bool(builder: *RenderPassBuilder<VulkanRenderer>, scene: *Scene) 
			{
				//log "Vulkan Color pass init";
				renderer := builder.Renderer();
				builder.Read(renderer.swapchainHandle);
				builder.Write(renderer.swapchainHandle);

				return true;
			},
			::(context: *RenderPassContext<VulkanRenderer>, scene: *Scene) 
			{
				//log "Vulkan Color pass exec";

				renderer := context.renderer;
				device := renderer.device;
				colorPassState := colorStateSet.Get(renderer.deviceIndex)~;
				renderPass := renderer.CastDriverRenderPass(context.driverRenderpass);
				allocator := renderer.allocator;
				frame := renderer.Frame();

				commandBuffer := renderer.GetCommandBuffer(CommandBufferKind.Graphics);

				pipelineMeshMap := meshGroupsByScene.Get(scene.id);
				for (kv in pipelineMeshMap)
				{
					pipelineMeshState := kv.key~;
					meshArr := kv.value~;

					pipelineKey := CreateColorPassPipelineKey(pipelineMeshState, renderPass, colorPassState);
					vulkanPipeline := FindOrCreatePipeline(
						device,
						pipelineKey, 
						renderer.pipelineCache~
					);
					pipeline := vulkanPipeline.pipeline;
					pipelineLayout := vulkanPipeline.layout;

					vkCmdBindPipeline(
						commandBuffer, 
						VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS, 
						pipeline
					);
					renderer.SetViewportAndScissor(commandBuffer);

					for (mesh in meshArr)
					{
						entity := mesh.entity;
						geo := mesh.geometry;

						transform := scene.GetComponentDirect<Transform>(entity, TransformComponent);

						log "Transform: ", transform;

						vertexAlloc := allocator.GetAllocation(geo.vertexHandle);
						indexAlloc := allocator.GetAllocation(geo.indexHandle);

						UpdateColorPassUniformBuffer(frame, renderer, colorPassState);

						vertexBuffers := [vertexAlloc.buffer,];
						offsets:= [uint64(0),];
						vkCmdBindVertexBuffers(
							commandBuffer, 
							uint32(0), 
							uint32(1), 
							fixed vertexBuffers, 
							fixed offsets
						);
						
						if (indexAlloc)
						{
							vkCmdBindIndexBuffer(commandBuffer, indexAlloc.buffer, 0, geo.indexKind);
						}

						vkCmdBindDescriptorSets(
							commandBuffer, 
							VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS, 
							pipelineLayout, 
							uint32(0), 
							uint32(1), 
							colorPassState.descriptorSets[frame]@, 
							uint32(0), 
							null
						);
						
						if (indexAlloc)
						{
							indexCount := indexAlloc.size / indexKindToByteCount[geo.indexKind];
							vkCmdDrawIndexed(commandBuffer, indexCount, uint32(1), uint32(0), uint32(0), uint32(0));
						}
						else
						{
						
						}
					}

					log "End Color Pass";
				}

			},
			RenderPassStage.Graphics,
			scene
		);
	},
	::(renderer: VulkanRenderer) 
	{
		log "Color pass added";

		deviceIndex := renderer.deviceIndex;

		if (colorStateSet.Has(deviceIndex)) return;

		device := renderer.device;
		allocator := renderer.allocator;

		colorPassState := ColorPassState();
		colorPassState.vertShaderHandle = UseShader(device, "./Resource/Shaders/Compiled/vert.spv", GPUShaderStage.VERTEX);
		colorPassState.fragShaderHandle = UseShader(device, "./Resource/Shaders/Compiled/frag.spv", GPUShaderStage.FRAGMENT);

		InitializeColorPassDescriptorSetLayout(device, colorPassState);
		InitializeColorPassPipelineLayout(device, colorPassState);
		InitializeColorPassUniformBuffers(device, allocator, colorPassState);
		InitializeColorPassDescriptorSets(device, allocator, colorPassState);

		colorStateSet.Insert(deviceIndex, colorPassState);
	}
);

InitializeColorPassDescriptorSetLayout(device: *VkDevice_T, colorPassState: ColorPassState) =>
{
	uboLayoutBinding := VkDescriptorSetLayoutBinding();
	uboLayoutBinding.binding = 0;
	uboLayoutBinding.descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
	uboLayoutBinding.descriptorCount = 1;
	uboLayoutBinding.stageFlags = VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT;
	uboLayoutBinding.pImmutableSamplers = null; // Optional

	samplerLayoutBinding := VkDescriptorSetLayoutBinding();
	samplerLayoutBinding.binding = 1;
	samplerLayoutBinding.descriptorCount = 1;
	samplerLayoutBinding.descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
	samplerLayoutBinding.pImmutableSamplers = null;
	samplerLayoutBinding.stageFlags = VkShaderStageFlagBits.VK_SHADER_STAGE_FRAGMENT_BIT;

	bindings := [uboLayoutBinding, samplerLayoutBinding];
	layoutInfo := VkDescriptorSetLayoutCreateInfo();
	layoutInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
	layoutInfo.bindingCount = 2;
	layoutInfo.pBindings = fixed bindings;
	
	CheckResult(
		vkCreateDescriptorSetLayout(device, layoutInfo@, null, colorPassState.descriptorSetLayout@),
		"ColorPass::Init Error creating Vulkan descriptor set layout"
	);
}

InitializeColorPassPipelineLayout(device: *VkDevice_T, colorPassState: ColorPassState) =>
{
	pipelineLayoutInfo := VkPipelineLayoutCreateInfo();
	pipelineLayoutInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
	pipelineLayoutInfo.setLayoutCount = uint32(1);
	pipelineLayoutInfo.pSetLayouts = colorPassState.descriptorSetLayout@;
	//pipelineLayoutInfo.pushConstantRangeCount = uint32(0);
	//pipelineLayoutInfo.pPushConstantRanges = null;

	CheckResult(
		vkCreatePipelineLayout(device, pipelineLayoutInfo@, null, colorPassState.pipelineLayout@),
		"ColorPass::Init Error creating Vulkan pipeline layout"
	);
}

InitializeColorPassUniformBuffers(device: *VkDevice_T, allocator: *VulkanAllocator, 
								  colorPassState: ColorPassState) =>
{
	bufferSize := #sizeof UniformBufferObject;

	for (i .. FrameCount)
	{
		createInfo := VkBufferCreateInfo();
		createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
		createInfo.usage = VkBufferUsageFlagBits.VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT;
		createInfo.size = bufferSize;
		createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

		buf := CreateVkBuffer(device, createInfo);
		bufHandle := allocator.AllocBuffer(
			buf, 
			VulkanMemoryFlags.Shared | VulkanMemoryFlags.Coherent | VulkanMemoryFlags.Mapped
		);
		alloc := allocator.GetAllocation(bufHandle);

		colorPassState.uniformBufferHandles[i] = bufHandle;

		block := allocator.GetAllocationBlock(bufHandle);

		colorPassState.uniformBuffersMapped[i] = (block.mappedPtr + alloc.offset);
	}
}

InitializeColorPassDescriptorSets(device: *VkDevice_T, allocator: *VulkanAllocator, 
								  colorPassState: ColorPassState) =>
{
	poolSizes := [VkDescriptorPoolSize(), VkDescriptorPoolSize()];
	poolSizes[0].type = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
	poolSizes[0].descriptorCount = FrameCount;

	poolSizes[1].type = VkDescriptorType.VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
	poolSizes[1].descriptorCount = FrameCount;

	poolInfo := VkDescriptorPoolCreateInfo();
	poolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
	poolInfo.poolSizeCount = 2;
	poolInfo.pPoolSizes = fixed poolSizes;
	poolInfo.maxSets = FrameCount;

	CheckResult(
		vkCreateDescriptorPool(device, poolInfo@, null, colorPassState.descriptorPool@),
		"ColorPass::Init Error allocating Vulkan descriptor pool"
	);

	layouts := [FrameCount]*VkDescriptorSetLayout_T;
	for (i .. FrameCount) layouts[i] = colorPassState.descriptorSetLayout;

	allocInfo := VkDescriptorSetAllocateInfo();
	allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
	allocInfo.descriptorPool = colorPassState.descriptorPool;
	allocInfo.descriptorSetCount = FrameCount;
	allocInfo.pSetLayouts = fixed layouts;

	CheckResult(
		vkAllocateDescriptorSets(device, allocInfo@, fixed colorPassState.descriptorSets),
		"ColorPass::Init Error allocating Vulkan descriptor sets"
	);

	for (i .. FrameCount) 
	{
		uniformBufferHandle := colorPassState.uniformBufferHandles[i];
		uniformBufferAlloc := allocator.GetAllocation(uniformBufferHandle);

		bufferInfo := VkDescriptorBufferInfo();
		bufferInfo.buffer = uniformBufferAlloc.buffer;
		bufferInfo.offset = 0;
		bufferInfo.range = #sizeof UniformBufferObject;

		//imageInfo := VkDescriptorImageInfo();
        //imageInfo.imageLayout = VkImageLayout.VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;
        //imageInfo.imageView = this.textureImageView;
        //imageInfo.sampler = this.textureSampler;

		descriptorWrites := [VkWriteDescriptorSet(), VkWriteDescriptorSet()];

		descriptorWrites[0].sType = VkStructureType.VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
		descriptorWrites[0].dstSet = colorPassState.descriptorSets[i];
		descriptorWrites[0].dstBinding = 0;
		descriptorWrites[0].dstArrayElement = 0;
		descriptorWrites[0].descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
		descriptorWrites[0].descriptorCount = 1;
		descriptorWrites[0].pBufferInfo = bufferInfo@;

		//descriptorWrites[1].sType = VkStructureType.VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET;
        //descriptorWrites[1].dstSet = this.descriptorSets[i];
        //descriptorWrites[1].dstBinding = 1;
        //descriptorWrites[1].dstArrayElement = 0;
        //descriptorWrites[1].descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
        //descriptorWrites[1].descriptorCount = 1;
        //descriptorWrites[1].pImageInfo = imageInfo@;

		vkUpdateDescriptorSets(device, 1, fixed descriptorWrites, 0, null);
    }
}