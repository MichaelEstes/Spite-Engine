package VulkanRenderer

import RenderCommon

state VulkanRenderPassCache
{
	renderPassMap := Map<RenderPass, *VkRenderPass_T, 
						 HashRenderPass, RenderPassEquals>()
}

*VkRenderPass_T CreateVulkanRenderPass(device: *VkDevice_T, createInfo: VkRenderPassCreateInfo)
{
	renderPass: *VkRenderPass_T = null;
	CheckResult(
		vkCreateRenderPass(device, createInfo@, null, renderPass@),
		"Error creating Vulkan render pass"
	);

	return renderPass;
}

*VkRenderPass_T FindOrCreateRenderPass(renderPass: RenderPass, cache: VulkanRenderPassCache, 
									   device: *VkDevice_T)
{
	if (cache.renderPassMap.Has(renderPass))
	{
		log "Using cached render pass";
		return cache.renderPassMap.Find(renderPass)~;
	}

	createInfo := VkRenderPassCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
	createInfo.attachmentCount = renderPass.attachments.count;

	attachments := [8]VkAttachmentDescription;
	for (i .. createInfo.attachmentCount)
	{
		attachment := renderPass.attachments[i];

		vkAttachment := VkAttachmentDescription();
		vkAttachment.format = GPUTextureFormatToVkFormat(attachment.format);
		vkAttachment.samples = GPUTextureSamplesToVkSamples(attachment.samples);
		vkAttachment.loadOp = attachment.load;
		vkAttachment.storeOp = attachment.store;
		vkAttachment.stencilLoadOp = attachment.stencilLoad;
		vkAttachment.stencilStoreOp = attachment.stencilStore;
		vkAttachment.initialLayout = GPUTextureLayoutToVkLayout(attachment.fromLayout);
		vkAttachment.finalLayout = GPUTextureLayoutToVkLayout(attachment.toLayout);

		attachments[i] = vkAttachment;
	}
	createInfo.pAttachments = fixed attachments;
	createInfo.subpassCount = 1;

	subpass := renderPass.subpass;
	subpassDesc := VkSubpassDescription();
	subpassDesc.inputAttachmentCount = subpass.inputAttachments.count;
	subpassDesc.colorAttachmentCount = subpass.colorAttachments.count;

	inputAttachments := [8]VkAttachmentReference;
	colorAttachments := [8]VkAttachmentReference;

	toVkAttachmentRef := ::VkAttachmentReference(attachmentRef: AttachmentRef) {
		vkRef := VkAttachmentReference();
		vkRef.attachment = attachmentRef.attachmentIndex;
		vkRef.layout = GPUTextureLayoutToVkLayout(attachmentRef.layout);
		return vkRef;
	}

	for (i .. subpassDesc.inputAttachmentCount)
	{
		inputAttachments[i] = toVkAttachmentRef(subpass.inputAttachments[i]);
	}

	for (i .. subpassDesc.colorAttachmentCount)
	{
		colorAttachments[i] = toVkAttachmentRef(subpass.colorAttachments[i]);
	}

	subpassDesc.pInputAttachments = fixed inputAttachments;
	subpassDesc.pColorAttachments = fixed colorAttachments;

	depthStencilAttachment := toVkAttachmentRef(subpass.depthStencilAttachment);
	if (subpass.depthStencilAttachment.attachmentIndex != InvalidAttchmentIndex)
	{
		subpassDesc.pDepthStencilAttachment = depthStencilAttachment@;
	}

	createInfo.pSubpasses = subpassDesc@;

	vkRenderPass := CreateVulkanRenderPass(device, createInfo);
	if (vkRenderPass)
	{
		cache.renderPassMap.Insert(renderPass, vkRenderPass);
	}

	return vkRenderPass;
}
