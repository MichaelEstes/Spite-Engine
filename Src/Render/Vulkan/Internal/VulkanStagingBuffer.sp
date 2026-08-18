package VulkanRenderer

import Math

UpdateBufferCopy(commandBuffer: *VkCommandBuffer_T, dstBuffer: *VkBuffer_T, 
				 data: *byte, size: uint, dstOffset: uint = 0)
{
	assert (size % 4) == 0, "size must be a multiple of 4";
	assert (dstOffset % 4) == 0, "dstOffset must be a multiple of 4";
	
	UpdateBufferMaxSize: uint = 65536;

	srcOffset := uint(0);
	toCopy := size;

	while (toCopy)
	{
		copySize := Math.UMin(toCopy, UpdateBufferMaxSize);
		vkCmdUpdateBuffer(commandBuffer, dstBuffer, dstOffset + srcOffset, copySize, data + srcOffset);

		srcOffset += copySize;
		toCopy -= copySize;
	}
}

state VulkanStagingBuffer
{
	size: uint = 32 * 1024 * 1024,
	buffer: *VkBuffer_T,
	mem: *VkDeviceMemory_T
}

state VulkanStagingBatch
{
	commandBuffer: *VkCommandBuffer_T,
	beginInfo: VkCommandBufferBeginInfo,
	submitInfo: VkSubmitInfo,
	stagingOffset: uint
}

VulkanStagingBuffer::Create(device: *VkDevice_T, physicalDevice: *VkPhysicalDevice_T)
{
	createInfo := VkBufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.usage = VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_SRC_BIT;
	createInfo.size = this.size;
	createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

	this.buffer = CreateVkBuffer(device, createInfo);

	memRequirements := VkMemoryRequirements();
    vkGetBufferMemoryRequirements(device, this.buffer, memRequirements@);

	props := VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT |
			 VkMemoryPropertyFlagBits.VK_MEMORY_PROPERTY_HOST_COHERENT_BIT;

    allocInfo := VkMemoryAllocateInfo();
    allocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO;
    allocInfo.allocationSize = memRequirements.size;
    allocInfo.memoryTypeIndex = FindMemoryType(physicalDevice, memRequirements.memoryTypeBits, props);

    CheckResult(
		vkAllocateMemory(device, allocInfo@, null, this.mem@),
		"Error allocating staging buffer"
    );

    vkBindBufferMemory(device, this.buffer, this.mem, 0);
}

VulkanStagingBuffer::StagedBufferCopy(device: *VkDevice_T, data: *byte, size: uint,
									  dstBuffer: *VkBuffer_T, commands: VulkanCommands,
									  queue: *VkQueue_T, dstOffset: uint = 0)
{
	commandBuffer := commands.commandBuffers[0]~;
	beginInfo := VkCommandBufferBeginInfo();
	beginInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
    beginInfo.flags = VkCommandBufferUsageFlagBits.VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;

	submitInfo := VkSubmitInfo();
    submitInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SUBMIT_INFO;
    submitInfo.commandBufferCount = 1;
    submitInfo.pCommandBuffers = commandBuffer@;

	srcOffset := uint(0);
	toCopy := size;

	while (toCopy)
	{
		copySize := Math.UMin(toCopy, this.size);

		mappedMem: *byte = null;
		vkMapMemory(device, this.mem, 0, copySize, 0, mappedMem@);
		copy_bytes(mappedMem, data + srcOffset, copySize);
		vkUnmapMemory(device, this.mem);

		copyRegion := VkBufferCopy();
		copyRegion.srcOffset = 0;
		copyRegion.size = copySize;
		copyRegion.dstOffset = dstOffset + srcOffset;

		vkBeginCommandBuffer(commandBuffer, beginInfo@);
		vkCmdCopyBuffer(commandBuffer, this.buffer, dstBuffer, 1, copyRegion@);
		vkEndCommandBuffer(commandBuffer);

		CheckResult(
			vkQueueSubmit(queue, 1, submitInfo@, null),
			"Error submitting staging copy queue"
		);

		CheckResult(
			vkQueueWaitIdle(queue),
			"Error waiting for staging copy queue"
		);

		srcOffset += copySize;
		toCopy -= copySize;
	}
}

