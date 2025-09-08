package VulkanRenderer

import Resource
import SDL
import BitArray

MaxDynamicStates := 8;
MaxVertexAttributes := 16;

enum GeometryAttributeFlags: uint16
{
	None = 0,
	Tangent = 1 << 0,
    Color = 1 << 1,
    UV0 = 1 << 2,
    UV1 = 1 << 3,
    UV2 = 1 << 4,
    UV3= 1 << 5,
}

state VulkanVertexInputBinding
{
	binding: ubyte,
	inputRate: ubyte,
	stride: uint16
}

bool VulkanVertexInputBinding::Valid()
{
	return this.binding | this.inputRate | this.stride;
}

state VulkanVertexAttributeBinding
{
	location: ubyte,
	binding: ubyte,
	format: uint16,
	offset: uint32,
}

bool VulkanVertexAttributeBinding::Valid()
{
	return this.location | this.binding | this.format | this.offset;
}

state VulkanPipelineMeshState
{
	geometryFlags: GeometryAttributeFlags,
	// size : offset
	// Topology				4 : 0
	// Polygon mode 		2 : 4
	// Alpha mode 			2 : 6
	// Cull mode 			2 : 8
	// Sample count			4 : 10
	// Depth bias enable	1 : 14
	// Depth write enable	1 : 15
	data: BitArray<16>
}

VkPrimitiveTopology VulkanPipelineMeshState::GetTopology() =>
{
	return this.data.Range<VkPrimitiveTopology>(0, 4);
}

VulkanPipelineMeshState::SetTopology(topology: VkPrimitiveTopology) =>
{
	this.data.SetRange<VkPrimitiveTopology>(0, 4, topology);
}

VkPolygonMode VulkanPipelineMeshState::GetPolygonMode() =>
{
	return this.data.Range<VkPolygonMode>(4, 6);
}

VulkanPipelineMeshState::SetPolygonMode(polygonMode: VkPolygonMode) =>
{
	this.data.SetRange<VkPolygonMode>(4, 6, polygonMode);
}

state VulkanPipelineKey
{
	renderPass: *VkRenderPass_T,
	layout: *VkPipelineLayout_T,

	vertexInputBindings := [MaxVertexAttributes]VulkanVertexInputBinding(),
	vertexInputAttributes := [MaxVertexAttributes]VulkanVertexAttributeBinding(),

	meshState: VulkanPipelineMeshState,

	vertexShaderHandle: ResourceHandle,
	fragmentShaderHandle: ResourceHandle,
}

state VulkanPipeline
{
	pipeline: *VkPipeline_T,
	layout: *VkPipelineLayout_T
}

uint HashPipelineKey(key: VulkanPipelineKey)
{
	return MHash<VulkanPipelineKey>(key);
}

state VulkanPipelineCache
{
	pipelineMap := Map<VulkanPipelineKey, VulkanPipeline, HashPipelineKey>()
}

VulkanPipeline FindOrCreatePipeline(device: *VkDevice_T, key: VulkanPipelineKey, cache: VulkanPipelineCache)
{
	pipeline := cache.pipelineMap.Find(key);
	if (pipeline) return pipeline~;
	
	createdPipeline := CreatePipelineFromKey(device, key);
	return createdPipeline;
}

VulkanPipeline CreatePipelineFromKey(device: *VkDevice_T, key: VulkanPipelineKey)
{
	builder := VulkanPipelineBuilder()
				.SetVertexShader(key.vertexShaderHandle)
				.SetFragmentShader(key.fragmentShaderHandle)
				.SetVertexInput(
					key.vertexInputBindings,
					key.vertexInputAttributes,
				)
				.SetInputAssembly(key.meshState.GetTopology())
				.SetRasterizer()
				.SetMultisampling()
				.SetDepthStencil(VkTrue, VkTrue)
				.SetColorBlend(
					VkPipelineColorBlendAttachmentState:[ColorBlendAttachment(),]
				)
				.SetPipelineLayout(key.layout);	
	
	return builder.Create(device, key.renderPass, 0);
}

state VulkanPipelineBuilder
{
    vertexShaderHandle: ResourceHandle,
	fragmentShaderHandle: ResourceHandle,

	vertexInputBindings: [MaxVertexAttributes]VulkanVertexInputBinding,
	vertexInputAttributes: [MaxVertexAttributes]VulkanVertexAttributeBinding,

	pipelineLayout: *VkPipelineLayout_T,

    inputAssembly: VkPipelineInputAssemblyStateCreateInfo,
    viewportState: VkPipelineViewportStateCreateInfo,
    rasterizer: VkPipelineRasterizationStateCreateInfo,
    multisampling: VkPipelineMultisampleStateCreateInfo,
    depthStencil: VkPipelineDepthStencilStateCreateInfo,
    colorBlend: VkPipelineColorBlendStateCreateInfo,
    dynamicStates: [MaxDynamicStates]VkDynamicState,
	
	dynamicStateCount: uint32,
}

