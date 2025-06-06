package VulkanRenderer

state VulkanFrame
{
	commandPool: *VkCommandPool_T,
	commandBuffer: *VkCommandBuffer_T
}

VulkanFrame::Initialize(renderer: *VulkanRenderer)
{
	commandPoolInfo := VkCommandPoolCreateInfo();
	commandPoolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
	commandPoolInfo.flags = VkCommandPoolCreateFlagBits.VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
	commandPoolInfo.queueFamilyIndex = renderer.device.queues.graphicsQueueIndex;

	CheckResult(
		vkCreateCommandPool(renderer.device.device, commandPoolInfo@, null, this.commandPool@),
		"Error creating command pool"
	);

	commandBufferAllocateInfo := VkCommandBufferAllocateInfo();
	commandBufferAllocateInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
	commandBufferAllocateInfo.commandPool = this.commandPool;
	commandBufferAllocateInfo.commandBufferCount = 1;
	commandBufferAllocateInfo.level = VkCommandBufferLevel.VK_COMMAND_BUFFER_LEVEL_PRIMARY;

	CheckResult(
		vkAllocateCommandBuffers(renderer.device.device, commandBufferAllocateInfo@, this.commandBuffer@),
		"Error allocating command buffer"
	);

	log "Initialized Vulkan frame";
}
