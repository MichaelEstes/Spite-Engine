package VulkanRenderer

state VulkanRenderPass
{
	device: *VkDevice_T,
	renderPass: *VkRenderPass_T,
	attachments: Array<VkAttachmentDescription>,
	attachmentRefs: Array<VkAttachmentReference>,
	subpasses: Array<VkSubpassDescription>,
	dependecies: Array<VkSubpassDependency>
}

VulkanRenderPass::delete
{
	delete this.attachments;
	delete this.attachmentRefs;

	for (subpass in this.subpasses)
	{
		delete subpass.pColorAttachments;
		delete subpass.pInputAttachments;
		delete subpass.pResolveAttachments;
		delete subpass.pPreserveAttachments;
	}
	delete this.subpasses;

	delete this.dependecies;

	vkDestroyRenderPass(this.device, this.renderPass, null);
}

ref VulkanRenderPass VulkanRenderPass::AddAttachment(format: VkFormat, samples: VkSampleCountFlagBits,
									loadOp: VkAttachmentLoadOp, storeOp: VkAttachmentStoreOp,
									initialLayout: VkImageLayout, finalLayout: VkImageLayout,
									refLayout: VkImageLayout)
{
	attachment := VkAttachmentDescription();
	attachment.format = format;
	attachment.samples = samples;
	attachment.loadOp = loadOp;
	attachment.storeOp = storeOp;
	attachment.initialLayout = initialLayout;
	attachment.finalLayout = finalLayout;

	index := this.attachments.Add(attachment);

	attachmentRef := VkAttachmentReference();
	attachmentRef.attachment = index;
	attachmentRef.layout = refLayout;

	this.attachmentRefs.Add(attachmentRef);

	return this;
}

ref VulkanRenderPass VulkanRenderPass::AddSubpass(pipelineBindPoint: VkPipelineBindPoint, 
								 colorAttachmentIndicies: []uint32,
								 depthAttachmentIndex: *uint32 = null,
								 inputAttachmentIndicies: []uint32 = []uint32,
								 resolveAttachmentIndicies: []uint32 = []uint32,
								 preserveAttachmentIndicies: []uint32 = []uint32)
{
	subpass := VkSubpassDescription();
	subpass.pipelineBindPoint = pipelineBindPoint;

	subpass.colorAttachmentCount = colorAttachmentIndicies.count;
	colorAttachments := Array<VkAttachmentReference>();
	for (colorIndex in colorAttachmentIndicies)
	{
		colorAttachments.Add(this.attachmentRefs[colorIndex]);
	}
	subpass.pColorAttachments = colorAttachments[0]@;
	
	if (depthAttachmentIndex)
	{
		subpass.pDepthStencilAttachment = this.attachmentRefs[depthAttachmentIndex~]@;
	}

	subpass.inputAttachmentCount = inputAttachmentIndicies.count;
	inputAttachments := Array<VkAttachmentReference>();
	for (inputIndex in inputAttachmentIndicies)
	{
		inputAttachments.Add(this.attachmentRefs[inputIndex]);
	}
	subpass.pInputAttachments = inputAttachments[0]@;

	resolveAttachments := Array<VkAttachmentReference>();
	for (resolveIndex in resolveAttachmentIndicies)
	{
		resolveAttachments.Add(this.attachmentRefs[resolveIndex]);
	}
	subpass.pResolveAttachments = resolveAttachments[0]@;

	subpass.preserveAttachmentCount = preserveAttachmentIndicies.count;
	preserveAttachments := Array<uint32>();
	for (preserveIndex in preserveAttachmentIndicies)
	{
		preserveAttachments.Add(preserveIndex);
	}
	subpass.pPreserveAttachments = preserveAttachments[0]@;


	this.subpasses.Add(subpass);
	return this;
}

ref VulkanRenderPass VulkanRenderPass::AddDependency(srcSubpass: uint32, dstSubpass: uint32,
								 	srcStageMask: uint32, dstStageMask: uint32,
								 	srcAccessMask: uint32, dstAccessMask: uint32,
								 	dependencyFlags: uint32)
{
	dependency := VkSubpassDependency();
	dependency.srcSubpass = srcSubpass;
	dependency.dstSubpass = dstSubpass;
	dependency.srcStageMask = srcStageMask;
	dependency.dstStageMask = dstStageMask;
	dependency.srcAccessMask = srcAccessMask;
	dependency.dstAccessMask = dstAccessMask;
	dependency.dependencyFlags = dependencyFlags;

	this.dependecies.Add(dependency);

	return this;
}

ref VulkanRenderPass VulkanRenderPass::Create(renderer: *VulkanRenderer)
{
	this.device = renderer.device.device;

	createInfo := VkRenderPassCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
	createInfo.attachmentCount = this.attachments.count;
	createInfo.pAttachments = this.attachments[0]@;
	createInfo.subpassCount = this.subpasses.count;
	createInfo.pSubpasses = this.subpasses[0]@;
	createInfo.dependencyCount = this.dependecies.count;
	createInfo.pDependencies = this.dependecies[0]@;

	CheckResult(
		vkCreateRenderPass(this.device, createInfo@, null, this.renderPass@),
		"Error creating Vulkan render pass"
	);

	return this;
}