VulkanPipelineBuilder::()
{
	this.inputAssembly = VkPipelineInputAssemblyStateCreateInfo();
	this.inputAssembly.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO;

    this.viewportState = VkPipelineViewportStateCreateInfo();
	this.viewportState.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO;

    this.rasterizer = VkPipelineRasterizationStateCreateInfo();
	this.rasterizer.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO;

    this.multisampling = VkPipelineMultisampleStateCreateInfo();
	this.multisampling.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO;

    this.depthStencil = VkPipelineDepthStencilStateCreateInfo();
	this.depthStencil.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_DEPTH_STENCIL_STATE_CREATE_INFO;

    this.colorBlend = VkPipelineColorBlendStateCreateInfo();
	this.colorBlend.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO;
}

ref VulkanPipelineBuilder VulkanPipelineBuilder::SetVertexShader(vertexShaderHandle: ResourceHandle)
{
	this.vertexShaderHandle = vertexShaderHandle;
	return this;
}

ref VulkanPipelineBuilder VulkanPipelineBuilder::SetFragmentShader(fragmentShaderHandle: ResourceHandle)
{
	this.fragmentShaderHandle = fragmentShaderHandle;
	return this;
}

ref VulkanPipelineBuilder VulkanPipelineBuilder::SetVertexInput(
	vertexInputBindings: []VulkanVertexInputBinding
	vertexInputAttributes: []VulkanVertexAttributeBinding
)
{
	assert vertexInputBindings.count <= MaxVertexAttributes, "VulkanPipelineBuilder::SetVertexInput Exceeded max number for vertex input bindings";
	assert vertexInputAttributes.count <= MaxVertexAttributes, "VulkanPipelineBuilder::SetVertexInput Exceeded max number for vertex input attributes";

	for (i .. vertexInputBindings.count)
	{
		this.vertexInputBindings[i] = vertexInputBindings[i];
	}

	for (i .. vertexInputAttributes.count)
	{
		this.vertexInputAttributes[i] = vertexInputAttributes[i];
	}

	return this;
}

ref VulkanPipelineBuilder VulkanPipelineBuilder::SetInputAssembly(topology: VkPrimitiveTopology = VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST,
	                                                primitiveRestartEnable: bool = false)
{
	this.inputAssembly.topology = topology;
	this.inputAssembly.primitiveRestartEnable = primitiveRestartEnable;

	return this;
}

ref VulkanPipelineBuilder VulkanPipelineBuilder::SetViewportState(viewportCount: uint32, scissorCount: uint32,
													viewports: *VkViewport = null, scissors: *VkRect2D = null)
{
	this.viewportState.viewportCount = viewportCount;
	this.viewportState.pViewports = viewports;
	this.viewportState.scissorCount = scissorCount;
	this.viewportState.pScissors = scissors;

	return this;
}

ref VulkanPipelineBuilder VulkanPipelineBuilder::SetRasterizer(depthClampEnable: uint32 = VkFalse,
	                                            rasterizerDiscardEnable: uint32 = VkFalse,
	                                            polygonMode: VkPolygonMode = VkPolygonMode.VK_POLYGON_MODE_FILL,
	                                            lineWidth: float32 = 1.0,
	                                            cullMode: VkCullModeFlagBits = VkCullModeFlagBits.VK_CULL_MODE_BACK_BIT,
	                                            frontFace: VkFrontFace = VkFrontFace.VK_FRONT_FACE_COUNTER_CLOCKWISE,
	                                            depthBiasEnable: uint32 = VkFalse,
	                                            depthBiasConstantFactor: float32 = 0.0,
	                                            depthBiasClamp: float32 = 0.0,
	                                            depthBiasSlopeFactor: float32 = 0.0)
{
	this.rasterizer.depthClampEnable = depthClampEnable;
    this.rasterizer.rasterizerDiscardEnable = rasterizerDiscardEnable;
    this.rasterizer.polygonMode = polygonMode;
    this.rasterizer.lineWidth = lineWidth;
    this.rasterizer.cullMode = cullMode;
    this.rasterizer.frontFace = frontFace;
    this.rasterizer.depthBiasEnable = depthBiasEnable;
    this.rasterizer.depthBiasConstantFactor = depthBiasConstantFactor;
    this.rasterizer.depthBiasClamp = depthBiasClamp;
    this.rasterizer.depthBiasSlopeFactor = depthBiasSlopeFactor;

    return this;
}

