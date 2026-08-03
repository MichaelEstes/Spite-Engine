package VulkanRenderer

import Math
import Array

state VulkanStagingBuffer
{
	size: uint = 32 * 1024 * 1024,
	buffer: *VkBuffer_T,
	mem: *VkDeviceMemory_T
}

state VulkanBufferCopyRequest
{
	data: *byte,
	size: uint,
	dstBuffer: *VkBuffer_T,
	dstOffset: uint
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

VulkanStagingBuffer::StagedBufferCopyBatched(device: *VkDevice_T, requests: Array<VulkanBufferCopyRequest>,
											  commands: VulkanCommands, queue: *VkQueue_T)
{
	commandBuffer := commands.commandBuffers[0]~;

	beginInfo := VkCommandBufferBeginInfo();
	beginInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
	beginInfo.flags = VkCommandBufferUsageFlagBits.VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;

	submitInfo := VkSubmitInfo();
	submitInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SUBMIT_INFO;
	submitInfo.commandBufferCount = 1;
	submitInfo.pCommandBuffers = commandBuffer@;

	vkBeginCommandBuffer(commandBuffer, beginInfo@);
	stagingOffset := uint(0);

	for (request in requests)
	{
		srcOffset := uint(0);
		toCopy := request.size;

		while (toCopy)
		{
			if (stagingOffset >= this.size)
			{
				vkEndCommandBuffer(commandBuffer);
				CheckResult(vkQueueSubmit(queue, 1, submitInfo@, null), "Error submitting batched staging copy queue");
				CheckResult(vkQueueWaitIdle(queue), "Error waiting for batched staging copy queue");
				vkBeginCommandBuffer(commandBuffer, beginInfo@);
				stagingOffset = 0;
			}

			copySize := Math.UMin(toCopy, this.size - stagingOffset);

			mappedMem: *byte = null;
			vkMapMemory(device, this.mem, stagingOffset, copySize, 0, mappedMem@);
			copy_bytes(mappedMem, request.data + srcOffset, copySize);
			vkUnmapMemory(device, this.mem);

			copyRegion := VkBufferCopy();
			copyRegion.srcOffset = stagingOffset;
			copyRegion.dstOffset = request.dstOffset + srcOffset;
			copyRegion.size = copySize;

			vkCmdCopyBuffer(commandBuffer, this.buffer, request.dstBuffer, 1, copyRegion@);

			stagingOffset += copySize;
			srcOffset += copySize;
			toCopy -= copySize;
		}
	}

	vkEndCommandBuffer(commandBuffer);

	CheckResult(vkQueueSubmit(queue, 1, submitInfo@, null), "Error submitting batched staging copy queue");
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
