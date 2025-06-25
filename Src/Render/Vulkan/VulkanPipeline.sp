package VulkanRenderer

state VulkanPipeline
{
	device: *VkDevice_T,
	pipeline: *VkPipeline_T,
	layout: *VkPipelineLayout_T,

    shaders: Array<VulkanShader>,

    vertexInput: VkPipelineVertexInputStateCreateInfo,
    inputAssembly: VkPipelineInputAssemblyStateCreateInfo,
    viewportState: VkPipelineViewportStateCreateInfo,
    rasterizer: VkPipelineRasterizationStateCreateInfo,
    multisampling: VkPipelineMultisampleStateCreateInfo,
    depthStencil: VkPipelineDepthStencilStateCreateInfo,
    colorBlend: VkPipelineColorBlendStateCreateInfo,
    dynamicStates: Array<VkDynamicState>
}

VulkanPipeline::delete
{
	delete this.shaders;
	delete this.dynamicStates;

	vkDestroyPipeline(this.device, this.pipeline, null);
	vkDestroyPipelineLayout(this.device, this.layout, null);
}

VulkanPipeline::(renderer: *VulkanRenderer)
{
    this.device = renderer.device.device;

	this.vertexInput = VkPipelineVertexInputStateCreateInfo();
	this.vertexInput.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;

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

ref VulkanPipeline VulkanPipeline::AddShader(renderer: *VulkanRenderer, file: string, stage: VkShaderStageFlagBits,
					                         entry: string = "main")
{
	shader := VulkanShader();
	shader.Create(renderer, file, stage, entry);
	this.shaders.Add(shader);

	return this;
}

ref VulkanPipeline VulkanPipeline::SetVertexInput(vertexBindingDescriptions: []*VkVertexInputBindingDescription, 
	                                              vertexAttributeDescriptions: []*VkVertexInputAttributeDescription)
{
	this.vertexInput.vertexBindingDescriptionCount = vertexBindingDescriptions.count;
	this.vertexInput.pVertexBindingDescriptions = vertexBindingDescriptions[0];
	this.vertexInput.vertexAttributeDescriptionCount = vertexAttributeDescriptions.count;
	this.vertexInput.pVertexAttributeDescriptions = vertexAttributeDescriptions[0];

	return this;
}

ref VulkanPipeline VulkanPipeline::SetInputAssembly(topology: VkPrimitiveTopology = VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST,
	                                                primitiveRestartEnable: bool = false)
{
	this.inputAssembly.topology = topology;
	this.inputAssembly.primitiveRestartEnable = primitiveRestartEnable;

	return this;
}

ref VulkanPipeline VulkanPipeline::SetViewportState(viewports: []*VkViewport, scissors: []*VkRect2D)
{
	this.viewportState.viewportCount = viewports.count;
	this.viewportState.pViewports = viewports[0];
	this.viewportState.scissorCount = scissors.count;
	this.viewportState.pScissors = scissors[0];

	return this;
}

ref VulkanPipeline VulkanPipeline::SetRasterizer(depthClampEnable: uint32 = VkFalse,
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

ref VulkanPipeline VulkanPipeline::SetMultisampling(rasterizationSamples: VkSampleCountFlagBits = VkSampleCountFlagBits.VK_SAMPLE_COUNT_1_BIT,
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

ref VulkanPipeline VulkanPipeline::SetDepthStencil(depthTestEnable: uint32 = VkFalse,
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

ref VulkanPipeline VulkanPipeline::SetColorBlend(attachments: []VkPipelineColorBlendAttachmentState,
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

ref VulkanPipeline VulkanPipeline::AddDynamicState(dynamicState: VkDynamicState)
{
	this.dynamicStates.Add(dynamicState);

	return this;
}

ref VulkanPipeline VulkanPipeline::CreatePipelineLayout(setLayouts: []*VkDescriptorSetLayout_T, pushConstantRanges: []VkPushConstantRange = []VkPushConstantRange)
{
    pipelineLayoutInfo := VkPipelineLayoutCreateInfo();
	pipelineLayoutInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
	pipelineLayoutInfo.setLayoutCount = setLayouts.count;
	pipelineLayoutInfo.pSetLayouts = setLayouts[0]@;
	pipelineLayoutInfo.pushConstantRangeCount = pushConstantRanges.count;
	pipelineLayoutInfo.pPushConstantRanges = pushConstantRanges[0]@;

    CheckResult(
		vkCreatePipelineLayout(this.device, pipelineLayoutInfo@, null, this.layout@),
		"Error creating Vulkan pipeline layout"
	);

	return this;
}

ref VulkanPipeline VulkanPipeline::Create(renderPass: VulkanRenderPass, subpass: uint32,
										  basePipelineHandle: *VkPipeline_T = null, basePipelineIndex: int32 = -1)
{
    dynamicState := VkPipelineDynamicStateCreateInfo();
	dynamicState.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO;
	dynamicState.dynamicStateCount = this.dynamicStates.count;
	dynamicState.pDynamicStates = this.dynamicStates[0]@;
	
    shaderStages := Array<VkPipelineShaderStageCreateInfo>();
	defer delete shaderStages;
	for (shader in this.shaders)
	{
		shaderStages.Add(shader.shaderCreateInfo);
	}

	pipelineInfo := VkGraphicsPipelineCreateInfo();
	pipelineInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO;
	
    pipelineInfo.stageCount = shaderStages.count;
	pipelineInfo.pStages = shaderStages[0]@;

	pipelineInfo.pVertexInputState = this.vertexInput@;
	pipelineInfo.pInputAssemblyState = this.inputAssembly@;
	pipelineInfo.pViewportState = this.viewportState@;
	pipelineInfo.pRasterizationState = this.rasterizer@;
	pipelineInfo.pMultisampleState = this.multisampling@;
	pipelineInfo.pDepthStencilState = this.depthStencil@;
	pipelineInfo.pColorBlendState = this.colorBlend@;
	pipelineInfo.pDynamicState = dynamicState@;
	pipelineInfo.layout = this.layout;
	pipelineInfo.renderPass = renderPass.renderPass;
	pipelineInfo.subpass = subpass;
	pipelineInfo.basePipelineHandle = basePipelineHandle; 
	pipelineInfo.basePipelineIndex = basePipelineIndex;

	CheckResult(
		vkCreateGraphicsPipelines(this.device, null, uint32(1), pipelineInfo@, null, this.pipeline@),
		"Error creating Vulkan pipeline"
	);

    return this;
}
