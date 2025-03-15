package Vulkan

extern
{
	VkResult vkCreateInstance(pCreateInfo: *VkInstanceCreateInfo, pAllocator: *VkAllocationCallbacks, pInstance: *VkInstance);
    void vkDestroyInstance(instance: VkInstance, pAllocator: *VkAllocationCallbacks);
    VkResult vkEnumeratePhysicalDevices(instance: VkInstance, pPhysicalDeviceCount: *uint32, pPhysicalDevices: *VkPhysicalDevice);
    void vkGetPhysicalDeviceFeatures(physicalDevice: VkPhysicalDevice, pFeatures: *VkPhysicalDeviceFeatures);
    void vkGetPhysicalDeviceFormatProperties(physicalDevice: VkPhysicalDevice, format: VkFormat, pFormatProperties: *VkFormatProperties);
    VkResult vkGetPhysicalDeviceImageFormatProperties(physicalDevice: VkPhysicalDevice, format: VkFormat, type: VkImageType, tiling: VkImageTiling, usage: VkImageUsageFlags, flags: VkImageCreateFlags, pImageFormatProperties: *VkImageFormatProperties);
    void vkGetPhysicalDeviceProperties(physicalDevice: VkPhysicalDevice, pProperties: *VkPhysicalDeviceProperties);
    void vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice: VkPhysicalDevice, pQueueFamilyPropertyCount: *uint32, pQueueFamilyProperties: *VkQueueFamilyProperties);
    void vkGetPhysicalDeviceMemoryProperties(physicalDevice: VkPhysicalDevice, pMemoryProperties: *VkPhysicalDeviceMemoryProperties);
    PFN_vkVoidFunction vkGetInstanceProcAddr(instance: VkInstance, pName: *byte);
    PFN_vkVoidFunction vkGetDeviceProcAddr(device: VkDevice, pName: *byte);
    VkResult vkCreateDevice(physicalDevice: VkPhysicalDevice, pCreateInfo: *VkDeviceCreateInfo, pAllocator: *VkAllocationCallbacks, pDevice: *VkDevice);
    void vkDestroyDevice(device: VkDevice, pAllocator: *VkAllocationCallbacks);
    VkResult vkEnumerateInstanceExtensionProperties(pLayerName: *byte, pPropertyCount: *uint32, pProperties: *VkExtensionProperties);
    VkResult vkEnumerateDeviceExtensionProperties(physicalDevice: VkPhysicalDevice, pLayerName: *byte, pPropertyCount: *uint32, pProperties: *VkExtensionProperties);
    VkResult vkEnumerateInstanceLayerProperties(pPropertyCount: *uint32, pProperties: *VkLayerProperties);
    VkResult vkEnumerateDeviceLayerProperties(physicalDevice: VkPhysicalDevice, pPropertyCount: *uint32, pProperties: *VkLayerProperties);
    void vkGetDeviceQueue(device: VkDevice, queueFamilyIndex: uint32, queueIndex: uint32, pQueue: *VkQueue);
    VkResult vkQueueSubmit(queue: VkQueue, submitCount: uint32, pSubmits: *VkSubmitInfo, fence: VkFence);
    VkResult vkQueueWaitIdle(queue: VkQueue);
    VkResult vkDeviceWaitIdle(device: VkDevice);
    VkResult vkAllocateMemory(device: VkDevice, pAllocateInfo: *VkMemoryAllocateInfo, pAllocator: *VkAllocationCallbacks, pMemory: *VkDeviceMemory);
    void vkFreeMemory(device: VkDevice, memory: VkDeviceMemory, pAllocator: *VkAllocationCallbacks);
    VkResult vkMapMemory(device: VkDevice, memory: VkDeviceMemory, offset: VkDeviceSize, size: VkDeviceSize, flags: VkMemoryMapFlags, ppData: **void);
    void vkUnmapMemory(device: VkDevice, memory: VkDeviceMemory);
    VkResult vkFlushMappedMemoryRanges(device: VkDevice, memoryRangeCount: uint32, pMemoryRanges: *VkMappedMemoryRange);
    VkResult vkInvalidateMappedMemoryRanges(device: VkDevice, memoryRangeCount: uint32, pMemoryRanges: *VkMappedMemoryRange);
    void vkGetDeviceMemoryCommitment(device: VkDevice, memory: VkDeviceMemory, pCommittedMemoryInBytes: *VkDeviceSize);
    VkResult vkBindBufferMemory(device: VkDevice, buffer: VkBuffer, memory: VkDeviceMemory, memoryOffset: VkDeviceSize);
    VkResult vkBindImageMemory(device: VkDevice, image: VkImage, memory: VkDeviceMemory, memoryOffset: VkDeviceSize);
    void vkGetBufferMemoryRequirements(device: VkDevice, buffer: VkBuffer, pMemoryRequirements: *VkMemoryRequirements);
    void vkGetImageMemoryRequirements(device: VkDevice, image: VkImage, pMemoryRequirements: *VkMemoryRequirements);
    void vkGetImageSparseMemoryRequirements(device: VkDevice, image: VkImage, pSparseMemoryRequirementCount: *uint32, pSparseMemoryRequirements: *VkSparseImageMemoryRequirements);
    void vkGetPhysicalDeviceSparseImageFormatProperties(physicalDevice: VkPhysicalDevice, format: VkFormat, type: VkImageType, samples: VkSampleCountFlagBits, usage: VkImageUsageFlags, tiling: VkImageTiling, pPropertyCount: *uint32, pProperties: *VkSparseImageFormatProperties);
    VkResult vkQueueBindSparse(queue: VkQueue, bindInfoCount: uint32, pBindInfo: *VkBindSparseInfo, fence: VkFence);
    VkResult vkCreateFence(device: VkDevice, pCreateInfo: *VkFenceCreateInfo, pAllocator: *VkAllocationCallbacks, pFence: *VkFence);
    void vkDestroyFence(device: VkDevice, fence: VkFence, pAllocator: *VkAllocationCallbacks);
    VkResult vkResetFences(device: VkDevice, fenceCount: uint32, pFences: *VkFence);
    VkResult vkGetFenceStatus(device: VkDevice, fence: VkFence);
    VkResult vkWaitForFences(device: VkDevice, fenceCount: uint32, pFences: *VkFence, waitAll: VkBool32, timeout: uint64);
    VkResult vkCreateSemaphore(device: VkDevice, pCreateInfo: *VkSemaphoreCreateInfo, pAllocator: *VkAllocationCallbacks, pSemaphore: *VkSemaphore);
    void vkDestroySemaphore(device: VkDevice, semaphore: VkSemaphore, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateEvent(device: VkDevice, pCreateInfo: *VkEventCreateInfo, pAllocator: *VkAllocationCallbacks, pEvent: *VkEvent);
    void vkDestroyEvent(device: VkDevice, event: VkEvent, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetEventStatus(device: VkDevice, event: VkEvent);
    VkResult vkSetEvent(device: VkDevice, event: VkEvent);
    VkResult vkResetEvent(device: VkDevice, event: VkEvent);
    VkResult vkCreateQueryPool(device: VkDevice, pCreateInfo: *VkQueryPoolCreateInfo, pAllocator: *VkAllocationCallbacks, pQueryPool: *VkQueryPool);
    void vkDestroyQueryPool(device: VkDevice, queryPool: VkQueryPool, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetQueryPoolResults(device: VkDevice, queryPool: VkQueryPool, firstQuery: uint32, queryCount: uint32, dataSize: uint, pData: *void, stride: VkDeviceSize, flags: VkQueryResultFlags);
    VkResult vkCreateBuffer(device: VkDevice, pCreateInfo: *VkBufferCreateInfo, pAllocator: *VkAllocationCallbacks, pBuffer: *VkBuffer);
    void vkDestroyBuffer(device: VkDevice, buffer: VkBuffer, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateBufferView(device: VkDevice, pCreateInfo: *VkBufferViewCreateInfo, pAllocator: *VkAllocationCallbacks, pView: *VkBufferView);
    void vkDestroyBufferView(device: VkDevice, bufferView: VkBufferView, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateImage(device: VkDevice, pCreateInfo: *VkImageCreateInfo, pAllocator: *VkAllocationCallbacks, pImage: *VkImage);
    void vkDestroyImage(device: VkDevice, image: VkImage, pAllocator: *VkAllocationCallbacks);
    void vkGetImageSubresourceLayout(device: VkDevice, image: VkImage, pSubresource: *VkImageSubresource, pLayout: *VkSubresourceLayout);
    VkResult vkCreateImageView(device: VkDevice, pCreateInfo: *VkImageViewCreateInfo, pAllocator: *VkAllocationCallbacks, pView: *VkImageView);
    void vkDestroyImageView(device: VkDevice, imageView: VkImageView, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateShaderModule(device: VkDevice, pCreateInfo: *VkShaderModuleCreateInfo, pAllocator: *VkAllocationCallbacks, pShaderModule: *VkShaderModule);
    void vkDestroyShaderModule(device: VkDevice, shaderModule: VkShaderModule, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreatePipelineCache(device: VkDevice, pCreateInfo: *VkPipelineCacheCreateInfo, pAllocator: *VkAllocationCallbacks, pPipelineCache: *VkPipelineCache);
    void vkDestroyPipelineCache(device: VkDevice, pipelineCache: VkPipelineCache, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetPipelineCacheData(device: VkDevice, pipelineCache: VkPipelineCache, pDataSize: *uint, pData: *void);
    VkResult vkMergePipelineCaches(device: VkDevice, dstCache: VkPipelineCache, srcCacheCount: uint32, pSrcCaches: *VkPipelineCache);
    VkResult vkCreateGraphicsPipelines(device: VkDevice, pipelineCache: VkPipelineCache, createInfoCount: uint32, pCreateInfos: *VkGraphicsPipelineCreateInfo, pAllocator: *VkAllocationCallbacks, pPipelines: *VkPipeline);
    VkResult vkCreateComputePipelines(device: VkDevice, pipelineCache: VkPipelineCache, createInfoCount: uint32, pCreateInfos: *VkComputePipelineCreateInfo, pAllocator: *VkAllocationCallbacks, pPipelines: *VkPipeline);
    void vkDestroyPipeline(device: VkDevice, pipeline: VkPipeline, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreatePipelineLayout(device: VkDevice, pCreateInfo: *VkPipelineLayoutCreateInfo, pAllocator: *VkAllocationCallbacks, pPipelineLayout: *VkPipelineLayout);
    void vkDestroyPipelineLayout(device: VkDevice, pipelineLayout: VkPipelineLayout, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateSampler(device: VkDevice, pCreateInfo: *VkSamplerCreateInfo, pAllocator: *VkAllocationCallbacks, pSampler: *VkSampler);
    void vkDestroySampler(device: VkDevice, sampler: VkSampler, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateDescriptorSetLayout(device: VkDevice, pCreateInfo: *VkDescriptorSetLayoutCreateInfo, pAllocator: *VkAllocationCallbacks, pSetLayout: *VkDescriptorSetLayout);
    void vkDestroyDescriptorSetLayout(device: VkDevice, descriptorSetLayout: VkDescriptorSetLayout, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateDescriptorPool(device: VkDevice, pCreateInfo: *VkDescriptorPoolCreateInfo, pAllocator: *VkAllocationCallbacks, pDescriptorPool: *VkDescriptorPool);
    void vkDestroyDescriptorPool(device: VkDevice, descriptorPool: VkDescriptorPool, pAllocator: *VkAllocationCallbacks);
    VkResult vkResetDescriptorPool(device: VkDevice, descriptorPool: VkDescriptorPool, flags: VkDescriptorPoolResetFlags);
    VkResult vkAllocateDescriptorSets(device: VkDevice, pAllocateInfo: *VkDescriptorSetAllocateInfo, pDescriptorSets: *VkDescriptorSet);
    VkResult vkFreeDescriptorSets(device: VkDevice, descriptorPool: VkDescriptorPool, descriptorSetCount: uint32, pDescriptorSets: *VkDescriptorSet);
    void vkUpdateDescriptorSets(device: VkDevice, descriptorWriteCount: uint32, pDescriptorWrites: *VkWriteDescriptorSet, descriptorCopyCount: uint32, pDescriptorCopies: *VkCopyDescriptorSet);
    VkResult vkCreateFramebuffer(device: VkDevice, pCreateInfo: *VkFramebufferCreateInfo, pAllocator: *VkAllocationCallbacks, pFramebuffer: *VkFramebuffer);
    void vkDestroyFramebuffer(device: VkDevice, framebuffer: VkFramebuffer, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateRenderPass(device: VkDevice, pCreateInfo: *VkRenderPassCreateInfo, pAllocator: *VkAllocationCallbacks, pRenderPass: *VkRenderPass);
    void vkDestroyRenderPass(device: VkDevice, renderPass: VkRenderPass, pAllocator: *VkAllocationCallbacks);
    void vkGetRenderAreaGranularity(device: VkDevice, renderPass: VkRenderPass, pGranularity: *VkExtent2D);
    VkResult vkCreateCommandPool(device: VkDevice, pCreateInfo: *VkCommandPoolCreateInfo, pAllocator: *VkAllocationCallbacks, pCommandPool: *VkCommandPool);
    void vkDestroyCommandPool(device: VkDevice, commandPool: VkCommandPool, pAllocator: *VkAllocationCallbacks);
    VkResult vkResetCommandPool(device: VkDevice, commandPool: VkCommandPool, flags: VkCommandPoolResetFlags);
    VkResult vkAllocateCommandBuffers(device: VkDevice, pAllocateInfo: *VkCommandBufferAllocateInfo, pCommandBuffers: *VkCommandBuffer);
    void vkFreeCommandBuffers(device: VkDevice, commandPool: VkCommandPool, commandBufferCount: uint32, pCommandBuffers: *VkCommandBuffer);
    VkResult vkBeginCommandBuffer(commandBuffer: VkCommandBuffer, pBeginInfo: *VkCommandBufferBeginInfo);
    VkResult vkEndCommandBuffer(commandBuffer: VkCommandBuffer);
    VkResult vkResetCommandBuffer(commandBuffer: VkCommandBuffer, flags: VkCommandBufferResetFlags);
    void vkCmdBindPipeline(commandBuffer: VkCommandBuffer, pipelineBindPoint: VkPipelineBindPoint, pipeline: VkPipeline);
    void vkCmdSetViewport(commandBuffer: VkCommandBuffer, firstViewport: uint32, viewportCount: uint32, pViewports: *VkViewport);
    void vkCmdSetScissor(commandBuffer: VkCommandBuffer, firstScissor: uint32, scissorCount: uint32, pScissors: *VkRect2D);
    void vkCmdSetLineWidth(commandBuffer: VkCommandBuffer, lineWidth: :float);
    void vkCmdSetDepthBias(commandBuffer: VkCommandBuffer, depthBiasConstantFactor: :float, depthBiasClamp: :float, depthBiasSlopeFactor: :float);
    void vkCmdSetBlendConstants(commandBuffer: VkCommandBuffer, blendConstants: [4]:float);
    void vkCmdSetDepthBounds(commandBuffer: VkCommandBuffer, minDepthBounds: :float, maxDepthBounds: :float);
    void vkCmdSetStencilCompareMask(commandBuffer: VkCommandBuffer, faceMask: VkStencilFaceFlags, compareMask: uint32);
    void vkCmdSetStencilWriteMask(commandBuffer: VkCommandBuffer, faceMask: VkStencilFaceFlags, writeMask: uint32);
    void vkCmdSetStencilReference(commandBuffer: VkCommandBuffer, faceMask: VkStencilFaceFlags, reference: uint32);
    void vkCmdBindDescriptorSets(commandBuffer: VkCommandBuffer, pipelineBindPoint: VkPipelineBindPoint, layout: VkPipelineLayout, firstSet: uint32, descriptorSetCount: uint32, pDescriptorSets: *VkDescriptorSet, dynamicOffsetCount: uint32, pDynamicOffsets: *uint32);
    void vkCmdBindIndexBuffer(commandBuffer: VkCommandBuffer, buffer: VkBuffer, offset: VkDeviceSize, indexType: VkIndexType);
    void vkCmdBindVertexBuffers(commandBuffer: VkCommandBuffer, firstBinding: uint32, bindingCount: uint32, pBuffers: *VkBuffer, pOffsets: *VkDeviceSize);
    void vkCmdDraw(commandBuffer: VkCommandBuffer, vertexCount: uint32, instanceCount: uint32, firstVertex: uint32, firstInstance: uint32);
    void vkCmdDrawIndexed(commandBuffer: VkCommandBuffer, indexCount: uint32, instanceCount: uint32, firstIndex: uint32, vertexOffset: int32, firstInstance: uint32);
    void vkCmdDrawIndirect(commandBuffer: VkCommandBuffer, buffer: VkBuffer, offset: VkDeviceSize, drawCount: uint32, stride: uint32);
    void vkCmdDrawIndexedIndirect(commandBuffer: VkCommandBuffer, buffer: VkBuffer, offset: VkDeviceSize, drawCount: uint32, stride: uint32);
    void vkCmdDispatch(commandBuffer: VkCommandBuffer, groupCountX: uint32, groupCountY: uint32, groupCountZ: uint32);
    void vkCmdDispatchIndirect(commandBuffer: VkCommandBuffer, buffer: VkBuffer, offset: VkDeviceSize);
    void vkCmdCopyBuffer(commandBuffer: VkCommandBuffer, srcBuffer: VkBuffer, dstBuffer: VkBuffer, regionCount: uint32, pRegions: *VkBufferCopy);
    void vkCmdCopyImage(commandBuffer: VkCommandBuffer, srcImage: VkImage, srcImageLayout: VkImageLayout, dstImage: VkImage, dstImageLayout: VkImageLayout, regionCount: uint32, pRegions: *VkImageCopy);
    void vkCmdBlitImage(commandBuffer: VkCommandBuffer, srcImage: VkImage, srcImageLayout: VkImageLayout, dstImage: VkImage, dstImageLayout: VkImageLayout, regionCount: uint32, pRegions: *VkImageBlit, filter: VkFilter);
    void vkCmdCopyBufferToImage(commandBuffer: VkCommandBuffer, srcBuffer: VkBuffer, dstImage: VkImage, dstImageLayout: VkImageLayout, regionCount: uint32, pRegions: *VkBufferImageCopy);
    void vkCmdCopyImageToBuffer(commandBuffer: VkCommandBuffer, srcImage: VkImage, srcImageLayout: VkImageLayout, dstBuffer: VkBuffer, regionCount: uint32, pRegions: *VkBufferImageCopy);
    void vkCmdUpdateBuffer(commandBuffer: VkCommandBuffer, dstBuffer: VkBuffer, dstOffset: VkDeviceSize, dataSize: VkDeviceSize, pData: *void);
    void vkCmdFillBuffer(commandBuffer: VkCommandBuffer, dstBuffer: VkBuffer, dstOffset: VkDeviceSize, size: VkDeviceSize, data: uint32);
    void vkCmdClearColorImage(commandBuffer: VkCommandBuffer, image: VkImage, imageLayout: VkImageLayout, pColor: *VkClearColorValue, rangeCount: uint32, pRanges: *VkImageSubresourceRange);
    void vkCmdClearDepthStencilImage(commandBuffer: VkCommandBuffer, image: VkImage, imageLayout: VkImageLayout, pDepthStencil: *VkClearDepthStencilValue, rangeCount: uint32, pRanges: *VkImageSubresourceRange);
    void vkCmdClearAttachments(commandBuffer: VkCommandBuffer, attachmentCount: uint32, pAttachments: *VkClearAttachment, rectCount: uint32, pRects: *VkClearRect);
    void vkCmdResolveImage(commandBuffer: VkCommandBuffer, srcImage: VkImage, srcImageLayout: VkImageLayout, dstImage: VkImage, dstImageLayout: VkImageLayout, regionCount: uint32, pRegions: *VkImageResolve);
    void vkCmdSetEvent(commandBuffer: VkCommandBuffer, event: VkEvent, stageMask: VkPipelineStageFlags);
    void vkCmdResetEvent(commandBuffer: VkCommandBuffer, event: VkEvent, stageMask: VkPipelineStageFlags);
    void vkCmdWaitEvents(commandBuffer: VkCommandBuffer, eventCount: uint32, pEvents: *VkEvent, srcStageMask: VkPipelineStageFlags, dstStageMask: VkPipelineStageFlags, memoryBarrierCount: uint32, pMemoryBarriers: *VkMemoryBarrier, bufferMemoryBarrierCount: uint32, pBufferMemoryBarriers: *VkBufferMemoryBarrier, imageMemoryBarrierCount: uint32, pImageMemoryBarriers: *VkImageMemoryBarrier);
    void vkCmdPipelineBarrier(commandBuffer: VkCommandBuffer, srcStageMask: VkPipelineStageFlags, dstStageMask: VkPipelineStageFlags, dependencyFlags: VkDependencyFlags, memoryBarrierCount: uint32, pMemoryBarriers: *VkMemoryBarrier, bufferMemoryBarrierCount: uint32, pBufferMemoryBarriers: *VkBufferMemoryBarrier, imageMemoryBarrierCount: uint32, pImageMemoryBarriers: *VkImageMemoryBarrier);
    void vkCmdBeginQuery(commandBuffer: VkCommandBuffer, queryPool: VkQueryPool, query: uint32, flags: VkQueryControlFlags);
    void vkCmdEndQuery(commandBuffer: VkCommandBuffer, queryPool: VkQueryPool, query: uint32);
    void vkCmdResetQueryPool(commandBuffer: VkCommandBuffer, queryPool: VkQueryPool, firstQuery: uint32, queryCount: uint32);
    void vkCmdWriteTimestamp(commandBuffer: VkCommandBuffer, pipelineStage: VkPipelineStageFlagBits, queryPool: VkQueryPool, query: uint32);
    void vkCmdCopyQueryPoolResults(commandBuffer: VkCommandBuffer, queryPool: VkQueryPool, firstQuery: uint32, queryCount: uint32, dstBuffer: VkBuffer, dstOffset: VkDeviceSize, stride: VkDeviceSize, flags: VkQueryResultFlags);
    void vkCmdPushConstants(commandBuffer: VkCommandBuffer, layout: VkPipelineLayout, stageFlags: VkShaderStageFlags, offset: uint32, size: uint32, pValues: *void);
    void vkCmdBeginRenderPass(commandBuffer: VkCommandBuffer, pRenderPassBegin: *VkRenderPassBeginInfo, contents: VkSubpassContents);
    void vkCmdNextSubpass(commandBuffer: VkCommandBuffer, contents: VkSubpassContents);
    void vkCmdEndRenderPass(commandBuffer: VkCommandBuffer);
    void vkCmdExecuteCommands(commandBuffer: VkCommandBuffer, commandBufferCount: uint32, pCommandBuffers: *VkCommandBuffer);
    VkResult vkEnumerateInstanceVersion(pApiVersion: *uint32);
    VkResult vkBindBufferMemory2(device: VkDevice, bindInfoCount: uint32, pBindInfos: *VkBindBufferMemoryInfo);
    VkResult vkBindImageMemory2(device: VkDevice, bindInfoCount: uint32, pBindInfos: *VkBindImageMemoryInfo);
    void vkGetDeviceGroupPeerMemoryFeatures(device: VkDevice, heapIndex: uint32, localDeviceIndex: uint32, remoteDeviceIndex: uint32, pPeerMemoryFeatures: *VkPeerMemoryFeatureFlags);
    void vkCmdSetDeviceMask(commandBuffer: VkCommandBuffer, deviceMask: uint32);
    void vkCmdDispatchBase(commandBuffer: VkCommandBuffer, baseGroupX: uint32, baseGroupY: uint32, baseGroupZ: uint32, groupCountX: uint32, groupCountY: uint32, groupCountZ: uint32);
    VkResult vkEnumeratePhysicalDeviceGroups(instance: VkInstance, pPhysicalDeviceGroupCount: *uint32, pPhysicalDeviceGroupProperties: *VkPhysicalDeviceGroupProperties);
    void vkGetImageMemoryRequirements2(device: VkDevice, pInfo: *VkImageMemoryRequirementsInfo2, pMemoryRequirements: *VkMemoryRequirements2);
    void vkGetBufferMemoryRequirements2(device: VkDevice, pInfo: *VkBufferMemoryRequirementsInfo2, pMemoryRequirements: *VkMemoryRequirements2);
    void vkGetImageSparseMemoryRequirements2(device: VkDevice, pInfo: *VkImageSparseMemoryRequirementsInfo2, pSparseMemoryRequirementCount: *uint32, pSparseMemoryRequirements: *VkSparseImageMemoryRequirements2);
    void vkGetPhysicalDeviceFeatures2(physicalDevice: VkPhysicalDevice, pFeatures: *VkPhysicalDeviceFeatures2);
    void vkGetPhysicalDeviceProperties2(physicalDevice: VkPhysicalDevice, pProperties: *VkPhysicalDeviceProperties2);
    void vkGetPhysicalDeviceFormatProperties2(physicalDevice: VkPhysicalDevice, format: VkFormat, pFormatProperties: *VkFormatProperties2);
    VkResult vkGetPhysicalDeviceImageFormatProperties2(physicalDevice: VkPhysicalDevice, pImageFormatInfo: *VkPhysicalDeviceImageFormatInfo2, pImageFormatProperties: *VkImageFormatProperties2);
    void vkGetPhysicalDeviceQueueFamilyProperties2(physicalDevice: VkPhysicalDevice, pQueueFamilyPropertyCount: *uint32, pQueueFamilyProperties: *VkQueueFamilyProperties2);
    void vkGetPhysicalDeviceMemoryProperties2(physicalDevice: VkPhysicalDevice, pMemoryProperties: *VkPhysicalDeviceMemoryProperties2);
    void vkGetPhysicalDeviceSparseImageFormatProperties2(physicalDevice: VkPhysicalDevice, pFormatInfo: *VkPhysicalDeviceSparseImageFormatInfo2, pPropertyCount: *uint32, pProperties: *VkSparseImageFormatProperties2);
    void vkTrimCommandPool(device: VkDevice, commandPool: VkCommandPool, flags: VkCommandPoolTrimFlags);
    void vkGetDeviceQueue2(device: VkDevice, pQueueInfo: *VkDeviceQueueInfo2, pQueue: *VkQueue);
    VkResult vkCreateSamplerYcbcrConversion(device: VkDevice, pCreateInfo: *VkSamplerYcbcrConversionCreateInfo, pAllocator: *VkAllocationCallbacks, pYcbcrConversion: *VkSamplerYcbcrConversion);
    void vkDestroySamplerYcbcrConversion(device: VkDevice, ycbcrConversion: VkSamplerYcbcrConversion, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateDescriptorUpdateTemplate(device: VkDevice, pCreateInfo: *VkDescriptorUpdateTemplateCreateInfo, pAllocator: *VkAllocationCallbacks, pDescriptorUpdateTemplate: *VkDescriptorUpdateTemplate);
    void vkDestroyDescriptorUpdateTemplate(device: VkDevice, descriptorUpdateTemplate: VkDescriptorUpdateTemplate, pAllocator: *VkAllocationCallbacks);
    void vkUpdateDescriptorSetWithTemplate(device: VkDevice, descriptorSet: VkDescriptorSet, descriptorUpdateTemplate: VkDescriptorUpdateTemplate, pData: *void);
    void vkGetPhysicalDeviceExternalBufferProperties(physicalDevice: VkPhysicalDevice, pExternalBufferInfo: *VkPhysicalDeviceExternalBufferInfo, pExternalBufferProperties: *VkExternalBufferProperties);
    void vkGetPhysicalDeviceExternalFenceProperties(physicalDevice: VkPhysicalDevice, pExternalFenceInfo: *VkPhysicalDeviceExternalFenceInfo, pExternalFenceProperties: *VkExternalFenceProperties);
    void vkGetPhysicalDeviceExternalSemaphoreProperties(physicalDevice: VkPhysicalDevice, pExternalSemaphoreInfo: *VkPhysicalDeviceExternalSemaphoreInfo, pExternalSemaphoreProperties: *VkExternalSemaphoreProperties);
    void vkGetDescriptorSetLayoutSupport(device: VkDevice, pCreateInfo: *VkDescriptorSetLayoutCreateInfo, pSupport: *VkDescriptorSetLayoutSupport);
    void vkCmdDrawIndirectCount(commandBuffer: VkCommandBuffer, buffer: VkBuffer, offset: VkDeviceSize, countBuffer: VkBuffer, countBufferOffset: VkDeviceSize, maxDrawCount: uint32, stride: uint32);
    void vkCmdDrawIndexedIndirectCount(commandBuffer: VkCommandBuffer, buffer: VkBuffer, offset: VkDeviceSize, countBuffer: VkBuffer, countBufferOffset: VkDeviceSize, maxDrawCount: uint32, stride: uint32);
    VkResult vkCreateRenderPass2(device: VkDevice, pCreateInfo: *VkRenderPassCreateInfo2, pAllocator: *VkAllocationCallbacks, pRenderPass: *VkRenderPass);
    void vkCmdBeginRenderPass2(commandBuffer: VkCommandBuffer, pRenderPassBegin: *VkRenderPassBeginInfo, pSubpassBeginInfo: *VkSubpassBeginInfo);
    void vkCmdNextSubpass2(commandBuffer: VkCommandBuffer, pSubpassBeginInfo: *VkSubpassBeginInfo, pSubpassEndInfo: *VkSubpassEndInfo);
    void vkCmdEndRenderPass2(commandBuffer: VkCommandBuffer, pSubpassEndInfo: *VkSubpassEndInfo);
    void vkResetQueryPool(device: VkDevice, queryPool: VkQueryPool, firstQuery: uint32, queryCount: uint32);
    VkResult vkGetSemaphoreCounterValue(device: VkDevice, semaphore: VkSemaphore, pValue: *uint64);
    VkResult vkWaitSemaphores(device: VkDevice, pWaitInfo: *VkSemaphoreWaitInfo, timeout: uint64);
    VkResult vkSignalSemaphore(device: VkDevice, pSignalInfo: *VkSemaphoreSignalInfo);
    VkDeviceAddress vkGetBufferDeviceAddress(device: VkDevice, pInfo: *VkBufferDeviceAddressInfo);
    uint64 vkGetBufferOpaqueCaptureAddress(device: VkDevice, pInfo: *VkBufferDeviceAddressInfo);
    uint64 vkGetDeviceMemoryOpaqueCaptureAddress(device: VkDevice, pInfo: *VkDeviceMemoryOpaqueCaptureAddressInfo);
    VkResult vkGetPhysicalDeviceToolProperties(physicalDevice: VkPhysicalDevice, pToolCount: *uint32, pToolProperties: *VkPhysicalDeviceToolProperties);
    VkResult vkCreatePrivateDataSlot(device: VkDevice, pCreateInfo: *VkPrivateDataSlotCreateInfo, pAllocator: *VkAllocationCallbacks, pPrivateDataSlot: *VkPrivateDataSlot);
    void vkDestroyPrivateDataSlot(device: VkDevice, privateDataSlot: VkPrivateDataSlot, pAllocator: *VkAllocationCallbacks);
    VkResult vkSetPrivateData(device: VkDevice, objectType: VkObjectType, objectHandle: uint64, privateDataSlot: VkPrivateDataSlot, data: uint64);
    void vkGetPrivateData(device: VkDevice, objectType: VkObjectType, objectHandle: uint64, privateDataSlot: VkPrivateDataSlot, pData: *uint64);
    void vkCmdSetEvent2(commandBuffer: VkCommandBuffer, event: VkEvent, pDependencyInfo: *VkDependencyInfo);
    void vkCmdResetEvent2(commandBuffer: VkCommandBuffer, event: VkEvent, stageMask: VkPipelineStageFlags2);
    void vkCmdWaitEvents2(commandBuffer: VkCommandBuffer, eventCount: uint32, pEvents: *VkEvent, pDependencyInfos: *VkDependencyInfo);
    void vkCmdPipelineBarrier2(commandBuffer: VkCommandBuffer, pDependencyInfo: *VkDependencyInfo);
    void vkCmdWriteTimestamp2(commandBuffer: VkCommandBuffer, stage: VkPipelineStageFlags2, queryPool: VkQueryPool, query: uint32);
    VkResult vkQueueSubmit2(queue: VkQueue, submitCount: uint32, pSubmits: *VkSubmitInfo2, fence: VkFence);
    void vkCmdCopyBuffer2(commandBuffer: VkCommandBuffer, pCopyBufferInfo: *VkCopyBufferInfo2);
    void vkCmdCopyImage2(commandBuffer: VkCommandBuffer, pCopyImageInfo: *VkCopyImageInfo2);
    void vkCmdCopyBufferToImage2(commandBuffer: VkCommandBuffer, pCopyBufferToImageInfo: *VkCopyBufferToImageInfo2);
    void vkCmdCopyImageToBuffer2(commandBuffer: VkCommandBuffer, pCopyImageToBufferInfo: *VkCopyImageToBufferInfo2);
    void vkCmdBlitImage2(commandBuffer: VkCommandBuffer, pBlitImageInfo: *VkBlitImageInfo2);
    void vkCmdResolveImage2(commandBuffer: VkCommandBuffer, pResolveImageInfo: *VkResolveImageInfo2);
    void vkCmdBeginRendering(commandBuffer: VkCommandBuffer, pRenderingInfo: *VkRenderingInfo);
    void vkCmdEndRendering(commandBuffer: VkCommandBuffer);
    void vkCmdSetCullMode(commandBuffer: VkCommandBuffer, cullMode: VkCullModeFlags);
    void vkCmdSetFrontFace(commandBuffer: VkCommandBuffer, frontFace: VkFrontFace);
    void vkCmdSetPrimitiveTopology(commandBuffer: VkCommandBuffer, primitiveTopology: VkPrimitiveTopology);
    void vkCmdSetViewportWithCount(commandBuffer: VkCommandBuffer, viewportCount: uint32, pViewports: *VkViewport);
    void vkCmdSetScissorWithCount(commandBuffer: VkCommandBuffer, scissorCount: uint32, pScissors: *VkRect2D);
    void vkCmdBindVertexBuffers2(commandBuffer: VkCommandBuffer, firstBinding: uint32, bindingCount: uint32, pBuffers: *VkBuffer, pOffsets: *VkDeviceSize, pSizes: *VkDeviceSize, pStrides: *VkDeviceSize);
    void vkCmdSetDepthTestEnable(commandBuffer: VkCommandBuffer, depthTestEnable: VkBool32);
    void vkCmdSetDepthWriteEnable(commandBuffer: VkCommandBuffer, depthWriteEnable: VkBool32);
    void vkCmdSetDepthCompareOp(commandBuffer: VkCommandBuffer, depthCompareOp: VkCompareOp);
    void vkCmdSetDepthBoundsTestEnable(commandBuffer: VkCommandBuffer, depthBoundsTestEnable: VkBool32);
    void vkCmdSetStencilTestEnable(commandBuffer: VkCommandBuffer, stencilTestEnable: VkBool32);
    void vkCmdSetStencilOp(commandBuffer: VkCommandBuffer, faceMask: VkStencilFaceFlags, failOp: VkStencilOp, passOp: VkStencilOp, depthFailOp: VkStencilOp, compareOp: VkCompareOp);
    void vkCmdSetRasterizerDiscardEnable(commandBuffer: VkCommandBuffer, rasterizerDiscardEnable: VkBool32);
    void vkCmdSetDepthBiasEnable(commandBuffer: VkCommandBuffer, depthBiasEnable: VkBool32);
    void vkCmdSetPrimitiveRestartEnable(commandBuffer: VkCommandBuffer, primitiveRestartEnable: VkBool32);
    void vkGetDeviceBufferMemoryRequirements(device: VkDevice, pInfo: *VkDeviceBufferMemoryRequirements, pMemoryRequirements: *VkMemoryRequirements2);
    void vkGetDeviceImageMemoryRequirements(device: VkDevice, pInfo: *VkDeviceImageMemoryRequirements, pMemoryRequirements: *VkMemoryRequirements2);
    void vkGetDeviceImageSparseMemoryRequirements(device: VkDevice, pInfo: *VkDeviceImageMemoryRequirements, pSparseMemoryRequirementCount: *uint32, pSparseMemoryRequirements: *VkSparseImageMemoryRequirements2);
    void vkCmdSetLineStipple(commandBuffer: VkCommandBuffer, lineStippleFactor: uint32, lineStipplePattern: uint16_t);
    VkResult vkMapMemory2(device: VkDevice, pMemoryMapInfo: *VkMemoryMapInfo, ppData: **void);
    VkResult vkUnmapMemory2(device: VkDevice, pMemoryUnmapInfo: *VkMemoryUnmapInfo);
    void vkCmdBindIndexBuffer2(commandBuffer: VkCommandBuffer, buffer: VkBuffer, offset: VkDeviceSize, size: VkDeviceSize, indexType: VkIndexType);
    void vkGetRenderingAreaGranularity(device: VkDevice, pRenderingAreaInfo: *VkRenderingAreaInfo, pGranularity: *VkExtent2D);
    void vkGetDeviceImageSubresourceLayout(device: VkDevice, pInfo: *VkDeviceImageSubresourceInfo, pLayout: *VkSubresourceLayout2);
    void vkGetImageSubresourceLayout2(device: VkDevice, image: VkImage, pSubresource: *VkImageSubresource2, pLayout: *VkSubresourceLayout2);
    void vkCmdPushDescriptorSet(commandBuffer: VkCommandBuffer, pipelineBindPoint: VkPipelineBindPoint, layout: VkPipelineLayout, set: uint32, descriptorWriteCount: uint32, pDescriptorWrites: *VkWriteDescriptorSet);
    void vkCmdPushDescriptorSetWithTemplate(commandBuffer: VkCommandBuffer, descriptorUpdateTemplate: VkDescriptorUpdateTemplate, layout: VkPipelineLayout, set: uint32, pData: *void);
    void vkCmdSetRenderingAttachmentLocations(commandBuffer: VkCommandBuffer, pLocationInfo: *VkRenderingAttachmentLocationInfo);
    void vkCmdSetRenderingInputAttachmentIndices(commandBuffer: VkCommandBuffer, pInputAttachmentIndexInfo: *VkRenderingInputAttachmentIndexInfo);
    void vkCmdBindDescriptorSets2(commandBuffer: VkCommandBuffer, pBindDescriptorSetsInfo: *VkBindDescriptorSetsInfo);
    void vkCmdPushConstants2(commandBuffer: VkCommandBuffer, pPushConstantsInfo: *VkPushConstantsInfo);
    void vkCmdPushDescriptorSet2(commandBuffer: VkCommandBuffer, pPushDescriptorSetInfo: *VkPushDescriptorSetInfo);
    void vkCmdPushDescriptorSetWithTemplate2(commandBuffer: VkCommandBuffer, pPushDescriptorSetWithTemplateInfo: *VkPushDescriptorSetWithTemplateInfo);
    VkResult vkCopyMemoryToImage(device: VkDevice, pCopyMemoryToImageInfo: *VkCopyMemoryToImageInfo);
    VkResult vkCopyImageToMemory(device: VkDevice, pCopyImageToMemoryInfo: *VkCopyImageToMemoryInfo);
    VkResult vkCopyImageToImage(device: VkDevice, pCopyImageToImageInfo: *VkCopyImageToImageInfo);
    VkResult vkTransitionImageLayout(device: VkDevice, transitionCount: uint32, pTransitions: *VkHostImageLayoutTransitionInfo);
    void vkDestroySurfaceKHR(instance: VkInstance, surface: VkSurfaceKHR, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetPhysicalDeviceSurfaceSupportKHR(physicalDevice: VkPhysicalDevice, queueFamilyIndex: uint32, surface: VkSurfaceKHR, pSupported: *VkBool32);
    VkResult vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice: VkPhysicalDevice, surface: VkSurfaceKHR, pSurfaceCapabilities: *VkSurfaceCapabilitiesKHR);
    VkResult vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice: VkPhysicalDevice, surface: VkSurfaceKHR, pSurfaceFormatCount: *uint32, pSurfaceFormats: *VkSurfaceFormatKHR);
    VkResult vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice: VkPhysicalDevice, surface: VkSurfaceKHR, pPresentModeCount: *uint32, pPresentModes: *VkPresentModeKHR);
    VkResult vkCreateSwapchainKHR(device: VkDevice, pCreateInfo: *VkSwapchainCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pSwapchain: *VkSwapchainKHR);
    void vkDestroySwapchainKHR(device: VkDevice, swapchain: VkSwapchainKHR, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetSwapchainImagesKHR(device: VkDevice, swapchain: VkSwapchainKHR, pSwapchainImageCount: *uint32, pSwapchainImages: *VkImage);
    VkResult vkAcquireNextImageKHR(device: VkDevice, swapchain: VkSwapchainKHR, timeout: uint64, semaphore: VkSemaphore, fence: VkFence, pImageIndex: *uint32);
    VkResult vkQueuePresentKHR(queue: VkQueue, pPresentInfo: *VkPresentInfoKHR);
    VkResult vkGetDeviceGroupPresentCapabilitiesKHR(device: VkDevice, pDeviceGroupPresentCapabilities: *VkDeviceGroupPresentCapabilitiesKHR);
    VkResult vkGetDeviceGroupSurfacePresentModesKHR(device: VkDevice, surface: VkSurfaceKHR, pModes: *VkDeviceGroupPresentModeFlagsKHR);
    VkResult vkGetPhysicalDevicePresentRectanglesKHR(physicalDevice: VkPhysicalDevice, surface: VkSurfaceKHR, pRectCount: *uint32, pRects: *VkRect2D);
    VkResult vkAcquireNextImage2KHR(device: VkDevice, pAcquireInfo: *VkAcquireNextImageInfoKHR, pImageIndex: *uint32);
    VkResult vkGetPhysicalDeviceDisplayPropertiesKHR(physicalDevice: VkPhysicalDevice, pPropertyCount: *uint32, pProperties: *VkDisplayPropertiesKHR);
    VkResult vkGetPhysicalDeviceDisplayPlanePropertiesKHR(physicalDevice: VkPhysicalDevice, pPropertyCount: *uint32, pProperties: *VkDisplayPlanePropertiesKHR);
    VkResult vkGetDisplayPlaneSupportedDisplaysKHR(physicalDevice: VkPhysicalDevice, planeIndex: uint32, pDisplayCount: *uint32, pDisplays: *VkDisplayKHR);
    VkResult vkGetDisplayModePropertiesKHR(physicalDevice: VkPhysicalDevice, display: VkDisplayKHR, pPropertyCount: *uint32, pProperties: *VkDisplayModePropertiesKHR);
    VkResult vkCreateDisplayModeKHR(physicalDevice: VkPhysicalDevice, display: VkDisplayKHR, pCreateInfo: *VkDisplayModeCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pMode: *VkDisplayModeKHR);
    VkResult vkGetDisplayPlaneCapabilitiesKHR(physicalDevice: VkPhysicalDevice, mode: VkDisplayModeKHR, planeIndex: uint32, pCapabilities: *VkDisplayPlaneCapabilitiesKHR);
    VkResult vkCreateDisplayPlaneSurfaceKHR(instance: VkInstance, pCreateInfo: *VkDisplaySurfaceCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pSurface: *VkSurfaceKHR);
    VkResult vkCreateSharedSwapchainsKHR(device: VkDevice, swapchainCount: uint32, pCreateInfos: *VkSwapchainCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pSwapchains: *VkSwapchainKHR);
    VkResult vkGetPhysicalDeviceVideoCapabilitiesKHR(physicalDevice: VkPhysicalDevice, pVideoProfile: *VkVideoProfileInfoKHR, pCapabilities: *VkVideoCapabilitiesKHR);
    VkResult vkGetPhysicalDeviceVideoFormatPropertiesKHR(physicalDevice: VkPhysicalDevice, pVideoFormatInfo: *VkPhysicalDeviceVideoFormatInfoKHR, pVideoFormatPropertyCount: *uint32, pVideoFormatProperties: *VkVideoFormatPropertiesKHR);
    VkResult vkCreateVideoSessionKHR(device: VkDevice, pCreateInfo: *VkVideoSessionCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pVideoSession: *VkVideoSessionKHR);
    void vkDestroyVideoSessionKHR(device: VkDevice, videoSession: VkVideoSessionKHR, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetVideoSessionMemoryRequirementsKHR(device: VkDevice, videoSession: VkVideoSessionKHR, pMemoryRequirementsCount: *uint32, pMemoryRequirements: *VkVideoSessionMemoryRequirementsKHR);
    VkResult vkBindVideoSessionMemoryKHR(device: VkDevice, videoSession: VkVideoSessionKHR, bindSessionMemoryInfoCount: uint32, pBindSessionMemoryInfos: *VkBindVideoSessionMemoryInfoKHR);
    VkResult vkCreateVideoSessionParametersKHR(device: VkDevice, pCreateInfo: *VkVideoSessionParametersCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pVideoSessionParameters: *VkVideoSessionParametersKHR);
    VkResult vkUpdateVideoSessionParametersKHR(device: VkDevice, videoSessionParameters: VkVideoSessionParametersKHR, pUpdateInfo: *VkVideoSessionParametersUpdateInfoKHR);
    void vkDestroyVideoSessionParametersKHR(device: VkDevice, videoSessionParameters: VkVideoSessionParametersKHR, pAllocator: *VkAllocationCallbacks);
    void vkCmdBeginVideoCodingKHR(commandBuffer: VkCommandBuffer, pBeginInfo: *VkVideoBeginCodingInfoKHR);
    void vkCmdEndVideoCodingKHR(commandBuffer: VkCommandBuffer, pEndCodingInfo: *VkVideoEndCodingInfoKHR);
    void vkCmdControlVideoCodingKHR(commandBuffer: VkCommandBuffer, pCodingControlInfo: *VkVideoCodingControlInfoKHR);
    void vkCmdDecodeVideoKHR(commandBuffer: VkCommandBuffer, pDecodeInfo: *VkVideoDecodeInfoKHR);
    void vkCmdBeginRenderingKHR(commandBuffer: VkCommandBuffer, pRenderingInfo: *VkRenderingInfo);
    void vkCmdEndRenderingKHR(commandBuffer: VkCommandBuffer);
    void vkGetPhysicalDeviceFeatures2KHR(physicalDevice: VkPhysicalDevice, pFeatures: *VkPhysicalDeviceFeatures2);
    void vkGetPhysicalDeviceProperties2KHR(physicalDevice: VkPhysicalDevice, pProperties: *VkPhysicalDeviceProperties2);
    void vkGetPhysicalDeviceFormatProperties2KHR(physicalDevice: VkPhysicalDevice, format: VkFormat, pFormatProperties: *VkFormatProperties2);
    VkResult vkGetPhysicalDeviceImageFormatProperties2KHR(physicalDevice: VkPhysicalDevice, pImageFormatInfo: *VkPhysicalDeviceImageFormatInfo2, pImageFormatProperties: *VkImageFormatProperties2);
    void vkGetPhysicalDeviceQueueFamilyProperties2KHR(physicalDevice: VkPhysicalDevice, pQueueFamilyPropertyCount: *uint32, pQueueFamilyProperties: *VkQueueFamilyProperties2);
    void vkGetPhysicalDeviceMemoryProperties2KHR(physicalDevice: VkPhysicalDevice, pMemoryProperties: *VkPhysicalDeviceMemoryProperties2);
    void vkGetPhysicalDeviceSparseImageFormatProperties2KHR(physicalDevice: VkPhysicalDevice, pFormatInfo: *VkPhysicalDeviceSparseImageFormatInfo2, pPropertyCount: *uint32, pProperties: *VkSparseImageFormatProperties2);
    void vkGetDeviceGroupPeerMemoryFeaturesKHR(device: VkDevice, heapIndex: uint32, localDeviceIndex: uint32, remoteDeviceIndex: uint32, pPeerMemoryFeatures: *VkPeerMemoryFeatureFlags);
    void vkCmdSetDeviceMaskKHR(commandBuffer: VkCommandBuffer, deviceMask: uint32);
    void vkCmdDispatchBaseKHR(commandBuffer: VkCommandBuffer, baseGroupX: uint32, baseGroupY: uint32, baseGroupZ: uint32, groupCountX: uint32, groupCountY: uint32, groupCountZ: uint32);
    void vkTrimCommandPoolKHR(device: VkDevice, commandPool: VkCommandPool, flags: VkCommandPoolTrimFlags);
    VkResult vkEnumeratePhysicalDeviceGroupsKHR(instance: VkInstance, pPhysicalDeviceGroupCount: *uint32, pPhysicalDeviceGroupProperties: *VkPhysicalDeviceGroupProperties);
    void vkGetPhysicalDeviceExternalBufferPropertiesKHR(physicalDevice: VkPhysicalDevice, pExternalBufferInfo: *VkPhysicalDeviceExternalBufferInfo, pExternalBufferProperties: *VkExternalBufferProperties);
    VkResult vkGetMemoryFdKHR(device: VkDevice, pGetFdInfo: *VkMemoryGetFdInfoKHR, pFd: *:int);
    VkResult vkGetMemoryFdPropertiesKHR(device: VkDevice, handleType: VkExternalMemoryHandleTypeFlagBits, fd: :int, pMemoryFdProperties: *VkMemoryFdPropertiesKHR);
    void vkGetPhysicalDeviceExternalSemaphorePropertiesKHR(physicalDevice: VkPhysicalDevice, pExternalSemaphoreInfo: *VkPhysicalDeviceExternalSemaphoreInfo, pExternalSemaphoreProperties: *VkExternalSemaphoreProperties);
    VkResult vkImportSemaphoreFdKHR(device: VkDevice, pImportSemaphoreFdInfo: *VkImportSemaphoreFdInfoKHR);
    VkResult vkGetSemaphoreFdKHR(device: VkDevice, pGetFdInfo: *VkSemaphoreGetFdInfoKHR, pFd: *:int);
    void vkCmdPushDescriptorSetKHR(commandBuffer: VkCommandBuffer, pipelineBindPoint: VkPipelineBindPoint, layout: VkPipelineLayout, set: uint32, descriptorWriteCount: uint32, pDescriptorWrites: *VkWriteDescriptorSet);
    void vkCmdPushDescriptorSetWithTemplateKHR(commandBuffer: VkCommandBuffer, descriptorUpdateTemplate: VkDescriptorUpdateTemplate, layout: VkPipelineLayout, set: uint32, pData: *void);
    VkResult vkCreateDescriptorUpdateTemplateKHR(device: VkDevice, pCreateInfo: *VkDescriptorUpdateTemplateCreateInfo, pAllocator: *VkAllocationCallbacks, pDescriptorUpdateTemplate: *VkDescriptorUpdateTemplate);
    void vkDestroyDescriptorUpdateTemplateKHR(device: VkDevice, descriptorUpdateTemplate: VkDescriptorUpdateTemplate, pAllocator: *VkAllocationCallbacks);
    void vkUpdateDescriptorSetWithTemplateKHR(device: VkDevice, descriptorSet: VkDescriptorSet, descriptorUpdateTemplate: VkDescriptorUpdateTemplate, pData: *void);
    VkResult vkCreateRenderPass2KHR(device: VkDevice, pCreateInfo: *VkRenderPassCreateInfo2, pAllocator: *VkAllocationCallbacks, pRenderPass: *VkRenderPass);
    void vkCmdBeginRenderPass2KHR(commandBuffer: VkCommandBuffer, pRenderPassBegin: *VkRenderPassBeginInfo, pSubpassBeginInfo: *VkSubpassBeginInfo);
    void vkCmdNextSubpass2KHR(commandBuffer: VkCommandBuffer, pSubpassBeginInfo: *VkSubpassBeginInfo, pSubpassEndInfo: *VkSubpassEndInfo);
    void vkCmdEndRenderPass2KHR(commandBuffer: VkCommandBuffer, pSubpassEndInfo: *VkSubpassEndInfo);
    VkResult vkGetSwapchainStatusKHR(device: VkDevice, swapchain: VkSwapchainKHR);
    void vkGetPhysicalDeviceExternalFencePropertiesKHR(physicalDevice: VkPhysicalDevice, pExternalFenceInfo: *VkPhysicalDeviceExternalFenceInfo, pExternalFenceProperties: *VkExternalFenceProperties);
    VkResult vkImportFenceFdKHR(device: VkDevice, pImportFenceFdInfo: *VkImportFenceFdInfoKHR);
    VkResult vkGetFenceFdKHR(device: VkDevice, pGetFdInfo: *VkFenceGetFdInfoKHR, pFd: *:int);
    VkResult vkEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR(physicalDevice: VkPhysicalDevice, queueFamilyIndex: uint32, pCounterCount: *uint32, pCounters: *VkPerformanceCounterKHR, pCounterDescriptions: *VkPerformanceCounterDescriptionKHR);
    void vkGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR(physicalDevice: VkPhysicalDevice, pPerformanceQueryCreateInfo: *VkQueryPoolPerformanceCreateInfoKHR, pNumPasses: *uint32);
    VkResult vkAcquireProfilingLockKHR(device: VkDevice, pInfo: *VkAcquireProfilingLockInfoKHR);
    void vkReleaseProfilingLockKHR(device: VkDevice);
    VkResult vkGetPhysicalDeviceSurfaceCapabilities2KHR(physicalDevice: VkPhysicalDevice, pSurfaceInfo: *VkPhysicalDeviceSurfaceInfo2KHR, pSurfaceCapabilities: *VkSurfaceCapabilities2KHR);
    VkResult vkGetPhysicalDeviceSurfaceFormats2KHR(physicalDevice: VkPhysicalDevice, pSurfaceInfo: *VkPhysicalDeviceSurfaceInfo2KHR, pSurfaceFormatCount: *uint32, pSurfaceFormats: *VkSurfaceFormat2KHR);
    VkResult vkGetPhysicalDeviceDisplayProperties2KHR(physicalDevice: VkPhysicalDevice, pPropertyCount: *uint32, pProperties: *VkDisplayProperties2KHR);
    VkResult vkGetPhysicalDeviceDisplayPlaneProperties2KHR(physicalDevice: VkPhysicalDevice, pPropertyCount: *uint32, pProperties: *VkDisplayPlaneProperties2KHR);
    VkResult vkGetDisplayModeProperties2KHR(physicalDevice: VkPhysicalDevice, display: VkDisplayKHR, pPropertyCount: *uint32, pProperties: *VkDisplayModeProperties2KHR);
    VkResult vkGetDisplayPlaneCapabilities2KHR(physicalDevice: VkPhysicalDevice, pDisplayPlaneInfo: *VkDisplayPlaneInfo2KHR, pCapabilities: *VkDisplayPlaneCapabilities2KHR);
    void vkGetImageMemoryRequirements2KHR(device: VkDevice, pInfo: *VkImageMemoryRequirementsInfo2, pMemoryRequirements: *VkMemoryRequirements2);
    void vkGetBufferMemoryRequirements2KHR(device: VkDevice, pInfo: *VkBufferMemoryRequirementsInfo2, pMemoryRequirements: *VkMemoryRequirements2);
    void vkGetImageSparseMemoryRequirements2KHR(device: VkDevice, pInfo: *VkImageSparseMemoryRequirementsInfo2, pSparseMemoryRequirementCount: *uint32, pSparseMemoryRequirements: *VkSparseImageMemoryRequirements2);
    VkResult vkCreateSamplerYcbcrConversionKHR(device: VkDevice, pCreateInfo: *VkSamplerYcbcrConversionCreateInfo, pAllocator: *VkAllocationCallbacks, pYcbcrConversion: *VkSamplerYcbcrConversion);
    void vkDestroySamplerYcbcrConversionKHR(device: VkDevice, ycbcrConversion: VkSamplerYcbcrConversion, pAllocator: *VkAllocationCallbacks);
    VkResult vkBindBufferMemory2KHR(device: VkDevice, bindInfoCount: uint32, pBindInfos: *VkBindBufferMemoryInfo);
    VkResult vkBindImageMemory2KHR(device: VkDevice, bindInfoCount: uint32, pBindInfos: *VkBindImageMemoryInfo);
    void vkGetDescriptorSetLayoutSupportKHR(device: VkDevice, pCreateInfo: *VkDescriptorSetLayoutCreateInfo, pSupport: *VkDescriptorSetLayoutSupport);
    void vkCmdDrawIndirectCountKHR(commandBuffer: VkCommandBuffer, buffer: VkBuffer, offset: VkDeviceSize, countBuffer: VkBuffer, countBufferOffset: VkDeviceSize, maxDrawCount: uint32, stride: uint32);
    void vkCmdDrawIndexedIndirectCountKHR(commandBuffer: VkCommandBuffer, buffer: VkBuffer, offset: VkDeviceSize, countBuffer: VkBuffer, countBufferOffset: VkDeviceSize, maxDrawCount: uint32, stride: uint32);
    VkResult vkGetSemaphoreCounterValueKHR(device: VkDevice, semaphore: VkSemaphore, pValue: *uint64);
    VkResult vkWaitSemaphoresKHR(device: VkDevice, pWaitInfo: *VkSemaphoreWaitInfo, timeout: uint64);
    VkResult vkSignalSemaphoreKHR(device: VkDevice, pSignalInfo: *VkSemaphoreSignalInfo);
    VkResult vkGetPhysicalDeviceFragmentShadingRatesKHR(physicalDevice: VkPhysicalDevice, pFragmentShadingRateCount: *uint32, pFragmentShadingRates: *VkPhysicalDeviceFragmentShadingRateKHR);
    void vkCmdSetFragmentShadingRateKHR(commandBuffer: VkCommandBuffer, pFragmentSize: *VkExtent2D, combinerOps: [2]VkFragmentShadingRateCombinerOpKHR);
    void vkCmdSetRenderingAttachmentLocationsKHR(commandBuffer: VkCommandBuffer, pLocationInfo: *VkRenderingAttachmentLocationInfo);
    void vkCmdSetRenderingInputAttachmentIndicesKHR(commandBuffer: VkCommandBuffer, pInputAttachmentIndexInfo: *VkRenderingInputAttachmentIndexInfo);
    VkResult vkWaitForPresentKHR(device: VkDevice, swapchain: VkSwapchainKHR, presentId: uint64, timeout: uint64);
    VkDeviceAddress vkGetBufferDeviceAddressKHR(device: VkDevice, pInfo: *VkBufferDeviceAddressInfo);
    uint64 vkGetBufferOpaqueCaptureAddressKHR(device: VkDevice, pInfo: *VkBufferDeviceAddressInfo);
    uint64 vkGetDeviceMemoryOpaqueCaptureAddressKHR(device: VkDevice, pInfo: *VkDeviceMemoryOpaqueCaptureAddressInfo);
    VkResult vkCreateDeferredOperationKHR(device: VkDevice, pAllocator: *VkAllocationCallbacks, pDeferredOperation: *VkDeferredOperationKHR);
    void vkDestroyDeferredOperationKHR(device: VkDevice, operation: VkDeferredOperationKHR, pAllocator: *VkAllocationCallbacks);
    uint32 vkGetDeferredOperationMaxConcurrencyKHR(device: VkDevice, operation: VkDeferredOperationKHR);
    VkResult vkGetDeferredOperationResultKHR(device: VkDevice, operation: VkDeferredOperationKHR);
    VkResult vkDeferredOperationJoinKHR(device: VkDevice, operation: VkDeferredOperationKHR);
    VkResult vkGetPipelineExecutablePropertiesKHR(device: VkDevice, pPipelineInfo: *VkPipelineInfoKHR, pExecutableCount: *uint32, pProperties: *VkPipelineExecutablePropertiesKHR);
    VkResult vkGetPipelineExecutableStatisticsKHR(device: VkDevice, pExecutableInfo: *VkPipelineExecutableInfoKHR, pStatisticCount: *uint32, pStatistics: *VkPipelineExecutableStatisticKHR);
    VkResult vkGetPipelineExecutableInternalRepresentationsKHR(device: VkDevice, pExecutableInfo: *VkPipelineExecutableInfoKHR, pInternalRepresentationCount: *uint32, pInternalRepresentations: *VkPipelineExecutableInternalRepresentationKHR);
    VkResult vkMapMemory2KHR(device: VkDevice, pMemoryMapInfo: *VkMemoryMapInfo, ppData: **void);
    VkResult vkUnmapMemory2KHR(device: VkDevice, pMemoryUnmapInfo: *VkMemoryUnmapInfo);
    VkResult vkGetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR(physicalDevice: VkPhysicalDevice, pQualityLevelInfo: *VkPhysicalDeviceVideoEncodeQualityLevelInfoKHR, pQualityLevelProperties: *VkVideoEncodeQualityLevelPropertiesKHR);
    VkResult vkGetEncodedVideoSessionParametersKHR(device: VkDevice, pVideoSessionParametersInfo: *VkVideoEncodeSessionParametersGetInfoKHR, pFeedbackInfo: *VkVideoEncodeSessionParametersFeedbackInfoKHR, pDataSize: *uint, pData: *void);
    void vkCmdEncodeVideoKHR(commandBuffer: VkCommandBuffer, pEncodeInfo: *VkVideoEncodeInfoKHR);
    void vkCmdSetEvent2KHR(commandBuffer: VkCommandBuffer, event: VkEvent, pDependencyInfo: *VkDependencyInfo);
    void vkCmdResetEvent2KHR(commandBuffer: VkCommandBuffer, event: VkEvent, stageMask: VkPipelineStageFlags2);
    void vkCmdWaitEvents2KHR(commandBuffer: VkCommandBuffer, eventCount: uint32, pEvents: *VkEvent, pDependencyInfos: *VkDependencyInfo);
    void vkCmdPipelineBarrier2KHR(commandBuffer: VkCommandBuffer, pDependencyInfo: *VkDependencyInfo);
    void vkCmdWriteTimestamp2KHR(commandBuffer: VkCommandBuffer, stage: VkPipelineStageFlags2, queryPool: VkQueryPool, query: uint32);
    VkResult vkQueueSubmit2KHR(queue: VkQueue, submitCount: uint32, pSubmits: *VkSubmitInfo2, fence: VkFence);
    void vkCmdCopyBuffer2KHR(commandBuffer: VkCommandBuffer, pCopyBufferInfo: *VkCopyBufferInfo2);
    void vkCmdCopyImage2KHR(commandBuffer: VkCommandBuffer, pCopyImageInfo: *VkCopyImageInfo2);
    void vkCmdCopyBufferToImage2KHR(commandBuffer: VkCommandBuffer, pCopyBufferToImageInfo: *VkCopyBufferToImageInfo2);
    void vkCmdCopyImageToBuffer2KHR(commandBuffer: VkCommandBuffer, pCopyImageToBufferInfo: *VkCopyImageToBufferInfo2);
    void vkCmdBlitImage2KHR(commandBuffer: VkCommandBuffer, pBlitImageInfo: *VkBlitImageInfo2);
    void vkCmdResolveImage2KHR(commandBuffer: VkCommandBuffer, pResolveImageInfo: *VkResolveImageInfo2);
    void vkCmdTraceRaysIndirect2KHR(commandBuffer: VkCommandBuffer, indirectDeviceAddress: VkDeviceAddress);
    void vkGetDeviceBufferMemoryRequirementsKHR(device: VkDevice, pInfo: *VkDeviceBufferMemoryRequirements, pMemoryRequirements: *VkMemoryRequirements2);
    void vkGetDeviceImageMemoryRequirementsKHR(device: VkDevice, pInfo: *VkDeviceImageMemoryRequirements, pMemoryRequirements: *VkMemoryRequirements2);
    void vkGetDeviceImageSparseMemoryRequirementsKHR(device: VkDevice, pInfo: *VkDeviceImageMemoryRequirements, pSparseMemoryRequirementCount: *uint32, pSparseMemoryRequirements: *VkSparseImageMemoryRequirements2);
    void vkCmdBindIndexBuffer2KHR(commandBuffer: VkCommandBuffer, buffer: VkBuffer, offset: VkDeviceSize, size: VkDeviceSize, indexType: VkIndexType);
    void vkGetRenderingAreaGranularityKHR(device: VkDevice, pRenderingAreaInfo: *VkRenderingAreaInfo, pGranularity: *VkExtent2D);
    void vkGetDeviceImageSubresourceLayoutKHR(device: VkDevice, pInfo: *VkDeviceImageSubresourceInfo, pLayout: *VkSubresourceLayout2);
    void vkGetImageSubresourceLayout2KHR(device: VkDevice, image: VkImage, pSubresource: *VkImageSubresource2, pLayout: *VkSubresourceLayout2);
    VkResult vkCreatePipelineBinariesKHR(device: VkDevice, pCreateInfo: *VkPipelineBinaryCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pBinaries: *VkPipelineBinaryHandlesInfoKHR);
    void vkDestroyPipelineBinaryKHR(device: VkDevice, pipelineBinary: VkPipelineBinaryKHR, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetPipelineKeyKHR(device: VkDevice, pPipelineCreateInfo: *VkPipelineCreateInfoKHR, pPipelineKey: *VkPipelineBinaryKeyKHR);
    VkResult vkGetPipelineBinaryDataKHR(device: VkDevice, pInfo: *VkPipelineBinaryDataInfoKHR, pPipelineBinaryKey: *VkPipelineBinaryKeyKHR, pPipelineBinaryDataSize: *uint, pPipelineBinaryData: *void);
    VkResult vkReleaseCapturedPipelineDataKHR(device: VkDevice, pInfo: *VkReleaseCapturedPipelineDataInfoKHR, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetPhysicalDeviceCooperativeMatrixPropertiesKHR(physicalDevice: VkPhysicalDevice, pPropertyCount: *uint32, pProperties: *VkCooperativeMatrixPropertiesKHR);
    void vkCmdSetLineStippleKHR(commandBuffer: VkCommandBuffer, lineStippleFactor: uint32, lineStipplePattern: uint16_t);
    VkResult vkGetPhysicalDeviceCalibrateableTimeDomainsKHR(physicalDevice: VkPhysicalDevice, pTimeDomainCount: *uint32, pTimeDomains: *VkTimeDomainKHR);
    VkResult vkGetCalibratedTimestampsKHR(device: VkDevice, timestampCount: uint32, pTimestampInfos: *VkCalibratedTimestampInfoKHR, pTimestamps: *uint64, pMaxDeviation: *uint64);
    void vkCmdBindDescriptorSets2KHR(commandBuffer: VkCommandBuffer, pBindDescriptorSetsInfo: *VkBindDescriptorSetsInfo);
    void vkCmdPushConstants2KHR(commandBuffer: VkCommandBuffer, pPushConstantsInfo: *VkPushConstantsInfo);
    void vkCmdPushDescriptorSet2KHR(commandBuffer: VkCommandBuffer, pPushDescriptorSetInfo: *VkPushDescriptorSetInfo);
    void vkCmdPushDescriptorSetWithTemplate2KHR(commandBuffer: VkCommandBuffer, pPushDescriptorSetWithTemplateInfo: *VkPushDescriptorSetWithTemplateInfo);
    void vkCmdSetDescriptorBufferOffsets2EXT(commandBuffer: VkCommandBuffer, pSetDescriptorBufferOffsetsInfo: *VkSetDescriptorBufferOffsetsInfoEXT);
    void vkCmdBindDescriptorBufferEmbeddedSamplers2EXT(commandBuffer: VkCommandBuffer, pBindDescriptorBufferEmbeddedSamplersInfo: *VkBindDescriptorBufferEmbeddedSamplersInfoEXT);
    VkResult vkCreateDebugReportCallbackEXT(instance: VkInstance, pCreateInfo: *VkDebugReportCallbackCreateInfoEXT, pAllocator: *VkAllocationCallbacks, pCallback: *VkDebugReportCallbackEXT);
    void vkDestroyDebugReportCallbackEXT(instance: VkInstance, callback: VkDebugReportCallbackEXT, pAllocator: *VkAllocationCallbacks);
    void vkDebugReportMessageEXT(instance: VkInstance, flags: VkDebugReportFlagsEXT, objectType: VkDebugReportObjectTypeEXT, object: uint64, location: uint, messageCode: int32, pLayerPrefix: *byte, pMessage: *byte);
    VkResult vkDebugMarkerSetObjectTagEXT(device: VkDevice, pTagInfo: *VkDebugMarkerObjectTagInfoEXT);
    VkResult vkDebugMarkerSetObjectNameEXT(device: VkDevice, pNameInfo: *VkDebugMarkerObjectNameInfoEXT);
    void vkCmdDebugMarkerBeginEXT(commandBuffer: VkCommandBuffer, pMarkerInfo: *VkDebugMarkerMarkerInfoEXT);
    void vkCmdDebugMarkerEndEXT(commandBuffer: VkCommandBuffer);
    void vkCmdDebugMarkerInsertEXT(commandBuffer: VkCommandBuffer, pMarkerInfo: *VkDebugMarkerMarkerInfoEXT);
    void vkCmdBindTransformFeedbackBuffersEXT(commandBuffer: VkCommandBuffer, firstBinding: uint32, bindingCount: uint32, pBuffers: *VkBuffer, pOffsets: *VkDeviceSize, pSizes: *VkDeviceSize);
    void vkCmdBeginTransformFeedbackEXT(commandBuffer: VkCommandBuffer, firstCounterBuffer: uint32, counterBufferCount: uint32, pCounterBuffers: *VkBuffer, pCounterBufferOffsets: *VkDeviceSize);
    void vkCmdEndTransformFeedbackEXT(commandBuffer: VkCommandBuffer, firstCounterBuffer: uint32, counterBufferCount: uint32, pCounterBuffers: *VkBuffer, pCounterBufferOffsets: *VkDeviceSize);
    void vkCmdBeginQueryIndexedEXT(commandBuffer: VkCommandBuffer, queryPool: VkQueryPool, query: uint32, flags: VkQueryControlFlags, index: uint32);
    void vkCmdEndQueryIndexedEXT(commandBuffer: VkCommandBuffer, queryPool: VkQueryPool, query: uint32, index: uint32);
    void vkCmdDrawIndirectByteCountEXT(commandBuffer: VkCommandBuffer, instanceCount: uint32, firstInstance: uint32, counterBuffer: VkBuffer, counterBufferOffset: VkDeviceSize, counterOffset: uint32, vertexStride: uint32);
    VkResult vkCreateCuModuleNVX(device: VkDevice, pCreateInfo: *VkCuModuleCreateInfoNVX, pAllocator: *VkAllocationCallbacks, pModule: *VkCuModuleNVX);
    VkResult vkCreateCuFunctionNVX(device: VkDevice, pCreateInfo: *VkCuFunctionCreateInfoNVX, pAllocator: *VkAllocationCallbacks, pFunction: *VkCuFunctionNVX);
    void vkDestroyCuModuleNVX(device: VkDevice, module: VkCuModuleNVX, pAllocator: *VkAllocationCallbacks);
    void vkDestroyCuFunctionNVX(device: VkDevice, function: VkCuFunctionNVX, pAllocator: *VkAllocationCallbacks);
    void vkCmdCuLaunchKernelNVX(commandBuffer: VkCommandBuffer, pLaunchInfo: *VkCuLaunchInfoNVX);
    uint32 vkGetImageViewHandleNVX(device: VkDevice, pInfo: *VkImageViewHandleInfoNVX);
    uint64 vkGetImageViewHandle64NVX(device: VkDevice, pInfo: *VkImageViewHandleInfoNVX);
    VkResult vkGetImageViewAddressNVX(device: VkDevice, imageView: VkImageView, pProperties: *VkImageViewAddressPropertiesNVX);
    void vkCmdDrawIndirectCountAMD(commandBuffer: VkCommandBuffer, buffer: VkBuffer, offset: VkDeviceSize, countBuffer: VkBuffer, countBufferOffset: VkDeviceSize, maxDrawCount: uint32, stride: uint32);
    void vkCmdDrawIndexedIndirectCountAMD(commandBuffer: VkCommandBuffer, buffer: VkBuffer, offset: VkDeviceSize, countBuffer: VkBuffer, countBufferOffset: VkDeviceSize, maxDrawCount: uint32, stride: uint32);
    VkResult vkGetShaderInfoAMD(device: VkDevice, pipeline: VkPipeline, shaderStage: VkShaderStageFlagBits, infoType: VkShaderInfoTypeAMD, pInfoSize: *uint, pInfo: *void);
    VkResult vkGetPhysicalDeviceExternalImageFormatPropertiesNV(physicalDevice: VkPhysicalDevice, format: VkFormat, type: VkImageType, tiling: VkImageTiling, usage: VkImageUsageFlags, flags: VkImageCreateFlags, externalHandleType: VkExternalMemoryHandleTypeFlagsNV, pExternalImageFormatProperties: *VkExternalImageFormatPropertiesNV);
    void vkCmdBeginConditionalRenderingEXT(commandBuffer: VkCommandBuffer, pConditionalRenderingBegin: *VkConditionalRenderingBeginInfoEXT);
    void vkCmdEndConditionalRenderingEXT(commandBuffer: VkCommandBuffer);
    void vkCmdSetViewportWScalingNV(commandBuffer: VkCommandBuffer, firstViewport: uint32, viewportCount: uint32, pViewportWScalings: *VkViewportWScalingNV);
    VkResult vkReleaseDisplayEXT(physicalDevice: VkPhysicalDevice, display: VkDisplayKHR);
    VkResult vkGetPhysicalDeviceSurfaceCapabilities2EXT(physicalDevice: VkPhysicalDevice, surface: VkSurfaceKHR, pSurfaceCapabilities: *VkSurfaceCapabilities2EXT);
    VkResult vkDisplayPowerControlEXT(device: VkDevice, display: VkDisplayKHR, pDisplayPowerInfo: *VkDisplayPowerInfoEXT);
    VkResult vkRegisterDeviceEventEXT(device: VkDevice, pDeviceEventInfo: *VkDeviceEventInfoEXT, pAllocator: *VkAllocationCallbacks, pFence: *VkFence);
    VkResult vkRegisterDisplayEventEXT(device: VkDevice, display: VkDisplayKHR, pDisplayEventInfo: *VkDisplayEventInfoEXT, pAllocator: *VkAllocationCallbacks, pFence: *VkFence);
    VkResult vkGetSwapchainCounterEXT(device: VkDevice, swapchain: VkSwapchainKHR, counter: VkSurfaceCounterFlagBitsEXT, pCounterValue: *uint64);
    VkResult vkGetRefreshCycleDurationGOOGLE(device: VkDevice, swapchain: VkSwapchainKHR, pDisplayTimingProperties: *VkRefreshCycleDurationGOOGLE);
    VkResult vkGetPastPresentationTimingGOOGLE(device: VkDevice, swapchain: VkSwapchainKHR, pPresentationTimingCount: *uint32, pPresentationTimings: *VkPastPresentationTimingGOOGLE);
    void vkCmdSetDiscardRectangleEXT(commandBuffer: VkCommandBuffer, firstDiscardRectangle: uint32, discardRectangleCount: uint32, pDiscardRectangles: *VkRect2D);
    void vkCmdSetDiscardRectangleEnableEXT(commandBuffer: VkCommandBuffer, discardRectangleEnable: VkBool32);
    void vkCmdSetDiscardRectangleModeEXT(commandBuffer: VkCommandBuffer, discardRectangleMode: VkDiscardRectangleModeEXT);
    void vkSetHdrMetadataEXT(device: VkDevice, swapchainCount: uint32, pSwapchains: *VkSwapchainKHR, pMetadata: *VkHdrMetadataEXT);
    VkResult vkSetDebugUtilsObjectNameEXT(device: VkDevice, pNameInfo: *VkDebugUtilsObjectNameInfoEXT);
    VkResult vkSetDebugUtilsObjectTagEXT(device: VkDevice, pTagInfo: *VkDebugUtilsObjectTagInfoEXT);
    void vkQueueBeginDebugUtilsLabelEXT(queue: VkQueue, pLabelInfo: *VkDebugUtilsLabelEXT);
    void vkQueueEndDebugUtilsLabelEXT(queue: VkQueue);
    void vkQueueInsertDebugUtilsLabelEXT(queue: VkQueue, pLabelInfo: *VkDebugUtilsLabelEXT);
    void vkCmdBeginDebugUtilsLabelEXT(commandBuffer: VkCommandBuffer, pLabelInfo: *VkDebugUtilsLabelEXT);
    void vkCmdEndDebugUtilsLabelEXT(commandBuffer: VkCommandBuffer);
    void vkCmdInsertDebugUtilsLabelEXT(commandBuffer: VkCommandBuffer, pLabelInfo: *VkDebugUtilsLabelEXT);
    VkResult vkCreateDebugUtilsMessengerEXT(instance: VkInstance, pCreateInfo: *VkDebugUtilsMessengerCreateInfoEXT, pAllocator: *VkAllocationCallbacks, pMessenger: *VkDebugUtilsMessengerEXT);
    void vkDestroyDebugUtilsMessengerEXT(instance: VkInstance, messenger: VkDebugUtilsMessengerEXT, pAllocator: *VkAllocationCallbacks);
    void vkSubmitDebugUtilsMessageEXT(instance: VkInstance, messageSeverity: VkDebugUtilsMessageSeverityFlagBitsEXT, messageTypes: VkDebugUtilsMessageTypeFlagsEXT, pCallbackData: *VkDebugUtilsMessengerCallbackDataEXT);
    void vkCmdSetSampleLocationsEXT(commandBuffer: VkCommandBuffer, pSampleLocationsInfo: *VkSampleLocationsInfoEXT);
    void vkGetPhysicalDeviceMultisamplePropertiesEXT(physicalDevice: VkPhysicalDevice, samples: VkSampleCountFlagBits, pMultisampleProperties: *VkMultisamplePropertiesEXT);
    VkResult vkGetImageDrmFormatModifierPropertiesEXT(device: VkDevice, image: VkImage, pProperties: *VkImageDrmFormatModifierPropertiesEXT);
    VkResult vkCreateValidationCacheEXT(device: VkDevice, pCreateInfo: *VkValidationCacheCreateInfoEXT, pAllocator: *VkAllocationCallbacks, pValidationCache: *VkValidationCacheEXT);
    void vkDestroyValidationCacheEXT(device: VkDevice, validationCache: VkValidationCacheEXT, pAllocator: *VkAllocationCallbacks);
    VkResult vkMergeValidationCachesEXT(device: VkDevice, dstCache: VkValidationCacheEXT, srcCacheCount: uint32, pSrcCaches: *VkValidationCacheEXT);
    VkResult vkGetValidationCacheDataEXT(device: VkDevice, validationCache: VkValidationCacheEXT, pDataSize: *uint, pData: *void);
    void vkCmdBindShadingRateImageNV(commandBuffer: VkCommandBuffer, imageView: VkImageView, imageLayout: VkImageLayout);
    void vkCmdSetViewportShadingRatePaletteNV(commandBuffer: VkCommandBuffer, firstViewport: uint32, viewportCount: uint32, pShadingRatePalettes: *VkShadingRatePaletteNV);
    void vkCmdSetCoarseSampleOrderNV(commandBuffer: VkCommandBuffer, sampleOrderType: VkCoarseSampleOrderTypeNV, customSampleOrderCount: uint32, pCustomSampleOrders: *VkCoarseSampleOrderCustomNV);
    VkResult vkCreateAccelerationStructureNV(device: VkDevice, pCreateInfo: *VkAccelerationStructureCreateInfoNV, pAllocator: *VkAllocationCallbacks, pAccelerationStructure: *VkAccelerationStructureNV);
    void vkDestroyAccelerationStructureNV(device: VkDevice, accelerationStructure: VkAccelerationStructureNV, pAllocator: *VkAllocationCallbacks);
    void vkGetAccelerationStructureMemoryRequirementsNV(device: VkDevice, pInfo: *VkAccelerationStructureMemoryRequirementsInfoNV, pMemoryRequirements: *VkMemoryRequirements2KHR);
    VkResult vkBindAccelerationStructureMemoryNV(device: VkDevice, bindInfoCount: uint32, pBindInfos: *VkBindAccelerationStructureMemoryInfoNV);
    void vkCmdBuildAccelerationStructureNV(commandBuffer: VkCommandBuffer, pInfo: *VkAccelerationStructureInfoNV, instanceData: VkBuffer, instanceOffset: VkDeviceSize, update: VkBool32, dst: VkAccelerationStructureNV, src: VkAccelerationStructureNV, scratch: VkBuffer, scratchOffset: VkDeviceSize);
    void vkCmdCopyAccelerationStructureNV(commandBuffer: VkCommandBuffer, dst: VkAccelerationStructureNV, src: VkAccelerationStructureNV, mode: VkCopyAccelerationStructureModeKHR);
    void vkCmdTraceRaysNV(commandBuffer: VkCommandBuffer, raygenShaderBindingTableBuffer: VkBuffer, raygenShaderBindingOffset: VkDeviceSize, missShaderBindingTableBuffer: VkBuffer, missShaderBindingOffset: VkDeviceSize, missShaderBindingStride: VkDeviceSize, hitShaderBindingTableBuffer: VkBuffer, hitShaderBindingOffset: VkDeviceSize, hitShaderBindingStride: VkDeviceSize, callableShaderBindingTableBuffer: VkBuffer, callableShaderBindingOffset: VkDeviceSize, callableShaderBindingStride: VkDeviceSize, width: uint32, height: uint32, depth: uint32);
    VkResult vkCreateRayTracingPipelinesNV(device: VkDevice, pipelineCache: VkPipelineCache, createInfoCount: uint32, pCreateInfos: *VkRayTracingPipelineCreateInfoNV, pAllocator: *VkAllocationCallbacks, pPipelines: *VkPipeline);
    VkResult vkGetRayTracingShaderGroupHandlesKHR(device: VkDevice, pipeline: VkPipeline, firstGroup: uint32, groupCount: uint32, dataSize: uint, pData: *void);
    VkResult vkGetRayTracingShaderGroupHandlesNV(device: VkDevice, pipeline: VkPipeline, firstGroup: uint32, groupCount: uint32, dataSize: uint, pData: *void);
    VkResult vkGetAccelerationStructureHandleNV(device: VkDevice, accelerationStructure: VkAccelerationStructureNV, dataSize: uint, pData: *void);
    void vkCmdWriteAccelerationStructuresPropertiesNV(commandBuffer: VkCommandBuffer, accelerationStructureCount: uint32, pAccelerationStructures: *VkAccelerationStructureNV, queryType: VkQueryType, queryPool: VkQueryPool, firstQuery: uint32);
    VkResult vkCompileDeferredNV(device: VkDevice, pipeline: VkPipeline, shader: uint32);
    VkResult vkGetMemoryHostPointerPropertiesEXT(device: VkDevice, handleType: VkExternalMemoryHandleTypeFlagBits, pHostPointer: *void, pMemoryHostPointerProperties: *VkMemoryHostPointerPropertiesEXT);
    void vkCmdWriteBufferMarkerAMD(commandBuffer: VkCommandBuffer, pipelineStage: VkPipelineStageFlagBits, dstBuffer: VkBuffer, dstOffset: VkDeviceSize, marker: uint32);
    void vkCmdWriteBufferMarker2AMD(commandBuffer: VkCommandBuffer, stage: VkPipelineStageFlags2, dstBuffer: VkBuffer, dstOffset: VkDeviceSize, marker: uint32);
    VkResult vkGetPhysicalDeviceCalibrateableTimeDomainsEXT(physicalDevice: VkPhysicalDevice, pTimeDomainCount: *uint32, pTimeDomains: *VkTimeDomainKHR);
    VkResult vkGetCalibratedTimestampsEXT(device: VkDevice, timestampCount: uint32, pTimestampInfos: *VkCalibratedTimestampInfoKHR, pTimestamps: *uint64, pMaxDeviation: *uint64);
    void vkCmdDrawMeshTasksNV(commandBuffer: VkCommandBuffer, taskCount: uint32, firstTask: uint32);
    void vkCmdDrawMeshTasksIndirectNV(commandBuffer: VkCommandBuffer, buffer: VkBuffer, offset: VkDeviceSize, drawCount: uint32, stride: uint32);
    void vkCmdDrawMeshTasksIndirectCountNV(commandBuffer: VkCommandBuffer, buffer: VkBuffer, offset: VkDeviceSize, countBuffer: VkBuffer, countBufferOffset: VkDeviceSize, maxDrawCount: uint32, stride: uint32);
    void vkCmdSetExclusiveScissorEnableNV(commandBuffer: VkCommandBuffer, firstExclusiveScissor: uint32, exclusiveScissorCount: uint32, pExclusiveScissorEnables: *VkBool32);
    void vkCmdSetExclusiveScissorNV(commandBuffer: VkCommandBuffer, firstExclusiveScissor: uint32, exclusiveScissorCount: uint32, pExclusiveScissors: *VkRect2D);
    void vkCmdSetCheckpointNV(commandBuffer: VkCommandBuffer, pCheckpointMarker: *void);
    void vkGetQueueCheckpointDataNV(queue: VkQueue, pCheckpointDataCount: *uint32, pCheckpointData: *VkCheckpointDataNV);
    void vkGetQueueCheckpointData2NV(queue: VkQueue, pCheckpointDataCount: *uint32, pCheckpointData: *VkCheckpointData2NV);
    VkResult vkInitializePerformanceApiINTEL(device: VkDevice, pInitializeInfo: *VkInitializePerformanceApiInfoINTEL);
    void vkUninitializePerformanceApiINTEL(device: VkDevice);
    VkResult vkCmdSetPerformanceMarkerINTEL(commandBuffer: VkCommandBuffer, pMarkerInfo: *VkPerformanceMarkerInfoINTEL);
    VkResult vkCmdSetPerformanceStreamMarkerINTEL(commandBuffer: VkCommandBuffer, pMarkerInfo: *VkPerformanceStreamMarkerInfoINTEL);
    VkResult vkCmdSetPerformanceOverrideINTEL(commandBuffer: VkCommandBuffer, pOverrideInfo: *VkPerformanceOverrideInfoINTEL);
    VkResult vkAcquirePerformanceConfigurationINTEL(device: VkDevice, pAcquireInfo: *VkPerformanceConfigurationAcquireInfoINTEL, pConfiguration: *VkPerformanceConfigurationINTEL);
    VkResult vkReleasePerformanceConfigurationINTEL(device: VkDevice, configuration: VkPerformanceConfigurationINTEL);
    VkResult vkQueueSetPerformanceConfigurationINTEL(queue: VkQueue, configuration: VkPerformanceConfigurationINTEL);
    VkResult vkGetPerformanceParameterINTEL(device: VkDevice, parameter: VkPerformanceParameterTypeINTEL, pValue: *VkPerformanceValueINTEL);
    void vkSetLocalDimmingAMD(device: VkDevice, swapChain: VkSwapchainKHR, localDimmingEnable: VkBool32);
    VkDeviceAddress vkGetBufferDeviceAddressEXT(device: VkDevice, pInfo: *VkBufferDeviceAddressInfo);
    VkResult vkGetPhysicalDeviceToolPropertiesEXT(physicalDevice: VkPhysicalDevice, pToolCount: *uint32, pToolProperties: *VkPhysicalDeviceToolProperties);
    VkResult vkGetPhysicalDeviceCooperativeMatrixPropertiesNV(physicalDevice: VkPhysicalDevice, pPropertyCount: *uint32, pProperties: *VkCooperativeMatrixPropertiesNV);
    VkResult vkGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV(physicalDevice: VkPhysicalDevice, pCombinationCount: *uint32, pCombinations: *VkFramebufferMixedSamplesCombinationNV);
    VkResult vkCreateHeadlessSurfaceEXT(instance: VkInstance, pCreateInfo: *VkHeadlessSurfaceCreateInfoEXT, pAllocator: *VkAllocationCallbacks, pSurface: *VkSurfaceKHR);
    void vkCmdSetLineStippleEXT(commandBuffer: VkCommandBuffer, lineStippleFactor: uint32, lineStipplePattern: uint16_t);
    void vkResetQueryPoolEXT(device: VkDevice, queryPool: VkQueryPool, firstQuery: uint32, queryCount: uint32);
    void vkCmdSetCullModeEXT(commandBuffer: VkCommandBuffer, cullMode: VkCullModeFlags);
    void vkCmdSetFrontFaceEXT(commandBuffer: VkCommandBuffer, frontFace: VkFrontFace);
    void vkCmdSetPrimitiveTopologyEXT(commandBuffer: VkCommandBuffer, primitiveTopology: VkPrimitiveTopology);
    void vkCmdSetViewportWithCountEXT(commandBuffer: VkCommandBuffer, viewportCount: uint32, pViewports: *VkViewport);
    void vkCmdSetScissorWithCountEXT(commandBuffer: VkCommandBuffer, scissorCount: uint32, pScissors: *VkRect2D);
    void vkCmdBindVertexBuffers2EXT(commandBuffer: VkCommandBuffer, firstBinding: uint32, bindingCount: uint32, pBuffers: *VkBuffer, pOffsets: *VkDeviceSize, pSizes: *VkDeviceSize, pStrides: *VkDeviceSize);
    void vkCmdSetDepthTestEnableEXT(commandBuffer: VkCommandBuffer, depthTestEnable: VkBool32);
    void vkCmdSetDepthWriteEnableEXT(commandBuffer: VkCommandBuffer, depthWriteEnable: VkBool32);
    void vkCmdSetDepthCompareOpEXT(commandBuffer: VkCommandBuffer, depthCompareOp: VkCompareOp);
    void vkCmdSetDepthBoundsTestEnableEXT(commandBuffer: VkCommandBuffer, depthBoundsTestEnable: VkBool32);
    void vkCmdSetStencilTestEnableEXT(commandBuffer: VkCommandBuffer, stencilTestEnable: VkBool32);
    void vkCmdSetStencilOpEXT(commandBuffer: VkCommandBuffer, faceMask: VkStencilFaceFlags, failOp: VkStencilOp, passOp: VkStencilOp, depthFailOp: VkStencilOp, compareOp: VkCompareOp);
    VkResult vkCopyMemoryToImageEXT(device: VkDevice, pCopyMemoryToImageInfo: *VkCopyMemoryToImageInfo);
    VkResult vkCopyImageToMemoryEXT(device: VkDevice, pCopyImageToMemoryInfo: *VkCopyImageToMemoryInfo);
    VkResult vkCopyImageToImageEXT(device: VkDevice, pCopyImageToImageInfo: *VkCopyImageToImageInfo);
    VkResult vkTransitionImageLayoutEXT(device: VkDevice, transitionCount: uint32, pTransitions: *VkHostImageLayoutTransitionInfo);
    void vkGetImageSubresourceLayout2EXT(device: VkDevice, image: VkImage, pSubresource: *VkImageSubresource2, pLayout: *VkSubresourceLayout2);
    VkResult vkReleaseSwapchainImagesEXT(device: VkDevice, pReleaseInfo: *VkReleaseSwapchainImagesInfoEXT);
    void vkGetGeneratedCommandsMemoryRequirementsNV(device: VkDevice, pInfo: *VkGeneratedCommandsMemoryRequirementsInfoNV, pMemoryRequirements: *VkMemoryRequirements2);
    void vkCmdPreprocessGeneratedCommandsNV(commandBuffer: VkCommandBuffer, pGeneratedCommandsInfo: *VkGeneratedCommandsInfoNV);
    void vkCmdExecuteGeneratedCommandsNV(commandBuffer: VkCommandBuffer, isPreprocessed: VkBool32, pGeneratedCommandsInfo: *VkGeneratedCommandsInfoNV);
    void vkCmdBindPipelineShaderGroupNV(commandBuffer: VkCommandBuffer, pipelineBindPoint: VkPipelineBindPoint, pipeline: VkPipeline, groupIndex: uint32);
    VkResult vkCreateIndirectCommandsLayoutNV(device: VkDevice, pCreateInfo: *VkIndirectCommandsLayoutCreateInfoNV, pAllocator: *VkAllocationCallbacks, pIndirectCommandsLayout: *VkIndirectCommandsLayoutNV);
    void vkDestroyIndirectCommandsLayoutNV(device: VkDevice, indirectCommandsLayout: VkIndirectCommandsLayoutNV, pAllocator: *VkAllocationCallbacks);
    void vkCmdSetDepthBias2EXT(commandBuffer: VkCommandBuffer, pDepthBiasInfo: *VkDepthBiasInfoEXT);
    VkResult vkAcquireDrmDisplayEXT(physicalDevice: VkPhysicalDevice, drmFd: int32, display: VkDisplayKHR);
    VkResult vkGetDrmDisplayEXT(physicalDevice: VkPhysicalDevice, drmFd: int32, connectorId: uint32, display: *VkDisplayKHR);
    VkResult vkCreatePrivateDataSlotEXT(device: VkDevice, pCreateInfo: *VkPrivateDataSlotCreateInfo, pAllocator: *VkAllocationCallbacks, pPrivateDataSlot: *VkPrivateDataSlot);
    void vkDestroyPrivateDataSlotEXT(device: VkDevice, privateDataSlot: VkPrivateDataSlot, pAllocator: *VkAllocationCallbacks);
    VkResult vkSetPrivateDataEXT(device: VkDevice, objectType: VkObjectType, objectHandle: uint64, privateDataSlot: VkPrivateDataSlot, data: uint64);
    void vkGetPrivateDataEXT(device: VkDevice, objectType: VkObjectType, objectHandle: uint64, privateDataSlot: VkPrivateDataSlot, pData: *uint64);
    VkResult vkCreateCudaModuleNV(device: VkDevice, pCreateInfo: *VkCudaModuleCreateInfoNV, pAllocator: *VkAllocationCallbacks, pModule: *VkCudaModuleNV);
    VkResult vkGetCudaModuleCacheNV(device: VkDevice, module: VkCudaModuleNV, pCacheSize: *uint, pCacheData: *void);
    VkResult vkCreateCudaFunctionNV(device: VkDevice, pCreateInfo: *VkCudaFunctionCreateInfoNV, pAllocator: *VkAllocationCallbacks, pFunction: *VkCudaFunctionNV);
    void vkDestroyCudaModuleNV(device: VkDevice, module: VkCudaModuleNV, pAllocator: *VkAllocationCallbacks);
    void vkDestroyCudaFunctionNV(device: VkDevice, function: VkCudaFunctionNV, pAllocator: *VkAllocationCallbacks);
    void vkCmdCudaLaunchKernelNV(commandBuffer: VkCommandBuffer, pLaunchInfo: *VkCudaLaunchInfoNV);
    void vkGetDescriptorSetLayoutSizeEXT(device: VkDevice, layout: VkDescriptorSetLayout, pLayoutSizeInBytes: *VkDeviceSize);
    void vkGetDescriptorSetLayoutBindingOffsetEXT(device: VkDevice, layout: VkDescriptorSetLayout, binding: uint32, pOffset: *VkDeviceSize);
    void vkGetDescriptorEXT(device: VkDevice, pDescriptorInfo: *VkDescriptorGetInfoEXT, dataSize: uint, pDescriptor: *void);
    void vkCmdBindDescriptorBuffersEXT(commandBuffer: VkCommandBuffer, bufferCount: uint32, pBindingInfos: *VkDescriptorBufferBindingInfoEXT);
    void vkCmdSetDescriptorBufferOffsetsEXT(commandBuffer: VkCommandBuffer, pipelineBindPoint: VkPipelineBindPoint, layout: VkPipelineLayout, firstSet: uint32, setCount: uint32, pBufferIndices: *uint32, pOffsets: *VkDeviceSize);
    void vkCmdBindDescriptorBufferEmbeddedSamplersEXT(commandBuffer: VkCommandBuffer, pipelineBindPoint: VkPipelineBindPoint, layout: VkPipelineLayout, set: uint32);
    VkResult vkGetBufferOpaqueCaptureDescriptorDataEXT(device: VkDevice, pInfo: *VkBufferCaptureDescriptorDataInfoEXT, pData: *void);
    VkResult vkGetImageOpaqueCaptureDescriptorDataEXT(device: VkDevice, pInfo: *VkImageCaptureDescriptorDataInfoEXT, pData: *void);
    VkResult vkGetImageViewOpaqueCaptureDescriptorDataEXT(device: VkDevice, pInfo: *VkImageViewCaptureDescriptorDataInfoEXT, pData: *void);
    VkResult vkGetSamplerOpaqueCaptureDescriptorDataEXT(device: VkDevice, pInfo: *VkSamplerCaptureDescriptorDataInfoEXT, pData: *void);
    VkResult vkGetAccelerationStructureOpaqueCaptureDescriptorDataEXT(device: VkDevice, pInfo: *VkAccelerationStructureCaptureDescriptorDataInfoEXT, pData: *void);
    void vkCmdSetFragmentShadingRateEnumNV(commandBuffer: VkCommandBuffer, shadingRate: VkFragmentShadingRateNV, combinerOps: [2]VkFragmentShadingRateCombinerOpKHR);
    VkResult vkGetDeviceFaultInfoEXT(device: VkDevice, pFaultCounts: *VkDeviceFaultCountsEXT, pFaultInfo: *VkDeviceFaultInfoEXT);
    void vkCmdSetVertexInputEXT(commandBuffer: VkCommandBuffer, vertexBindingDescriptionCount: uint32, pVertexBindingDescriptions: *VkVertexInputBindingDescription2EXT, vertexAttributeDescriptionCount: uint32, pVertexAttributeDescriptions: *VkVertexInputAttributeDescription2EXT);
    VkResult vkGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI(device: VkDevice, renderpass: VkRenderPass, pMaxWorkgroupSize: *VkExtent2D);
    void vkCmdSubpassShadingHUAWEI(commandBuffer: VkCommandBuffer);
    void vkCmdBindInvocationMaskHUAWEI(commandBuffer: VkCommandBuffer, imageView: VkImageView, imageLayout: VkImageLayout);
    VkResult vkGetMemoryRemoteAddressNV(device: VkDevice, pMemoryGetRemoteAddressInfo: *VkMemoryGetRemoteAddressInfoNV, pAddress: *VkRemoteAddressNV);
    VkResult vkGetPipelinePropertiesEXT(device: VkDevice, pPipelineInfo: *VkPipelineInfoEXT, pPipelineProperties: *VkBaseOutStructure);
    void vkCmdSetPatchControlPointsEXT(commandBuffer: VkCommandBuffer, patchControlPoints: uint32);
    void vkCmdSetRasterizerDiscardEnableEXT(commandBuffer: VkCommandBuffer, rasterizerDiscardEnable: VkBool32);
    void vkCmdSetDepthBiasEnableEXT(commandBuffer: VkCommandBuffer, depthBiasEnable: VkBool32);
    void vkCmdSetLogicOpEXT(commandBuffer: VkCommandBuffer, logicOp: VkLogicOp);
    void vkCmdSetPrimitiveRestartEnableEXT(commandBuffer: VkCommandBuffer, primitiveRestartEnable: VkBool32);
    void vkCmdSetColorWriteEnableEXT(commandBuffer: VkCommandBuffer, attachmentCount: uint32, pColorWriteEnables: *VkBool32);
    void vkCmdDrawMultiEXT(commandBuffer: VkCommandBuffer, drawCount: uint32, pVertexInfo: *VkMultiDrawInfoEXT, instanceCount: uint32, firstInstance: uint32, stride: uint32);
    void vkCmdDrawMultiIndexedEXT(commandBuffer: VkCommandBuffer, drawCount: uint32, pIndexInfo: *VkMultiDrawIndexedInfoEXT, instanceCount: uint32, firstInstance: uint32, stride: uint32, pVertexOffset: *int32);
    VkResult vkCreateMicromapEXT(device: VkDevice, pCreateInfo: *VkMicromapCreateInfoEXT, pAllocator: *VkAllocationCallbacks, pMicromap: *VkMicromapEXT);
    void vkDestroyMicromapEXT(device: VkDevice, micromap: VkMicromapEXT, pAllocator: *VkAllocationCallbacks);
    void vkCmdBuildMicromapsEXT(commandBuffer: VkCommandBuffer, infoCount: uint32, pInfos: *VkMicromapBuildInfoEXT);
    VkResult vkBuildMicromapsEXT(device: VkDevice, deferredOperation: VkDeferredOperationKHR, infoCount: uint32, pInfos: *VkMicromapBuildInfoEXT);
    VkResult vkCopyMicromapEXT(device: VkDevice, deferredOperation: VkDeferredOperationKHR, pInfo: *VkCopyMicromapInfoEXT);
    VkResult vkCopyMicromapToMemoryEXT(device: VkDevice, deferredOperation: VkDeferredOperationKHR, pInfo: *VkCopyMicromapToMemoryInfoEXT);
    VkResult vkCopyMemoryToMicromapEXT(device: VkDevice, deferredOperation: VkDeferredOperationKHR, pInfo: *VkCopyMemoryToMicromapInfoEXT);
    VkResult vkWriteMicromapsPropertiesEXT(device: VkDevice, micromapCount: uint32, pMicromaps: *VkMicromapEXT, queryType: VkQueryType, dataSize: uint, pData: *void, stride: uint);
    void vkCmdCopyMicromapEXT(commandBuffer: VkCommandBuffer, pInfo: *VkCopyMicromapInfoEXT);
    void vkCmdCopyMicromapToMemoryEXT(commandBuffer: VkCommandBuffer, pInfo: *VkCopyMicromapToMemoryInfoEXT);
    void vkCmdCopyMemoryToMicromapEXT(commandBuffer: VkCommandBuffer, pInfo: *VkCopyMemoryToMicromapInfoEXT);
    void vkCmdWriteMicromapsPropertiesEXT(commandBuffer: VkCommandBuffer, micromapCount: uint32, pMicromaps: *VkMicromapEXT, queryType: VkQueryType, queryPool: VkQueryPool, firstQuery: uint32);
    void vkGetDeviceMicromapCompatibilityEXT(device: VkDevice, pVersionInfo: *VkMicromapVersionInfoEXT, pCompatibility: *VkAccelerationStructureCompatibilityKHR);
    void vkGetMicromapBuildSizesEXT(device: VkDevice, buildType: VkAccelerationStructureBuildTypeKHR, pBuildInfo: *VkMicromapBuildInfoEXT, pSizeInfo: *VkMicromapBuildSizesInfoEXT);
    void vkCmdDrawClusterHUAWEI(commandBuffer: VkCommandBuffer, groupCountX: uint32, groupCountY: uint32, groupCountZ: uint32);
    void vkCmdDrawClusterIndirectHUAWEI(commandBuffer: VkCommandBuffer, buffer: VkBuffer, offset: VkDeviceSize);
    void vkSetDeviceMemoryPriorityEXT(device: VkDevice, memory: VkDeviceMemory, priority: :float);
    void vkGetDescriptorSetLayoutHostMappingInfoVALVE(device: VkDevice, pBindingReference: *VkDescriptorSetBindingReferenceVALVE, pHostMapping: *VkDescriptorSetLayoutHostMappingInfoVALVE);
    void vkGetDescriptorSetHostMappingVALVE(device: VkDevice, descriptorSet: VkDescriptorSet, ppData: **void);
    void vkCmdCopyMemoryIndirectNV(commandBuffer: VkCommandBuffer, copyBufferAddress: VkDeviceAddress, copyCount: uint32, stride: uint32);
    void vkCmdCopyMemoryToImageIndirectNV(commandBuffer: VkCommandBuffer, copyBufferAddress: VkDeviceAddress, copyCount: uint32, stride: uint32, dstImage: VkImage, dstImageLayout: VkImageLayout, pImageSubresources: *VkImageSubresourceLayers);
    void vkCmdDecompressMemoryNV(commandBuffer: VkCommandBuffer, decompressRegionCount: uint32, pDecompressMemoryRegions: *VkDecompressMemoryRegionNV);
    void vkCmdDecompressMemoryIndirectCountNV(commandBuffer: VkCommandBuffer, indirectCommandsAddress: VkDeviceAddress, indirectCommandsCountAddress: VkDeviceAddress, stride: uint32);
    void vkGetPipelineIndirectMemoryRequirementsNV(device: VkDevice, pCreateInfo: *VkComputePipelineCreateInfo, pMemoryRequirements: *VkMemoryRequirements2);
    void vkCmdUpdatePipelineIndirectBufferNV(commandBuffer: VkCommandBuffer, pipelineBindPoint: VkPipelineBindPoint, pipeline: VkPipeline);
    VkDeviceAddress vkGetPipelineIndirectDeviceAddressNV(device: VkDevice, pInfo: *VkPipelineIndirectDeviceAddressInfoNV);
    void vkCmdSetDepthClampEnableEXT(commandBuffer: VkCommandBuffer, depthClampEnable: VkBool32);
    void vkCmdSetPolygonModeEXT(commandBuffer: VkCommandBuffer, polygonMode: VkPolygonMode);
    void vkCmdSetRasterizationSamplesEXT(commandBuffer: VkCommandBuffer, rasterizationSamples: VkSampleCountFlagBits);
    void vkCmdSetSampleMaskEXT(commandBuffer: VkCommandBuffer, samples: VkSampleCountFlagBits, pSampleMask: *VkSampleMask);
    void vkCmdSetAlphaToCoverageEnableEXT(commandBuffer: VkCommandBuffer, alphaToCoverageEnable: VkBool32);
    void vkCmdSetAlphaToOneEnableEXT(commandBuffer: VkCommandBuffer, alphaToOneEnable: VkBool32);
    void vkCmdSetLogicOpEnableEXT(commandBuffer: VkCommandBuffer, logicOpEnable: VkBool32);
    void vkCmdSetColorBlendEnableEXT(commandBuffer: VkCommandBuffer, firstAttachment: uint32, attachmentCount: uint32, pColorBlendEnables: *VkBool32);
    void vkCmdSetColorBlendEquationEXT(commandBuffer: VkCommandBuffer, firstAttachment: uint32, attachmentCount: uint32, pColorBlendEquations: *VkColorBlendEquationEXT);
    void vkCmdSetColorWriteMaskEXT(commandBuffer: VkCommandBuffer, firstAttachment: uint32, attachmentCount: uint32, pColorWriteMasks: *VkColorComponentFlags);
    void vkCmdSetTessellationDomainOriginEXT(commandBuffer: VkCommandBuffer, domainOrigin: VkTessellationDomainOrigin);
    void vkCmdSetRasterizationStreamEXT(commandBuffer: VkCommandBuffer, rasterizationStream: uint32);
    void vkCmdSetConservativeRasterizationModeEXT(commandBuffer: VkCommandBuffer, conservativeRasterizationMode: VkConservativeRasterizationModeEXT);
    void vkCmdSetExtraPrimitiveOverestimationSizeEXT(commandBuffer: VkCommandBuffer, extraPrimitiveOverestimationSize: :float);
    void vkCmdSetDepthClipEnableEXT(commandBuffer: VkCommandBuffer, depthClipEnable: VkBool32);
    void vkCmdSetSampleLocationsEnableEXT(commandBuffer: VkCommandBuffer, sampleLocationsEnable: VkBool32);
    void vkCmdSetColorBlendAdvancedEXT(commandBuffer: VkCommandBuffer, firstAttachment: uint32, attachmentCount: uint32, pColorBlendAdvanced: *VkColorBlendAdvancedEXT);
    void vkCmdSetProvokingVertexModeEXT(commandBuffer: VkCommandBuffer, provokingVertexMode: VkProvokingVertexModeEXT);
    void vkCmdSetLineRasterizationModeEXT(commandBuffer: VkCommandBuffer, lineRasterizationMode: VkLineRasterizationModeEXT);
    void vkCmdSetLineStippleEnableEXT(commandBuffer: VkCommandBuffer, stippledLineEnable: VkBool32);
    void vkCmdSetDepthClipNegativeOneToOneEXT(commandBuffer: VkCommandBuffer, negativeOneToOne: VkBool32);
    void vkCmdSetViewportWScalingEnableNV(commandBuffer: VkCommandBuffer, viewportWScalingEnable: VkBool32);
    void vkCmdSetViewportSwizzleNV(commandBuffer: VkCommandBuffer, firstViewport: uint32, viewportCount: uint32, pViewportSwizzles: *VkViewportSwizzleNV);
    void vkCmdSetCoverageToColorEnableNV(commandBuffer: VkCommandBuffer, coverageToColorEnable: VkBool32);
    void vkCmdSetCoverageToColorLocationNV(commandBuffer: VkCommandBuffer, coverageToColorLocation: uint32);
    void vkCmdSetCoverageModulationModeNV(commandBuffer: VkCommandBuffer, coverageModulationMode: VkCoverageModulationModeNV);
    void vkCmdSetCoverageModulationTableEnableNV(commandBuffer: VkCommandBuffer, coverageModulationTableEnable: VkBool32);
    void vkCmdSetCoverageModulationTableNV(commandBuffer: VkCommandBuffer, coverageModulationTableCount: uint32, pCoverageModulationTable: *:float);
    void vkCmdSetShadingRateImageEnableNV(commandBuffer: VkCommandBuffer, shadingRateImageEnable: VkBool32);
    void vkCmdSetRepresentativeFragmentTestEnableNV(commandBuffer: VkCommandBuffer, representativeFragmentTestEnable: VkBool32);
    void vkCmdSetCoverageReductionModeNV(commandBuffer: VkCommandBuffer, coverageReductionMode: VkCoverageReductionModeNV);
    void vkGetShaderModuleIdentifierEXT(device: VkDevice, shaderModule: VkShaderModule, pIdentifier: *VkShaderModuleIdentifierEXT);
    void vkGetShaderModuleCreateInfoIdentifierEXT(device: VkDevice, pCreateInfo: *VkShaderModuleCreateInfo, pIdentifier: *VkShaderModuleIdentifierEXT);
    VkResult vkGetPhysicalDeviceOpticalFlowImageFormatsNV(physicalDevice: VkPhysicalDevice, pOpticalFlowImageFormatInfo: *VkOpticalFlowImageFormatInfoNV, pFormatCount: *uint32, pImageFormatProperties: *VkOpticalFlowImageFormatPropertiesNV);
    VkResult vkCreateOpticalFlowSessionNV(device: VkDevice, pCreateInfo: *VkOpticalFlowSessionCreateInfoNV, pAllocator: *VkAllocationCallbacks, pSession: *VkOpticalFlowSessionNV);
    void vkDestroyOpticalFlowSessionNV(device: VkDevice, session: VkOpticalFlowSessionNV, pAllocator: *VkAllocationCallbacks);
    VkResult vkBindOpticalFlowSessionImageNV(device: VkDevice, session: VkOpticalFlowSessionNV, bindingPoint: VkOpticalFlowSessionBindingPointNV, view: VkImageView, layout: VkImageLayout);
    void vkCmdOpticalFlowExecuteNV(commandBuffer: VkCommandBuffer, session: VkOpticalFlowSessionNV, pExecuteInfo: *VkOpticalFlowExecuteInfoNV);
    void vkAntiLagUpdateAMD(device: VkDevice, pData: *VkAntiLagDataAMD);
    VkResult vkCreateShadersEXT(device: VkDevice, createInfoCount: uint32, pCreateInfos: *VkShaderCreateInfoEXT, pAllocator: *VkAllocationCallbacks, pShaders: *VkShaderEXT);
    void vkDestroyShaderEXT(device: VkDevice, shader: VkShaderEXT, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetShaderBinaryDataEXT(device: VkDevice, shader: VkShaderEXT, pDataSize: *uint, pData: *void);
    void vkCmdBindShadersEXT(commandBuffer: VkCommandBuffer, stageCount: uint32, pStages: *VkShaderStageFlagBits, pShaders: *VkShaderEXT);
    void vkCmdSetDepthClampRangeEXT(commandBuffer: VkCommandBuffer, depthClampMode: VkDepthClampModeEXT, pDepthClampRange: *VkDepthClampRangeEXT);
    VkResult vkGetFramebufferTilePropertiesQCOM(device: VkDevice, framebuffer: VkFramebuffer, pPropertiesCount: *uint32, pProperties: *VkTilePropertiesQCOM);
    VkResult vkGetDynamicRenderingTilePropertiesQCOM(device: VkDevice, pRenderingInfo: *VkRenderingInfo, pProperties: *VkTilePropertiesQCOM);
    VkResult vkGetPhysicalDeviceCooperativeVectorPropertiesNV(physicalDevice: VkPhysicalDevice, pPropertyCount: *uint32, pProperties: *VkCooperativeVectorPropertiesNV);
    VkResult vkConvertCooperativeVectorMatrixNV(device: VkDevice, pInfo: *VkConvertCooperativeVectorMatrixInfoNV);
    void vkCmdConvertCooperativeVectorMatrixNV(commandBuffer: VkCommandBuffer, infoCount: uint32, pInfos: *VkConvertCooperativeVectorMatrixInfoNV);
    VkResult vkSetLatencySleepModeNV(device: VkDevice, swapchain: VkSwapchainKHR, pSleepModeInfo: *VkLatencySleepModeInfoNV);
    VkResult vkLatencySleepNV(device: VkDevice, swapchain: VkSwapchainKHR, pSleepInfo: *VkLatencySleepInfoNV);
    void vkSetLatencyMarkerNV(device: VkDevice, swapchain: VkSwapchainKHR, pLatencyMarkerInfo: *VkSetLatencyMarkerInfoNV);
    void vkGetLatencyTimingsNV(device: VkDevice, swapchain: VkSwapchainKHR, pLatencyMarkerInfo: *VkGetLatencyMarkerInfoNV);
    void vkQueueNotifyOutOfBandNV(queue: VkQueue, pQueueTypeInfo: *VkOutOfBandQueueTypeInfoNV);
    void vkCmdSetAttachmentFeedbackLoopEnableEXT(commandBuffer: VkCommandBuffer, aspectMask: VkImageAspectFlags);
    void vkGetClusterAccelerationStructureBuildSizesNV(device: VkDevice, pInfo: *VkClusterAccelerationStructureInputInfoNV, pSizeInfo: *VkAccelerationStructureBuildSizesInfoKHR);
    void vkCmdBuildClusterAccelerationStructureIndirectNV(commandBuffer: VkCommandBuffer, pCommandInfos: *VkClusterAccelerationStructureCommandsInfoNV);
    void vkGetPartitionedAccelerationStructuresBuildSizesNV(device: VkDevice, pInfo: *VkPartitionedAccelerationStructureInstancesInputNV, pSizeInfo: *VkAccelerationStructureBuildSizesInfoKHR);
    void vkCmdBuildPartitionedAccelerationStructuresNV(commandBuffer: VkCommandBuffer, pBuildInfo: *VkBuildPartitionedAccelerationStructureInfoNV);
    void vkGetGeneratedCommandsMemoryRequirementsEXT(device: VkDevice, pInfo: *VkGeneratedCommandsMemoryRequirementsInfoEXT, pMemoryRequirements: *VkMemoryRequirements2);
    void vkCmdPreprocessGeneratedCommandsEXT(commandBuffer: VkCommandBuffer, pGeneratedCommandsInfo: *VkGeneratedCommandsInfoEXT, stateCommandBuffer: VkCommandBuffer);
    void vkCmdExecuteGeneratedCommandsEXT(commandBuffer: VkCommandBuffer, isPreprocessed: VkBool32, pGeneratedCommandsInfo: *VkGeneratedCommandsInfoEXT);
    VkResult vkCreateIndirectCommandsLayoutEXT(device: VkDevice, pCreateInfo: *VkIndirectCommandsLayoutCreateInfoEXT, pAllocator: *VkAllocationCallbacks, pIndirectCommandsLayout: *VkIndirectCommandsLayoutEXT);
    void vkDestroyIndirectCommandsLayoutEXT(device: VkDevice, indirectCommandsLayout: VkIndirectCommandsLayoutEXT, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateIndirectExecutionSetEXT(device: VkDevice, pCreateInfo: *VkIndirectExecutionSetCreateInfoEXT, pAllocator: *VkAllocationCallbacks, pIndirectExecutionSet: *VkIndirectExecutionSetEXT);
    void vkDestroyIndirectExecutionSetEXT(device: VkDevice, indirectExecutionSet: VkIndirectExecutionSetEXT, pAllocator: *VkAllocationCallbacks);
    void vkUpdateIndirectExecutionSetPipelineEXT(device: VkDevice, indirectExecutionSet: VkIndirectExecutionSetEXT, executionSetWriteCount: uint32, pExecutionSetWrites: *VkWriteIndirectExecutionSetPipelineEXT);
    void vkUpdateIndirectExecutionSetShaderEXT(device: VkDevice, indirectExecutionSet: VkIndirectExecutionSetEXT, executionSetWriteCount: uint32, pExecutionSetWrites: *VkWriteIndirectExecutionSetShaderEXT);
    VkResult vkGetPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV(physicalDevice: VkPhysicalDevice, pPropertyCount: *uint32, pProperties: *VkCooperativeMatrixFlexibleDimensionsPropertiesNV);
    VkResult vkCreateAccelerationStructureKHR(device: VkDevice, pCreateInfo: *VkAccelerationStructureCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pAccelerationStructure: *VkAccelerationStructureKHR);
    void vkDestroyAccelerationStructureKHR(device: VkDevice, accelerationStructure: VkAccelerationStructureKHR, pAllocator: *VkAllocationCallbacks);
    void vkCmdBuildAccelerationStructuresKHR(commandBuffer: VkCommandBuffer, infoCount: uint32, pInfos: *VkAccelerationStructureBuildGeometryInfoKHR, ppBuildRangeInfos: **VkAccelerationStructureBuildRangeInfoKHR);
    void vkCmdBuildAccelerationStructuresIndirectKHR(commandBuffer: VkCommandBuffer, infoCount: uint32, pInfos: *VkAccelerationStructureBuildGeometryInfoKHR, pIndirectDeviceAddresses: *VkDeviceAddress, pIndirectStrides: *uint32, ppMaxPrimitiveCounts: **uint32);
    VkResult vkBuildAccelerationStructuresKHR(device: VkDevice, deferredOperation: VkDeferredOperationKHR, infoCount: uint32, pInfos: *VkAccelerationStructureBuildGeometryInfoKHR, ppBuildRangeInfos: **VkAccelerationStructureBuildRangeInfoKHR);
    VkResult vkCopyAccelerationStructureKHR(device: VkDevice, deferredOperation: VkDeferredOperationKHR, pInfo: *VkCopyAccelerationStructureInfoKHR);
    VkResult vkCopyAccelerationStructureToMemoryKHR(device: VkDevice, deferredOperation: VkDeferredOperationKHR, pInfo: *VkCopyAccelerationStructureToMemoryInfoKHR);
    VkResult vkCopyMemoryToAccelerationStructureKHR(device: VkDevice, deferredOperation: VkDeferredOperationKHR, pInfo: *VkCopyMemoryToAccelerationStructureInfoKHR);
    VkResult vkWriteAccelerationStructuresPropertiesKHR(device: VkDevice, accelerationStructureCount: uint32, pAccelerationStructures: *VkAccelerationStructureKHR, queryType: VkQueryType, dataSize: uint, pData: *void, stride: uint);
    void vkCmdCopyAccelerationStructureKHR(commandBuffer: VkCommandBuffer, pInfo: *VkCopyAccelerationStructureInfoKHR);
    void vkCmdCopyAccelerationStructureToMemoryKHR(commandBuffer: VkCommandBuffer, pInfo: *VkCopyAccelerationStructureToMemoryInfoKHR);
    void vkCmdCopyMemoryToAccelerationStructureKHR(commandBuffer: VkCommandBuffer, pInfo: *VkCopyMemoryToAccelerationStructureInfoKHR);
    VkDeviceAddress vkGetAccelerationStructureDeviceAddressKHR(device: VkDevice, pInfo: *VkAccelerationStructureDeviceAddressInfoKHR);
    void vkCmdWriteAccelerationStructuresPropertiesKHR(commandBuffer: VkCommandBuffer, accelerationStructureCount: uint32, pAccelerationStructures: *VkAccelerationStructureKHR, queryType: VkQueryType, queryPool: VkQueryPool, firstQuery: uint32);
    void vkGetDeviceAccelerationStructureCompatibilityKHR(device: VkDevice, pVersionInfo: *VkAccelerationStructureVersionInfoKHR, pCompatibility: *VkAccelerationStructureCompatibilityKHR);
    void vkGetAccelerationStructureBuildSizesKHR(device: VkDevice, buildType: VkAccelerationStructureBuildTypeKHR, pBuildInfo: *VkAccelerationStructureBuildGeometryInfoKHR, pMaxPrimitiveCounts: *uint32, pSizeInfo: *VkAccelerationStructureBuildSizesInfoKHR);
    void vkCmdTraceRaysKHR(commandBuffer: VkCommandBuffer, pRaygenShaderBindingTable: *VkStridedDeviceAddressRegionKHR, pMissShaderBindingTable: *VkStridedDeviceAddressRegionKHR, pHitShaderBindingTable: *VkStridedDeviceAddressRegionKHR, pCallableShaderBindingTable: *VkStridedDeviceAddressRegionKHR, width: uint32, height: uint32, depth: uint32);
    VkResult vkCreateRayTracingPipelinesKHR(device: VkDevice, deferredOperation: VkDeferredOperationKHR, pipelineCache: VkPipelineCache, createInfoCount: uint32, pCreateInfos: *VkRayTracingPipelineCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pPipelines: *VkPipeline);
    VkResult vkGetRayTracingCaptureReplayShaderGroupHandlesKHR(device: VkDevice, pipeline: VkPipeline, firstGroup: uint32, groupCount: uint32, dataSize: uint, pData: *void);
    void vkCmdTraceRaysIndirectKHR(commandBuffer: VkCommandBuffer, pRaygenShaderBindingTable: *VkStridedDeviceAddressRegionKHR, pMissShaderBindingTable: *VkStridedDeviceAddressRegionKHR, pHitShaderBindingTable: *VkStridedDeviceAddressRegionKHR, pCallableShaderBindingTable: *VkStridedDeviceAddressRegionKHR, indirectDeviceAddress: VkDeviceAddress);
    VkDeviceSize vkGetRayTracingShaderGroupStackSizeKHR(device: VkDevice, pipeline: VkPipeline, group: uint32, groupShader: VkShaderGroupShaderKHR);
    void vkCmdSetRayTracingPipelineStackSizeKHR(commandBuffer: VkCommandBuffer, pipelineStackSize: uint32);
    void vkCmdDrawMeshTasksEXT(commandBuffer: VkCommandBuffer, groupCountX: uint32, groupCountY: uint32, groupCountZ: uint32);
    void vkCmdDrawMeshTasksIndirectEXT(commandBuffer: VkCommandBuffer, buffer: VkBuffer, offset: VkDeviceSize, drawCount: uint32, stride: uint32);
    void vkCmdDrawMeshTasksIndirectCountEXT(commandBuffer: VkCommandBuffer, buffer: VkBuffer, offset: VkDeviceSize, countBuffer: VkBuffer, countBufferOffset: VkDeviceSize, maxDrawCount: uint32, stride: uint32);
}

state VkExtent2D
{
        width: uint32,
        height: uint32
}

state VkExtent3D
{
        width: uint32,
        height: uint32,
        depth: uint32
}

state VkOffset2D
{
        x: int32,
        y: int32
}

state VkOffset3D
{
        x: int32,
        y: int32,
        z: int32
}

state VkRect2D
{
        offset: VkOffset2D,
        extent: VkExtent2D
}

state VkBaseInStructure
{
        sType: VkStructureType,
        pNext: *:struct
}

state VkBaseOutStructure
{
        sType: VkStructureType,
        pNext: *:struct
}

state VkBufferMemoryBarrier
{
        sType: VkStructureType,
        pNext: *void,
        srcAccessMask: VkAccessFlags,
        dstAccessMask: VkAccessFlags,
        srcQueueFamilyIndex: uint32,
        dstQueueFamilyIndex: uint32,
        buffer: VkBuffer,
        offset: VkDeviceSize,
        size: VkDeviceSize
}

state VkDispatchIndirectCommand
{
        x: uint32,
        y: uint32,
        z: uint32
}

state VkDrawIndexedIndirectCommand
{
        indexCount: uint32,
        instanceCount: uint32,
        firstIndex: uint32,
        vertexOffset: int32,
        firstInstance: uint32
}

state VkDrawIndirectCommand
{
        vertexCount: uint32,
        instanceCount: uint32,
        firstVertex: uint32,
        firstInstance: uint32
}

state VkImageSubresourceRange
{
        aspectMask: VkImageAspectFlags,
        baseMipLevel: uint32,
        levelCount: uint32,
        baseArrayLayer: uint32,
        layerCount: uint32
}

state VkImageMemoryBarrier
{
        sType: VkStructureType,
        pNext: *void,
        srcAccessMask: VkAccessFlags,
        dstAccessMask: VkAccessFlags,
        oldLayout: VkImageLayout,
        newLayout: VkImageLayout,
        srcQueueFamilyIndex: uint32,
        dstQueueFamilyIndex: uint32,
        image: VkImage,
        subresourceRange: VkImageSubresourceRange
}

state VkMemoryBarrier
{
        sType: VkStructureType,
        pNext: *void,
        srcAccessMask: VkAccessFlags,
        dstAccessMask: VkAccessFlags
}

state VkPipelineCacheHeaderVersionOne
{
        headerSize: uint32,
        headerVersion: VkPipelineCacheHeaderVersion,
        vendorID: uint32,
        deviceID: uint32,
        pipelineCacheUUID: [16]uint8_t
}

state VkAllocationCallbacks
{
        pUserData: *void,
        pfnAllocation: PFN_vkAllocationFunction,
        pfnReallocation: PFN_vkReallocationFunction,
        pfnFree: PFN_vkFreeFunction,
        pfnInternalAllocation: PFN_vkInternalAllocationNotification,
        pfnInternalFree: PFN_vkInternalFreeNotification
}

state VkApplicationInfo
{
        sType: VkStructureType,
        pNext: *void,
        pApplicationName: *byte,
        applicationVersion: uint32,
        pEngineName: *byte,
        engineVersion: uint32,
        apiVersion: uint32
}

state VkFormatProperties
{
        linearTilingFeatures: VkFormatFeatureFlags,
        optimalTilingFeatures: VkFormatFeatureFlags,
        bufferFeatures: VkFormatFeatureFlags
}

state VkImageFormatProperties
{
        maxExtent: VkExtent3D,
        maxMipLevels: uint32,
        maxArrayLayers: uint32,
        sampleCounts: VkSampleCountFlags,
        maxResourceSize: VkDeviceSize
}

state VkInstanceCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkInstanceCreateFlags,
        pApplicationInfo: *VkApplicationInfo,
        enabledLayerCount: uint32,
        ppEnabledLayerNames: **byte,
        enabledExtensionCount: uint32,
        ppEnabledExtensionNames: **byte
}

state VkMemoryHeap
{
        size: VkDeviceSize,
        flags: VkMemoryHeapFlags
}

state VkMemoryType
{
        propertyFlags: VkMemoryPropertyFlags,
        heapIndex: uint32
}

state VkPhysicalDeviceFeatures
{
        robustBufferAccess: VkBool32,
        fullDrawIndexUint32: VkBool32,
        imageCubeArray: VkBool32,
        independentBlend: VkBool32,
        geometryShader: VkBool32,
        tessellationShader: VkBool32,
        sampleRateShading: VkBool32,
        dualSrcBlend: VkBool32,
        logicOp: VkBool32,
        multiDrawIndirect: VkBool32,
        drawIndirectFirstInstance: VkBool32,
        depthClamp: VkBool32,
        depthBiasClamp: VkBool32,
        fillModeNonSolid: VkBool32,
        depthBounds: VkBool32,
        wideLines: VkBool32,
        largePoints: VkBool32,
        alphaToOne: VkBool32,
        multiViewport: VkBool32,
        samplerAnisotropy: VkBool32,
        textureCompressionETC2: VkBool32,
        textureCompressionASTC_LDR: VkBool32,
        textureCompressionBC: VkBool32,
        occlusionQueryPrecise: VkBool32,
        pipelineStatisticsQuery: VkBool32,
        vertexPipelineStoresAndAtomics: VkBool32,
        fragmentStoresAndAtomics: VkBool32,
        shaderTessellationAndGeometryPointSize: VkBool32,
        shaderImageGatherExtended: VkBool32,
        shaderStorageImageExtendedFormats: VkBool32,
        shaderStorageImageMultisample: VkBool32,
        shaderStorageImageReadWithoutFormat: VkBool32,
        shaderStorageImageWriteWithoutFormat: VkBool32,
        shaderUniformBufferArrayDynamicIndexing: VkBool32,
        shaderSampledImageArrayDynamicIndexing: VkBool32,
        shaderStorageBufferArrayDynamicIndexing: VkBool32,
        shaderStorageImageArrayDynamicIndexing: VkBool32,
        shaderClipDistance: VkBool32,
        shaderCullDistance: VkBool32,
        shaderFloat64: VkBool32,
        shaderInt64: VkBool32,
        shaderInt16: VkBool32,
        shaderResourceResidency: VkBool32,
        shaderResourceMinLod: VkBool32,
        sparseBinding: VkBool32,
        sparseResidencyBuffer: VkBool32,
        sparseResidencyImage2D: VkBool32,
        sparseResidencyImage3D: VkBool32,
        sparseResidency2Samples: VkBool32,
        sparseResidency4Samples: VkBool32,
        sparseResidency8Samples: VkBool32,
        sparseResidency16Samples: VkBool32,
        sparseResidencyAliased: VkBool32,
        variableMultisampleRate: VkBool32,
        inheritedQueries: VkBool32
}

state VkPhysicalDeviceLimits
{
        maxImageDimension1D: uint32,
        maxImageDimension2D: uint32,
        maxImageDimension3D: uint32,
        maxImageDimensionCube: uint32,
        maxImageArrayLayers: uint32,
        maxTexelBufferElements: uint32,
        maxUniformBufferRange: uint32,
        maxStorageBufferRange: uint32,
        maxPushConstantsSize: uint32,
        maxMemoryAllocationCount: uint32,
        maxSamplerAllocationCount: uint32,
        bufferImageGranularity: VkDeviceSize,
        sparseAddressSpaceSize: VkDeviceSize,
        maxBoundDescriptorSets: uint32,
        maxPerStageDescriptorSamplers: uint32,
        maxPerStageDescriptorUniformBuffers: uint32,
        maxPerStageDescriptorStorageBuffers: uint32,
        maxPerStageDescriptorSampledImages: uint32,
        maxPerStageDescriptorStorageImages: uint32,
        maxPerStageDescriptorInputAttachments: uint32,
        maxPerStageResources: uint32,
        maxDescriptorSetSamplers: uint32,
        maxDescriptorSetUniformBuffers: uint32,
        maxDescriptorSetUniformBuffersDynamic: uint32,
        maxDescriptorSetStorageBuffers: uint32,
        maxDescriptorSetStorageBuffersDynamic: uint32,
        maxDescriptorSetSampledImages: uint32,
        maxDescriptorSetStorageImages: uint32,
        maxDescriptorSetInputAttachments: uint32,
        maxVertexInputAttributes: uint32,
        maxVertexInputBindings: uint32,
        maxVertexInputAttributeOffset: uint32,
        maxVertexInputBindingStride: uint32,
        maxVertexOutputComponents: uint32,
        maxTessellationGenerationLevel: uint32,
        maxTessellationPatchSize: uint32,
        maxTessellationControlPerVertexInputComponents: uint32,
        maxTessellationControlPerVertexOutputComponents: uint32,
        maxTessellationControlPerPatchOutputComponents: uint32,
        maxTessellationControlTotalOutputComponents: uint32,
        maxTessellationEvaluationInputComponents: uint32,
        maxTessellationEvaluationOutputComponents: uint32,
        maxGeometryShaderInvocations: uint32,
        maxGeometryInputComponents: uint32,
        maxGeometryOutputComponents: uint32,
        maxGeometryOutputVertices: uint32,
        maxGeometryTotalOutputComponents: uint32,
        maxFragmentInputComponents: uint32,
        maxFragmentOutputAttachments: uint32,
        maxFragmentDualSrcAttachments: uint32,
        maxFragmentCombinedOutputResources: uint32,
        maxComputeSharedMemorySize: uint32,
        maxComputeWorkGroupCount: [3]uint32,
        maxComputeWorkGroupInvocations: uint32,
        maxComputeWorkGroupSize: [3]uint32,
        subPixelPrecisionBits: uint32,
        subTexelPrecisionBits: uint32,
        mipmapPrecisionBits: uint32,
        maxDrawIndexedIndexValue: uint32,
        maxDrawIndirectCount: uint32,
        maxSamplerLodBias: :float,
        maxSamplerAnisotropy: :float,
        maxViewports: uint32,
        maxViewportDimensions: [2]uint32,
        viewportBoundsRange: [2]:float,
        viewportSubPixelBits: uint32,
        minMemoryMapAlignment: uint,
        minTexelBufferOffsetAlignment: VkDeviceSize,
        minUniformBufferOffsetAlignment: VkDeviceSize,
        minStorageBufferOffsetAlignment: VkDeviceSize,
        minTexelOffset: int32,
        maxTexelOffset: uint32,
        minTexelGatherOffset: int32,
        maxTexelGatherOffset: uint32,
        minInterpolationOffset: :float,
        maxInterpolationOffset: :float,
        subPixelInterpolationOffsetBits: uint32,
        maxFramebufferWidth: uint32,
        maxFramebufferHeight: uint32,
        maxFramebufferLayers: uint32,
        framebufferColorSampleCounts: VkSampleCountFlags,
        framebufferDepthSampleCounts: VkSampleCountFlags,
        framebufferStencilSampleCounts: VkSampleCountFlags,
        framebufferNoAttachmentsSampleCounts: VkSampleCountFlags,
        maxColorAttachments: uint32,
        sampledImageColorSampleCounts: VkSampleCountFlags,
        sampledImageIntegerSampleCounts: VkSampleCountFlags,
        sampledImageDepthSampleCounts: VkSampleCountFlags,
        sampledImageStencilSampleCounts: VkSampleCountFlags,
        storageImageSampleCounts: VkSampleCountFlags,
        maxSampleMaskWords: uint32,
        timestampComputeAndGraphics: VkBool32,
        timestampPeriod: :float,
        maxClipDistances: uint32,
        maxCullDistances: uint32,
        maxCombinedClipAndCullDistances: uint32,
        discreteQueuePriorities: uint32,
        pointSizeRange: [2]:float,
        lineWidthRange: [2]:float,
        pointSizeGranularity: :float,
        lineWidthGranularity: :float,
        strictLines: VkBool32,
        standardSampleLocations: VkBool32,
        optimalBufferCopyOffsetAlignment: VkDeviceSize,
        optimalBufferCopyRowPitchAlignment: VkDeviceSize,
        nonCoherentAtomSize: VkDeviceSize
}

state VkPhysicalDeviceMemoryProperties
{
        memoryTypeCount: uint32,
        memoryTypes: [32]VkMemoryType,
        memoryHeapCount: uint32,
        memoryHeaps: [16]VkMemoryHeap
}

state VkPhysicalDeviceSparseProperties
{
        residencyStandard2DBlockShape: VkBool32,
        residencyStandard2DMultisampleBlockShape: VkBool32,
        residencyStandard3DBlockShape: VkBool32,
        residencyAlignedMipSize: VkBool32,
        residencyNonResidentStrict: VkBool32
}

state VkPhysicalDeviceProperties
{
        apiVersion: uint32,
        driverVersion: uint32,
        vendorID: uint32,
        deviceID: uint32,
        deviceType: VkPhysicalDeviceType,
        deviceName: [256]byte,
        pipelineCacheUUID: [16]uint8_t,
        limits: VkPhysicalDeviceLimits,
        sparseProperties: VkPhysicalDeviceSparseProperties
}

state VkQueueFamilyProperties
{
        queueFlags: VkQueueFlags,
        queueCount: uint32,
        timestampValidBits: uint32,
        minImageTransferGranularity: VkExtent3D
}

state VkDeviceQueueCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkDeviceQueueCreateFlags,
        queueFamilyIndex: uint32,
        queueCount: uint32,
        pQueuePriorities: *:float
}

state VkDeviceCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkDeviceCreateFlags,
        queueCreateInfoCount: uint32,
        pQueueCreateInfos: *VkDeviceQueueCreateInfo,
        enabledLayerCount: uint32,
        ppEnabledLayerNames: **byte,
        enabledExtensionCount: uint32,
        ppEnabledExtensionNames: **byte,
        pEnabledFeatures: *VkPhysicalDeviceFeatures
}

state VkExtensionProperties
{
        extensionName: [256]byte,
        specVersion: uint32
}

state VkLayerProperties
{
        layerName: [256]byte,
        specVersion: uint32,
        implementationVersion: uint32,
        description: [256]byte
}

state VkSubmitInfo
{
        sType: VkStructureType,
        pNext: *void,
        waitSemaphoreCount: uint32,
        pWaitSemaphores: *VkSemaphore,
        pWaitDstStageMask: *VkPipelineStageFlags,
        commandBufferCount: uint32,
        pCommandBuffers: *VkCommandBuffer,
        signalSemaphoreCount: uint32,
        pSignalSemaphores: *VkSemaphore
}

state VkMappedMemoryRange
{
        sType: VkStructureType,
        pNext: *void,
        memory: VkDeviceMemory,
        offset: VkDeviceSize,
        size: VkDeviceSize
}

state VkMemoryAllocateInfo
{
        sType: VkStructureType,
        pNext: *void,
        allocationSize: VkDeviceSize,
        memoryTypeIndex: uint32
}

state VkMemoryRequirements
{
        size: VkDeviceSize,
        alignment: VkDeviceSize,
        memoryTypeBits: uint32
}

state VkSparseMemoryBind
{
        resourceOffset: VkDeviceSize,
        size: VkDeviceSize,
        memory: VkDeviceMemory,
        memoryOffset: VkDeviceSize,
        flags: VkSparseMemoryBindFlags
}

state VkSparseBufferMemoryBindInfo
{
        buffer: VkBuffer,
        bindCount: uint32,
        pBinds: *VkSparseMemoryBind
}

state VkSparseImageOpaqueMemoryBindInfo
{
        image: VkImage,
        bindCount: uint32,
        pBinds: *VkSparseMemoryBind
}

state VkImageSubresource
{
        aspectMask: VkImageAspectFlags,
        mipLevel: uint32,
        arrayLayer: uint32
}

state VkSparseImageMemoryBind
{
        subresource: VkImageSubresource,
        offset: VkOffset3D,
        extent: VkExtent3D,
        memory: VkDeviceMemory,
        memoryOffset: VkDeviceSize,
        flags: VkSparseMemoryBindFlags
}

state VkSparseImageMemoryBindInfo
{
        image: VkImage,
        bindCount: uint32,
        pBinds: *VkSparseImageMemoryBind
}

state VkBindSparseInfo
{
        sType: VkStructureType,
        pNext: *void,
        waitSemaphoreCount: uint32,
        pWaitSemaphores: *VkSemaphore,
        bufferBindCount: uint32,
        pBufferBinds: *VkSparseBufferMemoryBindInfo,
        imageOpaqueBindCount: uint32,
        pImageOpaqueBinds: *VkSparseImageOpaqueMemoryBindInfo,
        imageBindCount: uint32,
        pImageBinds: *VkSparseImageMemoryBindInfo,
        signalSemaphoreCount: uint32,
        pSignalSemaphores: *VkSemaphore
}

state VkSparseImageFormatProperties
{
        aspectMask: VkImageAspectFlags,
        imageGranularity: VkExtent3D,
        flags: VkSparseImageFormatFlags
}

state VkSparseImageMemoryRequirements
{
        formatProperties: VkSparseImageFormatProperties,
        imageMipTailFirstLod: uint32,
        imageMipTailSize: VkDeviceSize,
        imageMipTailOffset: VkDeviceSize,
        imageMipTailStride: VkDeviceSize
}

state VkFenceCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkFenceCreateFlags
}

state VkSemaphoreCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkSemaphoreCreateFlags
}

state VkEventCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkEventCreateFlags
}

state VkQueryPoolCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkQueryPoolCreateFlags,
        queryType: VkQueryType,
        queryCount: uint32,
        pipelineStatistics: VkQueryPipelineStatisticFlags
}

state VkBufferCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkBufferCreateFlags,
        size: VkDeviceSize,
        usage: VkBufferUsageFlags,
        sharingMode: VkSharingMode,
        queueFamilyIndexCount: uint32,
        pQueueFamilyIndices: *uint32
}

state VkBufferViewCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkBufferViewCreateFlags,
        buffer: VkBuffer,
        format: VkFormat,
        offset: VkDeviceSize,
        range: VkDeviceSize
}

state VkImageCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkImageCreateFlags,
        imageType: VkImageType,
        format: VkFormat,
        extent: VkExtent3D,
        mipLevels: uint32,
        arrayLayers: uint32,
        samples: VkSampleCountFlagBits,
        tiling: VkImageTiling,
        usage: VkImageUsageFlags,
        sharingMode: VkSharingMode,
        queueFamilyIndexCount: uint32,
        pQueueFamilyIndices: *uint32,
        initialLayout: VkImageLayout
}

state VkSubresourceLayout
{
        offset: VkDeviceSize,
        size: VkDeviceSize,
        rowPitch: VkDeviceSize,
        arrayPitch: VkDeviceSize,
        depthPitch: VkDeviceSize
}

state VkComponentMapping
{
        r: VkComponentSwizzle,
        g: VkComponentSwizzle,
        b: VkComponentSwizzle,
        a: VkComponentSwizzle
}

state VkImageViewCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkImageViewCreateFlags,
        image: VkImage,
        viewType: VkImageViewType,
        format: VkFormat,
        components: VkComponentMapping,
        subresourceRange: VkImageSubresourceRange
}

state VkShaderModuleCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkShaderModuleCreateFlags,
        codeSize: uint,
        pCode: *uint32
}

state VkPipelineCacheCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineCacheCreateFlags,
        initialDataSize: uint,
        pInitialData: *void
}

state VkSpecializationMapEntry
{
        constantID: uint32,
        offset: uint32,
        size: uint
}

state VkSpecializationInfo
{
        mapEntryCount: uint32,
        pMapEntries: *VkSpecializationMapEntry,
        dataSize: uint,
        pData: *void
}

state VkPipelineShaderStageCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineShaderStageCreateFlags,
        stage: VkShaderStageFlagBits,
        module: VkShaderModule,
        pName: *byte,
        pSpecializationInfo: *VkSpecializationInfo
}

state VkComputePipelineCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineCreateFlags,
        stage: VkPipelineShaderStageCreateInfo,
        layout: VkPipelineLayout,
        basePipelineHandle: VkPipeline,
        basePipelineIndex: int32
}

state VkVertexInputBindingDescription
{
        binding: uint32,
        stride: uint32,
        inputRate: VkVertexInputRate
}

state VkVertexInputAttributeDescription
{
        location: uint32,
        binding: uint32,
        format: VkFormat,
        offset: uint32
}

state VkPipelineVertexInputStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineVertexInputStateCreateFlags,
        vertexBindingDescriptionCount: uint32,
        pVertexBindingDescriptions: *VkVertexInputBindingDescription,
        vertexAttributeDescriptionCount: uint32,
        pVertexAttributeDescriptions: *VkVertexInputAttributeDescription
}

state VkPipelineInputAssemblyStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineInputAssemblyStateCreateFlags,
        topology: VkPrimitiveTopology,
        primitiveRestartEnable: VkBool32
}

state VkPipelineTessellationStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineTessellationStateCreateFlags,
        patchControlPoints: uint32
}

state VkViewport
{
        x: :float,
        y: :float,
        width: :float,
        height: :float,
        minDepth: :float,
        maxDepth: :float
}

state VkPipelineViewportStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineViewportStateCreateFlags,
        viewportCount: uint32,
        pViewports: *VkViewport,
        scissorCount: uint32,
        pScissors: *VkRect2D
}

state VkPipelineRasterizationStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineRasterizationStateCreateFlags,
        depthClampEnable: VkBool32,
        rasterizerDiscardEnable: VkBool32,
        polygonMode: VkPolygonMode,
        cullMode: VkCullModeFlags,
        frontFace: VkFrontFace,
        depthBiasEnable: VkBool32,
        depthBiasConstantFactor: :float,
        depthBiasClamp: :float,
        depthBiasSlopeFactor: :float,
        lineWidth: :float
}

state VkPipelineMultisampleStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineMultisampleStateCreateFlags,
        rasterizationSamples: VkSampleCountFlagBits,
        sampleShadingEnable: VkBool32,
        minSampleShading: :float,
        pSampleMask: *VkSampleMask,
        alphaToCoverageEnable: VkBool32,
        alphaToOneEnable: VkBool32
}

state VkStencilOpState
{
        failOp: VkStencilOp,
        passOp: VkStencilOp,
        depthFailOp: VkStencilOp,
        compareOp: VkCompareOp,
        compareMask: uint32,
        writeMask: uint32,
        reference: uint32
}

state VkPipelineDepthStencilStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineDepthStencilStateCreateFlags,
        depthTestEnable: VkBool32,
        depthWriteEnable: VkBool32,
        depthCompareOp: VkCompareOp,
        depthBoundsTestEnable: VkBool32,
        stencilTestEnable: VkBool32,
        front: VkStencilOpState,
        back: VkStencilOpState,
        minDepthBounds: :float,
        maxDepthBounds: :float
}

state VkPipelineColorBlendAttachmentState
{
        blendEnable: VkBool32,
        srcColorBlendFactor: VkBlendFactor,
        dstColorBlendFactor: VkBlendFactor,
        colorBlendOp: VkBlendOp,
        srcAlphaBlendFactor: VkBlendFactor,
        dstAlphaBlendFactor: VkBlendFactor,
        alphaBlendOp: VkBlendOp,
        colorWriteMask: VkColorComponentFlags
}

state VkPipelineColorBlendStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineColorBlendStateCreateFlags,
        logicOpEnable: VkBool32,
        logicOp: VkLogicOp,
        attachmentCount: uint32,
        pAttachments: *VkPipelineColorBlendAttachmentState,
        blendConstants: [4]:float
}

state VkPipelineDynamicStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineDynamicStateCreateFlags,
        dynamicStateCount: uint32,
        pDynamicStates: *VkDynamicState
}

state VkGraphicsPipelineCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineCreateFlags,
        stageCount: uint32,
        pStages: *VkPipelineShaderStageCreateInfo,
        pVertexInputState: *VkPipelineVertexInputStateCreateInfo,
        pInputAssemblyState: *VkPipelineInputAssemblyStateCreateInfo,
        pTessellationState: *VkPipelineTessellationStateCreateInfo,
        pViewportState: *VkPipelineViewportStateCreateInfo,
        pRasterizationState: *VkPipelineRasterizationStateCreateInfo,
        pMultisampleState: *VkPipelineMultisampleStateCreateInfo,
        pDepthStencilState: *VkPipelineDepthStencilStateCreateInfo,
        pColorBlendState: *VkPipelineColorBlendStateCreateInfo,
        pDynamicState: *VkPipelineDynamicStateCreateInfo,
        layout: VkPipelineLayout,
        renderPass: VkRenderPass,
        subpass: uint32,
        basePipelineHandle: VkPipeline,
        basePipelineIndex: int32
}

state VkPushConstantRange
{
        stageFlags: VkShaderStageFlags,
        offset: uint32,
        size: uint32
}

state VkPipelineLayoutCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineLayoutCreateFlags,
        setLayoutCount: uint32,
        pSetLayouts: *VkDescriptorSetLayout,
        pushConstantRangeCount: uint32,
        pPushConstantRanges: *VkPushConstantRange
}

state VkSamplerCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkSamplerCreateFlags,
        magFilter: VkFilter,
        minFilter: VkFilter,
        mipmapMode: VkSamplerMipmapMode,
        addressModeU: VkSamplerAddressMode,
        addressModeV: VkSamplerAddressMode,
        addressModeW: VkSamplerAddressMode,
        mipLodBias: :float,
        anisotropyEnable: VkBool32,
        maxAnisotropy: :float,
        compareEnable: VkBool32,
        compareOp: VkCompareOp,
        minLod: :float,
        maxLod: :float,
        borderColor: VkBorderColor,
        unnormalizedCoordinates: VkBool32
}

state VkCopyDescriptorSet
{
        sType: VkStructureType,
        pNext: *void,
        srcSet: VkDescriptorSet,
        srcBinding: uint32,
        srcArrayElement: uint32,
        dstSet: VkDescriptorSet,
        dstBinding: uint32,
        dstArrayElement: uint32,
        descriptorCount: uint32
}

state VkDescriptorBufferInfo
{
        buffer: VkBuffer,
        offset: VkDeviceSize,
        range: VkDeviceSize
}

state VkDescriptorImageInfo
{
        sampler: VkSampler,
        imageView: VkImageView,
        imageLayout: VkImageLayout
}

state VkDescriptorPoolSize
{
        type: VkDescriptorType,
        descriptorCount: uint32
}

state VkDescriptorPoolCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkDescriptorPoolCreateFlags,
        maxSets: uint32,
        poolSizeCount: uint32,
        pPoolSizes: *VkDescriptorPoolSize
}

state VkDescriptorSetAllocateInfo
{
        sType: VkStructureType,
        pNext: *void,
        descriptorPool: VkDescriptorPool,
        descriptorSetCount: uint32,
        pSetLayouts: *VkDescriptorSetLayout
}

state VkDescriptorSetLayoutBinding
{
        binding: uint32,
        descriptorType: VkDescriptorType,
        descriptorCount: uint32,
        stageFlags: VkShaderStageFlags,
        pImmutableSamplers: *VkSampler
}

state VkDescriptorSetLayoutCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkDescriptorSetLayoutCreateFlags,
        bindingCount: uint32,
        pBindings: *VkDescriptorSetLayoutBinding
}

state VkWriteDescriptorSet
{
        sType: VkStructureType,
        pNext: *void,
        dstSet: VkDescriptorSet,
        dstBinding: uint32,
        dstArrayElement: uint32,
        descriptorCount: uint32,
        descriptorType: VkDescriptorType,
        pImageInfo: *VkDescriptorImageInfo,
        pBufferInfo: *VkDescriptorBufferInfo,
        pTexelBufferView: *VkBufferView
}

state VkAttachmentDescription
{
        flags: VkAttachmentDescriptionFlags,
        format: VkFormat,
        samples: VkSampleCountFlagBits,
        loadOp: VkAttachmentLoadOp,
        storeOp: VkAttachmentStoreOp,
        stencilLoadOp: VkAttachmentLoadOp,
        stencilStoreOp: VkAttachmentStoreOp,
        initialLayout: VkImageLayout,
        finalLayout: VkImageLayout
}

state VkAttachmentReference
{
        attachment: uint32,
        layout: VkImageLayout
}

state VkFramebufferCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkFramebufferCreateFlags,
        renderPass: VkRenderPass,
        attachmentCount: uint32,
        pAttachments: *VkImageView,
        width: uint32,
        height: uint32,
        layers: uint32
}

state VkSubpassDescription
{
        flags: VkSubpassDescriptionFlags,
        pipelineBindPoint: VkPipelineBindPoint,
        inputAttachmentCount: uint32,
        pInputAttachments: *VkAttachmentReference,
        colorAttachmentCount: uint32,
        pColorAttachments: *VkAttachmentReference,
        pResolveAttachments: *VkAttachmentReference,
        pDepthStencilAttachment: *VkAttachmentReference,
        preserveAttachmentCount: uint32,
        pPreserveAttachments: *uint32
}

state VkSubpassDependency
{
        srcSubpass: uint32,
        dstSubpass: uint32,
        srcStageMask: VkPipelineStageFlags,
        dstStageMask: VkPipelineStageFlags,
        srcAccessMask: VkAccessFlags,
        dstAccessMask: VkAccessFlags,
        dependencyFlags: VkDependencyFlags
}

state VkRenderPassCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkRenderPassCreateFlags,
        attachmentCount: uint32,
        pAttachments: *VkAttachmentDescription,
        subpassCount: uint32,
        pSubpasses: *VkSubpassDescription,
        dependencyCount: uint32,
        pDependencies: *VkSubpassDependency
}

state VkCommandPoolCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkCommandPoolCreateFlags,
        queueFamilyIndex: uint32
}

state VkCommandBufferAllocateInfo
{
        sType: VkStructureType,
        pNext: *void,
        commandPool: VkCommandPool,
        level: VkCommandBufferLevel,
        commandBufferCount: uint32
}

state VkCommandBufferInheritanceInfo
{
        sType: VkStructureType,
        pNext: *void,
        renderPass: VkRenderPass,
        subpass: uint32,
        framebuffer: VkFramebuffer,
        occlusionQueryEnable: VkBool32,
        queryFlags: VkQueryControlFlags,
        pipelineStatistics: VkQueryPipelineStatisticFlags
}

state VkCommandBufferBeginInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkCommandBufferUsageFlags,
        pInheritanceInfo: *VkCommandBufferInheritanceInfo
}

state VkBufferCopy
{
        srcOffset: VkDeviceSize,
        dstOffset: VkDeviceSize,
        size: VkDeviceSize
}

state VkImageSubresourceLayers
{
        aspectMask: VkImageAspectFlags,
        mipLevel: uint32,
        baseArrayLayer: uint32,
        layerCount: uint32
}

state VkBufferImageCopy
{
        bufferOffset: VkDeviceSize,
        bufferRowLength: uint32,
        bufferImageHeight: uint32,
        imageSubresource: VkImageSubresourceLayers,
        imageOffset: VkOffset3D,
        imageExtent: VkExtent3D
}

state VkClearDepthStencilValue
{
        depth: :float,
        stencil: uint32
}

state VkClearAttachment
{
        aspectMask: VkImageAspectFlags,
        colorAttachment: uint32,
        clearValue: VkClearValue
}

state VkClearRect
{
        rect: VkRect2D,
        baseArrayLayer: uint32,
        layerCount: uint32
}

state VkImageBlit
{
        srcSubresource: VkImageSubresourceLayers,
        srcOffsets: [2]VkOffset3D,
        dstSubresource: VkImageSubresourceLayers,
        dstOffsets: [2]VkOffset3D
}

state VkImageCopy
{
        srcSubresource: VkImageSubresourceLayers,
        srcOffset: VkOffset3D,
        dstSubresource: VkImageSubresourceLayers,
        dstOffset: VkOffset3D,
        extent: VkExtent3D
}

state VkImageResolve
{
        srcSubresource: VkImageSubresourceLayers,
        srcOffset: VkOffset3D,
        dstSubresource: VkImageSubresourceLayers,
        dstOffset: VkOffset3D,
        extent: VkExtent3D
}

state VkRenderPassBeginInfo
{
        sType: VkStructureType,
        pNext: *void,
        renderPass: VkRenderPass,
        framebuffer: VkFramebuffer,
        renderArea: VkRect2D,
        clearValueCount: uint32,
        pClearValues: *VkClearValue
}

state VkPhysicalDeviceSubgroupProperties
{
        sType: VkStructureType,
        pNext: *void,
        subgroupSize: uint32,
        supportedStages: VkShaderStageFlags,
        supportedOperations: VkSubgroupFeatureFlags,
        quadOperationsInAllStages: VkBool32
}

state VkBindBufferMemoryInfo
{
        sType: VkStructureType,
        pNext: *void,
        buffer: VkBuffer,
        memory: VkDeviceMemory,
        memoryOffset: VkDeviceSize
}

state VkBindImageMemoryInfo
{
        sType: VkStructureType,
        pNext: *void,
        image: VkImage,
        memory: VkDeviceMemory,
        memoryOffset: VkDeviceSize
}

state VkPhysicalDevice16BitStorageFeatures
{
        sType: VkStructureType,
        pNext: *void,
        storageBuffer16BitAccess: VkBool32,
        uniformAndStorageBuffer16BitAccess: VkBool32,
        storagePushConstant16: VkBool32,
        storageInputOutput16: VkBool32
}

state VkMemoryDedicatedRequirements
{
        sType: VkStructureType,
        pNext: *void,
        prefersDedicatedAllocation: VkBool32,
        requiresDedicatedAllocation: VkBool32
}

state VkMemoryDedicatedAllocateInfo
{
        sType: VkStructureType,
        pNext: *void,
        image: VkImage,
        buffer: VkBuffer
}

state VkMemoryAllocateFlagsInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkMemoryAllocateFlags,
        deviceMask: uint32
}

state VkDeviceGroupRenderPassBeginInfo
{
        sType: VkStructureType,
        pNext: *void,
        deviceMask: uint32,
        deviceRenderAreaCount: uint32,
        pDeviceRenderAreas: *VkRect2D
}

state VkDeviceGroupCommandBufferBeginInfo
{
        sType: VkStructureType,
        pNext: *void,
        deviceMask: uint32
}

state VkDeviceGroupSubmitInfo
{
        sType: VkStructureType,
        pNext: *void,
        waitSemaphoreCount: uint32,
        pWaitSemaphoreDeviceIndices: *uint32,
        commandBufferCount: uint32,
        pCommandBufferDeviceMasks: *uint32,
        signalSemaphoreCount: uint32,
        pSignalSemaphoreDeviceIndices: *uint32
}

state VkDeviceGroupBindSparseInfo
{
        sType: VkStructureType,
        pNext: *void,
        resourceDeviceIndex: uint32,
        memoryDeviceIndex: uint32
}

state VkBindBufferMemoryDeviceGroupInfo
{
        sType: VkStructureType,
        pNext: *void,
        deviceIndexCount: uint32,
        pDeviceIndices: *uint32
}

state VkBindImageMemoryDeviceGroupInfo
{
        sType: VkStructureType,
        pNext: *void,
        deviceIndexCount: uint32,
        pDeviceIndices: *uint32,
        splitInstanceBindRegionCount: uint32,
        pSplitInstanceBindRegions: *VkRect2D
}

state VkPhysicalDeviceGroupProperties
{
        sType: VkStructureType,
        pNext: *void,
        physicalDeviceCount: uint32,
        physicalDevices: [32]VkPhysicalDevice,
        subsetAllocation: VkBool32
}

state VkDeviceGroupDeviceCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        physicalDeviceCount: uint32,
        pPhysicalDevices: *VkPhysicalDevice
}

state VkBufferMemoryRequirementsInfo2
{
        sType: VkStructureType,
        pNext: *void,
        buffer: VkBuffer
}

state VkImageMemoryRequirementsInfo2
{
        sType: VkStructureType,
        pNext: *void,
        image: VkImage
}

state VkImageSparseMemoryRequirementsInfo2
{
        sType: VkStructureType,
        pNext: *void,
        image: VkImage
}

state VkMemoryRequirements2
{
        sType: VkStructureType,
        pNext: *void,
        memoryRequirements: VkMemoryRequirements
}

state VkSparseImageMemoryRequirements2
{
        sType: VkStructureType,
        pNext: *void,
        memoryRequirements: VkSparseImageMemoryRequirements
}

state VkPhysicalDeviceFeatures2
{
        sType: VkStructureType,
        pNext: *void,
        features: VkPhysicalDeviceFeatures
}

state VkPhysicalDeviceProperties2
{
        sType: VkStructureType,
        pNext: *void,
        properties: VkPhysicalDeviceProperties
}

state VkFormatProperties2
{
        sType: VkStructureType,
        pNext: *void,
        formatProperties: VkFormatProperties
}

state VkImageFormatProperties2
{
        sType: VkStructureType,
        pNext: *void,
        imageFormatProperties: VkImageFormatProperties
}

state VkPhysicalDeviceImageFormatInfo2
{
        sType: VkStructureType,
        pNext: *void,
        format: VkFormat,
        type: VkImageType,
        tiling: VkImageTiling,
        usage: VkImageUsageFlags,
        flags: VkImageCreateFlags
}

state VkQueueFamilyProperties2
{
        sType: VkStructureType,
        pNext: *void,
        queueFamilyProperties: VkQueueFamilyProperties
}

state VkPhysicalDeviceMemoryProperties2
{
        sType: VkStructureType,
        pNext: *void,
        memoryProperties: VkPhysicalDeviceMemoryProperties
}

state VkSparseImageFormatProperties2
{
        sType: VkStructureType,
        pNext: *void,
        properties: VkSparseImageFormatProperties
}

state VkPhysicalDeviceSparseImageFormatInfo2
{
        sType: VkStructureType,
        pNext: *void,
        format: VkFormat,
        type: VkImageType,
        samples: VkSampleCountFlagBits,
        usage: VkImageUsageFlags,
        tiling: VkImageTiling
}

state VkPhysicalDevicePointClippingProperties
{
        sType: VkStructureType,
        pNext: *void,
        pointClippingBehavior: VkPointClippingBehavior
}

state VkInputAttachmentAspectReference
{
        subpass: uint32,
        inputAttachmentIndex: uint32,
        aspectMask: VkImageAspectFlags
}

state VkRenderPassInputAttachmentAspectCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        aspectReferenceCount: uint32,
        pAspectReferences: *VkInputAttachmentAspectReference
}

state VkImageViewUsageCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        usage: VkImageUsageFlags
}

state VkPipelineTessellationDomainOriginStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        domainOrigin: VkTessellationDomainOrigin
}

state VkRenderPassMultiviewCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        subpassCount: uint32,
        pViewMasks: *uint32,
        dependencyCount: uint32,
        pViewOffsets: *int32,
        correlationMaskCount: uint32,
        pCorrelationMasks: *uint32
}

state VkPhysicalDeviceMultiviewFeatures
{
        sType: VkStructureType,
        pNext: *void,
        multiview: VkBool32,
        multiviewGeometryShader: VkBool32,
        multiviewTessellationShader: VkBool32
}

state VkPhysicalDeviceMultiviewProperties
{
        sType: VkStructureType,
        pNext: *void,
        maxMultiviewViewCount: uint32,
        maxMultiviewInstanceIndex: uint32
}

state VkPhysicalDeviceVariablePointersFeatures
{
        sType: VkStructureType,
        pNext: *void,
        variablePointersStorageBuffer: VkBool32,
        variablePointers: VkBool32
}

state VkPhysicalDeviceProtectedMemoryFeatures
{
        sType: VkStructureType,
        pNext: *void,
        protectedMemory: VkBool32
}

state VkPhysicalDeviceProtectedMemoryProperties
{
        sType: VkStructureType,
        pNext: *void,
        protectedNoFault: VkBool32
}

state VkDeviceQueueInfo2
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkDeviceQueueCreateFlags,
        queueFamilyIndex: uint32,
        queueIndex: uint32
}

state VkProtectedSubmitInfo
{
        sType: VkStructureType,
        pNext: *void,
        protectedSubmit: VkBool32
}

state VkSamplerYcbcrConversionCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        format: VkFormat,
        ycbcrModel: VkSamplerYcbcrModelConversion,
        ycbcrRange: VkSamplerYcbcrRange,
        components: VkComponentMapping,
        xChromaOffset: VkChromaLocation,
        yChromaOffset: VkChromaLocation,
        chromaFilter: VkFilter,
        forceExplicitReconstruction: VkBool32
}

state VkSamplerYcbcrConversionInfo
{
        sType: VkStructureType,
        pNext: *void,
        conversion: VkSamplerYcbcrConversion
}

state VkBindImagePlaneMemoryInfo
{
        sType: VkStructureType,
        pNext: *void,
        planeAspect: VkImageAspectFlagBits
}

state VkImagePlaneMemoryRequirementsInfo
{
        sType: VkStructureType,
        pNext: *void,
        planeAspect: VkImageAspectFlagBits
}

state VkPhysicalDeviceSamplerYcbcrConversionFeatures
{
        sType: VkStructureType,
        pNext: *void,
        samplerYcbcrConversion: VkBool32
}

state VkSamplerYcbcrConversionImageFormatProperties
{
        sType: VkStructureType,
        pNext: *void,
        combinedImageSamplerDescriptorCount: uint32
}

state VkDescriptorUpdateTemplateEntry
{
        dstBinding: uint32,
        dstArrayElement: uint32,
        descriptorCount: uint32,
        descriptorType: VkDescriptorType,
        offset: uint,
        stride: uint
}

state VkDescriptorUpdateTemplateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkDescriptorUpdateTemplateCreateFlags,
        descriptorUpdateEntryCount: uint32,
        pDescriptorUpdateEntries: *VkDescriptorUpdateTemplateEntry,
        templateType: VkDescriptorUpdateTemplateType,
        descriptorSetLayout: VkDescriptorSetLayout,
        pipelineBindPoint: VkPipelineBindPoint,
        pipelineLayout: VkPipelineLayout,
        set: uint32
}

state VkExternalMemoryProperties
{
        externalMemoryFeatures: VkExternalMemoryFeatureFlags,
        exportFromImportedHandleTypes: VkExternalMemoryHandleTypeFlags,
        compatibleHandleTypes: VkExternalMemoryHandleTypeFlags
}

state VkPhysicalDeviceExternalImageFormatInfo
{
        sType: VkStructureType,
        pNext: *void,
        handleType: VkExternalMemoryHandleTypeFlagBits
}

state VkExternalImageFormatProperties
{
        sType: VkStructureType,
        pNext: *void,
        externalMemoryProperties: VkExternalMemoryProperties
}

state VkPhysicalDeviceExternalBufferInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkBufferCreateFlags,
        usage: VkBufferUsageFlags,
        handleType: VkExternalMemoryHandleTypeFlagBits
}

state VkExternalBufferProperties
{
        sType: VkStructureType,
        pNext: *void,
        externalMemoryProperties: VkExternalMemoryProperties
}

state VkPhysicalDeviceIDProperties
{
        sType: VkStructureType,
        pNext: *void,
        deviceUUID: [16]uint8_t,
        driverUUID: [16]uint8_t,
        deviceLUID: [8]uint8_t,
        deviceNodeMask: uint32,
        deviceLUIDValid: VkBool32
}

state VkExternalMemoryImageCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        handleTypes: VkExternalMemoryHandleTypeFlags
}

state VkExternalMemoryBufferCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        handleTypes: VkExternalMemoryHandleTypeFlags
}

state VkExportMemoryAllocateInfo
{
        sType: VkStructureType,
        pNext: *void,
        handleTypes: VkExternalMemoryHandleTypeFlags
}

state VkPhysicalDeviceExternalFenceInfo
{
        sType: VkStructureType,
        pNext: *void,
        handleType: VkExternalFenceHandleTypeFlagBits
}

state VkExternalFenceProperties
{
        sType: VkStructureType,
        pNext: *void,
        exportFromImportedHandleTypes: VkExternalFenceHandleTypeFlags,
        compatibleHandleTypes: VkExternalFenceHandleTypeFlags,
        externalFenceFeatures: VkExternalFenceFeatureFlags
}

state VkExportFenceCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        handleTypes: VkExternalFenceHandleTypeFlags
}

state VkExportSemaphoreCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        handleTypes: VkExternalSemaphoreHandleTypeFlags
}

state VkPhysicalDeviceExternalSemaphoreInfo
{
        sType: VkStructureType,
        pNext: *void,
        handleType: VkExternalSemaphoreHandleTypeFlagBits
}

state VkExternalSemaphoreProperties
{
        sType: VkStructureType,
        pNext: *void,
        exportFromImportedHandleTypes: VkExternalSemaphoreHandleTypeFlags,
        compatibleHandleTypes: VkExternalSemaphoreHandleTypeFlags,
        externalSemaphoreFeatures: VkExternalSemaphoreFeatureFlags
}

state VkPhysicalDeviceMaintenance3Properties
{
        sType: VkStructureType,
        pNext: *void,
        maxPerSetDescriptors: uint32,
        maxMemoryAllocationSize: VkDeviceSize
}

state VkDescriptorSetLayoutSupport
{
        sType: VkStructureType,
        pNext: *void,
        supported: VkBool32
}

state VkPhysicalDeviceShaderDrawParametersFeatures
{
        sType: VkStructureType,
        pNext: *void,
        shaderDrawParameters: VkBool32
}

state VkPhysicalDeviceVulkan11Features
{
        sType: VkStructureType,
        pNext: *void,
        storageBuffer16BitAccess: VkBool32,
        uniformAndStorageBuffer16BitAccess: VkBool32,
        storagePushConstant16: VkBool32,
        storageInputOutput16: VkBool32,
        multiview: VkBool32,
        multiviewGeometryShader: VkBool32,
        multiviewTessellationShader: VkBool32,
        variablePointersStorageBuffer: VkBool32,
        variablePointers: VkBool32,
        protectedMemory: VkBool32,
        samplerYcbcrConversion: VkBool32,
        shaderDrawParameters: VkBool32
}

state VkPhysicalDeviceVulkan11Properties
{
        sType: VkStructureType,
        pNext: *void,
        deviceUUID: [16]uint8_t,
        driverUUID: [16]uint8_t,
        deviceLUID: [8]uint8_t,
        deviceNodeMask: uint32,
        deviceLUIDValid: VkBool32,
        subgroupSize: uint32,
        subgroupSupportedStages: VkShaderStageFlags,
        subgroupSupportedOperations: VkSubgroupFeatureFlags,
        subgroupQuadOperationsInAllStages: VkBool32,
        pointClippingBehavior: VkPointClippingBehavior,
        maxMultiviewViewCount: uint32,
        maxMultiviewInstanceIndex: uint32,
        protectedNoFault: VkBool32,
        maxPerSetDescriptors: uint32,
        maxMemoryAllocationSize: VkDeviceSize
}

state VkPhysicalDeviceVulkan12Features
{
        sType: VkStructureType,
        pNext: *void,
        samplerMirrorClampToEdge: VkBool32,
        drawIndirectCount: VkBool32,
        storageBuffer8BitAccess: VkBool32,
        uniformAndStorageBuffer8BitAccess: VkBool32,
        storagePushConstant8: VkBool32,
        shaderBufferInt64Atomics: VkBool32,
        shaderSharedInt64Atomics: VkBool32,
        shaderFloat16: VkBool32,
        shaderInt8: VkBool32,
        descriptorIndexing: VkBool32,
        shaderInputAttachmentArrayDynamicIndexing: VkBool32,
        shaderUniformTexelBufferArrayDynamicIndexing: VkBool32,
        shaderStorageTexelBufferArrayDynamicIndexing: VkBool32,
        shaderUniformBufferArrayNonUniformIndexing: VkBool32,
        shaderSampledImageArrayNonUniformIndexing: VkBool32,
        shaderStorageBufferArrayNonUniformIndexing: VkBool32,
        shaderStorageImageArrayNonUniformIndexing: VkBool32,
        shaderInputAttachmentArrayNonUniformIndexing: VkBool32,
        shaderUniformTexelBufferArrayNonUniformIndexing: VkBool32,
        shaderStorageTexelBufferArrayNonUniformIndexing: VkBool32,
        descriptorBindingUniformBufferUpdateAfterBind: VkBool32,
        descriptorBindingSampledImageUpdateAfterBind: VkBool32,
        descriptorBindingStorageImageUpdateAfterBind: VkBool32,
        descriptorBindingStorageBufferUpdateAfterBind: VkBool32,
        descriptorBindingUniformTexelBufferUpdateAfterBind: VkBool32,
        descriptorBindingStorageTexelBufferUpdateAfterBind: VkBool32,
        descriptorBindingUpdateUnusedWhilePending: VkBool32,
        descriptorBindingPartiallyBound: VkBool32,
        descriptorBindingVariableDescriptorCount: VkBool32,
        runtimeDescriptorArray: VkBool32,
        samplerFilterMinmax: VkBool32,
        scalarBlockLayout: VkBool32,
        imagelessFramebuffer: VkBool32,
        uniformBufferStandardLayout: VkBool32,
        shaderSubgroupExtendedTypes: VkBool32,
        separateDepthStencilLayouts: VkBool32,
        hostQueryReset: VkBool32,
        timelineSemaphore: VkBool32,
        bufferDeviceAddress: VkBool32,
        bufferDeviceAddressCaptureReplay: VkBool32,
        bufferDeviceAddressMultiDevice: VkBool32,
        vulkanMemoryModel: VkBool32,
        vulkanMemoryModelDeviceScope: VkBool32,
        vulkanMemoryModelAvailabilityVisibilityChains: VkBool32,
        shaderOutputViewportIndex: VkBool32,
        shaderOutputLayer: VkBool32,
        subgroupBroadcastDynamicId: VkBool32
}

state VkConformanceVersion
{
        major: uint8_t,
        minor: uint8_t,
        subminor: uint8_t,
        patch: uint8_t
}

state VkPhysicalDeviceVulkan12Properties
{
        sType: VkStructureType,
        pNext: *void,
        driverID: VkDriverId,
        driverName: [256]byte,
        driverInfo: [256]byte,
        conformanceVersion: VkConformanceVersion,
        denormBehaviorIndependence: VkShaderFloatControlsIndependence,
        roundingModeIndependence: VkShaderFloatControlsIndependence,
        shaderSignedZeroInfNanPreserveFloat16: VkBool32,
        shaderSignedZeroInfNanPreserveFloat32: VkBool32,
        shaderSignedZeroInfNanPreserveFloat64: VkBool32,
        shaderDenormPreserveFloat16: VkBool32,
        shaderDenormPreserveFloat32: VkBool32,
        shaderDenormPreserveFloat64: VkBool32,
        shaderDenormFlushToZeroFloat16: VkBool32,
        shaderDenormFlushToZeroFloat32: VkBool32,
        shaderDenormFlushToZeroFloat64: VkBool32,
        shaderRoundingModeRTEFloat16: VkBool32,
        shaderRoundingModeRTEFloat32: VkBool32,
        shaderRoundingModeRTEFloat64: VkBool32,
        shaderRoundingModeRTZFloat16: VkBool32,
        shaderRoundingModeRTZFloat32: VkBool32,
        shaderRoundingModeRTZFloat64: VkBool32,
        maxUpdateAfterBindDescriptorsInAllPools: uint32,
        shaderUniformBufferArrayNonUniformIndexingNative: VkBool32,
        shaderSampledImageArrayNonUniformIndexingNative: VkBool32,
        shaderStorageBufferArrayNonUniformIndexingNative: VkBool32,
        shaderStorageImageArrayNonUniformIndexingNative: VkBool32,
        shaderInputAttachmentArrayNonUniformIndexingNative: VkBool32,
        robustBufferAccessUpdateAfterBind: VkBool32,
        quadDivergentImplicitLod: VkBool32,
        maxPerStageDescriptorUpdateAfterBindSamplers: uint32,
        maxPerStageDescriptorUpdateAfterBindUniformBuffers: uint32,
        maxPerStageDescriptorUpdateAfterBindStorageBuffers: uint32,
        maxPerStageDescriptorUpdateAfterBindSampledImages: uint32,
        maxPerStageDescriptorUpdateAfterBindStorageImages: uint32,
        maxPerStageDescriptorUpdateAfterBindInputAttachments: uint32,
        maxPerStageUpdateAfterBindResources: uint32,
        maxDescriptorSetUpdateAfterBindSamplers: uint32,
        maxDescriptorSetUpdateAfterBindUniformBuffers: uint32,
        maxDescriptorSetUpdateAfterBindUniformBuffersDynamic: uint32,
        maxDescriptorSetUpdateAfterBindStorageBuffers: uint32,
        maxDescriptorSetUpdateAfterBindStorageBuffersDynamic: uint32,
        maxDescriptorSetUpdateAfterBindSampledImages: uint32,
        maxDescriptorSetUpdateAfterBindStorageImages: uint32,
        maxDescriptorSetUpdateAfterBindInputAttachments: uint32,
        supportedDepthResolveModes: VkResolveModeFlags,
        supportedStencilResolveModes: VkResolveModeFlags,
        independentResolveNone: VkBool32,
        independentResolve: VkBool32,
        filterMinmaxSingleComponentFormats: VkBool32,
        filterMinmaxImageComponentMapping: VkBool32,
        maxTimelineSemaphoreValueDifference: uint64,
        framebufferIntegerColorSampleCounts: VkSampleCountFlags
}

state VkImageFormatListCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        viewFormatCount: uint32,
        pViewFormats: *VkFormat
}

state VkAttachmentDescription2
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkAttachmentDescriptionFlags,
        format: VkFormat,
        samples: VkSampleCountFlagBits,
        loadOp: VkAttachmentLoadOp,
        storeOp: VkAttachmentStoreOp,
        stencilLoadOp: VkAttachmentLoadOp,
        stencilStoreOp: VkAttachmentStoreOp,
        initialLayout: VkImageLayout,
        finalLayout: VkImageLayout
}

state VkAttachmentReference2
{
        sType: VkStructureType,
        pNext: *void,
        attachment: uint32,
        layout: VkImageLayout,
        aspectMask: VkImageAspectFlags
}

state VkSubpassDescription2
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkSubpassDescriptionFlags,
        pipelineBindPoint: VkPipelineBindPoint,
        viewMask: uint32,
        inputAttachmentCount: uint32,
        pInputAttachments: *VkAttachmentReference2,
        colorAttachmentCount: uint32,
        pColorAttachments: *VkAttachmentReference2,
        pResolveAttachments: *VkAttachmentReference2,
        pDepthStencilAttachment: *VkAttachmentReference2,
        preserveAttachmentCount: uint32,
        pPreserveAttachments: *uint32
}

state VkSubpassDependency2
{
        sType: VkStructureType,
        pNext: *void,
        srcSubpass: uint32,
        dstSubpass: uint32,
        srcStageMask: VkPipelineStageFlags,
        dstStageMask: VkPipelineStageFlags,
        srcAccessMask: VkAccessFlags,
        dstAccessMask: VkAccessFlags,
        dependencyFlags: VkDependencyFlags,
        viewOffset: int32
}

state VkRenderPassCreateInfo2
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkRenderPassCreateFlags,
        attachmentCount: uint32,
        pAttachments: *VkAttachmentDescription2,
        subpassCount: uint32,
        pSubpasses: *VkSubpassDescription2,
        dependencyCount: uint32,
        pDependencies: *VkSubpassDependency2,
        correlatedViewMaskCount: uint32,
        pCorrelatedViewMasks: *uint32
}

state VkSubpassBeginInfo
{
        sType: VkStructureType,
        pNext: *void,
        contents: VkSubpassContents
}

state VkSubpassEndInfo
{
        sType: VkStructureType,
        pNext: *void
}

state VkPhysicalDevice8BitStorageFeatures
{
        sType: VkStructureType,
        pNext: *void,
        storageBuffer8BitAccess: VkBool32,
        uniformAndStorageBuffer8BitAccess: VkBool32,
        storagePushConstant8: VkBool32
}

state VkPhysicalDeviceDriverProperties
{
        sType: VkStructureType,
        pNext: *void,
        driverID: VkDriverId,
        driverName: [256]byte,
        driverInfo: [256]byte,
        conformanceVersion: VkConformanceVersion
}

state VkPhysicalDeviceShaderAtomicInt64Features
{
        sType: VkStructureType,
        pNext: *void,
        shaderBufferInt64Atomics: VkBool32,
        shaderSharedInt64Atomics: VkBool32
}

state VkPhysicalDeviceShaderFloat16Int8Features
{
        sType: VkStructureType,
        pNext: *void,
        shaderFloat16: VkBool32,
        shaderInt8: VkBool32
}

state VkPhysicalDeviceFloatControlsProperties
{
        sType: VkStructureType,
        pNext: *void,
        denormBehaviorIndependence: VkShaderFloatControlsIndependence,
        roundingModeIndependence: VkShaderFloatControlsIndependence,
        shaderSignedZeroInfNanPreserveFloat16: VkBool32,
        shaderSignedZeroInfNanPreserveFloat32: VkBool32,
        shaderSignedZeroInfNanPreserveFloat64: VkBool32,
        shaderDenormPreserveFloat16: VkBool32,
        shaderDenormPreserveFloat32: VkBool32,
        shaderDenormPreserveFloat64: VkBool32,
        shaderDenormFlushToZeroFloat16: VkBool32,
        shaderDenormFlushToZeroFloat32: VkBool32,
        shaderDenormFlushToZeroFloat64: VkBool32,
        shaderRoundingModeRTEFloat16: VkBool32,
        shaderRoundingModeRTEFloat32: VkBool32,
        shaderRoundingModeRTEFloat64: VkBool32,
        shaderRoundingModeRTZFloat16: VkBool32,
        shaderRoundingModeRTZFloat32: VkBool32,
        shaderRoundingModeRTZFloat64: VkBool32
}

state VkDescriptorSetLayoutBindingFlagsCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        bindingCount: uint32,
        pBindingFlags: *VkDescriptorBindingFlags
}

state VkPhysicalDeviceDescriptorIndexingFeatures
{
        sType: VkStructureType,
        pNext: *void,
        shaderInputAttachmentArrayDynamicIndexing: VkBool32,
        shaderUniformTexelBufferArrayDynamicIndexing: VkBool32,
        shaderStorageTexelBufferArrayDynamicIndexing: VkBool32,
        shaderUniformBufferArrayNonUniformIndexing: VkBool32,
        shaderSampledImageArrayNonUniformIndexing: VkBool32,
        shaderStorageBufferArrayNonUniformIndexing: VkBool32,
        shaderStorageImageArrayNonUniformIndexing: VkBool32,
        shaderInputAttachmentArrayNonUniformIndexing: VkBool32,
        shaderUniformTexelBufferArrayNonUniformIndexing: VkBool32,
        shaderStorageTexelBufferArrayNonUniformIndexing: VkBool32,
        descriptorBindingUniformBufferUpdateAfterBind: VkBool32,
        descriptorBindingSampledImageUpdateAfterBind: VkBool32,
        descriptorBindingStorageImageUpdateAfterBind: VkBool32,
        descriptorBindingStorageBufferUpdateAfterBind: VkBool32,
        descriptorBindingUniformTexelBufferUpdateAfterBind: VkBool32,
        descriptorBindingStorageTexelBufferUpdateAfterBind: VkBool32,
        descriptorBindingUpdateUnusedWhilePending: VkBool32,
        descriptorBindingPartiallyBound: VkBool32,
        descriptorBindingVariableDescriptorCount: VkBool32,
        runtimeDescriptorArray: VkBool32
}

state VkPhysicalDeviceDescriptorIndexingProperties
{
        sType: VkStructureType,
        pNext: *void,
        maxUpdateAfterBindDescriptorsInAllPools: uint32,
        shaderUniformBufferArrayNonUniformIndexingNative: VkBool32,
        shaderSampledImageArrayNonUniformIndexingNative: VkBool32,
        shaderStorageBufferArrayNonUniformIndexingNative: VkBool32,
        shaderStorageImageArrayNonUniformIndexingNative: VkBool32,
        shaderInputAttachmentArrayNonUniformIndexingNative: VkBool32,
        robustBufferAccessUpdateAfterBind: VkBool32,
        quadDivergentImplicitLod: VkBool32,
        maxPerStageDescriptorUpdateAfterBindSamplers: uint32,
        maxPerStageDescriptorUpdateAfterBindUniformBuffers: uint32,
        maxPerStageDescriptorUpdateAfterBindStorageBuffers: uint32,
        maxPerStageDescriptorUpdateAfterBindSampledImages: uint32,
        maxPerStageDescriptorUpdateAfterBindStorageImages: uint32,
        maxPerStageDescriptorUpdateAfterBindInputAttachments: uint32,
        maxPerStageUpdateAfterBindResources: uint32,
        maxDescriptorSetUpdateAfterBindSamplers: uint32,
        maxDescriptorSetUpdateAfterBindUniformBuffers: uint32,
        maxDescriptorSetUpdateAfterBindUniformBuffersDynamic: uint32,
        maxDescriptorSetUpdateAfterBindStorageBuffers: uint32,
        maxDescriptorSetUpdateAfterBindStorageBuffersDynamic: uint32,
        maxDescriptorSetUpdateAfterBindSampledImages: uint32,
        maxDescriptorSetUpdateAfterBindStorageImages: uint32,
        maxDescriptorSetUpdateAfterBindInputAttachments: uint32
}

state VkDescriptorSetVariableDescriptorCountAllocateInfo
{
        sType: VkStructureType,
        pNext: *void,
        descriptorSetCount: uint32,
        pDescriptorCounts: *uint32
}

state VkDescriptorSetVariableDescriptorCountLayoutSupport
{
        sType: VkStructureType,
        pNext: *void,
        maxVariableDescriptorCount: uint32
}

state VkSubpassDescriptionDepthStencilResolve
{
        sType: VkStructureType,
        pNext: *void,
        depthResolveMode: VkResolveModeFlagBits,
        stencilResolveMode: VkResolveModeFlagBits,
        pDepthStencilResolveAttachment: *VkAttachmentReference2
}

state VkPhysicalDeviceDepthStencilResolveProperties
{
        sType: VkStructureType,
        pNext: *void,
        supportedDepthResolveModes: VkResolveModeFlags,
        supportedStencilResolveModes: VkResolveModeFlags,
        independentResolveNone: VkBool32,
        independentResolve: VkBool32
}

state VkPhysicalDeviceScalarBlockLayoutFeatures
{
        sType: VkStructureType,
        pNext: *void,
        scalarBlockLayout: VkBool32
}

state VkImageStencilUsageCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        stencilUsage: VkImageUsageFlags
}

state VkSamplerReductionModeCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        reductionMode: VkSamplerReductionMode
}

state VkPhysicalDeviceSamplerFilterMinmaxProperties
{
        sType: VkStructureType,
        pNext: *void,
        filterMinmaxSingleComponentFormats: VkBool32,
        filterMinmaxImageComponentMapping: VkBool32
}

state VkPhysicalDeviceVulkanMemoryModelFeatures
{
        sType: VkStructureType,
        pNext: *void,
        vulkanMemoryModel: VkBool32,
        vulkanMemoryModelDeviceScope: VkBool32,
        vulkanMemoryModelAvailabilityVisibilityChains: VkBool32
}

state VkPhysicalDeviceImagelessFramebufferFeatures
{
        sType: VkStructureType,
        pNext: *void,
        imagelessFramebuffer: VkBool32
}

state VkFramebufferAttachmentImageInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkImageCreateFlags,
        usage: VkImageUsageFlags,
        width: uint32,
        height: uint32,
        layerCount: uint32,
        viewFormatCount: uint32,
        pViewFormats: *VkFormat
}

state VkFramebufferAttachmentsCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        attachmentImageInfoCount: uint32,
        pAttachmentImageInfos: *VkFramebufferAttachmentImageInfo
}

state VkRenderPassAttachmentBeginInfo
{
        sType: VkStructureType,
        pNext: *void,
        attachmentCount: uint32,
        pAttachments: *VkImageView
}

state VkPhysicalDeviceUniformBufferStandardLayoutFeatures
{
        sType: VkStructureType,
        pNext: *void,
        uniformBufferStandardLayout: VkBool32
}

state VkPhysicalDeviceShaderSubgroupExtendedTypesFeatures
{
        sType: VkStructureType,
        pNext: *void,
        shaderSubgroupExtendedTypes: VkBool32
}

state VkPhysicalDeviceSeparateDepthStencilLayoutsFeatures
{
        sType: VkStructureType,
        pNext: *void,
        separateDepthStencilLayouts: VkBool32
}

state VkAttachmentReferenceStencilLayout
{
        sType: VkStructureType,
        pNext: *void,
        stencilLayout: VkImageLayout
}

state VkAttachmentDescriptionStencilLayout
{
        sType: VkStructureType,
        pNext: *void,
        stencilInitialLayout: VkImageLayout,
        stencilFinalLayout: VkImageLayout
}

state VkPhysicalDeviceHostQueryResetFeatures
{
        sType: VkStructureType,
        pNext: *void,
        hostQueryReset: VkBool32
}

state VkPhysicalDeviceTimelineSemaphoreFeatures
{
        sType: VkStructureType,
        pNext: *void,
        timelineSemaphore: VkBool32
}

state VkPhysicalDeviceTimelineSemaphoreProperties
{
        sType: VkStructureType,
        pNext: *void,
        maxTimelineSemaphoreValueDifference: uint64
}

state VkSemaphoreTypeCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        semaphoreType: VkSemaphoreType,
        initialValue: uint64
}

state VkTimelineSemaphoreSubmitInfo
{
        sType: VkStructureType,
        pNext: *void,
        waitSemaphoreValueCount: uint32,
        pWaitSemaphoreValues: *uint64,
        signalSemaphoreValueCount: uint32,
        pSignalSemaphoreValues: *uint64
}

state VkSemaphoreWaitInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkSemaphoreWaitFlags,
        semaphoreCount: uint32,
        pSemaphores: *VkSemaphore,
        pValues: *uint64
}

state VkSemaphoreSignalInfo
{
        sType: VkStructureType,
        pNext: *void,
        semaphore: VkSemaphore,
        value: uint64
}

state VkPhysicalDeviceBufferDeviceAddressFeatures
{
        sType: VkStructureType,
        pNext: *void,
        bufferDeviceAddress: VkBool32,
        bufferDeviceAddressCaptureReplay: VkBool32,
        bufferDeviceAddressMultiDevice: VkBool32
}

state VkBufferDeviceAddressInfo
{
        sType: VkStructureType,
        pNext: *void,
        buffer: VkBuffer
}

state VkBufferOpaqueCaptureAddressCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        opaqueCaptureAddress: uint64
}

state VkMemoryOpaqueCaptureAddressAllocateInfo
{
        sType: VkStructureType,
        pNext: *void,
        opaqueCaptureAddress: uint64
}

state VkDeviceMemoryOpaqueCaptureAddressInfo
{
        sType: VkStructureType,
        pNext: *void,
        memory: VkDeviceMemory
}

state VkPhysicalDeviceVulkan13Features
{
        sType: VkStructureType,
        pNext: *void,
        robustImageAccess: VkBool32,
        inlineUniformBlock: VkBool32,
        descriptorBindingInlineUniformBlockUpdateAfterBind: VkBool32,
        pipelineCreationCacheControl: VkBool32,
        privateData: VkBool32,
        shaderDemoteToHelperInvocation: VkBool32,
        shaderTerminateInvocation: VkBool32,
        subgroupSizeControl: VkBool32,
        computeFullSubgroups: VkBool32,
        synchronization2: VkBool32,
        textureCompressionASTC_HDR: VkBool32,
        shaderZeroInitializeWorkgroupMemory: VkBool32,
        dynamicRendering: VkBool32,
        shaderIntegerDotProduct: VkBool32,
        maintenance4: VkBool32
}

state VkPhysicalDeviceVulkan13Properties
{
        sType: VkStructureType,
        pNext: *void,
        minSubgroupSize: uint32,
        maxSubgroupSize: uint32,
        maxComputeWorkgroupSubgroups: uint32,
        requiredSubgroupSizeStages: VkShaderStageFlags,
        maxInlineUniformBlockSize: uint32,
        maxPerStageDescriptorInlineUniformBlocks: uint32,
        maxPerStageDescriptorUpdateAfterBindInlineUniformBlocks: uint32,
        maxDescriptorSetInlineUniformBlocks: uint32,
        maxDescriptorSetUpdateAfterBindInlineUniformBlocks: uint32,
        maxInlineUniformTotalSize: uint32,
        integerDotProduct8BitUnsignedAccelerated: VkBool32,
        integerDotProduct8BitSignedAccelerated: VkBool32,
        integerDotProduct8BitMixedSignednessAccelerated: VkBool32,
        integerDotProduct4x8BitPackedUnsignedAccelerated: VkBool32,
        integerDotProduct4x8BitPackedSignedAccelerated: VkBool32,
        integerDotProduct4x8BitPackedMixedSignednessAccelerated: VkBool32,
        integerDotProduct16BitUnsignedAccelerated: VkBool32,
        integerDotProduct16BitSignedAccelerated: VkBool32,
        integerDotProduct16BitMixedSignednessAccelerated: VkBool32,
        integerDotProduct32BitUnsignedAccelerated: VkBool32,
        integerDotProduct32BitSignedAccelerated: VkBool32,
        integerDotProduct32BitMixedSignednessAccelerated: VkBool32,
        integerDotProduct64BitUnsignedAccelerated: VkBool32,
        integerDotProduct64BitSignedAccelerated: VkBool32,
        integerDotProduct64BitMixedSignednessAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating8BitUnsignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating8BitSignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating8BitMixedSignednessAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating4x8BitPackedUnsignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating4x8BitPackedSignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating4x8BitPackedMixedSignednessAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating16BitUnsignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating16BitSignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating16BitMixedSignednessAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating32BitUnsignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating32BitSignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating32BitMixedSignednessAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating64BitUnsignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating64BitSignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating64BitMixedSignednessAccelerated: VkBool32,
        storageTexelBufferOffsetAlignmentBytes: VkDeviceSize,
        storageTexelBufferOffsetSingleTexelAlignment: VkBool32,
        uniformTexelBufferOffsetAlignmentBytes: VkDeviceSize,
        uniformTexelBufferOffsetSingleTexelAlignment: VkBool32,
        maxBufferSize: VkDeviceSize
}

state VkPipelineCreationFeedback
{
        flags: VkPipelineCreationFeedbackFlags,
        duration: uint64
}

state VkPipelineCreationFeedbackCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        pPipelineCreationFeedback: *VkPipelineCreationFeedback,
        pipelineStageCreationFeedbackCount: uint32,
        pPipelineStageCreationFeedbacks: *VkPipelineCreationFeedback
}

state VkPhysicalDeviceShaderTerminateInvocationFeatures
{
        sType: VkStructureType,
        pNext: *void,
        shaderTerminateInvocation: VkBool32
}

state VkPhysicalDeviceToolProperties
{
        sType: VkStructureType,
        pNext: *void,
        name: [256]byte,
        version: [256]byte,
        purposes: VkToolPurposeFlags,
        description: [256]byte,
        layer: [256]byte
}

state VkPhysicalDeviceShaderDemoteToHelperInvocationFeatures
{
        sType: VkStructureType,
        pNext: *void,
        shaderDemoteToHelperInvocation: VkBool32
}

state VkPhysicalDevicePrivateDataFeatures
{
        sType: VkStructureType,
        pNext: *void,
        privateData: VkBool32
}

state VkDevicePrivateDataCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        privateDataSlotRequestCount: uint32
}

state VkPrivateDataSlotCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPrivateDataSlotCreateFlags
}

state VkPhysicalDevicePipelineCreationCacheControlFeatures
{
        sType: VkStructureType,
        pNext: *void,
        pipelineCreationCacheControl: VkBool32
}

state VkMemoryBarrier2
{
        sType: VkStructureType,
        pNext: *void,
        srcStageMask: VkPipelineStageFlags2,
        srcAccessMask: VkAccessFlags2,
        dstStageMask: VkPipelineStageFlags2,
        dstAccessMask: VkAccessFlags2
}

state VkBufferMemoryBarrier2
{
        sType: VkStructureType,
        pNext: *void,
        srcStageMask: VkPipelineStageFlags2,
        srcAccessMask: VkAccessFlags2,
        dstStageMask: VkPipelineStageFlags2,
        dstAccessMask: VkAccessFlags2,
        srcQueueFamilyIndex: uint32,
        dstQueueFamilyIndex: uint32,
        buffer: VkBuffer,
        offset: VkDeviceSize,
        size: VkDeviceSize
}

state VkImageMemoryBarrier2
{
        sType: VkStructureType,
        pNext: *void,
        srcStageMask: VkPipelineStageFlags2,
        srcAccessMask: VkAccessFlags2,
        dstStageMask: VkPipelineStageFlags2,
        dstAccessMask: VkAccessFlags2,
        oldLayout: VkImageLayout,
        newLayout: VkImageLayout,
        srcQueueFamilyIndex: uint32,
        dstQueueFamilyIndex: uint32,
        image: VkImage,
        subresourceRange: VkImageSubresourceRange
}

state VkDependencyInfo
{
        sType: VkStructureType,
        pNext: *void,
        dependencyFlags: VkDependencyFlags,
        memoryBarrierCount: uint32,
        pMemoryBarriers: *VkMemoryBarrier2,
        bufferMemoryBarrierCount: uint32,
        pBufferMemoryBarriers: *VkBufferMemoryBarrier2,
        imageMemoryBarrierCount: uint32,
        pImageMemoryBarriers: *VkImageMemoryBarrier2
}

state VkSemaphoreSubmitInfo
{
        sType: VkStructureType,
        pNext: *void,
        semaphore: VkSemaphore,
        value: uint64,
        stageMask: VkPipelineStageFlags2,
        deviceIndex: uint32
}

state VkCommandBufferSubmitInfo
{
        sType: VkStructureType,
        pNext: *void,
        commandBuffer: VkCommandBuffer,
        deviceMask: uint32
}

state VkSubmitInfo2
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkSubmitFlags,
        waitSemaphoreInfoCount: uint32,
        pWaitSemaphoreInfos: *VkSemaphoreSubmitInfo,
        commandBufferInfoCount: uint32,
        pCommandBufferInfos: *VkCommandBufferSubmitInfo,
        signalSemaphoreInfoCount: uint32,
        pSignalSemaphoreInfos: *VkSemaphoreSubmitInfo
}

state VkPhysicalDeviceSynchronization2Features
{
        sType: VkStructureType,
        pNext: *void,
        synchronization2: VkBool32
}

state VkPhysicalDeviceZeroInitializeWorkgroupMemoryFeatures
{
        sType: VkStructureType,
        pNext: *void,
        shaderZeroInitializeWorkgroupMemory: VkBool32
}

state VkPhysicalDeviceImageRobustnessFeatures
{
        sType: VkStructureType,
        pNext: *void,
        robustImageAccess: VkBool32
}

state VkBufferCopy2
{
        sType: VkStructureType,
        pNext: *void,
        srcOffset: VkDeviceSize,
        dstOffset: VkDeviceSize,
        size: VkDeviceSize
}

state VkCopyBufferInfo2
{
        sType: VkStructureType,
        pNext: *void,
        srcBuffer: VkBuffer,
        dstBuffer: VkBuffer,
        regionCount: uint32,
        pRegions: *VkBufferCopy2
}

state VkImageCopy2
{
        sType: VkStructureType,
        pNext: *void,
        srcSubresource: VkImageSubresourceLayers,
        srcOffset: VkOffset3D,
        dstSubresource: VkImageSubresourceLayers,
        dstOffset: VkOffset3D,
        extent: VkExtent3D
}

state VkCopyImageInfo2
{
        sType: VkStructureType,
        pNext: *void,
        srcImage: VkImage,
        srcImageLayout: VkImageLayout,
        dstImage: VkImage,
        dstImageLayout: VkImageLayout,
        regionCount: uint32,
        pRegions: *VkImageCopy2
}

state VkBufferImageCopy2
{
        sType: VkStructureType,
        pNext: *void,
        bufferOffset: VkDeviceSize,
        bufferRowLength: uint32,
        bufferImageHeight: uint32,
        imageSubresource: VkImageSubresourceLayers,
        imageOffset: VkOffset3D,
        imageExtent: VkExtent3D
}

state VkCopyBufferToImageInfo2
{
        sType: VkStructureType,
        pNext: *void,
        srcBuffer: VkBuffer,
        dstImage: VkImage,
        dstImageLayout: VkImageLayout,
        regionCount: uint32,
        pRegions: *VkBufferImageCopy2
}

state VkCopyImageToBufferInfo2
{
        sType: VkStructureType,
        pNext: *void,
        srcImage: VkImage,
        srcImageLayout: VkImageLayout,
        dstBuffer: VkBuffer,
        regionCount: uint32,
        pRegions: *VkBufferImageCopy2
}

state VkImageBlit2
{
        sType: VkStructureType,
        pNext: *void,
        srcSubresource: VkImageSubresourceLayers,
        srcOffsets: [2]VkOffset3D,
        dstSubresource: VkImageSubresourceLayers,
        dstOffsets: [2]VkOffset3D
}

state VkBlitImageInfo2
{
        sType: VkStructureType,
        pNext: *void,
        srcImage: VkImage,
        srcImageLayout: VkImageLayout,
        dstImage: VkImage,
        dstImageLayout: VkImageLayout,
        regionCount: uint32,
        pRegions: *VkImageBlit2,
        filter: VkFilter
}

state VkImageResolve2
{
        sType: VkStructureType,
        pNext: *void,
        srcSubresource: VkImageSubresourceLayers,
        srcOffset: VkOffset3D,
        dstSubresource: VkImageSubresourceLayers,
        dstOffset: VkOffset3D,
        extent: VkExtent3D
}

state VkResolveImageInfo2
{
        sType: VkStructureType,
        pNext: *void,
        srcImage: VkImage,
        srcImageLayout: VkImageLayout,
        dstImage: VkImage,
        dstImageLayout: VkImageLayout,
        regionCount: uint32,
        pRegions: *VkImageResolve2
}

state VkPhysicalDeviceSubgroupSizeControlFeatures
{
        sType: VkStructureType,
        pNext: *void,
        subgroupSizeControl: VkBool32,
        computeFullSubgroups: VkBool32
}

state VkPhysicalDeviceSubgroupSizeControlProperties
{
        sType: VkStructureType,
        pNext: *void,
        minSubgroupSize: uint32,
        maxSubgroupSize: uint32,
        maxComputeWorkgroupSubgroups: uint32,
        requiredSubgroupSizeStages: VkShaderStageFlags
}

state VkPipelineShaderStageRequiredSubgroupSizeCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        requiredSubgroupSize: uint32
}

state VkPhysicalDeviceInlineUniformBlockFeatures
{
        sType: VkStructureType,
        pNext: *void,
        inlineUniformBlock: VkBool32,
        descriptorBindingInlineUniformBlockUpdateAfterBind: VkBool32
}

state VkPhysicalDeviceInlineUniformBlockProperties
{
        sType: VkStructureType,
        pNext: *void,
        maxInlineUniformBlockSize: uint32,
        maxPerStageDescriptorInlineUniformBlocks: uint32,
        maxPerStageDescriptorUpdateAfterBindInlineUniformBlocks: uint32,
        maxDescriptorSetInlineUniformBlocks: uint32,
        maxDescriptorSetUpdateAfterBindInlineUniformBlocks: uint32
}

state VkWriteDescriptorSetInlineUniformBlock
{
        sType: VkStructureType,
        pNext: *void,
        dataSize: uint32,
        pData: *void
}

state VkDescriptorPoolInlineUniformBlockCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        maxInlineUniformBlockBindings: uint32
}

state VkPhysicalDeviceTextureCompressionASTCHDRFeatures
{
        sType: VkStructureType,
        pNext: *void,
        textureCompressionASTC_HDR: VkBool32
}

state VkRenderingAttachmentInfo
{
        sType: VkStructureType,
        pNext: *void,
        imageView: VkImageView,
        imageLayout: VkImageLayout,
        resolveMode: VkResolveModeFlagBits,
        resolveImageView: VkImageView,
        resolveImageLayout: VkImageLayout,
        loadOp: VkAttachmentLoadOp,
        storeOp: VkAttachmentStoreOp,
        clearValue: VkClearValue
}

state VkRenderingInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkRenderingFlags,
        renderArea: VkRect2D,
        layerCount: uint32,
        viewMask: uint32,
        colorAttachmentCount: uint32,
        pColorAttachments: *VkRenderingAttachmentInfo,
        pDepthAttachment: *VkRenderingAttachmentInfo,
        pStencilAttachment: *VkRenderingAttachmentInfo
}

state VkPipelineRenderingCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        viewMask: uint32,
        colorAttachmentCount: uint32,
        pColorAttachmentFormats: *VkFormat,
        depthAttachmentFormat: VkFormat,
        stencilAttachmentFormat: VkFormat
}

state VkPhysicalDeviceDynamicRenderingFeatures
{
        sType: VkStructureType,
        pNext: *void,
        dynamicRendering: VkBool32
}

state VkCommandBufferInheritanceRenderingInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkRenderingFlags,
        viewMask: uint32,
        colorAttachmentCount: uint32,
        pColorAttachmentFormats: *VkFormat,
        depthAttachmentFormat: VkFormat,
        stencilAttachmentFormat: VkFormat,
        rasterizationSamples: VkSampleCountFlagBits
}

state VkPhysicalDeviceShaderIntegerDotProductFeatures
{
        sType: VkStructureType,
        pNext: *void,
        shaderIntegerDotProduct: VkBool32
}

state VkPhysicalDeviceShaderIntegerDotProductProperties
{
        sType: VkStructureType,
        pNext: *void,
        integerDotProduct8BitUnsignedAccelerated: VkBool32,
        integerDotProduct8BitSignedAccelerated: VkBool32,
        integerDotProduct8BitMixedSignednessAccelerated: VkBool32,
        integerDotProduct4x8BitPackedUnsignedAccelerated: VkBool32,
        integerDotProduct4x8BitPackedSignedAccelerated: VkBool32,
        integerDotProduct4x8BitPackedMixedSignednessAccelerated: VkBool32,
        integerDotProduct16BitUnsignedAccelerated: VkBool32,
        integerDotProduct16BitSignedAccelerated: VkBool32,
        integerDotProduct16BitMixedSignednessAccelerated: VkBool32,
        integerDotProduct32BitUnsignedAccelerated: VkBool32,
        integerDotProduct32BitSignedAccelerated: VkBool32,
        integerDotProduct32BitMixedSignednessAccelerated: VkBool32,
        integerDotProduct64BitUnsignedAccelerated: VkBool32,
        integerDotProduct64BitSignedAccelerated: VkBool32,
        integerDotProduct64BitMixedSignednessAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating8BitUnsignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating8BitSignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating8BitMixedSignednessAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating4x8BitPackedUnsignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating4x8BitPackedSignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating4x8BitPackedMixedSignednessAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating16BitUnsignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating16BitSignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating16BitMixedSignednessAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating32BitUnsignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating32BitSignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating32BitMixedSignednessAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating64BitUnsignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating64BitSignedAccelerated: VkBool32,
        integerDotProductAccumulatingSaturating64BitMixedSignednessAccelerated: VkBool32
}

state VkPhysicalDeviceTexelBufferAlignmentProperties
{
        sType: VkStructureType,
        pNext: *void,
        storageTexelBufferOffsetAlignmentBytes: VkDeviceSize,
        storageTexelBufferOffsetSingleTexelAlignment: VkBool32,
        uniformTexelBufferOffsetAlignmentBytes: VkDeviceSize,
        uniformTexelBufferOffsetSingleTexelAlignment: VkBool32
}

state VkFormatProperties3
{
        sType: VkStructureType,
        pNext: *void,
        linearTilingFeatures: VkFormatFeatureFlags2,
        optimalTilingFeatures: VkFormatFeatureFlags2,
        bufferFeatures: VkFormatFeatureFlags2
}

state VkPhysicalDeviceMaintenance4Features
{
        sType: VkStructureType,
        pNext: *void,
        maintenance4: VkBool32
}

state VkPhysicalDeviceMaintenance4Properties
{
        sType: VkStructureType,
        pNext: *void,
        maxBufferSize: VkDeviceSize
}

state VkDeviceBufferMemoryRequirements
{
        sType: VkStructureType,
        pNext: *void,
        pCreateInfo: *VkBufferCreateInfo
}

state VkDeviceImageMemoryRequirements
{
        sType: VkStructureType,
        pNext: *void,
        pCreateInfo: *VkImageCreateInfo,
        planeAspect: VkImageAspectFlagBits
}

state VkPhysicalDeviceVulkan14Features
{
        sType: VkStructureType,
        pNext: *void,
        globalPriorityQuery: VkBool32,
        shaderSubgroupRotate: VkBool32,
        shaderSubgroupRotateClustered: VkBool32,
        shaderFloatControls2: VkBool32,
        shaderExpectAssume: VkBool32,
        rectangularLines: VkBool32,
        bresenhamLines: VkBool32,
        smoothLines: VkBool32,
        stippledRectangularLines: VkBool32,
        stippledBresenhamLines: VkBool32,
        stippledSmoothLines: VkBool32,
        vertexAttributeInstanceRateDivisor: VkBool32,
        vertexAttributeInstanceRateZeroDivisor: VkBool32,
        indexTypeUint8: VkBool32,
        dynamicRenderingLocalRead: VkBool32,
        maintenance5: VkBool32,
        maintenance6: VkBool32,
        pipelineProtectedAccess: VkBool32,
        pipelineRobustness: VkBool32,
        hostImageCopy: VkBool32,
        pushDescriptor: VkBool32
}

state VkPhysicalDeviceVulkan14Properties
{
        sType: VkStructureType,
        pNext: *void,
        lineSubPixelPrecisionBits: uint32,
        maxVertexAttribDivisor: uint32,
        supportsNonZeroFirstInstance: VkBool32,
        maxPushDescriptors: uint32,
        dynamicRenderingLocalReadDepthStencilAttachments: VkBool32,
        dynamicRenderingLocalReadMultisampledAttachments: VkBool32,
        earlyFragmentMultisampleCoverageAfterSampleCounting: VkBool32,
        earlyFragmentSampleMaskTestBeforeSampleCounting: VkBool32,
        depthStencilSwizzleOneSupport: VkBool32,
        polygonModePointSize: VkBool32,
        nonStrictSinglePixelWideLinesUseParallelogram: VkBool32,
        nonStrictWideLinesUseParallelogram: VkBool32,
        blockTexelViewCompatibleMultipleLayers: VkBool32,
        maxCombinedImageSamplerDescriptorCount: uint32,
        fragmentShadingRateClampCombinerInputs: VkBool32,
        defaultRobustnessStorageBuffers: VkPipelineRobustnessBufferBehavior,
        defaultRobustnessUniformBuffers: VkPipelineRobustnessBufferBehavior,
        defaultRobustnessVertexInputs: VkPipelineRobustnessBufferBehavior,
        defaultRobustnessImages: VkPipelineRobustnessImageBehavior,
        copySrcLayoutCount: uint32,
        pCopySrcLayouts: *VkImageLayout,
        copyDstLayoutCount: uint32,
        pCopyDstLayouts: *VkImageLayout,
        optimalTilingLayoutUUID: [16]uint8_t,
        identicalMemoryTypeRequirements: VkBool32
}

state VkDeviceQueueGlobalPriorityCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        globalPriority: VkQueueGlobalPriority
}

state VkPhysicalDeviceGlobalPriorityQueryFeatures
{
        sType: VkStructureType,
        pNext: *void,
        globalPriorityQuery: VkBool32
}

state VkQueueFamilyGlobalPriorityProperties
{
        sType: VkStructureType,
        pNext: *void,
        priorityCount: uint32,
        priorities: [16]VkQueueGlobalPriority
}

state VkPhysicalDeviceShaderSubgroupRotateFeatures
{
        sType: VkStructureType,
        pNext: *void,
        shaderSubgroupRotate: VkBool32,
        shaderSubgroupRotateClustered: VkBool32
}

state VkPhysicalDeviceShaderFloatControls2Features
{
        sType: VkStructureType,
        pNext: *void,
        shaderFloatControls2: VkBool32
}

state VkPhysicalDeviceShaderExpectAssumeFeatures
{
        sType: VkStructureType,
        pNext: *void,
        shaderExpectAssume: VkBool32
}

state VkPhysicalDeviceLineRasterizationFeatures
{
        sType: VkStructureType,
        pNext: *void,
        rectangularLines: VkBool32,
        bresenhamLines: VkBool32,
        smoothLines: VkBool32,
        stippledRectangularLines: VkBool32,
        stippledBresenhamLines: VkBool32,
        stippledSmoothLines: VkBool32
}

state VkPhysicalDeviceLineRasterizationProperties
{
        sType: VkStructureType,
        pNext: *void,
        lineSubPixelPrecisionBits: uint32
}

state VkPipelineRasterizationLineStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        lineRasterizationMode: VkLineRasterizationMode,
        stippledLineEnable: VkBool32,
        lineStippleFactor: uint32,
        lineStipplePattern: uint16_t
}

state VkPhysicalDeviceVertexAttributeDivisorProperties
{
        sType: VkStructureType,
        pNext: *void,
        maxVertexAttribDivisor: uint32,
        supportsNonZeroFirstInstance: VkBool32
}

state VkVertexInputBindingDivisorDescription
{
        binding: uint32,
        divisor: uint32
}

state VkPipelineVertexInputDivisorStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        vertexBindingDivisorCount: uint32,
        pVertexBindingDivisors: *VkVertexInputBindingDivisorDescription
}

state VkPhysicalDeviceVertexAttributeDivisorFeatures
{
        sType: VkStructureType,
        pNext: *void,
        vertexAttributeInstanceRateDivisor: VkBool32,
        vertexAttributeInstanceRateZeroDivisor: VkBool32
}

state VkPhysicalDeviceIndexTypeUint8Features
{
        sType: VkStructureType,
        pNext: *void,
        indexTypeUint8: VkBool32
}

state VkMemoryMapInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkMemoryMapFlags,
        memory: VkDeviceMemory,
        offset: VkDeviceSize,
        size: VkDeviceSize
}

state VkMemoryUnmapInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkMemoryUnmapFlags,
        memory: VkDeviceMemory
}

state VkPhysicalDeviceMaintenance5Features
{
        sType: VkStructureType,
        pNext: *void,
        maintenance5: VkBool32
}

state VkPhysicalDeviceMaintenance5Properties
{
        sType: VkStructureType,
        pNext: *void,
        earlyFragmentMultisampleCoverageAfterSampleCounting: VkBool32,
        earlyFragmentSampleMaskTestBeforeSampleCounting: VkBool32,
        depthStencilSwizzleOneSupport: VkBool32,
        polygonModePointSize: VkBool32,
        nonStrictSinglePixelWideLinesUseParallelogram: VkBool32,
        nonStrictWideLinesUseParallelogram: VkBool32
}

state VkRenderingAreaInfo
{
        sType: VkStructureType,
        pNext: *void,
        viewMask: uint32,
        colorAttachmentCount: uint32,
        pColorAttachmentFormats: *VkFormat,
        depthAttachmentFormat: VkFormat,
        stencilAttachmentFormat: VkFormat
}

state VkImageSubresource2
{
        sType: VkStructureType,
        pNext: *void,
        imageSubresource: VkImageSubresource
}

state VkDeviceImageSubresourceInfo
{
        sType: VkStructureType,
        pNext: *void,
        pCreateInfo: *VkImageCreateInfo,
        pSubresource: *VkImageSubresource2
}

state VkSubresourceLayout2
{
        sType: VkStructureType,
        pNext: *void,
        subresourceLayout: VkSubresourceLayout
}

state VkPipelineCreateFlags2CreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineCreateFlags2
}

state VkBufferUsageFlags2CreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        usage: VkBufferUsageFlags2
}

state VkPhysicalDevicePushDescriptorProperties
{
        sType: VkStructureType,
        pNext: *void,
        maxPushDescriptors: uint32
}

state VkPhysicalDeviceDynamicRenderingLocalReadFeatures
{
        sType: VkStructureType,
        pNext: *void,
        dynamicRenderingLocalRead: VkBool32
}

state VkRenderingAttachmentLocationInfo
{
        sType: VkStructureType,
        pNext: *void,
        colorAttachmentCount: uint32,
        pColorAttachmentLocations: *uint32
}

state VkRenderingInputAttachmentIndexInfo
{
        sType: VkStructureType,
        pNext: *void,
        colorAttachmentCount: uint32,
        pColorAttachmentInputIndices: *uint32,
        pDepthInputAttachmentIndex: *uint32,
        pStencilInputAttachmentIndex: *uint32
}

state VkPhysicalDeviceMaintenance6Features
{
        sType: VkStructureType,
        pNext: *void,
        maintenance6: VkBool32
}

state VkPhysicalDeviceMaintenance6Properties
{
        sType: VkStructureType,
        pNext: *void,
        blockTexelViewCompatibleMultipleLayers: VkBool32,
        maxCombinedImageSamplerDescriptorCount: uint32,
        fragmentShadingRateClampCombinerInputs: VkBool32
}

state VkBindMemoryStatus
{
        sType: VkStructureType,
        pNext: *void,
        pResult: *VkResult
}

state VkBindDescriptorSetsInfo
{
        sType: VkStructureType,
        pNext: *void,
        stageFlags: VkShaderStageFlags,
        layout: VkPipelineLayout,
        firstSet: uint32,
        descriptorSetCount: uint32,
        pDescriptorSets: *VkDescriptorSet,
        dynamicOffsetCount: uint32,
        pDynamicOffsets: *uint32
}

state VkPushConstantsInfo
{
        sType: VkStructureType,
        pNext: *void,
        layout: VkPipelineLayout,
        stageFlags: VkShaderStageFlags,
        offset: uint32,
        size: uint32,
        pValues: *void
}

state VkPushDescriptorSetInfo
{
        sType: VkStructureType,
        pNext: *void,
        stageFlags: VkShaderStageFlags,
        layout: VkPipelineLayout,
        set: uint32,
        descriptorWriteCount: uint32,
        pDescriptorWrites: *VkWriteDescriptorSet
}

state VkPushDescriptorSetWithTemplateInfo
{
        sType: VkStructureType,
        pNext: *void,
        descriptorUpdateTemplate: VkDescriptorUpdateTemplate,
        layout: VkPipelineLayout,
        set: uint32,
        pData: *void
}

state VkPhysicalDevicePipelineProtectedAccessFeatures
{
        sType: VkStructureType,
        pNext: *void,
        pipelineProtectedAccess: VkBool32
}

state VkPhysicalDevicePipelineRobustnessFeatures
{
        sType: VkStructureType,
        pNext: *void,
        pipelineRobustness: VkBool32
}

state VkPhysicalDevicePipelineRobustnessProperties
{
        sType: VkStructureType,
        pNext: *void,
        defaultRobustnessStorageBuffers: VkPipelineRobustnessBufferBehavior,
        defaultRobustnessUniformBuffers: VkPipelineRobustnessBufferBehavior,
        defaultRobustnessVertexInputs: VkPipelineRobustnessBufferBehavior,
        defaultRobustnessImages: VkPipelineRobustnessImageBehavior
}

state VkPipelineRobustnessCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        storageBuffers: VkPipelineRobustnessBufferBehavior,
        uniformBuffers: VkPipelineRobustnessBufferBehavior,
        vertexInputs: VkPipelineRobustnessBufferBehavior,
        images: VkPipelineRobustnessImageBehavior
}

state VkPhysicalDeviceHostImageCopyFeatures
{
        sType: VkStructureType,
        pNext: *void,
        hostImageCopy: VkBool32
}

state VkPhysicalDeviceHostImageCopyProperties
{
        sType: VkStructureType,
        pNext: *void,
        copySrcLayoutCount: uint32,
        pCopySrcLayouts: *VkImageLayout,
        copyDstLayoutCount: uint32,
        pCopyDstLayouts: *VkImageLayout,
        optimalTilingLayoutUUID: [16]uint8_t,
        identicalMemoryTypeRequirements: VkBool32
}

state VkMemoryToImageCopy
{
        sType: VkStructureType,
        pNext: *void,
        pHostPointer: *void,
        memoryRowLength: uint32,
        memoryImageHeight: uint32,
        imageSubresource: VkImageSubresourceLayers,
        imageOffset: VkOffset3D,
        imageExtent: VkExtent3D
}

state VkImageToMemoryCopy
{
        sType: VkStructureType,
        pNext: *void,
        pHostPointer: *void,
        memoryRowLength: uint32,
        memoryImageHeight: uint32,
        imageSubresource: VkImageSubresourceLayers,
        imageOffset: VkOffset3D,
        imageExtent: VkExtent3D
}

state VkCopyMemoryToImageInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkHostImageCopyFlags,
        dstImage: VkImage,
        dstImageLayout: VkImageLayout,
        regionCount: uint32,
        pRegions: *VkMemoryToImageCopy
}

state VkCopyImageToMemoryInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkHostImageCopyFlags,
        srcImage: VkImage,
        srcImageLayout: VkImageLayout,
        regionCount: uint32,
        pRegions: *VkImageToMemoryCopy
}

state VkCopyImageToImageInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkHostImageCopyFlags,
        srcImage: VkImage,
        srcImageLayout: VkImageLayout,
        dstImage: VkImage,
        dstImageLayout: VkImageLayout,
        regionCount: uint32,
        pRegions: *VkImageCopy2
}

state VkHostImageLayoutTransitionInfo
{
        sType: VkStructureType,
        pNext: *void,
        image: VkImage,
        oldLayout: VkImageLayout,
        newLayout: VkImageLayout,
        subresourceRange: VkImageSubresourceRange
}

state VkSubresourceHostMemcpySize
{
        sType: VkStructureType,
        pNext: *void,
        size: VkDeviceSize
}

state VkHostImageCopyDevicePerformanceQuery
{
        sType: VkStructureType,
        pNext: *void,
        optimalDeviceAccess: VkBool32,
        identicalMemoryLayout: VkBool32
}

state VkSurfaceCapabilitiesKHR
{
        minImageCount: uint32,
        maxImageCount: uint32,
        currentExtent: VkExtent2D,
        minImageExtent: VkExtent2D,
        maxImageExtent: VkExtent2D,
        maxImageArrayLayers: uint32,
        supportedTransforms: VkSurfaceTransformFlagsKHR,
        currentTransform: VkSurfaceTransformFlagBitsKHR,
        supportedCompositeAlpha: VkCompositeAlphaFlagsKHR,
        supportedUsageFlags: VkImageUsageFlags
}

state VkSurfaceFormatKHR
{
        format: VkFormat,
        colorSpace: VkColorSpaceKHR
}

state VkSwapchainCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkSwapchainCreateFlagsKHR,
        surface: VkSurfaceKHR,
        minImageCount: uint32,
        imageFormat: VkFormat,
        imageColorSpace: VkColorSpaceKHR,
        imageExtent: VkExtent2D,
        imageArrayLayers: uint32,
        imageUsage: VkImageUsageFlags,
        imageSharingMode: VkSharingMode,
        queueFamilyIndexCount: uint32,
        pQueueFamilyIndices: *uint32,
        preTransform: VkSurfaceTransformFlagBitsKHR,
        compositeAlpha: VkCompositeAlphaFlagBitsKHR,
        presentMode: VkPresentModeKHR,
        clipped: VkBool32,
        oldSwapchain: VkSwapchainKHR
}

state VkPresentInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        waitSemaphoreCount: uint32,
        pWaitSemaphores: *VkSemaphore,
        swapchainCount: uint32,
        pSwapchains: *VkSwapchainKHR,
        pImageIndices: *uint32,
        pResults: *VkResult
}

state VkImageSwapchainCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        swapchain: VkSwapchainKHR
}

state VkBindImageMemorySwapchainInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        swapchain: VkSwapchainKHR,
        imageIndex: uint32
}

state VkAcquireNextImageInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        swapchain: VkSwapchainKHR,
        timeout: uint64,
        semaphore: VkSemaphore,
        fence: VkFence,
        deviceMask: uint32
}

state VkDeviceGroupPresentCapabilitiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        presentMask: [32]uint32,
        modes: VkDeviceGroupPresentModeFlagsKHR
}

state VkDeviceGroupPresentInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        swapchainCount: uint32,
        pDeviceMasks: *uint32,
        mode: VkDeviceGroupPresentModeFlagBitsKHR
}

state VkDeviceGroupSwapchainCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        modes: VkDeviceGroupPresentModeFlagsKHR
}

state VkDisplayModeParametersKHR
{
        visibleRegion: VkExtent2D,
        refreshRate: uint32
}

state VkDisplayModeCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkDisplayModeCreateFlagsKHR,
        parameters: VkDisplayModeParametersKHR
}

state VkDisplayModePropertiesKHR
{
        displayMode: VkDisplayModeKHR,
        parameters: VkDisplayModeParametersKHR
}

state VkDisplayPlaneCapabilitiesKHR
{
        supportedAlpha: VkDisplayPlaneAlphaFlagsKHR,
        minSrcPosition: VkOffset2D,
        maxSrcPosition: VkOffset2D,
        minSrcExtent: VkExtent2D,
        maxSrcExtent: VkExtent2D,
        minDstPosition: VkOffset2D,
        maxDstPosition: VkOffset2D,
        minDstExtent: VkExtent2D,
        maxDstExtent: VkExtent2D
}

state VkDisplayPlanePropertiesKHR
{
        currentDisplay: VkDisplayKHR,
        currentStackIndex: uint32
}

state VkDisplayPropertiesKHR
{
        display: VkDisplayKHR,
        displayName: *byte,
        physicalDimensions: VkExtent2D,
        physicalResolution: VkExtent2D,
        supportedTransforms: VkSurfaceTransformFlagsKHR,
        planeReorderPossible: VkBool32,
        persistentContent: VkBool32
}

state VkDisplaySurfaceCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkDisplaySurfaceCreateFlagsKHR,
        displayMode: VkDisplayModeKHR,
        planeIndex: uint32,
        planeStackIndex: uint32,
        transform: VkSurfaceTransformFlagBitsKHR,
        globalAlpha: :float,
        alphaMode: VkDisplayPlaneAlphaFlagBitsKHR,
        imageExtent: VkExtent2D
}

state VkDisplayPresentInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        srcRect: VkRect2D,
        dstRect: VkRect2D,
        persistent: VkBool32
}

state VkQueueFamilyQueryResultStatusPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        queryResultStatusSupport: VkBool32
}

state VkQueueFamilyVideoPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        videoCodecOperations: VkVideoCodecOperationFlagsKHR
}

state VkVideoProfileInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        videoCodecOperation: VkVideoCodecOperationFlagBitsKHR,
        chromaSubsampling: VkVideoChromaSubsamplingFlagsKHR,
        lumaBitDepth: VkVideoComponentBitDepthFlagsKHR,
        chromaBitDepth: VkVideoComponentBitDepthFlagsKHR
}

state VkVideoProfileListInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        profileCount: uint32,
        pProfiles: *VkVideoProfileInfoKHR
}

state VkVideoCapabilitiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkVideoCapabilityFlagsKHR,
        minBitstreamBufferOffsetAlignment: VkDeviceSize,
        minBitstreamBufferSizeAlignment: VkDeviceSize,
        pictureAccessGranularity: VkExtent2D,
        minCodedExtent: VkExtent2D,
        maxCodedExtent: VkExtent2D,
        maxDpbSlots: uint32,
        maxActiveReferencePictures: uint32,
        stdHeaderVersion: VkExtensionProperties
}

state VkPhysicalDeviceVideoFormatInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        imageUsage: VkImageUsageFlags
}

state VkVideoFormatPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        format: VkFormat,
        componentMapping: VkComponentMapping,
        imageCreateFlags: VkImageCreateFlags,
        imageType: VkImageType,
        imageTiling: VkImageTiling,
        imageUsageFlags: VkImageUsageFlags
}

state VkVideoPictureResourceInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        codedOffset: VkOffset2D,
        codedExtent: VkExtent2D,
        baseArrayLayer: uint32,
        imageViewBinding: VkImageView
}

state VkVideoReferenceSlotInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        slotIndex: int32,
        pPictureResource: *VkVideoPictureResourceInfoKHR
}

state VkVideoSessionMemoryRequirementsKHR
{
        sType: VkStructureType,
        pNext: *void,
        memoryBindIndex: uint32,
        memoryRequirements: VkMemoryRequirements
}

state VkBindVideoSessionMemoryInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        memoryBindIndex: uint32,
        memory: VkDeviceMemory,
        memoryOffset: VkDeviceSize,
        memorySize: VkDeviceSize
}

state VkVideoSessionCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        queueFamilyIndex: uint32,
        flags: VkVideoSessionCreateFlagsKHR,
        pVideoProfile: *VkVideoProfileInfoKHR,
        pictureFormat: VkFormat,
        maxCodedExtent: VkExtent2D,
        referencePictureFormat: VkFormat,
        maxDpbSlots: uint32,
        maxActiveReferencePictures: uint32,
        pStdHeaderVersion: *VkExtensionProperties
}

state VkVideoSessionParametersCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkVideoSessionParametersCreateFlagsKHR,
        videoSessionParametersTemplate: VkVideoSessionParametersKHR,
        videoSession: VkVideoSessionKHR
}

state VkVideoSessionParametersUpdateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        updateSequenceCount: uint32
}

state VkVideoBeginCodingInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkVideoBeginCodingFlagsKHR,
        videoSession: VkVideoSessionKHR,
        videoSessionParameters: VkVideoSessionParametersKHR,
        referenceSlotCount: uint32,
        pReferenceSlots: *VkVideoReferenceSlotInfoKHR
}

state VkVideoEndCodingInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkVideoEndCodingFlagsKHR
}

state VkVideoCodingControlInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkVideoCodingControlFlagsKHR
}

state VkVideoDecodeCapabilitiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkVideoDecodeCapabilityFlagsKHR
}

state VkVideoDecodeUsageInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        videoUsageHints: VkVideoDecodeUsageFlagsKHR
}

state VkVideoDecodeInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkVideoDecodeFlagsKHR,
        srcBuffer: VkBuffer,
        srcBufferOffset: VkDeviceSize,
        srcBufferRange: VkDeviceSize,
        dstPictureResource: VkVideoPictureResourceInfoKHR,
        pSetupReferenceSlot: *VkVideoReferenceSlotInfoKHR,
        referenceSlotCount: uint32,
        pReferenceSlots: *VkVideoReferenceSlotInfoKHR
}

state VkVideoEncodeH264QpKHR
{
        qpI: int32,
        qpP: int32,
        qpB: int32
}

state VkVideoEncodeH264QualityLevelPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        preferredRateControlFlags: VkVideoEncodeH264RateControlFlagsKHR,
        preferredGopFrameCount: uint32,
        preferredIdrPeriod: uint32,
        preferredConsecutiveBFrameCount: uint32,
        preferredTemporalLayerCount: uint32,
        preferredConstantQp: VkVideoEncodeH264QpKHR,
        preferredMaxL0ReferenceCount: uint32,
        preferredMaxL1ReferenceCount: uint32,
        preferredStdEntropyCodingModeFlag: VkBool32
}

state VkVideoEncodeH264SessionParametersCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        maxStdSPSCount: uint32,
        maxStdPPSCount: uint32,
        pParametersAddInfo: *VkVideoEncodeH264SessionParametersAddInfoKHR
}

state VkVideoEncodeH264SessionParametersGetInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        writeStdSPS: VkBool32,
        writeStdPPS: VkBool32,
        stdSPSId: uint32,
        stdPPSId: uint32
}

state VkVideoEncodeH264SessionParametersFeedbackInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        hasStdSPSOverrides: VkBool32,
        hasStdPPSOverrides: VkBool32
}

state VkVideoEncodeH264RateControlInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkVideoEncodeH264RateControlFlagsKHR,
        gopFrameCount: uint32,
        idrPeriod: uint32,
        consecutiveBFrameCount: uint32,
        temporalLayerCount: uint32
}

state VkVideoEncodeH264FrameSizeKHR
{
        frameISize: uint32,
        framePSize: uint32,
        frameBSize: uint32
}

state VkVideoEncodeH264RateControlLayerInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        useMinQp: VkBool32,
        minQp: VkVideoEncodeH264QpKHR,
        useMaxQp: VkBool32,
        maxQp: VkVideoEncodeH264QpKHR,
        useMaxFrameSize: VkBool32,
        maxFrameSize: VkVideoEncodeH264FrameSizeKHR
}

state VkVideoEncodeH264GopRemainingFrameInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        useGopRemainingFrames: VkBool32,
        gopRemainingI: uint32,
        gopRemainingP: uint32,
        gopRemainingB: uint32
}

state VkVideoEncodeH265QpKHR
{
        qpI: int32,
        qpP: int32,
        qpB: int32
}

state VkVideoEncodeH265QualityLevelPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        preferredRateControlFlags: VkVideoEncodeH265RateControlFlagsKHR,
        preferredGopFrameCount: uint32,
        preferredIdrPeriod: uint32,
        preferredConsecutiveBFrameCount: uint32,
        preferredSubLayerCount: uint32,
        preferredConstantQp: VkVideoEncodeH265QpKHR,
        preferredMaxL0ReferenceCount: uint32,
        preferredMaxL1ReferenceCount: uint32
}

state VkVideoEncodeH265SessionParametersCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        maxStdVPSCount: uint32,
        maxStdSPSCount: uint32,
        maxStdPPSCount: uint32,
        pParametersAddInfo: *VkVideoEncodeH265SessionParametersAddInfoKHR
}

state VkVideoEncodeH265SessionParametersGetInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        writeStdVPS: VkBool32,
        writeStdSPS: VkBool32,
        writeStdPPS: VkBool32,
        stdVPSId: uint32,
        stdSPSId: uint32,
        stdPPSId: uint32
}

state VkVideoEncodeH265SessionParametersFeedbackInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        hasStdVPSOverrides: VkBool32,
        hasStdSPSOverrides: VkBool32,
        hasStdPPSOverrides: VkBool32
}

state VkVideoEncodeH265RateControlInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkVideoEncodeH265RateControlFlagsKHR,
        gopFrameCount: uint32,
        idrPeriod: uint32,
        consecutiveBFrameCount: uint32,
        subLayerCount: uint32
}

state VkVideoEncodeH265FrameSizeKHR
{
        frameISize: uint32,
        framePSize: uint32,
        frameBSize: uint32
}

state VkVideoEncodeH265RateControlLayerInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        useMinQp: VkBool32,
        minQp: VkVideoEncodeH265QpKHR,
        useMaxQp: VkBool32,
        maxQp: VkVideoEncodeH265QpKHR,
        useMaxFrameSize: VkBool32,
        maxFrameSize: VkVideoEncodeH265FrameSizeKHR
}

state VkVideoEncodeH265GopRemainingFrameInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        useGopRemainingFrames: VkBool32,
        gopRemainingI: uint32,
        gopRemainingP: uint32,
        gopRemainingB: uint32
}

state VkVideoDecodeH264SessionParametersCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        maxStdSPSCount: uint32,
        maxStdPPSCount: uint32,
        pParametersAddInfo: *VkVideoDecodeH264SessionParametersAddInfoKHR
}

state VkImportMemoryFdInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        handleType: VkExternalMemoryHandleTypeFlagBits,
        fd: :int
}

state VkMemoryFdPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        memoryTypeBits: uint32
}

state VkMemoryGetFdInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        memory: VkDeviceMemory,
        handleType: VkExternalMemoryHandleTypeFlagBits
}

state VkImportSemaphoreFdInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        semaphore: VkSemaphore,
        flags: VkSemaphoreImportFlags,
        handleType: VkExternalSemaphoreHandleTypeFlagBits,
        fd: :int
}

state VkSemaphoreGetFdInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        semaphore: VkSemaphore,
        handleType: VkExternalSemaphoreHandleTypeFlagBits
}

state VkRectLayerKHR
{
        offset: VkOffset2D,
        extent: VkExtent2D,
        layer: uint32
}

state VkPresentRegionKHR
{
        rectangleCount: uint32,
        pRectangles: *VkRectLayerKHR
}

state VkPresentRegionsKHR
{
        sType: VkStructureType,
        pNext: *void,
        swapchainCount: uint32,
        pRegions: *VkPresentRegionKHR
}

state VkSharedPresentSurfaceCapabilitiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        sharedPresentSupportedUsageFlags: VkImageUsageFlags
}

state VkImportFenceFdInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        fence: VkFence,
        flags: VkFenceImportFlags,
        handleType: VkExternalFenceHandleTypeFlagBits,
        fd: :int
}

state VkFenceGetFdInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        fence: VkFence,
        handleType: VkExternalFenceHandleTypeFlagBits
}

state VkPhysicalDevicePerformanceQueryFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        performanceCounterQueryPools: VkBool32,
        performanceCounterMultipleQueryPools: VkBool32
}

state VkPhysicalDevicePerformanceQueryPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        allowCommandBufferQueryCopies: VkBool32
}

state VkPerformanceCounterKHR
{
        sType: VkStructureType,
        pNext: *void,
        unit: VkPerformanceCounterUnitKHR,
        scope: VkPerformanceCounterScopeKHR,
        storage: VkPerformanceCounterStorageKHR,
        uuid: [16]uint8_t
}

state VkPerformanceCounterDescriptionKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPerformanceCounterDescriptionFlagsKHR,
        name: [256]byte,
        category: [256]byte,
        description: [256]byte
}

state VkQueryPoolPerformanceCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        queueFamilyIndex: uint32,
        counterIndexCount: uint32,
        pCounterIndices: *uint32
}

state VkAcquireProfilingLockInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkAcquireProfilingLockFlagsKHR,
        timeout: uint64
}

state VkPerformanceQuerySubmitInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        counterPassIndex: uint32
}

state VkPhysicalDeviceSurfaceInfo2KHR
{
        sType: VkStructureType,
        pNext: *void,
        surface: VkSurfaceKHR
}

state VkSurfaceCapabilities2KHR
{
        sType: VkStructureType,
        pNext: *void,
        surfaceCapabilities: VkSurfaceCapabilitiesKHR
}

state VkSurfaceFormat2KHR
{
        sType: VkStructureType,
        pNext: *void,
        surfaceFormat: VkSurfaceFormatKHR
}

state VkDisplayProperties2KHR
{
        sType: VkStructureType,
        pNext: *void,
        displayProperties: VkDisplayPropertiesKHR
}

state VkDisplayPlaneProperties2KHR
{
        sType: VkStructureType,
        pNext: *void,
        displayPlaneProperties: VkDisplayPlanePropertiesKHR
}

state VkDisplayModeProperties2KHR
{
        sType: VkStructureType,
        pNext: *void,
        displayModeProperties: VkDisplayModePropertiesKHR
}

state VkDisplayPlaneInfo2KHR
{
        sType: VkStructureType,
        pNext: *void,
        mode: VkDisplayModeKHR,
        planeIndex: uint32
}

state VkDisplayPlaneCapabilities2KHR
{
        sType: VkStructureType,
        pNext: *void,
        capabilities: VkDisplayPlaneCapabilitiesKHR
}

state VkPhysicalDeviceShaderClockFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        shaderSubgroupClock: VkBool32,
        shaderDeviceClock: VkBool32
}

state VkVideoDecodeH265SessionParametersCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        maxStdVPSCount: uint32,
        maxStdSPSCount: uint32,
        maxStdPPSCount: uint32,
        pParametersAddInfo: *VkVideoDecodeH265SessionParametersAddInfoKHR
}

state VkFragmentShadingRateAttachmentInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        pFragmentShadingRateAttachment: *VkAttachmentReference2,
        shadingRateAttachmentTexelSize: VkExtent2D
}

state VkPipelineFragmentShadingRateStateCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        fragmentSize: VkExtent2D,
        combinerOps: [2]VkFragmentShadingRateCombinerOpKHR
}

state VkPhysicalDeviceFragmentShadingRateFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        pipelineFragmentShadingRate: VkBool32,
        primitiveFragmentShadingRate: VkBool32,
        attachmentFragmentShadingRate: VkBool32
}

state VkPhysicalDeviceFragmentShadingRatePropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        minFragmentShadingRateAttachmentTexelSize: VkExtent2D,
        maxFragmentShadingRateAttachmentTexelSize: VkExtent2D,
        maxFragmentShadingRateAttachmentTexelSizeAspectRatio: uint32,
        primitiveFragmentShadingRateWithMultipleViewports: VkBool32,
        layeredShadingRateAttachments: VkBool32,
        fragmentShadingRateNonTrivialCombinerOps: VkBool32,
        maxFragmentSize: VkExtent2D,
        maxFragmentSizeAspectRatio: uint32,
        maxFragmentShadingRateCoverageSamples: uint32,
        maxFragmentShadingRateRasterizationSamples: VkSampleCountFlagBits,
        fragmentShadingRateWithShaderDepthStencilWrites: VkBool32,
        fragmentShadingRateWithSampleMask: VkBool32,
        fragmentShadingRateWithShaderSampleMask: VkBool32,
        fragmentShadingRateWithConservativeRasterization: VkBool32,
        fragmentShadingRateWithFragmentShaderInterlock: VkBool32,
        fragmentShadingRateWithCustomSampleLocations: VkBool32,
        fragmentShadingRateStrictMultiplyCombiner: VkBool32
}

state VkPhysicalDeviceFragmentShadingRateKHR
{
        sType: VkStructureType,
        pNext: *void,
        sampleCounts: VkSampleCountFlags,
        fragmentSize: VkExtent2D
}

state VkRenderingFragmentShadingRateAttachmentInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        imageView: VkImageView,
        imageLayout: VkImageLayout,
        shadingRateAttachmentTexelSize: VkExtent2D
}

state VkPhysicalDeviceShaderQuadControlFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        shaderQuadControl: VkBool32
}

state VkSurfaceProtectedCapabilitiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        supportsProtected: VkBool32
}

state VkPhysicalDevicePresentWaitFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        presentWait: VkBool32
}

state VkPhysicalDevicePipelineExecutablePropertiesFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        pipelineExecutableInfo: VkBool32
}

state VkPipelineInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        pipeline: VkPipeline
}

state VkPipelineExecutablePropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        stages: VkShaderStageFlags,
        name: [256]byte,
        description: [256]byte,
        subgroupSize: uint32
}

state VkPipelineExecutableInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        pipeline: VkPipeline,
        executableIndex: uint32
}

state VkPipelineExecutableStatisticKHR
{
        sType: VkStructureType,
        pNext: *void,
        name: [256]byte,
        description: [256]byte,
        format: VkPipelineExecutableStatisticFormatKHR,
        value: VkPipelineExecutableStatisticValueKHR
}

state VkPipelineExecutableInternalRepresentationKHR
{
        sType: VkStructureType,
        pNext: *void,
        name: [256]byte,
        description: [256]byte,
        isText: VkBool32,
        dataSize: uint,
        pData: *void
}

state VkPipelineLibraryCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        libraryCount: uint32,
        pLibraries: *VkPipeline
}

state VkPresentIdKHR
{
        sType: VkStructureType,
        pNext: *void,
        swapchainCount: uint32,
        pPresentIds: *uint64
}

state VkPhysicalDevicePresentIdFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        presentId: VkBool32
}

state VkVideoEncodeInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkVideoEncodeFlagsKHR,
        dstBuffer: VkBuffer,
        dstBufferOffset: VkDeviceSize,
        dstBufferRange: VkDeviceSize,
        srcPictureResource: VkVideoPictureResourceInfoKHR,
        pSetupReferenceSlot: *VkVideoReferenceSlotInfoKHR,
        referenceSlotCount: uint32,
        pReferenceSlots: *VkVideoReferenceSlotInfoKHR,
        precedingExternallyEncodedBytes: uint32
}

state VkVideoEncodeCapabilitiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkVideoEncodeCapabilityFlagsKHR,
        rateControlModes: VkVideoEncodeRateControlModeFlagsKHR,
        maxRateControlLayers: uint32,
        maxBitrate: uint64,
        maxQualityLevels: uint32,
        encodeInputPictureGranularity: VkExtent2D,
        supportedEncodeFeedbackFlags: VkVideoEncodeFeedbackFlagsKHR
}

state VkQueryPoolVideoEncodeFeedbackCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        encodeFeedbackFlags: VkVideoEncodeFeedbackFlagsKHR
}

state VkVideoEncodeUsageInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        videoUsageHints: VkVideoEncodeUsageFlagsKHR,
        videoContentHints: VkVideoEncodeContentFlagsKHR,
        tuningMode: VkVideoEncodeTuningModeKHR
}

state VkVideoEncodeRateControlLayerInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        averageBitrate: uint64,
        maxBitrate: uint64,
        frameRateNumerator: uint32,
        frameRateDenominator: uint32
}

state VkVideoEncodeRateControlInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkVideoEncodeRateControlFlagsKHR,
        rateControlMode: VkVideoEncodeRateControlModeFlagBitsKHR,
        layerCount: uint32,
        pLayers: *VkVideoEncodeRateControlLayerInfoKHR,
        virtualBufferSizeInMs: uint32,
        initialVirtualBufferSizeInMs: uint32
}

state VkPhysicalDeviceVideoEncodeQualityLevelInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        pVideoProfile: *VkVideoProfileInfoKHR,
        qualityLevel: uint32
}

state VkVideoEncodeQualityLevelPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        preferredRateControlMode: VkVideoEncodeRateControlModeFlagBitsKHR,
        preferredRateControlLayerCount: uint32
}

state VkVideoEncodeQualityLevelInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        qualityLevel: uint32
}

state VkVideoEncodeSessionParametersGetInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        videoSessionParameters: VkVideoSessionParametersKHR
}

state VkVideoEncodeSessionParametersFeedbackInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        hasOverrides: VkBool32
}

state VkPhysicalDeviceFragmentShaderBarycentricFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        fragmentShaderBarycentric: VkBool32
}

state VkPhysicalDeviceFragmentShaderBarycentricPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        triStripVertexOrderIndependentOfProvokingVertex: VkBool32
}

state VkPhysicalDeviceShaderSubgroupUniformControlFlowFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        shaderSubgroupUniformControlFlow: VkBool32
}

state VkPhysicalDeviceWorkgroupMemoryExplicitLayoutFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        workgroupMemoryExplicitLayout: VkBool32,
        workgroupMemoryExplicitLayoutScalarBlockLayout: VkBool32,
        workgroupMemoryExplicitLayout8BitAccess: VkBool32,
        workgroupMemoryExplicitLayout16BitAccess: VkBool32
}

state VkPhysicalDeviceRayTracingMaintenance1FeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        rayTracingMaintenance1: VkBool32,
        rayTracingPipelineTraceRaysIndirect2: VkBool32
}

state VkTraceRaysIndirectCommand2KHR
{
        raygenShaderRecordAddress: VkDeviceAddress,
        raygenShaderRecordSize: VkDeviceSize,
        missShaderBindingTableAddress: VkDeviceAddress,
        missShaderBindingTableSize: VkDeviceSize,
        missShaderBindingTableStride: VkDeviceSize,
        hitShaderBindingTableAddress: VkDeviceAddress,
        hitShaderBindingTableSize: VkDeviceSize,
        hitShaderBindingTableStride: VkDeviceSize,
        callableShaderBindingTableAddress: VkDeviceAddress,
        callableShaderBindingTableSize: VkDeviceSize,
        callableShaderBindingTableStride: VkDeviceSize,
        width: uint32,
        height: uint32,
        depth: uint32
}

state VkPhysicalDeviceShaderMaximalReconvergenceFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        shaderMaximalReconvergence: VkBool32
}

state VkPhysicalDeviceRayTracingPositionFetchFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        rayTracingPositionFetch: VkBool32
}

state VkPhysicalDevicePipelineBinaryFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        pipelineBinaries: VkBool32
}

state VkPhysicalDevicePipelineBinaryPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        pipelineBinaryInternalCache: VkBool32,
        pipelineBinaryInternalCacheControl: VkBool32,
        pipelineBinaryPrefersInternalCache: VkBool32,
        pipelineBinaryPrecompiledInternalCache: VkBool32,
        pipelineBinaryCompressedData: VkBool32
}

state VkDevicePipelineBinaryInternalCacheControlKHR
{
        sType: VkStructureType,
        pNext: *void,
        disableInternalCache: VkBool32
}

state VkPipelineBinaryKeyKHR
{
        sType: VkStructureType,
        pNext: *void,
        keySize: uint32,
        key: [32]uint8_t
}

state VkPipelineBinaryDataKHR
{
        dataSize: uint,
        pData: *void
}

state VkPipelineBinaryKeysAndDataKHR
{
        binaryCount: uint32,
        pPipelineBinaryKeys: *VkPipelineBinaryKeyKHR,
        pPipelineBinaryData: *VkPipelineBinaryDataKHR
}

state VkPipelineCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void
}

state VkPipelineBinaryCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        pKeysAndDataInfo: *VkPipelineBinaryKeysAndDataKHR,
        pipeline: VkPipeline,
        pPipelineCreateInfo: *VkPipelineCreateInfoKHR
}

state VkPipelineBinaryInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        binaryCount: uint32,
        pPipelineBinaries: *VkPipelineBinaryKHR
}

state VkReleaseCapturedPipelineDataInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        pipeline: VkPipeline
}

state VkPipelineBinaryDataInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        pipelineBinary: VkPipelineBinaryKHR
}

state VkPipelineBinaryHandlesInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        pipelineBinaryCount: uint32,
        pPipelineBinaries: *VkPipelineBinaryKHR
}

state VkCooperativeMatrixPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        MSize: uint32,
        NSize: uint32,
        KSize: uint32,
        AType: VkComponentTypeKHR,
        BType: VkComponentTypeKHR,
        CType: VkComponentTypeKHR,
        ResultType: VkComponentTypeKHR,
        saturatingAccumulation: VkBool32,
        scope: VkScopeKHR
}

state VkPhysicalDeviceCooperativeMatrixFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        cooperativeMatrix: VkBool32,
        cooperativeMatrixRobustBufferAccess: VkBool32
}

state VkPhysicalDeviceCooperativeMatrixPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        cooperativeMatrixSupportedStages: VkShaderStageFlags
}

state VkPhysicalDeviceComputeShaderDerivativesFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        computeDerivativeGroupQuads: VkBool32,
        computeDerivativeGroupLinear: VkBool32
}

state VkPhysicalDeviceComputeShaderDerivativesPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        meshAndTaskShaderDerivatives: VkBool32
}

state VkPhysicalDeviceVideoEncodeAV1FeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        videoEncodeAV1: VkBool32
}

state VkVideoEncodeAV1QIndexKHR
{
        intraQIndex: uint32,
        predictiveQIndex: uint32,
        bipredictiveQIndex: uint32
}

state VkVideoEncodeAV1QualityLevelPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        preferredRateControlFlags: VkVideoEncodeAV1RateControlFlagsKHR,
        preferredGopFrameCount: uint32,
        preferredKeyFramePeriod: uint32,
        preferredConsecutiveBipredictiveFrameCount: uint32,
        preferredTemporalLayerCount: uint32,
        preferredConstantQIndex: VkVideoEncodeAV1QIndexKHR,
        preferredMaxSingleReferenceCount: uint32,
        preferredSingleReferenceNameMask: uint32,
        preferredMaxUnidirectionalCompoundReferenceCount: uint32,
        preferredMaxUnidirectionalCompoundGroup1ReferenceCount: uint32,
        preferredUnidirectionalCompoundReferenceNameMask: uint32,
        preferredMaxBidirectionalCompoundReferenceCount: uint32,
        preferredMaxBidirectionalCompoundGroup1ReferenceCount: uint32,
        preferredMaxBidirectionalCompoundGroup2ReferenceCount: uint32,
        preferredBidirectionalCompoundReferenceNameMask: uint32
}

state VkVideoEncodeAV1FrameSizeKHR
{
        intraFrameSize: uint32,
        predictiveFrameSize: uint32,
        bipredictiveFrameSize: uint32
}

state VkVideoEncodeAV1GopRemainingFrameInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        useGopRemainingFrames: VkBool32,
        gopRemainingIntra: uint32,
        gopRemainingPredictive: uint32,
        gopRemainingBipredictive: uint32
}

state VkVideoEncodeAV1RateControlInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkVideoEncodeAV1RateControlFlagsKHR,
        gopFrameCount: uint32,
        keyFramePeriod: uint32,
        consecutiveBipredictiveFrameCount: uint32,
        temporalLayerCount: uint32
}

state VkVideoEncodeAV1RateControlLayerInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        useMinQIndex: VkBool32,
        minQIndex: VkVideoEncodeAV1QIndexKHR,
        useMaxQIndex: VkBool32,
        maxQIndex: VkVideoEncodeAV1QIndexKHR,
        useMaxFrameSize: VkBool32,
        maxFrameSize: VkVideoEncodeAV1FrameSizeKHR
}

state VkPhysicalDeviceVideoMaintenance1FeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        videoMaintenance1: VkBool32
}

state VkVideoInlineQueryInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        queryPool: VkQueryPool,
        firstQuery: uint32,
        queryCount: uint32
}

state VkCalibratedTimestampInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        timeDomain: VkTimeDomainKHR
}

state VkSetDescriptorBufferOffsetsInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        stageFlags: VkShaderStageFlags,
        layout: VkPipelineLayout,
        firstSet: uint32,
        setCount: uint32,
        pBufferIndices: *uint32,
        pOffsets: *VkDeviceSize
}

state VkBindDescriptorBufferEmbeddedSamplersInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        stageFlags: VkShaderStageFlags,
        layout: VkPipelineLayout,
        set: uint32
}

state VkVideoEncodeQuantizationMapCapabilitiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        maxQuantizationMapExtent: VkExtent2D
}

state VkVideoFormatQuantizationMapPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        quantizationMapTexelSize: VkExtent2D
}

state VkVideoEncodeQuantizationMapInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        quantizationMap: VkImageView,
        quantizationMapExtent: VkExtent2D
}

state VkVideoEncodeQuantizationMapSessionParametersCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        quantizationMapTexelSize: VkExtent2D
}

state VkPhysicalDeviceVideoEncodeQuantizationMapFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        videoEncodeQuantizationMap: VkBool32
}

state VkVideoEncodeH264QuantizationMapCapabilitiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        minQpDelta: int32,
        maxQpDelta: int32
}

state VkVideoEncodeH265QuantizationMapCapabilitiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        minQpDelta: int32,
        maxQpDelta: int32
}

state VkVideoFormatH265QuantizationMapPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        compatibleCtbSizes: VkVideoEncodeH265CtbSizeFlagsKHR
}

state VkVideoEncodeAV1QuantizationMapCapabilitiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        minQIndexDelta: int32,
        maxQIndexDelta: int32
}

state VkVideoFormatAV1QuantizationMapPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        compatibleSuperblockSizes: VkVideoEncodeAV1SuperblockSizeFlagsKHR
}

state VkPhysicalDeviceShaderRelaxedExtendedInstructionFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        shaderRelaxedExtendedInstruction: VkBool32
}

state VkPhysicalDeviceMaintenance7FeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        maintenance7: VkBool32
}

state VkPhysicalDeviceMaintenance7PropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        robustFragmentShadingRateAttachmentAccess: VkBool32,
        separateDepthStencilAttachmentAccess: VkBool32,
        maxDescriptorSetTotalUniformBuffersDynamic: uint32,
        maxDescriptorSetTotalStorageBuffersDynamic: uint32,
        maxDescriptorSetTotalBuffersDynamic: uint32,
        maxDescriptorSetUpdateAfterBindTotalUniformBuffersDynamic: uint32,
        maxDescriptorSetUpdateAfterBindTotalStorageBuffersDynamic: uint32,
        maxDescriptorSetUpdateAfterBindTotalBuffersDynamic: uint32
}

state VkPhysicalDeviceLayeredApiPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        vendorID: uint32,
        deviceID: uint32,
        layeredAPI: VkPhysicalDeviceLayeredApiKHR,
        deviceName: [256]byte
}

state VkPhysicalDeviceLayeredApiPropertiesListKHR
{
        sType: VkStructureType,
        pNext: *void,
        layeredApiCount: uint32,
        pLayeredApis: *VkPhysicalDeviceLayeredApiPropertiesKHR
}

state VkPhysicalDeviceLayeredApiVulkanPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        properties: VkPhysicalDeviceProperties2
}

state VkPhysicalDeviceMaintenance8FeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        maintenance8: VkBool32
}

state VkMemoryBarrierAccessFlags3KHR
{
        sType: VkStructureType,
        pNext: *void,
        srcAccessMask3: VkAccessFlags3KHR,
        dstAccessMask3: VkAccessFlags3KHR
}

state VkPhysicalDeviceVideoMaintenance2FeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        videoMaintenance2: VkBool32
}

state VkPhysicalDeviceDepthClampZeroOneFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        depthClampZeroOne: VkBool32
}

state VkDebugReportCallbackCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkDebugReportFlagsEXT,
        pfnCallback: PFN_vkDebugReportCallbackEXT,
        pUserData: *void
}

state VkPipelineRasterizationStateRasterizationOrderAMD
{
        sType: VkStructureType,
        pNext: *void,
        rasterizationOrder: VkRasterizationOrderAMD
}

state VkDebugMarkerObjectNameInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        objectType: VkDebugReportObjectTypeEXT,
        object: uint64,
        pObjectName: *byte
}

state VkDebugMarkerObjectTagInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        objectType: VkDebugReportObjectTypeEXT,
        object: uint64,
        tagName: uint64,
        tagSize: uint,
        pTag: *void
}

state VkDebugMarkerMarkerInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        pMarkerName: *byte,
        color: [4]:float
}

state VkDedicatedAllocationImageCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        dedicatedAllocation: VkBool32
}

state VkDedicatedAllocationBufferCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        dedicatedAllocation: VkBool32
}

state VkDedicatedAllocationMemoryAllocateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        image: VkImage,
        buffer: VkBuffer
}

state VkPhysicalDeviceTransformFeedbackFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        transformFeedback: VkBool32,
        geometryStreams: VkBool32
}

state VkPhysicalDeviceTransformFeedbackPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        maxTransformFeedbackStreams: uint32,
        maxTransformFeedbackBuffers: uint32,
        maxTransformFeedbackBufferSize: VkDeviceSize,
        maxTransformFeedbackStreamDataSize: uint32,
        maxTransformFeedbackBufferDataSize: uint32,
        maxTransformFeedbackBufferDataStride: uint32,
        transformFeedbackQueries: VkBool32,
        transformFeedbackStreamsLinesTriangles: VkBool32,
        transformFeedbackRasterizationStreamSelect: VkBool32,
        transformFeedbackDraw: VkBool32
}

state VkPipelineRasterizationStateStreamCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineRasterizationStateStreamCreateFlagsEXT,
        rasterizationStream: uint32
}

state VkCuModuleCreateInfoNVX
{
        sType: VkStructureType,
        pNext: *void,
        dataSize: uint,
        pData: *void
}

state VkCuModuleTexturingModeCreateInfoNVX
{
        sType: VkStructureType,
        pNext: *void,
        use64bitTexturing: VkBool32
}

state VkCuFunctionCreateInfoNVX
{
        sType: VkStructureType,
        pNext: *void,
        module: VkCuModuleNVX,
        pName: *byte
}

state VkCuLaunchInfoNVX
{
        sType: VkStructureType,
        pNext: *void,
        function: VkCuFunctionNVX,
        gridDimX: uint32,
        gridDimY: uint32,
        gridDimZ: uint32,
        blockDimX: uint32,
        blockDimY: uint32,
        blockDimZ: uint32,
        sharedMemBytes: uint32,
        paramCount: uint,
        pParams: **void,
        extraCount: uint,
        pExtras: **void
}

state VkImageViewHandleInfoNVX
{
        sType: VkStructureType,
        pNext: *void,
        imageView: VkImageView,
        descriptorType: VkDescriptorType,
        sampler: VkSampler
}

state VkImageViewAddressPropertiesNVX
{
        sType: VkStructureType,
        pNext: *void,
        deviceAddress: VkDeviceAddress,
        size: VkDeviceSize
}

state VkTextureLODGatherFormatPropertiesAMD
{
        sType: VkStructureType,
        pNext: *void,
        supportsTextureGatherLODBiasAMD: VkBool32
}

state VkShaderResourceUsageAMD
{
        numUsedVgprs: uint32,
        numUsedSgprs: uint32,
        ldsSizePerLocalWorkGroup: uint32,
        ldsUsageSizeInBytes: uint,
        scratchMemUsageInBytes: uint
}

state VkShaderStatisticsInfoAMD
{
        shaderStageMask: VkShaderStageFlags,
        resourceUsage: VkShaderResourceUsageAMD,
        numPhysicalVgprs: uint32,
        numPhysicalSgprs: uint32,
        numAvailableVgprs: uint32,
        numAvailableSgprs: uint32,
        computeWorkGroupSize: [3]uint32
}

state VkPhysicalDeviceCornerSampledImageFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        cornerSampledImage: VkBool32
}

state VkExternalImageFormatPropertiesNV
{
        imageFormatProperties: VkImageFormatProperties,
        externalMemoryFeatures: VkExternalMemoryFeatureFlagsNV,
        exportFromImportedHandleTypes: VkExternalMemoryHandleTypeFlagsNV,
        compatibleHandleTypes: VkExternalMemoryHandleTypeFlagsNV
}

state VkExternalMemoryImageCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        handleTypes: VkExternalMemoryHandleTypeFlagsNV
}

state VkExportMemoryAllocateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        handleTypes: VkExternalMemoryHandleTypeFlagsNV
}

state VkValidationFlagsEXT
{
        sType: VkStructureType,
        pNext: *void,
        disabledValidationCheckCount: uint32,
        pDisabledValidationChecks: *VkValidationCheckEXT
}

state VkImageViewASTCDecodeModeEXT
{
        sType: VkStructureType,
        pNext: *void,
        decodeMode: VkFormat
}

state VkPhysicalDeviceASTCDecodeFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        decodeModeSharedExponent: VkBool32
}

state VkConditionalRenderingBeginInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        buffer: VkBuffer,
        offset: VkDeviceSize,
        flags: VkConditionalRenderingFlagsEXT
}

state VkPhysicalDeviceConditionalRenderingFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        conditionalRendering: VkBool32,
        inheritedConditionalRendering: VkBool32
}

state VkCommandBufferInheritanceConditionalRenderingInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        conditionalRenderingEnable: VkBool32
}

state VkViewportWScalingNV
{
        xcoeff: :float,
        ycoeff: :float
}

state VkPipelineViewportWScalingStateCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        viewportWScalingEnable: VkBool32,
        viewportCount: uint32,
        pViewportWScalings: *VkViewportWScalingNV
}

state VkSurfaceCapabilities2EXT
{
        sType: VkStructureType,
        pNext: *void,
        minImageCount: uint32,
        maxImageCount: uint32,
        currentExtent: VkExtent2D,
        minImageExtent: VkExtent2D,
        maxImageExtent: VkExtent2D,
        maxImageArrayLayers: uint32,
        supportedTransforms: VkSurfaceTransformFlagsKHR,
        currentTransform: VkSurfaceTransformFlagBitsKHR,
        supportedCompositeAlpha: VkCompositeAlphaFlagsKHR,
        supportedUsageFlags: VkImageUsageFlags,
        supportedSurfaceCounters: VkSurfaceCounterFlagsEXT
}

state VkDisplayPowerInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        powerState: VkDisplayPowerStateEXT
}

state VkDeviceEventInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        deviceEvent: VkDeviceEventTypeEXT
}

state VkDisplayEventInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        displayEvent: VkDisplayEventTypeEXT
}

state VkSwapchainCounterCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        surfaceCounters: VkSurfaceCounterFlagsEXT
}

state VkRefreshCycleDurationGOOGLE
{
        refreshDuration: uint64
}

state VkPastPresentationTimingGOOGLE
{
        presentID: uint32,
        desiredPresentTime: uint64,
        actualPresentTime: uint64,
        earliestPresentTime: uint64,
        presentMargin: uint64
}

state VkPresentTimeGOOGLE
{
        presentID: uint32,
        desiredPresentTime: uint64
}

state VkPresentTimesInfoGOOGLE
{
        sType: VkStructureType,
        pNext: *void,
        swapchainCount: uint32,
        pTimes: *VkPresentTimeGOOGLE
}

state VkPhysicalDeviceMultiviewPerViewAttributesPropertiesNVX
{
        sType: VkStructureType,
        pNext: *void,
        perViewPositionAllComponents: VkBool32
}

state VkMultiviewPerViewAttributesInfoNVX
{
        sType: VkStructureType,
        pNext: *void,
        perViewAttributes: VkBool32,
        perViewAttributesPositionXOnly: VkBool32
}

state VkViewportSwizzleNV
{
        x: VkViewportCoordinateSwizzleNV,
        y: VkViewportCoordinateSwizzleNV,
        z: VkViewportCoordinateSwizzleNV,
        w: VkViewportCoordinateSwizzleNV
}

state VkPipelineViewportSwizzleStateCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineViewportSwizzleStateCreateFlagsNV,
        viewportCount: uint32,
        pViewportSwizzles: *VkViewportSwizzleNV
}

state VkPhysicalDeviceDiscardRectanglePropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        maxDiscardRectangles: uint32
}

state VkPipelineDiscardRectangleStateCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineDiscardRectangleStateCreateFlagsEXT,
        discardRectangleMode: VkDiscardRectangleModeEXT,
        discardRectangleCount: uint32,
        pDiscardRectangles: *VkRect2D
}

state VkPhysicalDeviceConservativeRasterizationPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        primitiveOverestimationSize: :float,
        maxExtraPrimitiveOverestimationSize: :float,
        extraPrimitiveOverestimationSizeGranularity: :float,
        primitiveUnderestimation: VkBool32,
        conservativePointAndLineRasterization: VkBool32,
        degenerateTrianglesRasterized: VkBool32,
        degenerateLinesRasterized: VkBool32,
        fullyCoveredFragmentShaderInputVariable: VkBool32,
        conservativeRasterizationPostDepthCoverage: VkBool32
}

state VkPipelineRasterizationConservativeStateCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineRasterizationConservativeStateCreateFlagsEXT,
        conservativeRasterizationMode: VkConservativeRasterizationModeEXT,
        extraPrimitiveOverestimationSize: :float
}

state VkPhysicalDeviceDepthClipEnableFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        depthClipEnable: VkBool32
}

state VkPipelineRasterizationDepthClipStateCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineRasterizationDepthClipStateCreateFlagsEXT,
        depthClipEnable: VkBool32
}

state VkXYColorEXT
{
        x: :float,
        y: :float
}

state VkHdrMetadataEXT
{
        sType: VkStructureType,
        pNext: *void,
        displayPrimaryRed: VkXYColorEXT,
        displayPrimaryGreen: VkXYColorEXT,
        displayPrimaryBlue: VkXYColorEXT,
        whitePoint: VkXYColorEXT,
        maxLuminance: :float,
        minLuminance: :float,
        maxContentLightLevel: :float,
        maxFrameAverageLightLevel: :float
}

state VkPhysicalDeviceRelaxedLineRasterizationFeaturesIMG
{
        sType: VkStructureType,
        pNext: *void,
        relaxedLineRasterization: VkBool32
}

state VkDebugUtilsLabelEXT
{
        sType: VkStructureType,
        pNext: *void,
        pLabelName: *byte,
        color: [4]:float
}

state VkDebugUtilsObjectNameInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        objectType: VkObjectType,
        objectHandle: uint64,
        pObjectName: *byte
}

state VkDebugUtilsMessengerCallbackDataEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkDebugUtilsMessengerCallbackDataFlagsEXT,
        pMessageIdName: *byte,
        messageIdNumber: int32,
        pMessage: *byte,
        queueLabelCount: uint32,
        pQueueLabels: *VkDebugUtilsLabelEXT,
        cmdBufLabelCount: uint32,
        pCmdBufLabels: *VkDebugUtilsLabelEXT,
        objectCount: uint32,
        pObjects: *VkDebugUtilsObjectNameInfoEXT
}

state VkDebugUtilsMessengerCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkDebugUtilsMessengerCreateFlagsEXT,
        messageSeverity: VkDebugUtilsMessageSeverityFlagsEXT,
        messageType: VkDebugUtilsMessageTypeFlagsEXT,
        pfnUserCallback: PFN_vkDebugUtilsMessengerCallbackEXT,
        pUserData: *void
}

state VkDebugUtilsObjectTagInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        objectType: VkObjectType,
        objectHandle: uint64,
        tagName: uint64,
        tagSize: uint,
        pTag: *void
}

state VkAttachmentSampleCountInfoAMD
{
        sType: VkStructureType,
        pNext: *void,
        colorAttachmentCount: uint32,
        pColorAttachmentSamples: *VkSampleCountFlagBits,
        depthStencilAttachmentSamples: VkSampleCountFlagBits
}

state VkSampleLocationEXT
{
        x: :float,
        y: :float
}

state VkSampleLocationsInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        sampleLocationsPerPixel: VkSampleCountFlagBits,
        sampleLocationGridSize: VkExtent2D,
        sampleLocationsCount: uint32,
        pSampleLocations: *VkSampleLocationEXT
}

state VkAttachmentSampleLocationsEXT
{
        attachmentIndex: uint32,
        sampleLocationsInfo: VkSampleLocationsInfoEXT
}

state VkSubpassSampleLocationsEXT
{
        subpassIndex: uint32,
        sampleLocationsInfo: VkSampleLocationsInfoEXT
}

state VkRenderPassSampleLocationsBeginInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        attachmentInitialSampleLocationsCount: uint32,
        pAttachmentInitialSampleLocations: *VkAttachmentSampleLocationsEXT,
        postSubpassSampleLocationsCount: uint32,
        pPostSubpassSampleLocations: *VkSubpassSampleLocationsEXT
}

state VkPipelineSampleLocationsStateCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        sampleLocationsEnable: VkBool32,
        sampleLocationsInfo: VkSampleLocationsInfoEXT
}

state VkPhysicalDeviceSampleLocationsPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        sampleLocationSampleCounts: VkSampleCountFlags,
        maxSampleLocationGridSize: VkExtent2D,
        sampleLocationCoordinateRange: [2]:float,
        sampleLocationSubPixelBits: uint32,
        variableSampleLocations: VkBool32
}

state VkMultisamplePropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        maxSampleLocationGridSize: VkExtent2D
}

state VkPhysicalDeviceBlendOperationAdvancedFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        advancedBlendCoherentOperations: VkBool32
}

state VkPhysicalDeviceBlendOperationAdvancedPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        advancedBlendMaxColorAttachments: uint32,
        advancedBlendIndependentBlend: VkBool32,
        advancedBlendNonPremultipliedSrcColor: VkBool32,
        advancedBlendNonPremultipliedDstColor: VkBool32,
        advancedBlendCorrelatedOverlap: VkBool32,
        advancedBlendAllOperations: VkBool32
}

state VkPipelineColorBlendAdvancedStateCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        srcPremultiplied: VkBool32,
        dstPremultiplied: VkBool32,
        blendOverlap: VkBlendOverlapEXT
}

state VkPipelineCoverageToColorStateCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineCoverageToColorStateCreateFlagsNV,
        coverageToColorEnable: VkBool32,
        coverageToColorLocation: uint32
}

state VkPipelineCoverageModulationStateCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineCoverageModulationStateCreateFlagsNV,
        coverageModulationMode: VkCoverageModulationModeNV,
        coverageModulationTableEnable: VkBool32,
        coverageModulationTableCount: uint32,
        pCoverageModulationTable: *:float
}

state VkPhysicalDeviceShaderSMBuiltinsPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        shaderSMCount: uint32,
        shaderWarpsPerSM: uint32
}

state VkPhysicalDeviceShaderSMBuiltinsFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        shaderSMBuiltins: VkBool32
}

state VkDrmFormatModifierPropertiesEXT
{
        drmFormatModifier: uint64,
        drmFormatModifierPlaneCount: uint32,
        drmFormatModifierTilingFeatures: VkFormatFeatureFlags
}

state VkDrmFormatModifierPropertiesListEXT
{
        sType: VkStructureType,
        pNext: *void,
        drmFormatModifierCount: uint32,
        pDrmFormatModifierProperties: *VkDrmFormatModifierPropertiesEXT
}

state VkPhysicalDeviceImageDrmFormatModifierInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        drmFormatModifier: uint64,
        sharingMode: VkSharingMode,
        queueFamilyIndexCount: uint32,
        pQueueFamilyIndices: *uint32
}

state VkImageDrmFormatModifierListCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        drmFormatModifierCount: uint32,
        pDrmFormatModifiers: *uint64
}

state VkImageDrmFormatModifierExplicitCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        drmFormatModifier: uint64,
        drmFormatModifierPlaneCount: uint32,
        pPlaneLayouts: *VkSubresourceLayout
}

state VkImageDrmFormatModifierPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        drmFormatModifier: uint64
}

state VkDrmFormatModifierProperties2EXT
{
        drmFormatModifier: uint64,
        drmFormatModifierPlaneCount: uint32,
        drmFormatModifierTilingFeatures: VkFormatFeatureFlags2
}

state VkDrmFormatModifierPropertiesList2EXT
{
        sType: VkStructureType,
        pNext: *void,
        drmFormatModifierCount: uint32,
        pDrmFormatModifierProperties: *VkDrmFormatModifierProperties2EXT
}

state VkValidationCacheCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkValidationCacheCreateFlagsEXT,
        initialDataSize: uint,
        pInitialData: *void
}

state VkShaderModuleValidationCacheCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        validationCache: VkValidationCacheEXT
}

state VkShadingRatePaletteNV
{
        shadingRatePaletteEntryCount: uint32,
        pShadingRatePaletteEntries: *VkShadingRatePaletteEntryNV
}

state VkPipelineViewportShadingRateImageStateCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        shadingRateImageEnable: VkBool32,
        viewportCount: uint32,
        pShadingRatePalettes: *VkShadingRatePaletteNV
}

state VkPhysicalDeviceShadingRateImageFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        shadingRateImage: VkBool32,
        shadingRateCoarseSampleOrder: VkBool32
}

state VkPhysicalDeviceShadingRateImagePropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        shadingRateTexelSize: VkExtent2D,
        shadingRatePaletteSize: uint32,
        shadingRateMaxCoarseSamples: uint32
}

state VkCoarseSampleLocationNV
{
        pixelX: uint32,
        pixelY: uint32,
        sample: uint32
}

state VkCoarseSampleOrderCustomNV
{
        shadingRate: VkShadingRatePaletteEntryNV,
        sampleCount: uint32,
        sampleLocationCount: uint32,
        pSampleLocations: *VkCoarseSampleLocationNV
}

state VkPipelineViewportCoarseSampleOrderStateCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        sampleOrderType: VkCoarseSampleOrderTypeNV,
        customSampleOrderCount: uint32,
        pCustomSampleOrders: *VkCoarseSampleOrderCustomNV
}

state VkRayTracingShaderGroupCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        type: VkRayTracingShaderGroupTypeKHR,
        generalShader: uint32,
        closestHitShader: uint32,
        anyHitShader: uint32,
        intersectionShader: uint32
}

state VkRayTracingPipelineCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineCreateFlags,
        stageCount: uint32,
        pStages: *VkPipelineShaderStageCreateInfo,
        groupCount: uint32,
        pGroups: *VkRayTracingShaderGroupCreateInfoNV,
        maxRecursionDepth: uint32,
        layout: VkPipelineLayout,
        basePipelineHandle: VkPipeline,
        basePipelineIndex: int32
}

state VkGeometryTrianglesNV
{
        sType: VkStructureType,
        pNext: *void,
        vertexData: VkBuffer,
        vertexOffset: VkDeviceSize,
        vertexCount: uint32,
        vertexStride: VkDeviceSize,
        vertexFormat: VkFormat,
        indexData: VkBuffer,
        indexOffset: VkDeviceSize,
        indexCount: uint32,
        indexType: VkIndexType,
        transformData: VkBuffer,
        transformOffset: VkDeviceSize
}

state VkGeometryAABBNV
{
        sType: VkStructureType,
        pNext: *void,
        aabbData: VkBuffer,
        numAABBs: uint32,
        stride: uint32,
        offset: VkDeviceSize
}

state VkGeometryDataNV
{
        triangles: VkGeometryTrianglesNV,
        aabbs: VkGeometryAABBNV
}

state VkGeometryNV
{
        sType: VkStructureType,
        pNext: *void,
        geometryType: VkGeometryTypeKHR,
        geometry: VkGeometryDataNV,
        flags: VkGeometryFlagsKHR
}

state VkAccelerationStructureInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        type: VkAccelerationStructureTypeNV,
        flags: VkBuildAccelerationStructureFlagsNV,
        instanceCount: uint32,
        geometryCount: uint32,
        pGeometries: *VkGeometryNV
}

state VkAccelerationStructureCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        compactedSize: VkDeviceSize,
        info: VkAccelerationStructureInfoNV
}

state VkBindAccelerationStructureMemoryInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        accelerationStructure: VkAccelerationStructureNV,
        memory: VkDeviceMemory,
        memoryOffset: VkDeviceSize,
        deviceIndexCount: uint32,
        pDeviceIndices: *uint32
}

state VkWriteDescriptorSetAccelerationStructureNV
{
        sType: VkStructureType,
        pNext: *void,
        accelerationStructureCount: uint32,
        pAccelerationStructures: *VkAccelerationStructureNV
}

state VkAccelerationStructureMemoryRequirementsInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        type: VkAccelerationStructureMemoryRequirementsTypeNV,
        accelerationStructure: VkAccelerationStructureNV
}

state VkPhysicalDeviceRayTracingPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        shaderGroupHandleSize: uint32,
        maxRecursionDepth: uint32,
        maxShaderGroupStride: uint32,
        shaderGroupBaseAlignment: uint32,
        maxGeometryCount: uint64,
        maxInstanceCount: uint64,
        maxTriangleCount: uint64,
        maxDescriptorSetAccelerationStructures: uint32
}

state VkTransformMatrixKHR
{
        matrix: [3][4]:float
}

state VkAabbPositionsKHR
{
        minX: :float,
        minY: :float,
        minZ: :float,
        maxX: :float,
        maxY: :float,
        maxZ: :float
}

state VkAccelerationStructureInstanceKHR
{
        transform: VkTransformMatrixKHR,
        instanceCustomIndex: :bitfield,
        mask: :bitfield,
        instanceShaderBindingTableRecordOffset: :bitfield,
        flags: :bitfield,
        accelerationStructureReference: uint64
}

state VkPhysicalDeviceRepresentativeFragmentTestFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        representativeFragmentTest: VkBool32
}

state VkPipelineRepresentativeFragmentTestStateCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        representativeFragmentTestEnable: VkBool32
}

state VkPhysicalDeviceImageViewImageFormatInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        imageViewType: VkImageViewType
}

state VkFilterCubicImageViewImageFormatPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        filterCubic: VkBool32,
        filterCubicMinmax: VkBool32
}

state VkImportMemoryHostPointerInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        handleType: VkExternalMemoryHandleTypeFlagBits,
        pHostPointer: *void
}

state VkMemoryHostPointerPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        memoryTypeBits: uint32
}

state VkPhysicalDeviceExternalMemoryHostPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        minImportedHostPointerAlignment: VkDeviceSize
}

state VkPipelineCompilerControlCreateInfoAMD
{
        sType: VkStructureType,
        pNext: *void,
        compilerControlFlags: VkPipelineCompilerControlFlagsAMD
}

state VkPhysicalDeviceShaderCorePropertiesAMD
{
        sType: VkStructureType,
        pNext: *void,
        shaderEngineCount: uint32,
        shaderArraysPerEngineCount: uint32,
        computeUnitsPerShaderArray: uint32,
        simdPerComputeUnit: uint32,
        wavefrontsPerSimd: uint32,
        wavefrontSize: uint32,
        sgprsPerSimd: uint32,
        minSgprAllocation: uint32,
        maxSgprAllocation: uint32,
        sgprAllocationGranularity: uint32,
        vgprsPerSimd: uint32,
        minVgprAllocation: uint32,
        maxVgprAllocation: uint32,
        vgprAllocationGranularity: uint32
}

state VkDeviceMemoryOverallocationCreateInfoAMD
{
        sType: VkStructureType,
        pNext: *void,
        overallocationBehavior: VkMemoryOverallocationBehaviorAMD
}

state VkPhysicalDeviceVertexAttributeDivisorPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        maxVertexAttribDivisor: uint32
}

state VkPhysicalDeviceMeshShaderFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        taskShader: VkBool32,
        meshShader: VkBool32
}

state VkPhysicalDeviceMeshShaderPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        maxDrawMeshTasksCount: uint32,
        maxTaskWorkGroupInvocations: uint32,
        maxTaskWorkGroupSize: [3]uint32,
        maxTaskTotalMemorySize: uint32,
        maxTaskOutputCount: uint32,
        maxMeshWorkGroupInvocations: uint32,
        maxMeshWorkGroupSize: [3]uint32,
        maxMeshTotalMemorySize: uint32,
        maxMeshOutputVertices: uint32,
        maxMeshOutputPrimitives: uint32,
        maxMeshMultiviewViewCount: uint32,
        meshOutputPerVertexGranularity: uint32,
        meshOutputPerPrimitiveGranularity: uint32
}

state VkDrawMeshTasksIndirectCommandNV
{
        taskCount: uint32,
        firstTask: uint32
}

state VkPhysicalDeviceShaderImageFootprintFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        imageFootprint: VkBool32
}

state VkPipelineViewportExclusiveScissorStateCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        exclusiveScissorCount: uint32,
        pExclusiveScissors: *VkRect2D
}

state VkPhysicalDeviceExclusiveScissorFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        exclusiveScissor: VkBool32
}

state VkQueueFamilyCheckpointPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        checkpointExecutionStageMask: VkPipelineStageFlags
}

state VkCheckpointDataNV
{
        sType: VkStructureType,
        pNext: *void,
        stage: VkPipelineStageFlagBits,
        pCheckpointMarker: *void
}

state VkQueueFamilyCheckpointProperties2NV
{
        sType: VkStructureType,
        pNext: *void,
        checkpointExecutionStageMask: VkPipelineStageFlags2
}

state VkCheckpointData2NV
{
        sType: VkStructureType,
        pNext: *void,
        stage: VkPipelineStageFlags2,
        pCheckpointMarker: *void
}

state VkPhysicalDeviceShaderIntegerFunctions2FeaturesINTEL
{
        sType: VkStructureType,
        pNext: *void,
        shaderIntegerFunctions2: VkBool32
}

state VkPerformanceValueINTEL
{
        type: VkPerformanceValueTypeINTEL,
        data: VkPerformanceValueDataINTEL
}

state VkInitializePerformanceApiInfoINTEL
{
        sType: VkStructureType,
        pNext: *void,
        pUserData: *void
}

state VkQueryPoolPerformanceQueryCreateInfoINTEL
{
        sType: VkStructureType,
        pNext: *void,
        performanceCountersSampling: VkQueryPoolSamplingModeINTEL
}

state VkPerformanceMarkerInfoINTEL
{
        sType: VkStructureType,
        pNext: *void,
        marker: uint64
}

state VkPerformanceStreamMarkerInfoINTEL
{
        sType: VkStructureType,
        pNext: *void,
        marker: uint32
}

state VkPerformanceOverrideInfoINTEL
{
        sType: VkStructureType,
        pNext: *void,
        type: VkPerformanceOverrideTypeINTEL,
        enable: VkBool32,
        parameter: uint64
}

state VkPerformanceConfigurationAcquireInfoINTEL
{
        sType: VkStructureType,
        pNext: *void,
        type: VkPerformanceConfigurationTypeINTEL
}

state VkPhysicalDevicePCIBusInfoPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        pciDomain: uint32,
        pciBus: uint32,
        pciDevice: uint32,
        pciFunction: uint32
}

state VkDisplayNativeHdrSurfaceCapabilitiesAMD
{
        sType: VkStructureType,
        pNext: *void,
        localDimmingSupport: VkBool32
}

state VkSwapchainDisplayNativeHdrCreateInfoAMD
{
        sType: VkStructureType,
        pNext: *void,
        localDimmingEnable: VkBool32
}

state VkPhysicalDeviceFragmentDensityMapFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        fragmentDensityMap: VkBool32,
        fragmentDensityMapDynamic: VkBool32,
        fragmentDensityMapNonSubsampledImages: VkBool32
}

state VkPhysicalDeviceFragmentDensityMapPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        minFragmentDensityTexelSize: VkExtent2D,
        maxFragmentDensityTexelSize: VkExtent2D,
        fragmentDensityInvocations: VkBool32
}

state VkRenderPassFragmentDensityMapCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        fragmentDensityMapAttachment: VkAttachmentReference
}

state VkRenderingFragmentDensityMapAttachmentInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        imageView: VkImageView,
        imageLayout: VkImageLayout
}

state VkPhysicalDeviceShaderCoreProperties2AMD
{
        sType: VkStructureType,
        pNext: *void,
        shaderCoreFeatures: VkShaderCorePropertiesFlagsAMD,
        activeComputeUnitCount: uint32
}

state VkPhysicalDeviceCoherentMemoryFeaturesAMD
{
        sType: VkStructureType,
        pNext: *void,
        deviceCoherentMemory: VkBool32
}

state VkPhysicalDeviceShaderImageAtomicInt64FeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderImageInt64Atomics: VkBool32,
        sparseImageInt64Atomics: VkBool32
}

state VkPhysicalDeviceMemoryBudgetPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        heapBudget: [16]VkDeviceSize,
        heapUsage: [16]VkDeviceSize
}

state VkPhysicalDeviceMemoryPriorityFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        memoryPriority: VkBool32
}

state VkMemoryPriorityAllocateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        priority: :float
}

state VkPhysicalDeviceDedicatedAllocationImageAliasingFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        dedicatedAllocationImageAliasing: VkBool32
}

state VkPhysicalDeviceBufferDeviceAddressFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        bufferDeviceAddress: VkBool32,
        bufferDeviceAddressCaptureReplay: VkBool32,
        bufferDeviceAddressMultiDevice: VkBool32
}

state VkBufferDeviceAddressCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        deviceAddress: VkDeviceAddress
}

state VkValidationFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        enabledValidationFeatureCount: uint32,
        pEnabledValidationFeatures: *VkValidationFeatureEnableEXT,
        disabledValidationFeatureCount: uint32,
        pDisabledValidationFeatures: *VkValidationFeatureDisableEXT
}

state VkCooperativeMatrixPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        MSize: uint32,
        NSize: uint32,
        KSize: uint32,
        AType: VkComponentTypeNV,
        BType: VkComponentTypeNV,
        CType: VkComponentTypeNV,
        DType: VkComponentTypeNV,
        scope: VkScopeNV
}

state VkPhysicalDeviceCooperativeMatrixFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        cooperativeMatrix: VkBool32,
        cooperativeMatrixRobustBufferAccess: VkBool32
}

state VkPhysicalDeviceCooperativeMatrixPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        cooperativeMatrixSupportedStages: VkShaderStageFlags
}

state VkPhysicalDeviceCoverageReductionModeFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        coverageReductionMode: VkBool32
}

state VkPipelineCoverageReductionStateCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineCoverageReductionStateCreateFlagsNV,
        coverageReductionMode: VkCoverageReductionModeNV
}

state VkFramebufferMixedSamplesCombinationNV
{
        sType: VkStructureType,
        pNext: *void,
        coverageReductionMode: VkCoverageReductionModeNV,
        rasterizationSamples: VkSampleCountFlagBits,
        depthStencilSamples: VkSampleCountFlags,
        colorSamples: VkSampleCountFlags
}

state VkPhysicalDeviceFragmentShaderInterlockFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        fragmentShaderSampleInterlock: VkBool32,
        fragmentShaderPixelInterlock: VkBool32,
        fragmentShaderShadingRateInterlock: VkBool32
}

state VkPhysicalDeviceYcbcrImageArraysFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        ycbcrImageArrays: VkBool32
}

state VkPhysicalDeviceProvokingVertexFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        provokingVertexLast: VkBool32,
        transformFeedbackPreservesProvokingVertex: VkBool32
}

state VkPhysicalDeviceProvokingVertexPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        provokingVertexModePerPipeline: VkBool32,
        transformFeedbackPreservesTriangleFanProvokingVertex: VkBool32
}

state VkPipelineRasterizationProvokingVertexStateCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        provokingVertexMode: VkProvokingVertexModeEXT
}

state VkHeadlessSurfaceCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkHeadlessSurfaceCreateFlagsEXT
}

state VkPhysicalDeviceShaderAtomicFloatFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderBufferFloat32Atomics: VkBool32,
        shaderBufferFloat32AtomicAdd: VkBool32,
        shaderBufferFloat64Atomics: VkBool32,
        shaderBufferFloat64AtomicAdd: VkBool32,
        shaderSharedFloat32Atomics: VkBool32,
        shaderSharedFloat32AtomicAdd: VkBool32,
        shaderSharedFloat64Atomics: VkBool32,
        shaderSharedFloat64AtomicAdd: VkBool32,
        shaderImageFloat32Atomics: VkBool32,
        shaderImageFloat32AtomicAdd: VkBool32,
        sparseImageFloat32Atomics: VkBool32,
        sparseImageFloat32AtomicAdd: VkBool32
}

state VkPhysicalDeviceExtendedDynamicStateFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        extendedDynamicState: VkBool32
}

state VkPhysicalDeviceMapMemoryPlacedFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        memoryMapPlaced: VkBool32,
        memoryMapRangePlaced: VkBool32,
        memoryUnmapReserve: VkBool32
}

state VkPhysicalDeviceMapMemoryPlacedPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        minPlacedMemoryMapAlignment: VkDeviceSize
}

state VkMemoryMapPlacedInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        pPlacedAddress: *void
}

state VkPhysicalDeviceShaderAtomicFloat2FeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderBufferFloat16Atomics: VkBool32,
        shaderBufferFloat16AtomicAdd: VkBool32,
        shaderBufferFloat16AtomicMinMax: VkBool32,
        shaderBufferFloat32AtomicMinMax: VkBool32,
        shaderBufferFloat64AtomicMinMax: VkBool32,
        shaderSharedFloat16Atomics: VkBool32,
        shaderSharedFloat16AtomicAdd: VkBool32,
        shaderSharedFloat16AtomicMinMax: VkBool32,
        shaderSharedFloat32AtomicMinMax: VkBool32,
        shaderSharedFloat64AtomicMinMax: VkBool32,
        shaderImageFloat32AtomicMinMax: VkBool32,
        sparseImageFloat32AtomicMinMax: VkBool32
}

state VkSurfacePresentModeEXT
{
        sType: VkStructureType,
        pNext: *void,
        presentMode: VkPresentModeKHR
}

state VkSurfacePresentScalingCapabilitiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        supportedPresentScaling: VkPresentScalingFlagsEXT,
        supportedPresentGravityX: VkPresentGravityFlagsEXT,
        supportedPresentGravityY: VkPresentGravityFlagsEXT,
        minScaledImageExtent: VkExtent2D,
        maxScaledImageExtent: VkExtent2D
}

state VkSurfacePresentModeCompatibilityEXT
{
        sType: VkStructureType,
        pNext: *void,
        presentModeCount: uint32,
        pPresentModes: *VkPresentModeKHR
}

state VkPhysicalDeviceSwapchainMaintenance1FeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        swapchainMaintenance1: VkBool32
}

state VkSwapchainPresentFenceInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        swapchainCount: uint32,
        pFences: *VkFence
}

state VkSwapchainPresentModesCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        presentModeCount: uint32,
        pPresentModes: *VkPresentModeKHR
}

state VkSwapchainPresentModeInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        swapchainCount: uint32,
        pPresentModes: *VkPresentModeKHR
}

state VkSwapchainPresentScalingCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        scalingBehavior: VkPresentScalingFlagsEXT,
        presentGravityX: VkPresentGravityFlagsEXT,
        presentGravityY: VkPresentGravityFlagsEXT
}

state VkReleaseSwapchainImagesInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        swapchain: VkSwapchainKHR,
        imageIndexCount: uint32,
        pImageIndices: *uint32
}

state VkPhysicalDeviceDeviceGeneratedCommandsPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        maxGraphicsShaderGroupCount: uint32,
        maxIndirectSequenceCount: uint32,
        maxIndirectCommandsTokenCount: uint32,
        maxIndirectCommandsStreamCount: uint32,
        maxIndirectCommandsTokenOffset: uint32,
        maxIndirectCommandsStreamStride: uint32,
        minSequencesCountBufferOffsetAlignment: uint32,
        minSequencesIndexBufferOffsetAlignment: uint32,
        minIndirectCommandsBufferOffsetAlignment: uint32
}

state VkPhysicalDeviceDeviceGeneratedCommandsFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        deviceGeneratedCommands: VkBool32
}

state VkGraphicsShaderGroupCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        stageCount: uint32,
        pStages: *VkPipelineShaderStageCreateInfo,
        pVertexInputState: *VkPipelineVertexInputStateCreateInfo,
        pTessellationState: *VkPipelineTessellationStateCreateInfo
}

state VkGraphicsPipelineShaderGroupsCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        groupCount: uint32,
        pGroups: *VkGraphicsShaderGroupCreateInfoNV,
        pipelineCount: uint32,
        pPipelines: *VkPipeline
}

state VkBindShaderGroupIndirectCommandNV
{
        groupIndex: uint32
}

state VkBindIndexBufferIndirectCommandNV
{
        bufferAddress: VkDeviceAddress,
        size: uint32,
        indexType: VkIndexType
}

state VkBindVertexBufferIndirectCommandNV
{
        bufferAddress: VkDeviceAddress,
        size: uint32,
        stride: uint32
}

state VkSetStateFlagsIndirectCommandNV
{
        data: uint32
}

state VkIndirectCommandsStreamNV
{
        buffer: VkBuffer,
        offset: VkDeviceSize
}

state VkIndirectCommandsLayoutTokenNV
{
        sType: VkStructureType,
        pNext: *void,
        tokenType: VkIndirectCommandsTokenTypeNV,
        stream: uint32,
        offset: uint32,
        vertexBindingUnit: uint32,
        vertexDynamicStride: VkBool32,
        pushconstantPipelineLayout: VkPipelineLayout,
        pushconstantShaderStageFlags: VkShaderStageFlags,
        pushconstantOffset: uint32,
        pushconstantSize: uint32,
        indirectStateFlags: VkIndirectStateFlagsNV,
        indexTypeCount: uint32,
        pIndexTypes: *VkIndexType,
        pIndexTypeValues: *uint32
}

state VkIndirectCommandsLayoutCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkIndirectCommandsLayoutUsageFlagsNV,
        pipelineBindPoint: VkPipelineBindPoint,
        tokenCount: uint32,
        pTokens: *VkIndirectCommandsLayoutTokenNV,
        streamCount: uint32,
        pStreamStrides: *uint32
}

state VkGeneratedCommandsInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        pipelineBindPoint: VkPipelineBindPoint,
        pipeline: VkPipeline,
        indirectCommandsLayout: VkIndirectCommandsLayoutNV,
        streamCount: uint32,
        pStreams: *VkIndirectCommandsStreamNV,
        sequencesCount: uint32,
        preprocessBuffer: VkBuffer,
        preprocessOffset: VkDeviceSize,
        preprocessSize: VkDeviceSize,
        sequencesCountBuffer: VkBuffer,
        sequencesCountOffset: VkDeviceSize,
        sequencesIndexBuffer: VkBuffer,
        sequencesIndexOffset: VkDeviceSize
}

state VkGeneratedCommandsMemoryRequirementsInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        pipelineBindPoint: VkPipelineBindPoint,
        pipeline: VkPipeline,
        indirectCommandsLayout: VkIndirectCommandsLayoutNV,
        maxSequencesCount: uint32
}

state VkPhysicalDeviceInheritedViewportScissorFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        inheritedViewportScissor2D: VkBool32
}

state VkCommandBufferInheritanceViewportScissorInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        viewportScissor2D: VkBool32,
        viewportDepthCount: uint32,
        pViewportDepths: *VkViewport
}

state VkPhysicalDeviceTexelBufferAlignmentFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        texelBufferAlignment: VkBool32
}

state VkRenderPassTransformBeginInfoQCOM
{
        sType: VkStructureType,
        pNext: *void,
        transform: VkSurfaceTransformFlagBitsKHR
}

state VkCommandBufferInheritanceRenderPassTransformInfoQCOM
{
        sType: VkStructureType,
        pNext: *void,
        transform: VkSurfaceTransformFlagBitsKHR,
        renderArea: VkRect2D
}

state VkPhysicalDeviceDepthBiasControlFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        depthBiasControl: VkBool32,
        leastRepresentableValueForceUnormRepresentation: VkBool32,
        floatRepresentation: VkBool32,
        depthBiasExact: VkBool32
}

state VkDepthBiasInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        depthBiasConstantFactor: :float,
        depthBiasClamp: :float,
        depthBiasSlopeFactor: :float
}

state VkDepthBiasRepresentationInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        depthBiasRepresentation: VkDepthBiasRepresentationEXT,
        depthBiasExact: VkBool32
}

state VkPhysicalDeviceDeviceMemoryReportFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        deviceMemoryReport: VkBool32
}

state VkDeviceMemoryReportCallbackDataEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkDeviceMemoryReportFlagsEXT,
        type: VkDeviceMemoryReportEventTypeEXT,
        memoryObjectId: uint64,
        size: VkDeviceSize,
        objectType: VkObjectType,
        objectHandle: uint64,
        heapIndex: uint32
}

state VkDeviceDeviceMemoryReportCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkDeviceMemoryReportFlagsEXT,
        pfnUserCallback: PFN_vkDeviceMemoryReportCallbackEXT,
        pUserData: *void
}

state VkPhysicalDeviceRobustness2FeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        robustBufferAccess2: VkBool32,
        robustImageAccess2: VkBool32,
        nullDescriptor: VkBool32
}

state VkPhysicalDeviceRobustness2PropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        robustStorageBufferAccessSizeAlignment: VkDeviceSize,
        robustUniformBufferAccessSizeAlignment: VkDeviceSize
}

state VkSamplerCustomBorderColorCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        customBorderColor: VkClearColorValue,
        format: VkFormat
}

state VkPhysicalDeviceCustomBorderColorPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        maxCustomBorderColorSamplers: uint32
}

state VkPhysicalDeviceCustomBorderColorFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        customBorderColors: VkBool32,
        customBorderColorWithoutFormat: VkBool32
}

state VkPhysicalDevicePresentBarrierFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        presentBarrier: VkBool32
}

state VkSurfaceCapabilitiesPresentBarrierNV
{
        sType: VkStructureType,
        pNext: *void,
        presentBarrierSupported: VkBool32
}

state VkSwapchainPresentBarrierCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        presentBarrierEnable: VkBool32
}

state VkPhysicalDeviceDiagnosticsConfigFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        diagnosticsConfig: VkBool32
}

state VkDeviceDiagnosticsConfigCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkDeviceDiagnosticsConfigFlagsNV
}

state VkCudaModuleCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        dataSize: uint,
        pData: *void
}

state VkCudaFunctionCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        module: VkCudaModuleNV,
        pName: *byte
}

state VkCudaLaunchInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        function: VkCudaFunctionNV,
        gridDimX: uint32,
        gridDimY: uint32,
        gridDimZ: uint32,
        blockDimX: uint32,
        blockDimY: uint32,
        blockDimZ: uint32,
        sharedMemBytes: uint32,
        paramCount: uint,
        pParams: **void,
        extraCount: uint,
        pExtras: **void
}

state VkPhysicalDeviceCudaKernelLaunchFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        cudaKernelLaunchFeatures: VkBool32
}

state VkPhysicalDeviceCudaKernelLaunchPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        computeCapabilityMinor: uint32,
        computeCapabilityMajor: uint32
}

state VkQueryLowLatencySupportNV
{
        sType: VkStructureType,
        pNext: *void,
        pQueriedLowLatencyData: *void
}

state VkPhysicalDeviceDescriptorBufferPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        combinedImageSamplerDescriptorSingleArray: VkBool32,
        bufferlessPushDescriptors: VkBool32,
        allowSamplerImageViewPostSubmitCreation: VkBool32,
        descriptorBufferOffsetAlignment: VkDeviceSize,
        maxDescriptorBufferBindings: uint32,
        maxResourceDescriptorBufferBindings: uint32,
        maxSamplerDescriptorBufferBindings: uint32,
        maxEmbeddedImmutableSamplerBindings: uint32,
        maxEmbeddedImmutableSamplers: uint32,
        bufferCaptureReplayDescriptorDataSize: uint,
        imageCaptureReplayDescriptorDataSize: uint,
        imageViewCaptureReplayDescriptorDataSize: uint,
        samplerCaptureReplayDescriptorDataSize: uint,
        accelerationStructureCaptureReplayDescriptorDataSize: uint,
        samplerDescriptorSize: uint,
        combinedImageSamplerDescriptorSize: uint,
        sampledImageDescriptorSize: uint,
        storageImageDescriptorSize: uint,
        uniformTexelBufferDescriptorSize: uint,
        robustUniformTexelBufferDescriptorSize: uint,
        storageTexelBufferDescriptorSize: uint,
        robustStorageTexelBufferDescriptorSize: uint,
        uniformBufferDescriptorSize: uint,
        robustUniformBufferDescriptorSize: uint,
        storageBufferDescriptorSize: uint,
        robustStorageBufferDescriptorSize: uint,
        inputAttachmentDescriptorSize: uint,
        accelerationStructureDescriptorSize: uint,
        maxSamplerDescriptorBufferRange: VkDeviceSize,
        maxResourceDescriptorBufferRange: VkDeviceSize,
        samplerDescriptorBufferAddressSpaceSize: VkDeviceSize,
        resourceDescriptorBufferAddressSpaceSize: VkDeviceSize,
        descriptorBufferAddressSpaceSize: VkDeviceSize
}

state VkPhysicalDeviceDescriptorBufferDensityMapPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        combinedImageSamplerDensityMapDescriptorSize: uint
}

state VkPhysicalDeviceDescriptorBufferFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        descriptorBuffer: VkBool32,
        descriptorBufferCaptureReplay: VkBool32,
        descriptorBufferImageLayoutIgnored: VkBool32,
        descriptorBufferPushDescriptors: VkBool32
}

state VkDescriptorAddressInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        address: VkDeviceAddress,
        range: VkDeviceSize,
        format: VkFormat
}

state VkDescriptorBufferBindingInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        address: VkDeviceAddress,
        usage: VkBufferUsageFlags
}

state VkDescriptorBufferBindingPushDescriptorBufferHandleEXT
{
        sType: VkStructureType,
        pNext: *void,
        buffer: VkBuffer
}

state VkDescriptorGetInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        type: VkDescriptorType,
        data: VkDescriptorDataEXT
}

state VkBufferCaptureDescriptorDataInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        buffer: VkBuffer
}

state VkImageCaptureDescriptorDataInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        image: VkImage
}

state VkImageViewCaptureDescriptorDataInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        imageView: VkImageView
}

state VkSamplerCaptureDescriptorDataInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        sampler: VkSampler
}

state VkOpaqueCaptureDescriptorDataCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        opaqueCaptureDescriptorData: *void
}

state VkAccelerationStructureCaptureDescriptorDataInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        accelerationStructure: VkAccelerationStructureKHR,
        accelerationStructureNV: VkAccelerationStructureNV
}

state VkPhysicalDeviceGraphicsPipelineLibraryFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        graphicsPipelineLibrary: VkBool32
}

state VkPhysicalDeviceGraphicsPipelineLibraryPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        graphicsPipelineLibraryFastLinking: VkBool32,
        graphicsPipelineLibraryIndependentInterpolationDecoration: VkBool32
}

state VkGraphicsPipelineLibraryCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkGraphicsPipelineLibraryFlagsEXT
}

state VkPhysicalDeviceShaderEarlyAndLateFragmentTestsFeaturesAMD
{
        sType: VkStructureType,
        pNext: *void,
        shaderEarlyAndLateFragmentTests: VkBool32
}

state VkPhysicalDeviceFragmentShadingRateEnumsFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        fragmentShadingRateEnums: VkBool32,
        supersampleFragmentShadingRates: VkBool32,
        noInvocationFragmentShadingRates: VkBool32
}

state VkPhysicalDeviceFragmentShadingRateEnumsPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        maxFragmentShadingRateInvocationCount: VkSampleCountFlagBits
}

state VkPipelineFragmentShadingRateEnumStateCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        shadingRateType: VkFragmentShadingRateTypeNV,
        shadingRate: VkFragmentShadingRateNV,
        combinerOps: [2]VkFragmentShadingRateCombinerOpKHR
}

state VkAccelerationStructureGeometryMotionTrianglesDataNV
{
        sType: VkStructureType,
        pNext: *void,
        vertexData: VkDeviceOrHostAddressConstKHR
}

state VkAccelerationStructureMotionInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        maxInstances: uint32,
        flags: VkAccelerationStructureMotionInfoFlagsNV
}

state VkAccelerationStructureMatrixMotionInstanceNV
{
        transformT0: VkTransformMatrixKHR,
        transformT1: VkTransformMatrixKHR,
        instanceCustomIndex: :bitfield,
        mask: :bitfield,
        instanceShaderBindingTableRecordOffset: :bitfield,
        flags: :bitfield,
        accelerationStructureReference: uint64
}

state VkSRTDataNV
{
        sx: :float,
        a: :float,
        b: :float,
        pvx: :float,
        sy: :float,
        c: :float,
        pvy: :float,
        sz: :float,
        pvz: :float,
        qx: :float,
        qy: :float,
        qz: :float,
        qw: :float,
        tx: :float,
        ty: :float,
        tz: :float
}

state VkAccelerationStructureSRTMotionInstanceNV
{
        transformT0: VkSRTDataNV,
        transformT1: VkSRTDataNV,
        instanceCustomIndex: :bitfield,
        mask: :bitfield,
        instanceShaderBindingTableRecordOffset: :bitfield,
        flags: :bitfield,
        accelerationStructureReference: uint64
}

state VkAccelerationStructureMotionInstanceNV
{
        type: VkAccelerationStructureMotionInstanceTypeNV,
        flags: VkAccelerationStructureMotionInstanceFlagsNV,
        data: VkAccelerationStructureMotionInstanceDataNV
}

state VkPhysicalDeviceRayTracingMotionBlurFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        rayTracingMotionBlur: VkBool32,
        rayTracingMotionBlurPipelineTraceRaysIndirect: VkBool32
}

state VkPhysicalDeviceYcbcr2Plane444FormatsFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        ycbcr2plane444Formats: VkBool32
}

state VkPhysicalDeviceFragmentDensityMap2FeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        fragmentDensityMapDeferred: VkBool32
}

state VkPhysicalDeviceFragmentDensityMap2PropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        subsampledLoads: VkBool32,
        subsampledCoarseReconstructionEarlyAccess: VkBool32,
        maxSubsampledArrayLayers: uint32,
        maxDescriptorSetSubsampledSamplers: uint32
}

state VkCopyCommandTransformInfoQCOM
{
        sType: VkStructureType,
        pNext: *void,
        transform: VkSurfaceTransformFlagBitsKHR
}

state VkPhysicalDeviceImageCompressionControlFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        imageCompressionControl: VkBool32
}

state VkImageCompressionControlEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkImageCompressionFlagsEXT,
        compressionControlPlaneCount: uint32,
        pFixedRateFlags: *VkImageCompressionFixedRateFlagsEXT
}

state VkImageCompressionPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        imageCompressionFlags: VkImageCompressionFlagsEXT,
        imageCompressionFixedRateFlags: VkImageCompressionFixedRateFlagsEXT
}

state VkPhysicalDeviceAttachmentFeedbackLoopLayoutFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        attachmentFeedbackLoopLayout: VkBool32
}

state VkPhysicalDevice4444FormatsFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        formatA4R4G4B4: VkBool32,
        formatA4B4G4R4: VkBool32
}

state VkPhysicalDeviceFaultFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        deviceFault: VkBool32,
        deviceFaultVendorBinary: VkBool32
}

state VkDeviceFaultCountsEXT
{
        sType: VkStructureType,
        pNext: *void,
        addressInfoCount: uint32,
        vendorInfoCount: uint32,
        vendorBinarySize: VkDeviceSize
}

state VkDeviceFaultAddressInfoEXT
{
        addressType: VkDeviceFaultAddressTypeEXT,
        reportedAddress: VkDeviceAddress,
        addressPrecision: VkDeviceSize
}

state VkDeviceFaultVendorInfoEXT
{
        description: [256]byte,
        vendorFaultCode: uint64,
        vendorFaultData: uint64
}

state VkDeviceFaultInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        description: [256]byte,
        pAddressInfos: *VkDeviceFaultAddressInfoEXT,
        pVendorInfos: *VkDeviceFaultVendorInfoEXT,
        pVendorBinaryData: *void
}

state VkDeviceFaultVendorBinaryHeaderVersionOneEXT
{
        headerSize: uint32,
        headerVersion: VkDeviceFaultVendorBinaryHeaderVersionEXT,
        vendorID: uint32,
        deviceID: uint32,
        driverVersion: uint32,
        pipelineCacheUUID: [16]uint8_t,
        applicationNameOffset: uint32,
        applicationVersion: uint32,
        engineNameOffset: uint32,
        engineVersion: uint32,
        apiVersion: uint32
}

state VkPhysicalDeviceRasterizationOrderAttachmentAccessFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        rasterizationOrderColorAttachmentAccess: VkBool32,
        rasterizationOrderDepthAttachmentAccess: VkBool32,
        rasterizationOrderStencilAttachmentAccess: VkBool32
}

state VkPhysicalDeviceRGBA10X6FormatsFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        formatRgba10x6WithoutYCbCrSampler: VkBool32
}

state VkPhysicalDeviceMutableDescriptorTypeFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        mutableDescriptorType: VkBool32
}

state VkMutableDescriptorTypeListEXT
{
        descriptorTypeCount: uint32,
        pDescriptorTypes: *VkDescriptorType
}

state VkMutableDescriptorTypeCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        mutableDescriptorTypeListCount: uint32,
        pMutableDescriptorTypeLists: *VkMutableDescriptorTypeListEXT
}

state VkPhysicalDeviceVertexInputDynamicStateFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        vertexInputDynamicState: VkBool32
}

state VkVertexInputBindingDescription2EXT
{
        sType: VkStructureType,
        pNext: *void,
        binding: uint32,
        stride: uint32,
        inputRate: VkVertexInputRate,
        divisor: uint32
}

state VkVertexInputAttributeDescription2EXT
{
        sType: VkStructureType,
        pNext: *void,
        location: uint32,
        binding: uint32,
        format: VkFormat,
        offset: uint32
}

state VkPhysicalDeviceDrmPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        hasPrimary: VkBool32,
        hasRender: VkBool32,
        primaryMajor: int64_t,
        primaryMinor: int64_t,
        renderMajor: int64_t,
        renderMinor: int64_t
}

state VkPhysicalDeviceAddressBindingReportFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        reportAddressBinding: VkBool32
}

state VkDeviceAddressBindingCallbackDataEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkDeviceAddressBindingFlagsEXT,
        baseAddress: VkDeviceAddress,
        size: VkDeviceSize,
        bindingType: VkDeviceAddressBindingTypeEXT
}

state VkPhysicalDeviceDepthClipControlFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        depthClipControl: VkBool32
}

state VkPipelineViewportDepthClipControlCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        negativeOneToOne: VkBool32
}

state VkPhysicalDevicePrimitiveTopologyListRestartFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        primitiveTopologyListRestart: VkBool32,
        primitiveTopologyPatchListRestart: VkBool32
}

state VkPhysicalDevicePresentModeFifoLatestReadyFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        presentModeFifoLatestReady: VkBool32
}

state VkSubpassShadingPipelineCreateInfoHUAWEI
{
        sType: VkStructureType,
        pNext: *void,
        renderPass: VkRenderPass,
        subpass: uint32
}

state VkPhysicalDeviceSubpassShadingFeaturesHUAWEI
{
        sType: VkStructureType,
        pNext: *void,
        subpassShading: VkBool32
}

state VkPhysicalDeviceSubpassShadingPropertiesHUAWEI
{
        sType: VkStructureType,
        pNext: *void,
        maxSubpassShadingWorkgroupSizeAspectRatio: uint32
}

state VkPhysicalDeviceInvocationMaskFeaturesHUAWEI
{
        sType: VkStructureType,
        pNext: *void,
        invocationMask: VkBool32
}

state VkMemoryGetRemoteAddressInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        memory: VkDeviceMemory,
        handleType: VkExternalMemoryHandleTypeFlagBits
}

state VkPhysicalDeviceExternalMemoryRDMAFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        externalMemoryRDMA: VkBool32
}

state VkPipelinePropertiesIdentifierEXT
{
        sType: VkStructureType,
        pNext: *void,
        pipelineIdentifier: [16]uint8_t
}

state VkPhysicalDevicePipelinePropertiesFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        pipelinePropertiesIdentifier: VkBool32
}

state VkPhysicalDeviceFrameBoundaryFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        frameBoundary: VkBool32
}

state VkFrameBoundaryEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkFrameBoundaryFlagsEXT,
        frameID: uint64,
        imageCount: uint32,
        pImages: *VkImage,
        bufferCount: uint32,
        pBuffers: *VkBuffer,
        tagName: uint64,
        tagSize: uint,
        pTag: *void
}

state VkPhysicalDeviceMultisampledRenderToSingleSampledFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        multisampledRenderToSingleSampled: VkBool32
}

state VkSubpassResolvePerformanceQueryEXT
{
        sType: VkStructureType,
        pNext: *void,
        optimal: VkBool32
}

state VkMultisampledRenderToSingleSampledInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        multisampledRenderToSingleSampledEnable: VkBool32,
        rasterizationSamples: VkSampleCountFlagBits
}

state VkPhysicalDeviceExtendedDynamicState2FeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        extendedDynamicState2: VkBool32,
        extendedDynamicState2LogicOp: VkBool32,
        extendedDynamicState2PatchControlPoints: VkBool32
}

state VkPhysicalDeviceColorWriteEnableFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        colorWriteEnable: VkBool32
}

state VkPipelineColorWriteCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        attachmentCount: uint32,
        pColorWriteEnables: *VkBool32
}

state VkPhysicalDevicePrimitivesGeneratedQueryFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        primitivesGeneratedQuery: VkBool32,
        primitivesGeneratedQueryWithRasterizerDiscard: VkBool32,
        primitivesGeneratedQueryWithNonZeroStreams: VkBool32
}

state VkPhysicalDeviceImageViewMinLodFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        minLod: VkBool32
}

state VkImageViewMinLodCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        minLod: :float
}

state VkPhysicalDeviceMultiDrawFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        multiDraw: VkBool32
}

state VkPhysicalDeviceMultiDrawPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        maxMultiDrawCount: uint32
}

state VkMultiDrawInfoEXT
{
        firstVertex: uint32,
        vertexCount: uint32
}

state VkMultiDrawIndexedInfoEXT
{
        firstIndex: uint32,
        indexCount: uint32,
        vertexOffset: int32
}

state VkPhysicalDeviceImage2DViewOf3DFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        image2DViewOf3D: VkBool32,
        sampler2DViewOf3D: VkBool32
}

state VkPhysicalDeviceShaderTileImageFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderTileImageColorReadAccess: VkBool32,
        shaderTileImageDepthReadAccess: VkBool32,
        shaderTileImageStencilReadAccess: VkBool32
}

state VkPhysicalDeviceShaderTileImagePropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderTileImageCoherentReadAccelerated: VkBool32,
        shaderTileImageReadSampleFromPixelRateInvocation: VkBool32,
        shaderTileImageReadFromHelperInvocation: VkBool32
}

state VkMicromapUsageEXT
{
        count: uint32,
        subdivisionLevel: uint32,
        format: uint32
}

state VkMicromapBuildInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        type: VkMicromapTypeEXT,
        flags: VkBuildMicromapFlagsEXT,
        mode: VkBuildMicromapModeEXT,
        dstMicromap: VkMicromapEXT,
        usageCountsCount: uint32,
        pUsageCounts: *VkMicromapUsageEXT,
        ppUsageCounts: **VkMicromapUsageEXT,
        data: VkDeviceOrHostAddressConstKHR,
        scratchData: VkDeviceOrHostAddressKHR,
        triangleArray: VkDeviceOrHostAddressConstKHR,
        triangleArrayStride: VkDeviceSize
}

state VkMicromapCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        createFlags: VkMicromapCreateFlagsEXT,
        buffer: VkBuffer,
        offset: VkDeviceSize,
        size: VkDeviceSize,
        type: VkMicromapTypeEXT,
        deviceAddress: VkDeviceAddress
}

state VkPhysicalDeviceOpacityMicromapFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        micromap: VkBool32,
        micromapCaptureReplay: VkBool32,
        micromapHostCommands: VkBool32
}

state VkPhysicalDeviceOpacityMicromapPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        maxOpacity2StateSubdivisionLevel: uint32,
        maxOpacity4StateSubdivisionLevel: uint32
}

state VkMicromapVersionInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        pVersionData: *uint8_t
}

state VkCopyMicromapToMemoryInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        src: VkMicromapEXT,
        dst: VkDeviceOrHostAddressKHR,
        mode: VkCopyMicromapModeEXT
}

state VkCopyMemoryToMicromapInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        src: VkDeviceOrHostAddressConstKHR,
        dst: VkMicromapEXT,
        mode: VkCopyMicromapModeEXT
}

state VkCopyMicromapInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        src: VkMicromapEXT,
        dst: VkMicromapEXT,
        mode: VkCopyMicromapModeEXT
}

state VkMicromapBuildSizesInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        micromapSize: VkDeviceSize,
        buildScratchSize: VkDeviceSize,
        discardable: VkBool32
}

state VkAccelerationStructureTrianglesOpacityMicromapEXT
{
        sType: VkStructureType,
        pNext: *void,
        indexType: VkIndexType,
        indexBuffer: VkDeviceOrHostAddressConstKHR,
        indexStride: VkDeviceSize,
        baseTriangle: uint32,
        usageCountsCount: uint32,
        pUsageCounts: *VkMicromapUsageEXT,
        ppUsageCounts: **VkMicromapUsageEXT,
        micromap: VkMicromapEXT
}

state VkMicromapTriangleEXT
{
        dataOffset: uint32,
        subdivisionLevel: uint16_t,
        format: uint16_t
}

state VkPhysicalDeviceClusterCullingShaderFeaturesHUAWEI
{
        sType: VkStructureType,
        pNext: *void,
        clustercullingShader: VkBool32,
        multiviewClusterCullingShader: VkBool32
}

state VkPhysicalDeviceClusterCullingShaderPropertiesHUAWEI
{
        sType: VkStructureType,
        pNext: *void,
        maxWorkGroupCount: [3]uint32,
        maxWorkGroupSize: [3]uint32,
        maxOutputClusterCount: uint32,
        indirectBufferOffsetAlignment: VkDeviceSize
}

state VkPhysicalDeviceClusterCullingShaderVrsFeaturesHUAWEI
{
        sType: VkStructureType,
        pNext: *void,
        clusterShadingRate: VkBool32
}

state VkPhysicalDeviceBorderColorSwizzleFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        borderColorSwizzle: VkBool32,
        borderColorSwizzleFromImage: VkBool32
}

state VkSamplerBorderColorComponentMappingCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        components: VkComponentMapping,
        srgb: VkBool32
}

state VkPhysicalDevicePageableDeviceLocalMemoryFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        pageableDeviceLocalMemory: VkBool32
}

state VkPhysicalDeviceShaderCorePropertiesARM
{
        sType: VkStructureType,
        pNext: *void,
        pixelRate: uint32,
        texelRate: uint32,
        fmaRate: uint32
}

state VkDeviceQueueShaderCoreControlCreateInfoARM
{
        sType: VkStructureType,
        pNext: *void,
        shaderCoreCount: uint32
}

state VkPhysicalDeviceSchedulingControlsFeaturesARM
{
        sType: VkStructureType,
        pNext: *void,
        schedulingControls: VkBool32
}

state VkPhysicalDeviceSchedulingControlsPropertiesARM
{
        sType: VkStructureType,
        pNext: *void,
        schedulingControlsFlags: VkPhysicalDeviceSchedulingControlsFlagsARM
}

state VkPhysicalDeviceImageSlicedViewOf3DFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        imageSlicedViewOf3D: VkBool32
}

state VkImageViewSlicedCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        sliceOffset: uint32,
        sliceCount: uint32
}

state VkPhysicalDeviceDescriptorSetHostMappingFeaturesVALVE
{
        sType: VkStructureType,
        pNext: *void,
        descriptorSetHostMapping: VkBool32
}

state VkDescriptorSetBindingReferenceVALVE
{
        sType: VkStructureType,
        pNext: *void,
        descriptorSetLayout: VkDescriptorSetLayout,
        binding: uint32
}

state VkDescriptorSetLayoutHostMappingInfoVALVE
{
        sType: VkStructureType,
        pNext: *void,
        descriptorOffset: uint,
        descriptorSize: uint32
}

state VkPhysicalDeviceNonSeamlessCubeMapFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        nonSeamlessCubeMap: VkBool32
}

state VkPhysicalDeviceRenderPassStripedFeaturesARM
{
        sType: VkStructureType,
        pNext: *void,
        renderPassStriped: VkBool32
}

state VkPhysicalDeviceRenderPassStripedPropertiesARM
{
        sType: VkStructureType,
        pNext: *void,
        renderPassStripeGranularity: VkExtent2D,
        maxRenderPassStripes: uint32
}

state VkRenderPassStripeInfoARM
{
        sType: VkStructureType,
        pNext: *void,
        stripeArea: VkRect2D
}

state VkRenderPassStripeBeginInfoARM
{
        sType: VkStructureType,
        pNext: *void,
        stripeInfoCount: uint32,
        pStripeInfos: *VkRenderPassStripeInfoARM
}

state VkRenderPassStripeSubmitInfoARM
{
        sType: VkStructureType,
        pNext: *void,
        stripeSemaphoreInfoCount: uint32,
        pStripeSemaphoreInfos: *VkSemaphoreSubmitInfo
}

state VkPhysicalDeviceFragmentDensityMapOffsetFeaturesQCOM
{
        sType: VkStructureType,
        pNext: *void,
        fragmentDensityMapOffset: VkBool32
}

state VkPhysicalDeviceFragmentDensityMapOffsetPropertiesQCOM
{
        sType: VkStructureType,
        pNext: *void,
        fragmentDensityOffsetGranularity: VkExtent2D
}

state VkSubpassFragmentDensityMapOffsetEndInfoQCOM
{
        sType: VkStructureType,
        pNext: *void,
        fragmentDensityOffsetCount: uint32,
        pFragmentDensityOffsets: *VkOffset2D
}

state VkCopyMemoryIndirectCommandNV
{
        srcAddress: VkDeviceAddress,
        dstAddress: VkDeviceAddress,
        size: VkDeviceSize
}

state VkCopyMemoryToImageIndirectCommandNV
{
        srcAddress: VkDeviceAddress,
        bufferRowLength: uint32,
        bufferImageHeight: uint32,
        imageSubresource: VkImageSubresourceLayers,
        imageOffset: VkOffset3D,
        imageExtent: VkExtent3D
}

state VkPhysicalDeviceCopyMemoryIndirectFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        indirectCopy: VkBool32
}

state VkPhysicalDeviceCopyMemoryIndirectPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        supportedQueues: VkQueueFlags
}

state VkDecompressMemoryRegionNV
{
        srcAddress: VkDeviceAddress,
        dstAddress: VkDeviceAddress,
        compressedSize: VkDeviceSize,
        decompressedSize: VkDeviceSize,
        decompressionMethod: VkMemoryDecompressionMethodFlagsNV
}

state VkPhysicalDeviceMemoryDecompressionFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        memoryDecompression: VkBool32
}

state VkPhysicalDeviceMemoryDecompressionPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        decompressionMethods: VkMemoryDecompressionMethodFlagsNV,
        maxDecompressionIndirectCount: uint64
}

state VkPhysicalDeviceDeviceGeneratedCommandsComputeFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        deviceGeneratedCompute: VkBool32,
        deviceGeneratedComputePipelines: VkBool32,
        deviceGeneratedComputeCaptureReplay: VkBool32
}

state VkComputePipelineIndirectBufferInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        deviceAddress: VkDeviceAddress,
        size: VkDeviceSize,
        pipelineDeviceAddressCaptureReplay: VkDeviceAddress
}

state VkPipelineIndirectDeviceAddressInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        pipelineBindPoint: VkPipelineBindPoint,
        pipeline: VkPipeline
}

state VkBindPipelineIndirectCommandNV
{
        pipelineAddress: VkDeviceAddress
}

state VkPhysicalDeviceRayTracingLinearSweptSpheresFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        spheres: VkBool32,
        linearSweptSpheres: VkBool32
}

state VkAccelerationStructureGeometryLinearSweptSpheresDataNV
{
        sType: VkStructureType,
        pNext: *void,
        vertexFormat: VkFormat,
        vertexData: VkDeviceOrHostAddressConstKHR,
        vertexStride: VkDeviceSize,
        radiusFormat: VkFormat,
        radiusData: VkDeviceOrHostAddressConstKHR,
        radiusStride: VkDeviceSize,
        indexType: VkIndexType,
        indexData: VkDeviceOrHostAddressConstKHR,
        indexStride: VkDeviceSize,
        indexingMode: VkRayTracingLssIndexingModeNV,
        endCapsMode: VkRayTracingLssPrimitiveEndCapsModeNV
}

state VkAccelerationStructureGeometrySpheresDataNV
{
        sType: VkStructureType,
        pNext: *void,
        vertexFormat: VkFormat,
        vertexData: VkDeviceOrHostAddressConstKHR,
        vertexStride: VkDeviceSize,
        radiusFormat: VkFormat,
        radiusData: VkDeviceOrHostAddressConstKHR,
        radiusStride: VkDeviceSize,
        indexType: VkIndexType,
        indexData: VkDeviceOrHostAddressConstKHR,
        indexStride: VkDeviceSize
}

state VkPhysicalDeviceLinearColorAttachmentFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        linearColorAttachment: VkBool32
}

state VkPhysicalDeviceImageCompressionControlSwapchainFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        imageCompressionControlSwapchain: VkBool32
}

state VkImageViewSampleWeightCreateInfoQCOM
{
        sType: VkStructureType,
        pNext: *void,
        filterCenter: VkOffset2D,
        filterSize: VkExtent2D,
        numPhases: uint32
}

state VkPhysicalDeviceImageProcessingFeaturesQCOM
{
        sType: VkStructureType,
        pNext: *void,
        textureSampleWeighted: VkBool32,
        textureBoxFilter: VkBool32,
        textureBlockMatch: VkBool32
}

state VkPhysicalDeviceImageProcessingPropertiesQCOM
{
        sType: VkStructureType,
        pNext: *void,
        maxWeightFilterPhases: uint32,
        maxWeightFilterDimension: VkExtent2D,
        maxBlockMatchRegion: VkExtent2D,
        maxBoxFilterBlockSize: VkExtent2D
}

state VkPhysicalDeviceNestedCommandBufferFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        nestedCommandBuffer: VkBool32,
        nestedCommandBufferRendering: VkBool32,
        nestedCommandBufferSimultaneousUse: VkBool32
}

state VkPhysicalDeviceNestedCommandBufferPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        maxCommandBufferNestingLevel: uint32
}

state VkExternalMemoryAcquireUnmodifiedEXT
{
        sType: VkStructureType,
        pNext: *void,
        acquireUnmodifiedMemory: VkBool32
}

state VkPhysicalDeviceExtendedDynamicState3FeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        extendedDynamicState3TessellationDomainOrigin: VkBool32,
        extendedDynamicState3DepthClampEnable: VkBool32,
        extendedDynamicState3PolygonMode: VkBool32,
        extendedDynamicState3RasterizationSamples: VkBool32,
        extendedDynamicState3SampleMask: VkBool32,
        extendedDynamicState3AlphaToCoverageEnable: VkBool32,
        extendedDynamicState3AlphaToOneEnable: VkBool32,
        extendedDynamicState3LogicOpEnable: VkBool32,
        extendedDynamicState3ColorBlendEnable: VkBool32,
        extendedDynamicState3ColorBlendEquation: VkBool32,
        extendedDynamicState3ColorWriteMask: VkBool32,
        extendedDynamicState3RasterizationStream: VkBool32,
        extendedDynamicState3ConservativeRasterizationMode: VkBool32,
        extendedDynamicState3ExtraPrimitiveOverestimationSize: VkBool32,
        extendedDynamicState3DepthClipEnable: VkBool32,
        extendedDynamicState3SampleLocationsEnable: VkBool32,
        extendedDynamicState3ColorBlendAdvanced: VkBool32,
        extendedDynamicState3ProvokingVertexMode: VkBool32,
        extendedDynamicState3LineRasterizationMode: VkBool32,
        extendedDynamicState3LineStippleEnable: VkBool32,
        extendedDynamicState3DepthClipNegativeOneToOne: VkBool32,
        extendedDynamicState3ViewportWScalingEnable: VkBool32,
        extendedDynamicState3ViewportSwizzle: VkBool32,
        extendedDynamicState3CoverageToColorEnable: VkBool32,
        extendedDynamicState3CoverageToColorLocation: VkBool32,
        extendedDynamicState3CoverageModulationMode: VkBool32,
        extendedDynamicState3CoverageModulationTableEnable: VkBool32,
        extendedDynamicState3CoverageModulationTable: VkBool32,
        extendedDynamicState3CoverageReductionMode: VkBool32,
        extendedDynamicState3RepresentativeFragmentTestEnable: VkBool32,
        extendedDynamicState3ShadingRateImageEnable: VkBool32
}

state VkPhysicalDeviceExtendedDynamicState3PropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        dynamicPrimitiveTopologyUnrestricted: VkBool32
}

state VkColorBlendEquationEXT
{
        srcColorBlendFactor: VkBlendFactor,
        dstColorBlendFactor: VkBlendFactor,
        colorBlendOp: VkBlendOp,
        srcAlphaBlendFactor: VkBlendFactor,
        dstAlphaBlendFactor: VkBlendFactor,
        alphaBlendOp: VkBlendOp
}

state VkColorBlendAdvancedEXT
{
        advancedBlendOp: VkBlendOp,
        srcPremultiplied: VkBool32,
        dstPremultiplied: VkBool32,
        blendOverlap: VkBlendOverlapEXT,
        clampResults: VkBool32
}

state VkPhysicalDeviceSubpassMergeFeedbackFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        subpassMergeFeedback: VkBool32
}

state VkRenderPassCreationControlEXT
{
        sType: VkStructureType,
        pNext: *void,
        disallowMerging: VkBool32
}

state VkRenderPassCreationFeedbackInfoEXT
{
        postMergeSubpassCount: uint32
}

state VkRenderPassCreationFeedbackCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        pRenderPassFeedback: *VkRenderPassCreationFeedbackInfoEXT
}

state VkRenderPassSubpassFeedbackInfoEXT
{
        subpassMergeStatus: VkSubpassMergeStatusEXT,
        description: [256]byte,
        postMergeIndex: uint32
}

state VkRenderPassSubpassFeedbackCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        pSubpassFeedback: *VkRenderPassSubpassFeedbackInfoEXT
}

state VkDirectDriverLoadingInfoLUNARG
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkDirectDriverLoadingFlagsLUNARG,
        pfnGetInstanceProcAddr: PFN_vkGetInstanceProcAddrLUNARG
}

state VkDirectDriverLoadingListLUNARG
{
        sType: VkStructureType,
        pNext: *void,
        mode: VkDirectDriverLoadingModeLUNARG,
        driverCount: uint32,
        pDrivers: *VkDirectDriverLoadingInfoLUNARG
}

state VkPhysicalDeviceShaderModuleIdentifierFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderModuleIdentifier: VkBool32
}

state VkPhysicalDeviceShaderModuleIdentifierPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderModuleIdentifierAlgorithmUUID: [16]uint8_t
}

state VkPipelineShaderStageModuleIdentifierCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        identifierSize: uint32,
        pIdentifier: *uint8_t
}

state VkShaderModuleIdentifierEXT
{
        sType: VkStructureType,
        pNext: *void,
        identifierSize: uint32,
        identifier: [32]uint8_t
}

state VkPhysicalDeviceOpticalFlowFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        opticalFlow: VkBool32
}

state VkPhysicalDeviceOpticalFlowPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        supportedOutputGridSizes: VkOpticalFlowGridSizeFlagsNV,
        supportedHintGridSizes: VkOpticalFlowGridSizeFlagsNV,
        hintSupported: VkBool32,
        costSupported: VkBool32,
        bidirectionalFlowSupported: VkBool32,
        globalFlowSupported: VkBool32,
        minWidth: uint32,
        minHeight: uint32,
        maxWidth: uint32,
        maxHeight: uint32,
        maxNumRegionsOfInterest: uint32
}

state VkOpticalFlowImageFormatInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        usage: VkOpticalFlowUsageFlagsNV
}

state VkOpticalFlowImageFormatPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        format: VkFormat
}

state VkOpticalFlowSessionCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        width: uint32,
        height: uint32,
        imageFormat: VkFormat,
        flowVectorFormat: VkFormat,
        costFormat: VkFormat,
        outputGridSize: VkOpticalFlowGridSizeFlagsNV,
        hintGridSize: VkOpticalFlowGridSizeFlagsNV,
        performanceLevel: VkOpticalFlowPerformanceLevelNV,
        flags: VkOpticalFlowSessionCreateFlagsNV
}

state VkOpticalFlowSessionCreatePrivateDataInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        id: uint32,
        size: uint32,
        pPrivateData: *void
}

state VkOpticalFlowExecuteInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkOpticalFlowExecuteFlagsNV,
        regionCount: uint32,
        pRegions: *VkRect2D
}

state VkPhysicalDeviceLegacyDitheringFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        legacyDithering: VkBool32
}

state VkPhysicalDeviceAntiLagFeaturesAMD
{
        sType: VkStructureType,
        pNext: *void,
        antiLag: VkBool32
}

state VkAntiLagPresentationInfoAMD
{
        sType: VkStructureType,
        pNext: *void,
        stage: VkAntiLagStageAMD,
        frameIndex: uint64
}

state VkAntiLagDataAMD
{
        sType: VkStructureType,
        pNext: *void,
        mode: VkAntiLagModeAMD,
        maxFPS: uint32,
        pPresentationInfo: *VkAntiLagPresentationInfoAMD
}

state VkPhysicalDeviceShaderObjectFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderObject: VkBool32
}

state VkPhysicalDeviceShaderObjectPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderBinaryUUID: [16]uint8_t,
        shaderBinaryVersion: uint32
}

state VkShaderCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkShaderCreateFlagsEXT,
        stage: VkShaderStageFlagBits,
        nextStage: VkShaderStageFlags,
        codeType: VkShaderCodeTypeEXT,
        codeSize: uint,
        pCode: *void,
        pName: *byte,
        setLayoutCount: uint32,
        pSetLayouts: *VkDescriptorSetLayout,
        pushConstantRangeCount: uint32,
        pPushConstantRanges: *VkPushConstantRange,
        pSpecializationInfo: *VkSpecializationInfo
}

state VkDepthClampRangeEXT
{
        minDepthClamp: :float,
        maxDepthClamp: :float
}

state VkPhysicalDeviceTilePropertiesFeaturesQCOM
{
        sType: VkStructureType,
        pNext: *void,
        tileProperties: VkBool32
}

state VkTilePropertiesQCOM
{
        sType: VkStructureType,
        pNext: *void,
        tileSize: VkExtent3D,
        apronSize: VkExtent2D,
        origin: VkOffset2D
}

state VkPhysicalDeviceAmigoProfilingFeaturesSEC
{
        sType: VkStructureType,
        pNext: *void,
        amigoProfiling: VkBool32
}

state VkAmigoProfilingSubmitInfoSEC
{
        sType: VkStructureType,
        pNext: *void,
        firstDrawTimestamp: uint64,
        swapBufferTimestamp: uint64
}

state VkPhysicalDeviceMultiviewPerViewViewportsFeaturesQCOM
{
        sType: VkStructureType,
        pNext: *void,
        multiviewPerViewViewports: VkBool32
}

state VkPhysicalDeviceRayTracingInvocationReorderPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        rayTracingInvocationReorderReorderingHint: VkRayTracingInvocationReorderModeNV
}

state VkPhysicalDeviceRayTracingInvocationReorderFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        rayTracingInvocationReorder: VkBool32
}

state VkPhysicalDeviceCooperativeVectorPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        cooperativeVectorSupportedStages: VkShaderStageFlags,
        cooperativeVectorTrainingFloat16Accumulation: VkBool32,
        cooperativeVectorTrainingFloat32Accumulation: VkBool32,
        maxCooperativeVectorComponents: uint32
}

state VkPhysicalDeviceCooperativeVectorFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        cooperativeVector: VkBool32,
        cooperativeVectorTraining: VkBool32
}

state VkCooperativeVectorPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        inputType: VkComponentTypeKHR,
        inputInterpretation: VkComponentTypeKHR,
        matrixInterpretation: VkComponentTypeKHR,
        biasInterpretation: VkComponentTypeKHR,
        resultType: VkComponentTypeKHR,
        transpose: VkBool32
}

state VkConvertCooperativeVectorMatrixInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        srcSize: uint,
        srcData: VkDeviceOrHostAddressConstKHR,
        pDstSize: *uint,
        dstData: VkDeviceOrHostAddressKHR,
        srcComponentType: VkComponentTypeKHR,
        dstComponentType: VkComponentTypeKHR,
        numRows: uint32,
        numColumns: uint32,
        srcLayout: VkCooperativeVectorMatrixLayoutNV,
        srcStride: uint,
        dstLayout: VkCooperativeVectorMatrixLayoutNV,
        dstStride: uint
}

state VkPhysicalDeviceExtendedSparseAddressSpaceFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        extendedSparseAddressSpace: VkBool32
}

state VkPhysicalDeviceExtendedSparseAddressSpacePropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        extendedSparseAddressSpaceSize: VkDeviceSize,
        extendedSparseImageUsageFlags: VkImageUsageFlags,
        extendedSparseBufferUsageFlags: VkBufferUsageFlags
}

state VkPhysicalDeviceLegacyVertexAttributesFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        legacyVertexAttributes: VkBool32
}

state VkPhysicalDeviceLegacyVertexAttributesPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        nativeUnalignedPerformance: VkBool32
}

state VkLayerSettingEXT
{
        pLayerName: *byte,
        pSettingName: *byte,
        type: VkLayerSettingTypeEXT,
        valueCount: uint32,
        pValues: *void
}

state VkLayerSettingsCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        settingCount: uint32,
        pSettings: *VkLayerSettingEXT
}

state VkPhysicalDeviceShaderCoreBuiltinsFeaturesARM
{
        sType: VkStructureType,
        pNext: *void,
        shaderCoreBuiltins: VkBool32
}

state VkPhysicalDeviceShaderCoreBuiltinsPropertiesARM
{
        sType: VkStructureType,
        pNext: *void,
        shaderCoreMask: uint64,
        shaderCoreCount: uint32,
        shaderWarpsPerCore: uint32
}

state VkPhysicalDevicePipelineLibraryGroupHandlesFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        pipelineLibraryGroupHandles: VkBool32
}

state VkPhysicalDeviceDynamicRenderingUnusedAttachmentsFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        dynamicRenderingUnusedAttachments: VkBool32
}

state VkLatencySleepModeInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        lowLatencyMode: VkBool32,
        lowLatencyBoost: VkBool32,
        minimumIntervalUs: uint32
}

state VkLatencySleepInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        signalSemaphore: VkSemaphore,
        value: uint64
}

state VkSetLatencyMarkerInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        presentID: uint64,
        marker: VkLatencyMarkerNV
}

state VkLatencyTimingsFrameReportNV
{
        sType: VkStructureType,
        pNext: *void,
        presentID: uint64,
        inputSampleTimeUs: uint64,
        simStartTimeUs: uint64,
        simEndTimeUs: uint64,
        renderSubmitStartTimeUs: uint64,
        renderSubmitEndTimeUs: uint64,
        presentStartTimeUs: uint64,
        presentEndTimeUs: uint64,
        driverStartTimeUs: uint64,
        driverEndTimeUs: uint64,
        osRenderQueueStartTimeUs: uint64,
        osRenderQueueEndTimeUs: uint64,
        gpuRenderStartTimeUs: uint64,
        gpuRenderEndTimeUs: uint64
}

state VkGetLatencyMarkerInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        timingCount: uint32,
        pTimings: *VkLatencyTimingsFrameReportNV
}

state VkLatencySubmissionPresentIdNV
{
        sType: VkStructureType,
        pNext: *void,
        presentID: uint64
}

state VkSwapchainLatencyCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        latencyModeEnable: VkBool32
}

state VkOutOfBandQueueTypeInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        queueType: VkOutOfBandQueueTypeNV
}

state VkLatencySurfaceCapabilitiesNV
{
        sType: VkStructureType,
        pNext: *void,
        presentModeCount: uint32,
        pPresentModes: *VkPresentModeKHR
}

state VkPhysicalDeviceMultiviewPerViewRenderAreasFeaturesQCOM
{
        sType: VkStructureType,
        pNext: *void,
        multiviewPerViewRenderAreas: VkBool32
}

state VkMultiviewPerViewRenderAreasRenderPassBeginInfoQCOM
{
        sType: VkStructureType,
        pNext: *void,
        perViewRenderAreaCount: uint32,
        pPerViewRenderAreas: *VkRect2D
}

state VkPhysicalDevicePerStageDescriptorSetFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        perStageDescriptorSet: VkBool32,
        dynamicPipelineLayout: VkBool32
}

state VkPhysicalDeviceImageProcessing2FeaturesQCOM
{
        sType: VkStructureType,
        pNext: *void,
        textureBlockMatch2: VkBool32
}

state VkPhysicalDeviceImageProcessing2PropertiesQCOM
{
        sType: VkStructureType,
        pNext: *void,
        maxBlockMatchWindow: VkExtent2D
}

state VkSamplerBlockMatchWindowCreateInfoQCOM
{
        sType: VkStructureType,
        pNext: *void,
        windowExtent: VkExtent2D,
        windowCompareMode: VkBlockMatchWindowCompareModeQCOM
}

state VkPhysicalDeviceCubicWeightsFeaturesQCOM
{
        sType: VkStructureType,
        pNext: *void,
        selectableCubicWeights: VkBool32
}

state VkSamplerCubicWeightsCreateInfoQCOM
{
        sType: VkStructureType,
        pNext: *void,
        cubicWeights: VkCubicFilterWeightsQCOM
}

state VkBlitImageCubicWeightsInfoQCOM
{
        sType: VkStructureType,
        pNext: *void,
        cubicWeights: VkCubicFilterWeightsQCOM
}

state VkPhysicalDeviceYcbcrDegammaFeaturesQCOM
{
        sType: VkStructureType,
        pNext: *void,
        ycbcrDegamma: VkBool32
}

state VkSamplerYcbcrConversionYcbcrDegammaCreateInfoQCOM
{
        sType: VkStructureType,
        pNext: *void,
        enableYDegamma: VkBool32,
        enableCbCrDegamma: VkBool32
}

state VkPhysicalDeviceCubicClampFeaturesQCOM
{
        sType: VkStructureType,
        pNext: *void,
        cubicRangeClamp: VkBool32
}

state VkPhysicalDeviceAttachmentFeedbackLoopDynamicStateFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        attachmentFeedbackLoopDynamicState: VkBool32
}

state VkPhysicalDeviceLayeredDriverPropertiesMSFT
{
        sType: VkStructureType,
        pNext: *void,
        underlyingAPI: VkLayeredDriverUnderlyingApiMSFT
}

state VkPhysicalDeviceDescriptorPoolOverallocationFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        descriptorPoolOverallocation: VkBool32
}

state VkDisplaySurfaceStereoCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        stereoType: VkDisplaySurfaceStereoTypeNV
}

state VkDisplayModeStereoPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        hdmi3DSupported: VkBool32
}

state VkPhysicalDeviceRawAccessChainsFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        shaderRawAccessChains: VkBool32
}

state VkPhysicalDeviceCommandBufferInheritanceFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        commandBufferInheritance: VkBool32
}

state VkPhysicalDeviceShaderAtomicFloat16VectorFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        shaderFloat16VectorAtomics: VkBool32
}

state VkPhysicalDeviceShaderReplicatedCompositesFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderReplicatedComposites: VkBool32
}

state VkPhysicalDeviceRayTracingValidationFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        rayTracingValidation: VkBool32
}

state VkPhysicalDeviceClusterAccelerationStructureFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        clusterAccelerationStructure: VkBool32
}

state VkPhysicalDeviceClusterAccelerationStructurePropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        maxVerticesPerCluster: uint32,
        maxTrianglesPerCluster: uint32,
        clusterScratchByteAlignment: uint32,
        clusterByteAlignment: uint32,
        clusterTemplateByteAlignment: uint32,
        clusterBottomLevelByteAlignment: uint32,
        clusterTemplateBoundsByteAlignment: uint32,
        maxClusterGeometryIndex: uint32
}

state VkClusterAccelerationStructureClustersBottomLevelInputNV
{
        sType: VkStructureType,
        pNext: *void,
        maxTotalClusterCount: uint32,
        maxClusterCountPerAccelerationStructure: uint32
}

state VkClusterAccelerationStructureTriangleClusterInputNV
{
        sType: VkStructureType,
        pNext: *void,
        vertexFormat: VkFormat,
        maxGeometryIndexValue: uint32,
        maxClusterUniqueGeometryCount: uint32,
        maxClusterTriangleCount: uint32,
        maxClusterVertexCount: uint32,
        maxTotalTriangleCount: uint32,
        maxTotalVertexCount: uint32,
        minPositionTruncateBitCount: uint32
}

state VkClusterAccelerationStructureMoveObjectsInputNV
{
        sType: VkStructureType,
        pNext: *void,
        type: VkClusterAccelerationStructureTypeNV,
        noMoveOverlap: VkBool32,
        maxMovedBytes: VkDeviceSize
}

state VkClusterAccelerationStructureInputInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        maxAccelerationStructureCount: uint32,
        flags: VkBuildAccelerationStructureFlagsKHR,
        opType: VkClusterAccelerationStructureOpTypeNV,
        opMode: VkClusterAccelerationStructureOpModeNV,
        opInput: VkClusterAccelerationStructureOpInputNV
}

state VkStridedDeviceAddressRegionKHR
{
        deviceAddress: VkDeviceAddress,
        stride: VkDeviceSize,
        size: VkDeviceSize
}

state VkClusterAccelerationStructureCommandsInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        input: VkClusterAccelerationStructureInputInfoNV,
        dstImplicitData: VkDeviceAddress,
        scratchData: VkDeviceAddress,
        dstAddressesArray: VkStridedDeviceAddressRegionKHR,
        dstSizesArray: VkStridedDeviceAddressRegionKHR,
        srcInfosArray: VkStridedDeviceAddressRegionKHR,
        srcInfosCount: VkDeviceAddress,
        addressResolutionFlags: VkClusterAccelerationStructureAddressResolutionFlagsNV
}

state VkStridedDeviceAddressNV
{
        startAddress: VkDeviceAddress,
        strideInBytes: VkDeviceSize
}

state VkClusterAccelerationStructureGeometryIndexAndGeometryFlagsNV
{
        geometryIndex: :bitfield,
        reserved: :bitfield,
        geometryFlags: :bitfield
}

state VkClusterAccelerationStructureMoveObjectsInfoNV
{
        srcAccelerationStructure: VkDeviceAddress
}

state VkClusterAccelerationStructureBuildClustersBottomLevelInfoNV
{
        clusterReferencesCount: uint32,
        clusterReferencesStride: uint32,
        clusterReferences: VkDeviceAddress
}

state VkClusterAccelerationStructureBuildTriangleClusterInfoNV
{
        clusterID: uint32,
        clusterFlags: VkClusterAccelerationStructureClusterFlagsNV,
        triangleCount: :bitfield,
        vertexCount: :bitfield,
        positionTruncateBitCount: :bitfield,
        indexType: :bitfield,
        opacityMicromapIndexType: :bitfield,
        baseGeometryIndexAndGeometryFlags: VkClusterAccelerationStructureGeometryIndexAndGeometryFlagsNV,
        indexBufferStride: uint16_t,
        vertexBufferStride: uint16_t,
        geometryIndexAndFlagsBufferStride: uint16_t,
        opacityMicromapIndexBufferStride: uint16_t,
        indexBuffer: VkDeviceAddress,
        vertexBuffer: VkDeviceAddress,
        geometryIndexAndFlagsBuffer: VkDeviceAddress,
        opacityMicromapArray: VkDeviceAddress,
        opacityMicromapIndexBuffer: VkDeviceAddress
}

state VkClusterAccelerationStructureBuildTriangleClusterTemplateInfoNV
{
        clusterID: uint32,
        clusterFlags: VkClusterAccelerationStructureClusterFlagsNV,
        triangleCount: :bitfield,
        vertexCount: :bitfield,
        positionTruncateBitCount: :bitfield,
        indexType: :bitfield,
        opacityMicromapIndexType: :bitfield,
        baseGeometryIndexAndGeometryFlags: VkClusterAccelerationStructureGeometryIndexAndGeometryFlagsNV,
        indexBufferStride: uint16_t,
        vertexBufferStride: uint16_t,
        geometryIndexAndFlagsBufferStride: uint16_t,
        opacityMicromapIndexBufferStride: uint16_t,
        indexBuffer: VkDeviceAddress,
        vertexBuffer: VkDeviceAddress,
        geometryIndexAndFlagsBuffer: VkDeviceAddress,
        opacityMicromapArray: VkDeviceAddress,
        opacityMicromapIndexBuffer: VkDeviceAddress,
        instantiationBoundingBoxLimit: VkDeviceAddress
}

state VkClusterAccelerationStructureInstantiateClusterInfoNV
{
        clusterIdOffset: uint32,
        geometryIndexOffset: :bitfield,
        reserved: :bitfield,
        clusterTemplateAddress: VkDeviceAddress,
        vertexBuffer: VkStridedDeviceAddressNV
}

state VkAccelerationStructureBuildSizesInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        accelerationStructureSize: VkDeviceSize,
        updateScratchSize: VkDeviceSize,
        buildScratchSize: VkDeviceSize
}

state VkRayTracingPipelineClusterAccelerationStructureCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        allowClusterAccelerationStructure: VkBool32
}

state VkPhysicalDevicePartitionedAccelerationStructureFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        partitionedAccelerationStructure: VkBool32
}

state VkPhysicalDevicePartitionedAccelerationStructurePropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        maxPartitionCount: uint32
}

state VkPartitionedAccelerationStructureFlagsNV
{
        sType: VkStructureType,
        pNext: *void,
        enablePartitionTranslation: VkBool32
}

state VkBuildPartitionedAccelerationStructureIndirectCommandNV
{
        opType: VkPartitionedAccelerationStructureOpTypeNV,
        argCount: uint32,
        argData: VkStridedDeviceAddressNV
}

state VkPartitionedAccelerationStructureWriteInstanceDataNV
{
        transform: VkTransformMatrixKHR,
        explicitAABB: [6]:float,
        instanceID: uint32,
        instanceMask: uint32,
        instanceContributionToHitGroupIndex: uint32,
        instanceFlags: VkPartitionedAccelerationStructureInstanceFlagsNV,
        instanceIndex: uint32,
        partitionIndex: uint32,
        accelerationStructure: VkDeviceAddress
}

state VkPartitionedAccelerationStructureUpdateInstanceDataNV
{
        instanceIndex: uint32,
        instanceContributionToHitGroupIndex: uint32,
        accelerationStructure: VkDeviceAddress
}

state VkPartitionedAccelerationStructureWritePartitionTranslationDataNV
{
        partitionIndex: uint32,
        partitionTranslation: [3]:float
}

state VkWriteDescriptorSetPartitionedAccelerationStructureNV
{
        sType: VkStructureType,
        pNext: *void,
        accelerationStructureCount: uint32,
        pAccelerationStructures: *VkDeviceAddress
}

state VkPartitionedAccelerationStructureInstancesInputNV
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkBuildAccelerationStructureFlagsKHR,
        instanceCount: uint32,
        maxInstancePerPartitionCount: uint32,
        partitionCount: uint32,
        maxInstanceInGlobalPartitionCount: uint32
}

state VkBuildPartitionedAccelerationStructureInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        input: VkPartitionedAccelerationStructureInstancesInputNV,
        srcAccelerationStructureData: VkDeviceAddress,
        dstAccelerationStructureData: VkDeviceAddress,
        scratchData: VkDeviceAddress,
        srcInfos: VkDeviceAddress,
        srcInfosCount: VkDeviceAddress
}

state VkPhysicalDeviceDeviceGeneratedCommandsFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        deviceGeneratedCommands: VkBool32,
        dynamicGeneratedPipelineLayout: VkBool32
}

state VkPhysicalDeviceDeviceGeneratedCommandsPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        maxIndirectPipelineCount: uint32,
        maxIndirectShaderObjectCount: uint32,
        maxIndirectSequenceCount: uint32,
        maxIndirectCommandsTokenCount: uint32,
        maxIndirectCommandsTokenOffset: uint32,
        maxIndirectCommandsIndirectStride: uint32,
        supportedIndirectCommandsInputModes: VkIndirectCommandsInputModeFlagsEXT,
        supportedIndirectCommandsShaderStages: VkShaderStageFlags,
        supportedIndirectCommandsShaderStagesPipelineBinding: VkShaderStageFlags,
        supportedIndirectCommandsShaderStagesShaderBinding: VkShaderStageFlags,
        deviceGeneratedCommandsTransformFeedback: VkBool32,
        deviceGeneratedCommandsMultiDrawIndirectCount: VkBool32
}

state VkGeneratedCommandsMemoryRequirementsInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        indirectExecutionSet: VkIndirectExecutionSetEXT,
        indirectCommandsLayout: VkIndirectCommandsLayoutEXT,
        maxSequenceCount: uint32,
        maxDrawCount: uint32
}

state VkIndirectExecutionSetPipelineInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        initialPipeline: VkPipeline,
        maxPipelineCount: uint32
}

state VkIndirectExecutionSetShaderLayoutInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        setLayoutCount: uint32,
        pSetLayouts: *VkDescriptorSetLayout
}

state VkIndirectExecutionSetShaderInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderCount: uint32,
        pInitialShaders: *VkShaderEXT,
        pSetLayoutInfos: *VkIndirectExecutionSetShaderLayoutInfoEXT,
        maxShaderCount: uint32,
        pushConstantRangeCount: uint32,
        pPushConstantRanges: *VkPushConstantRange
}

state VkIndirectExecutionSetCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        type: VkIndirectExecutionSetInfoTypeEXT,
        info: VkIndirectExecutionSetInfoEXT
}

state VkGeneratedCommandsInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderStages: VkShaderStageFlags,
        indirectExecutionSet: VkIndirectExecutionSetEXT,
        indirectCommandsLayout: VkIndirectCommandsLayoutEXT,
        indirectAddress: VkDeviceAddress,
        indirectAddressSize: VkDeviceSize,
        preprocessAddress: VkDeviceAddress,
        preprocessSize: VkDeviceSize,
        maxSequenceCount: uint32,
        sequenceCountAddress: VkDeviceAddress,
        maxDrawCount: uint32
}

state VkWriteIndirectExecutionSetPipelineEXT
{
        sType: VkStructureType,
        pNext: *void,
        index: uint32,
        pipeline: VkPipeline
}

state VkIndirectCommandsPushConstantTokenEXT
{
        updateRange: VkPushConstantRange
}

state VkIndirectCommandsVertexBufferTokenEXT
{
        vertexBindingUnit: uint32
}

state VkIndirectCommandsIndexBufferTokenEXT
{
        mode: VkIndirectCommandsInputModeFlagBitsEXT
}

state VkIndirectCommandsExecutionSetTokenEXT
{
        type: VkIndirectExecutionSetInfoTypeEXT,
        shaderStages: VkShaderStageFlags
}

state VkIndirectCommandsLayoutTokenEXT
{
        sType: VkStructureType,
        pNext: *void,
        type: VkIndirectCommandsTokenTypeEXT,
        data: VkIndirectCommandsTokenDataEXT,
        offset: uint32
}

state VkIndirectCommandsLayoutCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkIndirectCommandsLayoutUsageFlagsEXT,
        shaderStages: VkShaderStageFlags,
        indirectStride: uint32,
        pipelineLayout: VkPipelineLayout,
        tokenCount: uint32,
        pTokens: *VkIndirectCommandsLayoutTokenEXT
}

state VkDrawIndirectCountIndirectCommandEXT
{
        bufferAddress: VkDeviceAddress,
        stride: uint32,
        commandCount: uint32
}

state VkBindVertexBufferIndirectCommandEXT
{
        bufferAddress: VkDeviceAddress,
        size: uint32,
        stride: uint32
}

state VkBindIndexBufferIndirectCommandEXT
{
        bufferAddress: VkDeviceAddress,
        size: uint32,
        indexType: VkIndexType
}

state VkGeneratedCommandsPipelineInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        pipeline: VkPipeline
}

state VkGeneratedCommandsShaderInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderCount: uint32,
        pShaders: *VkShaderEXT
}

state VkWriteIndirectExecutionSetShaderEXT
{
        sType: VkStructureType,
        pNext: *void,
        index: uint32,
        shader: VkShaderEXT
}

state VkPhysicalDeviceImageAlignmentControlFeaturesMESA
{
        sType: VkStructureType,
        pNext: *void,
        imageAlignmentControl: VkBool32
}

state VkPhysicalDeviceImageAlignmentControlPropertiesMESA
{
        sType: VkStructureType,
        pNext: *void,
        supportedImageAlignmentMask: uint32
}

state VkImageAlignmentControlCreateInfoMESA
{
        sType: VkStructureType,
        pNext: *void,
        maximumRequestedAlignment: uint32
}

state VkPhysicalDeviceDepthClampControlFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        depthClampControl: VkBool32
}

state VkPipelineViewportDepthClampControlCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        depthClampMode: VkDepthClampModeEXT,
        pDepthClampRange: *VkDepthClampRangeEXT
}

state VkPhysicalDeviceHdrVividFeaturesHUAWEI
{
        sType: VkStructureType,
        pNext: *void,
        hdrVivid: VkBool32
}

state VkHdrVividDynamicMetadataHUAWEI
{
        sType: VkStructureType,
        pNext: *void,
        dynamicMetadataSize: uint,
        pDynamicMetadata: *void
}

state VkCooperativeMatrixFlexibleDimensionsPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        MGranularity: uint32,
        NGranularity: uint32,
        KGranularity: uint32,
        AType: VkComponentTypeKHR,
        BType: VkComponentTypeKHR,
        CType: VkComponentTypeKHR,
        ResultType: VkComponentTypeKHR,
        saturatingAccumulation: VkBool32,
        scope: VkScopeKHR,
        workgroupInvocations: uint32
}

state VkPhysicalDeviceCooperativeMatrix2FeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        cooperativeMatrixWorkgroupScope: VkBool32,
        cooperativeMatrixFlexibleDimensions: VkBool32,
        cooperativeMatrixReductions: VkBool32,
        cooperativeMatrixConversions: VkBool32,
        cooperativeMatrixPerElementOperations: VkBool32,
        cooperativeMatrixTensorAddressing: VkBool32,
        cooperativeMatrixBlockLoads: VkBool32
}

state VkPhysicalDeviceCooperativeMatrix2PropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        cooperativeMatrixWorkgroupScopeMaxWorkgroupSize: uint32,
        cooperativeMatrixFlexibleDimensionsMaxDimension: uint32,
        cooperativeMatrixWorkgroupScopeReservedSharedMemory: uint32
}

state VkPhysicalDevicePipelineOpacityMicromapFeaturesARM
{
        sType: VkStructureType,
        pNext: *void,
        pipelineOpacityMicromap: VkBool32
}

state VkPhysicalDeviceVertexAttributeRobustnessFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        vertexAttributeRobustness: VkBool32
}

state VkSetPresentConfigNV
{
        sType: VkStructureType,
        pNext: *void,
        numFramesPerBatch: uint32,
        presentConfigFeedback: uint32
}

state VkPhysicalDevicePresentMeteringFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        presentMetering: VkBool32
}

state VkAccelerationStructureBuildRangeInfoKHR
{
        primitiveCount: uint32,
        primitiveOffset: uint32,
        firstVertex: uint32,
        transformOffset: uint32
}

state VkAccelerationStructureGeometryTrianglesDataKHR
{
        sType: VkStructureType,
        pNext: *void,
        vertexFormat: VkFormat,
        vertexData: VkDeviceOrHostAddressConstKHR,
        vertexStride: VkDeviceSize,
        maxVertex: uint32,
        indexType: VkIndexType,
        indexData: VkDeviceOrHostAddressConstKHR,
        transformData: VkDeviceOrHostAddressConstKHR
}

state VkAccelerationStructureGeometryAabbsDataKHR
{
        sType: VkStructureType,
        pNext: *void,
        data: VkDeviceOrHostAddressConstKHR,
        stride: VkDeviceSize
}

state VkAccelerationStructureGeometryInstancesDataKHR
{
        sType: VkStructureType,
        pNext: *void,
        arrayOfPointers: VkBool32,
        data: VkDeviceOrHostAddressConstKHR
}

state VkAccelerationStructureGeometryKHR
{
        sType: VkStructureType,
        pNext: *void,
        geometryType: VkGeometryTypeKHR,
        geometry: VkAccelerationStructureGeometryDataKHR,
        flags: VkGeometryFlagsKHR
}

state VkAccelerationStructureBuildGeometryInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        type: VkAccelerationStructureTypeKHR,
        flags: VkBuildAccelerationStructureFlagsKHR,
        mode: VkBuildAccelerationStructureModeKHR,
        srcAccelerationStructure: VkAccelerationStructureKHR,
        dstAccelerationStructure: VkAccelerationStructureKHR,
        geometryCount: uint32,
        pGeometries: *VkAccelerationStructureGeometryKHR,
        ppGeometries: **VkAccelerationStructureGeometryKHR,
        scratchData: VkDeviceOrHostAddressKHR
}

state VkAccelerationStructureCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        createFlags: VkAccelerationStructureCreateFlagsKHR,
        buffer: VkBuffer,
        offset: VkDeviceSize,
        size: VkDeviceSize,
        type: VkAccelerationStructureTypeKHR,
        deviceAddress: VkDeviceAddress
}

state VkWriteDescriptorSetAccelerationStructureKHR
{
        sType: VkStructureType,
        pNext: *void,
        accelerationStructureCount: uint32,
        pAccelerationStructures: *VkAccelerationStructureKHR
}

state VkPhysicalDeviceAccelerationStructureFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        accelerationStructure: VkBool32,
        accelerationStructureCaptureReplay: VkBool32,
        accelerationStructureIndirectBuild: VkBool32,
        accelerationStructureHostCommands: VkBool32,
        descriptorBindingAccelerationStructureUpdateAfterBind: VkBool32
}

state VkPhysicalDeviceAccelerationStructurePropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        maxGeometryCount: uint64,
        maxInstanceCount: uint64,
        maxPrimitiveCount: uint64,
        maxPerStageDescriptorAccelerationStructures: uint32,
        maxPerStageDescriptorUpdateAfterBindAccelerationStructures: uint32,
        maxDescriptorSetAccelerationStructures: uint32,
        maxDescriptorSetUpdateAfterBindAccelerationStructures: uint32,
        minAccelerationStructureScratchOffsetAlignment: uint32
}

state VkAccelerationStructureDeviceAddressInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        accelerationStructure: VkAccelerationStructureKHR
}

state VkAccelerationStructureVersionInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        pVersionData: *uint8_t
}

state VkCopyAccelerationStructureToMemoryInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        src: VkAccelerationStructureKHR,
        dst: VkDeviceOrHostAddressKHR,
        mode: VkCopyAccelerationStructureModeKHR
}

state VkCopyMemoryToAccelerationStructureInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        src: VkDeviceOrHostAddressConstKHR,
        dst: VkAccelerationStructureKHR,
        mode: VkCopyAccelerationStructureModeKHR
}

state VkCopyAccelerationStructureInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        src: VkAccelerationStructureKHR,
        dst: VkAccelerationStructureKHR,
        mode: VkCopyAccelerationStructureModeKHR
}

state VkRayTracingShaderGroupCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        type: VkRayTracingShaderGroupTypeKHR,
        generalShader: uint32,
        closestHitShader: uint32,
        anyHitShader: uint32,
        intersectionShader: uint32,
        pShaderGroupCaptureReplayHandle: *void
}

state VkRayTracingPipelineInterfaceCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        maxPipelineRayPayloadSize: uint32,
        maxPipelineRayHitAttributeSize: uint32
}

state VkRayTracingPipelineCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: VkPipelineCreateFlags,
        stageCount: uint32,
        pStages: *VkPipelineShaderStageCreateInfo,
        groupCount: uint32,
        pGroups: *VkRayTracingShaderGroupCreateInfoKHR,
        maxPipelineRayRecursionDepth: uint32,
        pLibraryInfo: *VkPipelineLibraryCreateInfoKHR,
        pLibraryInterface: *VkRayTracingPipelineInterfaceCreateInfoKHR,
        pDynamicState: *VkPipelineDynamicStateCreateInfo,
        layout: VkPipelineLayout,
        basePipelineHandle: VkPipeline,
        basePipelineIndex: int32
}

state VkPhysicalDeviceRayTracingPipelineFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        rayTracingPipeline: VkBool32,
        rayTracingPipelineShaderGroupHandleCaptureReplay: VkBool32,
        rayTracingPipelineShaderGroupHandleCaptureReplayMixed: VkBool32,
        rayTracingPipelineTraceRaysIndirect: VkBool32,
        rayTraversalPrimitiveCulling: VkBool32
}

state VkPhysicalDeviceRayTracingPipelinePropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        shaderGroupHandleSize: uint32,
        maxRayRecursionDepth: uint32,
        maxShaderGroupStride: uint32,
        shaderGroupBaseAlignment: uint32,
        shaderGroupHandleCaptureReplaySize: uint32,
        maxRayDispatchInvocationCount: uint32,
        shaderGroupHandleAlignment: uint32,
        maxRayHitAttributeSize: uint32
}

state VkTraceRaysIndirectCommandKHR
{
        width: uint32,
        height: uint32,
        depth: uint32
}

state VkPhysicalDeviceRayQueryFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        rayQuery: VkBool32
}

state VkPhysicalDeviceMeshShaderFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        taskShader: VkBool32,
        meshShader: VkBool32,
        multiviewMeshShader: VkBool32,
        primitiveFragmentShadingRateMeshShader: VkBool32,
        meshShaderQueries: VkBool32
}

state VkPhysicalDeviceMeshShaderPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        maxTaskWorkGroupTotalCount: uint32,
        maxTaskWorkGroupCount: [3]uint32,
        maxTaskWorkGroupInvocations: uint32,
        maxTaskWorkGroupSize: [3]uint32,
        maxTaskPayloadSize: uint32,
        maxTaskSharedMemorySize: uint32,
        maxTaskPayloadAndSharedMemorySize: uint32,
        maxMeshWorkGroupTotalCount: uint32,
        maxMeshWorkGroupCount: [3]uint32,
        maxMeshWorkGroupInvocations: uint32,
        maxMeshWorkGroupSize: [3]uint32,
        maxMeshSharedMemorySize: uint32,
        maxMeshPayloadAndSharedMemorySize: uint32,
        maxMeshOutputMemorySize: uint32,
        maxMeshPayloadAndOutputMemorySize: uint32,
        maxMeshOutputComponents: uint32,
        maxMeshOutputVertices: uint32,
        maxMeshOutputPrimitives: uint32,
        maxMeshOutputLayers: uint32,
        maxMeshMultiviewViewCount: uint32,
        meshOutputPerVertexGranularity: uint32,
        meshOutputPerPrimitiveGranularity: uint32,
        maxPreferredTaskWorkGroupInvocations: uint32,
        maxPreferredMeshWorkGroupInvocations: uint32,
        prefersLocalInvocationVertexOutput: VkBool32,
        prefersLocalInvocationPrimitiveOutput: VkBool32,
        prefersCompactVertexOutput: VkBool32,
        prefersCompactPrimitiveOutput: VkBool32
}

state VkDrawMeshTasksIndirectCommandEXT
{
        groupCountX: uint32,
        groupCountY: uint32,
        groupCountZ: uint32
}