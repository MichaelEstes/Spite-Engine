package VulkanRenderer

import Resource
import SDL
import RenderAssetDef
import ECS

MaxDynamicStates := 8;

enum VulkanAlphaMode: ubyte
{
	Opaque,
	Mask,
	Blend
}

state VulkanPipelineMeshState
{
	assetDefHandle: AssetDefHandle,
	topology: uint16,
	alphaMode: uint16
}

VkPrimitiveTopology VulkanPipelineMeshState::GetTopology() =>
{
	return this.topology as VkPrimitiveTopology;
}

VulkanPipelineMeshState::SetTopology(topology: VkPrimitiveTopology) =>
{
	this.topology = topology as uint16;
}

VulkanAlphaMode VulkanPipelineMeshState::GetAlphaMode() =>
{
	return this.alphaMode as VulkanAlphaMode;
}

VulkanPipelineMeshState::SetAlphaMode(alphaMode: VulkanAlphaMode) =>
{
	this.alphaMode = alphaMode as uint16;
}

uint HashPipelineMeshState(key: VulkanPipelineMeshState)
{
	return MHash<VulkanPipelineMeshState>(key);
}

state VulkanPipelineKey
{
	renderPass: *VkRenderPass_T,
	meshState: VulkanPipelineMeshState
}

