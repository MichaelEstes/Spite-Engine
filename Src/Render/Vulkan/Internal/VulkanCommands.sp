package VulkanRenderer

state VulkanCommands
{
	commandPool: *VkCommandPool_T,
	commandBuffers: Allocator<*VkCommandBuffer_T>,
	bufferCount: uint32
}

VulkanCommands::Create(device: *VkDevice_T, poolQueueIndex: uint32, bufferCount: uint32)
{
	commandPoolInfo := VkCommandPoolCreateInfo();
	commandPoolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO;
	commandPoolInfo.flags = VkCommandPoolCreateFlagBits.VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT;
	commandPoolInfo.queueFamilyIndex = poolQueueIndex;

	CheckResult(
		vkCreateCommandPool(device, commandPoolInfo@, null, this.commandPool@),
		"Error creating command pool"
	);

	this.commandBuffers.Alloc(bufferCount);
	this.bufferCount = bufferCount;

	commandBufferAllocateInfo := VkCommandBufferAllocateInfo();
	commandBufferAllocateInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
	commandBufferAllocateInfo.commandPool = this.commandPool;
	commandBufferAllocateInfo.commandBufferCount = bufferCount;
	commandBufferAllocateInfo.level = VkCommandBufferLevel.VK_COMMAND_BUFFER_LEVEL_PRIMARY;

	CheckResult(
		vkAllocateCommandBuffers(device, commandBufferAllocateInfo@, this.commandBuffers[0]),
		"Error allocating command buffer"
	);
}