VulkanStagingBuffer::BeginBatch(batch: *VulkanStagingBatch, commands: VulkanCommands)
{
	batch.commandBuffer = commands.commandBuffers[0]~;

	batch.beginInfo = VkCommandBufferBeginInfo();
	batch.beginInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
	batch.beginInfo.flags = VkCommandBufferUsageFlagBits.VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;

	batch.submitInfo = VkSubmitInfo();
	batch.submitInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SUBMIT_INFO;
	batch.submitInfo.commandBufferCount = 1;
	batch.submitInfo.pCommandBuffers = batch.commandBuffer@;

	batch.stagingOffset = 0;

	vkBeginCommandBuffer(batch.commandBuffer, batch.beginInfo@);
}

VulkanStagingBuffer::BatchCopy(batch: *VulkanStagingBatch, device: *VkDevice_T, data: *byte, size: uint,
							   dstBuffer: *VkBuffer_T, queue: *VkQueue_T, dstOffset: uint = 0)
{
	srcOffset := uint(0);
	toCopy := size;

	while (toCopy)
	{
		if (batch.stagingOffset >= this.size)
		{
			vkEndCommandBuffer(batch.commandBuffer);
			CheckResult(vkQueueSubmit(queue, 1, batch.submitInfo@, null), "Error submitting batched staging copy queue");
			CheckResult(vkQueueWaitIdle(queue), "Error waiting for batched staging copy queue");
			vkBeginCommandBuffer(batch.commandBuffer, batch.beginInfo@);
			batch.stagingOffset = 0;
		}

		copySize := Math.UMin(toCopy, this.size - batch.stagingOffset);

		mappedMem: *byte = null;
		vkMapMemory(device, this.mem, batch.stagingOffset, copySize, 0, mappedMem@);
		copy_bytes(mappedMem, data + srcOffset, copySize);
		vkUnmapMemory(device, this.mem);

		copyRegion := VkBufferCopy();
		copyRegion.srcOffset = batch.stagingOffset;
		copyRegion.dstOffset = dstOffset + srcOffset;
		copyRegion.size = copySize;

		vkCmdCopyBuffer(batch.commandBuffer, this.buffer, dstBuffer, 1, copyRegion@);

		batch.stagingOffset += copySize;
		srcOffset += copySize;
		toCopy -= copySize;
	}
}

VulkanStagingBuffer::EndBatch(batch: *VulkanStagingBatch, queue: *VkQueue_T)
{
	vkEndCommandBuffer(batch.commandBuffer);

	CheckResult(vkQueueSubmit(queue, 1, batch.submitInfo@, null), "Error submitting batched staging copy queue");
	CheckResult(vkQueueWaitIdle(queue), "Error waiting for batched staging copy queue");
}

VulkanStagingBuffer::StagedImageCopy(device: *VkDevice_T, data: *byte, size: uint,
									 dstImage: *VkImage_T, width: uint32, height: uint32,
									 commands: VulkanCommands, queue: *VkQueue_T)
{
	assert size < this.size, "VulkanStagingBuffer::StagedImageCopy Image to large for staging buffer";
	commandBuffer := commands.commandBuffers[0]~;
	beginInfo := VkCommandBufferBeginInfo();
	beginInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
    beginInfo.flags = VkCommandBufferUsageFlagBits.VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;

    vkBeginCommandBuffer(commandBuffer, beginInfo@);
	{
		mappedMem: *byte = null;
		vkMapMemory(device, this.mem, 0, size, 0, mappedMem@);
		copy_bytes(mappedMem, data, size);
		vkUnmapMemory(device, this.mem);
        
		region := VkBufferImageCopy();
		region.bufferOffset = 0;
		region.bufferRowLength = 0;
		region.bufferImageHeight = 0;

		region.imageSubresource.aspectMask = VkImageAspectFlagBits.VK_IMAGE_ASPECT_COLOR_BIT;
		region.imageSubresource.mipLevel = 0;
		region.imageSubresource.baseArrayLayer = 0;
		region.imageSubresource.layerCount = 1;

		region.imageOffset = {int32(0), int32(0), int32(0)};
		region.imageExtent = {width, height, uint32(1)};

		vkCmdCopyBufferToImage(
			commandBuffer,
			this.buffer,
			dstImage,
			VkImageLayout.VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL,
			1,
			region@
		);
	}
    vkEndCommandBuffer(commandBuffer);

	submitInfo := VkSubmitInfo();
    submitInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SUBMIT_INFO;
    submitInfo.commandBufferCount = 1;
    submitInfo.pCommandBuffers = commandBuffer@;

	CheckResult(
		vkQueueSubmit(queue, 1, submitInfo@, null),
		"Error submitting staging image copy queue"
    );

	CheckResult(
		vkQueueWaitIdle(queue),
		"Error waiting for staging image copy queue"
    );
}