VulkanPipelineKey CreatePipelineKey(
	meshState: VulkanPipelineMeshState, 
	renderPass: *VkRenderPass_T
)
{
	key := VulkanPipelineKey();
	key.meshState = meshState;
	key.renderPass = renderPass;

	return key;
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

state VulkanPipelineMap
{
	pipelineMap := Map<VulkanPipelineKey, VulkanPipeline, HashPipelineKey>()
}

VulkanPipeline FindOrCreatePipeline(device: *VkDevice_T, key: VulkanPipelineKey,
									cache: VulkanPipelineMap, layoutCache: VulkanPipelineLayoutCache)
{
	pipeline := cache.pipelineMap.Find(key);
	if (pipeline) 
	{
		return pipeline~;
	}
	
	createdPipeline := CreatePipelineFromKey(device, key, layoutCache);
	cache.pipelineMap.Insert(key, createdPipeline);
	return createdPipeline;
}

VkFormat VariableTypeToVkFormat(kind: VariableType)
{
	switch (kind)
	{
		case (VariableType.Bool)  return VkFormat.VK_FORMAT_R8_UINT;
		case (VariableType.Float) return VkFormat.VK_FORMAT_R32_SFLOAT;
		case (VariableType.Int)   return VkFormat.VK_FORMAT_R32_SINT;
		case (VariableType.Uint)  return VkFormat.VK_FORMAT_R32_UINT;
		case (VariableType.BVec2) return VkFormat.VK_FORMAT_R8G8_UINT;
		case (VariableType.BVec3) return VkFormat.VK_FORMAT_R8G8B8_UINT;
		case (VariableType.BVec4) return VkFormat.VK_FORMAT_R8G8B8A8_UINT;
		case (VariableType.FVec2) return VkFormat.VK_FORMAT_R32G32_SFLOAT;
		case (VariableType.FVec3) return VkFormat.VK_FORMAT_R32G32B32_SFLOAT;
		case (VariableType.FVec4) return VkFormat.VK_FORMAT_R32G32B32A32_SFLOAT;
		case (VariableType.IVec2) return VkFormat.VK_FORMAT_R32G32_SINT;
		case (VariableType.IVec3) return VkFormat.VK_FORMAT_R32G32B32_SINT;
		case (VariableType.IVec4) return VkFormat.VK_FORMAT_R32G32B32A32_SINT;
		case (VariableType.UVec2) return VkFormat.VK_FORMAT_R32G32_UINT;
		case (VariableType.UVec3) return VkFormat.VK_FORMAT_R32G32B32_UINT;
		case (VariableType.UVec4) return VkFormat.VK_FORMAT_R32G32B32A32_UINT;
	}

	assert false, "VariableTypeToVkFormat unsupported vertex attribute type";
	return VkFormat.VK_FORMAT_UNDEFINED;
}

VkPolygonMode PolygonModeToVk(mode: PolygonMode)
{
	switch (mode)
	{
		case (PolygonMode.Fill)  return VkPolygonMode.VK_POLYGON_MODE_FILL;
		case (PolygonMode.Line)  return VkPolygonMode.VK_POLYGON_MODE_LINE;
		case (PolygonMode.Point) return VkPolygonMode.VK_POLYGON_MODE_POINT;
	}

	return VkPolygonMode.VK_POLYGON_MODE_FILL;
}

VulkanPipeline CreatePipelineFromKey(device: *VkDevice_T, key: VulkanPipelineKey,
									 layoutCache: VulkanPipelineLayoutCache)
{
	meshState := key.meshState;
	depthTestEnable := VkTrue;
	depthWriteEnable := VkTrue;
	depthCompareOp := VkCompareOp.VK_COMPARE_OP_LESS;
	blendState := ColorBlendAttachment();
	assetDef := GetAssetDefWithHandle(meshState.assetDefHandle);

	alphaMode := meshState.GetAlphaMode();
	if (alphaMode == VulkanAlphaMode.Opaque)
	{
		depthWriteEnable = VkFalse;
		depthCompareOp = VkCompareOp.VK_COMPARE_OP_EQUAL;
	}
	else if (alphaMode == VulkanAlphaMode.Blend)
	{
		depthWriteEnable = VkFalse;

		blendState.blendEnable = VkTrue;
		blendState.srcColorBlendFactor = VkBlendFactor.VK_BLEND_FACTOR_SRC_ALPHA;
		blendState.dstColorBlendFactor = VkBlendFactor.VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA;
		blendState.colorBlendOp = VkBlendOp.VK_BLEND_OP_ADD;
		blendState.srcAlphaBlendFactor = VkBlendFactor.VK_BLEND_FACTOR_ONE;
		blendState.dstAlphaBlendFactor = VkBlendFactor.VK_BLEND_FACTOR_ZERO;
		blendState.alphaBlendOp = VkBlendOp.VK_BLEND_OP_ADD;
	}

	shaderHandle := UseAssetDefShader(meshState.assetDefHandle);

	layoutKey := PipelineLayoutKey(meshState.assetDefHandle);
	layout := FindOrCreatePipelineLayout(device, layoutKey, layoutCache);

	attributes := assetDef.vertex.attributes;
	vertexInputBindings := ECS.instance.frameAllocator.AllocArray<VkVertexInputBindingDescription>(attributes.count);
	vertexInputAttributes := ECS.instance.frameAllocator.AllocArray<VkVertexInputAttributeDescription>(attributes.count);

	perVertex := VkVertexInputRate.VK_VERTEX_INPUT_RATE_VERTEX;
	for (i .. attributes.count)
	{
		attr := attributes[i];

		binding := VkVertexInputBindingDescription();
		binding.binding = i;
		binding.stride = attr.def.ValueSize();
		binding.inputRate = perVertex;
		vertexInputBindings[i] = binding;

		attribute := VkVertexInputAttributeDescription();
		attribute.location = i;
		attribute.binding = i;
		attribute.format = VariableTypeToVkFormat(attr.def.kind);
		attribute.offset = 0;
		vertexInputAttributes[i] = attribute;
	}

	builder := VulkanPipelineBuilder()
				.SetShader(shaderHandle)
				.SetVertexInput(
					vertexInputBindings,
					vertexInputAttributes,
				)
				.SetInputAssembly(meshState.GetTopology())
				.SetViewportState(1, 1)
				.SetRasterizer(
					VkFalse,
					VkFalse,
					PolygonModeToVk(assetDef.fragment.polygonMode),
					1.0,
					VkCullModeFlagBits.VK_CULL_MODE_NONE
				)
				.SetMultisampling()
				.SetDepthStencil(depthTestEnable, depthWriteEnable, depthCompareOp)
				.SetColorBlend(
					VkPipelineColorBlendAttachmentState:[blendState,]
				)
				.AddDynamicState(VkDynamicState.VK_DYNAMIC_STATE_VIEWPORT)
				.AddDynamicState(VkDynamicState.VK_DYNAMIC_STATE_SCISSOR)
				.AddDynamicState(VkDynamicState.VK_DYNAMIC_STATE_CULL_MODE)
				.AddDynamicState(VkDynamicState.VK_DYNAMIC_STATE_VERTEX_INPUT_BINDING_STRIDE)
				.SetPipelineLayout(layout);

	return builder.Create(device, key.renderPass, 0);
}

VulkanPipeline CreateDepthPipelineFromKey(device: *VkDevice_T, key: VulkanPipelineKey,
										  layoutCache: VulkanPipelineLayoutCache)
{
	meshState := key.meshState;
	assetDef := GetAssetDefWithHandle(meshState.assetDefHandle);

	shaderHandle := UseAssetDefShader(meshState.assetDefHandle);

	layoutKey := PipelineLayoutKey(meshState.assetDefHandle, VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT);
	layout := FindOrCreatePipelineLayout(device, layoutKey, layoutCache);

	attributes := assetDef.vertex.attributes;
	vertexInputBindings := ECS.instance.frameAllocator.AllocArray<VkVertexInputBindingDescription>(attributes.count);
	vertexInputAttributes := ECS.instance.frameAllocator.AllocArray<VkVertexInputAttributeDescription>(attributes.count);

	perVertex := VkVertexInputRate.VK_VERTEX_INPUT_RATE_VERTEX;
	for (i .. attributes.count)
	{
		attr := attributes[i];

		binding := VkVertexInputBindingDescription();
		binding.binding = i;
		binding.stride = attr.def.ValueSize();
		binding.inputRate = perVertex;
		vertexInputBindings[i] = binding;

		attribute := VkVertexInputAttributeDescription();
		attribute.location = i;
		attribute.binding = i;
		attribute.format = VariableTypeToVkFormat(attr.def.kind);
		attribute.offset = 0;
		vertexInputAttributes[i] = attribute;
	}

	builder := VulkanPipelineBuilder()
				.SetShader(shaderHandle)
				.SetVertexOnly(true)
				.SetVertexInput(
					vertexInputBindings,
					vertexInputAttributes,
				)
				.SetInputAssembly(meshState.GetTopology())
				.SetViewportState(1, 1)
				.SetRasterizer(
					VkFalse,
					VkFalse,
					PolygonModeToVk(assetDef.fragment.polygonMode),
					1.0,
					VkCullModeFlagBits.VK_CULL_MODE_NONE
				)
				.SetMultisampling()
				.SetDepthStencil(VkTrue, VkTrue)
				.AddDynamicState(VkDynamicState.VK_DYNAMIC_STATE_VIEWPORT)
				.AddDynamicState(VkDynamicState.VK_DYNAMIC_STATE_SCISSOR)
				.AddDynamicState(VkDynamicState.VK_DYNAMIC_STATE_CULL_MODE)
				.AddDynamicState(VkDynamicState.VK_DYNAMIC_STATE_VERTEX_INPUT_BINDING_STRIDE)
				.SetPipelineLayout(layout);

	return builder.Create(device, key.renderPass, 0);
}

VulkanPipeline FindOrCreateDepthPipeline(device: *VkDevice_T, key: VulkanPipelineKey,
										 cache: VulkanPipelineMap, layoutCache: VulkanPipelineLayoutCache)
{
	pipeline := cache.pipelineMap.Find(key);
	if (pipeline)
	{
		return pipeline~;
	}

	createdPipeline := CreateDepthPipelineFromKey(device, key, layoutCache);
	cache.pipelineMap.Insert(key, createdPipeline);
	return createdPipeline;
}

state VulkanPipelineBuilder
{
    shaderHandle: ResourceHandle,

	vertexInputBindings: []VkVertexInputBindingDescription,
	vertexInputAttributes: []VkVertexInputAttributeDescription,

	pipelineLayout: *VkPipelineLayout_T,

    inputAssembly: VkPipelineInputAssemblyStateCreateInfo,
    viewportState: VkPipelineViewportStateCreateInfo,
    rasterizer: VkPipelineRasterizationStateCreateInfo,
    multisampling: VkPipelineMultisampleStateCreateInfo,
    depthStencil: VkPipelineDepthStencilStateCreateInfo,
    colorBlend: VkPipelineColorBlendStateCreateInfo,
    dynamicStates: [MaxDynamicStates]VkDynamicState,

	dynamicStateCount: uint32,
	vertexOnly: bool,
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

ref VulkanPipelineBuilder VulkanPipelineBuilder::SetShader(shaderHandle: ResourceHandle)
{
	this.shaderHandle = shaderHandle;
	return this;
}

ref VulkanPipelineBuilder VulkanPipelineBuilder::SetVertexOnly(vertexOnly: bool)
{
	this.vertexOnly = vertexOnly;
	return this;
}

ref VulkanPipelineBuilder VulkanPipelineBuilder::SetVertexInput(
	vertexInputBindings: []VkVertexInputBindingDescription
	vertexInputAttributes: []VkVertexInputAttributeDescription
)
{
	this.vertexInputBindings = vertexInputBindings;
	this.vertexInputAttributes = vertexInputAttributes;

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
	pipeline := VulkanPipeline();

	shaderStages := [2]VkPipelineShaderStageCreateInfo;
	shaderCount := 0;
	if (this.shaderHandle.id)
	{
		shaderRes := ShaderResourceManager.GetResource(this.shaderHandle).data;
		shaderStages[0] = shaderRes.vertex.shaderStageInfo;
		shaderCount = 1;

		if (!this.vertexOnly)
		{
			shaderStages[1] = shaderRes.fragment.shaderStageInfo;
			shaderCount = 2;
		}
	}

    dynamicState := VkPipelineDynamicStateCreateInfo();
	dynamicState.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO;
	dynamicState.dynamicStateCount = this.dynamicStateCount;
	dynamicState.pDynamicStates = this.dynamicStates[0]@;
	
	vertexInput := VkPipelineVertexInputStateCreateInfo();
	vertexInput.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO;
	vertexInput.vertexBindingDescriptionCount = this.vertexInputBindings.count;
	vertexInput.pVertexBindingDescriptions = this.vertexInputBindings[0]@;
	vertexInput.vertexAttributeDescriptionCount = this.vertexInputAttributes.count;
	vertexInput.pVertexAttributeDescriptions = this.vertexInputAttributes[0]@;

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

*VkPipelineCache_T CreateVkPipelineCache(device: *VkDevice_T, createInfo: VkPipelineCacheCreateInfo)
{
	cache: *VkPipelineCache_T = null;
	vkCreatePipelineCache(device, createInfo@, null, cache@);
	return cache;
}