ref VulkanPipelineBuilder VulkanPipelineBuilder::SetMultisampling(rasterizationSamples: VkSampleCountFlagBits = VkSampleCountFlagBits.VK_SAMPLE_COUNT_1_BIT,
	                                                sampleShadingEnable: uint32 = VkFalse,
	                                                minSampleShading: float32 = 0.0,
	                                                sampleMask: []uint32 = []uint32,
	                                                alphaToCoverageEnable: uint32 = VkFalse,
                                                    alphaToOneEnable: uint32 = VkFalse)
{
	this.multisampling.rasterizationSamples = rasterizationSamples;
    this.multisampling.sampleShadingEnable = sampleShadingEnable;
    this.multisampling.minSampleShading = minSampleShading;
    this.multisampling.pSampleMask = sampleMask[0]@;
    this.multisampling.alphaToCoverageEnable = alphaToCoverageEnable;
    this.multisampling.alphaToOneEnable = alphaToOneEnable;

    return this;
}

ref VulkanPipelineBuilder VulkanPipelineBuilder::SetDepthStencil(depthTestEnable: uint32 = VkFalse,
	                                               depthWriteEnable: uint32 = VkFalse,
	                                               depthCompareOp: VkCompareOp = VkCompareOp.VK_COMPARE_OP_LESS,
	                                               depthBoundsTestEnable: uint32 = VkFalse,
	                                               stencilTestEnable: uint32 = VkFalse,
	                                               front: VkStencilOpState = VkStencilOpState(),
                                                   back: VkStencilOpState = VkStencilOpState(),
	                                               minDepthBounds: float32 = 0.0,
	                                               maxDepthBounds: float32 = 1.0)
{
	this.depthStencil.depthTestEnable = depthTestEnable;
    this.depthStencil.depthWriteEnable = depthWriteEnable;
    this.depthStencil.depthCompareOp = depthCompareOp;
    this.depthStencil.depthBoundsTestEnable = depthBoundsTestEnable;
    this.depthStencil.stencilTestEnable = stencilTestEnable;
    this.depthStencil.front = front;
    this.depthStencil.back = back;
    this.depthStencil.minDepthBounds = minDepthBounds;
    this.depthStencil.maxDepthBounds = maxDepthBounds;

    return this;
}

ref VulkanPipelineBuilder VulkanPipelineBuilder::SetColorBlend(attachments: []VkPipelineColorBlendAttachmentState,
	                                             logicOpEnable: uint32 = VkFalse,
	                                             logicOp: VkLogicOp = VkLogicOp.VK_LOGIC_OP_COPY,
	                                             blendConstants: [4]float32 = float32:[0.0, 0.0, 0.0, 0.0])
{
	this.colorBlend.logicOpEnable = logicOpEnable;
    this.colorBlend.logicOp = logicOp;
    this.colorBlend.attachmentCount = attachments.count;
    this.colorBlend.pAttachments = attachments[0]@;
    this.colorBlend.blendConstants = blendConstants;

    return this;
}

ref VulkanPipelineBuilder VulkanPipelineBuilder::AddDynamicState(dynamicState: VkDynamicState)
{
	assert this.dynamicStateCount < MaxDynamicStates, "VulkanPipelineBuilder::AddDynamicState Exceed allow dynamicState count";
	this.dynamicStates[this.dynamicStateCount] = dynamicState;
	this.dynamicStateCount += 1;

	return this;
}

ref VulkanPipelineBuilder VulkanPipelineBuilder::SetPipelineLayout(pipelineLayout: *VkPipelineLayout_T)
{
	this.pipelineLayout = pipelineLayout;

	return this;
}

