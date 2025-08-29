package VulkanRenderer

import MurmurHash

state VulkanFrameBufferKey
{
	renderPass: *VkRenderPass_T,
	attachments: [8]*VkImageView_T,
	width: uint16,
	height: uint16,
	layers: uint16,
}

state VulkanFrameBufferValue
{
	frameBuffer: *VkFramebuffer_T,
	timestamp: uint,
}

state VulkanFrameBufferCache
{
	frameBufferMap := Map<VulkanFrameBufferKey, *VkFramebuffer_T, HashFrameBufferKey>()
}

uint HashFrameBufferKey(key: VulkanFrameBufferKey)
{
	return MHash<VulkanFrameBufferKey>(key);
}

*VkFramebuffer_T FindOrCreateFramebuffer(renderPass: *VkRenderPass_T, cache: VulkanFrameBufferCache, 
									     device: *VkDevice_T, width: uint16, height: uint16, layers: uint16,
										 attachments: [8]*VkImageView_T)
{
	key := VulkanFrameBufferKey();
	key.renderPass = renderPass;
	key.attachments = attachments;
	key.width = width;
	key.height = height;
	key.layers = layers;

	cachedFrameBuffer := cache.frameBufferMap.Find(key);
	if (cachedFrameBuffer) return cachedFrameBuffer~;

	//log "Creating framebuffer";
	createInfo := VkFramebufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO;
	
	createInfo.renderPass = renderPass;
	createInfo.width = width;
	createInfo.height = height;
	createInfo.layers = layers;

	attachmentCount := 0;
	while (attachmentCount < MaxAttachmentCount && 
		   attachments[attachmentCount] != null) 
	{
		attachmentCount += 1;
	}

	createInfo.attachmentCount = attachmentCount;
	createInfo.pAttachments = fixed attachments;
	
	frameBuffer: *VkFramebuffer_T = null;
	CheckResult(
		vkCreateFramebuffer(device, createInfo@, null, frameBuffer@),
		"Error creating Vulkan frame buffer"
	);

	if (frameBuffer)
	{
		cache.frameBufferMap.Insert(key, frameBuffer);
	}

	return frameBuffer;
}

//VulkanFrameBuffer::Create(device: *VkDevice_T, extent: VkExtent2D, renderPass: VulkanRenderPass, 
//						  attachments: []*VkImageView_T)
//{
//	
//}