VulkanPipeline VulkanPipelineBuilder::Create(device: *VkDevice_T, renderPass: *VkRenderPass_T, 
											 subpass: uint32)
{
	log "Creating pipeline";
	pipeline := VulkanPipeline();

	shaderStages := [2]VkPipelineShaderStageCreateInfo;
	shaderCount := 0;
	if (this.vertexShaderHandle.id)
	{
		vertShaderRes := ShaderResourceManager.GetResource(this.vertexShaderHandle).data;
		shaderStages[shaderCount] = vertShaderRes.shaderStageInfo;
		shaderCount += 1;
	}
	if (this.fragmentShaderHandle.id)
	{
		fragShaderRes := ShaderResourceManager.GetResource(this.fragmentShaderHandle).data;
		shaderStages[shaderCount] = fragShaderRes.shaderStageInfo;
		shaderCount += 1;
	}

    dynamicState := VkPipelineDynamicStateCreateInfo();
	dynamicState.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO;
	dynamicState.dynamicStateCount = this.dynamicStateCount;
	dynamicState.pDynamicStates = this.dynamicStates[0]@;
	
	bindingDescs := [16]VkVertexInputBindingDescription;
	attributeDescs := [16]VkVertexInputAttributeDescription;
	bindingDescCount := 0;
	attributeDescCount := 0;

	for (i .. MaxVertexAttributes)
	{
		inputBinding := this.vertexInputBindings[i];
		if (!inputBinding.Valid()) break;

		bindingDescs[i].binding = inputBinding.binding;
		bindingDescs[i].stride = inputBinding.stride;
		bindingDescs[i].inputRate = inputBinding.inputRate;
		bindingDescCount += 1;
	}

	for (i .. MaxVertexAttributes)
	{
		inputAttr := this.vertexInputAttributes[i];
		if (!inputAttr.Valid()) break;

		attributeDescs[i].location = inputAttr.location;
		attributeDescs[i].binding = inputAttr.binding;
		attributeDescs[i].format = inputAttr.format;
		attributeDescs[i].offset = inputAttr.offset;
		attributeDescCount += 1;
	}

	vertexInput := VkPipelineVertexInputStateCreateInfo();
	vertexInput.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;
	vertexInput.vertexBindingDescriptionCount = bindingDescCount;
	vertexInput.pVertexBindingDescriptions = fixed bindingDescs;
	vertexInput.vertexAttributeDescriptionCount = attributeDescCount;
	vertexInput.pVertexAttributeDescriptions = fixed attributeDescs;

	pipelineInfo := VkGraphicsPipelineCreateInfo();
	pipelineInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO;
	
    pipelineInfo.stageCount = shaderCount;
	pipelineInfo.pStages = fixed shaderStages;
	pipelineInfo.pVertexInputState = vertexInput@;
	pipelineInfo.pInputAssemblyState = this.inputAssembly@;
	pipelineInfo.pViewportState = this.viewportState@;
	pipelineInfo.pRasterizationState = this.rasterizer@;
	pipelineInfo.pMultisampleState = this.multisampling@;
	pipelineInfo.pDepthStencilState = this.depthStencil@;
	pipelineInfo.pColorBlendState = this.colorBlend@;
	pipelineInfo.pDynamicState = dynamicState@;
	pipelineInfo.layout = this.pipelineLayout;
	pipelineInfo.renderPass = renderPass;
	pipelineInfo.subpass = subpass;
	
	CheckResult(
		vkCreateGraphicsPipelines(device, null, uint32(1), pipelineInfo@, null, pipeline.pipeline@),
		"Error creating Vulkan pipeline"
	);

	pipeline.layout = this.pipelineLayout;
    return pipeline;
}

VkPipelineColorBlendAttachmentState ColorBlendAttachment(colorWriteMask: VkColorComponentFlagBits = VkColorComponentFlagBits.VK_COLOR_COMPONENT_R_BIT | VkColorComponentFlagBits.VK_COLOR_COMPONENT_G_BIT | VkColorComponentFlagBits.VK_COLOR_COMPONENT_B_BIT | VkColorComponentFlagBits.VK_COLOR_COMPONENT_A_BIT,
														 blendEnable: uint32 = VkFalse,
														 srcColorBlendFactor: VkBlendFactor = VkBlendFactor.VK_BLEND_FACTOR_ONE,
														 dstColorBlendFactor: VkBlendFactor = VkBlendFactor.VK_BLEND_FACTOR_ZERO,
														 colorBlendOp: VkBlendOp = VkBlendOp.VK_BLEND_OP_ADD,
														 srcAlphaBlendFactor: VkBlendFactor = VkBlendFactor.VK_BLEND_FACTOR_ONE,
														 dstAlphaBlendFactor: VkBlendFactor = VkBlendFactor.VK_BLEND_FACTOR_ZERO,
														 alphaBlendOp: VkBlendOp = VkBlendOp.VK_BLEND_OP_ADD
														)
{
	colorBlendAttachment := VkPipelineColorBlendAttachmentState();
	colorBlendAttachment.colorWriteMask = colorWriteMask;
	colorBlendAttachment.blendEnable = blendEnable;
	colorBlendAttachment.srcColorBlendFactor = srcColorBlendFactor;
	colorBlendAttachment.dstColorBlendFactor = dstColorBlendFactor;
	colorBlendAttachment.colorBlendOp = colorBlendOp;
	colorBlendAttachment.srcAlphaBlendFactor = srcAlphaBlendFactor;
	colorBlendAttachment.dstAlphaBlendFactor = dstAlphaBlendFactor;
	colorBlendAttachment.alphaBlendOp = alphaBlendOp;

	return colorBlendAttachment;
}