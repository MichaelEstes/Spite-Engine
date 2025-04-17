package Vulkan

extern
{
    #link windows "vulkan-1";
    #link linux "libvulkan.so.1";

    VkResult vkCreateInstance(pCreateInfo: *VkInstanceCreateInfo, pAllocator: *VkAllocationCallbacks, pInstance: **VkInstance_T);
    void vkDestroyInstance(instance: *VkInstance_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkEnumeratePhysicalDevices(instance: *VkInstance_T, pPhysicalDeviceCount: *uint32, pPhysicalDevices: **VkPhysicalDevice_T);
    void vkGetPhysicalDeviceFeatures(physicalDevice: *VkPhysicalDevice_T, pFeatures: *VkPhysicalDeviceFeatures);
    void vkGetPhysicalDeviceFormatProperties(physicalDevice: *VkPhysicalDevice_T, format: VkFormat, pFormatProperties: *VkFormatProperties);
    VkResult vkGetPhysicalDeviceImageFormatProperties(physicalDevice: *VkPhysicalDevice_T, format: VkFormat, type: VkImageType, tiling: VkImageTiling, usage: uint32, flags: uint32, pImageFormatProperties: *VkImageFormatProperties);
    void vkGetPhysicalDeviceProperties(physicalDevice: *VkPhysicalDevice_T, pProperties: *VkPhysicalDeviceProperties);
    void vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice: *VkPhysicalDevice_T, pQueueFamilyPropertyCount: *uint32, pQueueFamilyProperties: *VkQueueFamilyProperties);
    void vkGetPhysicalDeviceMemoryProperties(physicalDevice: *VkPhysicalDevice_T, pMemoryProperties: *VkPhysicalDeviceMemoryProperties);
    ::() vkGetInstanceProcAddr(instance: *VkInstance_T, pName: *byte);
    ::() vkGetDeviceProcAddr(device: *VkDevice_T, pName: *byte);
    VkResult vkCreateDevice(physicalDevice: *VkPhysicalDevice_T, pCreateInfo: *VkDeviceCreateInfo, pAllocator: *VkAllocationCallbacks, pDevice: **VkDevice_T);
    void vkDestroyDevice(device: *VkDevice_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkEnumerateInstanceExtensionProperties(pLayerName: *byte, pPropertyCount: *uint32, pProperties: *VkExtensionProperties);
    VkResult vkEnumerateDeviceExtensionProperties(physicalDevice: *VkPhysicalDevice_T, pLayerName: *byte, pPropertyCount: *uint32, pProperties: *VkExtensionProperties);
    VkResult vkEnumerateInstanceLayerProperties(pPropertyCount: *uint32, pProperties: *VkLayerProperties);
    VkResult vkEnumerateDeviceLayerProperties(physicalDevice: *VkPhysicalDevice_T, pPropertyCount: *uint32, pProperties: *VkLayerProperties);
    void vkGetDeviceQueue(device: *VkDevice_T, queueFamilyIndex: uint32, queueIndex: uint32, pQueue: **VkQueue_T);
    VkResult vkQueueSubmit(queue: *VkQueue_T, submitCount: uint32, pSubmits: *VkSubmitInfo, fence: *VkFence_T);
    VkResult vkQueueWaitIdle(queue: *VkQueue_T);
    VkResult vkDeviceWaitIdle(device: *VkDevice_T);
    VkResult vkAllocateMemory(device: *VkDevice_T, pAllocateInfo: *VkMemoryAllocateInfo, pAllocator: *VkAllocationCallbacks, pMemory: **VkDeviceMemory_T);
    void vkFreeMemory(device: *VkDevice_T, memory: *VkDeviceMemory_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkMapMemory(device: *VkDevice_T, memory: *VkDeviceMemory_T, offset: uint64, size: uint64, flags: uint32, ppData: **void);
    void vkUnmapMemory(device: *VkDevice_T, memory: *VkDeviceMemory_T);
    VkResult vkFlushMappedMemoryRanges(device: *VkDevice_T, memoryRangeCount: uint32, pMemoryRanges: *VkMappedMemoryRange);
    VkResult vkInvalidateMappedMemoryRanges(device: *VkDevice_T, memoryRangeCount: uint32, pMemoryRanges: *VkMappedMemoryRange);
    void vkGetDeviceMemoryCommitment(device: *VkDevice_T, memory: *VkDeviceMemory_T, pCommittedMemoryInBytes: *uint64);
    VkResult vkBindBufferMemory(device: *VkDevice_T, buffer: *VkBuffer_T, memory: *VkDeviceMemory_T, memoryOffset: uint64);
    VkResult vkBindImageMemory(device: *VkDevice_T, image: *VkImage_T, memory: *VkDeviceMemory_T, memoryOffset: uint64);
    void vkGetBufferMemoryRequirements(device: *VkDevice_T, buffer: *VkBuffer_T, pMemoryRequirements: *VkMemoryRequirements);
    void vkGetImageMemoryRequirements(device: *VkDevice_T, image: *VkImage_T, pMemoryRequirements: *VkMemoryRequirements);
    void vkGetImageSparseMemoryRequirements(device: *VkDevice_T, image: *VkImage_T, pSparseMemoryRequirementCount: *uint32, pSparseMemoryRequirements: *VkSparseImageMemoryRequirements);
    void vkGetPhysicalDeviceSparseImageFormatProperties(physicalDevice: *VkPhysicalDevice_T, format: VkFormat, type: VkImageType, samples: VkSampleCountFlagBits, usage: uint32, tiling: VkImageTiling, pPropertyCount: *uint32, pProperties: *VkSparseImageFormatProperties);
    VkResult vkQueueBindSparse(queue: *VkQueue_T, bindInfoCount: uint32, pBindInfo: *VkBindSparseInfo, fence: *VkFence_T);
    VkResult vkCreateFence(device: *VkDevice_T, pCreateInfo: *VkFenceCreateInfo, pAllocator: *VkAllocationCallbacks, pFence: **VkFence_T);
    void vkDestroyFence(device: *VkDevice_T, fence: *VkFence_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkResetFences(device: *VkDevice_T, fenceCount: uint32, pFences: **VkFence_T);
    VkResult vkGetFenceStatus(device: *VkDevice_T, fence: *VkFence_T);
    VkResult vkWaitForFences(device: *VkDevice_T, fenceCount: uint32, pFences: **VkFence_T, waitAll: uint32, timeout: uint64);
    VkResult vkCreateSemaphore(device: *VkDevice_T, pCreateInfo: *VkSemaphoreCreateInfo, pAllocator: *VkAllocationCallbacks, pSemaphore: **VkSemaphore_T);
    void vkDestroySemaphore(device: *VkDevice_T, semaphore: *VkSemaphore_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateEvent(device: *VkDevice_T, pCreateInfo: *VkEventCreateInfo, pAllocator: *VkAllocationCallbacks, pEvent: **VkEvent_T);
    void vkDestroyEvent(device: *VkDevice_T, event: *VkEvent_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetEventStatus(device: *VkDevice_T, event: *VkEvent_T);
    VkResult vkSetEvent(device: *VkDevice_T, event: *VkEvent_T);
    VkResult vkResetEvent(device: *VkDevice_T, event: *VkEvent_T);
    VkResult vkCreateQueryPool(device: *VkDevice_T, pCreateInfo: *VkQueryPoolCreateInfo, pAllocator: *VkAllocationCallbacks, pQueryPool: **VkQueryPool_T);
    void vkDestroyQueryPool(device: *VkDevice_T, queryPool: *VkQueryPool_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetQueryPoolResults(device: *VkDevice_T, queryPool: *VkQueryPool_T, firstQuery: uint32, queryCount: uint32, dataSize: uint64, pData: *void, stride: uint64, flags: uint32);
    VkResult vkCreateBuffer(device: *VkDevice_T, pCreateInfo: *VkBufferCreateInfo, pAllocator: *VkAllocationCallbacks, pBuffer: **VkBuffer_T);
    void vkDestroyBuffer(device: *VkDevice_T, buffer: *VkBuffer_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateBufferView(device: *VkDevice_T, pCreateInfo: *VkBufferViewCreateInfo, pAllocator: *VkAllocationCallbacks, pView: **VkBufferView_T);
    void vkDestroyBufferView(device: *VkDevice_T, bufferView: *VkBufferView_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateImage(device: *VkDevice_T, pCreateInfo: *VkImageCreateInfo, pAllocator: *VkAllocationCallbacks, pImage: **VkImage_T);
    void vkDestroyImage(device: *VkDevice_T, image: *VkImage_T, pAllocator: *VkAllocationCallbacks);
    void vkGetImageSubresourceLayout(device: *VkDevice_T, image: *VkImage_T, pSubresource: *VkImageSubresource, pLayout: *VkSubresourceLayout);
    VkResult vkCreateImageView(device: *VkDevice_T, pCreateInfo: *VkImageViewCreateInfo, pAllocator: *VkAllocationCallbacks, pView: **VkImageView_T);
    void vkDestroyImageView(device: *VkDevice_T, imageView: *VkImageView_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateShaderModule(device: *VkDevice_T, pCreateInfo: *VkShaderModuleCreateInfo, pAllocator: *VkAllocationCallbacks, pShaderModule: **VkShaderModule_T);
    void vkDestroyShaderModule(device: *VkDevice_T, shaderModule: *VkShaderModule_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreatePipelineCache(device: *VkDevice_T, pCreateInfo: *VkPipelineCacheCreateInfo, pAllocator: *VkAllocationCallbacks, pPipelineCache: **VkPipelineCache_T);
    void vkDestroyPipelineCache(device: *VkDevice_T, pipelineCache: *VkPipelineCache_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetPipelineCacheData(device: *VkDevice_T, pipelineCache: *VkPipelineCache_T, pDataSize: *uint64, pData: *void);
    VkResult vkMergePipelineCaches(device: *VkDevice_T, dstCache: *VkPipelineCache_T, srcCacheCount: uint32, pSrcCaches: **VkPipelineCache_T);
    VkResult vkCreateGraphicsPipelines(device: *VkDevice_T, pipelineCache: *VkPipelineCache_T, createInfoCount: uint32, pCreateInfos: *VkGraphicsPipelineCreateInfo, pAllocator: *VkAllocationCallbacks, pPipelines: **VkPipeline_T);
    VkResult vkCreateComputePipelines(device: *VkDevice_T, pipelineCache: *VkPipelineCache_T, createInfoCount: uint32, pCreateInfos: *VkComputePipelineCreateInfo, pAllocator: *VkAllocationCallbacks, pPipelines: **VkPipeline_T);
    void vkDestroyPipeline(device: *VkDevice_T, pipeline: *VkPipeline_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreatePipelineLayout(device: *VkDevice_T, pCreateInfo: *VkPipelineLayoutCreateInfo, pAllocator: *VkAllocationCallbacks, pPipelineLayout: **VkPipelineLayout_T);
    void vkDestroyPipelineLayout(device: *VkDevice_T, pipelineLayout: *VkPipelineLayout_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateSampler(device: *VkDevice_T, pCreateInfo: *VkSamplerCreateInfo, pAllocator: *VkAllocationCallbacks, pSampler: **VkSampler_T);
    void vkDestroySampler(device: *VkDevice_T, sampler: *VkSampler_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateDescriptorSetLayout(device: *VkDevice_T, pCreateInfo: *VkDescriptorSetLayoutCreateInfo, pAllocator: *VkAllocationCallbacks, pSetLayout: **VkDescriptorSetLayout_T);
    void vkDestroyDescriptorSetLayout(device: *VkDevice_T, descriptorSetLayout: *VkDescriptorSetLayout_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateDescriptorPool(device: *VkDevice_T, pCreateInfo: *VkDescriptorPoolCreateInfo, pAllocator: *VkAllocationCallbacks, pDescriptorPool: **VkDescriptorPool_T);
    void vkDestroyDescriptorPool(device: *VkDevice_T, descriptorPool: *VkDescriptorPool_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkResetDescriptorPool(device: *VkDevice_T, descriptorPool: *VkDescriptorPool_T, flags: uint32);
    VkResult vkAllocateDescriptorSets(device: *VkDevice_T, pAllocateInfo: *VkDescriptorSetAllocateInfo, pDescriptorSets: **VkDescriptorSet_T);
    VkResult vkFreeDescriptorSets(device: *VkDevice_T, descriptorPool: *VkDescriptorPool_T, descriptorSetCount: uint32, pDescriptorSets: **VkDescriptorSet_T);
    void vkUpdateDescriptorSets(device: *VkDevice_T, descriptorWriteCount: uint32, pDescriptorWrites: *VkWriteDescriptorSet, descriptorCopyCount: uint32, pDescriptorCopies: *VkCopyDescriptorSet);
    VkResult vkCreateFramebuffer(device: *VkDevice_T, pCreateInfo: *VkFramebufferCreateInfo, pAllocator: *VkAllocationCallbacks, pFramebuffer: **VkFramebuffer_T);
    void vkDestroyFramebuffer(device: *VkDevice_T, framebuffer: *VkFramebuffer_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateRenderPass(device: *VkDevice_T, pCreateInfo: *VkRenderPassCreateInfo, pAllocator: *VkAllocationCallbacks, pRenderPass: **VkRenderPass_T);
    void vkDestroyRenderPass(device: *VkDevice_T, renderPass: *VkRenderPass_T, pAllocator: *VkAllocationCallbacks);
    void vkGetRenderAreaGranularity(device: *VkDevice_T, renderPass: *VkRenderPass_T, pGranularity: *VkExtent2D);
    VkResult vkCreateCommandPool(device: *VkDevice_T, pCreateInfo: *VkCommandPoolCreateInfo, pAllocator: *VkAllocationCallbacks, pCommandPool: **VkCommandPool_T);
    void vkDestroyCommandPool(device: *VkDevice_T, commandPool: *VkCommandPool_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkResetCommandPool(device: *VkDevice_T, commandPool: *VkCommandPool_T, flags: uint32);
    VkResult vkAllocateCommandBuffers(device: *VkDevice_T, pAllocateInfo: *VkCommandBufferAllocateInfo, pCommandBuffers: **VkCommandBuffer_T);
    void vkFreeCommandBuffers(device: *VkDevice_T, commandPool: *VkCommandPool_T, commandBufferCount: uint32, pCommandBuffers: **VkCommandBuffer_T);
    VkResult vkBeginCommandBuffer(commandBuffer: *VkCommandBuffer_T, pBeginInfo: *VkCommandBufferBeginInfo);
    VkResult vkEndCommandBuffer(commandBuffer: *VkCommandBuffer_T);
    VkResult vkResetCommandBuffer(commandBuffer: *VkCommandBuffer_T, flags: uint32);
    void vkCmdBindPipeline(commandBuffer: *VkCommandBuffer_T, pipelineBindPoint: VkPipelineBindPoint, pipeline: *VkPipeline_T);
    void vkCmdSetViewport(commandBuffer: *VkCommandBuffer_T, firstViewport: uint32, viewportCount: uint32, pViewports: *VkViewport);
    void vkCmdSetScissor(commandBuffer: *VkCommandBuffer_T, firstScissor: uint32, scissorCount: uint32, pScissors: *VkRect2D);
    void vkCmdSetLineWidth(commandBuffer: *VkCommandBuffer_T, lineWidth: float32);
    void vkCmdSetDepthBias(commandBuffer: *VkCommandBuffer_T, depthBiasConstantFactor: float32, depthBiasClamp: float32, depthBiasSlopeFactor: float32);
    void vkCmdSetBlendConstants(commandBuffer: *VkCommandBuffer_T, blendConstants: [4]float32);
    void vkCmdSetDepthBounds(commandBuffer: *VkCommandBuffer_T, minDepthBounds: float32, maxDepthBounds: float32);
    void vkCmdSetStencilCompareMask(commandBuffer: *VkCommandBuffer_T, faceMask: uint32, compareMask: uint32);
    void vkCmdSetStencilWriteMask(commandBuffer: *VkCommandBuffer_T, faceMask: uint32, writeMask: uint32);
    void vkCmdSetStencilReference(commandBuffer: *VkCommandBuffer_T, faceMask: uint32, reference: uint32);
    void vkCmdBindDescriptorSets(commandBuffer: *VkCommandBuffer_T, pipelineBindPoint: VkPipelineBindPoint, layout: *VkPipelineLayout_T, firstSet: uint32, descriptorSetCount: uint32, pDescriptorSets: **VkDescriptorSet_T, dynamicOffsetCount: uint32, pDynamicOffsets: *uint32);
    void vkCmdBindIndexBuffer(commandBuffer: *VkCommandBuffer_T, buffer: *VkBuffer_T, offset: uint64, indexType: VkIndexType);
    void vkCmdBindVertexBuffers(commandBuffer: *VkCommandBuffer_T, firstBinding: uint32, bindingCount: uint32, pBuffers: **VkBuffer_T, pOffsets: *uint64);
    void vkCmdDraw(commandBuffer: *VkCommandBuffer_T, vertexCount: uint32, instanceCount: uint32, firstVertex: uint32, firstInstance: uint32);
    void vkCmdDrawIndexed(commandBuffer: *VkCommandBuffer_T, indexCount: uint32, instanceCount: uint32, firstIndex: uint32, vertexOffset: int32, firstInstance: uint32);
    void vkCmdDrawIndirect(commandBuffer: *VkCommandBuffer_T, buffer: *VkBuffer_T, offset: uint64, drawCount: uint32, stride: uint32);
    void vkCmdDrawIndexedIndirect(commandBuffer: *VkCommandBuffer_T, buffer: *VkBuffer_T, offset: uint64, drawCount: uint32, stride: uint32);
    void vkCmdDispatch(commandBuffer: *VkCommandBuffer_T, groupCountX: uint32, groupCountY: uint32, groupCountZ: uint32);
    void vkCmdDispatchIndirect(commandBuffer: *VkCommandBuffer_T, buffer: *VkBuffer_T, offset: uint64);
    void vkCmdCopyBuffer(commandBuffer: *VkCommandBuffer_T, srcBuffer: *VkBuffer_T, dstBuffer: *VkBuffer_T, regionCount: uint32, pRegions: *VkBufferCopy);
    void vkCmdCopyImage(commandBuffer: *VkCommandBuffer_T, srcImage: *VkImage_T, srcImageLayout: VkImageLayout, dstImage: *VkImage_T, dstImageLayout: VkImageLayout, regionCount: uint32, pRegions: *VkImageCopy);
    void vkCmdBlitImage(commandBuffer: *VkCommandBuffer_T, srcImage: *VkImage_T, srcImageLayout: VkImageLayout, dstImage: *VkImage_T, dstImageLayout: VkImageLayout, regionCount: uint32, pRegions: *VkImageBlit, filter: VkFilter);
    void vkCmdCopyBufferToImage(commandBuffer: *VkCommandBuffer_T, srcBuffer: *VkBuffer_T, dstImage: *VkImage_T, dstImageLayout: VkImageLayout, regionCount: uint32, pRegions: *VkBufferImageCopy);
    void vkCmdCopyImageToBuffer(commandBuffer: *VkCommandBuffer_T, srcImage: *VkImage_T, srcImageLayout: VkImageLayout, dstBuffer: *VkBuffer_T, regionCount: uint32, pRegions: *VkBufferImageCopy);
    void vkCmdUpdateBuffer(commandBuffer: *VkCommandBuffer_T, dstBuffer: *VkBuffer_T, dstOffset: uint64, dataSize: uint64, pData: *void);
    void vkCmdFillBuffer(commandBuffer: *VkCommandBuffer_T, dstBuffer: *VkBuffer_T, dstOffset: uint64, size: uint64, data: uint32);
    void vkCmdClearColorImage(commandBuffer: *VkCommandBuffer_T, image: *VkImage_T, imageLayout: VkImageLayout, pColor: *?{_float32: [4]float32, _int32: [4]int32, _uint32: [4]uint32}, rangeCount: uint32, pRanges: *VkImageSubresourceRange);
    void vkCmdClearDepthStencilImage(commandBuffer: *VkCommandBuffer_T, image: *VkImage_T, imageLayout: VkImageLayout, pDepthStencil: *VkClearDepthStencilValue, rangeCount: uint32, pRanges: *VkImageSubresourceRange);
    void vkCmdClearAttachments(commandBuffer: *VkCommandBuffer_T, attachmentCount: uint32, pAttachments: *VkClearAttachment, rectCount: uint32, pRects: *VkClearRect);
    void vkCmdResolveImage(commandBuffer: *VkCommandBuffer_T, srcImage: *VkImage_T, srcImageLayout: VkImageLayout, dstImage: *VkImage_T, dstImageLayout: VkImageLayout, regionCount: uint32, pRegions: *VkImageResolve);
    void vkCmdSetEvent(commandBuffer: *VkCommandBuffer_T, event: *VkEvent_T, stageMask: uint32);
    void vkCmdResetEvent(commandBuffer: *VkCommandBuffer_T, event: *VkEvent_T, stageMask: uint32);
    void vkCmdWaitEvents(commandBuffer: *VkCommandBuffer_T, eventCount: uint32, pEvents: **VkEvent_T, srcStageMask: uint32, dstStageMask: uint32, memoryBarrierCount: uint32, pMemoryBarriers: *VkMemoryBarrier, bufferMemoryBarrierCount: uint32, pBufferMemoryBarriers: *VkBufferMemoryBarrier, imageMemoryBarrierCount: uint32, pImageMemoryBarriers: *VkImageMemoryBarrier);
    void vkCmdPipelineBarrier(commandBuffer: *VkCommandBuffer_T, srcStageMask: uint32, dstStageMask: uint32, dependencyFlags: uint32, memoryBarrierCount: uint32, pMemoryBarriers: *VkMemoryBarrier, bufferMemoryBarrierCount: uint32, pBufferMemoryBarriers: *VkBufferMemoryBarrier, imageMemoryBarrierCount: uint32, pImageMemoryBarriers: *VkImageMemoryBarrier);
    void vkCmdBeginQuery(commandBuffer: *VkCommandBuffer_T, queryPool: *VkQueryPool_T, query: uint32, flags: uint32);
    void vkCmdEndQuery(commandBuffer: *VkCommandBuffer_T, queryPool: *VkQueryPool_T, query: uint32);
    void vkCmdResetQueryPool(commandBuffer: *VkCommandBuffer_T, queryPool: *VkQueryPool_T, firstQuery: uint32, queryCount: uint32);
    void vkCmdWriteTimestamp(commandBuffer: *VkCommandBuffer_T, pipelineStage: VkPipelineStageFlagBits, queryPool: *VkQueryPool_T, query: uint32);
    void vkCmdCopyQueryPoolResults(commandBuffer: *VkCommandBuffer_T, queryPool: *VkQueryPool_T, firstQuery: uint32, queryCount: uint32, dstBuffer: *VkBuffer_T, dstOffset: uint64, stride: uint64, flags: uint32);
    void vkCmdPushConstants(commandBuffer: *VkCommandBuffer_T, layout: *VkPipelineLayout_T, stageFlags: uint32, offset: uint32, size: uint32, pValues: *void);
    void vkCmdBeginRenderPass(commandBuffer: *VkCommandBuffer_T, pRenderPassBegin: *VkRenderPassBeginInfo, contents: VkSubpassContents);
    void vkCmdNextSubpass(commandBuffer: *VkCommandBuffer_T, contents: VkSubpassContents);
    void vkCmdEndRenderPass(commandBuffer: *VkCommandBuffer_T);
    void vkCmdExecuteCommands(commandBuffer: *VkCommandBuffer_T, commandBufferCount: uint32, pCommandBuffers: **VkCommandBuffer_T);
    VkResult vkEnumerateInstanceVersion(pApiVersion: *uint32);
    VkResult vkBindBufferMemory2(device: *VkDevice_T, bindInfoCount: uint32, pBindInfos: *VkBindBufferMemoryInfo);
    VkResult vkBindImageMemory2(device: *VkDevice_T, bindInfoCount: uint32, pBindInfos: *VkBindImageMemoryInfo);
    void vkGetDeviceGroupPeerMemoryFeatures(device: *VkDevice_T, heapIndex: uint32, localDeviceIndex: uint32, remoteDeviceIndex: uint32, pPeerMemoryFeatures: *uint32);
    void vkCmdSetDeviceMask(commandBuffer: *VkCommandBuffer_T, deviceMask: uint32);
    void vkCmdDispatchBase(commandBuffer: *VkCommandBuffer_T, baseGroupX: uint32, baseGroupY: uint32, baseGroupZ: uint32, groupCountX: uint32, groupCountY: uint32, groupCountZ: uint32);
    VkResult vkEnumeratePhysicalDeviceGroups(instance: *VkInstance_T, pPhysicalDeviceGroupCount: *uint32, pPhysicalDeviceGroupProperties: *VkPhysicalDeviceGroupProperties);
    void vkGetImageMemoryRequirements2(device: *VkDevice_T, pInfo: *VkImageMemoryRequirementsInfo2, pMemoryRequirements: *VkMemoryRequirements2);
    void vkGetBufferMemoryRequirements2(device: *VkDevice_T, pInfo: *VkBufferMemoryRequirementsInfo2, pMemoryRequirements: *VkMemoryRequirements2);
    void vkGetImageSparseMemoryRequirements2(device: *VkDevice_T, pInfo: *VkImageSparseMemoryRequirementsInfo2, pSparseMemoryRequirementCount: *uint32, pSparseMemoryRequirements: *VkSparseImageMemoryRequirements2);
    void vkGetPhysicalDeviceFeatures2(physicalDevice: *VkPhysicalDevice_T, pFeatures: *VkPhysicalDeviceFeatures2);
    void vkGetPhysicalDeviceProperties2(physicalDevice: *VkPhysicalDevice_T, pProperties: *VkPhysicalDeviceProperties2);
    void vkGetPhysicalDeviceFormatProperties2(physicalDevice: *VkPhysicalDevice_T, format: VkFormat, pFormatProperties: *VkFormatProperties2);
    VkResult vkGetPhysicalDeviceImageFormatProperties2(physicalDevice: *VkPhysicalDevice_T, pImageFormatInfo: *VkPhysicalDeviceImageFormatInfo2, pImageFormatProperties: *VkImageFormatProperties2);
    void vkGetPhysicalDeviceQueueFamilyProperties2(physicalDevice: *VkPhysicalDevice_T, pQueueFamilyPropertyCount: *uint32, pQueueFamilyProperties: *VkQueueFamilyProperties2);
    void vkGetPhysicalDeviceMemoryProperties2(physicalDevice: *VkPhysicalDevice_T, pMemoryProperties: *VkPhysicalDeviceMemoryProperties2);
    void vkGetPhysicalDeviceSparseImageFormatProperties2(physicalDevice: *VkPhysicalDevice_T, pFormatInfo: *VkPhysicalDeviceSparseImageFormatInfo2, pPropertyCount: *uint32, pProperties: *VkSparseImageFormatProperties2);
    void vkTrimCommandPool(device: *VkDevice_T, commandPool: *VkCommandPool_T, flags: uint32);
    void vkGetDeviceQueue2(device: *VkDevice_T, pQueueInfo: *VkDeviceQueueInfo2, pQueue: **VkQueue_T);
    VkResult vkCreateSamplerYcbcrConversion(device: *VkDevice_T, pCreateInfo: *VkSamplerYcbcrConversionCreateInfo, pAllocator: *VkAllocationCallbacks, pYcbcrConversion: **VkSamplerYcbcrConversion_T);
    void vkDestroySamplerYcbcrConversion(device: *VkDevice_T, ycbcrConversion: *VkSamplerYcbcrConversion_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateDescriptorUpdateTemplate(device: *VkDevice_T, pCreateInfo: *VkDescriptorUpdateTemplateCreateInfo, pAllocator: *VkAllocationCallbacks, pDescriptorUpdateTemplate: **VkDescriptorUpdateTemplate_T);
    void vkDestroyDescriptorUpdateTemplate(device: *VkDevice_T, descriptorUpdateTemplate: *VkDescriptorUpdateTemplate_T, pAllocator: *VkAllocationCallbacks);
    void vkUpdateDescriptorSetWithTemplate(device: *VkDevice_T, descriptorSet: *VkDescriptorSet_T, descriptorUpdateTemplate: *VkDescriptorUpdateTemplate_T, pData: *void);
    void vkGetPhysicalDeviceExternalBufferProperties(physicalDevice: *VkPhysicalDevice_T, pExternalBufferInfo: *VkPhysicalDeviceExternalBufferInfo, pExternalBufferProperties: *VkExternalBufferProperties);
    void vkGetPhysicalDeviceExternalFenceProperties(physicalDevice: *VkPhysicalDevice_T, pExternalFenceInfo: *VkPhysicalDeviceExternalFenceInfo, pExternalFenceProperties: *VkExternalFenceProperties);
    void vkGetPhysicalDeviceExternalSemaphoreProperties(physicalDevice: *VkPhysicalDevice_T, pExternalSemaphoreInfo: *VkPhysicalDeviceExternalSemaphoreInfo, pExternalSemaphoreProperties: *VkExternalSemaphoreProperties);
    void vkGetDescriptorSetLayoutSupport(device: *VkDevice_T, pCreateInfo: *VkDescriptorSetLayoutCreateInfo, pSupport: *VkDescriptorSetLayoutSupport);
    void vkCmdDrawIndirectCount(commandBuffer: *VkCommandBuffer_T, buffer: *VkBuffer_T, offset: uint64, countBuffer: *VkBuffer_T, countBufferOffset: uint64, maxDrawCount: uint32, stride: uint32);
    void vkCmdDrawIndexedIndirectCount(commandBuffer: *VkCommandBuffer_T, buffer: *VkBuffer_T, offset: uint64, countBuffer: *VkBuffer_T, countBufferOffset: uint64, maxDrawCount: uint32, stride: uint32);
    VkResult vkCreateRenderPass2(device: *VkDevice_T, pCreateInfo: *VkRenderPassCreateInfo2, pAllocator: *VkAllocationCallbacks, pRenderPass: **VkRenderPass_T);
    void vkCmdBeginRenderPass2(commandBuffer: *VkCommandBuffer_T, pRenderPassBegin: *VkRenderPassBeginInfo, pSubpassBeginInfo: *VkSubpassBeginInfo);
    void vkCmdNextSubpass2(commandBuffer: *VkCommandBuffer_T, pSubpassBeginInfo: *VkSubpassBeginInfo, pSubpassEndInfo: *VkSubpassEndInfo);
    void vkCmdEndRenderPass2(commandBuffer: *VkCommandBuffer_T, pSubpassEndInfo: *VkSubpassEndInfo);
    void vkResetQueryPool(device: *VkDevice_T, queryPool: *VkQueryPool_T, firstQuery: uint32, queryCount: uint32);
    VkResult vkGetSemaphoreCounterValue(device: *VkDevice_T, semaphore: *VkSemaphore_T, pValue: *uint64);
    VkResult vkWaitSemaphores(device: *VkDevice_T, pWaitInfo: *VkSemaphoreWaitInfo, timeout: uint64);
    VkResult vkSignalSemaphore(device: *VkDevice_T, pSignalInfo: *VkSemaphoreSignalInfo);
    uint64 vkGetBufferDeviceAddress(device: *VkDevice_T, pInfo: *VkBufferDeviceAddressInfo);
    uint64 vkGetBufferOpaqueCaptureAddress(device: *VkDevice_T, pInfo: *VkBufferDeviceAddressInfo);
    uint64 vkGetDeviceMemoryOpaqueCaptureAddress(device: *VkDevice_T, pInfo: *VkDeviceMemoryOpaqueCaptureAddressInfo);
    VkResult vkGetPhysicalDeviceToolProperties(physicalDevice: *VkPhysicalDevice_T, pToolCount: *uint32, pToolProperties: *VkPhysicalDeviceToolProperties);
    VkResult vkCreatePrivateDataSlot(device: *VkDevice_T, pCreateInfo: *VkPrivateDataSlotCreateInfo, pAllocator: *VkAllocationCallbacks, pPrivateDataSlot: **VkPrivateDataSlot_T);
    void vkDestroyPrivateDataSlot(device: *VkDevice_T, privateDataSlot: *VkPrivateDataSlot_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkSetPrivateData(device: *VkDevice_T, objectType: VkObjectType, objectHandle: uint64, privateDataSlot: *VkPrivateDataSlot_T, data: uint64);
    void vkGetPrivateData(device: *VkDevice_T, objectType: VkObjectType, objectHandle: uint64, privateDataSlot: *VkPrivateDataSlot_T, pData: *uint64);
    void vkCmdSetEvent2(commandBuffer: *VkCommandBuffer_T, event: *VkEvent_T, pDependencyInfo: *VkDependencyInfo);
    void vkCmdResetEvent2(commandBuffer: *VkCommandBuffer_T, event: *VkEvent_T, stageMask: uint64);
    void vkCmdWaitEvents2(commandBuffer: *VkCommandBuffer_T, eventCount: uint32, pEvents: **VkEvent_T, pDependencyInfos: *VkDependencyInfo);
    void vkCmdPipelineBarrier2(commandBuffer: *VkCommandBuffer_T, pDependencyInfo: *VkDependencyInfo);
    void vkCmdWriteTimestamp2(commandBuffer: *VkCommandBuffer_T, stage: uint64, queryPool: *VkQueryPool_T, query: uint32);
    VkResult vkQueueSubmit2(queue: *VkQueue_T, submitCount: uint32, pSubmits: *VkSubmitInfo2, fence: *VkFence_T);
    void vkCmdCopyBuffer2(commandBuffer: *VkCommandBuffer_T, pCopyBufferInfo: *VkCopyBufferInfo2);
    void vkCmdCopyImage2(commandBuffer: *VkCommandBuffer_T, pCopyImageInfo: *VkCopyImageInfo2);
    void vkCmdCopyBufferToImage2(commandBuffer: *VkCommandBuffer_T, pCopyBufferToImageInfo: *VkCopyBufferToImageInfo2);
    void vkCmdCopyImageToBuffer2(commandBuffer: *VkCommandBuffer_T, pCopyImageToBufferInfo: *VkCopyImageToBufferInfo2);
    void vkCmdBlitImage2(commandBuffer: *VkCommandBuffer_T, pBlitImageInfo: *VkBlitImageInfo2);
    void vkCmdResolveImage2(commandBuffer: *VkCommandBuffer_T, pResolveImageInfo: *VkResolveImageInfo2);
    void vkCmdBeginRendering(commandBuffer: *VkCommandBuffer_T, pRenderingInfo: *VkRenderingInfo);
    void vkCmdEndRendering(commandBuffer: *VkCommandBuffer_T);
    void vkCmdSetCullMode(commandBuffer: *VkCommandBuffer_T, cullMode: uint32);
    void vkCmdSetFrontFace(commandBuffer: *VkCommandBuffer_T, frontFace: VkFrontFace);
    void vkCmdSetPrimitiveTopology(commandBuffer: *VkCommandBuffer_T, primitiveTopology: VkPrimitiveTopology);
    void vkCmdSetViewportWithCount(commandBuffer: *VkCommandBuffer_T, viewportCount: uint32, pViewports: *VkViewport);
    void vkCmdSetScissorWithCount(commandBuffer: *VkCommandBuffer_T, scissorCount: uint32, pScissors: *VkRect2D);
    void vkCmdBindVertexBuffers2(commandBuffer: *VkCommandBuffer_T, firstBinding: uint32, bindingCount: uint32, pBuffers: **VkBuffer_T, pOffsets: *uint64, pSizes: *uint64, pStrides: *uint64);
    void vkCmdSetDepthTestEnable(commandBuffer: *VkCommandBuffer_T, depthTestEnable: uint32);
    void vkCmdSetDepthWriteEnable(commandBuffer: *VkCommandBuffer_T, depthWriteEnable: uint32);
    void vkCmdSetDepthCompareOp(commandBuffer: *VkCommandBuffer_T, depthCompareOp: VkCompareOp);
    void vkCmdSetDepthBoundsTestEnable(commandBuffer: *VkCommandBuffer_T, depthBoundsTestEnable: uint32);
    void vkCmdSetStencilTestEnable(commandBuffer: *VkCommandBuffer_T, stencilTestEnable: uint32);
    void vkCmdSetStencilOp(commandBuffer: *VkCommandBuffer_T, faceMask: uint32, failOp: VkStencilOp, passOp: VkStencilOp, depthFailOp: VkStencilOp, compareOp: VkCompareOp);
    void vkCmdSetRasterizerDiscardEnable(commandBuffer: *VkCommandBuffer_T, rasterizerDiscardEnable: uint32);
    void vkCmdSetDepthBiasEnable(commandBuffer: *VkCommandBuffer_T, depthBiasEnable: uint32);
    void vkCmdSetPrimitiveRestartEnable(commandBuffer: *VkCommandBuffer_T, primitiveRestartEnable: uint32);
    void vkGetDeviceBufferMemoryRequirements(device: *VkDevice_T, pInfo: *VkDeviceBufferMemoryRequirements, pMemoryRequirements: *VkMemoryRequirements2);
    void vkGetDeviceImageMemoryRequirements(device: *VkDevice_T, pInfo: *VkDeviceImageMemoryRequirements, pMemoryRequirements: *VkMemoryRequirements2);
    void vkGetDeviceImageSparseMemoryRequirements(device: *VkDevice_T, pInfo: *VkDeviceImageMemoryRequirements, pSparseMemoryRequirementCount: *uint32, pSparseMemoryRequirements: *VkSparseImageMemoryRequirements2);
    void vkCmdSetLineStipple(commandBuffer: *VkCommandBuffer_T, lineStippleFactor: uint32, lineStipplePattern: uint16);
    VkResult vkMapMemory2(device: *VkDevice_T, pMemoryMapInfo: *VkMemoryMapInfo, ppData: **void);
    VkResult vkUnmapMemory2(device: *VkDevice_T, pMemoryUnmapInfo: *VkMemoryUnmapInfo);
    void vkCmdBindIndexBuffer2(commandBuffer: *VkCommandBuffer_T, buffer: *VkBuffer_T, offset: uint64, size: uint64, indexType: VkIndexType);
    void vkGetRenderingAreaGranularity(device: *VkDevice_T, pRenderingAreaInfo: *VkRenderingAreaInfo, pGranularity: *VkExtent2D);
    void vkGetDeviceImageSubresourceLayout(device: *VkDevice_T, pInfo: *VkDeviceImageSubresourceInfo, pLayout: *VkSubresourceLayout2);
    void vkGetImageSubresourceLayout2(device: *VkDevice_T, image: *VkImage_T, pSubresource: *VkImageSubresource2, pLayout: *VkSubresourceLayout2);
    void vkCmdPushDescriptorSet(commandBuffer: *VkCommandBuffer_T, pipelineBindPoint: VkPipelineBindPoint, layout: *VkPipelineLayout_T, set: uint32, descriptorWriteCount: uint32, pDescriptorWrites: *VkWriteDescriptorSet);
    void vkCmdPushDescriptorSetWithTemplate(commandBuffer: *VkCommandBuffer_T, descriptorUpdateTemplate: *VkDescriptorUpdateTemplate_T, layout: *VkPipelineLayout_T, set: uint32, pData: *void);
    void vkCmdSetRenderingAttachmentLocations(commandBuffer: *VkCommandBuffer_T, pLocationInfo: *VkRenderingAttachmentLocationInfo);
    void vkCmdSetRenderingInputAttachmentIndices(commandBuffer: *VkCommandBuffer_T, pInputAttachmentIndexInfo: *VkRenderingInputAttachmentIndexInfo);
    void vkCmdBindDescriptorSets2(commandBuffer: *VkCommandBuffer_T, pBindDescriptorSetsInfo: *VkBindDescriptorSetsInfo);
    void vkCmdPushConstants2(commandBuffer: *VkCommandBuffer_T, pPushConstantsInfo: *VkPushConstantsInfo);
    void vkCmdPushDescriptorSet2(commandBuffer: *VkCommandBuffer_T, pPushDescriptorSetInfo: *VkPushDescriptorSetInfo);
    void vkCmdPushDescriptorSetWithTemplate2(commandBuffer: *VkCommandBuffer_T, pPushDescriptorSetWithTemplateInfo: *VkPushDescriptorSetWithTemplateInfo);
    VkResult vkCopyMemoryToImage(device: *VkDevice_T, pCopyMemoryToImageInfo: *VkCopyMemoryToImageInfo);
    VkResult vkCopyImageToMemory(device: *VkDevice_T, pCopyImageToMemoryInfo: *VkCopyImageToMemoryInfo);
    VkResult vkCopyImageToImage(device: *VkDevice_T, pCopyImageToImageInfo: *VkCopyImageToImageInfo);
    VkResult vkTransitionImageLayout(device: *VkDevice_T, transitionCount: uint32, pTransitions: *VkHostImageLayoutTransitionInfo);
    void vkDestroySurfaceKHR(instance: *VkInstance_T, surface: *VkSurfaceKHR_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetPhysicalDeviceSurfaceSupportKHR(physicalDevice: *VkPhysicalDevice_T, queueFamilyIndex: uint32, surface: *VkSurfaceKHR_T, pSupported: *uint32);
    VkResult vkGetPhysicalDeviceSurfaceCapabilitiesKHR(physicalDevice: *VkPhysicalDevice_T, surface: *VkSurfaceKHR_T, pSurfaceCapabilities: *VkSurfaceCapabilitiesKHR);
    VkResult vkGetPhysicalDeviceSurfaceFormatsKHR(physicalDevice: *VkPhysicalDevice_T, surface: *VkSurfaceKHR_T, pSurfaceFormatCount: *uint32, pSurfaceFormats: *VkSurfaceFormatKHR);
    VkResult vkGetPhysicalDeviceSurfacePresentModesKHR(physicalDevice: *VkPhysicalDevice_T, surface: *VkSurfaceKHR_T, pPresentModeCount: *uint32, pPresentModes: *VkPresentModeKHR);
    VkResult vkCreateSwapchainKHR(device: *VkDevice_T, pCreateInfo: *VkSwapchainCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pSwapchain: **VkSwapchainKHR_T);
    void vkDestroySwapchainKHR(device: *VkDevice_T, swapchain: *VkSwapchainKHR_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetSwapchainImagesKHR(device: *VkDevice_T, swapchain: *VkSwapchainKHR_T, pSwapchainImageCount: *uint32, pSwapchainImages: **VkImage_T);
    VkResult vkAcquireNextImageKHR(device: *VkDevice_T, swapchain: *VkSwapchainKHR_T, timeout: uint64, semaphore: *VkSemaphore_T, fence: *VkFence_T, pImageIndex: *uint32);
    VkResult vkQueuePresentKHR(queue: *VkQueue_T, pPresentInfo: *VkPresentInfoKHR);
    VkResult vkGetDeviceGroupPresentCapabilitiesKHR(device: *VkDevice_T, pDeviceGroupPresentCapabilities: *VkDeviceGroupPresentCapabilitiesKHR);
    VkResult vkGetDeviceGroupSurfacePresentModesKHR(device: *VkDevice_T, surface: *VkSurfaceKHR_T, pModes: *uint32);
    VkResult vkGetPhysicalDevicePresentRectanglesKHR(physicalDevice: *VkPhysicalDevice_T, surface: *VkSurfaceKHR_T, pRectCount: *uint32, pRects: *VkRect2D);
    VkResult vkAcquireNextImage2KHR(device: *VkDevice_T, pAcquireInfo: *VkAcquireNextImageInfoKHR, pImageIndex: *uint32);
    VkResult vkGetPhysicalDeviceDisplayPropertiesKHR(physicalDevice: *VkPhysicalDevice_T, pPropertyCount: *uint32, pProperties: *VkDisplayPropertiesKHR);
    VkResult vkGetPhysicalDeviceDisplayPlanePropertiesKHR(physicalDevice: *VkPhysicalDevice_T, pPropertyCount: *uint32, pProperties: *VkDisplayPlanePropertiesKHR);
    VkResult vkGetDisplayPlaneSupportedDisplaysKHR(physicalDevice: *VkPhysicalDevice_T, planeIndex: uint32, pDisplayCount: *uint32, pDisplays: **VkDisplayKHR_T);
    VkResult vkGetDisplayModePropertiesKHR(physicalDevice: *VkPhysicalDevice_T, display: *VkDisplayKHR_T, pPropertyCount: *uint32, pProperties: *VkDisplayModePropertiesKHR);
    VkResult vkCreateDisplayModeKHR(physicalDevice: *VkPhysicalDevice_T, display: *VkDisplayKHR_T, pCreateInfo: *VkDisplayModeCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pMode: **VkDisplayModeKHR_T);
    VkResult vkGetDisplayPlaneCapabilitiesKHR(physicalDevice: *VkPhysicalDevice_T, mode: *VkDisplayModeKHR_T, planeIndex: uint32, pCapabilities: *VkDisplayPlaneCapabilitiesKHR);
    VkResult vkCreateDisplayPlaneSurfaceKHR(instance: *VkInstance_T, pCreateInfo: *VkDisplaySurfaceCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pSurface: **VkSurfaceKHR_T);
    VkResult vkCreateSharedSwapchainsKHR(device: *VkDevice_T, swapchainCount: uint32, pCreateInfos: *VkSwapchainCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pSwapchains: **VkSwapchainKHR_T);
    VkResult vkGetPhysicalDeviceVideoCapabilitiesKHR(physicalDevice: *VkPhysicalDevice_T, pVideoProfile: *VkVideoProfileInfoKHR, pCapabilities: *VkVideoCapabilitiesKHR);
    VkResult vkGetPhysicalDeviceVideoFormatPropertiesKHR(physicalDevice: *VkPhysicalDevice_T, pVideoFormatInfo: *VkPhysicalDeviceVideoFormatInfoKHR, pVideoFormatPropertyCount: *uint32, pVideoFormatProperties: *VkVideoFormatPropertiesKHR);
    VkResult vkCreateVideoSessionKHR(device: *VkDevice_T, pCreateInfo: *VkVideoSessionCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pVideoSession: **VkVideoSessionKHR_T);
    void vkDestroyVideoSessionKHR(device: *VkDevice_T, videoSession: *VkVideoSessionKHR_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetVideoSessionMemoryRequirementsKHR(device: *VkDevice_T, videoSession: *VkVideoSessionKHR_T, pMemoryRequirementsCount: *uint32, pMemoryRequirements: *VkVideoSessionMemoryRequirementsKHR);
    VkResult vkBindVideoSessionMemoryKHR(device: *VkDevice_T, videoSession: *VkVideoSessionKHR_T, bindSessionMemoryInfoCount: uint32, pBindSessionMemoryInfos: *VkBindVideoSessionMemoryInfoKHR);
    VkResult vkCreateVideoSessionParametersKHR(device: *VkDevice_T, pCreateInfo: *VkVideoSessionParametersCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pVideoSessionParameters: **VkVideoSessionParametersKHR_T);
    VkResult vkUpdateVideoSessionParametersKHR(device: *VkDevice_T, videoSessionParameters: *VkVideoSessionParametersKHR_T, pUpdateInfo: *VkVideoSessionParametersUpdateInfoKHR);
    void vkDestroyVideoSessionParametersKHR(device: *VkDevice_T, videoSessionParameters: *VkVideoSessionParametersKHR_T, pAllocator: *VkAllocationCallbacks);
    void vkCmdBeginVideoCodingKHR(commandBuffer: *VkCommandBuffer_T, pBeginInfo: *VkVideoBeginCodingInfoKHR);
    void vkCmdEndVideoCodingKHR(commandBuffer: *VkCommandBuffer_T, pEndCodingInfo: *VkVideoEndCodingInfoKHR);
    void vkCmdControlVideoCodingKHR(commandBuffer: *VkCommandBuffer_T, pCodingControlInfo: *VkVideoCodingControlInfoKHR);
    void vkCmdDecodeVideoKHR(commandBuffer: *VkCommandBuffer_T, pDecodeInfo: *VkVideoDecodeInfoKHR);
    void vkCmdBeginRenderingKHR(commandBuffer: *VkCommandBuffer_T, pRenderingInfo: *VkRenderingInfo);
    void vkCmdEndRenderingKHR(commandBuffer: *VkCommandBuffer_T);
    void vkGetPhysicalDeviceFeatures2KHR(physicalDevice: *VkPhysicalDevice_T, pFeatures: *VkPhysicalDeviceFeatures2);
    void vkGetPhysicalDeviceProperties2KHR(physicalDevice: *VkPhysicalDevice_T, pProperties: *VkPhysicalDeviceProperties2);
    void vkGetPhysicalDeviceFormatProperties2KHR(physicalDevice: *VkPhysicalDevice_T, format: VkFormat, pFormatProperties: *VkFormatProperties2);
    VkResult vkGetPhysicalDeviceImageFormatProperties2KHR(physicalDevice: *VkPhysicalDevice_T, pImageFormatInfo: *VkPhysicalDeviceImageFormatInfo2, pImageFormatProperties: *VkImageFormatProperties2);
    void vkGetPhysicalDeviceQueueFamilyProperties2KHR(physicalDevice: *VkPhysicalDevice_T, pQueueFamilyPropertyCount: *uint32, pQueueFamilyProperties: *VkQueueFamilyProperties2);
    void vkGetPhysicalDeviceMemoryProperties2KHR(physicalDevice: *VkPhysicalDevice_T, pMemoryProperties: *VkPhysicalDeviceMemoryProperties2);
    void vkGetPhysicalDeviceSparseImageFormatProperties2KHR(physicalDevice: *VkPhysicalDevice_T, pFormatInfo: *VkPhysicalDeviceSparseImageFormatInfo2, pPropertyCount: *uint32, pProperties: *VkSparseImageFormatProperties2);
    void vkGetDeviceGroupPeerMemoryFeaturesKHR(device: *VkDevice_T, heapIndex: uint32, localDeviceIndex: uint32, remoteDeviceIndex: uint32, pPeerMemoryFeatures: *uint32);
    void vkCmdSetDeviceMaskKHR(commandBuffer: *VkCommandBuffer_T, deviceMask: uint32);
    void vkCmdDispatchBaseKHR(commandBuffer: *VkCommandBuffer_T, baseGroupX: uint32, baseGroupY: uint32, baseGroupZ: uint32, groupCountX: uint32, groupCountY: uint32, groupCountZ: uint32);
    void vkTrimCommandPoolKHR(device: *VkDevice_T, commandPool: *VkCommandPool_T, flags: uint32);
    VkResult vkEnumeratePhysicalDeviceGroupsKHR(instance: *VkInstance_T, pPhysicalDeviceGroupCount: *uint32, pPhysicalDeviceGroupProperties: *VkPhysicalDeviceGroupProperties);
    void vkGetPhysicalDeviceExternalBufferPropertiesKHR(physicalDevice: *VkPhysicalDevice_T, pExternalBufferInfo: *VkPhysicalDeviceExternalBufferInfo, pExternalBufferProperties: *VkExternalBufferProperties);
    VkResult vkGetMemoryFdKHR(device: *VkDevice_T, pGetFdInfo: *VkMemoryGetFdInfoKHR, pFd: *int32);
    VkResult vkGetMemoryFdPropertiesKHR(device: *VkDevice_T, handleType: VkExternalMemoryHandleTypeFlagBits, fd: int32, pMemoryFdProperties: *VkMemoryFdPropertiesKHR);
    void vkGetPhysicalDeviceExternalSemaphorePropertiesKHR(physicalDevice: *VkPhysicalDevice_T, pExternalSemaphoreInfo: *VkPhysicalDeviceExternalSemaphoreInfo, pExternalSemaphoreProperties: *VkExternalSemaphoreProperties);
    VkResult vkImportSemaphoreFdKHR(device: *VkDevice_T, pImportSemaphoreFdInfo: *VkImportSemaphoreFdInfoKHR);
    VkResult vkGetSemaphoreFdKHR(device: *VkDevice_T, pGetFdInfo: *VkSemaphoreGetFdInfoKHR, pFd: *int32);
    void vkCmdPushDescriptorSetKHR(commandBuffer: *VkCommandBuffer_T, pipelineBindPoint: VkPipelineBindPoint, layout: *VkPipelineLayout_T, set: uint32, descriptorWriteCount: uint32, pDescriptorWrites: *VkWriteDescriptorSet);
    void vkCmdPushDescriptorSetWithTemplateKHR(commandBuffer: *VkCommandBuffer_T, descriptorUpdateTemplate: *VkDescriptorUpdateTemplate_T, layout: *VkPipelineLayout_T, set: uint32, pData: *void);
    VkResult vkCreateDescriptorUpdateTemplateKHR(device: *VkDevice_T, pCreateInfo: *VkDescriptorUpdateTemplateCreateInfo, pAllocator: *VkAllocationCallbacks, pDescriptorUpdateTemplate: **VkDescriptorUpdateTemplate_T);
    void vkDestroyDescriptorUpdateTemplateKHR(device: *VkDevice_T, descriptorUpdateTemplate: *VkDescriptorUpdateTemplate_T, pAllocator: *VkAllocationCallbacks);
    void vkUpdateDescriptorSetWithTemplateKHR(device: *VkDevice_T, descriptorSet: *VkDescriptorSet_T, descriptorUpdateTemplate: *VkDescriptorUpdateTemplate_T, pData: *void);
    VkResult vkCreateRenderPass2KHR(device: *VkDevice_T, pCreateInfo: *VkRenderPassCreateInfo2, pAllocator: *VkAllocationCallbacks, pRenderPass: **VkRenderPass_T);
    void vkCmdBeginRenderPass2KHR(commandBuffer: *VkCommandBuffer_T, pRenderPassBegin: *VkRenderPassBeginInfo, pSubpassBeginInfo: *VkSubpassBeginInfo);
    void vkCmdNextSubpass2KHR(commandBuffer: *VkCommandBuffer_T, pSubpassBeginInfo: *VkSubpassBeginInfo, pSubpassEndInfo: *VkSubpassEndInfo);
    void vkCmdEndRenderPass2KHR(commandBuffer: *VkCommandBuffer_T, pSubpassEndInfo: *VkSubpassEndInfo);
    VkResult vkGetSwapchainStatusKHR(device: *VkDevice_T, swapchain: *VkSwapchainKHR_T);
    void vkGetPhysicalDeviceExternalFencePropertiesKHR(physicalDevice: *VkPhysicalDevice_T, pExternalFenceInfo: *VkPhysicalDeviceExternalFenceInfo, pExternalFenceProperties: *VkExternalFenceProperties);
    VkResult vkImportFenceFdKHR(device: *VkDevice_T, pImportFenceFdInfo: *VkImportFenceFdInfoKHR);
    VkResult vkGetFenceFdKHR(device: *VkDevice_T, pGetFdInfo: *VkFenceGetFdInfoKHR, pFd: *int32);
    VkResult vkEnumeratePhysicalDeviceQueueFamilyPerformanceQueryCountersKHR(physicalDevice: *VkPhysicalDevice_T, queueFamilyIndex: uint32, pCounterCount: *uint32, pCounters: *VkPerformanceCounterKHR, pCounterDescriptions: *VkPerformanceCounterDescriptionKHR);
    void vkGetPhysicalDeviceQueueFamilyPerformanceQueryPassesKHR(physicalDevice: *VkPhysicalDevice_T, pPerformanceQueryCreateInfo: *VkQueryPoolPerformanceCreateInfoKHR, pNumPasses: *uint32);
    VkResult vkAcquireProfilingLockKHR(device: *VkDevice_T, pInfo: *VkAcquireProfilingLockInfoKHR);
    void vkReleaseProfilingLockKHR(device: *VkDevice_T);
    VkResult vkGetPhysicalDeviceSurfaceCapabilities2KHR(physicalDevice: *VkPhysicalDevice_T, pSurfaceInfo: *VkPhysicalDeviceSurfaceInfo2KHR, pSurfaceCapabilities: *VkSurfaceCapabilities2KHR);
    VkResult vkGetPhysicalDeviceSurfaceFormats2KHR(physicalDevice: *VkPhysicalDevice_T, pSurfaceInfo: *VkPhysicalDeviceSurfaceInfo2KHR, pSurfaceFormatCount: *uint32, pSurfaceFormats: *VkSurfaceFormat2KHR);
    VkResult vkGetPhysicalDeviceDisplayProperties2KHR(physicalDevice: *VkPhysicalDevice_T, pPropertyCount: *uint32, pProperties: *VkDisplayProperties2KHR);
    VkResult vkGetPhysicalDeviceDisplayPlaneProperties2KHR(physicalDevice: *VkPhysicalDevice_T, pPropertyCount: *uint32, pProperties: *VkDisplayPlaneProperties2KHR);
    VkResult vkGetDisplayModeProperties2KHR(physicalDevice: *VkPhysicalDevice_T, display: *VkDisplayKHR_T, pPropertyCount: *uint32, pProperties: *VkDisplayModeProperties2KHR);
    VkResult vkGetDisplayPlaneCapabilities2KHR(physicalDevice: *VkPhysicalDevice_T, pDisplayPlaneInfo: *VkDisplayPlaneInfo2KHR, pCapabilities: *VkDisplayPlaneCapabilities2KHR);
    void vkGetImageMemoryRequirements2KHR(device: *VkDevice_T, pInfo: *VkImageMemoryRequirementsInfo2, pMemoryRequirements: *VkMemoryRequirements2);
    void vkGetBufferMemoryRequirements2KHR(device: *VkDevice_T, pInfo: *VkBufferMemoryRequirementsInfo2, pMemoryRequirements: *VkMemoryRequirements2);
    void vkGetImageSparseMemoryRequirements2KHR(device: *VkDevice_T, pInfo: *VkImageSparseMemoryRequirementsInfo2, pSparseMemoryRequirementCount: *uint32, pSparseMemoryRequirements: *VkSparseImageMemoryRequirements2);
    VkResult vkCreateSamplerYcbcrConversionKHR(device: *VkDevice_T, pCreateInfo: *VkSamplerYcbcrConversionCreateInfo, pAllocator: *VkAllocationCallbacks, pYcbcrConversion: **VkSamplerYcbcrConversion_T);
    void vkDestroySamplerYcbcrConversionKHR(device: *VkDevice_T, ycbcrConversion: *VkSamplerYcbcrConversion_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkBindBufferMemory2KHR(device: *VkDevice_T, bindInfoCount: uint32, pBindInfos: *VkBindBufferMemoryInfo);
    VkResult vkBindImageMemory2KHR(device: *VkDevice_T, bindInfoCount: uint32, pBindInfos: *VkBindImageMemoryInfo);
    void vkGetDescriptorSetLayoutSupportKHR(device: *VkDevice_T, pCreateInfo: *VkDescriptorSetLayoutCreateInfo, pSupport: *VkDescriptorSetLayoutSupport);
    void vkCmdDrawIndirectCountKHR(commandBuffer: *VkCommandBuffer_T, buffer: *VkBuffer_T, offset: uint64, countBuffer: *VkBuffer_T, countBufferOffset: uint64, maxDrawCount: uint32, stride: uint32);
    void vkCmdDrawIndexedIndirectCountKHR(commandBuffer: *VkCommandBuffer_T, buffer: *VkBuffer_T, offset: uint64, countBuffer: *VkBuffer_T, countBufferOffset: uint64, maxDrawCount: uint32, stride: uint32);
    VkResult vkGetSemaphoreCounterValueKHR(device: *VkDevice_T, semaphore: *VkSemaphore_T, pValue: *uint64);
    VkResult vkWaitSemaphoresKHR(device: *VkDevice_T, pWaitInfo: *VkSemaphoreWaitInfo, timeout: uint64);
    VkResult vkSignalSemaphoreKHR(device: *VkDevice_T, pSignalInfo: *VkSemaphoreSignalInfo);
    VkResult vkGetPhysicalDeviceFragmentShadingRatesKHR(physicalDevice: *VkPhysicalDevice_T, pFragmentShadingRateCount: *uint32, pFragmentShadingRates: *VkPhysicalDeviceFragmentShadingRateKHR);
    void vkCmdSetFragmentShadingRateKHR(commandBuffer: *VkCommandBuffer_T, pFragmentSize: *VkExtent2D, combinerOps: [2]VkFragmentShadingRateCombinerOpKHR);
    void vkCmdSetRenderingAttachmentLocationsKHR(commandBuffer: *VkCommandBuffer_T, pLocationInfo: *VkRenderingAttachmentLocationInfo);
    void vkCmdSetRenderingInputAttachmentIndicesKHR(commandBuffer: *VkCommandBuffer_T, pInputAttachmentIndexInfo: *VkRenderingInputAttachmentIndexInfo);
    VkResult vkWaitForPresentKHR(device: *VkDevice_T, swapchain: *VkSwapchainKHR_T, presentId: uint64, timeout: uint64);
    uint64 vkGetBufferDeviceAddressKHR(device: *VkDevice_T, pInfo: *VkBufferDeviceAddressInfo);
    uint64 vkGetBufferOpaqueCaptureAddressKHR(device: *VkDevice_T, pInfo: *VkBufferDeviceAddressInfo);
    uint64 vkGetDeviceMemoryOpaqueCaptureAddressKHR(device: *VkDevice_T, pInfo: *VkDeviceMemoryOpaqueCaptureAddressInfo);
    VkResult vkCreateDeferredOperationKHR(device: *VkDevice_T, pAllocator: *VkAllocationCallbacks, pDeferredOperation: **VkDeferredOperationKHR_T);
    void vkDestroyDeferredOperationKHR(device: *VkDevice_T, operation: *VkDeferredOperationKHR_T, pAllocator: *VkAllocationCallbacks);
    uint32 vkGetDeferredOperationMaxConcurrencyKHR(device: *VkDevice_T, operation: *VkDeferredOperationKHR_T);
    VkResult vkGetDeferredOperationResultKHR(device: *VkDevice_T, operation: *VkDeferredOperationKHR_T);
    VkResult vkDeferredOperationJoinKHR(device: *VkDevice_T, operation: *VkDeferredOperationKHR_T);
    VkResult vkGetPipelineExecutablePropertiesKHR(device: *VkDevice_T, pPipelineInfo: *VkPipelineInfoKHR, pExecutableCount: *uint32, pProperties: *VkPipelineExecutablePropertiesKHR);
    VkResult vkGetPipelineExecutableStatisticsKHR(device: *VkDevice_T, pExecutableInfo: *VkPipelineExecutableInfoKHR, pStatisticCount: *uint32, pStatistics: *VkPipelineExecutableStatisticKHR);
    VkResult vkGetPipelineExecutableInternalRepresentationsKHR(device: *VkDevice_T, pExecutableInfo: *VkPipelineExecutableInfoKHR, pInternalRepresentationCount: *uint32, pInternalRepresentations: *VkPipelineExecutableInternalRepresentationKHR);
    VkResult vkMapMemory2KHR(device: *VkDevice_T, pMemoryMapInfo: *VkMemoryMapInfo, ppData: **void);
    VkResult vkUnmapMemory2KHR(device: *VkDevice_T, pMemoryUnmapInfo: *VkMemoryUnmapInfo);
    VkResult vkGetPhysicalDeviceVideoEncodeQualityLevelPropertiesKHR(physicalDevice: *VkPhysicalDevice_T, pQualityLevelInfo: *VkPhysicalDeviceVideoEncodeQualityLevelInfoKHR, pQualityLevelProperties: *VkVideoEncodeQualityLevelPropertiesKHR);
    VkResult vkGetEncodedVideoSessionParametersKHR(device: *VkDevice_T, pVideoSessionParametersInfo: *VkVideoEncodeSessionParametersGetInfoKHR, pFeedbackInfo: *VkVideoEncodeSessionParametersFeedbackInfoKHR, pDataSize: *uint64, pData: *void);
    void vkCmdEncodeVideoKHR(commandBuffer: *VkCommandBuffer_T, pEncodeInfo: *VkVideoEncodeInfoKHR);
    void vkCmdSetEvent2KHR(commandBuffer: *VkCommandBuffer_T, event: *VkEvent_T, pDependencyInfo: *VkDependencyInfo);
    void vkCmdResetEvent2KHR(commandBuffer: *VkCommandBuffer_T, event: *VkEvent_T, stageMask: uint64);
    void vkCmdWaitEvents2KHR(commandBuffer: *VkCommandBuffer_T, eventCount: uint32, pEvents: **VkEvent_T, pDependencyInfos: *VkDependencyInfo);
    void vkCmdPipelineBarrier2KHR(commandBuffer: *VkCommandBuffer_T, pDependencyInfo: *VkDependencyInfo);
    void vkCmdWriteTimestamp2KHR(commandBuffer: *VkCommandBuffer_T, stage: uint64, queryPool: *VkQueryPool_T, query: uint32);
    VkResult vkQueueSubmit2KHR(queue: *VkQueue_T, submitCount: uint32, pSubmits: *VkSubmitInfo2, fence: *VkFence_T);
    void vkCmdCopyBuffer2KHR(commandBuffer: *VkCommandBuffer_T, pCopyBufferInfo: *VkCopyBufferInfo2);
    void vkCmdCopyImage2KHR(commandBuffer: *VkCommandBuffer_T, pCopyImageInfo: *VkCopyImageInfo2);
    void vkCmdCopyBufferToImage2KHR(commandBuffer: *VkCommandBuffer_T, pCopyBufferToImageInfo: *VkCopyBufferToImageInfo2);
    void vkCmdCopyImageToBuffer2KHR(commandBuffer: *VkCommandBuffer_T, pCopyImageToBufferInfo: *VkCopyImageToBufferInfo2);
    void vkCmdBlitImage2KHR(commandBuffer: *VkCommandBuffer_T, pBlitImageInfo: *VkBlitImageInfo2);
    void vkCmdResolveImage2KHR(commandBuffer: *VkCommandBuffer_T, pResolveImageInfo: *VkResolveImageInfo2);
    void vkCmdTraceRaysIndirect2KHR(commandBuffer: *VkCommandBuffer_T, indirectDeviceAddress: uint64);
    void vkGetDeviceBufferMemoryRequirementsKHR(device: *VkDevice_T, pInfo: *VkDeviceBufferMemoryRequirements, pMemoryRequirements: *VkMemoryRequirements2);
    void vkGetDeviceImageMemoryRequirementsKHR(device: *VkDevice_T, pInfo: *VkDeviceImageMemoryRequirements, pMemoryRequirements: *VkMemoryRequirements2);
    void vkGetDeviceImageSparseMemoryRequirementsKHR(device: *VkDevice_T, pInfo: *VkDeviceImageMemoryRequirements, pSparseMemoryRequirementCount: *uint32, pSparseMemoryRequirements: *VkSparseImageMemoryRequirements2);
    void vkCmdBindIndexBuffer2KHR(commandBuffer: *VkCommandBuffer_T, buffer: *VkBuffer_T, offset: uint64, size: uint64, indexType: VkIndexType);
    void vkGetRenderingAreaGranularityKHR(device: *VkDevice_T, pRenderingAreaInfo: *VkRenderingAreaInfo, pGranularity: *VkExtent2D);
    void vkGetDeviceImageSubresourceLayoutKHR(device: *VkDevice_T, pInfo: *VkDeviceImageSubresourceInfo, pLayout: *VkSubresourceLayout2);
    void vkGetImageSubresourceLayout2KHR(device: *VkDevice_T, image: *VkImage_T, pSubresource: *VkImageSubresource2, pLayout: *VkSubresourceLayout2);
    VkResult vkCreatePipelineBinariesKHR(device: *VkDevice_T, pCreateInfo: *VkPipelineBinaryCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pBinaries: *VkPipelineBinaryHandlesInfoKHR);
    void vkDestroyPipelineBinaryKHR(device: *VkDevice_T, pipelineBinary: *VkPipelineBinaryKHR_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetPipelineKeyKHR(device: *VkDevice_T, pPipelineCreateInfo: *VkPipelineCreateInfoKHR, pPipelineKey: *VkPipelineBinaryKeyKHR);
    VkResult vkGetPipelineBinaryDataKHR(device: *VkDevice_T, pInfo: *VkPipelineBinaryDataInfoKHR, pPipelineBinaryKey: *VkPipelineBinaryKeyKHR, pPipelineBinaryDataSize: *uint64, pPipelineBinaryData: *void);
    VkResult vkReleaseCapturedPipelineDataKHR(device: *VkDevice_T, pInfo: *VkReleaseCapturedPipelineDataInfoKHR, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetPhysicalDeviceCooperativeMatrixPropertiesKHR(physicalDevice: *VkPhysicalDevice_T, pPropertyCount: *uint32, pProperties: *VkCooperativeMatrixPropertiesKHR);
    void vkCmdSetLineStippleKHR(commandBuffer: *VkCommandBuffer_T, lineStippleFactor: uint32, lineStipplePattern: uint16);
    VkResult vkGetPhysicalDeviceCalibrateableTimeDomainsKHR(physicalDevice: *VkPhysicalDevice_T, pTimeDomainCount: *uint32, pTimeDomains: *VkTimeDomainKHR);
    VkResult vkGetCalibratedTimestampsKHR(device: *VkDevice_T, timestampCount: uint32, pTimestampInfos: *VkCalibratedTimestampInfoKHR, pTimestamps: *uint64, pMaxDeviation: *uint64);
    void vkCmdBindDescriptorSets2KHR(commandBuffer: *VkCommandBuffer_T, pBindDescriptorSetsInfo: *VkBindDescriptorSetsInfo);
    void vkCmdPushConstants2KHR(commandBuffer: *VkCommandBuffer_T, pPushConstantsInfo: *VkPushConstantsInfo);
    void vkCmdPushDescriptorSet2KHR(commandBuffer: *VkCommandBuffer_T, pPushDescriptorSetInfo: *VkPushDescriptorSetInfo);
    void vkCmdPushDescriptorSetWithTemplate2KHR(commandBuffer: *VkCommandBuffer_T, pPushDescriptorSetWithTemplateInfo: *VkPushDescriptorSetWithTemplateInfo);
    void vkCmdSetDescriptorBufferOffsets2EXT(commandBuffer: *VkCommandBuffer_T, pSetDescriptorBufferOffsetsInfo: *VkSetDescriptorBufferOffsetsInfoEXT);
    void vkCmdBindDescriptorBufferEmbeddedSamplers2EXT(commandBuffer: *VkCommandBuffer_T, pBindDescriptorBufferEmbeddedSamplersInfo: *VkBindDescriptorBufferEmbeddedSamplersInfoEXT);
    VkResult vkCreateDebugReportCallbackEXT(instance: *VkInstance_T, pCreateInfo: *VkDebugReportCallbackCreateInfoEXT, pAllocator: *VkAllocationCallbacks, pCallback: **VkDebugReportCallbackEXT_T);
    void vkDestroyDebugReportCallbackEXT(instance: *VkInstance_T, callback: *VkDebugReportCallbackEXT_T, pAllocator: *VkAllocationCallbacks);
    void vkDebugReportMessageEXT(instance: *VkInstance_T, flags: uint32, objectType: VkDebugReportObjectTypeEXT, object: uint64, location: uint64, messageCode: int32, pLayerPrefix: *byte, pMessage: *byte);
    VkResult vkDebugMarkerSetObjectTagEXT(device: *VkDevice_T, pTagInfo: *VkDebugMarkerObjectTagInfoEXT);
    VkResult vkDebugMarkerSetObjectNameEXT(device: *VkDevice_T, pNameInfo: *VkDebugMarkerObjectNameInfoEXT);
    void vkCmdDebugMarkerBeginEXT(commandBuffer: *VkCommandBuffer_T, pMarkerInfo: *VkDebugMarkerMarkerInfoEXT);
    void vkCmdDebugMarkerEndEXT(commandBuffer: *VkCommandBuffer_T);
    void vkCmdDebugMarkerInsertEXT(commandBuffer: *VkCommandBuffer_T, pMarkerInfo: *VkDebugMarkerMarkerInfoEXT);
    void vkCmdBindTransformFeedbackBuffersEXT(commandBuffer: *VkCommandBuffer_T, firstBinding: uint32, bindingCount: uint32, pBuffers: **VkBuffer_T, pOffsets: *uint64, pSizes: *uint64);
    void vkCmdBeginTransformFeedbackEXT(commandBuffer: *VkCommandBuffer_T, firstCounterBuffer: uint32, counterBufferCount: uint32, pCounterBuffers: **VkBuffer_T, pCounterBufferOffsets: *uint64);
    void vkCmdEndTransformFeedbackEXT(commandBuffer: *VkCommandBuffer_T, firstCounterBuffer: uint32, counterBufferCount: uint32, pCounterBuffers: **VkBuffer_T, pCounterBufferOffsets: *uint64);
    void vkCmdBeginQueryIndexedEXT(commandBuffer: *VkCommandBuffer_T, queryPool: *VkQueryPool_T, query: uint32, flags: uint32, index: uint32);
    void vkCmdEndQueryIndexedEXT(commandBuffer: *VkCommandBuffer_T, queryPool: *VkQueryPool_T, query: uint32, index: uint32);
    void vkCmdDrawIndirectByteCountEXT(commandBuffer: *VkCommandBuffer_T, instanceCount: uint32, firstInstance: uint32, counterBuffer: *VkBuffer_T, counterBufferOffset: uint64, counterOffset: uint32, vertexStride: uint32);
    VkResult vkCreateCuModuleNVX(device: *VkDevice_T, pCreateInfo: *VkCuModuleCreateInfoNVX, pAllocator: *VkAllocationCallbacks, pModule: **VkCuModuleNVX_T);
    VkResult vkCreateCuFunctionNVX(device: *VkDevice_T, pCreateInfo: *VkCuFunctionCreateInfoNVX, pAllocator: *VkAllocationCallbacks, pFunction: **VkCuFunctionNVX_T);
    void vkDestroyCuModuleNVX(device: *VkDevice_T, module: *VkCuModuleNVX_T, pAllocator: *VkAllocationCallbacks);
    void vkDestroyCuFunctionNVX(device: *VkDevice_T, function: *VkCuFunctionNVX_T, pAllocator: *VkAllocationCallbacks);
    void vkCmdCuLaunchKernelNVX(commandBuffer: *VkCommandBuffer_T, pLaunchInfo: *VkCuLaunchInfoNVX);
    uint32 vkGetImageViewHandleNVX(device: *VkDevice_T, pInfo: *VkImageViewHandleInfoNVX);
    uint64 vkGetImageViewHandle64NVX(device: *VkDevice_T, pInfo: *VkImageViewHandleInfoNVX);
    VkResult vkGetImageViewAddressNVX(device: *VkDevice_T, imageView: *VkImageView_T, pProperties: *VkImageViewAddressPropertiesNVX);
    void vkCmdDrawIndirectCountAMD(commandBuffer: *VkCommandBuffer_T, buffer: *VkBuffer_T, offset: uint64, countBuffer: *VkBuffer_T, countBufferOffset: uint64, maxDrawCount: uint32, stride: uint32);
    void vkCmdDrawIndexedIndirectCountAMD(commandBuffer: *VkCommandBuffer_T, buffer: *VkBuffer_T, offset: uint64, countBuffer: *VkBuffer_T, countBufferOffset: uint64, maxDrawCount: uint32, stride: uint32);
    VkResult vkGetShaderInfoAMD(device: *VkDevice_T, pipeline: *VkPipeline_T, shaderStage: VkShaderStageFlagBits, infoType: VkShaderInfoTypeAMD, pInfoSize: *uint64, pInfo: *void);
    VkResult vkGetPhysicalDeviceExternalImageFormatPropertiesNV(physicalDevice: *VkPhysicalDevice_T, format: VkFormat, type: VkImageType, tiling: VkImageTiling, usage: uint32, flags: uint32, externalHandleType: uint32, pExternalImageFormatProperties: *VkExternalImageFormatPropertiesNV);
    void vkCmdBeginConditionalRenderingEXT(commandBuffer: *VkCommandBuffer_T, pConditionalRenderingBegin: *VkConditionalRenderingBeginInfoEXT);
    void vkCmdEndConditionalRenderingEXT(commandBuffer: *VkCommandBuffer_T);
    void vkCmdSetViewportWScalingNV(commandBuffer: *VkCommandBuffer_T, firstViewport: uint32, viewportCount: uint32, pViewportWScalings: *VkViewportWScalingNV);
    VkResult vkReleaseDisplayEXT(physicalDevice: *VkPhysicalDevice_T, display: *VkDisplayKHR_T);
    VkResult vkGetPhysicalDeviceSurfaceCapabilities2EXT(physicalDevice: *VkPhysicalDevice_T, surface: *VkSurfaceKHR_T, pSurfaceCapabilities: *VkSurfaceCapabilities2EXT);
    VkResult vkDisplayPowerControlEXT(device: *VkDevice_T, display: *VkDisplayKHR_T, pDisplayPowerInfo: *VkDisplayPowerInfoEXT);
    VkResult vkRegisterDeviceEventEXT(device: *VkDevice_T, pDeviceEventInfo: *VkDeviceEventInfoEXT, pAllocator: *VkAllocationCallbacks, pFence: **VkFence_T);
    VkResult vkRegisterDisplayEventEXT(device: *VkDevice_T, display: *VkDisplayKHR_T, pDisplayEventInfo: *VkDisplayEventInfoEXT, pAllocator: *VkAllocationCallbacks, pFence: **VkFence_T);
    VkResult vkGetSwapchainCounterEXT(device: *VkDevice_T, swapchain: *VkSwapchainKHR_T, counter: VkSurfaceCounterFlagBitsEXT, pCounterValue: *uint64);
    VkResult vkGetRefreshCycleDurationGOOGLE(device: *VkDevice_T, swapchain: *VkSwapchainKHR_T, pDisplayTimingProperties: *VkRefreshCycleDurationGOOGLE);
    VkResult vkGetPastPresentationTimingGOOGLE(device: *VkDevice_T, swapchain: *VkSwapchainKHR_T, pPresentationTimingCount: *uint32, pPresentationTimings: *VkPastPresentationTimingGOOGLE);
    void vkCmdSetDiscardRectangleEXT(commandBuffer: *VkCommandBuffer_T, firstDiscardRectangle: uint32, discardRectangleCount: uint32, pDiscardRectangles: *VkRect2D);
    void vkCmdSetDiscardRectangleEnableEXT(commandBuffer: *VkCommandBuffer_T, discardRectangleEnable: uint32);
    void vkCmdSetDiscardRectangleModeEXT(commandBuffer: *VkCommandBuffer_T, discardRectangleMode: VkDiscardRectangleModeEXT);
    void vkSetHdrMetadataEXT(device: *VkDevice_T, swapchainCount: uint32, pSwapchains: **VkSwapchainKHR_T, pMetadata: *VkHdrMetadataEXT);
    VkResult vkSetDebugUtilsObjectNameEXT(device: *VkDevice_T, pNameInfo: *VkDebugUtilsObjectNameInfoEXT);
    VkResult vkSetDebugUtilsObjectTagEXT(device: *VkDevice_T, pTagInfo: *VkDebugUtilsObjectTagInfoEXT);
    void vkQueueBeginDebugUtilsLabelEXT(queue: *VkQueue_T, pLabelInfo: *VkDebugUtilsLabelEXT);
    void vkQueueEndDebugUtilsLabelEXT(queue: *VkQueue_T);
    void vkQueueInsertDebugUtilsLabelEXT(queue: *VkQueue_T, pLabelInfo: *VkDebugUtilsLabelEXT);
    void vkCmdBeginDebugUtilsLabelEXT(commandBuffer: *VkCommandBuffer_T, pLabelInfo: *VkDebugUtilsLabelEXT);
    void vkCmdEndDebugUtilsLabelEXT(commandBuffer: *VkCommandBuffer_T);
    void vkCmdInsertDebugUtilsLabelEXT(commandBuffer: *VkCommandBuffer_T, pLabelInfo: *VkDebugUtilsLabelEXT);
    VkResult vkCreateDebugUtilsMessengerEXT(instance: *VkInstance_T, pCreateInfo: *VkDebugUtilsMessengerCreateInfoEXT, pAllocator: *VkAllocationCallbacks, pMessenger: **VkDebugUtilsMessengerEXT_T);
    void vkDestroyDebugUtilsMessengerEXT(instance: *VkInstance_T, messenger: *VkDebugUtilsMessengerEXT_T, pAllocator: *VkAllocationCallbacks);
    void vkSubmitDebugUtilsMessageEXT(instance: *VkInstance_T, messageSeverity: VkDebugUtilsMessageSeverityFlagBitsEXT, messageTypes: uint32, pCallbackData: *VkDebugUtilsMessengerCallbackDataEXT);
    void vkCmdSetSampleLocationsEXT(commandBuffer: *VkCommandBuffer_T, pSampleLocationsInfo: *VkSampleLocationsInfoEXT);
    void vkGetPhysicalDeviceMultisamplePropertiesEXT(physicalDevice: *VkPhysicalDevice_T, samples: VkSampleCountFlagBits, pMultisampleProperties: *VkMultisamplePropertiesEXT);
    VkResult vkGetImageDrmFormatModifierPropertiesEXT(device: *VkDevice_T, image: *VkImage_T, pProperties: *VkImageDrmFormatModifierPropertiesEXT);
    VkResult vkCreateValidationCacheEXT(device: *VkDevice_T, pCreateInfo: *VkValidationCacheCreateInfoEXT, pAllocator: *VkAllocationCallbacks, pValidationCache: **VkValidationCacheEXT_T);
    void vkDestroyValidationCacheEXT(device: *VkDevice_T, validationCache: *VkValidationCacheEXT_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkMergeValidationCachesEXT(device: *VkDevice_T, dstCache: *VkValidationCacheEXT_T, srcCacheCount: uint32, pSrcCaches: **VkValidationCacheEXT_T);
    VkResult vkGetValidationCacheDataEXT(device: *VkDevice_T, validationCache: *VkValidationCacheEXT_T, pDataSize: *uint64, pData: *void);
    void vkCmdBindShadingRateImageNV(commandBuffer: *VkCommandBuffer_T, imageView: *VkImageView_T, imageLayout: VkImageLayout);
    void vkCmdSetViewportShadingRatePaletteNV(commandBuffer: *VkCommandBuffer_T, firstViewport: uint32, viewportCount: uint32, pShadingRatePalettes: *VkShadingRatePaletteNV);
    void vkCmdSetCoarseSampleOrderNV(commandBuffer: *VkCommandBuffer_T, sampleOrderType: VkCoarseSampleOrderTypeNV, customSampleOrderCount: uint32, pCustomSampleOrders: *VkCoarseSampleOrderCustomNV);
    VkResult vkCreateAccelerationStructureNV(device: *VkDevice_T, pCreateInfo: *VkAccelerationStructureCreateInfoNV, pAllocator: *VkAllocationCallbacks, pAccelerationStructure: **VkAccelerationStructureNV_T);
    void vkDestroyAccelerationStructureNV(device: *VkDevice_T, accelerationStructure: *VkAccelerationStructureNV_T, pAllocator: *VkAllocationCallbacks);
    void vkGetAccelerationStructureMemoryRequirementsNV(device: *VkDevice_T, pInfo: *VkAccelerationStructureMemoryRequirementsInfoNV, pMemoryRequirements: *VkMemoryRequirements2);
    VkResult vkBindAccelerationStructureMemoryNV(device: *VkDevice_T, bindInfoCount: uint32, pBindInfos: *VkBindAccelerationStructureMemoryInfoNV);
    void vkCmdBuildAccelerationStructureNV(commandBuffer: *VkCommandBuffer_T, pInfo: *VkAccelerationStructureInfoNV, instanceData: *VkBuffer_T, instanceOffset: uint64, update: uint32, dst: *VkAccelerationStructureNV_T, src: *VkAccelerationStructureNV_T, scratch: *VkBuffer_T, scratchOffset: uint64);
    void vkCmdCopyAccelerationStructureNV(commandBuffer: *VkCommandBuffer_T, dst: *VkAccelerationStructureNV_T, src: *VkAccelerationStructureNV_T, mode: VkCopyAccelerationStructureModeKHR);
    void vkCmdTraceRaysNV(commandBuffer: *VkCommandBuffer_T, raygenShaderBindingTableBuffer: *VkBuffer_T, raygenShaderBindingOffset: uint64, missShaderBindingTableBuffer: *VkBuffer_T, missShaderBindingOffset: uint64, missShaderBindingStride: uint64, hitShaderBindingTableBuffer: *VkBuffer_T, hitShaderBindingOffset: uint64, hitShaderBindingStride: uint64, callableShaderBindingTableBuffer: *VkBuffer_T, callableShaderBindingOffset: uint64, callableShaderBindingStride: uint64, width: uint32, height: uint32, depth: uint32);
    VkResult vkCreateRayTracingPipelinesNV(device: *VkDevice_T, pipelineCache: *VkPipelineCache_T, createInfoCount: uint32, pCreateInfos: *VkRayTracingPipelineCreateInfoNV, pAllocator: *VkAllocationCallbacks, pPipelines: **VkPipeline_T);
    VkResult vkGetRayTracingShaderGroupHandlesKHR(device: *VkDevice_T, pipeline: *VkPipeline_T, firstGroup: uint32, groupCount: uint32, dataSize: uint64, pData: *void);
    VkResult vkGetRayTracingShaderGroupHandlesNV(device: *VkDevice_T, pipeline: *VkPipeline_T, firstGroup: uint32, groupCount: uint32, dataSize: uint64, pData: *void);
    VkResult vkGetAccelerationStructureHandleNV(device: *VkDevice_T, accelerationStructure: *VkAccelerationStructureNV_T, dataSize: uint64, pData: *void);
    void vkCmdWriteAccelerationStructuresPropertiesNV(commandBuffer: *VkCommandBuffer_T, accelerationStructureCount: uint32, pAccelerationStructures: **VkAccelerationStructureNV_T, queryType: VkQueryType, queryPool: *VkQueryPool_T, firstQuery: uint32);
    VkResult vkCompileDeferredNV(device: *VkDevice_T, pipeline: *VkPipeline_T, shader: uint32);
    VkResult vkGetMemoryHostPointerPropertiesEXT(device: *VkDevice_T, handleType: VkExternalMemoryHandleTypeFlagBits, pHostPointer: *void, pMemoryHostPointerProperties: *VkMemoryHostPointerPropertiesEXT);
    void vkCmdWriteBufferMarkerAMD(commandBuffer: *VkCommandBuffer_T, pipelineStage: VkPipelineStageFlagBits, dstBuffer: *VkBuffer_T, dstOffset: uint64, marker: uint32);
    void vkCmdWriteBufferMarker2AMD(commandBuffer: *VkCommandBuffer_T, stage: uint64, dstBuffer: *VkBuffer_T, dstOffset: uint64, marker: uint32);
    VkResult vkGetPhysicalDeviceCalibrateableTimeDomainsEXT(physicalDevice: *VkPhysicalDevice_T, pTimeDomainCount: *uint32, pTimeDomains: *VkTimeDomainKHR);
    VkResult vkGetCalibratedTimestampsEXT(device: *VkDevice_T, timestampCount: uint32, pTimestampInfos: *VkCalibratedTimestampInfoKHR, pTimestamps: *uint64, pMaxDeviation: *uint64);
    void vkCmdDrawMeshTasksNV(commandBuffer: *VkCommandBuffer_T, taskCount: uint32, firstTask: uint32);
    void vkCmdDrawMeshTasksIndirectNV(commandBuffer: *VkCommandBuffer_T, buffer: *VkBuffer_T, offset: uint64, drawCount: uint32, stride: uint32);
    void vkCmdDrawMeshTasksIndirectCountNV(commandBuffer: *VkCommandBuffer_T, buffer: *VkBuffer_T, offset: uint64, countBuffer: *VkBuffer_T, countBufferOffset: uint64, maxDrawCount: uint32, stride: uint32);
    void vkCmdSetExclusiveScissorEnableNV(commandBuffer: *VkCommandBuffer_T, firstExclusiveScissor: uint32, exclusiveScissorCount: uint32, pExclusiveScissorEnables: *uint32);
    void vkCmdSetExclusiveScissorNV(commandBuffer: *VkCommandBuffer_T, firstExclusiveScissor: uint32, exclusiveScissorCount: uint32, pExclusiveScissors: *VkRect2D);
    void vkCmdSetCheckpointNV(commandBuffer: *VkCommandBuffer_T, pCheckpointMarker: *void);
    void vkGetQueueCheckpointDataNV(queue: *VkQueue_T, pCheckpointDataCount: *uint32, pCheckpointData: *VkCheckpointDataNV);
    void vkGetQueueCheckpointData2NV(queue: *VkQueue_T, pCheckpointDataCount: *uint32, pCheckpointData: *VkCheckpointData2NV);
    VkResult vkInitializePerformanceApiINTEL(device: *VkDevice_T, pInitializeInfo: *VkInitializePerformanceApiInfoINTEL);
    void vkUninitializePerformanceApiINTEL(device: *VkDevice_T);
    VkResult vkCmdSetPerformanceMarkerINTEL(commandBuffer: *VkCommandBuffer_T, pMarkerInfo: *VkPerformanceMarkerInfoINTEL);
    VkResult vkCmdSetPerformanceStreamMarkerINTEL(commandBuffer: *VkCommandBuffer_T, pMarkerInfo: *VkPerformanceStreamMarkerInfoINTEL);
    VkResult vkCmdSetPerformanceOverrideINTEL(commandBuffer: *VkCommandBuffer_T, pOverrideInfo: *VkPerformanceOverrideInfoINTEL);
    VkResult vkAcquirePerformanceConfigurationINTEL(device: *VkDevice_T, pAcquireInfo: *VkPerformanceConfigurationAcquireInfoINTEL, pConfiguration: **VkPerformanceConfigurationINTEL_T);
    VkResult vkReleasePerformanceConfigurationINTEL(device: *VkDevice_T, configuration: *VkPerformanceConfigurationINTEL_T);
    VkResult vkQueueSetPerformanceConfigurationINTEL(queue: *VkQueue_T, configuration: *VkPerformanceConfigurationINTEL_T);
    VkResult vkGetPerformanceParameterINTEL(device: *VkDevice_T, parameter: VkPerformanceParameterTypeINTEL, pValue: *VkPerformanceValueINTEL);
    void vkSetLocalDimmingAMD(device: *VkDevice_T, swapChain: *VkSwapchainKHR_T, localDimmingEnable: uint32);
    uint64 vkGetBufferDeviceAddressEXT(device: *VkDevice_T, pInfo: *VkBufferDeviceAddressInfo);
    VkResult vkGetPhysicalDeviceToolPropertiesEXT(physicalDevice: *VkPhysicalDevice_T, pToolCount: *uint32, pToolProperties: *VkPhysicalDeviceToolProperties);
    VkResult vkGetPhysicalDeviceCooperativeMatrixPropertiesNV(physicalDevice: *VkPhysicalDevice_T, pPropertyCount: *uint32, pProperties: *VkCooperativeMatrixPropertiesNV);
    VkResult vkGetPhysicalDeviceSupportedFramebufferMixedSamplesCombinationsNV(physicalDevice: *VkPhysicalDevice_T, pCombinationCount: *uint32, pCombinations: *VkFramebufferMixedSamplesCombinationNV);
    VkResult vkCreateHeadlessSurfaceEXT(instance: *VkInstance_T, pCreateInfo: *VkHeadlessSurfaceCreateInfoEXT, pAllocator: *VkAllocationCallbacks, pSurface: **VkSurfaceKHR_T);
    void vkCmdSetLineStippleEXT(commandBuffer: *VkCommandBuffer_T, lineStippleFactor: uint32, lineStipplePattern: uint16);
    void vkResetQueryPoolEXT(device: *VkDevice_T, queryPool: *VkQueryPool_T, firstQuery: uint32, queryCount: uint32);
    void vkCmdSetCullModeEXT(commandBuffer: *VkCommandBuffer_T, cullMode: uint32);
    void vkCmdSetFrontFaceEXT(commandBuffer: *VkCommandBuffer_T, frontFace: VkFrontFace);
    void vkCmdSetPrimitiveTopologyEXT(commandBuffer: *VkCommandBuffer_T, primitiveTopology: VkPrimitiveTopology);
    void vkCmdSetViewportWithCountEXT(commandBuffer: *VkCommandBuffer_T, viewportCount: uint32, pViewports: *VkViewport);
    void vkCmdSetScissorWithCountEXT(commandBuffer: *VkCommandBuffer_T, scissorCount: uint32, pScissors: *VkRect2D);
    void vkCmdBindVertexBuffers2EXT(commandBuffer: *VkCommandBuffer_T, firstBinding: uint32, bindingCount: uint32, pBuffers: **VkBuffer_T, pOffsets: *uint64, pSizes: *uint64, pStrides: *uint64);
    void vkCmdSetDepthTestEnableEXT(commandBuffer: *VkCommandBuffer_T, depthTestEnable: uint32);
    void vkCmdSetDepthWriteEnableEXT(commandBuffer: *VkCommandBuffer_T, depthWriteEnable: uint32);
    void vkCmdSetDepthCompareOpEXT(commandBuffer: *VkCommandBuffer_T, depthCompareOp: VkCompareOp);
    void vkCmdSetDepthBoundsTestEnableEXT(commandBuffer: *VkCommandBuffer_T, depthBoundsTestEnable: uint32);
    void vkCmdSetStencilTestEnableEXT(commandBuffer: *VkCommandBuffer_T, stencilTestEnable: uint32);
    void vkCmdSetStencilOpEXT(commandBuffer: *VkCommandBuffer_T, faceMask: uint32, failOp: VkStencilOp, passOp: VkStencilOp, depthFailOp: VkStencilOp, compareOp: VkCompareOp);
    VkResult vkCopyMemoryToImageEXT(device: *VkDevice_T, pCopyMemoryToImageInfo: *VkCopyMemoryToImageInfo);
    VkResult vkCopyImageToMemoryEXT(device: *VkDevice_T, pCopyImageToMemoryInfo: *VkCopyImageToMemoryInfo);
    VkResult vkCopyImageToImageEXT(device: *VkDevice_T, pCopyImageToImageInfo: *VkCopyImageToImageInfo);
    VkResult vkTransitionImageLayoutEXT(device: *VkDevice_T, transitionCount: uint32, pTransitions: *VkHostImageLayoutTransitionInfo);
    void vkGetImageSubresourceLayout2EXT(device: *VkDevice_T, image: *VkImage_T, pSubresource: *VkImageSubresource2, pLayout: *VkSubresourceLayout2);
    VkResult vkReleaseSwapchainImagesEXT(device: *VkDevice_T, pReleaseInfo: *VkReleaseSwapchainImagesInfoEXT);
    void vkGetGeneratedCommandsMemoryRequirementsNV(device: *VkDevice_T, pInfo: *VkGeneratedCommandsMemoryRequirementsInfoNV, pMemoryRequirements: *VkMemoryRequirements2);
    void vkCmdPreprocessGeneratedCommandsNV(commandBuffer: *VkCommandBuffer_T, pGeneratedCommandsInfo: *VkGeneratedCommandsInfoNV);
    void vkCmdExecuteGeneratedCommandsNV(commandBuffer: *VkCommandBuffer_T, isPreprocessed: uint32, pGeneratedCommandsInfo: *VkGeneratedCommandsInfoNV);
    void vkCmdBindPipelineShaderGroupNV(commandBuffer: *VkCommandBuffer_T, pipelineBindPoint: VkPipelineBindPoint, pipeline: *VkPipeline_T, groupIndex: uint32);
    VkResult vkCreateIndirectCommandsLayoutNV(device: *VkDevice_T, pCreateInfo: *VkIndirectCommandsLayoutCreateInfoNV, pAllocator: *VkAllocationCallbacks, pIndirectCommandsLayout: **VkIndirectCommandsLayoutNV_T);
    void vkDestroyIndirectCommandsLayoutNV(device: *VkDevice_T, indirectCommandsLayout: *VkIndirectCommandsLayoutNV_T, pAllocator: *VkAllocationCallbacks);
    void vkCmdSetDepthBias2EXT(commandBuffer: *VkCommandBuffer_T, pDepthBiasInfo: *VkDepthBiasInfoEXT);
    VkResult vkAcquireDrmDisplayEXT(physicalDevice: *VkPhysicalDevice_T, drmFd: int32, display: *VkDisplayKHR_T);
    VkResult vkGetDrmDisplayEXT(physicalDevice: *VkPhysicalDevice_T, drmFd: int32, connectorId: uint32, display: **VkDisplayKHR_T);
    VkResult vkCreatePrivateDataSlotEXT(device: *VkDevice_T, pCreateInfo: *VkPrivateDataSlotCreateInfo, pAllocator: *VkAllocationCallbacks, pPrivateDataSlot: **VkPrivateDataSlot_T);
    void vkDestroyPrivateDataSlotEXT(device: *VkDevice_T, privateDataSlot: *VkPrivateDataSlot_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkSetPrivateDataEXT(device: *VkDevice_T, objectType: VkObjectType, objectHandle: uint64, privateDataSlot: *VkPrivateDataSlot_T, data: uint64);
    void vkGetPrivateDataEXT(device: *VkDevice_T, objectType: VkObjectType, objectHandle: uint64, privateDataSlot: *VkPrivateDataSlot_T, pData: *uint64);
    VkResult vkCreateCudaModuleNV(device: *VkDevice_T, pCreateInfo: *VkCudaModuleCreateInfoNV, pAllocator: *VkAllocationCallbacks, pModule: **VkCudaModuleNV_T);
    VkResult vkGetCudaModuleCacheNV(device: *VkDevice_T, module: *VkCudaModuleNV_T, pCacheSize: *uint64, pCacheData: *void);
    VkResult vkCreateCudaFunctionNV(device: *VkDevice_T, pCreateInfo: *VkCudaFunctionCreateInfoNV, pAllocator: *VkAllocationCallbacks, pFunction: **VkCudaFunctionNV_T);
    void vkDestroyCudaModuleNV(device: *VkDevice_T, module: *VkCudaModuleNV_T, pAllocator: *VkAllocationCallbacks);
    void vkDestroyCudaFunctionNV(device: *VkDevice_T, function: *VkCudaFunctionNV_T, pAllocator: *VkAllocationCallbacks);
    void vkCmdCudaLaunchKernelNV(commandBuffer: *VkCommandBuffer_T, pLaunchInfo: *VkCudaLaunchInfoNV);
    void vkGetDescriptorSetLayoutSizeEXT(device: *VkDevice_T, layout: *VkDescriptorSetLayout_T, pLayoutSizeInBytes: *uint64);
    void vkGetDescriptorSetLayoutBindingOffsetEXT(device: *VkDevice_T, layout: *VkDescriptorSetLayout_T, binding: uint32, pOffset: *uint64);
    void vkGetDescriptorEXT(device: *VkDevice_T, pDescriptorInfo: *VkDescriptorGetInfoEXT, dataSize: uint64, pDescriptor: *void);
    void vkCmdBindDescriptorBuffersEXT(commandBuffer: *VkCommandBuffer_T, bufferCount: uint32, pBindingInfos: *VkDescriptorBufferBindingInfoEXT);
    void vkCmdSetDescriptorBufferOffsetsEXT(commandBuffer: *VkCommandBuffer_T, pipelineBindPoint: VkPipelineBindPoint, layout: *VkPipelineLayout_T, firstSet: uint32, setCount: uint32, pBufferIndices: *uint32, pOffsets: *uint64);
    void vkCmdBindDescriptorBufferEmbeddedSamplersEXT(commandBuffer: *VkCommandBuffer_T, pipelineBindPoint: VkPipelineBindPoint, layout: *VkPipelineLayout_T, set: uint32);
    VkResult vkGetBufferOpaqueCaptureDescriptorDataEXT(device: *VkDevice_T, pInfo: *VkBufferCaptureDescriptorDataInfoEXT, pData: *void);
    VkResult vkGetImageOpaqueCaptureDescriptorDataEXT(device: *VkDevice_T, pInfo: *VkImageCaptureDescriptorDataInfoEXT, pData: *void);
    VkResult vkGetImageViewOpaqueCaptureDescriptorDataEXT(device: *VkDevice_T, pInfo: *VkImageViewCaptureDescriptorDataInfoEXT, pData: *void);
    VkResult vkGetSamplerOpaqueCaptureDescriptorDataEXT(device: *VkDevice_T, pInfo: *VkSamplerCaptureDescriptorDataInfoEXT, pData: *void);
    VkResult vkGetAccelerationStructureOpaqueCaptureDescriptorDataEXT(device: *VkDevice_T, pInfo: *VkAccelerationStructureCaptureDescriptorDataInfoEXT, pData: *void);
    void vkCmdSetFragmentShadingRateEnumNV(commandBuffer: *VkCommandBuffer_T, shadingRate: VkFragmentShadingRateNV, combinerOps: [2]VkFragmentShadingRateCombinerOpKHR);
    VkResult vkGetDeviceFaultInfoEXT(device: *VkDevice_T, pFaultCounts: *VkDeviceFaultCountsEXT, pFaultInfo: *VkDeviceFaultInfoEXT);
    void vkCmdSetVertexInputEXT(commandBuffer: *VkCommandBuffer_T, vertexBindingDescriptionCount: uint32, pVertexBindingDescriptions: *VkVertexInputBindingDescription2EXT, vertexAttributeDescriptionCount: uint32, pVertexAttributeDescriptions: *VkVertexInputAttributeDescription2EXT);
    VkResult vkGetDeviceSubpassShadingMaxWorkgroupSizeHUAWEI(device: *VkDevice_T, renderpass: *VkRenderPass_T, pMaxWorkgroupSize: *VkExtent2D);
    void vkCmdSubpassShadingHUAWEI(commandBuffer: *VkCommandBuffer_T);
    void vkCmdBindInvocationMaskHUAWEI(commandBuffer: *VkCommandBuffer_T, imageView: *VkImageView_T, imageLayout: VkImageLayout);
    VkResult vkGetMemoryRemoteAddressNV(device: *VkDevice_T, pMemoryGetRemoteAddressInfo: *VkMemoryGetRemoteAddressInfoNV, pAddress: **void);
    VkResult vkGetPipelinePropertiesEXT(device: *VkDevice_T, pPipelineInfo: *VkPipelineInfoKHR, pPipelineProperties: *VkBaseOutStructure);
    void vkCmdSetPatchControlPointsEXT(commandBuffer: *VkCommandBuffer_T, patchControlPoints: uint32);
    void vkCmdSetRasterizerDiscardEnableEXT(commandBuffer: *VkCommandBuffer_T, rasterizerDiscardEnable: uint32);
    void vkCmdSetDepthBiasEnableEXT(commandBuffer: *VkCommandBuffer_T, depthBiasEnable: uint32);
    void vkCmdSetLogicOpEXT(commandBuffer: *VkCommandBuffer_T, logicOp: VkLogicOp);
    void vkCmdSetPrimitiveRestartEnableEXT(commandBuffer: *VkCommandBuffer_T, primitiveRestartEnable: uint32);
    void vkCmdSetColorWriteEnableEXT(commandBuffer: *VkCommandBuffer_T, attachmentCount: uint32, pColorWriteEnables: *uint32);
    void vkCmdDrawMultiEXT(commandBuffer: *VkCommandBuffer_T, drawCount: uint32, pVertexInfo: *VkMultiDrawInfoEXT, instanceCount: uint32, firstInstance: uint32, stride: uint32);
    void vkCmdDrawMultiIndexedEXT(commandBuffer: *VkCommandBuffer_T, drawCount: uint32, pIndexInfo: *VkMultiDrawIndexedInfoEXT, instanceCount: uint32, firstInstance: uint32, stride: uint32, pVertexOffset: *int32);
    VkResult vkCreateMicromapEXT(device: *VkDevice_T, pCreateInfo: *VkMicromapCreateInfoEXT, pAllocator: *VkAllocationCallbacks, pMicromap: **VkMicromapEXT_T);
    void vkDestroyMicromapEXT(device: *VkDevice_T, micromap: *VkMicromapEXT_T, pAllocator: *VkAllocationCallbacks);
    void vkCmdBuildMicromapsEXT(commandBuffer: *VkCommandBuffer_T, infoCount: uint32, pInfos: *VkMicromapBuildInfoEXT);
    VkResult vkBuildMicromapsEXT(device: *VkDevice_T, deferredOperation: *VkDeferredOperationKHR_T, infoCount: uint32, pInfos: *VkMicromapBuildInfoEXT);
    VkResult vkCopyMicromapEXT(device: *VkDevice_T, deferredOperation: *VkDeferredOperationKHR_T, pInfo: *VkCopyMicromapInfoEXT);
    VkResult vkCopyMicromapToMemoryEXT(device: *VkDevice_T, deferredOperation: *VkDeferredOperationKHR_T, pInfo: *VkCopyMicromapToMemoryInfoEXT);
    VkResult vkCopyMemoryToMicromapEXT(device: *VkDevice_T, deferredOperation: *VkDeferredOperationKHR_T, pInfo: *VkCopyMemoryToMicromapInfoEXT);
    VkResult vkWriteMicromapsPropertiesEXT(device: *VkDevice_T, micromapCount: uint32, pMicromaps: **VkMicromapEXT_T, queryType: VkQueryType, dataSize: uint64, pData: *void, stride: uint64);
    void vkCmdCopyMicromapEXT(commandBuffer: *VkCommandBuffer_T, pInfo: *VkCopyMicromapInfoEXT);
    void vkCmdCopyMicromapToMemoryEXT(commandBuffer: *VkCommandBuffer_T, pInfo: *VkCopyMicromapToMemoryInfoEXT);
    void vkCmdCopyMemoryToMicromapEXT(commandBuffer: *VkCommandBuffer_T, pInfo: *VkCopyMemoryToMicromapInfoEXT);
    void vkCmdWriteMicromapsPropertiesEXT(commandBuffer: *VkCommandBuffer_T, micromapCount: uint32, pMicromaps: **VkMicromapEXT_T, queryType: VkQueryType, queryPool: *VkQueryPool_T, firstQuery: uint32);
    void vkGetDeviceMicromapCompatibilityEXT(device: *VkDevice_T, pVersionInfo: *VkMicromapVersionInfoEXT, pCompatibility: *VkAccelerationStructureCompatibilityKHR);
    void vkGetMicromapBuildSizesEXT(device: *VkDevice_T, buildType: VkAccelerationStructureBuildTypeKHR, pBuildInfo: *VkMicromapBuildInfoEXT, pSizeInfo: *VkMicromapBuildSizesInfoEXT);
    void vkCmdDrawClusterHUAWEI(commandBuffer: *VkCommandBuffer_T, groupCountX: uint32, groupCountY: uint32, groupCountZ: uint32);
    void vkCmdDrawClusterIndirectHUAWEI(commandBuffer: *VkCommandBuffer_T, buffer: *VkBuffer_T, offset: uint64);
    void vkSetDeviceMemoryPriorityEXT(device: *VkDevice_T, memory: *VkDeviceMemory_T, priority: float32);
    void vkGetDescriptorSetLayoutHostMappingInfoVALVE(device: *VkDevice_T, pBindingReference: *VkDescriptorSetBindingReferenceVALVE, pHostMapping: *VkDescriptorSetLayoutHostMappingInfoVALVE);
    void vkGetDescriptorSetHostMappingVALVE(device: *VkDevice_T, descriptorSet: *VkDescriptorSet_T, ppData: **void);
    void vkCmdCopyMemoryIndirectNV(commandBuffer: *VkCommandBuffer_T, copyBufferAddress: uint64, copyCount: uint32, stride: uint32);
    void vkCmdCopyMemoryToImageIndirectNV(commandBuffer: *VkCommandBuffer_T, copyBufferAddress: uint64, copyCount: uint32, stride: uint32, dstImage: *VkImage_T, dstImageLayout: VkImageLayout, pImageSubresources: *VkImageSubresourceLayers);
    void vkCmdDecompressMemoryNV(commandBuffer: *VkCommandBuffer_T, decompressRegionCount: uint32, pDecompressMemoryRegions: *VkDecompressMemoryRegionNV);
    void vkCmdDecompressMemoryIndirectCountNV(commandBuffer: *VkCommandBuffer_T, indirectCommandsAddress: uint64, indirectCommandsCountAddress: uint64, stride: uint32);
    void vkGetPipelineIndirectMemoryRequirementsNV(device: *VkDevice_T, pCreateInfo: *VkComputePipelineCreateInfo, pMemoryRequirements: *VkMemoryRequirements2);
    void vkCmdUpdatePipelineIndirectBufferNV(commandBuffer: *VkCommandBuffer_T, pipelineBindPoint: VkPipelineBindPoint, pipeline: *VkPipeline_T);
    uint64 vkGetPipelineIndirectDeviceAddressNV(device: *VkDevice_T, pInfo: *VkPipelineIndirectDeviceAddressInfoNV);
    void vkCmdSetDepthClampEnableEXT(commandBuffer: *VkCommandBuffer_T, depthClampEnable: uint32);
    void vkCmdSetPolygonModeEXT(commandBuffer: *VkCommandBuffer_T, polygonMode: VkPolygonMode);
    void vkCmdSetRasterizationSamplesEXT(commandBuffer: *VkCommandBuffer_T, rasterizationSamples: VkSampleCountFlagBits);
    void vkCmdSetSampleMaskEXT(commandBuffer: *VkCommandBuffer_T, samples: VkSampleCountFlagBits, pSampleMask: *uint32);
    void vkCmdSetAlphaToCoverageEnableEXT(commandBuffer: *VkCommandBuffer_T, alphaToCoverageEnable: uint32);
    void vkCmdSetAlphaToOneEnableEXT(commandBuffer: *VkCommandBuffer_T, alphaToOneEnable: uint32);
    void vkCmdSetLogicOpEnableEXT(commandBuffer: *VkCommandBuffer_T, logicOpEnable: uint32);
    void vkCmdSetColorBlendEnableEXT(commandBuffer: *VkCommandBuffer_T, firstAttachment: uint32, attachmentCount: uint32, pColorBlendEnables: *uint32);
    void vkCmdSetColorBlendEquationEXT(commandBuffer: *VkCommandBuffer_T, firstAttachment: uint32, attachmentCount: uint32, pColorBlendEquations: *VkColorBlendEquationEXT);
    void vkCmdSetColorWriteMaskEXT(commandBuffer: *VkCommandBuffer_T, firstAttachment: uint32, attachmentCount: uint32, pColorWriteMasks: *uint32);
    void vkCmdSetTessellationDomainOriginEXT(commandBuffer: *VkCommandBuffer_T, domainOrigin: VkTessellationDomainOrigin);
    void vkCmdSetRasterizationStreamEXT(commandBuffer: *VkCommandBuffer_T, rasterizationStream: uint32);
    void vkCmdSetConservativeRasterizationModeEXT(commandBuffer: *VkCommandBuffer_T, conservativeRasterizationMode: VkConservativeRasterizationModeEXT);
    void vkCmdSetExtraPrimitiveOverestimationSizeEXT(commandBuffer: *VkCommandBuffer_T, extraPrimitiveOverestimationSize: float32);
    void vkCmdSetDepthClipEnableEXT(commandBuffer: *VkCommandBuffer_T, depthClipEnable: uint32);
    void vkCmdSetSampleLocationsEnableEXT(commandBuffer: *VkCommandBuffer_T, sampleLocationsEnable: uint32);
    void vkCmdSetColorBlendAdvancedEXT(commandBuffer: *VkCommandBuffer_T, firstAttachment: uint32, attachmentCount: uint32, pColorBlendAdvanced: *VkColorBlendAdvancedEXT);
    void vkCmdSetProvokingVertexModeEXT(commandBuffer: *VkCommandBuffer_T, provokingVertexMode: VkProvokingVertexModeEXT);
    void vkCmdSetLineRasterizationModeEXT(commandBuffer: *VkCommandBuffer_T, lineRasterizationMode: VkLineRasterizationMode);
    void vkCmdSetLineStippleEnableEXT(commandBuffer: *VkCommandBuffer_T, stippledLineEnable: uint32);
    void vkCmdSetDepthClipNegativeOneToOneEXT(commandBuffer: *VkCommandBuffer_T, negativeOneToOne: uint32);
    void vkCmdSetViewportWScalingEnableNV(commandBuffer: *VkCommandBuffer_T, viewportWScalingEnable: uint32);
    void vkCmdSetViewportSwizzleNV(commandBuffer: *VkCommandBuffer_T, firstViewport: uint32, viewportCount: uint32, pViewportSwizzles: *VkViewportSwizzleNV);
    void vkCmdSetCoverageToColorEnableNV(commandBuffer: *VkCommandBuffer_T, coverageToColorEnable: uint32);
    void vkCmdSetCoverageToColorLocationNV(commandBuffer: *VkCommandBuffer_T, coverageToColorLocation: uint32);
    void vkCmdSetCoverageModulationModeNV(commandBuffer: *VkCommandBuffer_T, coverageModulationMode: VkCoverageModulationModeNV);
    void vkCmdSetCoverageModulationTableEnableNV(commandBuffer: *VkCommandBuffer_T, coverageModulationTableEnable: uint32);
    void vkCmdSetCoverageModulationTableNV(commandBuffer: *VkCommandBuffer_T, coverageModulationTableCount: uint32, pCoverageModulationTable: *float32);
    void vkCmdSetShadingRateImageEnableNV(commandBuffer: *VkCommandBuffer_T, shadingRateImageEnable: uint32);
    void vkCmdSetRepresentativeFragmentTestEnableNV(commandBuffer: *VkCommandBuffer_T, representativeFragmentTestEnable: uint32);
    void vkCmdSetCoverageReductionModeNV(commandBuffer: *VkCommandBuffer_T, coverageReductionMode: VkCoverageReductionModeNV);
    void vkGetShaderModuleIdentifierEXT(device: *VkDevice_T, shaderModule: *VkShaderModule_T, pIdentifier: *VkShaderModuleIdentifierEXT);
    void vkGetShaderModuleCreateInfoIdentifierEXT(device: *VkDevice_T, pCreateInfo: *VkShaderModuleCreateInfo, pIdentifier: *VkShaderModuleIdentifierEXT);
    VkResult vkGetPhysicalDeviceOpticalFlowImageFormatsNV(physicalDevice: *VkPhysicalDevice_T, pOpticalFlowImageFormatInfo: *VkOpticalFlowImageFormatInfoNV, pFormatCount: *uint32, pImageFormatProperties: *VkOpticalFlowImageFormatPropertiesNV);
    VkResult vkCreateOpticalFlowSessionNV(device: *VkDevice_T, pCreateInfo: *VkOpticalFlowSessionCreateInfoNV, pAllocator: *VkAllocationCallbacks, pSession: **VkOpticalFlowSessionNV_T);
    void vkDestroyOpticalFlowSessionNV(device: *VkDevice_T, session: *VkOpticalFlowSessionNV_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkBindOpticalFlowSessionImageNV(device: *VkDevice_T, session: *VkOpticalFlowSessionNV_T, bindingPoint: VkOpticalFlowSessionBindingPointNV, view: *VkImageView_T, layout: VkImageLayout);
    void vkCmdOpticalFlowExecuteNV(commandBuffer: *VkCommandBuffer_T, session: *VkOpticalFlowSessionNV_T, pExecuteInfo: *VkOpticalFlowExecuteInfoNV);
    void vkAntiLagUpdateAMD(device: *VkDevice_T, pData: *VkAntiLagDataAMD);
    VkResult vkCreateShadersEXT(device: *VkDevice_T, createInfoCount: uint32, pCreateInfos: *VkShaderCreateInfoEXT, pAllocator: *VkAllocationCallbacks, pShaders: **VkShaderEXT_T);
    void vkDestroyShaderEXT(device: *VkDevice_T, shader: *VkShaderEXT_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkGetShaderBinaryDataEXT(device: *VkDevice_T, shader: *VkShaderEXT_T, pDataSize: *uint64, pData: *void);
    void vkCmdBindShadersEXT(commandBuffer: *VkCommandBuffer_T, stageCount: uint32, pStages: *VkShaderStageFlagBits, pShaders: **VkShaderEXT_T);
    void vkCmdSetDepthClampRangeEXT(commandBuffer: *VkCommandBuffer_T, depthClampMode: VkDepthClampModeEXT, pDepthClampRange: *VkDepthClampRangeEXT);
    VkResult vkGetFramebufferTilePropertiesQCOM(device: *VkDevice_T, framebuffer: *VkFramebuffer_T, pPropertiesCount: *uint32, pProperties: *VkTilePropertiesQCOM);
    VkResult vkGetDynamicRenderingTilePropertiesQCOM(device: *VkDevice_T, pRenderingInfo: *VkRenderingInfo, pProperties: *VkTilePropertiesQCOM);
    VkResult vkGetPhysicalDeviceCooperativeVectorPropertiesNV(physicalDevice: *VkPhysicalDevice_T, pPropertyCount: *uint32, pProperties: *VkCooperativeVectorPropertiesNV);
    VkResult vkConvertCooperativeVectorMatrixNV(device: *VkDevice_T, pInfo: *VkConvertCooperativeVectorMatrixInfoNV);
    void vkCmdConvertCooperativeVectorMatrixNV(commandBuffer: *VkCommandBuffer_T, infoCount: uint32, pInfos: *VkConvertCooperativeVectorMatrixInfoNV);
    VkResult vkSetLatencySleepModeNV(device: *VkDevice_T, swapchain: *VkSwapchainKHR_T, pSleepModeInfo: *VkLatencySleepModeInfoNV);
    VkResult vkLatencySleepNV(device: *VkDevice_T, swapchain: *VkSwapchainKHR_T, pSleepInfo: *VkLatencySleepInfoNV);
    void vkSetLatencyMarkerNV(device: *VkDevice_T, swapchain: *VkSwapchainKHR_T, pLatencyMarkerInfo: *VkSetLatencyMarkerInfoNV);
    void vkGetLatencyTimingsNV(device: *VkDevice_T, swapchain: *VkSwapchainKHR_T, pLatencyMarkerInfo: *VkGetLatencyMarkerInfoNV);
    void vkQueueNotifyOutOfBandNV(queue: *VkQueue_T, pQueueTypeInfo: *VkOutOfBandQueueTypeInfoNV);
    void vkCmdSetAttachmentFeedbackLoopEnableEXT(commandBuffer: *VkCommandBuffer_T, aspectMask: uint32);
    void vkGetClusterAccelerationStructureBuildSizesNV(device: *VkDevice_T, pInfo: *VkClusterAccelerationStructureInputInfoNV, pSizeInfo: *VkAccelerationStructureBuildSizesInfoKHR);
    void vkCmdBuildClusterAccelerationStructureIndirectNV(commandBuffer: *VkCommandBuffer_T, pCommandInfos: *VkClusterAccelerationStructureCommandsInfoNV);
    void vkGetPartitionedAccelerationStructuresBuildSizesNV(device: *VkDevice_T, pInfo: *VkPartitionedAccelerationStructureInstancesInputNV, pSizeInfo: *VkAccelerationStructureBuildSizesInfoKHR);
    void vkCmdBuildPartitionedAccelerationStructuresNV(commandBuffer: *VkCommandBuffer_T, pBuildInfo: *VkBuildPartitionedAccelerationStructureInfoNV);
    void vkGetGeneratedCommandsMemoryRequirementsEXT(device: *VkDevice_T, pInfo: *VkGeneratedCommandsMemoryRequirementsInfoEXT, pMemoryRequirements: *VkMemoryRequirements2);
    void vkCmdPreprocessGeneratedCommandsEXT(commandBuffer: *VkCommandBuffer_T, pGeneratedCommandsInfo: *VkGeneratedCommandsInfoEXT, stateCommandBuffer: *VkCommandBuffer_T);
    void vkCmdExecuteGeneratedCommandsEXT(commandBuffer: *VkCommandBuffer_T, isPreprocessed: uint32, pGeneratedCommandsInfo: *VkGeneratedCommandsInfoEXT);
    VkResult vkCreateIndirectCommandsLayoutEXT(device: *VkDevice_T, pCreateInfo: *VkIndirectCommandsLayoutCreateInfoEXT, pAllocator: *VkAllocationCallbacks, pIndirectCommandsLayout: **VkIndirectCommandsLayoutEXT_T);
    void vkDestroyIndirectCommandsLayoutEXT(device: *VkDevice_T, indirectCommandsLayout: *VkIndirectCommandsLayoutEXT_T, pAllocator: *VkAllocationCallbacks);
    VkResult vkCreateIndirectExecutionSetEXT(device: *VkDevice_T, pCreateInfo: *VkIndirectExecutionSetCreateInfoEXT, pAllocator: *VkAllocationCallbacks, pIndirectExecutionSet: **VkIndirectExecutionSetEXT_T);
    void vkDestroyIndirectExecutionSetEXT(device: *VkDevice_T, indirectExecutionSet: *VkIndirectExecutionSetEXT_T, pAllocator: *VkAllocationCallbacks);
    void vkUpdateIndirectExecutionSetPipelineEXT(device: *VkDevice_T, indirectExecutionSet: *VkIndirectExecutionSetEXT_T, executionSetWriteCount: uint32, pExecutionSetWrites: *VkWriteIndirectExecutionSetPipelineEXT);
    void vkUpdateIndirectExecutionSetShaderEXT(device: *VkDevice_T, indirectExecutionSet: *VkIndirectExecutionSetEXT_T, executionSetWriteCount: uint32, pExecutionSetWrites: *VkWriteIndirectExecutionSetShaderEXT);
    VkResult vkGetPhysicalDeviceCooperativeMatrixFlexibleDimensionsPropertiesNV(physicalDevice: *VkPhysicalDevice_T, pPropertyCount: *uint32, pProperties: *VkCooperativeMatrixFlexibleDimensionsPropertiesNV);
    VkResult vkCreateAccelerationStructureKHR(device: *VkDevice_T, pCreateInfo: *VkAccelerationStructureCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pAccelerationStructure: **VkAccelerationStructureKHR_T);
    void vkDestroyAccelerationStructureKHR(device: *VkDevice_T, accelerationStructure: *VkAccelerationStructureKHR_T, pAllocator: *VkAllocationCallbacks);
    void vkCmdBuildAccelerationStructuresKHR(commandBuffer: *VkCommandBuffer_T, infoCount: uint32, pInfos: *VkAccelerationStructureBuildGeometryInfoKHR, ppBuildRangeInfos: **VkAccelerationStructureBuildRangeInfoKHR);
    void vkCmdBuildAccelerationStructuresIndirectKHR(commandBuffer: *VkCommandBuffer_T, infoCount: uint32, pInfos: *VkAccelerationStructureBuildGeometryInfoKHR, pIndirectDeviceAddresses: *uint64, pIndirectStrides: *uint32, ppMaxPrimitiveCounts: **uint32);
    VkResult vkBuildAccelerationStructuresKHR(device: *VkDevice_T, deferredOperation: *VkDeferredOperationKHR_T, infoCount: uint32, pInfos: *VkAccelerationStructureBuildGeometryInfoKHR, ppBuildRangeInfos: **VkAccelerationStructureBuildRangeInfoKHR);
    VkResult vkCopyAccelerationStructureKHR(device: *VkDevice_T, deferredOperation: *VkDeferredOperationKHR_T, pInfo: *VkCopyAccelerationStructureInfoKHR);
    VkResult vkCopyAccelerationStructureToMemoryKHR(device: *VkDevice_T, deferredOperation: *VkDeferredOperationKHR_T, pInfo: *VkCopyAccelerationStructureToMemoryInfoKHR);
    VkResult vkCopyMemoryToAccelerationStructureKHR(device: *VkDevice_T, deferredOperation: *VkDeferredOperationKHR_T, pInfo: *VkCopyMemoryToAccelerationStructureInfoKHR);
    VkResult vkWriteAccelerationStructuresPropertiesKHR(device: *VkDevice_T, accelerationStructureCount: uint32, pAccelerationStructures: **VkAccelerationStructureKHR_T, queryType: VkQueryType, dataSize: uint64, pData: *void, stride: uint64);
    void vkCmdCopyAccelerationStructureKHR(commandBuffer: *VkCommandBuffer_T, pInfo: *VkCopyAccelerationStructureInfoKHR);
    void vkCmdCopyAccelerationStructureToMemoryKHR(commandBuffer: *VkCommandBuffer_T, pInfo: *VkCopyAccelerationStructureToMemoryInfoKHR);
    void vkCmdCopyMemoryToAccelerationStructureKHR(commandBuffer: *VkCommandBuffer_T, pInfo: *VkCopyMemoryToAccelerationStructureInfoKHR);
    uint64 vkGetAccelerationStructureDeviceAddressKHR(device: *VkDevice_T, pInfo: *VkAccelerationStructureDeviceAddressInfoKHR);
    void vkCmdWriteAccelerationStructuresPropertiesKHR(commandBuffer: *VkCommandBuffer_T, accelerationStructureCount: uint32, pAccelerationStructures: **VkAccelerationStructureKHR_T, queryType: VkQueryType, queryPool: *VkQueryPool_T, firstQuery: uint32);
    void vkGetDeviceAccelerationStructureCompatibilityKHR(device: *VkDevice_T, pVersionInfo: *VkAccelerationStructureVersionInfoKHR, pCompatibility: *VkAccelerationStructureCompatibilityKHR);
    void vkGetAccelerationStructureBuildSizesKHR(device: *VkDevice_T, buildType: VkAccelerationStructureBuildTypeKHR, pBuildInfo: *VkAccelerationStructureBuildGeometryInfoKHR, pMaxPrimitiveCounts: *uint32, pSizeInfo: *VkAccelerationStructureBuildSizesInfoKHR);
    void vkCmdTraceRaysKHR(commandBuffer: *VkCommandBuffer_T, pRaygenShaderBindingTable: *VkStridedDeviceAddressRegionKHR, pMissShaderBindingTable: *VkStridedDeviceAddressRegionKHR, pHitShaderBindingTable: *VkStridedDeviceAddressRegionKHR, pCallableShaderBindingTable: *VkStridedDeviceAddressRegionKHR, width: uint32, height: uint32, depth: uint32);
    VkResult vkCreateRayTracingPipelinesKHR(device: *VkDevice_T, deferredOperation: *VkDeferredOperationKHR_T, pipelineCache: *VkPipelineCache_T, createInfoCount: uint32, pCreateInfos: *VkRayTracingPipelineCreateInfoKHR, pAllocator: *VkAllocationCallbacks, pPipelines: **VkPipeline_T);
    VkResult vkGetRayTracingCaptureReplayShaderGroupHandlesKHR(device: *VkDevice_T, pipeline: *VkPipeline_T, firstGroup: uint32, groupCount: uint32, dataSize: uint64, pData: *void);
    void vkCmdTraceRaysIndirectKHR(commandBuffer: *VkCommandBuffer_T, pRaygenShaderBindingTable: *VkStridedDeviceAddressRegionKHR, pMissShaderBindingTable: *VkStridedDeviceAddressRegionKHR, pHitShaderBindingTable: *VkStridedDeviceAddressRegionKHR, pCallableShaderBindingTable: *VkStridedDeviceAddressRegionKHR, indirectDeviceAddress: uint64);
    uint64 vkGetRayTracingShaderGroupStackSizeKHR(device: *VkDevice_T, pipeline: *VkPipeline_T, group: uint32, groupShader: VkShaderGroupShaderKHR);
    void vkCmdSetRayTracingPipelineStackSizeKHR(commandBuffer: *VkCommandBuffer_T, pipelineStackSize: uint32);
    void vkCmdDrawMeshTasksEXT(commandBuffer: *VkCommandBuffer_T, groupCountX: uint32, groupCountY: uint32, groupCountZ: uint32);
    void vkCmdDrawMeshTasksIndirectEXT(commandBuffer: *VkCommandBuffer_T, buffer: *VkBuffer_T, offset: uint64, drawCount: uint32, stride: uint32);
    void vkCmdDrawMeshTasksIndirectCountEXT(commandBuffer: *VkCommandBuffer_T, buffer: *VkBuffer_T, offset: uint64, countBuffer: *VkBuffer_T, countBufferOffset: uint64, maxDrawCount: uint32, stride: uint32);
}

VK_SUBPASS_EXTERNAL := uint32(^0);
VK_QUEUE_FAMILY_IGNORED := uint32(^0);

enum VkResult: uint32
{
        VK_SUCCESS = 0,
        VK_NOT_READY = 1,
        VK_TIMEOUT = 2,
        VK_EVENT_SET = 3,
        VK_EVENT_RESET = 4,
        VK_INCOMPLETE = 5,
        VK_ERROR_OUT_OF_HOST_MEMORY = 4294967295,
        VK_ERROR_OUT_OF_DEVICE_MEMORY = 4294967294,
        VK_ERROR_INITIALIZATION_FAILED = 4294967293,
        VK_ERROR_DEVICE_LOST = 4294967292,
        VK_ERROR_MEMORY_MAP_FAILED = 4294967291,
        VK_ERROR_LAYER_NOT_PRESENT = 4294967290,
        VK_ERROR_EXTENSION_NOT_PRESENT = 4294967289,
        VK_ERROR_FEATURE_NOT_PRESENT = 4294967288,
        VK_ERROR_INCOMPATIBLE_DRIVER = 4294967287,
        VK_ERROR_TOO_MANY_OBJECTS = 4294967286,
        VK_ERROR_FORMAT_NOT_SUPPORTED = 4294967285,
        VK_ERROR_FRAGMENTED_POOL = 4294967284,
        VK_ERROR_UNKNOWN = 4294967283,
        VK_ERROR_OUT_OF_POOL_MEMORY = 3294898296,
        VK_ERROR_INVALID_EXTERNAL_HANDLE = 3294895293,
        VK_ERROR_FRAGMENTATION = 3294806296,
        VK_ERROR_INVALID_OPAQUE_CAPTURE_ADDRESS = 3294710296,
        VK_PIPELINE_COMPILE_REQUIRED = 1000297000,
        VK_ERROR_NOT_PERMITTED = 3294793295,
        VK_ERROR_SURFACE_LOST_KHR = 3294967296,
        VK_ERROR_NATIVE_WINDOW_IN_USE_KHR = 3294967295,
        VK_SUBOPTIMAL_KHR = 1000001003,
        VK_ERROR_OUT_OF_DATE_KHR = 3294966292,
        VK_ERROR_INCOMPATIBLE_DISPLAY_KHR = 3294964295,
        VK_ERROR_VALIDATION_FAILED_EXT = 3294956295,
        VK_ERROR_INVALID_SHADER_NV = 3294955296,
        VK_ERROR_IMAGE_USAGE_NOT_SUPPORTED_KHR = 3294944296,
        VK_ERROR_VIDEO_PICTURE_LAYOUT_NOT_SUPPORTED_KHR = 3294944295,
        VK_ERROR_VIDEO_PROFILE_OPERATION_NOT_SUPPORTED_KHR = 3294944294,
        VK_ERROR_VIDEO_PROFILE_FORMAT_NOT_SUPPORTED_KHR = 3294944293,
        VK_ERROR_VIDEO_PROFILE_CODEC_NOT_SUPPORTED_KHR = 3294944292,
        VK_ERROR_VIDEO_STD_VERSION_NOT_SUPPORTED_KHR = 3294944291,
        VK_ERROR_INVALID_DRM_FORMAT_MODIFIER_PLANE_LAYOUT_EXT = 3294809296,
        VK_ERROR_FULL_SCREEN_EXCLUSIVE_MODE_LOST_EXT = 3294712296,
        VK_THREAD_IDLE_KHR = 1000268000,
        VK_THREAD_DONE_KHR = 1000268001,
        VK_OPERATION_DEFERRED_KHR = 1000268002,
        VK_OPERATION_NOT_DEFERRED_KHR = 1000268003,
        VK_ERROR_INVALID_VIDEO_STD_PARAMETERS_KHR = 3294668296,
        VK_ERROR_COMPRESSION_EXHAUSTED_EXT = 3294629296,
        VK_INCOMPATIBLE_SHADER_BINARY_EXT = 1000482000,
        VK_PIPELINE_BINARY_MISSING_KHR = 1000483000,
        VK_ERROR_NOT_ENOUGH_SPACE_KHR = 3294484296,
        VK_ERROR_OUT_OF_POOL_MEMORY_KHR = 3294898296,
        VK_ERROR_INVALID_EXTERNAL_HANDLE_KHR = 3294895293,
        VK_ERROR_FRAGMENTATION_EXT = 3294806296,
        VK_ERROR_NOT_PERMITTED_EXT = 3294793295,
        VK_ERROR_NOT_PERMITTED_KHR = 3294793295,
        VK_ERROR_INVALID_DEVICE_ADDRESS_EXT = 3294710296,
        VK_ERROR_INVALID_OPAQUE_CAPTURE_ADDRESS_KHR = 3294710296,
        VK_PIPELINE_COMPILE_REQUIRED_EXT = 1000297000,
        VK_ERROR_PIPELINE_COMPILE_REQUIRED_EXT = 1000297000,
        VK_ERROR_INCOMPATIBLE_SHADER_BINARY_EXT = 1000482000,
        VK_RESULT_MAX_ENUM = 2147483647
}

enum VkStructureType: uint32
{
        VK_STRUCTURE_TYPE_APPLICATION_INFO = 0,
        VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO = 1,
        VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO = 2,
        VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO = 3,
        VK_STRUCTURE_TYPE_SUBMIT_INFO = 4,
        VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_INFO = 5,
        VK_STRUCTURE_TYPE_MAPPED_MEMORY_RANGE = 6,
        VK_STRUCTURE_TYPE_BIND_SPARSE_INFO = 7,
        VK_STRUCTURE_TYPE_FENCE_CREATE_INFO = 8,
        VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO = 9,
        VK_STRUCTURE_TYPE_EVENT_CREATE_INFO = 10,
        VK_STRUCTURE_TYPE_QUERY_POOL_CREATE_INFO = 11,
        VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO = 12,
        VK_STRUCTURE_TYPE_BUFFER_VIEW_CREATE_INFO = 13,
        VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO = 14,
        VK_STRUCTURE_TYPE_IMAGE_VIEW_CREATE_INFO = 15,
        VK_STRUCTURE_TYPE_SHADER_MODULE_CREATE_INFO = 16,
        VK_STRUCTURE_TYPE_PIPELINE_CACHE_CREATE_INFO = 17,
        VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_CREATE_INFO = 18,
        VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_STATE_CREATE_INFO = 19,
        VK_STRUCTURE_TYPE_PIPELINE_INPUT_ASSEMBLY_STATE_CREATE_INFO = 20,
        VK_STRUCTURE_TYPE_PIPELINE_TESSELLATION_STATE_CREATE_INFO = 21,
        VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_STATE_CREATE_INFO = 22,
        VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_CREATE_INFO = 23,
        VK_STRUCTURE_TYPE_PIPELINE_MULTISAMPLE_STATE_CREATE_INFO = 24,
        VK_STRUCTURE_TYPE_PIPELINE_DEPTH_STENCIL_STATE_CREATE_INFO = 25,
        VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_STATE_CREATE_INFO = 26,
        VK_STRUCTURE_TYPE_PIPELINE_DYNAMIC_STATE_CREATE_INFO = 27,
        VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_CREATE_INFO = 28,
        VK_STRUCTURE_TYPE_COMPUTE_PIPELINE_CREATE_INFO = 29,
        VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO = 30,
        VK_STRUCTURE_TYPE_SAMPLER_CREATE_INFO = 31,
        VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO = 32,
        VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO = 33,
        VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO = 34,
        VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET = 35,
        VK_STRUCTURE_TYPE_COPY_DESCRIPTOR_SET = 36,
        VK_STRUCTURE_TYPE_FRAMEBUFFER_CREATE_INFO = 37,
        VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO = 38,
        VK_STRUCTURE_TYPE_COMMAND_POOL_CREATE_INFO = 39,
        VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO = 40,
        VK_STRUCTURE_TYPE_COMMAND_BUFFER_INHERITANCE_INFO = 41,
        VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO = 42,
        VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO = 43,
        VK_STRUCTURE_TYPE_BUFFER_MEMORY_BARRIER = 44,
        VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER = 45,
        VK_STRUCTURE_TYPE_MEMORY_BARRIER = 46,
        VK_STRUCTURE_TYPE_LOADER_INSTANCE_CREATE_INFO = 47,
        VK_STRUCTURE_TYPE_LOADER_DEVICE_CREATE_INFO = 48,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SUBGROUP_PROPERTIES = 1000094000,
        VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_INFO = 1000157000,
        VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_INFO = 1000157001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_16BIT_STORAGE_FEATURES = 1000083000,
        VK_STRUCTURE_TYPE_MEMORY_DEDICATED_REQUIREMENTS = 1000127000,
        VK_STRUCTURE_TYPE_MEMORY_DEDICATED_ALLOCATE_INFO = 1000127001,
        VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_FLAGS_INFO = 1000060000,
        VK_STRUCTURE_TYPE_DEVICE_GROUP_RENDER_PASS_BEGIN_INFO = 1000060003,
        VK_STRUCTURE_TYPE_DEVICE_GROUP_COMMAND_BUFFER_BEGIN_INFO = 1000060004,
        VK_STRUCTURE_TYPE_DEVICE_GROUP_SUBMIT_INFO = 1000060005,
        VK_STRUCTURE_TYPE_DEVICE_GROUP_BIND_SPARSE_INFO = 1000060006,
        VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_DEVICE_GROUP_INFO = 1000060013,
        VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_DEVICE_GROUP_INFO = 1000060014,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_GROUP_PROPERTIES = 1000070000,
        VK_STRUCTURE_TYPE_DEVICE_GROUP_DEVICE_CREATE_INFO = 1000070001,
        VK_STRUCTURE_TYPE_BUFFER_MEMORY_REQUIREMENTS_INFO_2 = 1000146000,
        VK_STRUCTURE_TYPE_IMAGE_MEMORY_REQUIREMENTS_INFO_2 = 1000146001,
        VK_STRUCTURE_TYPE_IMAGE_SPARSE_MEMORY_REQUIREMENTS_INFO_2 = 1000146002,
        VK_STRUCTURE_TYPE_MEMORY_REQUIREMENTS_2 = 1000146003,
        VK_STRUCTURE_TYPE_SPARSE_IMAGE_MEMORY_REQUIREMENTS_2 = 1000146004,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FEATURES_2 = 1000059000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROPERTIES_2 = 1000059001,
        VK_STRUCTURE_TYPE_FORMAT_PROPERTIES_2 = 1000059002,
        VK_STRUCTURE_TYPE_IMAGE_FORMAT_PROPERTIES_2 = 1000059003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_FORMAT_INFO_2 = 1000059004,
        VK_STRUCTURE_TYPE_QUEUE_FAMILY_PROPERTIES_2 = 1000059005,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_PROPERTIES_2 = 1000059006,
        VK_STRUCTURE_TYPE_SPARSE_IMAGE_FORMAT_PROPERTIES_2 = 1000059007,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SPARSE_IMAGE_FORMAT_INFO_2 = 1000059008,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_POINT_CLIPPING_PROPERTIES = 1000117000,
        VK_STRUCTURE_TYPE_RENDER_PASS_INPUT_ATTACHMENT_ASPECT_CREATE_INFO = 1000117001,
        VK_STRUCTURE_TYPE_IMAGE_VIEW_USAGE_CREATE_INFO = 1000117002,
        VK_STRUCTURE_TYPE_PIPELINE_TESSELLATION_DOMAIN_ORIGIN_STATE_CREATE_INFO = 1000117003,
        VK_STRUCTURE_TYPE_RENDER_PASS_MULTIVIEW_CREATE_INFO = 1000053000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_FEATURES = 1000053001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_PROPERTIES = 1000053002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VARIABLE_POINTERS_FEATURES = 1000120000,
        VK_STRUCTURE_TYPE_PROTECTED_SUBMIT_INFO = 1000145000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROTECTED_MEMORY_FEATURES = 1000145001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROTECTED_MEMORY_PROPERTIES = 1000145002,
        VK_STRUCTURE_TYPE_DEVICE_QUEUE_INFO_2 = 1000145003,
        VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_CREATE_INFO = 1000156000,
        VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_INFO = 1000156001,
        VK_STRUCTURE_TYPE_BIND_IMAGE_PLANE_MEMORY_INFO = 1000156002,
        VK_STRUCTURE_TYPE_IMAGE_PLANE_MEMORY_REQUIREMENTS_INFO = 1000156003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLER_YCBCR_CONVERSION_FEATURES = 1000156004,
        VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_IMAGE_FORMAT_PROPERTIES = 1000156005,
        VK_STRUCTURE_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_CREATE_INFO = 1000085000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_IMAGE_FORMAT_INFO = 1000071000,
        VK_STRUCTURE_TYPE_EXTERNAL_IMAGE_FORMAT_PROPERTIES = 1000071001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_BUFFER_INFO = 1000071002,
        VK_STRUCTURE_TYPE_EXTERNAL_BUFFER_PROPERTIES = 1000071003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ID_PROPERTIES = 1000071004,
        VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_BUFFER_CREATE_INFO = 1000072000,
        VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_IMAGE_CREATE_INFO = 1000072001,
        VK_STRUCTURE_TYPE_EXPORT_MEMORY_ALLOCATE_INFO = 1000072002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_FENCE_INFO = 1000112000,
        VK_STRUCTURE_TYPE_EXTERNAL_FENCE_PROPERTIES = 1000112001,
        VK_STRUCTURE_TYPE_EXPORT_FENCE_CREATE_INFO = 1000113000,
        VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_CREATE_INFO = 1000077000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_SEMAPHORE_INFO = 1000076000,
        VK_STRUCTURE_TYPE_EXTERNAL_SEMAPHORE_PROPERTIES = 1000076001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_3_PROPERTIES = 1000168000,
        VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_SUPPORT = 1000168001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_DRAW_PARAMETERS_FEATURES = 1000063000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_1_FEATURES = 49,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_1_PROPERTIES = 50,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_2_FEATURES = 51,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_2_PROPERTIES = 52,
        VK_STRUCTURE_TYPE_IMAGE_FORMAT_LIST_CREATE_INFO = 1000147000,
        VK_STRUCTURE_TYPE_ATTACHMENT_DESCRIPTION_2 = 1000109000,
        VK_STRUCTURE_TYPE_ATTACHMENT_REFERENCE_2 = 1000109001,
        VK_STRUCTURE_TYPE_SUBPASS_DESCRIPTION_2 = 1000109002,
        VK_STRUCTURE_TYPE_SUBPASS_DEPENDENCY_2 = 1000109003,
        VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO_2 = 1000109004,
        VK_STRUCTURE_TYPE_SUBPASS_BEGIN_INFO = 1000109005,
        VK_STRUCTURE_TYPE_SUBPASS_END_INFO = 1000109006,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_8BIT_STORAGE_FEATURES = 1000177000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DRIVER_PROPERTIES = 1000196000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_ATOMIC_INT64_FEATURES = 1000180000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_FLOAT16_INT8_FEATURES = 1000082000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FLOAT_CONTROLS_PROPERTIES = 1000197000,
        VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_BINDING_FLAGS_CREATE_INFO = 1000161000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_INDEXING_FEATURES = 1000161001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_INDEXING_PROPERTIES = 1000161002,
        VK_STRUCTURE_TYPE_DESCRIPTOR_SET_VARIABLE_DESCRIPTOR_COUNT_ALLOCATE_INFO = 1000161003,
        VK_STRUCTURE_TYPE_DESCRIPTOR_SET_VARIABLE_DESCRIPTOR_COUNT_LAYOUT_SUPPORT = 1000161004,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEPTH_STENCIL_RESOLVE_PROPERTIES = 1000199000,
        VK_STRUCTURE_TYPE_SUBPASS_DESCRIPTION_DEPTH_STENCIL_RESOLVE = 1000199001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SCALAR_BLOCK_LAYOUT_FEATURES = 1000221000,
        VK_STRUCTURE_TYPE_IMAGE_STENCIL_USAGE_CREATE_INFO = 1000246000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLER_FILTER_MINMAX_PROPERTIES = 1000130000,
        VK_STRUCTURE_TYPE_SAMPLER_REDUCTION_MODE_CREATE_INFO = 1000130001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_MEMORY_MODEL_FEATURES = 1000211000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGELESS_FRAMEBUFFER_FEATURES = 1000108000,
        VK_STRUCTURE_TYPE_FRAMEBUFFER_ATTACHMENTS_CREATE_INFO = 1000108001,
        VK_STRUCTURE_TYPE_FRAMEBUFFER_ATTACHMENT_IMAGE_INFO = 1000108002,
        VK_STRUCTURE_TYPE_RENDER_PASS_ATTACHMENT_BEGIN_INFO = 1000108003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_UNIFORM_BUFFER_STANDARD_LAYOUT_FEATURES = 1000253000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_SUBGROUP_EXTENDED_TYPES_FEATURES = 1000175000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SEPARATE_DEPTH_STENCIL_LAYOUTS_FEATURES = 1000241000,
        VK_STRUCTURE_TYPE_ATTACHMENT_REFERENCE_STENCIL_LAYOUT = 1000241001,
        VK_STRUCTURE_TYPE_ATTACHMENT_DESCRIPTION_STENCIL_LAYOUT = 1000241002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_HOST_QUERY_RESET_FEATURES = 1000261000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TIMELINE_SEMAPHORE_FEATURES = 1000207000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TIMELINE_SEMAPHORE_PROPERTIES = 1000207001,
        VK_STRUCTURE_TYPE_SEMAPHORE_TYPE_CREATE_INFO = 1000207002,
        VK_STRUCTURE_TYPE_TIMELINE_SEMAPHORE_SUBMIT_INFO = 1000207003,
        VK_STRUCTURE_TYPE_SEMAPHORE_WAIT_INFO = 1000207004,
        VK_STRUCTURE_TYPE_SEMAPHORE_SIGNAL_INFO = 1000207005,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BUFFER_DEVICE_ADDRESS_FEATURES = 1000257000,
        VK_STRUCTURE_TYPE_BUFFER_DEVICE_ADDRESS_INFO = 1000244001,
        VK_STRUCTURE_TYPE_BUFFER_OPAQUE_CAPTURE_ADDRESS_CREATE_INFO = 1000257002,
        VK_STRUCTURE_TYPE_MEMORY_OPAQUE_CAPTURE_ADDRESS_ALLOCATE_INFO = 1000257003,
        VK_STRUCTURE_TYPE_DEVICE_MEMORY_OPAQUE_CAPTURE_ADDRESS_INFO = 1000257004,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_3_FEATURES = 53,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_3_PROPERTIES = 54,
        VK_STRUCTURE_TYPE_PIPELINE_CREATION_FEEDBACK_CREATE_INFO = 1000192000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_TERMINATE_INVOCATION_FEATURES = 1000215000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TOOL_PROPERTIES = 1000245000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_DEMOTE_TO_HELPER_INVOCATION_FEATURES = 1000276000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PRIVATE_DATA_FEATURES = 1000295000,
        VK_STRUCTURE_TYPE_DEVICE_PRIVATE_DATA_CREATE_INFO = 1000295001,
        VK_STRUCTURE_TYPE_PRIVATE_DATA_SLOT_CREATE_INFO = 1000295002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_CREATION_CACHE_CONTROL_FEATURES = 1000297000,
        VK_STRUCTURE_TYPE_MEMORY_BARRIER_2 = 1000314000,
        VK_STRUCTURE_TYPE_BUFFER_MEMORY_BARRIER_2 = 1000314001,
        VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER_2 = 1000314002,
        VK_STRUCTURE_TYPE_DEPENDENCY_INFO = 1000314003,
        VK_STRUCTURE_TYPE_SUBMIT_INFO_2 = 1000314004,
        VK_STRUCTURE_TYPE_SEMAPHORE_SUBMIT_INFO = 1000314005,
        VK_STRUCTURE_TYPE_COMMAND_BUFFER_SUBMIT_INFO = 1000314006,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SYNCHRONIZATION_2_FEATURES = 1000314007,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ZERO_INITIALIZE_WORKGROUP_MEMORY_FEATURES = 1000325000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_ROBUSTNESS_FEATURES = 1000335000,
        VK_STRUCTURE_TYPE_COPY_BUFFER_INFO_2 = 1000337000,
        VK_STRUCTURE_TYPE_COPY_IMAGE_INFO_2 = 1000337001,
        VK_STRUCTURE_TYPE_COPY_BUFFER_TO_IMAGE_INFO_2 = 1000337002,
        VK_STRUCTURE_TYPE_COPY_IMAGE_TO_BUFFER_INFO_2 = 1000337003,
        VK_STRUCTURE_TYPE_BLIT_IMAGE_INFO_2 = 1000337004,
        VK_STRUCTURE_TYPE_RESOLVE_IMAGE_INFO_2 = 1000337005,
        VK_STRUCTURE_TYPE_BUFFER_COPY_2 = 1000337006,
        VK_STRUCTURE_TYPE_IMAGE_COPY_2 = 1000337007,
        VK_STRUCTURE_TYPE_IMAGE_BLIT_2 = 1000337008,
        VK_STRUCTURE_TYPE_BUFFER_IMAGE_COPY_2 = 1000337009,
        VK_STRUCTURE_TYPE_IMAGE_RESOLVE_2 = 1000337010,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SUBGROUP_SIZE_CONTROL_PROPERTIES = 1000225000,
        VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_REQUIRED_SUBGROUP_SIZE_CREATE_INFO = 1000225001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SUBGROUP_SIZE_CONTROL_FEATURES = 1000225002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_INLINE_UNIFORM_BLOCK_FEATURES = 1000138000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_INLINE_UNIFORM_BLOCK_PROPERTIES = 1000138001,
        VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET_INLINE_UNIFORM_BLOCK = 1000138002,
        VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_INLINE_UNIFORM_BLOCK_CREATE_INFO = 1000138003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TEXTURE_COMPRESSION_ASTC_HDR_FEATURES = 1000066000,
        VK_STRUCTURE_TYPE_RENDERING_INFO = 1000044000,
        VK_STRUCTURE_TYPE_RENDERING_ATTACHMENT_INFO = 1000044001,
        VK_STRUCTURE_TYPE_PIPELINE_RENDERING_CREATE_INFO = 1000044002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DYNAMIC_RENDERING_FEATURES = 1000044003,
        VK_STRUCTURE_TYPE_COMMAND_BUFFER_INHERITANCE_RENDERING_INFO = 1000044004,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_INTEGER_DOT_PRODUCT_FEATURES = 1000280000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_INTEGER_DOT_PRODUCT_PROPERTIES = 1000280001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TEXEL_BUFFER_ALIGNMENT_PROPERTIES = 1000281001,
        VK_STRUCTURE_TYPE_FORMAT_PROPERTIES_3 = 1000360000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_4_FEATURES = 1000413000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_4_PROPERTIES = 1000413001,
        VK_STRUCTURE_TYPE_DEVICE_BUFFER_MEMORY_REQUIREMENTS = 1000413002,
        VK_STRUCTURE_TYPE_DEVICE_IMAGE_MEMORY_REQUIREMENTS = 1000413003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_4_FEATURES = 55,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_1_4_PROPERTIES = 56,
        VK_STRUCTURE_TYPE_DEVICE_QUEUE_GLOBAL_PRIORITY_CREATE_INFO = 1000174000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_GLOBAL_PRIORITY_QUERY_FEATURES = 1000388000,
        VK_STRUCTURE_TYPE_QUEUE_FAMILY_GLOBAL_PRIORITY_PROPERTIES = 1000388001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_SUBGROUP_ROTATE_FEATURES = 1000416000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_FLOAT_CONTROLS_2_FEATURES = 1000528000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_EXPECT_ASSUME_FEATURES = 1000544000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LINE_RASTERIZATION_FEATURES = 1000259000,
        VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_LINE_STATE_CREATE_INFO = 1000259001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LINE_RASTERIZATION_PROPERTIES = 1000259002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_ATTRIBUTE_DIVISOR_PROPERTIES = 1000525000,
        VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_DIVISOR_STATE_CREATE_INFO = 1000190001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_ATTRIBUTE_DIVISOR_FEATURES = 1000190002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_INDEX_TYPE_UINT8_FEATURES = 1000265000,
        VK_STRUCTURE_TYPE_MEMORY_MAP_INFO = 1000271000,
        VK_STRUCTURE_TYPE_MEMORY_UNMAP_INFO = 1000271001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_5_FEATURES = 1000470000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_5_PROPERTIES = 1000470001,
        VK_STRUCTURE_TYPE_RENDERING_AREA_INFO = 1000470003,
        VK_STRUCTURE_TYPE_DEVICE_IMAGE_SUBRESOURCE_INFO = 1000470004,
        VK_STRUCTURE_TYPE_SUBRESOURCE_LAYOUT_2 = 1000338002,
        VK_STRUCTURE_TYPE_IMAGE_SUBRESOURCE_2 = 1000338003,
        VK_STRUCTURE_TYPE_PIPELINE_CREATE_FLAGS_2_CREATE_INFO = 1000470005,
        VK_STRUCTURE_TYPE_BUFFER_USAGE_FLAGS_2_CREATE_INFO = 1000470006,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PUSH_DESCRIPTOR_PROPERTIES = 1000080000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DYNAMIC_RENDERING_LOCAL_READ_FEATURES = 1000232000,
        VK_STRUCTURE_TYPE_RENDERING_ATTACHMENT_LOCATION_INFO = 1000232001,
        VK_STRUCTURE_TYPE_RENDERING_INPUT_ATTACHMENT_INDEX_INFO = 1000232002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_6_FEATURES = 1000545000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_6_PROPERTIES = 1000545001,
        VK_STRUCTURE_TYPE_BIND_MEMORY_STATUS = 1000545002,
        VK_STRUCTURE_TYPE_BIND_DESCRIPTOR_SETS_INFO = 1000545003,
        VK_STRUCTURE_TYPE_PUSH_CONSTANTS_INFO = 1000545004,
        VK_STRUCTURE_TYPE_PUSH_DESCRIPTOR_SET_INFO = 1000545005,
        VK_STRUCTURE_TYPE_PUSH_DESCRIPTOR_SET_WITH_TEMPLATE_INFO = 1000545006,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_PROTECTED_ACCESS_FEATURES = 1000466000,
        VK_STRUCTURE_TYPE_PIPELINE_ROBUSTNESS_CREATE_INFO = 1000068000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_ROBUSTNESS_FEATURES = 1000068001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_ROBUSTNESS_PROPERTIES = 1000068002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_HOST_IMAGE_COPY_FEATURES = 1000270000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_HOST_IMAGE_COPY_PROPERTIES = 1000270001,
        VK_STRUCTURE_TYPE_MEMORY_TO_IMAGE_COPY = 1000270002,
        VK_STRUCTURE_TYPE_IMAGE_TO_MEMORY_COPY = 1000270003,
        VK_STRUCTURE_TYPE_COPY_IMAGE_TO_MEMORY_INFO = 1000270004,
        VK_STRUCTURE_TYPE_COPY_MEMORY_TO_IMAGE_INFO = 1000270005,
        VK_STRUCTURE_TYPE_HOST_IMAGE_LAYOUT_TRANSITION_INFO = 1000270006,
        VK_STRUCTURE_TYPE_COPY_IMAGE_TO_IMAGE_INFO = 1000270007,
        VK_STRUCTURE_TYPE_SUBRESOURCE_HOST_MEMCPY_SIZE = 1000270008,
        VK_STRUCTURE_TYPE_HOST_IMAGE_COPY_DEVICE_PERFORMANCE_QUERY = 1000270009,
        VK_STRUCTURE_TYPE_SWAPCHAIN_CREATE_INFO_KHR = 1000001000,
        VK_STRUCTURE_TYPE_PRESENT_INFO_KHR = 1000001001,
        VK_STRUCTURE_TYPE_DEVICE_GROUP_PRESENT_CAPABILITIES_KHR = 1000060007,
        VK_STRUCTURE_TYPE_IMAGE_SWAPCHAIN_CREATE_INFO_KHR = 1000060008,
        VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_SWAPCHAIN_INFO_KHR = 1000060009,
        VK_STRUCTURE_TYPE_ACQUIRE_NEXT_IMAGE_INFO_KHR = 1000060010,
        VK_STRUCTURE_TYPE_DEVICE_GROUP_PRESENT_INFO_KHR = 1000060011,
        VK_STRUCTURE_TYPE_DEVICE_GROUP_SWAPCHAIN_CREATE_INFO_KHR = 1000060012,
        VK_STRUCTURE_TYPE_DISPLAY_MODE_CREATE_INFO_KHR = 1000002000,
        VK_STRUCTURE_TYPE_DISPLAY_SURFACE_CREATE_INFO_KHR = 1000002001,
        VK_STRUCTURE_TYPE_DISPLAY_PRESENT_INFO_KHR = 1000003000,
        VK_STRUCTURE_TYPE_XLIB_SURFACE_CREATE_INFO_KHR = 1000004000,
        VK_STRUCTURE_TYPE_XCB_SURFACE_CREATE_INFO_KHR = 1000005000,
        VK_STRUCTURE_TYPE_WAYLAND_SURFACE_CREATE_INFO_KHR = 1000006000,
        VK_STRUCTURE_TYPE_ANDROID_SURFACE_CREATE_INFO_KHR = 1000008000,
        VK_STRUCTURE_TYPE_WIN32_SURFACE_CREATE_INFO_KHR = 1000009000,
        VK_STRUCTURE_TYPE_DEBUG_REPORT_CALLBACK_CREATE_INFO_EXT = 1000011000,
        VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_RASTERIZATION_ORDER_AMD = 1000018000,
        VK_STRUCTURE_TYPE_DEBUG_MARKER_OBJECT_NAME_INFO_EXT = 1000022000,
        VK_STRUCTURE_TYPE_DEBUG_MARKER_OBJECT_TAG_INFO_EXT = 1000022001,
        VK_STRUCTURE_TYPE_DEBUG_MARKER_MARKER_INFO_EXT = 1000022002,
        VK_STRUCTURE_TYPE_VIDEO_PROFILE_INFO_KHR = 1000023000,
        VK_STRUCTURE_TYPE_VIDEO_CAPABILITIES_KHR = 1000023001,
        VK_STRUCTURE_TYPE_VIDEO_PICTURE_RESOURCE_INFO_KHR = 1000023002,
        VK_STRUCTURE_TYPE_VIDEO_SESSION_MEMORY_REQUIREMENTS_KHR = 1000023003,
        VK_STRUCTURE_TYPE_BIND_VIDEO_SESSION_MEMORY_INFO_KHR = 1000023004,
        VK_STRUCTURE_TYPE_VIDEO_SESSION_CREATE_INFO_KHR = 1000023005,
        VK_STRUCTURE_TYPE_VIDEO_SESSION_PARAMETERS_CREATE_INFO_KHR = 1000023006,
        VK_STRUCTURE_TYPE_VIDEO_SESSION_PARAMETERS_UPDATE_INFO_KHR = 1000023007,
        VK_STRUCTURE_TYPE_VIDEO_BEGIN_CODING_INFO_KHR = 1000023008,
        VK_STRUCTURE_TYPE_VIDEO_END_CODING_INFO_KHR = 1000023009,
        VK_STRUCTURE_TYPE_VIDEO_CODING_CONTROL_INFO_KHR = 1000023010,
        VK_STRUCTURE_TYPE_VIDEO_REFERENCE_SLOT_INFO_KHR = 1000023011,
        VK_STRUCTURE_TYPE_QUEUE_FAMILY_VIDEO_PROPERTIES_KHR = 1000023012,
        VK_STRUCTURE_TYPE_VIDEO_PROFILE_LIST_INFO_KHR = 1000023013,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VIDEO_FORMAT_INFO_KHR = 1000023014,
        VK_STRUCTURE_TYPE_VIDEO_FORMAT_PROPERTIES_KHR = 1000023015,
        VK_STRUCTURE_TYPE_QUEUE_FAMILY_QUERY_RESULT_STATUS_PROPERTIES_KHR = 1000023016,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_INFO_KHR = 1000024000,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_CAPABILITIES_KHR = 1000024001,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_USAGE_INFO_KHR = 1000024002,
        VK_STRUCTURE_TYPE_DEDICATED_ALLOCATION_IMAGE_CREATE_INFO_NV = 1000026000,
        VK_STRUCTURE_TYPE_DEDICATED_ALLOCATION_BUFFER_CREATE_INFO_NV = 1000026001,
        VK_STRUCTURE_TYPE_DEDICATED_ALLOCATION_MEMORY_ALLOCATE_INFO_NV = 1000026002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TRANSFORM_FEEDBACK_FEATURES_EXT = 1000028000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TRANSFORM_FEEDBACK_PROPERTIES_EXT = 1000028001,
        VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_STATE_STREAM_CREATE_INFO_EXT = 1000028002,
        VK_STRUCTURE_TYPE_CU_MODULE_CREATE_INFO_NVX = 1000029000,
        VK_STRUCTURE_TYPE_CU_FUNCTION_CREATE_INFO_NVX = 1000029001,
        VK_STRUCTURE_TYPE_CU_LAUNCH_INFO_NVX = 1000029002,
        VK_STRUCTURE_TYPE_CU_MODULE_TEXTURING_MODE_CREATE_INFO_NVX = 1000029004,
        VK_STRUCTURE_TYPE_IMAGE_VIEW_HANDLE_INFO_NVX = 1000030000,
        VK_STRUCTURE_TYPE_IMAGE_VIEW_ADDRESS_PROPERTIES_NVX = 1000030001,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_CAPABILITIES_KHR = 1000038000,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_SESSION_PARAMETERS_CREATE_INFO_KHR = 1000038001,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_SESSION_PARAMETERS_ADD_INFO_KHR = 1000038002,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_PICTURE_INFO_KHR = 1000038003,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_DPB_SLOT_INFO_KHR = 1000038004,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_NALU_SLICE_INFO_KHR = 1000038005,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_GOP_REMAINING_FRAME_INFO_KHR = 1000038006,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_PROFILE_INFO_KHR = 1000038007,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_RATE_CONTROL_INFO_KHR = 1000038008,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_RATE_CONTROL_LAYER_INFO_KHR = 1000038009,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_SESSION_CREATE_INFO_KHR = 1000038010,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_QUALITY_LEVEL_PROPERTIES_KHR = 1000038011,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_SESSION_PARAMETERS_GET_INFO_KHR = 1000038012,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_SESSION_PARAMETERS_FEEDBACK_INFO_KHR = 1000038013,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_CAPABILITIES_KHR = 1000039000,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_SESSION_PARAMETERS_CREATE_INFO_KHR = 1000039001,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_SESSION_PARAMETERS_ADD_INFO_KHR = 1000039002,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_PICTURE_INFO_KHR = 1000039003,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_DPB_SLOT_INFO_KHR = 1000039004,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_NALU_SLICE_SEGMENT_INFO_KHR = 1000039005,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_GOP_REMAINING_FRAME_INFO_KHR = 1000039006,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_PROFILE_INFO_KHR = 1000039007,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_RATE_CONTROL_INFO_KHR = 1000039009,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_RATE_CONTROL_LAYER_INFO_KHR = 1000039010,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_SESSION_CREATE_INFO_KHR = 1000039011,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_QUALITY_LEVEL_PROPERTIES_KHR = 1000039012,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_SESSION_PARAMETERS_GET_INFO_KHR = 1000039013,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_SESSION_PARAMETERS_FEEDBACK_INFO_KHR = 1000039014,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_CAPABILITIES_KHR = 1000040000,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_PICTURE_INFO_KHR = 1000040001,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_PROFILE_INFO_KHR = 1000040003,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_SESSION_PARAMETERS_CREATE_INFO_KHR = 1000040004,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_SESSION_PARAMETERS_ADD_INFO_KHR = 1000040005,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_DPB_SLOT_INFO_KHR = 1000040006,
        VK_STRUCTURE_TYPE_TEXTURE_LOD_GATHER_FORMAT_PROPERTIES_AMD = 1000041000,
        VK_STRUCTURE_TYPE_STREAM_DESCRIPTOR_SURFACE_CREATE_INFO_GGP = 1000049000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CORNER_SAMPLED_IMAGE_FEATURES_NV = 1000050000,
        VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_IMAGE_CREATE_INFO_NV = 1000056000,
        VK_STRUCTURE_TYPE_EXPORT_MEMORY_ALLOCATE_INFO_NV = 1000056001,
        VK_STRUCTURE_TYPE_IMPORT_MEMORY_WIN32_HANDLE_INFO_NV = 1000057000,
        VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_NV = 1000057001,
        VK_STRUCTURE_TYPE_WIN32_KEYED_MUTEX_ACQUIRE_RELEASE_INFO_NV = 1000058000,
        VK_STRUCTURE_TYPE_VALIDATION_FLAGS_EXT = 1000061000,
        VK_STRUCTURE_TYPE_VI_SURFACE_CREATE_INFO_NN = 1000062000,
        VK_STRUCTURE_TYPE_IMAGE_VIEW_ASTC_DECODE_MODE_EXT = 1000067000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ASTC_DECODE_FEATURES_EXT = 1000067001,
        VK_STRUCTURE_TYPE_IMPORT_MEMORY_WIN32_HANDLE_INFO_KHR = 1000073000,
        VK_STRUCTURE_TYPE_EXPORT_MEMORY_WIN32_HANDLE_INFO_KHR = 1000073001,
        VK_STRUCTURE_TYPE_MEMORY_WIN32_HANDLE_PROPERTIES_KHR = 1000073002,
        VK_STRUCTURE_TYPE_MEMORY_GET_WIN32_HANDLE_INFO_KHR = 1000073003,
        VK_STRUCTURE_TYPE_IMPORT_MEMORY_FD_INFO_KHR = 1000074000,
        VK_STRUCTURE_TYPE_MEMORY_FD_PROPERTIES_KHR = 1000074001,
        VK_STRUCTURE_TYPE_MEMORY_GET_FD_INFO_KHR = 1000074002,
        VK_STRUCTURE_TYPE_WIN32_KEYED_MUTEX_ACQUIRE_RELEASE_INFO_KHR = 1000075000,
        VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR = 1000078000,
        VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_WIN32_HANDLE_INFO_KHR = 1000078001,
        VK_STRUCTURE_TYPE_D3D12_FENCE_SUBMIT_INFO_KHR = 1000078002,
        VK_STRUCTURE_TYPE_SEMAPHORE_GET_WIN32_HANDLE_INFO_KHR = 1000078003,
        VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_FD_INFO_KHR = 1000079000,
        VK_STRUCTURE_TYPE_SEMAPHORE_GET_FD_INFO_KHR = 1000079001,
        VK_STRUCTURE_TYPE_COMMAND_BUFFER_INHERITANCE_CONDITIONAL_RENDERING_INFO_EXT = 1000081000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CONDITIONAL_RENDERING_FEATURES_EXT = 1000081001,
        VK_STRUCTURE_TYPE_CONDITIONAL_RENDERING_BEGIN_INFO_EXT = 1000081002,
        VK_STRUCTURE_TYPE_PRESENT_REGIONS_KHR = 1000084000,
        VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_W_SCALING_STATE_CREATE_INFO_NV = 1000087000,
        VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_2_EXT = 1000090000,
        VK_STRUCTURE_TYPE_DISPLAY_POWER_INFO_EXT = 1000091000,
        VK_STRUCTURE_TYPE_DEVICE_EVENT_INFO_EXT = 1000091001,
        VK_STRUCTURE_TYPE_DISPLAY_EVENT_INFO_EXT = 1000091002,
        VK_STRUCTURE_TYPE_SWAPCHAIN_COUNTER_CREATE_INFO_EXT = 1000091003,
        VK_STRUCTURE_TYPE_PRESENT_TIMES_INFO_GOOGLE = 1000092000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_PER_VIEW_ATTRIBUTES_PROPERTIES_NVX = 1000097000,
        VK_STRUCTURE_TYPE_MULTIVIEW_PER_VIEW_ATTRIBUTES_INFO_NVX = 1000044009,
        VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_SWIZZLE_STATE_CREATE_INFO_NV = 1000098000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DISCARD_RECTANGLE_PROPERTIES_EXT = 1000099000,
        VK_STRUCTURE_TYPE_PIPELINE_DISCARD_RECTANGLE_STATE_CREATE_INFO_EXT = 1000099001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CONSERVATIVE_RASTERIZATION_PROPERTIES_EXT = 1000101000,
        VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_CONSERVATIVE_STATE_CREATE_INFO_EXT = 1000101001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEPTH_CLIP_ENABLE_FEATURES_EXT = 1000102000,
        VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_DEPTH_CLIP_STATE_CREATE_INFO_EXT = 1000102001,
        VK_STRUCTURE_TYPE_HDR_METADATA_EXT = 1000105000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RELAXED_LINE_RASTERIZATION_FEATURES_IMG = 1000110000,
        VK_STRUCTURE_TYPE_SHARED_PRESENT_SURFACE_CAPABILITIES_KHR = 1000111000,
        VK_STRUCTURE_TYPE_IMPORT_FENCE_WIN32_HANDLE_INFO_KHR = 1000114000,
        VK_STRUCTURE_TYPE_EXPORT_FENCE_WIN32_HANDLE_INFO_KHR = 1000114001,
        VK_STRUCTURE_TYPE_FENCE_GET_WIN32_HANDLE_INFO_KHR = 1000114002,
        VK_STRUCTURE_TYPE_IMPORT_FENCE_FD_INFO_KHR = 1000115000,
        VK_STRUCTURE_TYPE_FENCE_GET_FD_INFO_KHR = 1000115001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PERFORMANCE_QUERY_FEATURES_KHR = 1000116000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PERFORMANCE_QUERY_PROPERTIES_KHR = 1000116001,
        VK_STRUCTURE_TYPE_QUERY_POOL_PERFORMANCE_CREATE_INFO_KHR = 1000116002,
        VK_STRUCTURE_TYPE_PERFORMANCE_QUERY_SUBMIT_INFO_KHR = 1000116003,
        VK_STRUCTURE_TYPE_ACQUIRE_PROFILING_LOCK_INFO_KHR = 1000116004,
        VK_STRUCTURE_TYPE_PERFORMANCE_COUNTER_KHR = 1000116005,
        VK_STRUCTURE_TYPE_PERFORMANCE_COUNTER_DESCRIPTION_KHR = 1000116006,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SURFACE_INFO_2_KHR = 1000119000,
        VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_2_KHR = 1000119001,
        VK_STRUCTURE_TYPE_SURFACE_FORMAT_2_KHR = 1000119002,
        VK_STRUCTURE_TYPE_DISPLAY_PROPERTIES_2_KHR = 1000121000,
        VK_STRUCTURE_TYPE_DISPLAY_PLANE_PROPERTIES_2_KHR = 1000121001,
        VK_STRUCTURE_TYPE_DISPLAY_MODE_PROPERTIES_2_KHR = 1000121002,
        VK_STRUCTURE_TYPE_DISPLAY_PLANE_INFO_2_KHR = 1000121003,
        VK_STRUCTURE_TYPE_DISPLAY_PLANE_CAPABILITIES_2_KHR = 1000121004,
        VK_STRUCTURE_TYPE_IOS_SURFACE_CREATE_INFO_MVK = 1000122000,
        VK_STRUCTURE_TYPE_MACOS_SURFACE_CREATE_INFO_MVK = 1000123000,
        VK_STRUCTURE_TYPE_DEBUG_UTILS_OBJECT_NAME_INFO_EXT = 1000128000,
        VK_STRUCTURE_TYPE_DEBUG_UTILS_OBJECT_TAG_INFO_EXT = 1000128001,
        VK_STRUCTURE_TYPE_DEBUG_UTILS_LABEL_EXT = 1000128002,
        VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CALLBACK_DATA_EXT = 1000128003,
        VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT = 1000128004,
        VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_USAGE_ANDROID = 1000129000,
        VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_PROPERTIES_ANDROID = 1000129001,
        VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_FORMAT_PROPERTIES_ANDROID = 1000129002,
        VK_STRUCTURE_TYPE_IMPORT_ANDROID_HARDWARE_BUFFER_INFO_ANDROID = 1000129003,
        VK_STRUCTURE_TYPE_MEMORY_GET_ANDROID_HARDWARE_BUFFER_INFO_ANDROID = 1000129004,
        VK_STRUCTURE_TYPE_EXTERNAL_FORMAT_ANDROID = 1000129005,
        VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_FORMAT_PROPERTIES_2_ANDROID = 1000129006,
        VK_STRUCTURE_TYPE_ATTACHMENT_SAMPLE_COUNT_INFO_AMD = 1000044008,
        VK_STRUCTURE_TYPE_SAMPLE_LOCATIONS_INFO_EXT = 1000143000,
        VK_STRUCTURE_TYPE_RENDER_PASS_SAMPLE_LOCATIONS_BEGIN_INFO_EXT = 1000143001,
        VK_STRUCTURE_TYPE_PIPELINE_SAMPLE_LOCATIONS_STATE_CREATE_INFO_EXT = 1000143002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLE_LOCATIONS_PROPERTIES_EXT = 1000143003,
        VK_STRUCTURE_TYPE_MULTISAMPLE_PROPERTIES_EXT = 1000143004,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BLEND_OPERATION_ADVANCED_FEATURES_EXT = 1000148000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BLEND_OPERATION_ADVANCED_PROPERTIES_EXT = 1000148001,
        VK_STRUCTURE_TYPE_PIPELINE_COLOR_BLEND_ADVANCED_STATE_CREATE_INFO_EXT = 1000148002,
        VK_STRUCTURE_TYPE_PIPELINE_COVERAGE_TO_COLOR_STATE_CREATE_INFO_NV = 1000149000,
        VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET_ACCELERATION_STRUCTURE_KHR = 1000150007,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_BUILD_GEOMETRY_INFO_KHR = 1000150000,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_DEVICE_ADDRESS_INFO_KHR = 1000150002,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_AABBS_DATA_KHR = 1000150003,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_INSTANCES_DATA_KHR = 1000150004,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_TRIANGLES_DATA_KHR = 1000150005,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_KHR = 1000150006,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_VERSION_INFO_KHR = 1000150009,
        VK_STRUCTURE_TYPE_COPY_ACCELERATION_STRUCTURE_INFO_KHR = 1000150010,
        VK_STRUCTURE_TYPE_COPY_ACCELERATION_STRUCTURE_TO_MEMORY_INFO_KHR = 1000150011,
        VK_STRUCTURE_TYPE_COPY_MEMORY_TO_ACCELERATION_STRUCTURE_INFO_KHR = 1000150012,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ACCELERATION_STRUCTURE_FEATURES_KHR = 1000150013,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ACCELERATION_STRUCTURE_PROPERTIES_KHR = 1000150014,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_CREATE_INFO_KHR = 1000150017,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_BUILD_SIZES_INFO_KHR = 1000150020,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_PIPELINE_FEATURES_KHR = 1000347000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_PIPELINE_PROPERTIES_KHR = 1000347001,
        VK_STRUCTURE_TYPE_RAY_TRACING_PIPELINE_CREATE_INFO_KHR = 1000150015,
        VK_STRUCTURE_TYPE_RAY_TRACING_SHADER_GROUP_CREATE_INFO_KHR = 1000150016,
        VK_STRUCTURE_TYPE_RAY_TRACING_PIPELINE_INTERFACE_CREATE_INFO_KHR = 1000150018,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_QUERY_FEATURES_KHR = 1000348013,
        VK_STRUCTURE_TYPE_PIPELINE_COVERAGE_MODULATION_STATE_CREATE_INFO_NV = 1000152000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_SM_BUILTINS_FEATURES_NV = 1000154000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_SM_BUILTINS_PROPERTIES_NV = 1000154001,
        VK_STRUCTURE_TYPE_DRM_FORMAT_MODIFIER_PROPERTIES_LIST_EXT = 1000158000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_DRM_FORMAT_MODIFIER_INFO_EXT = 1000158002,
        VK_STRUCTURE_TYPE_IMAGE_DRM_FORMAT_MODIFIER_LIST_CREATE_INFO_EXT = 1000158003,
        VK_STRUCTURE_TYPE_IMAGE_DRM_FORMAT_MODIFIER_EXPLICIT_CREATE_INFO_EXT = 1000158004,
        VK_STRUCTURE_TYPE_IMAGE_DRM_FORMAT_MODIFIER_PROPERTIES_EXT = 1000158005,
        VK_STRUCTURE_TYPE_DRM_FORMAT_MODIFIER_PROPERTIES_LIST_2_EXT = 1000158006,
        VK_STRUCTURE_TYPE_VALIDATION_CACHE_CREATE_INFO_EXT = 1000160000,
        VK_STRUCTURE_TYPE_SHADER_MODULE_VALIDATION_CACHE_CREATE_INFO_EXT = 1000160001,
        VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_SHADING_RATE_IMAGE_STATE_CREATE_INFO_NV = 1000164000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADING_RATE_IMAGE_FEATURES_NV = 1000164001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADING_RATE_IMAGE_PROPERTIES_NV = 1000164002,
        VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_COARSE_SAMPLE_ORDER_STATE_CREATE_INFO_NV = 1000164005,
        VK_STRUCTURE_TYPE_RAY_TRACING_PIPELINE_CREATE_INFO_NV = 1000165000,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_CREATE_INFO_NV = 1000165001,
        VK_STRUCTURE_TYPE_GEOMETRY_NV = 1000165003,
        VK_STRUCTURE_TYPE_GEOMETRY_TRIANGLES_NV = 1000165004,
        VK_STRUCTURE_TYPE_GEOMETRY_AABB_NV = 1000165005,
        VK_STRUCTURE_TYPE_BIND_ACCELERATION_STRUCTURE_MEMORY_INFO_NV = 1000165006,
        VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET_ACCELERATION_STRUCTURE_NV = 1000165007,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_INFO_NV = 1000165008,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_PROPERTIES_NV = 1000165009,
        VK_STRUCTURE_TYPE_RAY_TRACING_SHADER_GROUP_CREATE_INFO_NV = 1000165011,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_INFO_NV = 1000165012,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_REPRESENTATIVE_FRAGMENT_TEST_FEATURES_NV = 1000166000,
        VK_STRUCTURE_TYPE_PIPELINE_REPRESENTATIVE_FRAGMENT_TEST_STATE_CREATE_INFO_NV = 1000166001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_VIEW_IMAGE_FORMAT_INFO_EXT = 1000170000,
        VK_STRUCTURE_TYPE_FILTER_CUBIC_IMAGE_VIEW_IMAGE_FORMAT_PROPERTIES_EXT = 1000170001,
        VK_STRUCTURE_TYPE_IMPORT_MEMORY_HOST_POINTER_INFO_EXT = 1000178000,
        VK_STRUCTURE_TYPE_MEMORY_HOST_POINTER_PROPERTIES_EXT = 1000178001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_MEMORY_HOST_PROPERTIES_EXT = 1000178002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_CLOCK_FEATURES_KHR = 1000181000,
        VK_STRUCTURE_TYPE_PIPELINE_COMPILER_CONTROL_CREATE_INFO_AMD = 1000183000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_CORE_PROPERTIES_AMD = 1000185000,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_CAPABILITIES_KHR = 1000187000,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_SESSION_PARAMETERS_CREATE_INFO_KHR = 1000187001,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_SESSION_PARAMETERS_ADD_INFO_KHR = 1000187002,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_PROFILE_INFO_KHR = 1000187003,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_PICTURE_INFO_KHR = 1000187004,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_DPB_SLOT_INFO_KHR = 1000187005,
        VK_STRUCTURE_TYPE_DEVICE_MEMORY_OVERALLOCATION_CREATE_INFO_AMD = 1000189000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_ATTRIBUTE_DIVISOR_PROPERTIES_EXT = 1000190000,
        VK_STRUCTURE_TYPE_PRESENT_FRAME_TOKEN_GGP = 1000191000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MESH_SHADER_FEATURES_NV = 1000202000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MESH_SHADER_PROPERTIES_NV = 1000202001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_IMAGE_FOOTPRINT_FEATURES_NV = 1000204000,
        VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_EXCLUSIVE_SCISSOR_STATE_CREATE_INFO_NV = 1000205000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXCLUSIVE_SCISSOR_FEATURES_NV = 1000205002,
        VK_STRUCTURE_TYPE_CHECKPOINT_DATA_NV = 1000206000,
        VK_STRUCTURE_TYPE_QUEUE_FAMILY_CHECKPOINT_PROPERTIES_NV = 1000206001,
        VK_STRUCTURE_TYPE_QUEUE_FAMILY_CHECKPOINT_PROPERTIES_2_NV = 1000314008,
        VK_STRUCTURE_TYPE_CHECKPOINT_DATA_2_NV = 1000314009,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_INTEGER_FUNCTIONS_2_FEATURES_INTEL = 1000209000,
        VK_STRUCTURE_TYPE_QUERY_POOL_PERFORMANCE_QUERY_CREATE_INFO_INTEL = 1000210000,
        VK_STRUCTURE_TYPE_INITIALIZE_PERFORMANCE_API_INFO_INTEL = 1000210001,
        VK_STRUCTURE_TYPE_PERFORMANCE_MARKER_INFO_INTEL = 1000210002,
        VK_STRUCTURE_TYPE_PERFORMANCE_STREAM_MARKER_INFO_INTEL = 1000210003,
        VK_STRUCTURE_TYPE_PERFORMANCE_OVERRIDE_INFO_INTEL = 1000210004,
        VK_STRUCTURE_TYPE_PERFORMANCE_CONFIGURATION_ACQUIRE_INFO_INTEL = 1000210005,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PCI_BUS_INFO_PROPERTIES_EXT = 1000212000,
        VK_STRUCTURE_TYPE_DISPLAY_NATIVE_HDR_SURFACE_CAPABILITIES_AMD = 1000213000,
        VK_STRUCTURE_TYPE_SWAPCHAIN_DISPLAY_NATIVE_HDR_CREATE_INFO_AMD = 1000213001,
        VK_STRUCTURE_TYPE_IMAGEPIPE_SURFACE_CREATE_INFO_FUCHSIA = 1000214000,
        VK_STRUCTURE_TYPE_METAL_SURFACE_CREATE_INFO_EXT = 1000217000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_FEATURES_EXT = 1000218000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_PROPERTIES_EXT = 1000218001,
        VK_STRUCTURE_TYPE_RENDER_PASS_FRAGMENT_DENSITY_MAP_CREATE_INFO_EXT = 1000218002,
        VK_STRUCTURE_TYPE_RENDERING_FRAGMENT_DENSITY_MAP_ATTACHMENT_INFO_EXT = 1000044007,
        VK_STRUCTURE_TYPE_FRAGMENT_SHADING_RATE_ATTACHMENT_INFO_KHR = 1000226000,
        VK_STRUCTURE_TYPE_PIPELINE_FRAGMENT_SHADING_RATE_STATE_CREATE_INFO_KHR = 1000226001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADING_RATE_PROPERTIES_KHR = 1000226002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADING_RATE_FEATURES_KHR = 1000226003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADING_RATE_KHR = 1000226004,
        VK_STRUCTURE_TYPE_RENDERING_FRAGMENT_SHADING_RATE_ATTACHMENT_INFO_KHR = 1000044006,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_CORE_PROPERTIES_2_AMD = 1000227000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COHERENT_MEMORY_FEATURES_AMD = 1000229000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_IMAGE_ATOMIC_INT64_FEATURES_EXT = 1000234000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_QUAD_CONTROL_FEATURES_KHR = 1000235000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_BUDGET_PROPERTIES_EXT = 1000237000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_PRIORITY_FEATURES_EXT = 1000238000,
        VK_STRUCTURE_TYPE_MEMORY_PRIORITY_ALLOCATE_INFO_EXT = 1000238001,
        VK_STRUCTURE_TYPE_SURFACE_PROTECTED_CAPABILITIES_KHR = 1000239000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEDICATED_ALLOCATION_IMAGE_ALIASING_FEATURES_NV = 1000240000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BUFFER_DEVICE_ADDRESS_FEATURES_EXT = 1000244000,
        VK_STRUCTURE_TYPE_BUFFER_DEVICE_ADDRESS_CREATE_INFO_EXT = 1000244002,
        VK_STRUCTURE_TYPE_VALIDATION_FEATURES_EXT = 1000247000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PRESENT_WAIT_FEATURES_KHR = 1000248000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COOPERATIVE_MATRIX_FEATURES_NV = 1000249000,
        VK_STRUCTURE_TYPE_COOPERATIVE_MATRIX_PROPERTIES_NV = 1000249001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COOPERATIVE_MATRIX_PROPERTIES_NV = 1000249002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COVERAGE_REDUCTION_MODE_FEATURES_NV = 1000250000,
        VK_STRUCTURE_TYPE_PIPELINE_COVERAGE_REDUCTION_STATE_CREATE_INFO_NV = 1000250001,
        VK_STRUCTURE_TYPE_FRAMEBUFFER_MIXED_SAMPLES_COMBINATION_NV = 1000250002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADER_INTERLOCK_FEATURES_EXT = 1000251000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_YCBCR_IMAGE_ARRAYS_FEATURES_EXT = 1000252000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROVOKING_VERTEX_FEATURES_EXT = 1000254000,
        VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_PROVOKING_VERTEX_STATE_CREATE_INFO_EXT = 1000254001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROVOKING_VERTEX_PROPERTIES_EXT = 1000254002,
        VK_STRUCTURE_TYPE_SURFACE_FULL_SCREEN_EXCLUSIVE_INFO_EXT = 1000255000,
        VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_FULL_SCREEN_EXCLUSIVE_EXT = 1000255002,
        VK_STRUCTURE_TYPE_SURFACE_FULL_SCREEN_EXCLUSIVE_WIN32_INFO_EXT = 1000255001,
        VK_STRUCTURE_TYPE_HEADLESS_SURFACE_CREATE_INFO_EXT = 1000256000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_ATOMIC_FLOAT_FEATURES_EXT = 1000260000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTENDED_DYNAMIC_STATE_FEATURES_EXT = 1000267000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_EXECUTABLE_PROPERTIES_FEATURES_KHR = 1000269000,
        VK_STRUCTURE_TYPE_PIPELINE_INFO_KHR = 1000269001,
        VK_STRUCTURE_TYPE_PIPELINE_EXECUTABLE_PROPERTIES_KHR = 1000269002,
        VK_STRUCTURE_TYPE_PIPELINE_EXECUTABLE_INFO_KHR = 1000269003,
        VK_STRUCTURE_TYPE_PIPELINE_EXECUTABLE_STATISTIC_KHR = 1000269004,
        VK_STRUCTURE_TYPE_PIPELINE_EXECUTABLE_INTERNAL_REPRESENTATION_KHR = 1000269005,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAP_MEMORY_PLACED_FEATURES_EXT = 1000272000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAP_MEMORY_PLACED_PROPERTIES_EXT = 1000272001,
        VK_STRUCTURE_TYPE_MEMORY_MAP_PLACED_INFO_EXT = 1000272002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_ATOMIC_FLOAT_2_FEATURES_EXT = 1000273000,
        VK_STRUCTURE_TYPE_SURFACE_PRESENT_MODE_EXT = 1000274000,
        VK_STRUCTURE_TYPE_SURFACE_PRESENT_SCALING_CAPABILITIES_EXT = 1000274001,
        VK_STRUCTURE_TYPE_SURFACE_PRESENT_MODE_COMPATIBILITY_EXT = 1000274002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SWAPCHAIN_MAINTENANCE_1_FEATURES_EXT = 1000275000,
        VK_STRUCTURE_TYPE_SWAPCHAIN_PRESENT_FENCE_INFO_EXT = 1000275001,
        VK_STRUCTURE_TYPE_SWAPCHAIN_PRESENT_MODES_CREATE_INFO_EXT = 1000275002,
        VK_STRUCTURE_TYPE_SWAPCHAIN_PRESENT_MODE_INFO_EXT = 1000275003,
        VK_STRUCTURE_TYPE_SWAPCHAIN_PRESENT_SCALING_CREATE_INFO_EXT = 1000275004,
        VK_STRUCTURE_TYPE_RELEASE_SWAPCHAIN_IMAGES_INFO_EXT = 1000275005,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEVICE_GENERATED_COMMANDS_PROPERTIES_NV = 1000277000,
        VK_STRUCTURE_TYPE_GRAPHICS_SHADER_GROUP_CREATE_INFO_NV = 1000277001,
        VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_SHADER_GROUPS_CREATE_INFO_NV = 1000277002,
        VK_STRUCTURE_TYPE_INDIRECT_COMMANDS_LAYOUT_TOKEN_NV = 1000277003,
        VK_STRUCTURE_TYPE_INDIRECT_COMMANDS_LAYOUT_CREATE_INFO_NV = 1000277004,
        VK_STRUCTURE_TYPE_GENERATED_COMMANDS_INFO_NV = 1000277005,
        VK_STRUCTURE_TYPE_GENERATED_COMMANDS_MEMORY_REQUIREMENTS_INFO_NV = 1000277006,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEVICE_GENERATED_COMMANDS_FEATURES_NV = 1000277007,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_INHERITED_VIEWPORT_SCISSOR_FEATURES_NV = 1000278000,
        VK_STRUCTURE_TYPE_COMMAND_BUFFER_INHERITANCE_VIEWPORT_SCISSOR_INFO_NV = 1000278001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TEXEL_BUFFER_ALIGNMENT_FEATURES_EXT = 1000281000,
        VK_STRUCTURE_TYPE_COMMAND_BUFFER_INHERITANCE_RENDER_PASS_TRANSFORM_INFO_QCOM = 1000282000,
        VK_STRUCTURE_TYPE_RENDER_PASS_TRANSFORM_BEGIN_INFO_QCOM = 1000282001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEPTH_BIAS_CONTROL_FEATURES_EXT = 1000283000,
        VK_STRUCTURE_TYPE_DEPTH_BIAS_INFO_EXT = 1000283001,
        VK_STRUCTURE_TYPE_DEPTH_BIAS_REPRESENTATION_INFO_EXT = 1000283002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEVICE_MEMORY_REPORT_FEATURES_EXT = 1000284000,
        VK_STRUCTURE_TYPE_DEVICE_DEVICE_MEMORY_REPORT_CREATE_INFO_EXT = 1000284001,
        VK_STRUCTURE_TYPE_DEVICE_MEMORY_REPORT_CALLBACK_DATA_EXT = 1000284002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ROBUSTNESS_2_FEATURES_EXT = 1000286000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ROBUSTNESS_2_PROPERTIES_EXT = 1000286001,
        VK_STRUCTURE_TYPE_SAMPLER_CUSTOM_BORDER_COLOR_CREATE_INFO_EXT = 1000287000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CUSTOM_BORDER_COLOR_PROPERTIES_EXT = 1000287001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CUSTOM_BORDER_COLOR_FEATURES_EXT = 1000287002,
        VK_STRUCTURE_TYPE_PIPELINE_LIBRARY_CREATE_INFO_KHR = 1000290000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PRESENT_BARRIER_FEATURES_NV = 1000292000,
        VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES_PRESENT_BARRIER_NV = 1000292001,
        VK_STRUCTURE_TYPE_SWAPCHAIN_PRESENT_BARRIER_CREATE_INFO_NV = 1000292002,
        VK_STRUCTURE_TYPE_PRESENT_ID_KHR = 1000294000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PRESENT_ID_FEATURES_KHR = 1000294001,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_INFO_KHR = 1000299000,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_RATE_CONTROL_INFO_KHR = 1000299001,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_RATE_CONTROL_LAYER_INFO_KHR = 1000299002,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_CAPABILITIES_KHR = 1000299003,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_USAGE_INFO_KHR = 1000299004,
        VK_STRUCTURE_TYPE_QUERY_POOL_VIDEO_ENCODE_FEEDBACK_CREATE_INFO_KHR = 1000299005,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VIDEO_ENCODE_QUALITY_LEVEL_INFO_KHR = 1000299006,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_QUALITY_LEVEL_PROPERTIES_KHR = 1000299007,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_QUALITY_LEVEL_INFO_KHR = 1000299008,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_SESSION_PARAMETERS_GET_INFO_KHR = 1000299009,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_SESSION_PARAMETERS_FEEDBACK_INFO_KHR = 1000299010,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DIAGNOSTICS_CONFIG_FEATURES_NV = 1000300000,
        VK_STRUCTURE_TYPE_DEVICE_DIAGNOSTICS_CONFIG_CREATE_INFO_NV = 1000300001,
        VK_STRUCTURE_TYPE_CUDA_MODULE_CREATE_INFO_NV = 1000307000,
        VK_STRUCTURE_TYPE_CUDA_FUNCTION_CREATE_INFO_NV = 1000307001,
        VK_STRUCTURE_TYPE_CUDA_LAUNCH_INFO_NV = 1000307002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CUDA_KERNEL_LAUNCH_FEATURES_NV = 1000307003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CUDA_KERNEL_LAUNCH_PROPERTIES_NV = 1000307004,
        VK_STRUCTURE_TYPE_QUERY_LOW_LATENCY_SUPPORT_NV = 1000310000,
        VK_STRUCTURE_TYPE_EXPORT_METAL_OBJECT_CREATE_INFO_EXT = 1000311000,
        VK_STRUCTURE_TYPE_EXPORT_METAL_OBJECTS_INFO_EXT = 1000311001,
        VK_STRUCTURE_TYPE_EXPORT_METAL_DEVICE_INFO_EXT = 1000311002,
        VK_STRUCTURE_TYPE_EXPORT_METAL_COMMAND_QUEUE_INFO_EXT = 1000311003,
        VK_STRUCTURE_TYPE_EXPORT_METAL_BUFFER_INFO_EXT = 1000311004,
        VK_STRUCTURE_TYPE_IMPORT_METAL_BUFFER_INFO_EXT = 1000311005,
        VK_STRUCTURE_TYPE_EXPORT_METAL_TEXTURE_INFO_EXT = 1000311006,
        VK_STRUCTURE_TYPE_IMPORT_METAL_TEXTURE_INFO_EXT = 1000311007,
        VK_STRUCTURE_TYPE_EXPORT_METAL_IO_SURFACE_INFO_EXT = 1000311008,
        VK_STRUCTURE_TYPE_IMPORT_METAL_IO_SURFACE_INFO_EXT = 1000311009,
        VK_STRUCTURE_TYPE_EXPORT_METAL_SHARED_EVENT_INFO_EXT = 1000311010,
        VK_STRUCTURE_TYPE_IMPORT_METAL_SHARED_EVENT_INFO_EXT = 1000311011,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_BUFFER_PROPERTIES_EXT = 1000316000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_BUFFER_DENSITY_MAP_PROPERTIES_EXT = 1000316001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_BUFFER_FEATURES_EXT = 1000316002,
        VK_STRUCTURE_TYPE_DESCRIPTOR_ADDRESS_INFO_EXT = 1000316003,
        VK_STRUCTURE_TYPE_DESCRIPTOR_GET_INFO_EXT = 1000316004,
        VK_STRUCTURE_TYPE_BUFFER_CAPTURE_DESCRIPTOR_DATA_INFO_EXT = 1000316005,
        VK_STRUCTURE_TYPE_IMAGE_CAPTURE_DESCRIPTOR_DATA_INFO_EXT = 1000316006,
        VK_STRUCTURE_TYPE_IMAGE_VIEW_CAPTURE_DESCRIPTOR_DATA_INFO_EXT = 1000316007,
        VK_STRUCTURE_TYPE_SAMPLER_CAPTURE_DESCRIPTOR_DATA_INFO_EXT = 1000316008,
        VK_STRUCTURE_TYPE_OPAQUE_CAPTURE_DESCRIPTOR_DATA_CREATE_INFO_EXT = 1000316010,
        VK_STRUCTURE_TYPE_DESCRIPTOR_BUFFER_BINDING_INFO_EXT = 1000316011,
        VK_STRUCTURE_TYPE_DESCRIPTOR_BUFFER_BINDING_PUSH_DESCRIPTOR_BUFFER_HANDLE_EXT = 1000316012,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_CAPTURE_DESCRIPTOR_DATA_INFO_EXT = 1000316009,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_GRAPHICS_PIPELINE_LIBRARY_FEATURES_EXT = 1000320000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_GRAPHICS_PIPELINE_LIBRARY_PROPERTIES_EXT = 1000320001,
        VK_STRUCTURE_TYPE_GRAPHICS_PIPELINE_LIBRARY_CREATE_INFO_EXT = 1000320002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_EARLY_AND_LATE_FRAGMENT_TESTS_FEATURES_AMD = 1000321000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADER_BARYCENTRIC_FEATURES_KHR = 1000203000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADER_BARYCENTRIC_PROPERTIES_KHR = 1000322000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_SUBGROUP_UNIFORM_CONTROL_FLOW_FEATURES_KHR = 1000323000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADING_RATE_ENUMS_PROPERTIES_NV = 1000326000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADING_RATE_ENUMS_FEATURES_NV = 1000326001,
        VK_STRUCTURE_TYPE_PIPELINE_FRAGMENT_SHADING_RATE_ENUM_STATE_CREATE_INFO_NV = 1000326002,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_MOTION_TRIANGLES_DATA_NV = 1000327000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_MOTION_BLUR_FEATURES_NV = 1000327001,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_MOTION_INFO_NV = 1000327002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MESH_SHADER_FEATURES_EXT = 1000328000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MESH_SHADER_PROPERTIES_EXT = 1000328001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_YCBCR_2_PLANE_444_FORMATS_FEATURES_EXT = 1000330000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_2_FEATURES_EXT = 1000332000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_2_PROPERTIES_EXT = 1000332001,
        VK_STRUCTURE_TYPE_COPY_COMMAND_TRANSFORM_INFO_QCOM = 1000333000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_WORKGROUP_MEMORY_EXPLICIT_LAYOUT_FEATURES_KHR = 1000336000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_COMPRESSION_CONTROL_FEATURES_EXT = 1000338000,
        VK_STRUCTURE_TYPE_IMAGE_COMPRESSION_CONTROL_EXT = 1000338001,
        VK_STRUCTURE_TYPE_IMAGE_COMPRESSION_PROPERTIES_EXT = 1000338004,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ATTACHMENT_FEEDBACK_LOOP_LAYOUT_FEATURES_EXT = 1000339000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_4444_FORMATS_FEATURES_EXT = 1000340000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FAULT_FEATURES_EXT = 1000341000,
        VK_STRUCTURE_TYPE_DEVICE_FAULT_COUNTS_EXT = 1000341001,
        VK_STRUCTURE_TYPE_DEVICE_FAULT_INFO_EXT = 1000341002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RGBA10X6_FORMATS_FEATURES_EXT = 1000344000,
        VK_STRUCTURE_TYPE_DIRECTFB_SURFACE_CREATE_INFO_EXT = 1000346000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_INPUT_DYNAMIC_STATE_FEATURES_EXT = 1000352000,
        VK_STRUCTURE_TYPE_VERTEX_INPUT_BINDING_DESCRIPTION_2_EXT = 1000352001,
        VK_STRUCTURE_TYPE_VERTEX_INPUT_ATTRIBUTE_DESCRIPTION_2_EXT = 1000352002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DRM_PROPERTIES_EXT = 1000353000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ADDRESS_BINDING_REPORT_FEATURES_EXT = 1000354000,
        VK_STRUCTURE_TYPE_DEVICE_ADDRESS_BINDING_CALLBACK_DATA_EXT = 1000354001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEPTH_CLIP_CONTROL_FEATURES_EXT = 1000355000,
        VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_DEPTH_CLIP_CONTROL_CREATE_INFO_EXT = 1000355001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PRIMITIVE_TOPOLOGY_LIST_RESTART_FEATURES_EXT = 1000356000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PRESENT_MODE_FIFO_LATEST_READY_FEATURES_EXT = 1000361000,
        VK_STRUCTURE_TYPE_IMPORT_MEMORY_ZIRCON_HANDLE_INFO_FUCHSIA = 1000364000,
        VK_STRUCTURE_TYPE_MEMORY_ZIRCON_HANDLE_PROPERTIES_FUCHSIA = 1000364001,
        VK_STRUCTURE_TYPE_MEMORY_GET_ZIRCON_HANDLE_INFO_FUCHSIA = 1000364002,
        VK_STRUCTURE_TYPE_IMPORT_SEMAPHORE_ZIRCON_HANDLE_INFO_FUCHSIA = 1000365000,
        VK_STRUCTURE_TYPE_SEMAPHORE_GET_ZIRCON_HANDLE_INFO_FUCHSIA = 1000365001,
        VK_STRUCTURE_TYPE_BUFFER_COLLECTION_CREATE_INFO_FUCHSIA = 1000366000,
        VK_STRUCTURE_TYPE_IMPORT_MEMORY_BUFFER_COLLECTION_FUCHSIA = 1000366001,
        VK_STRUCTURE_TYPE_BUFFER_COLLECTION_IMAGE_CREATE_INFO_FUCHSIA = 1000366002,
        VK_STRUCTURE_TYPE_BUFFER_COLLECTION_PROPERTIES_FUCHSIA = 1000366003,
        VK_STRUCTURE_TYPE_BUFFER_CONSTRAINTS_INFO_FUCHSIA = 1000366004,
        VK_STRUCTURE_TYPE_BUFFER_COLLECTION_BUFFER_CREATE_INFO_FUCHSIA = 1000366005,
        VK_STRUCTURE_TYPE_IMAGE_CONSTRAINTS_INFO_FUCHSIA = 1000366006,
        VK_STRUCTURE_TYPE_IMAGE_FORMAT_CONSTRAINTS_INFO_FUCHSIA = 1000366007,
        VK_STRUCTURE_TYPE_SYSMEM_COLOR_SPACE_FUCHSIA = 1000366008,
        VK_STRUCTURE_TYPE_BUFFER_COLLECTION_CONSTRAINTS_INFO_FUCHSIA = 1000366009,
        VK_STRUCTURE_TYPE_SUBPASS_SHADING_PIPELINE_CREATE_INFO_HUAWEI = 1000369000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SUBPASS_SHADING_FEATURES_HUAWEI = 1000369001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SUBPASS_SHADING_PROPERTIES_HUAWEI = 1000369002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_INVOCATION_MASK_FEATURES_HUAWEI = 1000370000,
        VK_STRUCTURE_TYPE_MEMORY_GET_REMOTE_ADDRESS_INFO_NV = 1000371000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_MEMORY_RDMA_FEATURES_NV = 1000371001,
        VK_STRUCTURE_TYPE_PIPELINE_PROPERTIES_IDENTIFIER_EXT = 1000372000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_PROPERTIES_FEATURES_EXT = 1000372001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAME_BOUNDARY_FEATURES_EXT = 1000375000,
        VK_STRUCTURE_TYPE_FRAME_BOUNDARY_EXT = 1000375001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTISAMPLED_RENDER_TO_SINGLE_SAMPLED_FEATURES_EXT = 1000376000,
        VK_STRUCTURE_TYPE_SUBPASS_RESOLVE_PERFORMANCE_QUERY_EXT = 1000376001,
        VK_STRUCTURE_TYPE_MULTISAMPLED_RENDER_TO_SINGLE_SAMPLED_INFO_EXT = 1000376002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTENDED_DYNAMIC_STATE_2_FEATURES_EXT = 1000377000,
        VK_STRUCTURE_TYPE_SCREEN_SURFACE_CREATE_INFO_QNX = 1000378000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COLOR_WRITE_ENABLE_FEATURES_EXT = 1000381000,
        VK_STRUCTURE_TYPE_PIPELINE_COLOR_WRITE_CREATE_INFO_EXT = 1000381001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PRIMITIVES_GENERATED_QUERY_FEATURES_EXT = 1000382000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_MAINTENANCE_1_FEATURES_KHR = 1000386000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_VIEW_MIN_LOD_FEATURES_EXT = 1000391000,
        VK_STRUCTURE_TYPE_IMAGE_VIEW_MIN_LOD_CREATE_INFO_EXT = 1000391001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTI_DRAW_FEATURES_EXT = 1000392000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTI_DRAW_PROPERTIES_EXT = 1000392001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_2D_VIEW_OF_3D_FEATURES_EXT = 1000393000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_TILE_IMAGE_FEATURES_EXT = 1000395000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_TILE_IMAGE_PROPERTIES_EXT = 1000395001,
        VK_STRUCTURE_TYPE_MICROMAP_BUILD_INFO_EXT = 1000396000,
        VK_STRUCTURE_TYPE_MICROMAP_VERSION_INFO_EXT = 1000396001,
        VK_STRUCTURE_TYPE_COPY_MICROMAP_INFO_EXT = 1000396002,
        VK_STRUCTURE_TYPE_COPY_MICROMAP_TO_MEMORY_INFO_EXT = 1000396003,
        VK_STRUCTURE_TYPE_COPY_MEMORY_TO_MICROMAP_INFO_EXT = 1000396004,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_OPACITY_MICROMAP_FEATURES_EXT = 1000396005,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_OPACITY_MICROMAP_PROPERTIES_EXT = 1000396006,
        VK_STRUCTURE_TYPE_MICROMAP_CREATE_INFO_EXT = 1000396007,
        VK_STRUCTURE_TYPE_MICROMAP_BUILD_SIZES_INFO_EXT = 1000396008,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_TRIANGLES_OPACITY_MICROMAP_EXT = 1000396009,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CLUSTER_CULLING_SHADER_FEATURES_HUAWEI = 1000404000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CLUSTER_CULLING_SHADER_PROPERTIES_HUAWEI = 1000404001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CLUSTER_CULLING_SHADER_VRS_FEATURES_HUAWEI = 1000404002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BORDER_COLOR_SWIZZLE_FEATURES_EXT = 1000411000,
        VK_STRUCTURE_TYPE_SAMPLER_BORDER_COLOR_COMPONENT_MAPPING_CREATE_INFO_EXT = 1000411001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PAGEABLE_DEVICE_LOCAL_MEMORY_FEATURES_EXT = 1000412000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_CORE_PROPERTIES_ARM = 1000415000,
        VK_STRUCTURE_TYPE_DEVICE_QUEUE_SHADER_CORE_CONTROL_CREATE_INFO_ARM = 1000417000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SCHEDULING_CONTROLS_FEATURES_ARM = 1000417001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SCHEDULING_CONTROLS_PROPERTIES_ARM = 1000417002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_SLICED_VIEW_OF_3D_FEATURES_EXT = 1000418000,
        VK_STRUCTURE_TYPE_IMAGE_VIEW_SLICED_CREATE_INFO_EXT = 1000418001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_SET_HOST_MAPPING_FEATURES_VALVE = 1000420000,
        VK_STRUCTURE_TYPE_DESCRIPTOR_SET_BINDING_REFERENCE_VALVE = 1000420001,
        VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_HOST_MAPPING_INFO_VALVE = 1000420002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_NON_SEAMLESS_CUBE_MAP_FEATURES_EXT = 1000422000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RENDER_PASS_STRIPED_FEATURES_ARM = 1000424000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RENDER_PASS_STRIPED_PROPERTIES_ARM = 1000424001,
        VK_STRUCTURE_TYPE_RENDER_PASS_STRIPE_BEGIN_INFO_ARM = 1000424002,
        VK_STRUCTURE_TYPE_RENDER_PASS_STRIPE_INFO_ARM = 1000424003,
        VK_STRUCTURE_TYPE_RENDER_PASS_STRIPE_SUBMIT_INFO_ARM = 1000424004,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_OFFSET_FEATURES_QCOM = 1000425000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_DENSITY_MAP_OFFSET_PROPERTIES_QCOM = 1000425001,
        VK_STRUCTURE_TYPE_SUBPASS_FRAGMENT_DENSITY_MAP_OFFSET_END_INFO_QCOM = 1000425002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COPY_MEMORY_INDIRECT_FEATURES_NV = 1000426000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COPY_MEMORY_INDIRECT_PROPERTIES_NV = 1000426001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_DECOMPRESSION_FEATURES_NV = 1000427000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_DECOMPRESSION_PROPERTIES_NV = 1000427001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEVICE_GENERATED_COMMANDS_COMPUTE_FEATURES_NV = 1000428000,
        VK_STRUCTURE_TYPE_COMPUTE_PIPELINE_INDIRECT_BUFFER_INFO_NV = 1000428001,
        VK_STRUCTURE_TYPE_PIPELINE_INDIRECT_DEVICE_ADDRESS_INFO_NV = 1000428002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_LINEAR_SWEPT_SPHERES_FEATURES_NV = 1000429008,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_LINEAR_SWEPT_SPHERES_DATA_NV = 1000429009,
        VK_STRUCTURE_TYPE_ACCELERATION_STRUCTURE_GEOMETRY_SPHERES_DATA_NV = 1000429010,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LINEAR_COLOR_ATTACHMENT_FEATURES_NV = 1000430000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_MAXIMAL_RECONVERGENCE_FEATURES_KHR = 1000434000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_COMPRESSION_CONTROL_SWAPCHAIN_FEATURES_EXT = 1000437000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_PROCESSING_FEATURES_QCOM = 1000440000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_PROCESSING_PROPERTIES_QCOM = 1000440001,
        VK_STRUCTURE_TYPE_IMAGE_VIEW_SAMPLE_WEIGHT_CREATE_INFO_QCOM = 1000440002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_NESTED_COMMAND_BUFFER_FEATURES_EXT = 1000451000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_NESTED_COMMAND_BUFFER_PROPERTIES_EXT = 1000451001,
        VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_ACQUIRE_UNMODIFIED_EXT = 1000453000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTENDED_DYNAMIC_STATE_3_FEATURES_EXT = 1000455000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTENDED_DYNAMIC_STATE_3_PROPERTIES_EXT = 1000455001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SUBPASS_MERGE_FEEDBACK_FEATURES_EXT = 1000458000,
        VK_STRUCTURE_TYPE_RENDER_PASS_CREATION_CONTROL_EXT = 1000458001,
        VK_STRUCTURE_TYPE_RENDER_PASS_CREATION_FEEDBACK_CREATE_INFO_EXT = 1000458002,
        VK_STRUCTURE_TYPE_RENDER_PASS_SUBPASS_FEEDBACK_CREATE_INFO_EXT = 1000458003,
        VK_STRUCTURE_TYPE_DIRECT_DRIVER_LOADING_INFO_LUNARG = 1000459000,
        VK_STRUCTURE_TYPE_DIRECT_DRIVER_LOADING_LIST_LUNARG = 1000459001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_MODULE_IDENTIFIER_FEATURES_EXT = 1000462000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_MODULE_IDENTIFIER_PROPERTIES_EXT = 1000462001,
        VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_MODULE_IDENTIFIER_CREATE_INFO_EXT = 1000462002,
        VK_STRUCTURE_TYPE_SHADER_MODULE_IDENTIFIER_EXT = 1000462003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RASTERIZATION_ORDER_ATTACHMENT_ACCESS_FEATURES_EXT = 1000342000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_OPTICAL_FLOW_FEATURES_NV = 1000464000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_OPTICAL_FLOW_PROPERTIES_NV = 1000464001,
        VK_STRUCTURE_TYPE_OPTICAL_FLOW_IMAGE_FORMAT_INFO_NV = 1000464002,
        VK_STRUCTURE_TYPE_OPTICAL_FLOW_IMAGE_FORMAT_PROPERTIES_NV = 1000464003,
        VK_STRUCTURE_TYPE_OPTICAL_FLOW_SESSION_CREATE_INFO_NV = 1000464004,
        VK_STRUCTURE_TYPE_OPTICAL_FLOW_EXECUTE_INFO_NV = 1000464005,
        VK_STRUCTURE_TYPE_OPTICAL_FLOW_SESSION_CREATE_PRIVATE_DATA_INFO_NV = 1000464010,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LEGACY_DITHERING_FEATURES_EXT = 1000465000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_FORMAT_RESOLVE_FEATURES_ANDROID = 1000468000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_FORMAT_RESOLVE_PROPERTIES_ANDROID = 1000468001,
        VK_STRUCTURE_TYPE_ANDROID_HARDWARE_BUFFER_FORMAT_RESOLVE_PROPERTIES_ANDROID = 1000468002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ANTI_LAG_FEATURES_AMD = 1000476000,
        VK_STRUCTURE_TYPE_ANTI_LAG_DATA_AMD = 1000476001,
        VK_STRUCTURE_TYPE_ANTI_LAG_PRESENTATION_INFO_AMD = 1000476002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_POSITION_FETCH_FEATURES_KHR = 1000481000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_OBJECT_FEATURES_EXT = 1000482000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_OBJECT_PROPERTIES_EXT = 1000482001,
        VK_STRUCTURE_TYPE_SHADER_CREATE_INFO_EXT = 1000482002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_BINARY_FEATURES_KHR = 1000483000,
        VK_STRUCTURE_TYPE_PIPELINE_BINARY_CREATE_INFO_KHR = 1000483001,
        VK_STRUCTURE_TYPE_PIPELINE_BINARY_INFO_KHR = 1000483002,
        VK_STRUCTURE_TYPE_PIPELINE_BINARY_KEY_KHR = 1000483003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_BINARY_PROPERTIES_KHR = 1000483004,
        VK_STRUCTURE_TYPE_RELEASE_CAPTURED_PIPELINE_DATA_INFO_KHR = 1000483005,
        VK_STRUCTURE_TYPE_PIPELINE_BINARY_DATA_INFO_KHR = 1000483006,
        VK_STRUCTURE_TYPE_PIPELINE_CREATE_INFO_KHR = 1000483007,
        VK_STRUCTURE_TYPE_DEVICE_PIPELINE_BINARY_INTERNAL_CACHE_CONTROL_KHR = 1000483008,
        VK_STRUCTURE_TYPE_PIPELINE_BINARY_HANDLES_INFO_KHR = 1000483009,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TILE_PROPERTIES_FEATURES_QCOM = 1000484000,
        VK_STRUCTURE_TYPE_TILE_PROPERTIES_QCOM = 1000484001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_AMIGO_PROFILING_FEATURES_SEC = 1000485000,
        VK_STRUCTURE_TYPE_AMIGO_PROFILING_SUBMIT_INFO_SEC = 1000485001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_PER_VIEW_VIEWPORTS_FEATURES_QCOM = 1000488000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_INVOCATION_REORDER_FEATURES_NV = 1000490000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_INVOCATION_REORDER_PROPERTIES_NV = 1000490001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COOPERATIVE_VECTOR_FEATURES_NV = 1000491000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COOPERATIVE_VECTOR_PROPERTIES_NV = 1000491001,
        VK_STRUCTURE_TYPE_COOPERATIVE_VECTOR_PROPERTIES_NV = 1000491002,
        VK_STRUCTURE_TYPE_CONVERT_COOPERATIVE_VECTOR_MATRIX_INFO_NV = 1000491004,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTENDED_SPARSE_ADDRESS_SPACE_FEATURES_NV = 1000492000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTENDED_SPARSE_ADDRESS_SPACE_PROPERTIES_NV = 1000492001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MUTABLE_DESCRIPTOR_TYPE_FEATURES_EXT = 1000351000,
        VK_STRUCTURE_TYPE_MUTABLE_DESCRIPTOR_TYPE_CREATE_INFO_EXT = 1000351002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LEGACY_VERTEX_ATTRIBUTES_FEATURES_EXT = 1000495000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LEGACY_VERTEX_ATTRIBUTES_PROPERTIES_EXT = 1000495001,
        VK_STRUCTURE_TYPE_LAYER_SETTINGS_CREATE_INFO_EXT = 1000496000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_CORE_BUILTINS_FEATURES_ARM = 1000497000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_CORE_BUILTINS_PROPERTIES_ARM = 1000497001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_LIBRARY_GROUP_HANDLES_FEATURES_EXT = 1000498000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DYNAMIC_RENDERING_UNUSED_ATTACHMENTS_FEATURES_EXT = 1000499000,
        VK_STRUCTURE_TYPE_LATENCY_SLEEP_MODE_INFO_NV = 1000505000,
        VK_STRUCTURE_TYPE_LATENCY_SLEEP_INFO_NV = 1000505001,
        VK_STRUCTURE_TYPE_SET_LATENCY_MARKER_INFO_NV = 1000505002,
        VK_STRUCTURE_TYPE_GET_LATENCY_MARKER_INFO_NV = 1000505003,
        VK_STRUCTURE_TYPE_LATENCY_TIMINGS_FRAME_REPORT_NV = 1000505004,
        VK_STRUCTURE_TYPE_LATENCY_SUBMISSION_PRESENT_ID_NV = 1000505005,
        VK_STRUCTURE_TYPE_OUT_OF_BAND_QUEUE_TYPE_INFO_NV = 1000505006,
        VK_STRUCTURE_TYPE_SWAPCHAIN_LATENCY_CREATE_INFO_NV = 1000505007,
        VK_STRUCTURE_TYPE_LATENCY_SURFACE_CAPABILITIES_NV = 1000505008,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COOPERATIVE_MATRIX_FEATURES_KHR = 1000506000,
        VK_STRUCTURE_TYPE_COOPERATIVE_MATRIX_PROPERTIES_KHR = 1000506001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COOPERATIVE_MATRIX_PROPERTIES_KHR = 1000506002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_PER_VIEW_RENDER_AREAS_FEATURES_QCOM = 1000510000,
        VK_STRUCTURE_TYPE_MULTIVIEW_PER_VIEW_RENDER_AREAS_RENDER_PASS_BEGIN_INFO_QCOM = 1000510001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COMPUTE_SHADER_DERIVATIVES_FEATURES_KHR = 1000201000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COMPUTE_SHADER_DERIVATIVES_PROPERTIES_KHR = 1000511000,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_AV1_CAPABILITIES_KHR = 1000512000,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_AV1_PICTURE_INFO_KHR = 1000512001,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_AV1_PROFILE_INFO_KHR = 1000512003,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_AV1_SESSION_PARAMETERS_CREATE_INFO_KHR = 1000512004,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_AV1_DPB_SLOT_INFO_KHR = 1000512005,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_CAPABILITIES_KHR = 1000513000,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_SESSION_PARAMETERS_CREATE_INFO_KHR = 1000513001,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_PICTURE_INFO_KHR = 1000513002,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_DPB_SLOT_INFO_KHR = 1000513003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VIDEO_ENCODE_AV1_FEATURES_KHR = 1000513004,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_PROFILE_INFO_KHR = 1000513005,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_RATE_CONTROL_INFO_KHR = 1000513006,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_RATE_CONTROL_LAYER_INFO_KHR = 1000513007,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_QUALITY_LEVEL_PROPERTIES_KHR = 1000513008,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_SESSION_CREATE_INFO_KHR = 1000513009,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_GOP_REMAINING_FRAME_INFO_KHR = 1000513010,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VIDEO_MAINTENANCE_1_FEATURES_KHR = 1000515000,
        VK_STRUCTURE_TYPE_VIDEO_INLINE_QUERY_INFO_KHR = 1000515001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PER_STAGE_DESCRIPTOR_SET_FEATURES_NV = 1000516000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_PROCESSING_2_FEATURES_QCOM = 1000518000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_PROCESSING_2_PROPERTIES_QCOM = 1000518001,
        VK_STRUCTURE_TYPE_SAMPLER_BLOCK_MATCH_WINDOW_CREATE_INFO_QCOM = 1000518002,
        VK_STRUCTURE_TYPE_SAMPLER_CUBIC_WEIGHTS_CREATE_INFO_QCOM = 1000519000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CUBIC_WEIGHTS_FEATURES_QCOM = 1000519001,
        VK_STRUCTURE_TYPE_BLIT_IMAGE_CUBIC_WEIGHTS_INFO_QCOM = 1000519002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_YCBCR_DEGAMMA_FEATURES_QCOM = 1000520000,
        VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_YCBCR_DEGAMMA_CREATE_INFO_QCOM = 1000520001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CUBIC_CLAMP_FEATURES_QCOM = 1000521000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ATTACHMENT_FEEDBACK_LOOP_DYNAMIC_STATE_FEATURES_EXT = 1000524000,
        VK_STRUCTURE_TYPE_SCREEN_BUFFER_PROPERTIES_QNX = 1000529000,
        VK_STRUCTURE_TYPE_SCREEN_BUFFER_FORMAT_PROPERTIES_QNX = 1000529001,
        VK_STRUCTURE_TYPE_IMPORT_SCREEN_BUFFER_INFO_QNX = 1000529002,
        VK_STRUCTURE_TYPE_EXTERNAL_FORMAT_QNX = 1000529003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_MEMORY_SCREEN_BUFFER_FEATURES_QNX = 1000529004,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LAYERED_DRIVER_PROPERTIES_MSFT = 1000530000,
        VK_STRUCTURE_TYPE_CALIBRATED_TIMESTAMP_INFO_KHR = 1000184000,
        VK_STRUCTURE_TYPE_SET_DESCRIPTOR_BUFFER_OFFSETS_INFO_EXT = 1000545007,
        VK_STRUCTURE_TYPE_BIND_DESCRIPTOR_BUFFER_EMBEDDED_SAMPLERS_INFO_EXT = 1000545008,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_POOL_OVERALLOCATION_FEATURES_NV = 1000546000,
        VK_STRUCTURE_TYPE_DISPLAY_SURFACE_STEREO_CREATE_INFO_NV = 1000551000,
        VK_STRUCTURE_TYPE_DISPLAY_MODE_STEREO_PROPERTIES_NV = 1000551001,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_QUANTIZATION_MAP_CAPABILITIES_KHR = 1000553000,
        VK_STRUCTURE_TYPE_VIDEO_FORMAT_QUANTIZATION_MAP_PROPERTIES_KHR = 1000553001,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_QUANTIZATION_MAP_INFO_KHR = 1000553002,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_QUANTIZATION_MAP_SESSION_PARAMETERS_CREATE_INFO_KHR = 1000553005,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VIDEO_ENCODE_QUANTIZATION_MAP_FEATURES_KHR = 1000553009,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H264_QUANTIZATION_MAP_CAPABILITIES_KHR = 1000553003,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_H265_QUANTIZATION_MAP_CAPABILITIES_KHR = 1000553004,
        VK_STRUCTURE_TYPE_VIDEO_FORMAT_H265_QUANTIZATION_MAP_PROPERTIES_KHR = 1000553006,
        VK_STRUCTURE_TYPE_VIDEO_ENCODE_AV1_QUANTIZATION_MAP_CAPABILITIES_KHR = 1000553007,
        VK_STRUCTURE_TYPE_VIDEO_FORMAT_AV1_QUANTIZATION_MAP_PROPERTIES_KHR = 1000553008,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAW_ACCESS_CHAINS_FEATURES_NV = 1000555000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_RELAXED_EXTENDED_INSTRUCTION_FEATURES_KHR = 1000558000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COMMAND_BUFFER_INHERITANCE_FEATURES_NV = 1000559000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_7_FEATURES_KHR = 1000562000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_7_PROPERTIES_KHR = 1000562001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LAYERED_API_PROPERTIES_LIST_KHR = 1000562002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LAYERED_API_PROPERTIES_KHR = 1000562003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LAYERED_API_VULKAN_PROPERTIES_KHR = 1000562004,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_ATOMIC_FLOAT16_VECTOR_FEATURES_NV = 1000563000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_REPLICATED_COMPOSITES_FEATURES_EXT = 1000564000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RAY_TRACING_VALIDATION_FEATURES_NV = 1000568000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CLUSTER_ACCELERATION_STRUCTURE_FEATURES_NV = 1000569000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_CLUSTER_ACCELERATION_STRUCTURE_PROPERTIES_NV = 1000569001,
        VK_STRUCTURE_TYPE_CLUSTER_ACCELERATION_STRUCTURE_CLUSTERS_BOTTOM_LEVEL_INPUT_NV = 1000569002,
        VK_STRUCTURE_TYPE_CLUSTER_ACCELERATION_STRUCTURE_TRIANGLE_CLUSTER_INPUT_NV = 1000569003,
        VK_STRUCTURE_TYPE_CLUSTER_ACCELERATION_STRUCTURE_MOVE_OBJECTS_INPUT_NV = 1000569004,
        VK_STRUCTURE_TYPE_CLUSTER_ACCELERATION_STRUCTURE_INPUT_INFO_NV = 1000569005,
        VK_STRUCTURE_TYPE_CLUSTER_ACCELERATION_STRUCTURE_COMMANDS_INFO_NV = 1000569006,
        VK_STRUCTURE_TYPE_RAY_TRACING_PIPELINE_CLUSTER_ACCELERATION_STRUCTURE_CREATE_INFO_NV = 1000569007,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PARTITIONED_ACCELERATION_STRUCTURE_FEATURES_NV = 1000570000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PARTITIONED_ACCELERATION_STRUCTURE_PROPERTIES_NV = 1000570001,
        VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET_PARTITIONED_ACCELERATION_STRUCTURE_NV = 1000570002,
        VK_STRUCTURE_TYPE_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCES_INPUT_NV = 1000570003,
        VK_STRUCTURE_TYPE_BUILD_PARTITIONED_ACCELERATION_STRUCTURE_INFO_NV = 1000570004,
        VK_STRUCTURE_TYPE_PARTITIONED_ACCELERATION_STRUCTURE_FLAGS_NV = 1000570005,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEVICE_GENERATED_COMMANDS_FEATURES_EXT = 1000572000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEVICE_GENERATED_COMMANDS_PROPERTIES_EXT = 1000572001,
        VK_STRUCTURE_TYPE_GENERATED_COMMANDS_MEMORY_REQUIREMENTS_INFO_EXT = 1000572002,
        VK_STRUCTURE_TYPE_INDIRECT_EXECUTION_SET_CREATE_INFO_EXT = 1000572003,
        VK_STRUCTURE_TYPE_GENERATED_COMMANDS_INFO_EXT = 1000572004,
        VK_STRUCTURE_TYPE_INDIRECT_COMMANDS_LAYOUT_CREATE_INFO_EXT = 1000572006,
        VK_STRUCTURE_TYPE_INDIRECT_COMMANDS_LAYOUT_TOKEN_EXT = 1000572007,
        VK_STRUCTURE_TYPE_WRITE_INDIRECT_EXECUTION_SET_PIPELINE_EXT = 1000572008,
        VK_STRUCTURE_TYPE_WRITE_INDIRECT_EXECUTION_SET_SHADER_EXT = 1000572009,
        VK_STRUCTURE_TYPE_INDIRECT_EXECUTION_SET_PIPELINE_INFO_EXT = 1000572010,
        VK_STRUCTURE_TYPE_INDIRECT_EXECUTION_SET_SHADER_INFO_EXT = 1000572011,
        VK_STRUCTURE_TYPE_INDIRECT_EXECUTION_SET_SHADER_LAYOUT_INFO_EXT = 1000572012,
        VK_STRUCTURE_TYPE_GENERATED_COMMANDS_PIPELINE_INFO_EXT = 1000572013,
        VK_STRUCTURE_TYPE_GENERATED_COMMANDS_SHADER_INFO_EXT = 1000572014,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_8_FEATURES_KHR = 1000574000,
        VK_STRUCTURE_TYPE_MEMORY_BARRIER_ACCESS_FLAGS_3_KHR = 1000574002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_ALIGNMENT_CONTROL_FEATURES_MESA = 1000575000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_ALIGNMENT_CONTROL_PROPERTIES_MESA = 1000575001,
        VK_STRUCTURE_TYPE_IMAGE_ALIGNMENT_CONTROL_CREATE_INFO_MESA = 1000575002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEPTH_CLAMP_CONTROL_FEATURES_EXT = 1000582000,
        VK_STRUCTURE_TYPE_PIPELINE_VIEWPORT_DEPTH_CLAMP_CONTROL_CREATE_INFO_EXT = 1000582001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VIDEO_MAINTENANCE_2_FEATURES_KHR = 1000586000,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_H264_INLINE_SESSION_PARAMETERS_INFO_KHR = 1000586001,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_H265_INLINE_SESSION_PARAMETERS_INFO_KHR = 1000586002,
        VK_STRUCTURE_TYPE_VIDEO_DECODE_AV1_INLINE_SESSION_PARAMETERS_INFO_KHR = 1000586003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_HDR_VIVID_FEATURES_HUAWEI = 1000590000,
        VK_STRUCTURE_TYPE_HDR_VIVID_DYNAMIC_METADATA_HUAWEI = 1000590001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COOPERATIVE_MATRIX_2_FEATURES_NV = 1000593000,
        VK_STRUCTURE_TYPE_COOPERATIVE_MATRIX_FLEXIBLE_DIMENSIONS_PROPERTIES_NV = 1000593001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COOPERATIVE_MATRIX_2_PROPERTIES_NV = 1000593002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_OPACITY_MICROMAP_FEATURES_ARM = 1000596000,
        VK_STRUCTURE_TYPE_IMPORT_MEMORY_METAL_HANDLE_INFO_EXT = 1000602000,
        VK_STRUCTURE_TYPE_MEMORY_METAL_HANDLE_PROPERTIES_EXT = 1000602001,
        VK_STRUCTURE_TYPE_MEMORY_GET_METAL_HANDLE_INFO_EXT = 1000602002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEPTH_CLAMP_ZERO_ONE_FEATURES_KHR = 1000421000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_ATTRIBUTE_ROBUSTNESS_FEATURES_EXT = 1000608000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VARIABLE_POINTER_FEATURES = 1000120000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_DRAW_PARAMETER_FEATURES = 1000063000,
        VK_STRUCTURE_TYPE_DEBUG_REPORT_CREATE_INFO_EXT = 1000011000,
        VK_STRUCTURE_TYPE_RENDERING_INFO_KHR = 1000044000,
        VK_STRUCTURE_TYPE_RENDERING_ATTACHMENT_INFO_KHR = 1000044001,
        VK_STRUCTURE_TYPE_PIPELINE_RENDERING_CREATE_INFO_KHR = 1000044002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DYNAMIC_RENDERING_FEATURES_KHR = 1000044003,
        VK_STRUCTURE_TYPE_COMMAND_BUFFER_INHERITANCE_RENDERING_INFO_KHR = 1000044004,
        VK_STRUCTURE_TYPE_RENDER_PASS_MULTIVIEW_CREATE_INFO_KHR = 1000053000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_FEATURES_KHR = 1000053001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MULTIVIEW_PROPERTIES_KHR = 1000053002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FEATURES_2_KHR = 1000059000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PROPERTIES_2_KHR = 1000059001,
        VK_STRUCTURE_TYPE_FORMAT_PROPERTIES_2_KHR = 1000059002,
        VK_STRUCTURE_TYPE_IMAGE_FORMAT_PROPERTIES_2_KHR = 1000059003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_FORMAT_INFO_2_KHR = 1000059004,
        VK_STRUCTURE_TYPE_QUEUE_FAMILY_PROPERTIES_2_KHR = 1000059005,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_PROPERTIES_2_KHR = 1000059006,
        VK_STRUCTURE_TYPE_SPARSE_IMAGE_FORMAT_PROPERTIES_2_KHR = 1000059007,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SPARSE_IMAGE_FORMAT_INFO_2_KHR = 1000059008,
        VK_STRUCTURE_TYPE_MEMORY_ALLOCATE_FLAGS_INFO_KHR = 1000060000,
        VK_STRUCTURE_TYPE_DEVICE_GROUP_RENDER_PASS_BEGIN_INFO_KHR = 1000060003,
        VK_STRUCTURE_TYPE_DEVICE_GROUP_COMMAND_BUFFER_BEGIN_INFO_KHR = 1000060004,
        VK_STRUCTURE_TYPE_DEVICE_GROUP_SUBMIT_INFO_KHR = 1000060005,
        VK_STRUCTURE_TYPE_DEVICE_GROUP_BIND_SPARSE_INFO_KHR = 1000060006,
        VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_DEVICE_GROUP_INFO_KHR = 1000060013,
        VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_DEVICE_GROUP_INFO_KHR = 1000060014,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TEXTURE_COMPRESSION_ASTC_HDR_FEATURES_EXT = 1000066000,
        VK_STRUCTURE_TYPE_PIPELINE_ROBUSTNESS_CREATE_INFO_EXT = 1000068000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_ROBUSTNESS_FEATURES_EXT = 1000068001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_ROBUSTNESS_PROPERTIES_EXT = 1000068002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_GROUP_PROPERTIES_KHR = 1000070000,
        VK_STRUCTURE_TYPE_DEVICE_GROUP_DEVICE_CREATE_INFO_KHR = 1000070001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_IMAGE_FORMAT_INFO_KHR = 1000071000,
        VK_STRUCTURE_TYPE_EXTERNAL_IMAGE_FORMAT_PROPERTIES_KHR = 1000071001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_BUFFER_INFO_KHR = 1000071002,
        VK_STRUCTURE_TYPE_EXTERNAL_BUFFER_PROPERTIES_KHR = 1000071003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ID_PROPERTIES_KHR = 1000071004,
        VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_BUFFER_CREATE_INFO_KHR = 1000072000,
        VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_IMAGE_CREATE_INFO_KHR = 1000072001,
        VK_STRUCTURE_TYPE_EXPORT_MEMORY_ALLOCATE_INFO_KHR = 1000072002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_SEMAPHORE_INFO_KHR = 1000076000,
        VK_STRUCTURE_TYPE_EXTERNAL_SEMAPHORE_PROPERTIES_KHR = 1000076001,
        VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_CREATE_INFO_KHR = 1000077000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PUSH_DESCRIPTOR_PROPERTIES_KHR = 1000080000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_FLOAT16_INT8_FEATURES_KHR = 1000082000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FLOAT16_INT8_FEATURES_KHR = 1000082000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_16BIT_STORAGE_FEATURES_KHR = 1000083000,
        VK_STRUCTURE_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_CREATE_INFO_KHR = 1000085000,
        VK_STRUCTURE_TYPE_SURFACE_CAPABILITIES2_EXT = 1000090000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGELESS_FRAMEBUFFER_FEATURES_KHR = 1000108000,
        VK_STRUCTURE_TYPE_FRAMEBUFFER_ATTACHMENTS_CREATE_INFO_KHR = 1000108001,
        VK_STRUCTURE_TYPE_FRAMEBUFFER_ATTACHMENT_IMAGE_INFO_KHR = 1000108002,
        VK_STRUCTURE_TYPE_RENDER_PASS_ATTACHMENT_BEGIN_INFO_KHR = 1000108003,
        VK_STRUCTURE_TYPE_ATTACHMENT_DESCRIPTION_2_KHR = 1000109000,
        VK_STRUCTURE_TYPE_ATTACHMENT_REFERENCE_2_KHR = 1000109001,
        VK_STRUCTURE_TYPE_SUBPASS_DESCRIPTION_2_KHR = 1000109002,
        VK_STRUCTURE_TYPE_SUBPASS_DEPENDENCY_2_KHR = 1000109003,
        VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO_2_KHR = 1000109004,
        VK_STRUCTURE_TYPE_SUBPASS_BEGIN_INFO_KHR = 1000109005,
        VK_STRUCTURE_TYPE_SUBPASS_END_INFO_KHR = 1000109006,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_EXTERNAL_FENCE_INFO_KHR = 1000112000,
        VK_STRUCTURE_TYPE_EXTERNAL_FENCE_PROPERTIES_KHR = 1000112001,
        VK_STRUCTURE_TYPE_EXPORT_FENCE_CREATE_INFO_KHR = 1000113000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_POINT_CLIPPING_PROPERTIES_KHR = 1000117000,
        VK_STRUCTURE_TYPE_RENDER_PASS_INPUT_ATTACHMENT_ASPECT_CREATE_INFO_KHR = 1000117001,
        VK_STRUCTURE_TYPE_IMAGE_VIEW_USAGE_CREATE_INFO_KHR = 1000117002,
        VK_STRUCTURE_TYPE_PIPELINE_TESSELLATION_DOMAIN_ORIGIN_STATE_CREATE_INFO_KHR = 1000117003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VARIABLE_POINTERS_FEATURES_KHR = 1000120000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VARIABLE_POINTER_FEATURES_KHR = 1000120000,
        VK_STRUCTURE_TYPE_MEMORY_DEDICATED_REQUIREMENTS_KHR = 1000127000,
        VK_STRUCTURE_TYPE_MEMORY_DEDICATED_ALLOCATE_INFO_KHR = 1000127001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLER_FILTER_MINMAX_PROPERTIES_EXT = 1000130000,
        VK_STRUCTURE_TYPE_SAMPLER_REDUCTION_MODE_CREATE_INFO_EXT = 1000130001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_INLINE_UNIFORM_BLOCK_FEATURES_EXT = 1000138000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_INLINE_UNIFORM_BLOCK_PROPERTIES_EXT = 1000138001,
        VK_STRUCTURE_TYPE_WRITE_DESCRIPTOR_SET_INLINE_UNIFORM_BLOCK_EXT = 1000138002,
        VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_INLINE_UNIFORM_BLOCK_CREATE_INFO_EXT = 1000138003,
        VK_STRUCTURE_TYPE_BUFFER_MEMORY_REQUIREMENTS_INFO_2_KHR = 1000146000,
        VK_STRUCTURE_TYPE_IMAGE_MEMORY_REQUIREMENTS_INFO_2_KHR = 1000146001,
        VK_STRUCTURE_TYPE_IMAGE_SPARSE_MEMORY_REQUIREMENTS_INFO_2_KHR = 1000146002,
        VK_STRUCTURE_TYPE_MEMORY_REQUIREMENTS_2_KHR = 1000146003,
        VK_STRUCTURE_TYPE_SPARSE_IMAGE_MEMORY_REQUIREMENTS_2_KHR = 1000146004,
        VK_STRUCTURE_TYPE_IMAGE_FORMAT_LIST_CREATE_INFO_KHR = 1000147000,
        VK_STRUCTURE_TYPE_ATTACHMENT_SAMPLE_COUNT_INFO_NV = 1000044008,
        VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_CREATE_INFO_KHR = 1000156000,
        VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_INFO_KHR = 1000156001,
        VK_STRUCTURE_TYPE_BIND_IMAGE_PLANE_MEMORY_INFO_KHR = 1000156002,
        VK_STRUCTURE_TYPE_IMAGE_PLANE_MEMORY_REQUIREMENTS_INFO_KHR = 1000156003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SAMPLER_YCBCR_CONVERSION_FEATURES_KHR = 1000156004,
        VK_STRUCTURE_TYPE_SAMPLER_YCBCR_CONVERSION_IMAGE_FORMAT_PROPERTIES_KHR = 1000156005,
        VK_STRUCTURE_TYPE_BIND_BUFFER_MEMORY_INFO_KHR = 1000157000,
        VK_STRUCTURE_TYPE_BIND_IMAGE_MEMORY_INFO_KHR = 1000157001,
        VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_BINDING_FLAGS_CREATE_INFO_EXT = 1000161000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_INDEXING_FEATURES_EXT = 1000161001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DESCRIPTOR_INDEXING_PROPERTIES_EXT = 1000161002,
        VK_STRUCTURE_TYPE_DESCRIPTOR_SET_VARIABLE_DESCRIPTOR_COUNT_ALLOCATE_INFO_EXT = 1000161003,
        VK_STRUCTURE_TYPE_DESCRIPTOR_SET_VARIABLE_DESCRIPTOR_COUNT_LAYOUT_SUPPORT_EXT = 1000161004,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_3_PROPERTIES_KHR = 1000168000,
        VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_SUPPORT_KHR = 1000168001,
        VK_STRUCTURE_TYPE_DEVICE_QUEUE_GLOBAL_PRIORITY_CREATE_INFO_EXT = 1000174000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_SUBGROUP_EXTENDED_TYPES_FEATURES_KHR = 1000175000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_8BIT_STORAGE_FEATURES_KHR = 1000177000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_ATOMIC_INT64_FEATURES_KHR = 1000180000,
        VK_STRUCTURE_TYPE_CALIBRATED_TIMESTAMP_INFO_EXT = 1000184000,
        VK_STRUCTURE_TYPE_DEVICE_QUEUE_GLOBAL_PRIORITY_CREATE_INFO_KHR = 1000174000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_GLOBAL_PRIORITY_QUERY_FEATURES_KHR = 1000388000,
        VK_STRUCTURE_TYPE_QUEUE_FAMILY_GLOBAL_PRIORITY_PROPERTIES_KHR = 1000388001,
        VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_DIVISOR_STATE_CREATE_INFO_EXT = 1000190001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_ATTRIBUTE_DIVISOR_FEATURES_EXT = 1000190002,
        VK_STRUCTURE_TYPE_PIPELINE_CREATION_FEEDBACK_CREATE_INFO_EXT = 1000192000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DRIVER_PROPERTIES_KHR = 1000196000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FLOAT_CONTROLS_PROPERTIES_KHR = 1000197000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEPTH_STENCIL_RESOLVE_PROPERTIES_KHR = 1000199000,
        VK_STRUCTURE_TYPE_SUBPASS_DESCRIPTION_DEPTH_STENCIL_RESOLVE_KHR = 1000199001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_COMPUTE_SHADER_DERIVATIVES_FEATURES_NV = 1000201000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_FRAGMENT_SHADER_BARYCENTRIC_FEATURES_NV = 1000203000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TIMELINE_SEMAPHORE_FEATURES_KHR = 1000207000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TIMELINE_SEMAPHORE_PROPERTIES_KHR = 1000207001,
        VK_STRUCTURE_TYPE_SEMAPHORE_TYPE_CREATE_INFO_KHR = 1000207002,
        VK_STRUCTURE_TYPE_TIMELINE_SEMAPHORE_SUBMIT_INFO_KHR = 1000207003,
        VK_STRUCTURE_TYPE_SEMAPHORE_WAIT_INFO_KHR = 1000207004,
        VK_STRUCTURE_TYPE_SEMAPHORE_SIGNAL_INFO_KHR = 1000207005,
        VK_STRUCTURE_TYPE_QUERY_POOL_CREATE_INFO_INTEL = 1000210000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VULKAN_MEMORY_MODEL_FEATURES_KHR = 1000211000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_TERMINATE_INVOCATION_FEATURES_KHR = 1000215000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SCALAR_BLOCK_LAYOUT_FEATURES_EXT = 1000221000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SUBGROUP_SIZE_CONTROL_PROPERTIES_EXT = 1000225000,
        VK_STRUCTURE_TYPE_PIPELINE_SHADER_STAGE_REQUIRED_SUBGROUP_SIZE_CREATE_INFO_EXT = 1000225001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SUBGROUP_SIZE_CONTROL_FEATURES_EXT = 1000225002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DYNAMIC_RENDERING_LOCAL_READ_FEATURES_KHR = 1000232000,
        VK_STRUCTURE_TYPE_RENDERING_ATTACHMENT_LOCATION_INFO_KHR = 1000232001,
        VK_STRUCTURE_TYPE_RENDERING_INPUT_ATTACHMENT_INDEX_INFO_KHR = 1000232002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SEPARATE_DEPTH_STENCIL_LAYOUTS_FEATURES_KHR = 1000241000,
        VK_STRUCTURE_TYPE_ATTACHMENT_REFERENCE_STENCIL_LAYOUT_KHR = 1000241001,
        VK_STRUCTURE_TYPE_ATTACHMENT_DESCRIPTION_STENCIL_LAYOUT_KHR = 1000241002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BUFFER_ADDRESS_FEATURES_EXT = 1000244000,
        VK_STRUCTURE_TYPE_BUFFER_DEVICE_ADDRESS_INFO_EXT = 1000244001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TOOL_PROPERTIES_EXT = 1000245000,
        VK_STRUCTURE_TYPE_IMAGE_STENCIL_USAGE_CREATE_INFO_EXT = 1000246000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_UNIFORM_BUFFER_STANDARD_LAYOUT_FEATURES_KHR = 1000253000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_BUFFER_DEVICE_ADDRESS_FEATURES_KHR = 1000257000,
        VK_STRUCTURE_TYPE_BUFFER_DEVICE_ADDRESS_INFO_KHR = 1000244001,
        VK_STRUCTURE_TYPE_BUFFER_OPAQUE_CAPTURE_ADDRESS_CREATE_INFO_KHR = 1000257002,
        VK_STRUCTURE_TYPE_MEMORY_OPAQUE_CAPTURE_ADDRESS_ALLOCATE_INFO_KHR = 1000257003,
        VK_STRUCTURE_TYPE_DEVICE_MEMORY_OPAQUE_CAPTURE_ADDRESS_INFO_KHR = 1000257004,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LINE_RASTERIZATION_FEATURES_EXT = 1000259000,
        VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_LINE_STATE_CREATE_INFO_EXT = 1000259001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LINE_RASTERIZATION_PROPERTIES_EXT = 1000259002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_HOST_QUERY_RESET_FEATURES_EXT = 1000261000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_INDEX_TYPE_UINT8_FEATURES_EXT = 1000265000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_HOST_IMAGE_COPY_FEATURES_EXT = 1000270000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_HOST_IMAGE_COPY_PROPERTIES_EXT = 1000270001,
        VK_STRUCTURE_TYPE_MEMORY_TO_IMAGE_COPY_EXT = 1000270002,
        VK_STRUCTURE_TYPE_IMAGE_TO_MEMORY_COPY_EXT = 1000270003,
        VK_STRUCTURE_TYPE_COPY_IMAGE_TO_MEMORY_INFO_EXT = 1000270004,
        VK_STRUCTURE_TYPE_COPY_MEMORY_TO_IMAGE_INFO_EXT = 1000270005,
        VK_STRUCTURE_TYPE_HOST_IMAGE_LAYOUT_TRANSITION_INFO_EXT = 1000270006,
        VK_STRUCTURE_TYPE_COPY_IMAGE_TO_IMAGE_INFO_EXT = 1000270007,
        VK_STRUCTURE_TYPE_SUBRESOURCE_HOST_MEMCPY_SIZE_EXT = 1000270008,
        VK_STRUCTURE_TYPE_HOST_IMAGE_COPY_DEVICE_PERFORMANCE_QUERY_EXT = 1000270009,
        VK_STRUCTURE_TYPE_MEMORY_MAP_INFO_KHR = 1000271000,
        VK_STRUCTURE_TYPE_MEMORY_UNMAP_INFO_KHR = 1000271001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_DEMOTE_TO_HELPER_INVOCATION_FEATURES_EXT = 1000276000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_INTEGER_DOT_PRODUCT_FEATURES_KHR = 1000280000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_INTEGER_DOT_PRODUCT_PROPERTIES_KHR = 1000280001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_TEXEL_BUFFER_ALIGNMENT_PROPERTIES_EXT = 1000281001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PRIVATE_DATA_FEATURES_EXT = 1000295000,
        VK_STRUCTURE_TYPE_DEVICE_PRIVATE_DATA_CREATE_INFO_EXT = 1000295001,
        VK_STRUCTURE_TYPE_PRIVATE_DATA_SLOT_CREATE_INFO_EXT = 1000295002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_CREATION_CACHE_CONTROL_FEATURES_EXT = 1000297000,
        VK_STRUCTURE_TYPE_MEMORY_BARRIER_2_KHR = 1000314000,
        VK_STRUCTURE_TYPE_BUFFER_MEMORY_BARRIER_2_KHR = 1000314001,
        VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER_2_KHR = 1000314002,
        VK_STRUCTURE_TYPE_DEPENDENCY_INFO_KHR = 1000314003,
        VK_STRUCTURE_TYPE_SUBMIT_INFO_2_KHR = 1000314004,
        VK_STRUCTURE_TYPE_SEMAPHORE_SUBMIT_INFO_KHR = 1000314005,
        VK_STRUCTURE_TYPE_COMMAND_BUFFER_SUBMIT_INFO_KHR = 1000314006,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SYNCHRONIZATION_2_FEATURES_KHR = 1000314007,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_ZERO_INITIALIZE_WORKGROUP_MEMORY_FEATURES_KHR = 1000325000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_IMAGE_ROBUSTNESS_FEATURES_EXT = 1000335000,
        VK_STRUCTURE_TYPE_COPY_BUFFER_INFO_2_KHR = 1000337000,
        VK_STRUCTURE_TYPE_COPY_IMAGE_INFO_2_KHR = 1000337001,
        VK_STRUCTURE_TYPE_COPY_BUFFER_TO_IMAGE_INFO_2_KHR = 1000337002,
        VK_STRUCTURE_TYPE_COPY_IMAGE_TO_BUFFER_INFO_2_KHR = 1000337003,
        VK_STRUCTURE_TYPE_BLIT_IMAGE_INFO_2_KHR = 1000337004,
        VK_STRUCTURE_TYPE_RESOLVE_IMAGE_INFO_2_KHR = 1000337005,
        VK_STRUCTURE_TYPE_BUFFER_COPY_2_KHR = 1000337006,
        VK_STRUCTURE_TYPE_IMAGE_COPY_2_KHR = 1000337007,
        VK_STRUCTURE_TYPE_IMAGE_BLIT_2_KHR = 1000337008,
        VK_STRUCTURE_TYPE_BUFFER_IMAGE_COPY_2_KHR = 1000337009,
        VK_STRUCTURE_TYPE_IMAGE_RESOLVE_2_KHR = 1000337010,
        VK_STRUCTURE_TYPE_SUBRESOURCE_LAYOUT_2_EXT = 1000338002,
        VK_STRUCTURE_TYPE_IMAGE_SUBRESOURCE_2_EXT = 1000338003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_RASTERIZATION_ORDER_ATTACHMENT_ACCESS_FEATURES_ARM = 1000342000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MUTABLE_DESCRIPTOR_TYPE_FEATURES_VALVE = 1000351000,
        VK_STRUCTURE_TYPE_MUTABLE_DESCRIPTOR_TYPE_CREATE_INFO_VALVE = 1000351002,
        VK_STRUCTURE_TYPE_FORMAT_PROPERTIES_3_KHR = 1000360000,
        VK_STRUCTURE_TYPE_PIPELINE_INFO_EXT = 1000269001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_GLOBAL_PRIORITY_QUERY_FEATURES_EXT = 1000388000,
        VK_STRUCTURE_TYPE_QUEUE_FAMILY_GLOBAL_PRIORITY_PROPERTIES_EXT = 1000388001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_4_FEATURES_KHR = 1000413000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_4_PROPERTIES_KHR = 1000413001,
        VK_STRUCTURE_TYPE_DEVICE_BUFFER_MEMORY_REQUIREMENTS_KHR = 1000413002,
        VK_STRUCTURE_TYPE_DEVICE_IMAGE_MEMORY_REQUIREMENTS_KHR = 1000413003,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_SUBGROUP_ROTATE_FEATURES_KHR = 1000416000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_DEPTH_CLAMP_ZERO_ONE_FEATURES_EXT = 1000421000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_PIPELINE_PROTECTED_ACCESS_FEATURES_EXT = 1000466000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_5_FEATURES_KHR = 1000470000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_5_PROPERTIES_KHR = 1000470001,
        VK_STRUCTURE_TYPE_RENDERING_AREA_INFO_KHR = 1000470003,
        VK_STRUCTURE_TYPE_DEVICE_IMAGE_SUBRESOURCE_INFO_KHR = 1000470004,
        VK_STRUCTURE_TYPE_SUBRESOURCE_LAYOUT_2_KHR = 1000338002,
        VK_STRUCTURE_TYPE_IMAGE_SUBRESOURCE_2_KHR = 1000338003,
        VK_STRUCTURE_TYPE_PIPELINE_CREATE_FLAGS_2_CREATE_INFO_KHR = 1000470005,
        VK_STRUCTURE_TYPE_BUFFER_USAGE_FLAGS_2_CREATE_INFO_KHR = 1000470006,
        VK_STRUCTURE_TYPE_SHADER_REQUIRED_SUBGROUP_SIZE_CREATE_INFO_EXT = 1000225001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_ATTRIBUTE_DIVISOR_PROPERTIES_KHR = 1000525000,
        VK_STRUCTURE_TYPE_PIPELINE_VERTEX_INPUT_DIVISOR_STATE_CREATE_INFO_KHR = 1000190001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_VERTEX_ATTRIBUTE_DIVISOR_FEATURES_KHR = 1000190002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_FLOAT_CONTROLS_2_FEATURES_KHR = 1000528000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_INDEX_TYPE_UINT8_FEATURES_KHR = 1000265000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LINE_RASTERIZATION_FEATURES_KHR = 1000259000,
        VK_STRUCTURE_TYPE_PIPELINE_RASTERIZATION_LINE_STATE_CREATE_INFO_KHR = 1000259001,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_LINE_RASTERIZATION_PROPERTIES_KHR = 1000259002,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_SHADER_EXPECT_ASSUME_FEATURES_KHR = 1000544000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_6_FEATURES_KHR = 1000545000,
        VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MAINTENANCE_6_PROPERTIES_KHR = 1000545001,
        VK_STRUCTURE_TYPE_BIND_MEMORY_STATUS_KHR = 1000545002,
        VK_STRUCTURE_TYPE_BIND_DESCRIPTOR_SETS_INFO_KHR = 1000545003,
        VK_STRUCTURE_TYPE_PUSH_CONSTANTS_INFO_KHR = 1000545004,
        VK_STRUCTURE_TYPE_PUSH_DESCRIPTOR_SET_INFO_KHR = 1000545005,
        VK_STRUCTURE_TYPE_PUSH_DESCRIPTOR_SET_WITH_TEMPLATE_INFO_KHR = 1000545006,
        VK_STRUCTURE_TYPE_MAX_ENUM = 2147483647
}

enum VkPipelineCacheHeaderVersion: uint32
{
        VK_PIPELINE_CACHE_HEADER_VERSION_ONE = 1,
        VK_PIPELINE_CACHE_HEADER_VERSION_MAX_ENUM = 2147483647
}

enum VkImageLayout: uint32
{
        VK_IMAGE_LAYOUT_UNDEFINED = 0,
        VK_IMAGE_LAYOUT_GENERAL = 1,
        VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL = 2,
        VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL = 3,
        VK_IMAGE_LAYOUT_DEPTH_STENCIL_READ_ONLY_OPTIMAL = 4,
        VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL = 5,
        VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL = 6,
        VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL = 7,
        VK_IMAGE_LAYOUT_PREINITIALIZED = 8,
        VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_STENCIL_ATTACHMENT_OPTIMAL = 1000117000,
        VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_STENCIL_READ_ONLY_OPTIMAL = 1000117001,
        VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_OPTIMAL = 1000241000,
        VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_OPTIMAL = 1000241001,
        VK_IMAGE_LAYOUT_STENCIL_ATTACHMENT_OPTIMAL = 1000241002,
        VK_IMAGE_LAYOUT_STENCIL_READ_ONLY_OPTIMAL = 1000241003,
        VK_IMAGE_LAYOUT_READ_ONLY_OPTIMAL = 1000314000,
        VK_IMAGE_LAYOUT_ATTACHMENT_OPTIMAL = 1000314001,
        VK_IMAGE_LAYOUT_RENDERING_LOCAL_READ = 1000232000,
        VK_IMAGE_LAYOUT_PRESENT_SRC_KHR = 1000001002,
        VK_IMAGE_LAYOUT_VIDEO_DECODE_DST_KHR = 1000024000,
        VK_IMAGE_LAYOUT_VIDEO_DECODE_SRC_KHR = 1000024001,
        VK_IMAGE_LAYOUT_VIDEO_DECODE_DPB_KHR = 1000024002,
        VK_IMAGE_LAYOUT_SHARED_PRESENT_KHR = 1000111000,
        VK_IMAGE_LAYOUT_FRAGMENT_DENSITY_MAP_OPTIMAL_EXT = 1000218000,
        VK_IMAGE_LAYOUT_FRAGMENT_SHADING_RATE_ATTACHMENT_OPTIMAL_KHR = 1000164003,
        VK_IMAGE_LAYOUT_VIDEO_ENCODE_DST_KHR = 1000299000,
        VK_IMAGE_LAYOUT_VIDEO_ENCODE_SRC_KHR = 1000299001,
        VK_IMAGE_LAYOUT_VIDEO_ENCODE_DPB_KHR = 1000299002,
        VK_IMAGE_LAYOUT_ATTACHMENT_FEEDBACK_LOOP_OPTIMAL_EXT = 1000339000,
        VK_IMAGE_LAYOUT_VIDEO_ENCODE_QUANTIZATION_MAP_KHR = 1000553000,
        VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_STENCIL_ATTACHMENT_OPTIMAL_KHR = 1000117000,
        VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_STENCIL_READ_ONLY_OPTIMAL_KHR = 1000117001,
        VK_IMAGE_LAYOUT_SHADING_RATE_OPTIMAL_NV = 1000164003,
        VK_IMAGE_LAYOUT_RENDERING_LOCAL_READ_KHR = 1000232000,
        VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_OPTIMAL_KHR = 1000241000,
        VK_IMAGE_LAYOUT_DEPTH_READ_ONLY_OPTIMAL_KHR = 1000241001,
        VK_IMAGE_LAYOUT_STENCIL_ATTACHMENT_OPTIMAL_KHR = 1000241002,
        VK_IMAGE_LAYOUT_STENCIL_READ_ONLY_OPTIMAL_KHR = 1000241003,
        VK_IMAGE_LAYOUT_READ_ONLY_OPTIMAL_KHR = 1000314000,
        VK_IMAGE_LAYOUT_ATTACHMENT_OPTIMAL_KHR = 1000314001,
        VK_IMAGE_LAYOUT_MAX_ENUM = 2147483647
}

enum VkObjectType: uint32
{
        VK_OBJECT_TYPE_UNKNOWN = 0,
        VK_OBJECT_TYPE_INSTANCE = 1,
        VK_OBJECT_TYPE_PHYSICAL_DEVICE = 2,
        VK_OBJECT_TYPE_DEVICE = 3,
        VK_OBJECT_TYPE_QUEUE = 4,
        VK_OBJECT_TYPE_SEMAPHORE = 5,
        VK_OBJECT_TYPE_COMMAND_BUFFER = 6,
        VK_OBJECT_TYPE_FENCE = 7,
        VK_OBJECT_TYPE_DEVICE_MEMORY = 8,
        VK_OBJECT_TYPE_BUFFER = 9,
        VK_OBJECT_TYPE_IMAGE = 10,
        VK_OBJECT_TYPE_EVENT = 11,
        VK_OBJECT_TYPE_QUERY_POOL = 12,
        VK_OBJECT_TYPE_BUFFER_VIEW = 13,
        VK_OBJECT_TYPE_IMAGE_VIEW = 14,
        VK_OBJECT_TYPE_SHADER_MODULE = 15,
        VK_OBJECT_TYPE_PIPELINE_CACHE = 16,
        VK_OBJECT_TYPE_PIPELINE_LAYOUT = 17,
        VK_OBJECT_TYPE_RENDER_PASS = 18,
        VK_OBJECT_TYPE_PIPELINE = 19,
        VK_OBJECT_TYPE_DESCRIPTOR_SET_LAYOUT = 20,
        VK_OBJECT_TYPE_SAMPLER = 21,
        VK_OBJECT_TYPE_DESCRIPTOR_POOL = 22,
        VK_OBJECT_TYPE_DESCRIPTOR_SET = 23,
        VK_OBJECT_TYPE_FRAMEBUFFER = 24,
        VK_OBJECT_TYPE_COMMAND_POOL = 25,
        VK_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION = 1000156000,
        VK_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE = 1000085000,
        VK_OBJECT_TYPE_PRIVATE_DATA_SLOT = 1000295000,
        VK_OBJECT_TYPE_SURFACE_KHR = 1000000000,
        VK_OBJECT_TYPE_SWAPCHAIN_KHR = 1000001000,
        VK_OBJECT_TYPE_DISPLAY_KHR = 1000002000,
        VK_OBJECT_TYPE_DISPLAY_MODE_KHR = 1000002001,
        VK_OBJECT_TYPE_DEBUG_REPORT_CALLBACK_EXT = 1000011000,
        VK_OBJECT_TYPE_VIDEO_SESSION_KHR = 1000023000,
        VK_OBJECT_TYPE_VIDEO_SESSION_PARAMETERS_KHR = 1000023001,
        VK_OBJECT_TYPE_CU_MODULE_NVX = 1000029000,
        VK_OBJECT_TYPE_CU_FUNCTION_NVX = 1000029001,
        VK_OBJECT_TYPE_DEBUG_UTILS_MESSENGER_EXT = 1000128000,
        VK_OBJECT_TYPE_ACCELERATION_STRUCTURE_KHR = 1000150000,
        VK_OBJECT_TYPE_VALIDATION_CACHE_EXT = 1000160000,
        VK_OBJECT_TYPE_ACCELERATION_STRUCTURE_NV = 1000165000,
        VK_OBJECT_TYPE_PERFORMANCE_CONFIGURATION_INTEL = 1000210000,
        VK_OBJECT_TYPE_DEFERRED_OPERATION_KHR = 1000268000,
        VK_OBJECT_TYPE_INDIRECT_COMMANDS_LAYOUT_NV = 1000277000,
        VK_OBJECT_TYPE_CUDA_MODULE_NV = 1000307000,
        VK_OBJECT_TYPE_CUDA_FUNCTION_NV = 1000307001,
        VK_OBJECT_TYPE_BUFFER_COLLECTION_FUCHSIA = 1000366000,
        VK_OBJECT_TYPE_MICROMAP_EXT = 1000396000,
        VK_OBJECT_TYPE_OPTICAL_FLOW_SESSION_NV = 1000464000,
        VK_OBJECT_TYPE_SHADER_EXT = 1000482000,
        VK_OBJECT_TYPE_PIPELINE_BINARY_KHR = 1000483000,
        VK_OBJECT_TYPE_INDIRECT_COMMANDS_LAYOUT_EXT = 1000572000,
        VK_OBJECT_TYPE_INDIRECT_EXECUTION_SET_EXT = 1000572001,
        VK_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_KHR = 1000085000,
        VK_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION_KHR = 1000156000,
        VK_OBJECT_TYPE_PRIVATE_DATA_SLOT_EXT = 1000295000,
        VK_OBJECT_TYPE_MAX_ENUM = 2147483647
}

enum VkVendorId: uint32
{
        VK_VENDOR_ID_KHRONOS = 65536,
        VK_VENDOR_ID_VIV = 65537,
        VK_VENDOR_ID_VSI = 65538,
        VK_VENDOR_ID_KAZAN = 65539,
        VK_VENDOR_ID_CODEPLAY = 65540,
        VK_VENDOR_ID_MESA = 65541,
        VK_VENDOR_ID_POCL = 65542,
        VK_VENDOR_ID_MOBILEYE = 65543,
        VK_VENDOR_ID_MAX_ENUM = 2147483647
}

enum VkSystemAllocationScope: uint32
{
        VK_SYSTEM_ALLOCATION_SCOPE_COMMAND = 0,
        VK_SYSTEM_ALLOCATION_SCOPE_OBJECT = 1,
        VK_SYSTEM_ALLOCATION_SCOPE_CACHE = 2,
        VK_SYSTEM_ALLOCATION_SCOPE_DEVICE = 3,
        VK_SYSTEM_ALLOCATION_SCOPE_INSTANCE = 4,
        VK_SYSTEM_ALLOCATION_SCOPE_MAX_ENUM = 2147483647
}

enum VkInternalAllocationType: uint32
{
        VK_INTERNAL_ALLOCATION_TYPE_EXECUTABLE = 0,
        VK_INTERNAL_ALLOCATION_TYPE_MAX_ENUM = 2147483647
}

enum VkFormat: uint32
{
        VK_FORMAT_UNDEFINED = 0,
        VK_FORMAT_R4G4_UNORM_PACK8 = 1,
        VK_FORMAT_R4G4B4A4_UNORM_PACK16 = 2,
        VK_FORMAT_B4G4R4A4_UNORM_PACK16 = 3,
        VK_FORMAT_R5G6B5_UNORM_PACK16 = 4,
        VK_FORMAT_B5G6R5_UNORM_PACK16 = 5,
        VK_FORMAT_R5G5B5A1_UNORM_PACK16 = 6,
        VK_FORMAT_B5G5R5A1_UNORM_PACK16 = 7,
        VK_FORMAT_A1R5G5B5_UNORM_PACK16 = 8,
        VK_FORMAT_R8_UNORM = 9,
        VK_FORMAT_R8_SNORM = 10,
        VK_FORMAT_R8_USCALED = 11,
        VK_FORMAT_R8_SSCALED = 12,
        VK_FORMAT_R8_UINT = 13,
        VK_FORMAT_R8_SINT = 14,
        VK_FORMAT_R8_SRGB = 15,
        VK_FORMAT_R8G8_UNORM = 16,
        VK_FORMAT_R8G8_SNORM = 17,
        VK_FORMAT_R8G8_USCALED = 18,
        VK_FORMAT_R8G8_SSCALED = 19,
        VK_FORMAT_R8G8_UINT = 20,
        VK_FORMAT_R8G8_SINT = 21,
        VK_FORMAT_R8G8_SRGB = 22,
        VK_FORMAT_R8G8B8_UNORM = 23,
        VK_FORMAT_R8G8B8_SNORM = 24,
        VK_FORMAT_R8G8B8_USCALED = 25,
        VK_FORMAT_R8G8B8_SSCALED = 26,
        VK_FORMAT_R8G8B8_UINT = 27,
        VK_FORMAT_R8G8B8_SINT = 28,
        VK_FORMAT_R8G8B8_SRGB = 29,
        VK_FORMAT_B8G8R8_UNORM = 30,
        VK_FORMAT_B8G8R8_SNORM = 31,
        VK_FORMAT_B8G8R8_USCALED = 32,
        VK_FORMAT_B8G8R8_SSCALED = 33,
        VK_FORMAT_B8G8R8_UINT = 34,
        VK_FORMAT_B8G8R8_SINT = 35,
        VK_FORMAT_B8G8R8_SRGB = 36,
        VK_FORMAT_R8G8B8A8_UNORM = 37,
        VK_FORMAT_R8G8B8A8_SNORM = 38,
        VK_FORMAT_R8G8B8A8_USCALED = 39,
        VK_FORMAT_R8G8B8A8_SSCALED = 40,
        VK_FORMAT_R8G8B8A8_UINT = 41,
        VK_FORMAT_R8G8B8A8_SINT = 42,
        VK_FORMAT_R8G8B8A8_SRGB = 43,
        VK_FORMAT_B8G8R8A8_UNORM = 44,
        VK_FORMAT_B8G8R8A8_SNORM = 45,
        VK_FORMAT_B8G8R8A8_USCALED = 46,
        VK_FORMAT_B8G8R8A8_SSCALED = 47,
        VK_FORMAT_B8G8R8A8_UINT = 48,
        VK_FORMAT_B8G8R8A8_SINT = 49,
        VK_FORMAT_B8G8R8A8_SRGB = 50,
        VK_FORMAT_A8B8G8R8_UNORM_PACK32 = 51,
        VK_FORMAT_A8B8G8R8_SNORM_PACK32 = 52,
        VK_FORMAT_A8B8G8R8_USCALED_PACK32 = 53,
        VK_FORMAT_A8B8G8R8_SSCALED_PACK32 = 54,
        VK_FORMAT_A8B8G8R8_UINT_PACK32 = 55,
        VK_FORMAT_A8B8G8R8_SINT_PACK32 = 56,
        VK_FORMAT_A8B8G8R8_SRGB_PACK32 = 57,
        VK_FORMAT_A2R10G10B10_UNORM_PACK32 = 58,
        VK_FORMAT_A2R10G10B10_SNORM_PACK32 = 59,
        VK_FORMAT_A2R10G10B10_USCALED_PACK32 = 60,
        VK_FORMAT_A2R10G10B10_SSCALED_PACK32 = 61,
        VK_FORMAT_A2R10G10B10_UINT_PACK32 = 62,
        VK_FORMAT_A2R10G10B10_SINT_PACK32 = 63,
        VK_FORMAT_A2B10G10R10_UNORM_PACK32 = 64,
        VK_FORMAT_A2B10G10R10_SNORM_PACK32 = 65,
        VK_FORMAT_A2B10G10R10_USCALED_PACK32 = 66,
        VK_FORMAT_A2B10G10R10_SSCALED_PACK32 = 67,
        VK_FORMAT_A2B10G10R10_UINT_PACK32 = 68,
        VK_FORMAT_A2B10G10R10_SINT_PACK32 = 69,
        VK_FORMAT_R16_UNORM = 70,
        VK_FORMAT_R16_SNORM = 71,
        VK_FORMAT_R16_USCALED = 72,
        VK_FORMAT_R16_SSCALED = 73,
        VK_FORMAT_R16_UINT = 74,
        VK_FORMAT_R16_SINT = 75,
        VK_FORMAT_R16_SFLOAT = 76,
        VK_FORMAT_R16G16_UNORM = 77,
        VK_FORMAT_R16G16_SNORM = 78,
        VK_FORMAT_R16G16_USCALED = 79,
        VK_FORMAT_R16G16_SSCALED = 80,
        VK_FORMAT_R16G16_UINT = 81,
        VK_FORMAT_R16G16_SINT = 82,
        VK_FORMAT_R16G16_SFLOAT = 83,
        VK_FORMAT_R16G16B16_UNORM = 84,
        VK_FORMAT_R16G16B16_SNORM = 85,
        VK_FORMAT_R16G16B16_USCALED = 86,
        VK_FORMAT_R16G16B16_SSCALED = 87,
        VK_FORMAT_R16G16B16_UINT = 88,
        VK_FORMAT_R16G16B16_SINT = 89,
        VK_FORMAT_R16G16B16_SFLOAT = 90,
        VK_FORMAT_R16G16B16A16_UNORM = 91,
        VK_FORMAT_R16G16B16A16_SNORM = 92,
        VK_FORMAT_R16G16B16A16_USCALED = 93,
        VK_FORMAT_R16G16B16A16_SSCALED = 94,
        VK_FORMAT_R16G16B16A16_UINT = 95,
        VK_FORMAT_R16G16B16A16_SINT = 96,
        VK_FORMAT_R16G16B16A16_SFLOAT = 97,
        VK_FORMAT_R32_UINT = 98,
        VK_FORMAT_R32_SINT = 99,
        VK_FORMAT_R32_SFLOAT = 100,
        VK_FORMAT_R32G32_UINT = 101,
        VK_FORMAT_R32G32_SINT = 102,
        VK_FORMAT_R32G32_SFLOAT = 103,
        VK_FORMAT_R32G32B32_UINT = 104,
        VK_FORMAT_R32G32B32_SINT = 105,
        VK_FORMAT_R32G32B32_SFLOAT = 106,
        VK_FORMAT_R32G32B32A32_UINT = 107,
        VK_FORMAT_R32G32B32A32_SINT = 108,
        VK_FORMAT_R32G32B32A32_SFLOAT = 109,
        VK_FORMAT_R64_UINT = 110,
        VK_FORMAT_R64_SINT = 111,
        VK_FORMAT_R64_SFLOAT = 112,
        VK_FORMAT_R64G64_UINT = 113,
        VK_FORMAT_R64G64_SINT = 114,
        VK_FORMAT_R64G64_SFLOAT = 115,
        VK_FORMAT_R64G64B64_UINT = 116,
        VK_FORMAT_R64G64B64_SINT = 117,
        VK_FORMAT_R64G64B64_SFLOAT = 118,
        VK_FORMAT_R64G64B64A64_UINT = 119,
        VK_FORMAT_R64G64B64A64_SINT = 120,
        VK_FORMAT_R64G64B64A64_SFLOAT = 121,
        VK_FORMAT_B10G11R11_UFLOAT_PACK32 = 122,
        VK_FORMAT_E5B9G9R9_UFLOAT_PACK32 = 123,
        VK_FORMAT_D16_UNORM = 124,
        VK_FORMAT_X8_D24_UNORM_PACK32 = 125,
        VK_FORMAT_D32_SFLOAT = 126,
        VK_FORMAT_S8_UINT = 127,
        VK_FORMAT_D16_UNORM_S8_UINT = 128,
        VK_FORMAT_D24_UNORM_S8_UINT = 129,
        VK_FORMAT_D32_SFLOAT_S8_UINT = 130,
        VK_FORMAT_BC1_RGB_UNORM_BLOCK = 131,
        VK_FORMAT_BC1_RGB_SRGB_BLOCK = 132,
        VK_FORMAT_BC1_RGBA_UNORM_BLOCK = 133,
        VK_FORMAT_BC1_RGBA_SRGB_BLOCK = 134,
        VK_FORMAT_BC2_UNORM_BLOCK = 135,
        VK_FORMAT_BC2_SRGB_BLOCK = 136,
        VK_FORMAT_BC3_UNORM_BLOCK = 137,
        VK_FORMAT_BC3_SRGB_BLOCK = 138,
        VK_FORMAT_BC4_UNORM_BLOCK = 139,
        VK_FORMAT_BC4_SNORM_BLOCK = 140,
        VK_FORMAT_BC5_UNORM_BLOCK = 141,
        VK_FORMAT_BC5_SNORM_BLOCK = 142,
        VK_FORMAT_BC6H_UFLOAT_BLOCK = 143,
        VK_FORMAT_BC6H_SFLOAT_BLOCK = 144,
        VK_FORMAT_BC7_UNORM_BLOCK = 145,
        VK_FORMAT_BC7_SRGB_BLOCK = 146,
        VK_FORMAT_ETC2_R8G8B8_UNORM_BLOCK = 147,
        VK_FORMAT_ETC2_R8G8B8_SRGB_BLOCK = 148,
        VK_FORMAT_ETC2_R8G8B8A1_UNORM_BLOCK = 149,
        VK_FORMAT_ETC2_R8G8B8A1_SRGB_BLOCK = 150,
        VK_FORMAT_ETC2_R8G8B8A8_UNORM_BLOCK = 151,
        VK_FORMAT_ETC2_R8G8B8A8_SRGB_BLOCK = 152,
        VK_FORMAT_EAC_R11_UNORM_BLOCK = 153,
        VK_FORMAT_EAC_R11_SNORM_BLOCK = 154,
        VK_FORMAT_EAC_R11G11_UNORM_BLOCK = 155,
        VK_FORMAT_EAC_R11G11_SNORM_BLOCK = 156,
        VK_FORMAT_ASTC_4x4_UNORM_BLOCK = 157,
        VK_FORMAT_ASTC_4x4_SRGB_BLOCK = 158,
        VK_FORMAT_ASTC_5x4_UNORM_BLOCK = 159,
        VK_FORMAT_ASTC_5x4_SRGB_BLOCK = 160,
        VK_FORMAT_ASTC_5x5_UNORM_BLOCK = 161,
        VK_FORMAT_ASTC_5x5_SRGB_BLOCK = 162,
        VK_FORMAT_ASTC_6x5_UNORM_BLOCK = 163,
        VK_FORMAT_ASTC_6x5_SRGB_BLOCK = 164,
        VK_FORMAT_ASTC_6x6_UNORM_BLOCK = 165,
        VK_FORMAT_ASTC_6x6_SRGB_BLOCK = 166,
        VK_FORMAT_ASTC_8x5_UNORM_BLOCK = 167,
        VK_FORMAT_ASTC_8x5_SRGB_BLOCK = 168,
        VK_FORMAT_ASTC_8x6_UNORM_BLOCK = 169,
        VK_FORMAT_ASTC_8x6_SRGB_BLOCK = 170,
        VK_FORMAT_ASTC_8x8_UNORM_BLOCK = 171,
        VK_FORMAT_ASTC_8x8_SRGB_BLOCK = 172,
        VK_FORMAT_ASTC_10x5_UNORM_BLOCK = 173,
        VK_FORMAT_ASTC_10x5_SRGB_BLOCK = 174,
        VK_FORMAT_ASTC_10x6_UNORM_BLOCK = 175,
        VK_FORMAT_ASTC_10x6_SRGB_BLOCK = 176,
        VK_FORMAT_ASTC_10x8_UNORM_BLOCK = 177,
        VK_FORMAT_ASTC_10x8_SRGB_BLOCK = 178,
        VK_FORMAT_ASTC_10x10_UNORM_BLOCK = 179,
        VK_FORMAT_ASTC_10x10_SRGB_BLOCK = 180,
        VK_FORMAT_ASTC_12x10_UNORM_BLOCK = 181,
        VK_FORMAT_ASTC_12x10_SRGB_BLOCK = 182,
        VK_FORMAT_ASTC_12x12_UNORM_BLOCK = 183,
        VK_FORMAT_ASTC_12x12_SRGB_BLOCK = 184,
        VK_FORMAT_G8B8G8R8_422_UNORM = 1000156000,
        VK_FORMAT_B8G8R8G8_422_UNORM = 1000156001,
        VK_FORMAT_G8_B8_R8_3PLANE_420_UNORM = 1000156002,
        VK_FORMAT_G8_B8R8_2PLANE_420_UNORM = 1000156003,
        VK_FORMAT_G8_B8_R8_3PLANE_422_UNORM = 1000156004,
        VK_FORMAT_G8_B8R8_2PLANE_422_UNORM = 1000156005,
        VK_FORMAT_G8_B8_R8_3PLANE_444_UNORM = 1000156006,
        VK_FORMAT_R10X6_UNORM_PACK16 = 1000156007,
        VK_FORMAT_R10X6G10X6_UNORM_2PACK16 = 1000156008,
        VK_FORMAT_R10X6G10X6B10X6A10X6_UNORM_4PACK16 = 1000156009,
        VK_FORMAT_G10X6B10X6G10X6R10X6_422_UNORM_4PACK16 = 1000156010,
        VK_FORMAT_B10X6G10X6R10X6G10X6_422_UNORM_4PACK16 = 1000156011,
        VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_420_UNORM_3PACK16 = 1000156012,
        VK_FORMAT_G10X6_B10X6R10X6_2PLANE_420_UNORM_3PACK16 = 1000156013,
        VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_422_UNORM_3PACK16 = 1000156014,
        VK_FORMAT_G10X6_B10X6R10X6_2PLANE_422_UNORM_3PACK16 = 1000156015,
        VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_444_UNORM_3PACK16 = 1000156016,
        VK_FORMAT_R12X4_UNORM_PACK16 = 1000156017,
        VK_FORMAT_R12X4G12X4_UNORM_2PACK16 = 1000156018,
        VK_FORMAT_R12X4G12X4B12X4A12X4_UNORM_4PACK16 = 1000156019,
        VK_FORMAT_G12X4B12X4G12X4R12X4_422_UNORM_4PACK16 = 1000156020,
        VK_FORMAT_B12X4G12X4R12X4G12X4_422_UNORM_4PACK16 = 1000156021,
        VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_420_UNORM_3PACK16 = 1000156022,
        VK_FORMAT_G12X4_B12X4R12X4_2PLANE_420_UNORM_3PACK16 = 1000156023,
        VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_422_UNORM_3PACK16 = 1000156024,
        VK_FORMAT_G12X4_B12X4R12X4_2PLANE_422_UNORM_3PACK16 = 1000156025,
        VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_444_UNORM_3PACK16 = 1000156026,
        VK_FORMAT_G16B16G16R16_422_UNORM = 1000156027,
        VK_FORMAT_B16G16R16G16_422_UNORM = 1000156028,
        VK_FORMAT_G16_B16_R16_3PLANE_420_UNORM = 1000156029,
        VK_FORMAT_G16_B16R16_2PLANE_420_UNORM = 1000156030,
        VK_FORMAT_G16_B16_R16_3PLANE_422_UNORM = 1000156031,
        VK_FORMAT_G16_B16R16_2PLANE_422_UNORM = 1000156032,
        VK_FORMAT_G16_B16_R16_3PLANE_444_UNORM = 1000156033,
        VK_FORMAT_G8_B8R8_2PLANE_444_UNORM = 1000330000,
        VK_FORMAT_G10X6_B10X6R10X6_2PLANE_444_UNORM_3PACK16 = 1000330001,
        VK_FORMAT_G12X4_B12X4R12X4_2PLANE_444_UNORM_3PACK16 = 1000330002,
        VK_FORMAT_G16_B16R16_2PLANE_444_UNORM = 1000330003,
        VK_FORMAT_A4R4G4B4_UNORM_PACK16 = 1000340000,
        VK_FORMAT_A4B4G4R4_UNORM_PACK16 = 1000340001,
        VK_FORMAT_ASTC_4x4_SFLOAT_BLOCK = 1000066000,
        VK_FORMAT_ASTC_5x4_SFLOAT_BLOCK = 1000066001,
        VK_FORMAT_ASTC_5x5_SFLOAT_BLOCK = 1000066002,
        VK_FORMAT_ASTC_6x5_SFLOAT_BLOCK = 1000066003,
        VK_FORMAT_ASTC_6x6_SFLOAT_BLOCK = 1000066004,
        VK_FORMAT_ASTC_8x5_SFLOAT_BLOCK = 1000066005,
        VK_FORMAT_ASTC_8x6_SFLOAT_BLOCK = 1000066006,
        VK_FORMAT_ASTC_8x8_SFLOAT_BLOCK = 1000066007,
        VK_FORMAT_ASTC_10x5_SFLOAT_BLOCK = 1000066008,
        VK_FORMAT_ASTC_10x6_SFLOAT_BLOCK = 1000066009,
        VK_FORMAT_ASTC_10x8_SFLOAT_BLOCK = 1000066010,
        VK_FORMAT_ASTC_10x10_SFLOAT_BLOCK = 1000066011,
        VK_FORMAT_ASTC_12x10_SFLOAT_BLOCK = 1000066012,
        VK_FORMAT_ASTC_12x12_SFLOAT_BLOCK = 1000066013,
        VK_FORMAT_A1B5G5R5_UNORM_PACK16 = 1000470000,
        VK_FORMAT_A8_UNORM = 1000470001,
        VK_FORMAT_PVRTC1_2BPP_UNORM_BLOCK_IMG = 1000054000,
        VK_FORMAT_PVRTC1_4BPP_UNORM_BLOCK_IMG = 1000054001,
        VK_FORMAT_PVRTC2_2BPP_UNORM_BLOCK_IMG = 1000054002,
        VK_FORMAT_PVRTC2_4BPP_UNORM_BLOCK_IMG = 1000054003,
        VK_FORMAT_PVRTC1_2BPP_SRGB_BLOCK_IMG = 1000054004,
        VK_FORMAT_PVRTC1_4BPP_SRGB_BLOCK_IMG = 1000054005,
        VK_FORMAT_PVRTC2_2BPP_SRGB_BLOCK_IMG = 1000054006,
        VK_FORMAT_PVRTC2_4BPP_SRGB_BLOCK_IMG = 1000054007,
        VK_FORMAT_R16G16_SFIXED5_NV = 1000464000,
        VK_FORMAT_ASTC_4x4_SFLOAT_BLOCK_EXT = 1000066000,
        VK_FORMAT_ASTC_5x4_SFLOAT_BLOCK_EXT = 1000066001,
        VK_FORMAT_ASTC_5x5_SFLOAT_BLOCK_EXT = 1000066002,
        VK_FORMAT_ASTC_6x5_SFLOAT_BLOCK_EXT = 1000066003,
        VK_FORMAT_ASTC_6x6_SFLOAT_BLOCK_EXT = 1000066004,
        VK_FORMAT_ASTC_8x5_SFLOAT_BLOCK_EXT = 1000066005,
        VK_FORMAT_ASTC_8x6_SFLOAT_BLOCK_EXT = 1000066006,
        VK_FORMAT_ASTC_8x8_SFLOAT_BLOCK_EXT = 1000066007,
        VK_FORMAT_ASTC_10x5_SFLOAT_BLOCK_EXT = 1000066008,
        VK_FORMAT_ASTC_10x6_SFLOAT_BLOCK_EXT = 1000066009,
        VK_FORMAT_ASTC_10x8_SFLOAT_BLOCK_EXT = 1000066010,
        VK_FORMAT_ASTC_10x10_SFLOAT_BLOCK_EXT = 1000066011,
        VK_FORMAT_ASTC_12x10_SFLOAT_BLOCK_EXT = 1000066012,
        VK_FORMAT_ASTC_12x12_SFLOAT_BLOCK_EXT = 1000066013,
        VK_FORMAT_G8B8G8R8_422_UNORM_KHR = 1000156000,
        VK_FORMAT_B8G8R8G8_422_UNORM_KHR = 1000156001,
        VK_FORMAT_G8_B8_R8_3PLANE_420_UNORM_KHR = 1000156002,
        VK_FORMAT_G8_B8R8_2PLANE_420_UNORM_KHR = 1000156003,
        VK_FORMAT_G8_B8_R8_3PLANE_422_UNORM_KHR = 1000156004,
        VK_FORMAT_G8_B8R8_2PLANE_422_UNORM_KHR = 1000156005,
        VK_FORMAT_G8_B8_R8_3PLANE_444_UNORM_KHR = 1000156006,
        VK_FORMAT_R10X6_UNORM_PACK16_KHR = 1000156007,
        VK_FORMAT_R10X6G10X6_UNORM_2PACK16_KHR = 1000156008,
        VK_FORMAT_R10X6G10X6B10X6A10X6_UNORM_4PACK16_KHR = 1000156009,
        VK_FORMAT_G10X6B10X6G10X6R10X6_422_UNORM_4PACK16_KHR = 1000156010,
        VK_FORMAT_B10X6G10X6R10X6G10X6_422_UNORM_4PACK16_KHR = 1000156011,
        VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_420_UNORM_3PACK16_KHR = 1000156012,
        VK_FORMAT_G10X6_B10X6R10X6_2PLANE_420_UNORM_3PACK16_KHR = 1000156013,
        VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_422_UNORM_3PACK16_KHR = 1000156014,
        VK_FORMAT_G10X6_B10X6R10X6_2PLANE_422_UNORM_3PACK16_KHR = 1000156015,
        VK_FORMAT_G10X6_B10X6_R10X6_3PLANE_444_UNORM_3PACK16_KHR = 1000156016,
        VK_FORMAT_R12X4_UNORM_PACK16_KHR = 1000156017,
        VK_FORMAT_R12X4G12X4_UNORM_2PACK16_KHR = 1000156018,
        VK_FORMAT_R12X4G12X4B12X4A12X4_UNORM_4PACK16_KHR = 1000156019,
        VK_FORMAT_G12X4B12X4G12X4R12X4_422_UNORM_4PACK16_KHR = 1000156020,
        VK_FORMAT_B12X4G12X4R12X4G12X4_422_UNORM_4PACK16_KHR = 1000156021,
        VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_420_UNORM_3PACK16_KHR = 1000156022,
        VK_FORMAT_G12X4_B12X4R12X4_2PLANE_420_UNORM_3PACK16_KHR = 1000156023,
        VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_422_UNORM_3PACK16_KHR = 1000156024,
        VK_FORMAT_G12X4_B12X4R12X4_2PLANE_422_UNORM_3PACK16_KHR = 1000156025,
        VK_FORMAT_G12X4_B12X4_R12X4_3PLANE_444_UNORM_3PACK16_KHR = 1000156026,
        VK_FORMAT_G16B16G16R16_422_UNORM_KHR = 1000156027,
        VK_FORMAT_B16G16R16G16_422_UNORM_KHR = 1000156028,
        VK_FORMAT_G16_B16_R16_3PLANE_420_UNORM_KHR = 1000156029,
        VK_FORMAT_G16_B16R16_2PLANE_420_UNORM_KHR = 1000156030,
        VK_FORMAT_G16_B16_R16_3PLANE_422_UNORM_KHR = 1000156031,
        VK_FORMAT_G16_B16R16_2PLANE_422_UNORM_KHR = 1000156032,
        VK_FORMAT_G16_B16_R16_3PLANE_444_UNORM_KHR = 1000156033,
        VK_FORMAT_G8_B8R8_2PLANE_444_UNORM_EXT = 1000330000,
        VK_FORMAT_G10X6_B10X6R10X6_2PLANE_444_UNORM_3PACK16_EXT = 1000330001,
        VK_FORMAT_G12X4_B12X4R12X4_2PLANE_444_UNORM_3PACK16_EXT = 1000330002,
        VK_FORMAT_G16_B16R16_2PLANE_444_UNORM_EXT = 1000330003,
        VK_FORMAT_A4R4G4B4_UNORM_PACK16_EXT = 1000340000,
        VK_FORMAT_A4B4G4R4_UNORM_PACK16_EXT = 1000340001,
        VK_FORMAT_R16G16_S10_5_NV = 1000464000,
        VK_FORMAT_A1B5G5R5_UNORM_PACK16_KHR = 1000470000,
        VK_FORMAT_A8_UNORM_KHR = 1000470001,
        VK_FORMAT_MAX_ENUM = 2147483647
}

enum VkImageTiling: uint32
{
        VK_IMAGE_TILING_OPTIMAL = 0,
        VK_IMAGE_TILING_LINEAR = 1,
        VK_IMAGE_TILING_DRM_FORMAT_MODIFIER_EXT = 1000158000,
        VK_IMAGE_TILING_MAX_ENUM = 2147483647
}

enum VkImageType: uint32
{
        VK_IMAGE_TYPE_1D = 0,
        VK_IMAGE_TYPE_2D = 1,
        VK_IMAGE_TYPE_3D = 2,
        VK_IMAGE_TYPE_MAX_ENUM = 2147483647
}

enum VkPhysicalDeviceType: uint32
{
        VK_PHYSICAL_DEVICE_TYPE_OTHER = 0,
        VK_PHYSICAL_DEVICE_TYPE_INTEGRATED_GPU = 1,
        VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU = 2,
        VK_PHYSICAL_DEVICE_TYPE_VIRTUAL_GPU = 3,
        VK_PHYSICAL_DEVICE_TYPE_CPU = 4,
        VK_PHYSICAL_DEVICE_TYPE_MAX_ENUM = 2147483647
}

enum VkQueryType: uint32
{
        VK_QUERY_TYPE_OCCLUSION = 0,
        VK_QUERY_TYPE_PIPELINE_STATISTICS = 1,
        VK_QUERY_TYPE_TIMESTAMP = 2,
        VK_QUERY_TYPE_RESULT_STATUS_ONLY_KHR = 1000023000,
        VK_QUERY_TYPE_TRANSFORM_FEEDBACK_STREAM_EXT = 1000028004,
        VK_QUERY_TYPE_PERFORMANCE_QUERY_KHR = 1000116000,
        VK_QUERY_TYPE_ACCELERATION_STRUCTURE_COMPACTED_SIZE_KHR = 1000150000,
        VK_QUERY_TYPE_ACCELERATION_STRUCTURE_SERIALIZATION_SIZE_KHR = 1000150001,
        VK_QUERY_TYPE_ACCELERATION_STRUCTURE_COMPACTED_SIZE_NV = 1000165000,
        VK_QUERY_TYPE_PERFORMANCE_QUERY_INTEL = 1000210000,
        VK_QUERY_TYPE_VIDEO_ENCODE_FEEDBACK_KHR = 1000299000,
        VK_QUERY_TYPE_MESH_PRIMITIVES_GENERATED_EXT = 1000328000,
        VK_QUERY_TYPE_PRIMITIVES_GENERATED_EXT = 1000382000,
        VK_QUERY_TYPE_ACCELERATION_STRUCTURE_SERIALIZATION_BOTTOM_LEVEL_POINTERS_KHR = 1000386000,
        VK_QUERY_TYPE_ACCELERATION_STRUCTURE_SIZE_KHR = 1000386001,
        VK_QUERY_TYPE_MICROMAP_SERIALIZATION_SIZE_EXT = 1000396000,
        VK_QUERY_TYPE_MICROMAP_COMPACTED_SIZE_EXT = 1000396001,
        VK_QUERY_TYPE_MAX_ENUM = 2147483647
}

enum VkSharingMode: uint32
{
        VK_SHARING_MODE_EXCLUSIVE = 0,
        VK_SHARING_MODE_CONCURRENT = 1,
        VK_SHARING_MODE_MAX_ENUM = 2147483647
}

enum VkComponentSwizzle: uint32
{
        VK_COMPONENT_SWIZZLE_IDENTITY = 0,
        VK_COMPONENT_SWIZZLE_ZERO = 1,
        VK_COMPONENT_SWIZZLE_ONE = 2,
        VK_COMPONENT_SWIZZLE_R = 3,
        VK_COMPONENT_SWIZZLE_G = 4,
        VK_COMPONENT_SWIZZLE_B = 5,
        VK_COMPONENT_SWIZZLE_A = 6,
        VK_COMPONENT_SWIZZLE_MAX_ENUM = 2147483647
}

enum VkImageViewType: uint32
{
        VK_IMAGE_VIEW_TYPE_1D = 0,
        VK_IMAGE_VIEW_TYPE_2D = 1,
        VK_IMAGE_VIEW_TYPE_3D = 2,
        VK_IMAGE_VIEW_TYPE_CUBE = 3,
        VK_IMAGE_VIEW_TYPE_1D_ARRAY = 4,
        VK_IMAGE_VIEW_TYPE_2D_ARRAY = 5,
        VK_IMAGE_VIEW_TYPE_CUBE_ARRAY = 6,
        VK_IMAGE_VIEW_TYPE_MAX_ENUM = 2147483647
}

enum VkBlendFactor: uint32
{
        VK_BLEND_FACTOR_ZERO = 0,
        VK_BLEND_FACTOR_ONE = 1,
        VK_BLEND_FACTOR_SRC_COLOR = 2,
        VK_BLEND_FACTOR_ONE_MINUS_SRC_COLOR = 3,
        VK_BLEND_FACTOR_DST_COLOR = 4,
        VK_BLEND_FACTOR_ONE_MINUS_DST_COLOR = 5,
        VK_BLEND_FACTOR_SRC_ALPHA = 6,
        VK_BLEND_FACTOR_ONE_MINUS_SRC_ALPHA = 7,
        VK_BLEND_FACTOR_DST_ALPHA = 8,
        VK_BLEND_FACTOR_ONE_MINUS_DST_ALPHA = 9,
        VK_BLEND_FACTOR_CONSTANT_COLOR = 10,
        VK_BLEND_FACTOR_ONE_MINUS_CONSTANT_COLOR = 11,
        VK_BLEND_FACTOR_CONSTANT_ALPHA = 12,
        VK_BLEND_FACTOR_ONE_MINUS_CONSTANT_ALPHA = 13,
        VK_BLEND_FACTOR_SRC_ALPHA_SATURATE = 14,
        VK_BLEND_FACTOR_SRC1_COLOR = 15,
        VK_BLEND_FACTOR_ONE_MINUS_SRC1_COLOR = 16,
        VK_BLEND_FACTOR_SRC1_ALPHA = 17,
        VK_BLEND_FACTOR_ONE_MINUS_SRC1_ALPHA = 18,
        VK_BLEND_FACTOR_MAX_ENUM = 2147483647
}

enum VkBlendOp: uint32
{
        VK_BLEND_OP_ADD = 0,
        VK_BLEND_OP_SUBTRACT = 1,
        VK_BLEND_OP_REVERSE_SUBTRACT = 2,
        VK_BLEND_OP_MIN = 3,
        VK_BLEND_OP_MAX = 4,
        VK_BLEND_OP_ZERO_EXT = 1000148000,
        VK_BLEND_OP_SRC_EXT = 1000148001,
        VK_BLEND_OP_DST_EXT = 1000148002,
        VK_BLEND_OP_SRC_OVER_EXT = 1000148003,
        VK_BLEND_OP_DST_OVER_EXT = 1000148004,
        VK_BLEND_OP_SRC_IN_EXT = 1000148005,
        VK_BLEND_OP_DST_IN_EXT = 1000148006,
        VK_BLEND_OP_SRC_OUT_EXT = 1000148007,
        VK_BLEND_OP_DST_OUT_EXT = 1000148008,
        VK_BLEND_OP_SRC_ATOP_EXT = 1000148009,
        VK_BLEND_OP_DST_ATOP_EXT = 1000148010,
        VK_BLEND_OP_XOR_EXT = 1000148011,
        VK_BLEND_OP_MULTIPLY_EXT = 1000148012,
        VK_BLEND_OP_SCREEN_EXT = 1000148013,
        VK_BLEND_OP_OVERLAY_EXT = 1000148014,
        VK_BLEND_OP_DARKEN_EXT = 1000148015,
        VK_BLEND_OP_LIGHTEN_EXT = 1000148016,
        VK_BLEND_OP_COLORDODGE_EXT = 1000148017,
        VK_BLEND_OP_COLORBURN_EXT = 1000148018,
        VK_BLEND_OP_HARDLIGHT_EXT = 1000148019,
        VK_BLEND_OP_SOFTLIGHT_EXT = 1000148020,
        VK_BLEND_OP_DIFFERENCE_EXT = 1000148021,
        VK_BLEND_OP_EXCLUSION_EXT = 1000148022,
        VK_BLEND_OP_INVERT_EXT = 1000148023,
        VK_BLEND_OP_INVERT_RGB_EXT = 1000148024,
        VK_BLEND_OP_LINEARDODGE_EXT = 1000148025,
        VK_BLEND_OP_LINEARBURN_EXT = 1000148026,
        VK_BLEND_OP_VIVIDLIGHT_EXT = 1000148027,
        VK_BLEND_OP_LINEARLIGHT_EXT = 1000148028,
        VK_BLEND_OP_PINLIGHT_EXT = 1000148029,
        VK_BLEND_OP_HARDMIX_EXT = 1000148030,
        VK_BLEND_OP_HSL_HUE_EXT = 1000148031,
        VK_BLEND_OP_HSL_SATURATION_EXT = 1000148032,
        VK_BLEND_OP_HSL_COLOR_EXT = 1000148033,
        VK_BLEND_OP_HSL_LUMINOSITY_EXT = 1000148034,
        VK_BLEND_OP_PLUS_EXT = 1000148035,
        VK_BLEND_OP_PLUS_CLAMPED_EXT = 1000148036,
        VK_BLEND_OP_PLUS_CLAMPED_ALPHA_EXT = 1000148037,
        VK_BLEND_OP_PLUS_DARKER_EXT = 1000148038,
        VK_BLEND_OP_MINUS_EXT = 1000148039,
        VK_BLEND_OP_MINUS_CLAMPED_EXT = 1000148040,
        VK_BLEND_OP_CONTRAST_EXT = 1000148041,
        VK_BLEND_OP_INVERT_OVG_EXT = 1000148042,
        VK_BLEND_OP_RED_EXT = 1000148043,
        VK_BLEND_OP_GREEN_EXT = 1000148044,
        VK_BLEND_OP_BLUE_EXT = 1000148045,
        VK_BLEND_OP_MAX_ENUM = 2147483647
}

enum VkCompareOp: uint32
{
        VK_COMPARE_OP_NEVER = 0,
        VK_COMPARE_OP_LESS = 1,
        VK_COMPARE_OP_EQUAL = 2,
        VK_COMPARE_OP_LESS_OR_EQUAL = 3,
        VK_COMPARE_OP_GREATER = 4,
        VK_COMPARE_OP_NOT_EQUAL = 5,
        VK_COMPARE_OP_GREATER_OR_EQUAL = 6,
        VK_COMPARE_OP_ALWAYS = 7,
        VK_COMPARE_OP_MAX_ENUM = 2147483647
}

enum VkDynamicState: uint32
{
        VK_DYNAMIC_STATE_VIEWPORT = 0,
        VK_DYNAMIC_STATE_SCISSOR = 1,
        VK_DYNAMIC_STATE_LINE_WIDTH = 2,
        VK_DYNAMIC_STATE_DEPTH_BIAS = 3,
        VK_DYNAMIC_STATE_BLEND_CONSTANTS = 4,
        VK_DYNAMIC_STATE_DEPTH_BOUNDS = 5,
        VK_DYNAMIC_STATE_STENCIL_COMPARE_MASK = 6,
        VK_DYNAMIC_STATE_STENCIL_WRITE_MASK = 7,
        VK_DYNAMIC_STATE_STENCIL_REFERENCE = 8,
        VK_DYNAMIC_STATE_CULL_MODE = 1000267000,
        VK_DYNAMIC_STATE_FRONT_FACE = 1000267001,
        VK_DYNAMIC_STATE_PRIMITIVE_TOPOLOGY = 1000267002,
        VK_DYNAMIC_STATE_VIEWPORT_WITH_COUNT = 1000267003,
        VK_DYNAMIC_STATE_SCISSOR_WITH_COUNT = 1000267004,
        VK_DYNAMIC_STATE_VERTEX_INPUT_BINDING_STRIDE = 1000267005,
        VK_DYNAMIC_STATE_DEPTH_TEST_ENABLE = 1000267006,
        VK_DYNAMIC_STATE_DEPTH_WRITE_ENABLE = 1000267007,
        VK_DYNAMIC_STATE_DEPTH_COMPARE_OP = 1000267008,
        VK_DYNAMIC_STATE_DEPTH_BOUNDS_TEST_ENABLE = 1000267009,
        VK_DYNAMIC_STATE_STENCIL_TEST_ENABLE = 1000267010,
        VK_DYNAMIC_STATE_STENCIL_OP = 1000267011,
        VK_DYNAMIC_STATE_RASTERIZER_DISCARD_ENABLE = 1000377001,
        VK_DYNAMIC_STATE_DEPTH_BIAS_ENABLE = 1000377002,
        VK_DYNAMIC_STATE_PRIMITIVE_RESTART_ENABLE = 1000377004,
        VK_DYNAMIC_STATE_LINE_STIPPLE = 1000259000,
        VK_DYNAMIC_STATE_VIEWPORT_W_SCALING_NV = 1000087000,
        VK_DYNAMIC_STATE_DISCARD_RECTANGLE_EXT = 1000099000,
        VK_DYNAMIC_STATE_DISCARD_RECTANGLE_ENABLE_EXT = 1000099001,
        VK_DYNAMIC_STATE_DISCARD_RECTANGLE_MODE_EXT = 1000099002,
        VK_DYNAMIC_STATE_SAMPLE_LOCATIONS_EXT = 1000143000,
        VK_DYNAMIC_STATE_RAY_TRACING_PIPELINE_STACK_SIZE_KHR = 1000347000,
        VK_DYNAMIC_STATE_VIEWPORT_SHADING_RATE_PALETTE_NV = 1000164004,
        VK_DYNAMIC_STATE_VIEWPORT_COARSE_SAMPLE_ORDER_NV = 1000164006,
        VK_DYNAMIC_STATE_EXCLUSIVE_SCISSOR_ENABLE_NV = 1000205000,
        VK_DYNAMIC_STATE_EXCLUSIVE_SCISSOR_NV = 1000205001,
        VK_DYNAMIC_STATE_FRAGMENT_SHADING_RATE_KHR = 1000226000,
        VK_DYNAMIC_STATE_VERTEX_INPUT_EXT = 1000352000,
        VK_DYNAMIC_STATE_PATCH_CONTROL_POINTS_EXT = 1000377000,
        VK_DYNAMIC_STATE_LOGIC_OP_EXT = 1000377003,
        VK_DYNAMIC_STATE_COLOR_WRITE_ENABLE_EXT = 1000381000,
        VK_DYNAMIC_STATE_DEPTH_CLAMP_ENABLE_EXT = 1000455003,
        VK_DYNAMIC_STATE_POLYGON_MODE_EXT = 1000455004,
        VK_DYNAMIC_STATE_RASTERIZATION_SAMPLES_EXT = 1000455005,
        VK_DYNAMIC_STATE_SAMPLE_MASK_EXT = 1000455006,
        VK_DYNAMIC_STATE_ALPHA_TO_COVERAGE_ENABLE_EXT = 1000455007,
        VK_DYNAMIC_STATE_ALPHA_TO_ONE_ENABLE_EXT = 1000455008,
        VK_DYNAMIC_STATE_LOGIC_OP_ENABLE_EXT = 1000455009,
        VK_DYNAMIC_STATE_COLOR_BLEND_ENABLE_EXT = 1000455010,
        VK_DYNAMIC_STATE_COLOR_BLEND_EQUATION_EXT = 1000455011,
        VK_DYNAMIC_STATE_COLOR_WRITE_MASK_EXT = 1000455012,
        VK_DYNAMIC_STATE_TESSELLATION_DOMAIN_ORIGIN_EXT = 1000455002,
        VK_DYNAMIC_STATE_RASTERIZATION_STREAM_EXT = 1000455013,
        VK_DYNAMIC_STATE_CONSERVATIVE_RASTERIZATION_MODE_EXT = 1000455014,
        VK_DYNAMIC_STATE_EXTRA_PRIMITIVE_OVERESTIMATION_SIZE_EXT = 1000455015,
        VK_DYNAMIC_STATE_DEPTH_CLIP_ENABLE_EXT = 1000455016,
        VK_DYNAMIC_STATE_SAMPLE_LOCATIONS_ENABLE_EXT = 1000455017,
        VK_DYNAMIC_STATE_COLOR_BLEND_ADVANCED_EXT = 1000455018,
        VK_DYNAMIC_STATE_PROVOKING_VERTEX_MODE_EXT = 1000455019,
        VK_DYNAMIC_STATE_LINE_RASTERIZATION_MODE_EXT = 1000455020,
        VK_DYNAMIC_STATE_LINE_STIPPLE_ENABLE_EXT = 1000455021,
        VK_DYNAMIC_STATE_DEPTH_CLIP_NEGATIVE_ONE_TO_ONE_EXT = 1000455022,
        VK_DYNAMIC_STATE_VIEWPORT_W_SCALING_ENABLE_NV = 1000455023,
        VK_DYNAMIC_STATE_VIEWPORT_SWIZZLE_NV = 1000455024,
        VK_DYNAMIC_STATE_COVERAGE_TO_COLOR_ENABLE_NV = 1000455025,
        VK_DYNAMIC_STATE_COVERAGE_TO_COLOR_LOCATION_NV = 1000455026,
        VK_DYNAMIC_STATE_COVERAGE_MODULATION_MODE_NV = 1000455027,
        VK_DYNAMIC_STATE_COVERAGE_MODULATION_TABLE_ENABLE_NV = 1000455028,
        VK_DYNAMIC_STATE_COVERAGE_MODULATION_TABLE_NV = 1000455029,
        VK_DYNAMIC_STATE_SHADING_RATE_IMAGE_ENABLE_NV = 1000455030,
        VK_DYNAMIC_STATE_REPRESENTATIVE_FRAGMENT_TEST_ENABLE_NV = 1000455031,
        VK_DYNAMIC_STATE_COVERAGE_REDUCTION_MODE_NV = 1000455032,
        VK_DYNAMIC_STATE_ATTACHMENT_FEEDBACK_LOOP_ENABLE_EXT = 1000524000,
        VK_DYNAMIC_STATE_DEPTH_CLAMP_RANGE_EXT = 1000582000,
        VK_DYNAMIC_STATE_LINE_STIPPLE_EXT = 1000259000,
        VK_DYNAMIC_STATE_CULL_MODE_EXT = 1000267000,
        VK_DYNAMIC_STATE_FRONT_FACE_EXT = 1000267001,
        VK_DYNAMIC_STATE_PRIMITIVE_TOPOLOGY_EXT = 1000267002,
        VK_DYNAMIC_STATE_VIEWPORT_WITH_COUNT_EXT = 1000267003,
        VK_DYNAMIC_STATE_SCISSOR_WITH_COUNT_EXT = 1000267004,
        VK_DYNAMIC_STATE_VERTEX_INPUT_BINDING_STRIDE_EXT = 1000267005,
        VK_DYNAMIC_STATE_DEPTH_TEST_ENABLE_EXT = 1000267006,
        VK_DYNAMIC_STATE_DEPTH_WRITE_ENABLE_EXT = 1000267007,
        VK_DYNAMIC_STATE_DEPTH_COMPARE_OP_EXT = 1000267008,
        VK_DYNAMIC_STATE_DEPTH_BOUNDS_TEST_ENABLE_EXT = 1000267009,
        VK_DYNAMIC_STATE_STENCIL_TEST_ENABLE_EXT = 1000267010,
        VK_DYNAMIC_STATE_STENCIL_OP_EXT = 1000267011,
        VK_DYNAMIC_STATE_RASTERIZER_DISCARD_ENABLE_EXT = 1000377001,
        VK_DYNAMIC_STATE_DEPTH_BIAS_ENABLE_EXT = 1000377002,
        VK_DYNAMIC_STATE_PRIMITIVE_RESTART_ENABLE_EXT = 1000377004,
        VK_DYNAMIC_STATE_LINE_STIPPLE_KHR = 1000259000,
        VK_DYNAMIC_STATE_MAX_ENUM = 2147483647
}

enum VkFrontFace: uint32
{
        VK_FRONT_FACE_COUNTER_CLOCKWISE = 0,
        VK_FRONT_FACE_CLOCKWISE = 1,
        VK_FRONT_FACE_MAX_ENUM = 2147483647
}

enum VkVertexInputRate: uint32
{
        VK_VERTEX_INPUT_RATE_VERTEX = 0,
        VK_VERTEX_INPUT_RATE_INSTANCE = 1,
        VK_VERTEX_INPUT_RATE_MAX_ENUM = 2147483647
}

enum VkPrimitiveTopology: uint32
{
        VK_PRIMITIVE_TOPOLOGY_POINT_LIST = 0,
        VK_PRIMITIVE_TOPOLOGY_LINE_LIST = 1,
        VK_PRIMITIVE_TOPOLOGY_LINE_STRIP = 2,
        VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST = 3,
        VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP = 4,
        VK_PRIMITIVE_TOPOLOGY_TRIANGLE_FAN = 5,
        VK_PRIMITIVE_TOPOLOGY_LINE_LIST_WITH_ADJACENCY = 6,
        VK_PRIMITIVE_TOPOLOGY_LINE_STRIP_WITH_ADJACENCY = 7,
        VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST_WITH_ADJACENCY = 8,
        VK_PRIMITIVE_TOPOLOGY_TRIANGLE_STRIP_WITH_ADJACENCY = 9,
        VK_PRIMITIVE_TOPOLOGY_PATCH_LIST = 10,
        VK_PRIMITIVE_TOPOLOGY_MAX_ENUM = 2147483647
}

enum VkPolygonMode: uint32
{
        VK_POLYGON_MODE_FILL = 0,
        VK_POLYGON_MODE_LINE = 1,
        VK_POLYGON_MODE_POINT = 2,
        VK_POLYGON_MODE_FILL_RECTANGLE_NV = 1000153000,
        VK_POLYGON_MODE_MAX_ENUM = 2147483647
}

enum VkStencilOp: uint32
{
        VK_STENCIL_OP_KEEP = 0,
        VK_STENCIL_OP_ZERO = 1,
        VK_STENCIL_OP_REPLACE = 2,
        VK_STENCIL_OP_INCREMENT_AND_CLAMP = 3,
        VK_STENCIL_OP_DECREMENT_AND_CLAMP = 4,
        VK_STENCIL_OP_INVERT = 5,
        VK_STENCIL_OP_INCREMENT_AND_WRAP = 6,
        VK_STENCIL_OP_DECREMENT_AND_WRAP = 7,
        VK_STENCIL_OP_MAX_ENUM = 2147483647
}

enum VkLogicOp: uint32
{
        VK_LOGIC_OP_CLEAR = 0,
        VK_LOGIC_OP_AND = 1,
        VK_LOGIC_OP_AND_REVERSE = 2,
        VK_LOGIC_OP_COPY = 3,
        VK_LOGIC_OP_AND_INVERTED = 4,
        VK_LOGIC_OP_NO_OP = 5,
        VK_LOGIC_OP_XOR = 6,
        VK_LOGIC_OP_OR = 7,
        VK_LOGIC_OP_NOR = 8,
        VK_LOGIC_OP_EQUIVALENT = 9,
        VK_LOGIC_OP_INVERT = 10,
        VK_LOGIC_OP_OR_REVERSE = 11,
        VK_LOGIC_OP_COPY_INVERTED = 12,
        VK_LOGIC_OP_OR_INVERTED = 13,
        VK_LOGIC_OP_NAND = 14,
        VK_LOGIC_OP_SET = 15,
        VK_LOGIC_OP_MAX_ENUM = 2147483647
}

enum VkBorderColor: uint32
{
        VK_BORDER_COLOR_FLOAT_TRANSPARENT_BLACK = 0,
        VK_BORDER_COLOR_INT_TRANSPARENT_BLACK = 1,
        VK_BORDER_COLOR_FLOAT_OPAQUE_BLACK = 2,
        VK_BORDER_COLOR_INT_OPAQUE_BLACK = 3,
        VK_BORDER_COLOR_FLOAT_OPAQUE_WHITE = 4,
        VK_BORDER_COLOR_INT_OPAQUE_WHITE = 5,
        VK_BORDER_COLOR_FLOAT_CUSTOM_EXT = 1000287003,
        VK_BORDER_COLOR_INT_CUSTOM_EXT = 1000287004,
        VK_BORDER_COLOR_MAX_ENUM = 2147483647
}

enum VkFilter: uint32
{
        VK_FILTER_NEAREST = 0,
        VK_FILTER_LINEAR = 1,
        VK_FILTER_CUBIC_EXT = 1000015000,
        VK_FILTER_CUBIC_IMG = 1000015000,
        VK_FILTER_MAX_ENUM = 2147483647
}

enum VkSamplerAddressMode: uint32
{
        VK_SAMPLER_ADDRESS_MODE_REPEAT = 0,
        VK_SAMPLER_ADDRESS_MODE_MIRRORED_REPEAT = 1,
        VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_EDGE = 2,
        VK_SAMPLER_ADDRESS_MODE_CLAMP_TO_BORDER = 3,
        VK_SAMPLER_ADDRESS_MODE_MIRROR_CLAMP_TO_EDGE = 4,
        VK_SAMPLER_ADDRESS_MODE_MIRROR_CLAMP_TO_EDGE_KHR = 4,
        VK_SAMPLER_ADDRESS_MODE_MAX_ENUM = 2147483647
}

enum VkSamplerMipmapMode: uint32
{
        VK_SAMPLER_MIPMAP_MODE_NEAREST = 0,
        VK_SAMPLER_MIPMAP_MODE_LINEAR = 1,
        VK_SAMPLER_MIPMAP_MODE_MAX_ENUM = 2147483647
}

enum VkDescriptorType: uint32
{
        VK_DESCRIPTOR_TYPE_SAMPLER = 0,
        VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER = 1,
        VK_DESCRIPTOR_TYPE_SAMPLED_IMAGE = 2,
        VK_DESCRIPTOR_TYPE_STORAGE_IMAGE = 3,
        VK_DESCRIPTOR_TYPE_UNIFORM_TEXEL_BUFFER = 4,
        VK_DESCRIPTOR_TYPE_STORAGE_TEXEL_BUFFER = 5,
        VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER = 6,
        VK_DESCRIPTOR_TYPE_STORAGE_BUFFER = 7,
        VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER_DYNAMIC = 8,
        VK_DESCRIPTOR_TYPE_STORAGE_BUFFER_DYNAMIC = 9,
        VK_DESCRIPTOR_TYPE_INPUT_ATTACHMENT = 10,
        VK_DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK = 1000138000,
        VK_DESCRIPTOR_TYPE_ACCELERATION_STRUCTURE_KHR = 1000150000,
        VK_DESCRIPTOR_TYPE_ACCELERATION_STRUCTURE_NV = 1000165000,
        VK_DESCRIPTOR_TYPE_SAMPLE_WEIGHT_IMAGE_QCOM = 1000440000,
        VK_DESCRIPTOR_TYPE_BLOCK_MATCH_IMAGE_QCOM = 1000440001,
        VK_DESCRIPTOR_TYPE_MUTABLE_EXT = 1000351000,
        VK_DESCRIPTOR_TYPE_PARTITIONED_ACCELERATION_STRUCTURE_NV = 1000570000,
        VK_DESCRIPTOR_TYPE_INLINE_UNIFORM_BLOCK_EXT = 1000138000,
        VK_DESCRIPTOR_TYPE_MUTABLE_VALVE = 1000351000,
        VK_DESCRIPTOR_TYPE_MAX_ENUM = 2147483647
}

enum VkAttachmentLoadOp: uint32
{
        VK_ATTACHMENT_LOAD_OP_LOAD = 0,
        VK_ATTACHMENT_LOAD_OP_CLEAR = 1,
        VK_ATTACHMENT_LOAD_OP_DONT_CARE = 2,
        VK_ATTACHMENT_LOAD_OP_NONE = 1000400000,
        VK_ATTACHMENT_LOAD_OP_NONE_EXT = 1000400000,
        VK_ATTACHMENT_LOAD_OP_NONE_KHR = 1000400000,
        VK_ATTACHMENT_LOAD_OP_MAX_ENUM = 2147483647
}

enum VkAttachmentStoreOp: uint32
{
        VK_ATTACHMENT_STORE_OP_STORE = 0,
        VK_ATTACHMENT_STORE_OP_DONT_CARE = 1,
        VK_ATTACHMENT_STORE_OP_NONE = 1000301000,
        VK_ATTACHMENT_STORE_OP_NONE_KHR = 1000301000,
        VK_ATTACHMENT_STORE_OP_NONE_QCOM = 1000301000,
        VK_ATTACHMENT_STORE_OP_NONE_EXT = 1000301000,
        VK_ATTACHMENT_STORE_OP_MAX_ENUM = 2147483647
}

enum VkPipelineBindPoint: uint32
{
        VK_PIPELINE_BIND_POINT_GRAPHICS = 0,
        VK_PIPELINE_BIND_POINT_COMPUTE = 1,
        VK_PIPELINE_BIND_POINT_RAY_TRACING_KHR = 1000165000,
        VK_PIPELINE_BIND_POINT_SUBPASS_SHADING_HUAWEI = 1000369003,
        VK_PIPELINE_BIND_POINT_RAY_TRACING_NV = 1000165000,
        VK_PIPELINE_BIND_POINT_MAX_ENUM = 2147483647
}

enum VkCommandBufferLevel: uint32
{
        VK_COMMAND_BUFFER_LEVEL_PRIMARY = 0,
        VK_COMMAND_BUFFER_LEVEL_SECONDARY = 1,
        VK_COMMAND_BUFFER_LEVEL_MAX_ENUM = 2147483647
}

enum VkIndexType: uint32
{
        VK_INDEX_TYPE_UINT16 = 0,
        VK_INDEX_TYPE_UINT32 = 1,
        VK_INDEX_TYPE_UINT8 = 1000265000,
        VK_INDEX_TYPE_NONE_KHR = 1000165000,
        VK_INDEX_TYPE_NONE_NV = 1000165000,
        VK_INDEX_TYPE_UINT8_EXT = 1000265000,
        VK_INDEX_TYPE_UINT8_KHR = 1000265000,
        VK_INDEX_TYPE_MAX_ENUM = 2147483647
}

enum VkSubpassContents: uint32
{
        VK_SUBPASS_CONTENTS_INLINE = 0,
        VK_SUBPASS_CONTENTS_SECONDARY_COMMAND_BUFFERS = 1,
        VK_SUBPASS_CONTENTS_INLINE_AND_SECONDARY_COMMAND_BUFFERS_KHR = 1000451000,
        VK_SUBPASS_CONTENTS_INLINE_AND_SECONDARY_COMMAND_BUFFERS_EXT = 1000451000,
        VK_SUBPASS_CONTENTS_MAX_ENUM = 2147483647
}

enum VkAccessFlagBits: uint32
{
        VK_ACCESS_INDIRECT_COMMAND_READ_BIT = 1,
        VK_ACCESS_INDEX_READ_BIT = 2,
        VK_ACCESS_VERTEX_ATTRIBUTE_READ_BIT = 4,
        VK_ACCESS_UNIFORM_READ_BIT = 8,
        VK_ACCESS_INPUT_ATTACHMENT_READ_BIT = 16,
        VK_ACCESS_SHADER_READ_BIT = 32,
        VK_ACCESS_SHADER_WRITE_BIT = 64,
        VK_ACCESS_COLOR_ATTACHMENT_READ_BIT = 128,
        VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT = 256,
        VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_READ_BIT = 512,
        VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT = 1024,
        VK_ACCESS_TRANSFER_READ_BIT = 2048,
        VK_ACCESS_TRANSFER_WRITE_BIT = 4096,
        VK_ACCESS_HOST_READ_BIT = 8192,
        VK_ACCESS_HOST_WRITE_BIT = 16384,
        VK_ACCESS_MEMORY_READ_BIT = 32768,
        VK_ACCESS_MEMORY_WRITE_BIT = 65536,
        VK_ACCESS_NONE = 0,
        VK_ACCESS_TRANSFORM_FEEDBACK_WRITE_BIT_EXT = 33554432,
        VK_ACCESS_TRANSFORM_FEEDBACK_COUNTER_READ_BIT_EXT = 67108864,
        VK_ACCESS_TRANSFORM_FEEDBACK_COUNTER_WRITE_BIT_EXT = 134217728,
        VK_ACCESS_CONDITIONAL_RENDERING_READ_BIT_EXT = 1048576,
        VK_ACCESS_COLOR_ATTACHMENT_READ_NONCOHERENT_BIT_EXT = 524288,
        VK_ACCESS_ACCELERATION_STRUCTURE_READ_BIT_KHR = 2097152,
        VK_ACCESS_ACCELERATION_STRUCTURE_WRITE_BIT_KHR = 4194304,
        VK_ACCESS_FRAGMENT_DENSITY_MAP_READ_BIT_EXT = 16777216,
        VK_ACCESS_FRAGMENT_SHADING_RATE_ATTACHMENT_READ_BIT_KHR = 8388608,
        VK_ACCESS_COMMAND_PREPROCESS_READ_BIT_NV = 131072,
        VK_ACCESS_COMMAND_PREPROCESS_WRITE_BIT_NV = 262144,
        VK_ACCESS_SHADING_RATE_IMAGE_READ_BIT_NV = 8388608,
        VK_ACCESS_ACCELERATION_STRUCTURE_READ_BIT_NV = 2097152,
        VK_ACCESS_ACCELERATION_STRUCTURE_WRITE_BIT_NV = 4194304,
        VK_ACCESS_NONE_KHR = 0,
        VK_ACCESS_COMMAND_PREPROCESS_READ_BIT_EXT = 131072,
        VK_ACCESS_COMMAND_PREPROCESS_WRITE_BIT_EXT = 262144,
        VK_ACCESS_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkImageAspectFlagBits: uint32
{
        VK_IMAGE_ASPECT_COLOR_BIT = 1,
        VK_IMAGE_ASPECT_DEPTH_BIT = 2,
        VK_IMAGE_ASPECT_STENCIL_BIT = 4,
        VK_IMAGE_ASPECT_METADATA_BIT = 8,
        VK_IMAGE_ASPECT_PLANE_0_BIT = 16,
        VK_IMAGE_ASPECT_PLANE_1_BIT = 32,
        VK_IMAGE_ASPECT_PLANE_2_BIT = 64,
        VK_IMAGE_ASPECT_NONE = 0,
        VK_IMAGE_ASPECT_MEMORY_PLANE_0_BIT_EXT = 128,
        VK_IMAGE_ASPECT_MEMORY_PLANE_1_BIT_EXT = 256,
        VK_IMAGE_ASPECT_MEMORY_PLANE_2_BIT_EXT = 512,
        VK_IMAGE_ASPECT_MEMORY_PLANE_3_BIT_EXT = 1024,
        VK_IMAGE_ASPECT_PLANE_0_BIT_KHR = 16,
        VK_IMAGE_ASPECT_PLANE_1_BIT_KHR = 32,
        VK_IMAGE_ASPECT_PLANE_2_BIT_KHR = 64,
        VK_IMAGE_ASPECT_NONE_KHR = 0,
        VK_IMAGE_ASPECT_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkFormatFeatureFlagBits: uint32
{
        VK_FORMAT_FEATURE_SAMPLED_IMAGE_BIT = 1,
        VK_FORMAT_FEATURE_STORAGE_IMAGE_BIT = 2,
        VK_FORMAT_FEATURE_STORAGE_IMAGE_ATOMIC_BIT = 4,
        VK_FORMAT_FEATURE_UNIFORM_TEXEL_BUFFER_BIT = 8,
        VK_FORMAT_FEATURE_STORAGE_TEXEL_BUFFER_BIT = 16,
        VK_FORMAT_FEATURE_STORAGE_TEXEL_BUFFER_ATOMIC_BIT = 32,
        VK_FORMAT_FEATURE_VERTEX_BUFFER_BIT = 64,
        VK_FORMAT_FEATURE_COLOR_ATTACHMENT_BIT = 128,
        VK_FORMAT_FEATURE_COLOR_ATTACHMENT_BLEND_BIT = 256,
        VK_FORMAT_FEATURE_DEPTH_STENCIL_ATTACHMENT_BIT = 512,
        VK_FORMAT_FEATURE_BLIT_SRC_BIT = 1024,
        VK_FORMAT_FEATURE_BLIT_DST_BIT = 2048,
        VK_FORMAT_FEATURE_SAMPLED_IMAGE_FILTER_LINEAR_BIT = 4096,
        VK_FORMAT_FEATURE_TRANSFER_SRC_BIT = 16384,
        VK_FORMAT_FEATURE_TRANSFER_DST_BIT = 32768,
        VK_FORMAT_FEATURE_MIDPOINT_CHROMA_SAMPLES_BIT = 131072,
        VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_LINEAR_FILTER_BIT = 262144,
        VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_SEPARATE_RECONSTRUCTION_FILTER_BIT = 524288,
        VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_BIT = 1048576,
        VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_FORCEABLE_BIT = 2097152,
        VK_FORMAT_FEATURE_DISJOINT_BIT = 4194304,
        VK_FORMAT_FEATURE_COSITED_CHROMA_SAMPLES_BIT = 8388608,
        VK_FORMAT_FEATURE_SAMPLED_IMAGE_FILTER_MINMAX_BIT = 65536,
        VK_FORMAT_FEATURE_VIDEO_DECODE_OUTPUT_BIT_KHR = 33554432,
        VK_FORMAT_FEATURE_VIDEO_DECODE_DPB_BIT_KHR = 67108864,
        VK_FORMAT_FEATURE_ACCELERATION_STRUCTURE_VERTEX_BUFFER_BIT_KHR = 536870912,
        VK_FORMAT_FEATURE_SAMPLED_IMAGE_FILTER_CUBIC_BIT_EXT = 8192,
        VK_FORMAT_FEATURE_FRAGMENT_DENSITY_MAP_BIT_EXT = 16777216,
        VK_FORMAT_FEATURE_FRAGMENT_SHADING_RATE_ATTACHMENT_BIT_KHR = 1073741824,
        VK_FORMAT_FEATURE_VIDEO_ENCODE_INPUT_BIT_KHR = 134217728,
        VK_FORMAT_FEATURE_VIDEO_ENCODE_DPB_BIT_KHR = 268435456,
        VK_FORMAT_FEATURE_SAMPLED_IMAGE_FILTER_CUBIC_BIT_IMG = 8192,
        VK_FORMAT_FEATURE_TRANSFER_SRC_BIT_KHR = 16384,
        VK_FORMAT_FEATURE_TRANSFER_DST_BIT_KHR = 32768,
        VK_FORMAT_FEATURE_SAMPLED_IMAGE_FILTER_MINMAX_BIT_EXT = 65536,
        VK_FORMAT_FEATURE_MIDPOINT_CHROMA_SAMPLES_BIT_KHR = 131072,
        VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_LINEAR_FILTER_BIT_KHR = 262144,
        VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_SEPARATE_RECONSTRUCTION_FILTER_BIT_KHR = 524288,
        VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_BIT_KHR = 1048576,
        VK_FORMAT_FEATURE_SAMPLED_IMAGE_YCBCR_CONVERSION_CHROMA_RECONSTRUCTION_EXPLICIT_FORCEABLE_BIT_KHR = 2097152,
        VK_FORMAT_FEATURE_DISJOINT_BIT_KHR = 4194304,
        VK_FORMAT_FEATURE_COSITED_CHROMA_SAMPLES_BIT_KHR = 8388608,
        VK_FORMAT_FEATURE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkImageCreateFlagBits: uint32
{
        VK_IMAGE_CREATE_SPARSE_BINDING_BIT = 1,
        VK_IMAGE_CREATE_SPARSE_RESIDENCY_BIT = 2,
        VK_IMAGE_CREATE_SPARSE_ALIASED_BIT = 4,
        VK_IMAGE_CREATE_MUTABLE_FORMAT_BIT = 8,
        VK_IMAGE_CREATE_CUBE_COMPATIBLE_BIT = 16,
        VK_IMAGE_CREATE_ALIAS_BIT = 1024,
        VK_IMAGE_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT = 64,
        VK_IMAGE_CREATE_2D_ARRAY_COMPATIBLE_BIT = 32,
        VK_IMAGE_CREATE_BLOCK_TEXEL_VIEW_COMPATIBLE_BIT = 128,
        VK_IMAGE_CREATE_EXTENDED_USAGE_BIT = 256,
        VK_IMAGE_CREATE_PROTECTED_BIT = 2048,
        VK_IMAGE_CREATE_DISJOINT_BIT = 512,
        VK_IMAGE_CREATE_CORNER_SAMPLED_BIT_NV = 8192,
        VK_IMAGE_CREATE_SAMPLE_LOCATIONS_COMPATIBLE_DEPTH_BIT_EXT = 4096,
        VK_IMAGE_CREATE_SUBSAMPLED_BIT_EXT = 16384,
        VK_IMAGE_CREATE_DESCRIPTOR_BUFFER_CAPTURE_REPLAY_BIT_EXT = 65536,
        VK_IMAGE_CREATE_MULTISAMPLED_RENDER_TO_SINGLE_SAMPLED_BIT_EXT = 262144,
        VK_IMAGE_CREATE_2D_VIEW_COMPATIBLE_BIT_EXT = 131072,
        VK_IMAGE_CREATE_FRAGMENT_DENSITY_MAP_OFFSET_BIT_QCOM = 32768,
        VK_IMAGE_CREATE_VIDEO_PROFILE_INDEPENDENT_BIT_KHR = 1048576,
        VK_IMAGE_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT_KHR = 64,
        VK_IMAGE_CREATE_2D_ARRAY_COMPATIBLE_BIT_KHR = 32,
        VK_IMAGE_CREATE_BLOCK_TEXEL_VIEW_COMPATIBLE_BIT_KHR = 128,
        VK_IMAGE_CREATE_EXTENDED_USAGE_BIT_KHR = 256,
        VK_IMAGE_CREATE_DISJOINT_BIT_KHR = 512,
        VK_IMAGE_CREATE_ALIAS_BIT_KHR = 1024,
        VK_IMAGE_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkSampleCountFlagBits: uint32
{
        VK_SAMPLE_COUNT_1_BIT = 1,
        VK_SAMPLE_COUNT_2_BIT = 2,
        VK_SAMPLE_COUNT_4_BIT = 4,
        VK_SAMPLE_COUNT_8_BIT = 8,
        VK_SAMPLE_COUNT_16_BIT = 16,
        VK_SAMPLE_COUNT_32_BIT = 32,
        VK_SAMPLE_COUNT_64_BIT = 64,
        VK_SAMPLE_COUNT_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkImageUsageFlagBits: uint32
{
        VK_IMAGE_USAGE_TRANSFER_SRC_BIT = 1,
        VK_IMAGE_USAGE_TRANSFER_DST_BIT = 2,
        VK_IMAGE_USAGE_SAMPLED_BIT = 4,
        VK_IMAGE_USAGE_STORAGE_BIT = 8,
        VK_IMAGE_USAGE_COLOR_ATTACHMENT_BIT = 16,
        VK_IMAGE_USAGE_DEPTH_STENCIL_ATTACHMENT_BIT = 32,
        VK_IMAGE_USAGE_TRANSIENT_ATTACHMENT_BIT = 64,
        VK_IMAGE_USAGE_INPUT_ATTACHMENT_BIT = 128,
        VK_IMAGE_USAGE_HOST_TRANSFER_BIT = 4194304,
        VK_IMAGE_USAGE_VIDEO_DECODE_DST_BIT_KHR = 1024,
        VK_IMAGE_USAGE_VIDEO_DECODE_SRC_BIT_KHR = 2048,
        VK_IMAGE_USAGE_VIDEO_DECODE_DPB_BIT_KHR = 4096,
        VK_IMAGE_USAGE_FRAGMENT_DENSITY_MAP_BIT_EXT = 512,
        VK_IMAGE_USAGE_FRAGMENT_SHADING_RATE_ATTACHMENT_BIT_KHR = 256,
        VK_IMAGE_USAGE_VIDEO_ENCODE_DST_BIT_KHR = 8192,
        VK_IMAGE_USAGE_VIDEO_ENCODE_SRC_BIT_KHR = 16384,
        VK_IMAGE_USAGE_VIDEO_ENCODE_DPB_BIT_KHR = 32768,
        VK_IMAGE_USAGE_ATTACHMENT_FEEDBACK_LOOP_BIT_EXT = 524288,
        VK_IMAGE_USAGE_INVOCATION_MASK_BIT_HUAWEI = 262144,
        VK_IMAGE_USAGE_SAMPLE_WEIGHT_BIT_QCOM = 1048576,
        VK_IMAGE_USAGE_SAMPLE_BLOCK_MATCH_BIT_QCOM = 2097152,
        VK_IMAGE_USAGE_VIDEO_ENCODE_QUANTIZATION_DELTA_MAP_BIT_KHR = 33554432,
        VK_IMAGE_USAGE_VIDEO_ENCODE_EMPHASIS_MAP_BIT_KHR = 67108864,
        VK_IMAGE_USAGE_SHADING_RATE_IMAGE_BIT_NV = 256,
        VK_IMAGE_USAGE_HOST_TRANSFER_BIT_EXT = 4194304,
        VK_IMAGE_USAGE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkInstanceCreateFlagBits: uint32
{
        VK_INSTANCE_CREATE_ENUMERATE_PORTABILITY_BIT_KHR = 1,
        VK_INSTANCE_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkMemoryHeapFlagBits: uint32
{
        VK_MEMORY_HEAP_DEVICE_LOCAL_BIT = 1,
        VK_MEMORY_HEAP_MULTI_INSTANCE_BIT = 2,
        VK_MEMORY_HEAP_MULTI_INSTANCE_BIT_KHR = 2,
        VK_MEMORY_HEAP_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkMemoryPropertyFlagBits: uint32
{
        VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT = 1,
        VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT = 2,
        VK_MEMORY_PROPERTY_HOST_COHERENT_BIT = 4,
        VK_MEMORY_PROPERTY_HOST_CACHED_BIT = 8,
        VK_MEMORY_PROPERTY_LAZILY_ALLOCATED_BIT = 16,
        VK_MEMORY_PROPERTY_PROTECTED_BIT = 32,
        VK_MEMORY_PROPERTY_DEVICE_COHERENT_BIT_AMD = 64,
        VK_MEMORY_PROPERTY_DEVICE_UNCACHED_BIT_AMD = 128,
        VK_MEMORY_PROPERTY_RDMA_CAPABLE_BIT_NV = 256,
        VK_MEMORY_PROPERTY_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkQueueFlagBits: uint32
{
        VK_QUEUE_GRAPHICS_BIT = 1,
        VK_QUEUE_COMPUTE_BIT = 2,
        VK_QUEUE_TRANSFER_BIT = 4,
        VK_QUEUE_SPARSE_BINDING_BIT = 8,
        VK_QUEUE_PROTECTED_BIT = 16,
        VK_QUEUE_VIDEO_DECODE_BIT_KHR = 32,
        VK_QUEUE_VIDEO_ENCODE_BIT_KHR = 64,
        VK_QUEUE_OPTICAL_FLOW_BIT_NV = 256,
        VK_QUEUE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkDeviceQueueCreateFlagBits: uint32
{
        VK_DEVICE_QUEUE_CREATE_PROTECTED_BIT = 1,
        VK_DEVICE_QUEUE_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkPipelineStageFlagBits: uint32
{
        VK_PIPELINE_STAGE_TOP_OF_PIPE_BIT = 1,
        VK_PIPELINE_STAGE_DRAW_INDIRECT_BIT = 2,
        VK_PIPELINE_STAGE_VERTEX_INPUT_BIT = 4,
        VK_PIPELINE_STAGE_VERTEX_SHADER_BIT = 8,
        VK_PIPELINE_STAGE_TESSELLATION_CONTROL_SHADER_BIT = 16,
        VK_PIPELINE_STAGE_TESSELLATION_EVALUATION_SHADER_BIT = 32,
        VK_PIPELINE_STAGE_GEOMETRY_SHADER_BIT = 64,
        VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT = 128,
        VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT = 256,
        VK_PIPELINE_STAGE_LATE_FRAGMENT_TESTS_BIT = 512,
        VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT = 1024,
        VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT = 2048,
        VK_PIPELINE_STAGE_TRANSFER_BIT = 4096,
        VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT = 8192,
        VK_PIPELINE_STAGE_HOST_BIT = 16384,
        VK_PIPELINE_STAGE_ALL_GRAPHICS_BIT = 32768,
        VK_PIPELINE_STAGE_ALL_COMMANDS_BIT = 65536,
        VK_PIPELINE_STAGE_NONE = 0,
        VK_PIPELINE_STAGE_TRANSFORM_FEEDBACK_BIT_EXT = 16777216,
        VK_PIPELINE_STAGE_CONDITIONAL_RENDERING_BIT_EXT = 262144,
        VK_PIPELINE_STAGE_ACCELERATION_STRUCTURE_BUILD_BIT_KHR = 33554432,
        VK_PIPELINE_STAGE_RAY_TRACING_SHADER_BIT_KHR = 2097152,
        VK_PIPELINE_STAGE_FRAGMENT_DENSITY_PROCESS_BIT_EXT = 8388608,
        VK_PIPELINE_STAGE_FRAGMENT_SHADING_RATE_ATTACHMENT_BIT_KHR = 4194304,
        VK_PIPELINE_STAGE_COMMAND_PREPROCESS_BIT_NV = 131072,
        VK_PIPELINE_STAGE_TASK_SHADER_BIT_EXT = 524288,
        VK_PIPELINE_STAGE_MESH_SHADER_BIT_EXT = 1048576,
        VK_PIPELINE_STAGE_SHADING_RATE_IMAGE_BIT_NV = 4194304,
        VK_PIPELINE_STAGE_RAY_TRACING_SHADER_BIT_NV = 2097152,
        VK_PIPELINE_STAGE_ACCELERATION_STRUCTURE_BUILD_BIT_NV = 33554432,
        VK_PIPELINE_STAGE_TASK_SHADER_BIT_NV = 524288,
        VK_PIPELINE_STAGE_MESH_SHADER_BIT_NV = 1048576,
        VK_PIPELINE_STAGE_NONE_KHR = 0,
        VK_PIPELINE_STAGE_COMMAND_PREPROCESS_BIT_EXT = 131072,
        VK_PIPELINE_STAGE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkMemoryMapFlagBits: uint32
{
        VK_MEMORY_MAP_PLACED_BIT_EXT = 1,
        VK_MEMORY_MAP_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkSparseMemoryBindFlagBits: uint32
{
        VK_SPARSE_MEMORY_BIND_METADATA_BIT = 1,
        VK_SPARSE_MEMORY_BIND_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkSparseImageFormatFlagBits: uint32
{
        VK_SPARSE_IMAGE_FORMAT_SINGLE_MIPTAIL_BIT = 1,
        VK_SPARSE_IMAGE_FORMAT_ALIGNED_MIP_SIZE_BIT = 2,
        VK_SPARSE_IMAGE_FORMAT_NONSTANDARD_BLOCK_SIZE_BIT = 4,
        VK_SPARSE_IMAGE_FORMAT_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkFenceCreateFlagBits: uint32
{
        VK_FENCE_CREATE_SIGNALED_BIT = 1,
        VK_FENCE_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkEventCreateFlagBits: uint32
{
        VK_EVENT_CREATE_DEVICE_ONLY_BIT = 1,
        VK_EVENT_CREATE_DEVICE_ONLY_BIT_KHR = 1,
        VK_EVENT_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkQueryPipelineStatisticFlagBits: uint32
{
        VK_QUERY_PIPELINE_STATISTIC_INPUT_ASSEMBLY_VERTICES_BIT = 1,
        VK_QUERY_PIPELINE_STATISTIC_INPUT_ASSEMBLY_PRIMITIVES_BIT = 2,
        VK_QUERY_PIPELINE_STATISTIC_VERTEX_SHADER_INVOCATIONS_BIT = 4,
        VK_QUERY_PIPELINE_STATISTIC_GEOMETRY_SHADER_INVOCATIONS_BIT = 8,
        VK_QUERY_PIPELINE_STATISTIC_GEOMETRY_SHADER_PRIMITIVES_BIT = 16,
        VK_QUERY_PIPELINE_STATISTIC_CLIPPING_INVOCATIONS_BIT = 32,
        VK_QUERY_PIPELINE_STATISTIC_CLIPPING_PRIMITIVES_BIT = 64,
        VK_QUERY_PIPELINE_STATISTIC_FRAGMENT_SHADER_INVOCATIONS_BIT = 128,
        VK_QUERY_PIPELINE_STATISTIC_TESSELLATION_CONTROL_SHADER_PATCHES_BIT = 256,
        VK_QUERY_PIPELINE_STATISTIC_TESSELLATION_EVALUATION_SHADER_INVOCATIONS_BIT = 512,
        VK_QUERY_PIPELINE_STATISTIC_COMPUTE_SHADER_INVOCATIONS_BIT = 1024,
        VK_QUERY_PIPELINE_STATISTIC_TASK_SHADER_INVOCATIONS_BIT_EXT = 2048,
        VK_QUERY_PIPELINE_STATISTIC_MESH_SHADER_INVOCATIONS_BIT_EXT = 4096,
        VK_QUERY_PIPELINE_STATISTIC_CLUSTER_CULLING_SHADER_INVOCATIONS_BIT_HUAWEI = 8192,
        VK_QUERY_PIPELINE_STATISTIC_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkQueryResultFlagBits: uint32
{
        VK_QUERY_RESULT_64_BIT = 1,
        VK_QUERY_RESULT_WAIT_BIT = 2,
        VK_QUERY_RESULT_WITH_AVAILABILITY_BIT = 4,
        VK_QUERY_RESULT_PARTIAL_BIT = 8,
        VK_QUERY_RESULT_WITH_STATUS_BIT_KHR = 16,
        VK_QUERY_RESULT_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkBufferCreateFlagBits: uint32
{
        VK_BUFFER_CREATE_SPARSE_BINDING_BIT = 1,
        VK_BUFFER_CREATE_SPARSE_RESIDENCY_BIT = 2,
        VK_BUFFER_CREATE_SPARSE_ALIASED_BIT = 4,
        VK_BUFFER_CREATE_PROTECTED_BIT = 8,
        VK_BUFFER_CREATE_DEVICE_ADDRESS_CAPTURE_REPLAY_BIT = 16,
        VK_BUFFER_CREATE_DESCRIPTOR_BUFFER_CAPTURE_REPLAY_BIT_EXT = 32,
        VK_BUFFER_CREATE_VIDEO_PROFILE_INDEPENDENT_BIT_KHR = 64,
        VK_BUFFER_CREATE_DEVICE_ADDRESS_CAPTURE_REPLAY_BIT_EXT = 16,
        VK_BUFFER_CREATE_DEVICE_ADDRESS_CAPTURE_REPLAY_BIT_KHR = 16,
        VK_BUFFER_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkBufferUsageFlagBits: uint32
{
        VK_BUFFER_USAGE_TRANSFER_SRC_BIT = 1,
        VK_BUFFER_USAGE_TRANSFER_DST_BIT = 2,
        VK_BUFFER_USAGE_UNIFORM_TEXEL_BUFFER_BIT = 4,
        VK_BUFFER_USAGE_STORAGE_TEXEL_BUFFER_BIT = 8,
        VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT = 16,
        VK_BUFFER_USAGE_STORAGE_BUFFER_BIT = 32,
        VK_BUFFER_USAGE_INDEX_BUFFER_BIT = 64,
        VK_BUFFER_USAGE_VERTEX_BUFFER_BIT = 128,
        VK_BUFFER_USAGE_INDIRECT_BUFFER_BIT = 256,
        VK_BUFFER_USAGE_SHADER_DEVICE_ADDRESS_BIT = 131072,
        VK_BUFFER_USAGE_VIDEO_DECODE_SRC_BIT_KHR = 8192,
        VK_BUFFER_USAGE_VIDEO_DECODE_DST_BIT_KHR = 16384,
        VK_BUFFER_USAGE_TRANSFORM_FEEDBACK_BUFFER_BIT_EXT = 2048,
        VK_BUFFER_USAGE_TRANSFORM_FEEDBACK_COUNTER_BUFFER_BIT_EXT = 4096,
        VK_BUFFER_USAGE_CONDITIONAL_RENDERING_BIT_EXT = 512,
        VK_BUFFER_USAGE_ACCELERATION_STRUCTURE_BUILD_INPUT_READ_ONLY_BIT_KHR = 524288,
        VK_BUFFER_USAGE_ACCELERATION_STRUCTURE_STORAGE_BIT_KHR = 1048576,
        VK_BUFFER_USAGE_SHADER_BINDING_TABLE_BIT_KHR = 1024,
        VK_BUFFER_USAGE_VIDEO_ENCODE_DST_BIT_KHR = 32768,
        VK_BUFFER_USAGE_VIDEO_ENCODE_SRC_BIT_KHR = 65536,
        VK_BUFFER_USAGE_SAMPLER_DESCRIPTOR_BUFFER_BIT_EXT = 2097152,
        VK_BUFFER_USAGE_RESOURCE_DESCRIPTOR_BUFFER_BIT_EXT = 4194304,
        VK_BUFFER_USAGE_PUSH_DESCRIPTORS_DESCRIPTOR_BUFFER_BIT_EXT = 67108864,
        VK_BUFFER_USAGE_MICROMAP_BUILD_INPUT_READ_ONLY_BIT_EXT = 8388608,
        VK_BUFFER_USAGE_MICROMAP_STORAGE_BIT_EXT = 16777216,
        VK_BUFFER_USAGE_RAY_TRACING_BIT_NV = 1024,
        VK_BUFFER_USAGE_SHADER_DEVICE_ADDRESS_BIT_EXT = 131072,
        VK_BUFFER_USAGE_SHADER_DEVICE_ADDRESS_BIT_KHR = 131072,
        VK_BUFFER_USAGE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkImageViewCreateFlagBits: uint32
{
        VK_IMAGE_VIEW_CREATE_FRAGMENT_DENSITY_MAP_DYNAMIC_BIT_EXT = 1,
        VK_IMAGE_VIEW_CREATE_DESCRIPTOR_BUFFER_CAPTURE_REPLAY_BIT_EXT = 4,
        VK_IMAGE_VIEW_CREATE_FRAGMENT_DENSITY_MAP_DEFERRED_BIT_EXT = 2,
        VK_IMAGE_VIEW_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkPipelineCacheCreateFlagBits: uint32
{
        VK_PIPELINE_CACHE_CREATE_EXTERNALLY_SYNCHRONIZED_BIT = 1,
        VK_PIPELINE_CACHE_CREATE_INTERNALLY_SYNCHRONIZED_MERGE_BIT_KHR = 8,
        VK_PIPELINE_CACHE_CREATE_EXTERNALLY_SYNCHRONIZED_BIT_EXT = 1,
        VK_PIPELINE_CACHE_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkColorComponentFlagBits: uint32
{
        VK_COLOR_COMPONENT_R_BIT = 1,
        VK_COLOR_COMPONENT_G_BIT = 2,
        VK_COLOR_COMPONENT_B_BIT = 4,
        VK_COLOR_COMPONENT_A_BIT = 8,
        VK_COLOR_COMPONENT_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkPipelineCreateFlagBits: uint32
{
        VK_PIPELINE_CREATE_DISABLE_OPTIMIZATION_BIT = 1,
        VK_PIPELINE_CREATE_ALLOW_DERIVATIVES_BIT = 2,
        VK_PIPELINE_CREATE_DERIVATIVE_BIT = 4,
        VK_PIPELINE_CREATE_VIEW_INDEX_FROM_DEVICE_INDEX_BIT = 8,
        VK_PIPELINE_CREATE_DISPATCH_BASE_BIT = 16,
        VK_PIPELINE_CREATE_FAIL_ON_PIPELINE_COMPILE_REQUIRED_BIT = 256,
        VK_PIPELINE_CREATE_EARLY_RETURN_ON_FAILURE_BIT = 512,
        VK_PIPELINE_CREATE_NO_PROTECTED_ACCESS_BIT = 134217728,
        VK_PIPELINE_CREATE_PROTECTED_ACCESS_ONLY_BIT = 1073741824,
        VK_PIPELINE_CREATE_RAY_TRACING_NO_NULL_ANY_HIT_SHADERS_BIT_KHR = 16384,
        VK_PIPELINE_CREATE_RAY_TRACING_NO_NULL_CLOSEST_HIT_SHADERS_BIT_KHR = 32768,
        VK_PIPELINE_CREATE_RAY_TRACING_NO_NULL_MISS_SHADERS_BIT_KHR = 65536,
        VK_PIPELINE_CREATE_RAY_TRACING_NO_NULL_INTERSECTION_SHADERS_BIT_KHR = 131072,
        VK_PIPELINE_CREATE_RAY_TRACING_SKIP_TRIANGLES_BIT_KHR = 4096,
        VK_PIPELINE_CREATE_RAY_TRACING_SKIP_AABBS_BIT_KHR = 8192,
        VK_PIPELINE_CREATE_RAY_TRACING_SHADER_GROUP_HANDLE_CAPTURE_REPLAY_BIT_KHR = 524288,
        VK_PIPELINE_CREATE_DEFER_COMPILE_BIT_NV = 32,
        VK_PIPELINE_CREATE_RENDERING_FRAGMENT_DENSITY_MAP_ATTACHMENT_BIT_EXT = 4194304,
        VK_PIPELINE_CREATE_RENDERING_FRAGMENT_SHADING_RATE_ATTACHMENT_BIT_KHR = 2097152,
        VK_PIPELINE_CREATE_CAPTURE_STATISTICS_BIT_KHR = 64,
        VK_PIPELINE_CREATE_CAPTURE_INTERNAL_REPRESENTATIONS_BIT_KHR = 128,
        VK_PIPELINE_CREATE_INDIRECT_BINDABLE_BIT_NV = 262144,
        VK_PIPELINE_CREATE_LIBRARY_BIT_KHR = 2048,
        VK_PIPELINE_CREATE_DESCRIPTOR_BUFFER_BIT_EXT = 536870912,
        VK_PIPELINE_CREATE_RETAIN_LINK_TIME_OPTIMIZATION_INFO_BIT_EXT = 8388608,
        VK_PIPELINE_CREATE_LINK_TIME_OPTIMIZATION_BIT_EXT = 1024,
        VK_PIPELINE_CREATE_RAY_TRACING_ALLOW_MOTION_BIT_NV = 1048576,
        VK_PIPELINE_CREATE_COLOR_ATTACHMENT_FEEDBACK_LOOP_BIT_EXT = 33554432,
        VK_PIPELINE_CREATE_DEPTH_STENCIL_ATTACHMENT_FEEDBACK_LOOP_BIT_EXT = 67108864,
        VK_PIPELINE_CREATE_RAY_TRACING_OPACITY_MICROMAP_BIT_EXT = 16777216,
        VK_PIPELINE_CREATE_DISPATCH_BASE = 16,
        VK_PIPELINE_CREATE_VIEW_INDEX_FROM_DEVICE_INDEX_BIT_KHR = 8,
        VK_PIPELINE_CREATE_DISPATCH_BASE_KHR = 16,
        VK_PIPELINE_RASTERIZATION_STATE_CREATE_FRAGMENT_DENSITY_MAP_ATTACHMENT_BIT_EXT = 4194304,
        VK_PIPELINE_RASTERIZATION_STATE_CREATE_FRAGMENT_SHADING_RATE_ATTACHMENT_BIT_KHR = 2097152,
        VK_PIPELINE_CREATE_FAIL_ON_PIPELINE_COMPILE_REQUIRED_BIT_EXT = 256,
        VK_PIPELINE_CREATE_EARLY_RETURN_ON_FAILURE_BIT_EXT = 512,
        VK_PIPELINE_CREATE_NO_PROTECTED_ACCESS_BIT_EXT = 134217728,
        VK_PIPELINE_CREATE_PROTECTED_ACCESS_ONLY_BIT_EXT = 1073741824,
        VK_PIPELINE_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkPipelineShaderStageCreateFlagBits: uint32
{
        VK_PIPELINE_SHADER_STAGE_CREATE_ALLOW_VARYING_SUBGROUP_SIZE_BIT = 1,
        VK_PIPELINE_SHADER_STAGE_CREATE_REQUIRE_FULL_SUBGROUPS_BIT = 2,
        VK_PIPELINE_SHADER_STAGE_CREATE_ALLOW_VARYING_SUBGROUP_SIZE_BIT_EXT = 1,
        VK_PIPELINE_SHADER_STAGE_CREATE_REQUIRE_FULL_SUBGROUPS_BIT_EXT = 2,
        VK_PIPELINE_SHADER_STAGE_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkShaderStageFlagBits: uint32
{
        VK_SHADER_STAGE_VERTEX_BIT = 1,
        VK_SHADER_STAGE_TESSELLATION_CONTROL_BIT = 2,
        VK_SHADER_STAGE_TESSELLATION_EVALUATION_BIT = 4,
        VK_SHADER_STAGE_GEOMETRY_BIT = 8,
        VK_SHADER_STAGE_FRAGMENT_BIT = 16,
        VK_SHADER_STAGE_COMPUTE_BIT = 32,
        VK_SHADER_STAGE_ALL_GRAPHICS = 31,
        VK_SHADER_STAGE_ALL = 2147483647,
        VK_SHADER_STAGE_RAYGEN_BIT_KHR = 256,
        VK_SHADER_STAGE_ANY_HIT_BIT_KHR = 512,
        VK_SHADER_STAGE_CLOSEST_HIT_BIT_KHR = 1024,
        VK_SHADER_STAGE_MISS_BIT_KHR = 2048,
        VK_SHADER_STAGE_INTERSECTION_BIT_KHR = 4096,
        VK_SHADER_STAGE_CALLABLE_BIT_KHR = 8192,
        VK_SHADER_STAGE_TASK_BIT_EXT = 64,
        VK_SHADER_STAGE_MESH_BIT_EXT = 128,
        VK_SHADER_STAGE_SUBPASS_SHADING_BIT_HUAWEI = 16384,
        VK_SHADER_STAGE_CLUSTER_CULLING_BIT_HUAWEI = 524288,
        VK_SHADER_STAGE_RAYGEN_BIT_NV = 256,
        VK_SHADER_STAGE_ANY_HIT_BIT_NV = 512,
        VK_SHADER_STAGE_CLOSEST_HIT_BIT_NV = 1024,
        VK_SHADER_STAGE_MISS_BIT_NV = 2048,
        VK_SHADER_STAGE_INTERSECTION_BIT_NV = 4096,
        VK_SHADER_STAGE_CALLABLE_BIT_NV = 8192,
        VK_SHADER_STAGE_TASK_BIT_NV = 64,
        VK_SHADER_STAGE_MESH_BIT_NV = 128,
        VK_SHADER_STAGE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkCullModeFlagBits: uint32
{
        VK_CULL_MODE_NONE = 0,
        VK_CULL_MODE_FRONT_BIT = 1,
        VK_CULL_MODE_BACK_BIT = 2,
        VK_CULL_MODE_FRONT_AND_BACK = 3,
        VK_CULL_MODE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkPipelineDepthStencilStateCreateFlagBits: uint32
{
        VK_PIPELINE_DEPTH_STENCIL_STATE_CREATE_RASTERIZATION_ORDER_ATTACHMENT_DEPTH_ACCESS_BIT_EXT = 1,
        VK_PIPELINE_DEPTH_STENCIL_STATE_CREATE_RASTERIZATION_ORDER_ATTACHMENT_STENCIL_ACCESS_BIT_EXT = 2,
        VK_PIPELINE_DEPTH_STENCIL_STATE_CREATE_RASTERIZATION_ORDER_ATTACHMENT_DEPTH_ACCESS_BIT_ARM = 1,
        VK_PIPELINE_DEPTH_STENCIL_STATE_CREATE_RASTERIZATION_ORDER_ATTACHMENT_STENCIL_ACCESS_BIT_ARM = 2,
        VK_PIPELINE_DEPTH_STENCIL_STATE_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkPipelineColorBlendStateCreateFlagBits: uint32
{
        VK_PIPELINE_COLOR_BLEND_STATE_CREATE_RASTERIZATION_ORDER_ATTACHMENT_ACCESS_BIT_EXT = 1,
        VK_PIPELINE_COLOR_BLEND_STATE_CREATE_RASTERIZATION_ORDER_ATTACHMENT_ACCESS_BIT_ARM = 1,
        VK_PIPELINE_COLOR_BLEND_STATE_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkPipelineLayoutCreateFlagBits: uint32
{
        VK_PIPELINE_LAYOUT_CREATE_INDEPENDENT_SETS_BIT_EXT = 2,
        VK_PIPELINE_LAYOUT_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkSamplerCreateFlagBits: uint32
{
        VK_SAMPLER_CREATE_SUBSAMPLED_BIT_EXT = 1,
        VK_SAMPLER_CREATE_SUBSAMPLED_COARSE_RECONSTRUCTION_BIT_EXT = 2,
        VK_SAMPLER_CREATE_DESCRIPTOR_BUFFER_CAPTURE_REPLAY_BIT_EXT = 8,
        VK_SAMPLER_CREATE_NON_SEAMLESS_CUBE_MAP_BIT_EXT = 4,
        VK_SAMPLER_CREATE_IMAGE_PROCESSING_BIT_QCOM = 16,
        VK_SAMPLER_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkDescriptorPoolCreateFlagBits: uint32
{
        VK_DESCRIPTOR_POOL_CREATE_FREE_DESCRIPTOR_SET_BIT = 1,
        VK_DESCRIPTOR_POOL_CREATE_UPDATE_AFTER_BIND_BIT = 2,
        VK_DESCRIPTOR_POOL_CREATE_HOST_ONLY_BIT_EXT = 4,
        VK_DESCRIPTOR_POOL_CREATE_ALLOW_OVERALLOCATION_SETS_BIT_NV = 8,
        VK_DESCRIPTOR_POOL_CREATE_ALLOW_OVERALLOCATION_POOLS_BIT_NV = 16,
        VK_DESCRIPTOR_POOL_CREATE_UPDATE_AFTER_BIND_BIT_EXT = 2,
        VK_DESCRIPTOR_POOL_CREATE_HOST_ONLY_BIT_VALVE = 4,
        VK_DESCRIPTOR_POOL_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkDescriptorSetLayoutCreateFlagBits: uint32
{
        VK_DESCRIPTOR_SET_LAYOUT_CREATE_UPDATE_AFTER_BIND_POOL_BIT = 2,
        VK_DESCRIPTOR_SET_LAYOUT_CREATE_PUSH_DESCRIPTOR_BIT = 1,
        VK_DESCRIPTOR_SET_LAYOUT_CREATE_DESCRIPTOR_BUFFER_BIT_EXT = 16,
        VK_DESCRIPTOR_SET_LAYOUT_CREATE_EMBEDDED_IMMUTABLE_SAMPLERS_BIT_EXT = 32,
        VK_DESCRIPTOR_SET_LAYOUT_CREATE_INDIRECT_BINDABLE_BIT_NV = 128,
        VK_DESCRIPTOR_SET_LAYOUT_CREATE_HOST_ONLY_POOL_BIT_EXT = 4,
        VK_DESCRIPTOR_SET_LAYOUT_CREATE_PER_STAGE_BIT_NV = 64,
        VK_DESCRIPTOR_SET_LAYOUT_CREATE_PUSH_DESCRIPTOR_BIT_KHR = 1,
        VK_DESCRIPTOR_SET_LAYOUT_CREATE_UPDATE_AFTER_BIND_POOL_BIT_EXT = 2,
        VK_DESCRIPTOR_SET_LAYOUT_CREATE_HOST_ONLY_POOL_BIT_VALVE = 4,
        VK_DESCRIPTOR_SET_LAYOUT_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkAttachmentDescriptionFlagBits: uint32
{
        VK_ATTACHMENT_DESCRIPTION_MAY_ALIAS_BIT = 1,
        VK_ATTACHMENT_DESCRIPTION_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkDependencyFlagBits: uint32
{
        VK_DEPENDENCY_BY_REGION_BIT = 1,
        VK_DEPENDENCY_DEVICE_GROUP_BIT = 4,
        VK_DEPENDENCY_VIEW_LOCAL_BIT = 2,
        VK_DEPENDENCY_FEEDBACK_LOOP_BIT_EXT = 8,
        VK_DEPENDENCY_QUEUE_FAMILY_OWNERSHIP_TRANSFER_USE_ALL_STAGES_BIT_KHR = 32,
        VK_DEPENDENCY_VIEW_LOCAL_BIT_KHR = 2,
        VK_DEPENDENCY_DEVICE_GROUP_BIT_KHR = 4,
        VK_DEPENDENCY_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkFramebufferCreateFlagBits: uint32
{
        VK_FRAMEBUFFER_CREATE_IMAGELESS_BIT = 1,
        VK_FRAMEBUFFER_CREATE_IMAGELESS_BIT_KHR = 1,
        VK_FRAMEBUFFER_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkRenderPassCreateFlagBits: uint32
{
        VK_RENDER_PASS_CREATE_TRANSFORM_BIT_QCOM = 2,
        VK_RENDER_PASS_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkSubpassDescriptionFlagBits: uint32
{
        VK_SUBPASS_DESCRIPTION_PER_VIEW_ATTRIBUTES_BIT_NVX = 1,
        VK_SUBPASS_DESCRIPTION_PER_VIEW_POSITION_X_ONLY_BIT_NVX = 2,
        VK_SUBPASS_DESCRIPTION_FRAGMENT_REGION_BIT_QCOM = 4,
        VK_SUBPASS_DESCRIPTION_SHADER_RESOLVE_BIT_QCOM = 8,
        VK_SUBPASS_DESCRIPTION_RASTERIZATION_ORDER_ATTACHMENT_COLOR_ACCESS_BIT_EXT = 16,
        VK_SUBPASS_DESCRIPTION_RASTERIZATION_ORDER_ATTACHMENT_DEPTH_ACCESS_BIT_EXT = 32,
        VK_SUBPASS_DESCRIPTION_RASTERIZATION_ORDER_ATTACHMENT_STENCIL_ACCESS_BIT_EXT = 64,
        VK_SUBPASS_DESCRIPTION_ENABLE_LEGACY_DITHERING_BIT_EXT = 128,
        VK_SUBPASS_DESCRIPTION_RASTERIZATION_ORDER_ATTACHMENT_COLOR_ACCESS_BIT_ARM = 16,
        VK_SUBPASS_DESCRIPTION_RASTERIZATION_ORDER_ATTACHMENT_DEPTH_ACCESS_BIT_ARM = 32,
        VK_SUBPASS_DESCRIPTION_RASTERIZATION_ORDER_ATTACHMENT_STENCIL_ACCESS_BIT_ARM = 64,
        VK_SUBPASS_DESCRIPTION_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkCommandPoolCreateFlagBits: uint32
{
        VK_COMMAND_POOL_CREATE_TRANSIENT_BIT = 1,
        VK_COMMAND_POOL_CREATE_RESET_COMMAND_BUFFER_BIT = 2,
        VK_COMMAND_POOL_CREATE_PROTECTED_BIT = 4,
        VK_COMMAND_POOL_CREATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkCommandPoolResetFlagBits: uint32
{
        VK_COMMAND_POOL_RESET_RELEASE_RESOURCES_BIT = 1,
        VK_COMMAND_POOL_RESET_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkCommandBufferUsageFlagBits: uint32
{
        VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT = 1,
        VK_COMMAND_BUFFER_USAGE_RENDER_PASS_CONTINUE_BIT = 2,
        VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT = 4,
        VK_COMMAND_BUFFER_USAGE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkQueryControlFlagBits: uint32
{
        VK_QUERY_CONTROL_PRECISE_BIT = 1,
        VK_QUERY_CONTROL_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkCommandBufferResetFlagBits: uint32
{
        VK_COMMAND_BUFFER_RESET_RELEASE_RESOURCES_BIT = 1,
        VK_COMMAND_BUFFER_RESET_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkStencilFaceFlagBits: uint32
{
        VK_STENCIL_FACE_FRONT_BIT = 1,
        VK_STENCIL_FACE_BACK_BIT = 2,
        VK_STENCIL_FACE_FRONT_AND_BACK = 3,
        VK_STENCIL_FRONT_AND_BACK = 3,
        VK_STENCIL_FACE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkPointClippingBehavior: uint32
{
        VK_POINT_CLIPPING_BEHAVIOR_ALL_CLIP_PLANES = 0,
        VK_POINT_CLIPPING_BEHAVIOR_USER_CLIP_PLANES_ONLY = 1,
        VK_POINT_CLIPPING_BEHAVIOR_ALL_CLIP_PLANES_KHR = 0,
        VK_POINT_CLIPPING_BEHAVIOR_USER_CLIP_PLANES_ONLY_KHR = 1,
        VK_POINT_CLIPPING_BEHAVIOR_MAX_ENUM = 2147483647
}

enum VkTessellationDomainOrigin: uint32
{
        VK_TESSELLATION_DOMAIN_ORIGIN_UPPER_LEFT = 0,
        VK_TESSELLATION_DOMAIN_ORIGIN_LOWER_LEFT = 1,
        VK_TESSELLATION_DOMAIN_ORIGIN_UPPER_LEFT_KHR = 0,
        VK_TESSELLATION_DOMAIN_ORIGIN_LOWER_LEFT_KHR = 1,
        VK_TESSELLATION_DOMAIN_ORIGIN_MAX_ENUM = 2147483647
}

enum VkSamplerYcbcrModelConversion: uint32
{
        VK_SAMPLER_YCBCR_MODEL_CONVERSION_RGB_IDENTITY = 0,
        VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_IDENTITY = 1,
        VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_709 = 2,
        VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_601 = 3,
        VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_2020 = 4,
        VK_SAMPLER_YCBCR_MODEL_CONVERSION_RGB_IDENTITY_KHR = 0,
        VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_IDENTITY_KHR = 1,
        VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_709_KHR = 2,
        VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_601_KHR = 3,
        VK_SAMPLER_YCBCR_MODEL_CONVERSION_YCBCR_2020_KHR = 4,
        VK_SAMPLER_YCBCR_MODEL_CONVERSION_MAX_ENUM = 2147483647
}

enum VkSamplerYcbcrRange: uint32
{
        VK_SAMPLER_YCBCR_RANGE_ITU_FULL = 0,
        VK_SAMPLER_YCBCR_RANGE_ITU_NARROW = 1,
        VK_SAMPLER_YCBCR_RANGE_ITU_FULL_KHR = 0,
        VK_SAMPLER_YCBCR_RANGE_ITU_NARROW_KHR = 1,
        VK_SAMPLER_YCBCR_RANGE_MAX_ENUM = 2147483647
}

enum VkChromaLocation: uint32
{
        VK_CHROMA_LOCATION_COSITED_EVEN = 0,
        VK_CHROMA_LOCATION_MIDPOINT = 1,
        VK_CHROMA_LOCATION_COSITED_EVEN_KHR = 0,
        VK_CHROMA_LOCATION_MIDPOINT_KHR = 1,
        VK_CHROMA_LOCATION_MAX_ENUM = 2147483647
}

enum VkDescriptorUpdateTemplateType: uint32
{
        VK_DESCRIPTOR_UPDATE_TEMPLATE_TYPE_DESCRIPTOR_SET = 0,
        VK_DESCRIPTOR_UPDATE_TEMPLATE_TYPE_PUSH_DESCRIPTORS = 1,
        VK_DESCRIPTOR_UPDATE_TEMPLATE_TYPE_PUSH_DESCRIPTORS_KHR = 1,
        VK_DESCRIPTOR_UPDATE_TEMPLATE_TYPE_DESCRIPTOR_SET_KHR = 0,
        VK_DESCRIPTOR_UPDATE_TEMPLATE_TYPE_MAX_ENUM = 2147483647
}

enum VkSubgroupFeatureFlagBits: uint32
{
        VK_SUBGROUP_FEATURE_BASIC_BIT = 1,
        VK_SUBGROUP_FEATURE_VOTE_BIT = 2,
        VK_SUBGROUP_FEATURE_ARITHMETIC_BIT = 4,
        VK_SUBGROUP_FEATURE_BALLOT_BIT = 8,
        VK_SUBGROUP_FEATURE_SHUFFLE_BIT = 16,
        VK_SUBGROUP_FEATURE_SHUFFLE_RELATIVE_BIT = 32,
        VK_SUBGROUP_FEATURE_CLUSTERED_BIT = 64,
        VK_SUBGROUP_FEATURE_QUAD_BIT = 128,
        VK_SUBGROUP_FEATURE_ROTATE_BIT = 512,
        VK_SUBGROUP_FEATURE_ROTATE_CLUSTERED_BIT = 1024,
        VK_SUBGROUP_FEATURE_PARTITIONED_BIT_NV = 256,
        VK_SUBGROUP_FEATURE_ROTATE_BIT_KHR = 512,
        VK_SUBGROUP_FEATURE_ROTATE_CLUSTERED_BIT_KHR = 1024,
        VK_SUBGROUP_FEATURE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkPeerMemoryFeatureFlagBits: uint32
{
        VK_PEER_MEMORY_FEATURE_COPY_SRC_BIT = 1,
        VK_PEER_MEMORY_FEATURE_COPY_DST_BIT = 2,
        VK_PEER_MEMORY_FEATURE_GENERIC_SRC_BIT = 4,
        VK_PEER_MEMORY_FEATURE_GENERIC_DST_BIT = 8,
        VK_PEER_MEMORY_FEATURE_COPY_SRC_BIT_KHR = 1,
        VK_PEER_MEMORY_FEATURE_COPY_DST_BIT_KHR = 2,
        VK_PEER_MEMORY_FEATURE_GENERIC_SRC_BIT_KHR = 4,
        VK_PEER_MEMORY_FEATURE_GENERIC_DST_BIT_KHR = 8,
        VK_PEER_MEMORY_FEATURE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkMemoryAllocateFlagBits: uint32
{
        VK_MEMORY_ALLOCATE_DEVICE_MASK_BIT = 1,
        VK_MEMORY_ALLOCATE_DEVICE_ADDRESS_BIT = 2,
        VK_MEMORY_ALLOCATE_DEVICE_ADDRESS_CAPTURE_REPLAY_BIT = 4,
        VK_MEMORY_ALLOCATE_DEVICE_MASK_BIT_KHR = 1,
        VK_MEMORY_ALLOCATE_DEVICE_ADDRESS_BIT_KHR = 2,
        VK_MEMORY_ALLOCATE_DEVICE_ADDRESS_CAPTURE_REPLAY_BIT_KHR = 4,
        VK_MEMORY_ALLOCATE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkExternalMemoryHandleTypeFlagBits: uint32
{
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT = 1,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT = 2,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT = 4,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_BIT = 8,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_KMT_BIT = 16,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_HEAP_BIT = 32,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_RESOURCE_BIT = 64,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_DMA_BUF_BIT_EXT = 512,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_ANDROID_HARDWARE_BUFFER_BIT_ANDROID = 1024,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_HOST_ALLOCATION_BIT_EXT = 128,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_HOST_MAPPED_FOREIGN_MEMORY_BIT_EXT = 256,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_ZIRCON_VMO_BIT_FUCHSIA = 2048,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_RDMA_ADDRESS_BIT_NV = 4096,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_SCREEN_BUFFER_BIT_QNX = 16384,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_MTLBUFFER_BIT_EXT = 65536,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_MTLTEXTURE_BIT_EXT = 131072,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_MTLHEAP_BIT_EXT = 262144,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_FD_BIT_KHR = 1,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR = 2,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT_KHR = 4,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_BIT_KHR = 8,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_TEXTURE_KMT_BIT_KHR = 16,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_HEAP_BIT_KHR = 32,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D12_RESOURCE_BIT_KHR = 64,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkExternalMemoryFeatureFlagBits: uint32
{
        VK_EXTERNAL_MEMORY_FEATURE_DEDICATED_ONLY_BIT = 1,
        VK_EXTERNAL_MEMORY_FEATURE_EXPORTABLE_BIT = 2,
        VK_EXTERNAL_MEMORY_FEATURE_IMPORTABLE_BIT = 4,
        VK_EXTERNAL_MEMORY_FEATURE_DEDICATED_ONLY_BIT_KHR = 1,
        VK_EXTERNAL_MEMORY_FEATURE_EXPORTABLE_BIT_KHR = 2,
        VK_EXTERNAL_MEMORY_FEATURE_IMPORTABLE_BIT_KHR = 4,
        VK_EXTERNAL_MEMORY_FEATURE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkExternalFenceHandleTypeFlagBits: uint32
{
        VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_FD_BIT = 1,
        VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_BIT = 2,
        VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT = 4,
        VK_EXTERNAL_FENCE_HANDLE_TYPE_SYNC_FD_BIT = 8,
        VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_FD_BIT_KHR = 1,
        VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR = 2,
        VK_EXTERNAL_FENCE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT_KHR = 4,
        VK_EXTERNAL_FENCE_HANDLE_TYPE_SYNC_FD_BIT_KHR = 8,
        VK_EXTERNAL_FENCE_HANDLE_TYPE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkExternalFenceFeatureFlagBits: uint32
{
        VK_EXTERNAL_FENCE_FEATURE_EXPORTABLE_BIT = 1,
        VK_EXTERNAL_FENCE_FEATURE_IMPORTABLE_BIT = 2,
        VK_EXTERNAL_FENCE_FEATURE_EXPORTABLE_BIT_KHR = 1,
        VK_EXTERNAL_FENCE_FEATURE_IMPORTABLE_BIT_KHR = 2,
        VK_EXTERNAL_FENCE_FEATURE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkFenceImportFlagBits: uint32
{
        VK_FENCE_IMPORT_TEMPORARY_BIT = 1,
        VK_FENCE_IMPORT_TEMPORARY_BIT_KHR = 1,
        VK_FENCE_IMPORT_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkSemaphoreImportFlagBits: uint32
{
        VK_SEMAPHORE_IMPORT_TEMPORARY_BIT = 1,
        VK_SEMAPHORE_IMPORT_TEMPORARY_BIT_KHR = 1,
        VK_SEMAPHORE_IMPORT_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkExternalSemaphoreHandleTypeFlagBits: uint32
{
        VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT = 1,
        VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT = 2,
        VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT = 4,
        VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_D3D12_FENCE_BIT = 8,
        VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_SYNC_FD_BIT = 16,
        VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_ZIRCON_EVENT_BIT_FUCHSIA = 128,
        VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_D3D11_FENCE_BIT = 8,
        VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_FD_BIT_KHR = 1,
        VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR = 2,
        VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT_KHR = 4,
        VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_D3D12_FENCE_BIT_KHR = 8,
        VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_SYNC_FD_BIT_KHR = 16,
        VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkExternalSemaphoreFeatureFlagBits: uint32
{
        VK_EXTERNAL_SEMAPHORE_FEATURE_EXPORTABLE_BIT = 1,
        VK_EXTERNAL_SEMAPHORE_FEATURE_IMPORTABLE_BIT = 2,
        VK_EXTERNAL_SEMAPHORE_FEATURE_EXPORTABLE_BIT_KHR = 1,
        VK_EXTERNAL_SEMAPHORE_FEATURE_IMPORTABLE_BIT_KHR = 2,
        VK_EXTERNAL_SEMAPHORE_FEATURE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkDriverId: uint32
{
        VK_DRIVER_ID_AMD_PROPRIETARY = 1,
        VK_DRIVER_ID_AMD_OPEN_SOURCE = 2,
        VK_DRIVER_ID_MESA_RADV = 3,
        VK_DRIVER_ID_NVIDIA_PROPRIETARY = 4,
        VK_DRIVER_ID_INTEL_PROPRIETARY_WINDOWS = 5,
        VK_DRIVER_ID_INTEL_OPEN_SOURCE_MESA = 6,
        VK_DRIVER_ID_IMAGINATION_PROPRIETARY = 7,
        VK_DRIVER_ID_QUALCOMM_PROPRIETARY = 8,
        VK_DRIVER_ID_ARM_PROPRIETARY = 9,
        VK_DRIVER_ID_GOOGLE_SWIFTSHADER = 10,
        VK_DRIVER_ID_GGP_PROPRIETARY = 11,
        VK_DRIVER_ID_BROADCOM_PROPRIETARY = 12,
        VK_DRIVER_ID_MESA_LLVMPIPE = 13,
        VK_DRIVER_ID_MOLTENVK = 14,
        VK_DRIVER_ID_COREAVI_PROPRIETARY = 15,
        VK_DRIVER_ID_JUICE_PROPRIETARY = 16,
        VK_DRIVER_ID_VERISILICON_PROPRIETARY = 17,
        VK_DRIVER_ID_MESA_TURNIP = 18,
        VK_DRIVER_ID_MESA_V3DV = 19,
        VK_DRIVER_ID_MESA_PANVK = 20,
        VK_DRIVER_ID_SAMSUNG_PROPRIETARY = 21,
        VK_DRIVER_ID_MESA_VENUS = 22,
        VK_DRIVER_ID_MESA_DOZEN = 23,
        VK_DRIVER_ID_MESA_NVK = 24,
        VK_DRIVER_ID_IMAGINATION_OPEN_SOURCE_MESA = 25,
        VK_DRIVER_ID_MESA_HONEYKRISP = 26,
        VK_DRIVER_ID_VULKAN_SC_EMULATION_ON_VULKAN = 27,
        VK_DRIVER_ID_AMD_PROPRIETARY_KHR = 1,
        VK_DRIVER_ID_AMD_OPEN_SOURCE_KHR = 2,
        VK_DRIVER_ID_MESA_RADV_KHR = 3,
        VK_DRIVER_ID_NVIDIA_PROPRIETARY_KHR = 4,
        VK_DRIVER_ID_INTEL_PROPRIETARY_WINDOWS_KHR = 5,
        VK_DRIVER_ID_INTEL_OPEN_SOURCE_MESA_KHR = 6,
        VK_DRIVER_ID_IMAGINATION_PROPRIETARY_KHR = 7,
        VK_DRIVER_ID_QUALCOMM_PROPRIETARY_KHR = 8,
        VK_DRIVER_ID_ARM_PROPRIETARY_KHR = 9,
        VK_DRIVER_ID_GOOGLE_SWIFTSHADER_KHR = 10,
        VK_DRIVER_ID_GGP_PROPRIETARY_KHR = 11,
        VK_DRIVER_ID_BROADCOM_PROPRIETARY_KHR = 12,
        VK_DRIVER_ID_MAX_ENUM = 2147483647
}

enum VkShaderFloatControlsIndependence: uint32
{
        VK_SHADER_FLOAT_CONTROLS_INDEPENDENCE_32_BIT_ONLY = 0,
        VK_SHADER_FLOAT_CONTROLS_INDEPENDENCE_ALL = 1,
        VK_SHADER_FLOAT_CONTROLS_INDEPENDENCE_NONE = 2,
        VK_SHADER_FLOAT_CONTROLS_INDEPENDENCE_32_BIT_ONLY_KHR = 0,
        VK_SHADER_FLOAT_CONTROLS_INDEPENDENCE_ALL_KHR = 1,
        VK_SHADER_FLOAT_CONTROLS_INDEPENDENCE_NONE_KHR = 2,
        VK_SHADER_FLOAT_CONTROLS_INDEPENDENCE_MAX_ENUM = 2147483647
}

enum VkSamplerReductionMode: uint32
{
        VK_SAMPLER_REDUCTION_MODE_WEIGHTED_AVERAGE = 0,
        VK_SAMPLER_REDUCTION_MODE_MIN = 1,
        VK_SAMPLER_REDUCTION_MODE_MAX = 2,
        VK_SAMPLER_REDUCTION_MODE_WEIGHTED_AVERAGE_RANGECLAMP_QCOM = 1000521000,
        VK_SAMPLER_REDUCTION_MODE_WEIGHTED_AVERAGE_EXT = 0,
        VK_SAMPLER_REDUCTION_MODE_MIN_EXT = 1,
        VK_SAMPLER_REDUCTION_MODE_MAX_EXT = 2,
        VK_SAMPLER_REDUCTION_MODE_MAX_ENUM = 2147483647
}

enum VkSemaphoreType: uint32
{
        VK_SEMAPHORE_TYPE_BINARY = 0,
        VK_SEMAPHORE_TYPE_TIMELINE = 1,
        VK_SEMAPHORE_TYPE_BINARY_KHR = 0,
        VK_SEMAPHORE_TYPE_TIMELINE_KHR = 1,
        VK_SEMAPHORE_TYPE_MAX_ENUM = 2147483647
}

enum VkResolveModeFlagBits: uint32
{
        VK_RESOLVE_MODE_NONE = 0,
        VK_RESOLVE_MODE_SAMPLE_ZERO_BIT = 1,
        VK_RESOLVE_MODE_AVERAGE_BIT = 2,
        VK_RESOLVE_MODE_MIN_BIT = 4,
        VK_RESOLVE_MODE_MAX_BIT = 8,
        VK_RESOLVE_MODE_EXTERNAL_FORMAT_DOWNSAMPLE_ANDROID = 16,
        VK_RESOLVE_MODE_NONE_KHR = 0,
        VK_RESOLVE_MODE_SAMPLE_ZERO_BIT_KHR = 1,
        VK_RESOLVE_MODE_AVERAGE_BIT_KHR = 2,
        VK_RESOLVE_MODE_MIN_BIT_KHR = 4,
        VK_RESOLVE_MODE_MAX_BIT_KHR = 8,
        VK_RESOLVE_MODE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkDescriptorBindingFlagBits: uint32
{
        VK_DESCRIPTOR_BINDING_UPDATE_AFTER_BIND_BIT = 1,
        VK_DESCRIPTOR_BINDING_UPDATE_UNUSED_WHILE_PENDING_BIT = 2,
        VK_DESCRIPTOR_BINDING_PARTIALLY_BOUND_BIT = 4,
        VK_DESCRIPTOR_BINDING_VARIABLE_DESCRIPTOR_COUNT_BIT = 8,
        VK_DESCRIPTOR_BINDING_UPDATE_AFTER_BIND_BIT_EXT = 1,
        VK_DESCRIPTOR_BINDING_UPDATE_UNUSED_WHILE_PENDING_BIT_EXT = 2,
        VK_DESCRIPTOR_BINDING_PARTIALLY_BOUND_BIT_EXT = 4,
        VK_DESCRIPTOR_BINDING_VARIABLE_DESCRIPTOR_COUNT_BIT_EXT = 8,
        VK_DESCRIPTOR_BINDING_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkSemaphoreWaitFlagBits: uint32
{
        VK_SEMAPHORE_WAIT_ANY_BIT = 1,
        VK_SEMAPHORE_WAIT_ANY_BIT_KHR = 1,
        VK_SEMAPHORE_WAIT_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkPipelineCreationFeedbackFlagBits: uint32
{
        VK_PIPELINE_CREATION_FEEDBACK_VALID_BIT = 1,
        VK_PIPELINE_CREATION_FEEDBACK_APPLICATION_PIPELINE_CACHE_HIT_BIT = 2,
        VK_PIPELINE_CREATION_FEEDBACK_BASE_PIPELINE_ACCELERATION_BIT = 4,
        VK_PIPELINE_CREATION_FEEDBACK_VALID_BIT_EXT = 1,
        VK_PIPELINE_CREATION_FEEDBACK_APPLICATION_PIPELINE_CACHE_HIT_BIT_EXT = 2,
        VK_PIPELINE_CREATION_FEEDBACK_BASE_PIPELINE_ACCELERATION_BIT_EXT = 4,
        VK_PIPELINE_CREATION_FEEDBACK_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkToolPurposeFlagBits: uint32
{
        VK_TOOL_PURPOSE_VALIDATION_BIT = 1,
        VK_TOOL_PURPOSE_PROFILING_BIT = 2,
        VK_TOOL_PURPOSE_TRACING_BIT = 4,
        VK_TOOL_PURPOSE_ADDITIONAL_FEATURES_BIT = 8,
        VK_TOOL_PURPOSE_MODIFYING_FEATURES_BIT = 16,
        VK_TOOL_PURPOSE_DEBUG_REPORTING_BIT_EXT = 32,
        VK_TOOL_PURPOSE_DEBUG_MARKERS_BIT_EXT = 64,
        VK_TOOL_PURPOSE_VALIDATION_BIT_EXT = 1,
        VK_TOOL_PURPOSE_PROFILING_BIT_EXT = 2,
        VK_TOOL_PURPOSE_TRACING_BIT_EXT = 4,
        VK_TOOL_PURPOSE_ADDITIONAL_FEATURES_BIT_EXT = 8,
        VK_TOOL_PURPOSE_MODIFYING_FEATURES_BIT_EXT = 16,
        VK_TOOL_PURPOSE_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkSubmitFlagBits: uint32
{
        VK_SUBMIT_PROTECTED_BIT = 1,
        VK_SUBMIT_PROTECTED_BIT_KHR = 1,
        VK_SUBMIT_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkRenderingFlagBits: uint32
{
        VK_RENDERING_CONTENTS_SECONDARY_COMMAND_BUFFERS_BIT = 1,
        VK_RENDERING_SUSPENDING_BIT = 2,
        VK_RENDERING_RESUMING_BIT = 4,
        VK_RENDERING_ENABLE_LEGACY_DITHERING_BIT_EXT = 8,
        VK_RENDERING_CONTENTS_INLINE_BIT_KHR = 16,
        VK_RENDERING_CONTENTS_SECONDARY_COMMAND_BUFFERS_BIT_KHR = 1,
        VK_RENDERING_SUSPENDING_BIT_KHR = 2,
        VK_RENDERING_RESUMING_BIT_KHR = 4,
        VK_RENDERING_CONTENTS_INLINE_BIT_EXT = 16,
        VK_RENDERING_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkPipelineRobustnessBufferBehavior: uint32
{
        VK_PIPELINE_ROBUSTNESS_BUFFER_BEHAVIOR_DEVICE_DEFAULT = 0,
        VK_PIPELINE_ROBUSTNESS_BUFFER_BEHAVIOR_DISABLED = 1,
        VK_PIPELINE_ROBUSTNESS_BUFFER_BEHAVIOR_ROBUST_BUFFER_ACCESS = 2,
        VK_PIPELINE_ROBUSTNESS_BUFFER_BEHAVIOR_ROBUST_BUFFER_ACCESS_2 = 3,
        VK_PIPELINE_ROBUSTNESS_BUFFER_BEHAVIOR_DEVICE_DEFAULT_EXT = 0,
        VK_PIPELINE_ROBUSTNESS_BUFFER_BEHAVIOR_DISABLED_EXT = 1,
        VK_PIPELINE_ROBUSTNESS_BUFFER_BEHAVIOR_ROBUST_BUFFER_ACCESS_EXT = 2,
        VK_PIPELINE_ROBUSTNESS_BUFFER_BEHAVIOR_ROBUST_BUFFER_ACCESS_2_EXT = 3,
        VK_PIPELINE_ROBUSTNESS_BUFFER_BEHAVIOR_MAX_ENUM = 2147483647
}

enum VkPipelineRobustnessImageBehavior: uint32
{
        VK_PIPELINE_ROBUSTNESS_IMAGE_BEHAVIOR_DEVICE_DEFAULT = 0,
        VK_PIPELINE_ROBUSTNESS_IMAGE_BEHAVIOR_DISABLED = 1,
        VK_PIPELINE_ROBUSTNESS_IMAGE_BEHAVIOR_ROBUST_IMAGE_ACCESS = 2,
        VK_PIPELINE_ROBUSTNESS_IMAGE_BEHAVIOR_ROBUST_IMAGE_ACCESS_2 = 3,
        VK_PIPELINE_ROBUSTNESS_IMAGE_BEHAVIOR_DEVICE_DEFAULT_EXT = 0,
        VK_PIPELINE_ROBUSTNESS_IMAGE_BEHAVIOR_DISABLED_EXT = 1,
        VK_PIPELINE_ROBUSTNESS_IMAGE_BEHAVIOR_ROBUST_IMAGE_ACCESS_EXT = 2,
        VK_PIPELINE_ROBUSTNESS_IMAGE_BEHAVIOR_ROBUST_IMAGE_ACCESS_2_EXT = 3,
        VK_PIPELINE_ROBUSTNESS_IMAGE_BEHAVIOR_MAX_ENUM = 2147483647
}

enum VkQueueGlobalPriority: uint32
{
        VK_QUEUE_GLOBAL_PRIORITY_LOW = 128,
        VK_QUEUE_GLOBAL_PRIORITY_MEDIUM = 256,
        VK_QUEUE_GLOBAL_PRIORITY_HIGH = 512,
        VK_QUEUE_GLOBAL_PRIORITY_REALTIME = 1024,
        VK_QUEUE_GLOBAL_PRIORITY_LOW_EXT = 128,
        VK_QUEUE_GLOBAL_PRIORITY_MEDIUM_EXT = 256,
        VK_QUEUE_GLOBAL_PRIORITY_HIGH_EXT = 512,
        VK_QUEUE_GLOBAL_PRIORITY_REALTIME_EXT = 1024,
        VK_QUEUE_GLOBAL_PRIORITY_LOW_KHR = 128,
        VK_QUEUE_GLOBAL_PRIORITY_MEDIUM_KHR = 256,
        VK_QUEUE_GLOBAL_PRIORITY_HIGH_KHR = 512,
        VK_QUEUE_GLOBAL_PRIORITY_REALTIME_KHR = 1024,
        VK_QUEUE_GLOBAL_PRIORITY_MAX_ENUM = 2147483647
}

enum VkLineRasterizationMode: uint32
{
        VK_LINE_RASTERIZATION_MODE_DEFAULT = 0,
        VK_LINE_RASTERIZATION_MODE_RECTANGULAR = 1,
        VK_LINE_RASTERIZATION_MODE_BRESENHAM = 2,
        VK_LINE_RASTERIZATION_MODE_RECTANGULAR_SMOOTH = 3,
        VK_LINE_RASTERIZATION_MODE_DEFAULT_EXT = 0,
        VK_LINE_RASTERIZATION_MODE_RECTANGULAR_EXT = 1,
        VK_LINE_RASTERIZATION_MODE_BRESENHAM_EXT = 2,
        VK_LINE_RASTERIZATION_MODE_RECTANGULAR_SMOOTH_EXT = 3,
        VK_LINE_RASTERIZATION_MODE_DEFAULT_KHR = 0,
        VK_LINE_RASTERIZATION_MODE_RECTANGULAR_KHR = 1,
        VK_LINE_RASTERIZATION_MODE_BRESENHAM_KHR = 2,
        VK_LINE_RASTERIZATION_MODE_RECTANGULAR_SMOOTH_KHR = 3,
        VK_LINE_RASTERIZATION_MODE_MAX_ENUM = 2147483647
}

enum VkMemoryUnmapFlagBits: uint32
{
        VK_MEMORY_UNMAP_RESERVE_BIT_EXT = 1,
        VK_MEMORY_UNMAP_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkHostImageCopyFlagBits: uint32
{
        VK_HOST_IMAGE_COPY_MEMCPY = 1,
        VK_HOST_IMAGE_COPY_MEMCPY_EXT = 1,
        VK_HOST_IMAGE_COPY_FLAG_BITS_MAX_ENUM = 2147483647
}

enum VkPresentModeKHR: uint32
{
        VK_PRESENT_MODE_IMMEDIATE_KHR = 0,
        VK_PRESENT_MODE_MAILBOX_KHR = 1,
        VK_PRESENT_MODE_FIFO_KHR = 2,
        VK_PRESENT_MODE_FIFO_RELAXED_KHR = 3,
        VK_PRESENT_MODE_SHARED_DEMAND_REFRESH_KHR = 1000111000,
        VK_PRESENT_MODE_SHARED_CONTINUOUS_REFRESH_KHR = 1000111001,
        VK_PRESENT_MODE_FIFO_LATEST_READY_EXT = 1000361000,
        VK_PRESENT_MODE_MAX_ENUM_KHR = 2147483647
}

enum VkColorSpaceKHR: uint32
{
        VK_COLOR_SPACE_SRGB_NONLINEAR_KHR = 0,
        VK_COLOR_SPACE_DISPLAY_P3_NONLINEAR_EXT = 1000104001,
        VK_COLOR_SPACE_EXTENDED_SRGB_LINEAR_EXT = 1000104002,
        VK_COLOR_SPACE_DISPLAY_P3_LINEAR_EXT = 1000104003,
        VK_COLOR_SPACE_DCI_P3_NONLINEAR_EXT = 1000104004,
        VK_COLOR_SPACE_BT709_LINEAR_EXT = 1000104005,
        VK_COLOR_SPACE_BT709_NONLINEAR_EXT = 1000104006,
        VK_COLOR_SPACE_BT2020_LINEAR_EXT = 1000104007,
        VK_COLOR_SPACE_HDR10_ST2084_EXT = 1000104008,
        VK_COLOR_SPACE_DOLBYVISION_EXT = 1000104009,
        VK_COLOR_SPACE_HDR10_HLG_EXT = 1000104010,
        VK_COLOR_SPACE_ADOBERGB_LINEAR_EXT = 1000104011,
        VK_COLOR_SPACE_ADOBERGB_NONLINEAR_EXT = 1000104012,
        VK_COLOR_SPACE_PASS_THROUGH_EXT = 1000104013,
        VK_COLOR_SPACE_EXTENDED_SRGB_NONLINEAR_EXT = 1000104014,
        VK_COLOR_SPACE_DISPLAY_NATIVE_AMD = 1000213000,
        VK_COLORSPACE_SRGB_NONLINEAR_KHR = 0,
        VK_COLOR_SPACE_DCI_P3_LINEAR_EXT = 1000104003,
        VK_COLOR_SPACE_MAX_ENUM_KHR = 2147483647
}

enum VkSurfaceTransformFlagBitsKHR: uint32
{
        VK_SURFACE_TRANSFORM_IDENTITY_BIT_KHR = 1,
        VK_SURFACE_TRANSFORM_ROTATE_90_BIT_KHR = 2,
        VK_SURFACE_TRANSFORM_ROTATE_180_BIT_KHR = 4,
        VK_SURFACE_TRANSFORM_ROTATE_270_BIT_KHR = 8,
        VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_BIT_KHR = 16,
        VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_90_BIT_KHR = 32,
        VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_180_BIT_KHR = 64,
        VK_SURFACE_TRANSFORM_HORIZONTAL_MIRROR_ROTATE_270_BIT_KHR = 128,
        VK_SURFACE_TRANSFORM_INHERIT_BIT_KHR = 256,
        VK_SURFACE_TRANSFORM_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkCompositeAlphaFlagBitsKHR: uint32
{
        VK_COMPOSITE_ALPHA_OPAQUE_BIT_KHR = 1,
        VK_COMPOSITE_ALPHA_PRE_MULTIPLIED_BIT_KHR = 2,
        VK_COMPOSITE_ALPHA_POST_MULTIPLIED_BIT_KHR = 4,
        VK_COMPOSITE_ALPHA_INHERIT_BIT_KHR = 8,
        VK_COMPOSITE_ALPHA_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkSwapchainCreateFlagBitsKHR: uint32
{
        VK_SWAPCHAIN_CREATE_SPLIT_INSTANCE_BIND_REGIONS_BIT_KHR = 1,
        VK_SWAPCHAIN_CREATE_PROTECTED_BIT_KHR = 2,
        VK_SWAPCHAIN_CREATE_MUTABLE_FORMAT_BIT_KHR = 4,
        VK_SWAPCHAIN_CREATE_DEFERRED_MEMORY_ALLOCATION_BIT_EXT = 8,
        VK_SWAPCHAIN_CREATE_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkDeviceGroupPresentModeFlagBitsKHR: uint32
{
        VK_DEVICE_GROUP_PRESENT_MODE_LOCAL_BIT_KHR = 1,
        VK_DEVICE_GROUP_PRESENT_MODE_REMOTE_BIT_KHR = 2,
        VK_DEVICE_GROUP_PRESENT_MODE_SUM_BIT_KHR = 4,
        VK_DEVICE_GROUP_PRESENT_MODE_LOCAL_MULTI_DEVICE_BIT_KHR = 8,
        VK_DEVICE_GROUP_PRESENT_MODE_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkDisplayPlaneAlphaFlagBitsKHR: uint32
{
        VK_DISPLAY_PLANE_ALPHA_OPAQUE_BIT_KHR = 1,
        VK_DISPLAY_PLANE_ALPHA_GLOBAL_BIT_KHR = 2,
        VK_DISPLAY_PLANE_ALPHA_PER_PIXEL_BIT_KHR = 4,
        VK_DISPLAY_PLANE_ALPHA_PER_PIXEL_PREMULTIPLIED_BIT_KHR = 8,
        VK_DISPLAY_PLANE_ALPHA_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkQueryResultStatusKHR: uint32
{
        VK_QUERY_RESULT_STATUS_ERROR_KHR = 4294967295,
        VK_QUERY_RESULT_STATUS_NOT_READY_KHR = 0,
        VK_QUERY_RESULT_STATUS_COMPLETE_KHR = 1,
        VK_QUERY_RESULT_STATUS_INSUFFICIENT_BITSTREAM_BUFFER_RANGE_KHR = 3294668296,
        VK_QUERY_RESULT_STATUS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoCodecOperationFlagBitsKHR: uint32
{
        VK_VIDEO_CODEC_OPERATION_NONE_KHR = 0,
        VK_VIDEO_CODEC_OPERATION_ENCODE_H264_BIT_KHR = 65536,
        VK_VIDEO_CODEC_OPERATION_ENCODE_H265_BIT_KHR = 131072,
        VK_VIDEO_CODEC_OPERATION_DECODE_H264_BIT_KHR = 1,
        VK_VIDEO_CODEC_OPERATION_DECODE_H265_BIT_KHR = 2,
        VK_VIDEO_CODEC_OPERATION_DECODE_AV1_BIT_KHR = 4,
        VK_VIDEO_CODEC_OPERATION_ENCODE_AV1_BIT_KHR = 262144,
        VK_VIDEO_CODEC_OPERATION_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoChromaSubsamplingFlagBitsKHR: uint32
{
        VK_VIDEO_CHROMA_SUBSAMPLING_INVALID_KHR = 0,
        VK_VIDEO_CHROMA_SUBSAMPLING_MONOCHROME_BIT_KHR = 1,
        VK_VIDEO_CHROMA_SUBSAMPLING_420_BIT_KHR = 2,
        VK_VIDEO_CHROMA_SUBSAMPLING_422_BIT_KHR = 4,
        VK_VIDEO_CHROMA_SUBSAMPLING_444_BIT_KHR = 8,
        VK_VIDEO_CHROMA_SUBSAMPLING_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoComponentBitDepthFlagBitsKHR: uint32
{
        VK_VIDEO_COMPONENT_BIT_DEPTH_INVALID_KHR = 0,
        VK_VIDEO_COMPONENT_BIT_DEPTH_8_BIT_KHR = 1,
        VK_VIDEO_COMPONENT_BIT_DEPTH_10_BIT_KHR = 4,
        VK_VIDEO_COMPONENT_BIT_DEPTH_12_BIT_KHR = 16,
        VK_VIDEO_COMPONENT_BIT_DEPTH_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoCapabilityFlagBitsKHR: uint32
{
        VK_VIDEO_CAPABILITY_PROTECTED_CONTENT_BIT_KHR = 1,
        VK_VIDEO_CAPABILITY_SEPARATE_REFERENCE_IMAGES_BIT_KHR = 2,
        VK_VIDEO_CAPABILITY_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoSessionCreateFlagBitsKHR: uint32
{
        VK_VIDEO_SESSION_CREATE_PROTECTED_CONTENT_BIT_KHR = 1,
        VK_VIDEO_SESSION_CREATE_ALLOW_ENCODE_PARAMETER_OPTIMIZATIONS_BIT_KHR = 2,
        VK_VIDEO_SESSION_CREATE_INLINE_QUERIES_BIT_KHR = 4,
        VK_VIDEO_SESSION_CREATE_ALLOW_ENCODE_QUANTIZATION_DELTA_MAP_BIT_KHR = 8,
        VK_VIDEO_SESSION_CREATE_ALLOW_ENCODE_EMPHASIS_MAP_BIT_KHR = 16,
        VK_VIDEO_SESSION_CREATE_INLINE_SESSION_PARAMETERS_BIT_KHR = 32,
        VK_VIDEO_SESSION_CREATE_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoSessionParametersCreateFlagBitsKHR: uint32
{
        VK_VIDEO_SESSION_PARAMETERS_CREATE_QUANTIZATION_MAP_COMPATIBLE_BIT_KHR = 1,
        VK_VIDEO_SESSION_PARAMETERS_CREATE_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoCodingControlFlagBitsKHR: uint32
{
        VK_VIDEO_CODING_CONTROL_RESET_BIT_KHR = 1,
        VK_VIDEO_CODING_CONTROL_ENCODE_RATE_CONTROL_BIT_KHR = 2,
        VK_VIDEO_CODING_CONTROL_ENCODE_QUALITY_LEVEL_BIT_KHR = 4,
        VK_VIDEO_CODING_CONTROL_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoDecodeCapabilityFlagBitsKHR: uint32
{
        VK_VIDEO_DECODE_CAPABILITY_DPB_AND_OUTPUT_COINCIDE_BIT_KHR = 1,
        VK_VIDEO_DECODE_CAPABILITY_DPB_AND_OUTPUT_DISTINCT_BIT_KHR = 2,
        VK_VIDEO_DECODE_CAPABILITY_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoDecodeUsageFlagBitsKHR: uint32
{
        VK_VIDEO_DECODE_USAGE_DEFAULT_KHR = 0,
        VK_VIDEO_DECODE_USAGE_TRANSCODING_BIT_KHR = 1,
        VK_VIDEO_DECODE_USAGE_OFFLINE_BIT_KHR = 2,
        VK_VIDEO_DECODE_USAGE_STREAMING_BIT_KHR = 4,
        VK_VIDEO_DECODE_USAGE_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeH264CapabilityFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_H264_CAPABILITY_HRD_COMPLIANCE_BIT_KHR = 1,
        VK_VIDEO_ENCODE_H264_CAPABILITY_PREDICTION_WEIGHT_TABLE_GENERATED_BIT_KHR = 2,
        VK_VIDEO_ENCODE_H264_CAPABILITY_ROW_UNALIGNED_SLICE_BIT_KHR = 4,
        VK_VIDEO_ENCODE_H264_CAPABILITY_DIFFERENT_SLICE_TYPE_BIT_KHR = 8,
        VK_VIDEO_ENCODE_H264_CAPABILITY_B_FRAME_IN_L0_LIST_BIT_KHR = 16,
        VK_VIDEO_ENCODE_H264_CAPABILITY_B_FRAME_IN_L1_LIST_BIT_KHR = 32,
        VK_VIDEO_ENCODE_H264_CAPABILITY_PER_PICTURE_TYPE_MIN_MAX_QP_BIT_KHR = 64,
        VK_VIDEO_ENCODE_H264_CAPABILITY_PER_SLICE_CONSTANT_QP_BIT_KHR = 128,
        VK_VIDEO_ENCODE_H264_CAPABILITY_GENERATE_PREFIX_NALU_BIT_KHR = 256,
        VK_VIDEO_ENCODE_H264_CAPABILITY_MB_QP_DIFF_WRAPAROUND_BIT_KHR = 512,
        VK_VIDEO_ENCODE_H264_CAPABILITY_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeH264StdFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_H264_STD_SEPARATE_COLOR_PLANE_FLAG_SET_BIT_KHR = 1,
        VK_VIDEO_ENCODE_H264_STD_QPPRIME_Y_ZERO_TRANSFORM_BYPASS_FLAG_SET_BIT_KHR = 2,
        VK_VIDEO_ENCODE_H264_STD_SCALING_MATRIX_PRESENT_FLAG_SET_BIT_KHR = 4,
        VK_VIDEO_ENCODE_H264_STD_CHROMA_QP_INDEX_OFFSET_BIT_KHR = 8,
        VK_VIDEO_ENCODE_H264_STD_SECOND_CHROMA_QP_INDEX_OFFSET_BIT_KHR = 16,
        VK_VIDEO_ENCODE_H264_STD_PIC_INIT_QP_MINUS26_BIT_KHR = 32,
        VK_VIDEO_ENCODE_H264_STD_WEIGHTED_PRED_FLAG_SET_BIT_KHR = 64,
        VK_VIDEO_ENCODE_H264_STD_WEIGHTED_BIPRED_IDC_EXPLICIT_BIT_KHR = 128,
        VK_VIDEO_ENCODE_H264_STD_WEIGHTED_BIPRED_IDC_IMPLICIT_BIT_KHR = 256,
        VK_VIDEO_ENCODE_H264_STD_TRANSFORM_8X8_MODE_FLAG_SET_BIT_KHR = 512,
        VK_VIDEO_ENCODE_H264_STD_DIRECT_SPATIAL_MV_PRED_FLAG_UNSET_BIT_KHR = 1024,
        VK_VIDEO_ENCODE_H264_STD_ENTROPY_CODING_MODE_FLAG_UNSET_BIT_KHR = 2048,
        VK_VIDEO_ENCODE_H264_STD_ENTROPY_CODING_MODE_FLAG_SET_BIT_KHR = 4096,
        VK_VIDEO_ENCODE_H264_STD_DIRECT_8X8_INFERENCE_FLAG_UNSET_BIT_KHR = 8192,
        VK_VIDEO_ENCODE_H264_STD_CONSTRAINED_INTRA_PRED_FLAG_SET_BIT_KHR = 16384,
        VK_VIDEO_ENCODE_H264_STD_DEBLOCKING_FILTER_DISABLED_BIT_KHR = 32768,
        VK_VIDEO_ENCODE_H264_STD_DEBLOCKING_FILTER_ENABLED_BIT_KHR = 65536,
        VK_VIDEO_ENCODE_H264_STD_DEBLOCKING_FILTER_PARTIAL_BIT_KHR = 131072,
        VK_VIDEO_ENCODE_H264_STD_SLICE_QP_DELTA_BIT_KHR = 524288,
        VK_VIDEO_ENCODE_H264_STD_DIFFERENT_SLICE_QP_DELTA_BIT_KHR = 1048576,
        VK_VIDEO_ENCODE_H264_STD_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeH264RateControlFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_H264_RATE_CONTROL_ATTEMPT_HRD_COMPLIANCE_BIT_KHR = 1,
        VK_VIDEO_ENCODE_H264_RATE_CONTROL_REGULAR_GOP_BIT_KHR = 2,
        VK_VIDEO_ENCODE_H264_RATE_CONTROL_REFERENCE_PATTERN_FLAT_BIT_KHR = 4,
        VK_VIDEO_ENCODE_H264_RATE_CONTROL_REFERENCE_PATTERN_DYADIC_BIT_KHR = 8,
        VK_VIDEO_ENCODE_H264_RATE_CONTROL_TEMPORAL_LAYER_PATTERN_DYADIC_BIT_KHR = 16,
        VK_VIDEO_ENCODE_H264_RATE_CONTROL_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeH265CapabilityFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_H265_CAPABILITY_HRD_COMPLIANCE_BIT_KHR = 1,
        VK_VIDEO_ENCODE_H265_CAPABILITY_PREDICTION_WEIGHT_TABLE_GENERATED_BIT_KHR = 2,
        VK_VIDEO_ENCODE_H265_CAPABILITY_ROW_UNALIGNED_SLICE_SEGMENT_BIT_KHR = 4,
        VK_VIDEO_ENCODE_H265_CAPABILITY_DIFFERENT_SLICE_SEGMENT_TYPE_BIT_KHR = 8,
        VK_VIDEO_ENCODE_H265_CAPABILITY_B_FRAME_IN_L0_LIST_BIT_KHR = 16,
        VK_VIDEO_ENCODE_H265_CAPABILITY_B_FRAME_IN_L1_LIST_BIT_KHR = 32,
        VK_VIDEO_ENCODE_H265_CAPABILITY_PER_PICTURE_TYPE_MIN_MAX_QP_BIT_KHR = 64,
        VK_VIDEO_ENCODE_H265_CAPABILITY_PER_SLICE_SEGMENT_CONSTANT_QP_BIT_KHR = 128,
        VK_VIDEO_ENCODE_H265_CAPABILITY_MULTIPLE_TILES_PER_SLICE_SEGMENT_BIT_KHR = 256,
        VK_VIDEO_ENCODE_H265_CAPABILITY_MULTIPLE_SLICE_SEGMENTS_PER_TILE_BIT_KHR = 512,
        VK_VIDEO_ENCODE_H265_CAPABILITY_CU_QP_DIFF_WRAPAROUND_BIT_KHR = 1024,
        VK_VIDEO_ENCODE_H265_CAPABILITY_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeH265StdFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_H265_STD_SEPARATE_COLOR_PLANE_FLAG_SET_BIT_KHR = 1,
        VK_VIDEO_ENCODE_H265_STD_SAMPLE_ADAPTIVE_OFFSET_ENABLED_FLAG_SET_BIT_KHR = 2,
        VK_VIDEO_ENCODE_H265_STD_SCALING_LIST_DATA_PRESENT_FLAG_SET_BIT_KHR = 4,
        VK_VIDEO_ENCODE_H265_STD_PCM_ENABLED_FLAG_SET_BIT_KHR = 8,
        VK_VIDEO_ENCODE_H265_STD_SPS_TEMPORAL_MVP_ENABLED_FLAG_SET_BIT_KHR = 16,
        VK_VIDEO_ENCODE_H265_STD_INIT_QP_MINUS26_BIT_KHR = 32,
        VK_VIDEO_ENCODE_H265_STD_WEIGHTED_PRED_FLAG_SET_BIT_KHR = 64,
        VK_VIDEO_ENCODE_H265_STD_WEIGHTED_BIPRED_FLAG_SET_BIT_KHR = 128,
        VK_VIDEO_ENCODE_H265_STD_LOG2_PARALLEL_MERGE_LEVEL_MINUS2_BIT_KHR = 256,
        VK_VIDEO_ENCODE_H265_STD_SIGN_DATA_HIDING_ENABLED_FLAG_SET_BIT_KHR = 512,
        VK_VIDEO_ENCODE_H265_STD_TRANSFORM_SKIP_ENABLED_FLAG_SET_BIT_KHR = 1024,
        VK_VIDEO_ENCODE_H265_STD_TRANSFORM_SKIP_ENABLED_FLAG_UNSET_BIT_KHR = 2048,
        VK_VIDEO_ENCODE_H265_STD_PPS_SLICE_CHROMA_QP_OFFSETS_PRESENT_FLAG_SET_BIT_KHR = 4096,
        VK_VIDEO_ENCODE_H265_STD_TRANSQUANT_BYPASS_ENABLED_FLAG_SET_BIT_KHR = 8192,
        VK_VIDEO_ENCODE_H265_STD_CONSTRAINED_INTRA_PRED_FLAG_SET_BIT_KHR = 16384,
        VK_VIDEO_ENCODE_H265_STD_ENTROPY_CODING_SYNC_ENABLED_FLAG_SET_BIT_KHR = 32768,
        VK_VIDEO_ENCODE_H265_STD_DEBLOCKING_FILTER_OVERRIDE_ENABLED_FLAG_SET_BIT_KHR = 65536,
        VK_VIDEO_ENCODE_H265_STD_DEPENDENT_SLICE_SEGMENTS_ENABLED_FLAG_SET_BIT_KHR = 131072,
        VK_VIDEO_ENCODE_H265_STD_DEPENDENT_SLICE_SEGMENT_FLAG_SET_BIT_KHR = 262144,
        VK_VIDEO_ENCODE_H265_STD_SLICE_QP_DELTA_BIT_KHR = 524288,
        VK_VIDEO_ENCODE_H265_STD_DIFFERENT_SLICE_QP_DELTA_BIT_KHR = 1048576,
        VK_VIDEO_ENCODE_H265_STD_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeH265CtbSizeFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_H265_CTB_SIZE_16_BIT_KHR = 1,
        VK_VIDEO_ENCODE_H265_CTB_SIZE_32_BIT_KHR = 2,
        VK_VIDEO_ENCODE_H265_CTB_SIZE_64_BIT_KHR = 4,
        VK_VIDEO_ENCODE_H265_CTB_SIZE_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeH265TransformBlockSizeFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_H265_TRANSFORM_BLOCK_SIZE_4_BIT_KHR = 1,
        VK_VIDEO_ENCODE_H265_TRANSFORM_BLOCK_SIZE_8_BIT_KHR = 2,
        VK_VIDEO_ENCODE_H265_TRANSFORM_BLOCK_SIZE_16_BIT_KHR = 4,
        VK_VIDEO_ENCODE_H265_TRANSFORM_BLOCK_SIZE_32_BIT_KHR = 8,
        VK_VIDEO_ENCODE_H265_TRANSFORM_BLOCK_SIZE_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeH265RateControlFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_H265_RATE_CONTROL_ATTEMPT_HRD_COMPLIANCE_BIT_KHR = 1,
        VK_VIDEO_ENCODE_H265_RATE_CONTROL_REGULAR_GOP_BIT_KHR = 2,
        VK_VIDEO_ENCODE_H265_RATE_CONTROL_REFERENCE_PATTERN_FLAT_BIT_KHR = 4,
        VK_VIDEO_ENCODE_H265_RATE_CONTROL_REFERENCE_PATTERN_DYADIC_BIT_KHR = 8,
        VK_VIDEO_ENCODE_H265_RATE_CONTROL_TEMPORAL_SUB_LAYER_PATTERN_DYADIC_BIT_KHR = 16,
        VK_VIDEO_ENCODE_H265_RATE_CONTROL_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoDecodeH264PictureLayoutFlagBitsKHR: uint32
{
        VK_VIDEO_DECODE_H264_PICTURE_LAYOUT_PROGRESSIVE_KHR = 0,
        VK_VIDEO_DECODE_H264_PICTURE_LAYOUT_INTERLACED_INTERLEAVED_LINES_BIT_KHR = 1,
        VK_VIDEO_DECODE_H264_PICTURE_LAYOUT_INTERLACED_SEPARATE_PLANES_BIT_KHR = 2,
        VK_VIDEO_DECODE_H264_PICTURE_LAYOUT_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkPerformanceCounterUnitKHR: uint32
{
        VK_PERFORMANCE_COUNTER_UNIT_GENERIC_KHR = 0,
        VK_PERFORMANCE_COUNTER_UNIT_PERCENTAGE_KHR = 1,
        VK_PERFORMANCE_COUNTER_UNIT_NANOSECONDS_KHR = 2,
        VK_PERFORMANCE_COUNTER_UNIT_BYTES_KHR = 3,
        VK_PERFORMANCE_COUNTER_UNIT_BYTES_PER_SECOND_KHR = 4,
        VK_PERFORMANCE_COUNTER_UNIT_KELVIN_KHR = 5,
        VK_PERFORMANCE_COUNTER_UNIT_WATTS_KHR = 6,
        VK_PERFORMANCE_COUNTER_UNIT_VOLTS_KHR = 7,
        VK_PERFORMANCE_COUNTER_UNIT_AMPS_KHR = 8,
        VK_PERFORMANCE_COUNTER_UNIT_HERTZ_KHR = 9,
        VK_PERFORMANCE_COUNTER_UNIT_CYCLES_KHR = 10,
        VK_PERFORMANCE_COUNTER_UNIT_MAX_ENUM_KHR = 2147483647
}

enum VkPerformanceCounterScopeKHR: uint32
{
        VK_PERFORMANCE_COUNTER_SCOPE_COMMAND_BUFFER_KHR = 0,
        VK_PERFORMANCE_COUNTER_SCOPE_RENDER_PASS_KHR = 1,
        VK_PERFORMANCE_COUNTER_SCOPE_COMMAND_KHR = 2,
        VK_QUERY_SCOPE_COMMAND_BUFFER_KHR = 0,
        VK_QUERY_SCOPE_RENDER_PASS_KHR = 1,
        VK_QUERY_SCOPE_COMMAND_KHR = 2,
        VK_PERFORMANCE_COUNTER_SCOPE_MAX_ENUM_KHR = 2147483647
}

enum VkPerformanceCounterStorageKHR: uint32
{
        VK_PERFORMANCE_COUNTER_STORAGE_INT32_KHR = 0,
        VK_PERFORMANCE_COUNTER_STORAGE_INT64_KHR = 1,
        VK_PERFORMANCE_COUNTER_STORAGE_UINT32_KHR = 2,
        VK_PERFORMANCE_COUNTER_STORAGE_UINT64_KHR = 3,
        VK_PERFORMANCE_COUNTER_STORAGE_FLOAT32_KHR = 4,
        VK_PERFORMANCE_COUNTER_STORAGE_FLOAT64_KHR = 5,
        VK_PERFORMANCE_COUNTER_STORAGE_MAX_ENUM_KHR = 2147483647
}

enum VkPerformanceCounterDescriptionFlagBitsKHR: uint32
{
        VK_PERFORMANCE_COUNTER_DESCRIPTION_PERFORMANCE_IMPACTING_BIT_KHR = 1,
        VK_PERFORMANCE_COUNTER_DESCRIPTION_CONCURRENTLY_IMPACTED_BIT_KHR = 2,
        VK_PERFORMANCE_COUNTER_DESCRIPTION_PERFORMANCE_IMPACTING_KHR = 1,
        VK_PERFORMANCE_COUNTER_DESCRIPTION_CONCURRENTLY_IMPACTED_KHR = 2,
        VK_PERFORMANCE_COUNTER_DESCRIPTION_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkAcquireProfilingLockFlagBitsKHR: uint32
{
        VK_ACQUIRE_PROFILING_LOCK_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkFragmentShadingRateCombinerOpKHR: uint32
{
        VK_FRAGMENT_SHADING_RATE_COMBINER_OP_KEEP_KHR = 0,
        VK_FRAGMENT_SHADING_RATE_COMBINER_OP_REPLACE_KHR = 1,
        VK_FRAGMENT_SHADING_RATE_COMBINER_OP_MIN_KHR = 2,
        VK_FRAGMENT_SHADING_RATE_COMBINER_OP_MAX_KHR = 3,
        VK_FRAGMENT_SHADING_RATE_COMBINER_OP_MUL_KHR = 4,
        VK_FRAGMENT_SHADING_RATE_COMBINER_OP_MAX_ENUM_KHR = 2147483647
}

enum VkPipelineExecutableStatisticFormatKHR: uint32
{
        VK_PIPELINE_EXECUTABLE_STATISTIC_FORMAT_BOOL32_KHR = 0,
        VK_PIPELINE_EXECUTABLE_STATISTIC_FORMAT_INT64_KHR = 1,
        VK_PIPELINE_EXECUTABLE_STATISTIC_FORMAT_UINT64_KHR = 2,
        VK_PIPELINE_EXECUTABLE_STATISTIC_FORMAT_FLOAT64_KHR = 3,
        VK_PIPELINE_EXECUTABLE_STATISTIC_FORMAT_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeTuningModeKHR: uint32
{
        VK_VIDEO_ENCODE_TUNING_MODE_DEFAULT_KHR = 0,
        VK_VIDEO_ENCODE_TUNING_MODE_HIGH_QUALITY_KHR = 1,
        VK_VIDEO_ENCODE_TUNING_MODE_LOW_LATENCY_KHR = 2,
        VK_VIDEO_ENCODE_TUNING_MODE_ULTRA_LOW_LATENCY_KHR = 3,
        VK_VIDEO_ENCODE_TUNING_MODE_LOSSLESS_KHR = 4,
        VK_VIDEO_ENCODE_TUNING_MODE_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_WITH_QUANTIZATION_DELTA_MAP_BIT_KHR = 1,
        VK_VIDEO_ENCODE_WITH_EMPHASIS_MAP_BIT_KHR = 2,
        VK_VIDEO_ENCODE_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeCapabilityFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_CAPABILITY_PRECEDING_EXTERNALLY_ENCODED_BYTES_BIT_KHR = 1,
        VK_VIDEO_ENCODE_CAPABILITY_INSUFFICIENT_BITSTREAM_BUFFER_RANGE_DETECTION_BIT_KHR = 2,
        VK_VIDEO_ENCODE_CAPABILITY_QUANTIZATION_DELTA_MAP_BIT_KHR = 4,
        VK_VIDEO_ENCODE_CAPABILITY_EMPHASIS_MAP_BIT_KHR = 8,
        VK_VIDEO_ENCODE_CAPABILITY_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeRateControlModeFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_RATE_CONTROL_MODE_DEFAULT_KHR = 0,
        VK_VIDEO_ENCODE_RATE_CONTROL_MODE_DISABLED_BIT_KHR = 1,
        VK_VIDEO_ENCODE_RATE_CONTROL_MODE_CBR_BIT_KHR = 2,
        VK_VIDEO_ENCODE_RATE_CONTROL_MODE_VBR_BIT_KHR = 4,
        VK_VIDEO_ENCODE_RATE_CONTROL_MODE_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeFeedbackFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_FEEDBACK_BITSTREAM_BUFFER_OFFSET_BIT_KHR = 1,
        VK_VIDEO_ENCODE_FEEDBACK_BITSTREAM_BYTES_WRITTEN_BIT_KHR = 2,
        VK_VIDEO_ENCODE_FEEDBACK_BITSTREAM_HAS_OVERRIDES_BIT_KHR = 4,
        VK_VIDEO_ENCODE_FEEDBACK_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeUsageFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_USAGE_DEFAULT_KHR = 0,
        VK_VIDEO_ENCODE_USAGE_TRANSCODING_BIT_KHR = 1,
        VK_VIDEO_ENCODE_USAGE_STREAMING_BIT_KHR = 2,
        VK_VIDEO_ENCODE_USAGE_RECORDING_BIT_KHR = 4,
        VK_VIDEO_ENCODE_USAGE_CONFERENCING_BIT_KHR = 8,
        VK_VIDEO_ENCODE_USAGE_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeContentFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_CONTENT_DEFAULT_KHR = 0,
        VK_VIDEO_ENCODE_CONTENT_CAMERA_BIT_KHR = 1,
        VK_VIDEO_ENCODE_CONTENT_DESKTOP_BIT_KHR = 2,
        VK_VIDEO_ENCODE_CONTENT_RENDERED_BIT_KHR = 4,
        VK_VIDEO_ENCODE_CONTENT_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkComponentTypeKHR: uint32
{
        VK_COMPONENT_TYPE_FLOAT16_KHR = 0,
        VK_COMPONENT_TYPE_FLOAT32_KHR = 1,
        VK_COMPONENT_TYPE_FLOAT64_KHR = 2,
        VK_COMPONENT_TYPE_SINT8_KHR = 3,
        VK_COMPONENT_TYPE_SINT16_KHR = 4,
        VK_COMPONENT_TYPE_SINT32_KHR = 5,
        VK_COMPONENT_TYPE_SINT64_KHR = 6,
        VK_COMPONENT_TYPE_UINT8_KHR = 7,
        VK_COMPONENT_TYPE_UINT16_KHR = 8,
        VK_COMPONENT_TYPE_UINT32_KHR = 9,
        VK_COMPONENT_TYPE_UINT64_KHR = 10,
        VK_COMPONENT_TYPE_SINT8_PACKED_NV = 1000491000,
        VK_COMPONENT_TYPE_UINT8_PACKED_NV = 1000491001,
        VK_COMPONENT_TYPE_FLOAT_E4M3_NV = 1000491002,
        VK_COMPONENT_TYPE_FLOAT_E5M2_NV = 1000491003,
        VK_COMPONENT_TYPE_FLOAT16_NV = 0,
        VK_COMPONENT_TYPE_FLOAT32_NV = 1,
        VK_COMPONENT_TYPE_FLOAT64_NV = 2,
        VK_COMPONENT_TYPE_SINT8_NV = 3,
        VK_COMPONENT_TYPE_SINT16_NV = 4,
        VK_COMPONENT_TYPE_SINT32_NV = 5,
        VK_COMPONENT_TYPE_SINT64_NV = 6,
        VK_COMPONENT_TYPE_UINT8_NV = 7,
        VK_COMPONENT_TYPE_UINT16_NV = 8,
        VK_COMPONENT_TYPE_UINT32_NV = 9,
        VK_COMPONENT_TYPE_UINT64_NV = 10,
        VK_COMPONENT_TYPE_MAX_ENUM_KHR = 2147483647
}

enum VkScopeKHR: uint32
{
        VK_SCOPE_DEVICE_KHR = 1,
        VK_SCOPE_WORKGROUP_KHR = 2,
        VK_SCOPE_SUBGROUP_KHR = 3,
        VK_SCOPE_QUEUE_FAMILY_KHR = 5,
        VK_SCOPE_DEVICE_NV = 1,
        VK_SCOPE_WORKGROUP_NV = 2,
        VK_SCOPE_SUBGROUP_NV = 3,
        VK_SCOPE_QUEUE_FAMILY_NV = 5,
        VK_SCOPE_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeAV1PredictionModeKHR: uint32
{
        VK_VIDEO_ENCODE_AV1_PREDICTION_MODE_INTRA_ONLY_KHR = 0,
        VK_VIDEO_ENCODE_AV1_PREDICTION_MODE_SINGLE_REFERENCE_KHR = 1,
        VK_VIDEO_ENCODE_AV1_PREDICTION_MODE_UNIDIRECTIONAL_COMPOUND_KHR = 2,
        VK_VIDEO_ENCODE_AV1_PREDICTION_MODE_BIDIRECTIONAL_COMPOUND_KHR = 3,
        VK_VIDEO_ENCODE_AV1_PREDICTION_MODE_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeAV1RateControlGroupKHR: uint32
{
        VK_VIDEO_ENCODE_AV1_RATE_CONTROL_GROUP_INTRA_KHR = 0,
        VK_VIDEO_ENCODE_AV1_RATE_CONTROL_GROUP_PREDICTIVE_KHR = 1,
        VK_VIDEO_ENCODE_AV1_RATE_CONTROL_GROUP_BIPREDICTIVE_KHR = 2,
        VK_VIDEO_ENCODE_AV1_RATE_CONTROL_GROUP_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeAV1CapabilityFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_AV1_CAPABILITY_PER_RATE_CONTROL_GROUP_MIN_MAX_Q_INDEX_BIT_KHR = 1,
        VK_VIDEO_ENCODE_AV1_CAPABILITY_GENERATE_OBU_EXTENSION_HEADER_BIT_KHR = 2,
        VK_VIDEO_ENCODE_AV1_CAPABILITY_PRIMARY_REFERENCE_CDF_ONLY_BIT_KHR = 4,
        VK_VIDEO_ENCODE_AV1_CAPABILITY_FRAME_SIZE_OVERRIDE_BIT_KHR = 8,
        VK_VIDEO_ENCODE_AV1_CAPABILITY_MOTION_VECTOR_SCALING_BIT_KHR = 16,
        VK_VIDEO_ENCODE_AV1_CAPABILITY_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeAV1StdFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_AV1_STD_UNIFORM_TILE_SPACING_FLAG_SET_BIT_KHR = 1,
        VK_VIDEO_ENCODE_AV1_STD_SKIP_MODE_PRESENT_UNSET_BIT_KHR = 2,
        VK_VIDEO_ENCODE_AV1_STD_PRIMARY_REF_FRAME_BIT_KHR = 4,
        VK_VIDEO_ENCODE_AV1_STD_DELTA_Q_BIT_KHR = 8,
        VK_VIDEO_ENCODE_AV1_STD_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeAV1SuperblockSizeFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_AV1_SUPERBLOCK_SIZE_64_BIT_KHR = 1,
        VK_VIDEO_ENCODE_AV1_SUPERBLOCK_SIZE_128_BIT_KHR = 2,
        VK_VIDEO_ENCODE_AV1_SUPERBLOCK_SIZE_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkVideoEncodeAV1RateControlFlagBitsKHR: uint32
{
        VK_VIDEO_ENCODE_AV1_RATE_CONTROL_REGULAR_GOP_BIT_KHR = 1,
        VK_VIDEO_ENCODE_AV1_RATE_CONTROL_TEMPORAL_LAYER_PATTERN_DYADIC_BIT_KHR = 2,
        VK_VIDEO_ENCODE_AV1_RATE_CONTROL_REFERENCE_PATTERN_FLAT_BIT_KHR = 4,
        VK_VIDEO_ENCODE_AV1_RATE_CONTROL_REFERENCE_PATTERN_DYADIC_BIT_KHR = 8,
        VK_VIDEO_ENCODE_AV1_RATE_CONTROL_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkTimeDomainKHR: uint32
{
        VK_TIME_DOMAIN_DEVICE_KHR = 0,
        VK_TIME_DOMAIN_CLOCK_MONOTONIC_KHR = 1,
        VK_TIME_DOMAIN_CLOCK_MONOTONIC_RAW_KHR = 2,
        VK_TIME_DOMAIN_QUERY_PERFORMANCE_COUNTER_KHR = 3,
        VK_TIME_DOMAIN_DEVICE_EXT = 0,
        VK_TIME_DOMAIN_CLOCK_MONOTONIC_EXT = 1,
        VK_TIME_DOMAIN_CLOCK_MONOTONIC_RAW_EXT = 2,
        VK_TIME_DOMAIN_QUERY_PERFORMANCE_COUNTER_EXT = 3,
        VK_TIME_DOMAIN_MAX_ENUM_KHR = 2147483647
}

enum VkPhysicalDeviceLayeredApiKHR: uint32
{
        VK_PHYSICAL_DEVICE_LAYERED_API_VULKAN_KHR = 0,
        VK_PHYSICAL_DEVICE_LAYERED_API_D3D12_KHR = 1,
        VK_PHYSICAL_DEVICE_LAYERED_API_METAL_KHR = 2,
        VK_PHYSICAL_DEVICE_LAYERED_API_OPENGL_KHR = 3,
        VK_PHYSICAL_DEVICE_LAYERED_API_OPENGLES_KHR = 4,
        VK_PHYSICAL_DEVICE_LAYERED_API_MAX_ENUM_KHR = 2147483647
}

enum VkDebugReportObjectTypeEXT: uint32
{
        VK_DEBUG_REPORT_OBJECT_TYPE_UNKNOWN_EXT = 0,
        VK_DEBUG_REPORT_OBJECT_TYPE_INSTANCE_EXT = 1,
        VK_DEBUG_REPORT_OBJECT_TYPE_PHYSICAL_DEVICE_EXT = 2,
        VK_DEBUG_REPORT_OBJECT_TYPE_DEVICE_EXT = 3,
        VK_DEBUG_REPORT_OBJECT_TYPE_QUEUE_EXT = 4,
        VK_DEBUG_REPORT_OBJECT_TYPE_SEMAPHORE_EXT = 5,
        VK_DEBUG_REPORT_OBJECT_TYPE_COMMAND_BUFFER_EXT = 6,
        VK_DEBUG_REPORT_OBJECT_TYPE_FENCE_EXT = 7,
        VK_DEBUG_REPORT_OBJECT_TYPE_DEVICE_MEMORY_EXT = 8,
        VK_DEBUG_REPORT_OBJECT_TYPE_BUFFER_EXT = 9,
        VK_DEBUG_REPORT_OBJECT_TYPE_IMAGE_EXT = 10,
        VK_DEBUG_REPORT_OBJECT_TYPE_EVENT_EXT = 11,
        VK_DEBUG_REPORT_OBJECT_TYPE_QUERY_POOL_EXT = 12,
        VK_DEBUG_REPORT_OBJECT_TYPE_BUFFER_VIEW_EXT = 13,
        VK_DEBUG_REPORT_OBJECT_TYPE_IMAGE_VIEW_EXT = 14,
        VK_DEBUG_REPORT_OBJECT_TYPE_SHADER_MODULE_EXT = 15,
        VK_DEBUG_REPORT_OBJECT_TYPE_PIPELINE_CACHE_EXT = 16,
        VK_DEBUG_REPORT_OBJECT_TYPE_PIPELINE_LAYOUT_EXT = 17,
        VK_DEBUG_REPORT_OBJECT_TYPE_RENDER_PASS_EXT = 18,
        VK_DEBUG_REPORT_OBJECT_TYPE_PIPELINE_EXT = 19,
        VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_SET_LAYOUT_EXT = 20,
        VK_DEBUG_REPORT_OBJECT_TYPE_SAMPLER_EXT = 21,
        VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_POOL_EXT = 22,
        VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_SET_EXT = 23,
        VK_DEBUG_REPORT_OBJECT_TYPE_FRAMEBUFFER_EXT = 24,
        VK_DEBUG_REPORT_OBJECT_TYPE_COMMAND_POOL_EXT = 25,
        VK_DEBUG_REPORT_OBJECT_TYPE_SURFACE_KHR_EXT = 26,
        VK_DEBUG_REPORT_OBJECT_TYPE_SWAPCHAIN_KHR_EXT = 27,
        VK_DEBUG_REPORT_OBJECT_TYPE_DEBUG_REPORT_CALLBACK_EXT_EXT = 28,
        VK_DEBUG_REPORT_OBJECT_TYPE_DISPLAY_KHR_EXT = 29,
        VK_DEBUG_REPORT_OBJECT_TYPE_DISPLAY_MODE_KHR_EXT = 30,
        VK_DEBUG_REPORT_OBJECT_TYPE_VALIDATION_CACHE_EXT_EXT = 33,
        VK_DEBUG_REPORT_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION_EXT = 1000156000,
        VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_EXT = 1000085000,
        VK_DEBUG_REPORT_OBJECT_TYPE_CU_MODULE_NVX_EXT = 1000029000,
        VK_DEBUG_REPORT_OBJECT_TYPE_CU_FUNCTION_NVX_EXT = 1000029001,
        VK_DEBUG_REPORT_OBJECT_TYPE_ACCELERATION_STRUCTURE_KHR_EXT = 1000150000,
        VK_DEBUG_REPORT_OBJECT_TYPE_ACCELERATION_STRUCTURE_NV_EXT = 1000165000,
        VK_DEBUG_REPORT_OBJECT_TYPE_CUDA_MODULE_NV_EXT = 1000307000,
        VK_DEBUG_REPORT_OBJECT_TYPE_CUDA_FUNCTION_NV_EXT = 1000307001,
        VK_DEBUG_REPORT_OBJECT_TYPE_BUFFER_COLLECTION_FUCHSIA_EXT = 1000366000,
        VK_DEBUG_REPORT_OBJECT_TYPE_DEBUG_REPORT_EXT = 28,
        VK_DEBUG_REPORT_OBJECT_TYPE_VALIDATION_CACHE_EXT = 33,
        VK_DEBUG_REPORT_OBJECT_TYPE_DESCRIPTOR_UPDATE_TEMPLATE_KHR_EXT = 1000085000,
        VK_DEBUG_REPORT_OBJECT_TYPE_SAMPLER_YCBCR_CONVERSION_KHR_EXT = 1000156000,
        VK_DEBUG_REPORT_OBJECT_TYPE_MAX_ENUM_EXT = 2147483647
}

enum VkDebugReportFlagBitsEXT: uint32
{
        VK_DEBUG_REPORT_INFORMATION_BIT_EXT = 1,
        VK_DEBUG_REPORT_WARNING_BIT_EXT = 2,
        VK_DEBUG_REPORT_PERFORMANCE_WARNING_BIT_EXT = 4,
        VK_DEBUG_REPORT_ERROR_BIT_EXT = 8,
        VK_DEBUG_REPORT_DEBUG_BIT_EXT = 16,
        VK_DEBUG_REPORT_FLAG_BITS_MAX_ENUM_EXT = 2147483647
}

enum VkRasterizationOrderAMD: uint32
{
        VK_RASTERIZATION_ORDER_STRICT_AMD = 0,
        VK_RASTERIZATION_ORDER_RELAXED_AMD = 1,
        VK_RASTERIZATION_ORDER_MAX_ENUM_AMD = 2147483647
}

enum VkShaderInfoTypeAMD: uint32
{
        VK_SHADER_INFO_TYPE_STATISTICS_AMD = 0,
        VK_SHADER_INFO_TYPE_BINARY_AMD = 1,
        VK_SHADER_INFO_TYPE_DISASSEMBLY_AMD = 2,
        VK_SHADER_INFO_TYPE_MAX_ENUM_AMD = 2147483647
}

enum VkExternalMemoryHandleTypeFlagBitsNV: uint32
{
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT_NV = 1,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_KMT_BIT_NV = 2,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_IMAGE_BIT_NV = 4,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_D3D11_IMAGE_KMT_BIT_NV = 8,
        VK_EXTERNAL_MEMORY_HANDLE_TYPE_FLAG_BITS_MAX_ENUM_NV = 2147483647
}

enum VkExternalMemoryFeatureFlagBitsNV: uint32
{
        VK_EXTERNAL_MEMORY_FEATURE_DEDICATED_ONLY_BIT_NV = 1,
        VK_EXTERNAL_MEMORY_FEATURE_EXPORTABLE_BIT_NV = 2,
        VK_EXTERNAL_MEMORY_FEATURE_IMPORTABLE_BIT_NV = 4,
        VK_EXTERNAL_MEMORY_FEATURE_FLAG_BITS_MAX_ENUM_NV = 2147483647
}

enum VkValidationCheckEXT: uint32
{
        VK_VALIDATION_CHECK_ALL_EXT = 0,
        VK_VALIDATION_CHECK_SHADERS_EXT = 1,
        VK_VALIDATION_CHECK_MAX_ENUM_EXT = 2147483647
}

enum VkConditionalRenderingFlagBitsEXT: uint32
{
        VK_CONDITIONAL_RENDERING_INVERTED_BIT_EXT = 1,
        VK_CONDITIONAL_RENDERING_FLAG_BITS_MAX_ENUM_EXT = 2147483647
}

enum VkSurfaceCounterFlagBitsEXT: uint32
{
        VK_SURFACE_COUNTER_VBLANK_BIT_EXT = 1,
        VK_SURFACE_COUNTER_VBLANK_EXT = 1,
        VK_SURFACE_COUNTER_FLAG_BITS_MAX_ENUM_EXT = 2147483647
}

enum VkDisplayPowerStateEXT: uint32
{
        VK_DISPLAY_POWER_STATE_OFF_EXT = 0,
        VK_DISPLAY_POWER_STATE_SUSPEND_EXT = 1,
        VK_DISPLAY_POWER_STATE_ON_EXT = 2,
        VK_DISPLAY_POWER_STATE_MAX_ENUM_EXT = 2147483647
}

enum VkDeviceEventTypeEXT: uint32
{
        VK_DEVICE_EVENT_TYPE_DISPLAY_HOTPLUG_EXT = 0,
        VK_DEVICE_EVENT_TYPE_MAX_ENUM_EXT = 2147483647
}

enum VkDisplayEventTypeEXT: uint32
{
        VK_DISPLAY_EVENT_TYPE_FIRST_PIXEL_OUT_EXT = 0,
        VK_DISPLAY_EVENT_TYPE_MAX_ENUM_EXT = 2147483647
}

enum VkViewportCoordinateSwizzleNV: uint32
{
        VK_VIEWPORT_COORDINATE_SWIZZLE_POSITIVE_X_NV = 0,
        VK_VIEWPORT_COORDINATE_SWIZZLE_NEGATIVE_X_NV = 1,
        VK_VIEWPORT_COORDINATE_SWIZZLE_POSITIVE_Y_NV = 2,
        VK_VIEWPORT_COORDINATE_SWIZZLE_NEGATIVE_Y_NV = 3,
        VK_VIEWPORT_COORDINATE_SWIZZLE_POSITIVE_Z_NV = 4,
        VK_VIEWPORT_COORDINATE_SWIZZLE_NEGATIVE_Z_NV = 5,
        VK_VIEWPORT_COORDINATE_SWIZZLE_POSITIVE_W_NV = 6,
        VK_VIEWPORT_COORDINATE_SWIZZLE_NEGATIVE_W_NV = 7,
        VK_VIEWPORT_COORDINATE_SWIZZLE_MAX_ENUM_NV = 2147483647
}

enum VkDiscardRectangleModeEXT: uint32
{
        VK_DISCARD_RECTANGLE_MODE_INCLUSIVE_EXT = 0,
        VK_DISCARD_RECTANGLE_MODE_EXCLUSIVE_EXT = 1,
        VK_DISCARD_RECTANGLE_MODE_MAX_ENUM_EXT = 2147483647
}

enum VkConservativeRasterizationModeEXT: uint32
{
        VK_CONSERVATIVE_RASTERIZATION_MODE_DISABLED_EXT = 0,
        VK_CONSERVATIVE_RASTERIZATION_MODE_OVERESTIMATE_EXT = 1,
        VK_CONSERVATIVE_RASTERIZATION_MODE_UNDERESTIMATE_EXT = 2,
        VK_CONSERVATIVE_RASTERIZATION_MODE_MAX_ENUM_EXT = 2147483647
}

enum VkDebugUtilsMessageSeverityFlagBitsEXT: uint32
{
        VK_DEBUG_UTILS_MESSAGE_SEVERITY_VERBOSE_BIT_EXT = 1,
        VK_DEBUG_UTILS_MESSAGE_SEVERITY_INFO_BIT_EXT = 16,
        VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT = 256,
        VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT = 4096,
        VK_DEBUG_UTILS_MESSAGE_SEVERITY_FLAG_BITS_MAX_ENUM_EXT = 2147483647
}

enum VkDebugUtilsMessageTypeFlagBitsEXT: uint32
{
        VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT = 1,
        VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT = 2,
        VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT = 4,
        VK_DEBUG_UTILS_MESSAGE_TYPE_DEVICE_ADDRESS_BINDING_BIT_EXT = 8,
        VK_DEBUG_UTILS_MESSAGE_TYPE_FLAG_BITS_MAX_ENUM_EXT = 2147483647
}

enum VkBlendOverlapEXT: uint32
{
        VK_BLEND_OVERLAP_UNCORRELATED_EXT = 0,
        VK_BLEND_OVERLAP_DISJOINT_EXT = 1,
        VK_BLEND_OVERLAP_CONJOINT_EXT = 2,
        VK_BLEND_OVERLAP_MAX_ENUM_EXT = 2147483647
}

enum VkCoverageModulationModeNV: uint32
{
        VK_COVERAGE_MODULATION_MODE_NONE_NV = 0,
        VK_COVERAGE_MODULATION_MODE_RGB_NV = 1,
        VK_COVERAGE_MODULATION_MODE_ALPHA_NV = 2,
        VK_COVERAGE_MODULATION_MODE_RGBA_NV = 3,
        VK_COVERAGE_MODULATION_MODE_MAX_ENUM_NV = 2147483647
}

enum VkValidationCacheHeaderVersionEXT: uint32
{
        VK_VALIDATION_CACHE_HEADER_VERSION_ONE_EXT = 1,
        VK_VALIDATION_CACHE_HEADER_VERSION_MAX_ENUM_EXT = 2147483647
}

enum VkShadingRatePaletteEntryNV: uint32
{
        VK_SHADING_RATE_PALETTE_ENTRY_NO_INVOCATIONS_NV = 0,
        VK_SHADING_RATE_PALETTE_ENTRY_16_INVOCATIONS_PER_PIXEL_NV = 1,
        VK_SHADING_RATE_PALETTE_ENTRY_8_INVOCATIONS_PER_PIXEL_NV = 2,
        VK_SHADING_RATE_PALETTE_ENTRY_4_INVOCATIONS_PER_PIXEL_NV = 3,
        VK_SHADING_RATE_PALETTE_ENTRY_2_INVOCATIONS_PER_PIXEL_NV = 4,
        VK_SHADING_RATE_PALETTE_ENTRY_1_INVOCATION_PER_PIXEL_NV = 5,
        VK_SHADING_RATE_PALETTE_ENTRY_1_INVOCATION_PER_2X1_PIXELS_NV = 6,
        VK_SHADING_RATE_PALETTE_ENTRY_1_INVOCATION_PER_1X2_PIXELS_NV = 7,
        VK_SHADING_RATE_PALETTE_ENTRY_1_INVOCATION_PER_2X2_PIXELS_NV = 8,
        VK_SHADING_RATE_PALETTE_ENTRY_1_INVOCATION_PER_4X2_PIXELS_NV = 9,
        VK_SHADING_RATE_PALETTE_ENTRY_1_INVOCATION_PER_2X4_PIXELS_NV = 10,
        VK_SHADING_RATE_PALETTE_ENTRY_1_INVOCATION_PER_4X4_PIXELS_NV = 11,
        VK_SHADING_RATE_PALETTE_ENTRY_MAX_ENUM_NV = 2147483647
}

enum VkCoarseSampleOrderTypeNV: uint32
{
        VK_COARSE_SAMPLE_ORDER_TYPE_DEFAULT_NV = 0,
        VK_COARSE_SAMPLE_ORDER_TYPE_CUSTOM_NV = 1,
        VK_COARSE_SAMPLE_ORDER_TYPE_PIXEL_MAJOR_NV = 2,
        VK_COARSE_SAMPLE_ORDER_TYPE_SAMPLE_MAJOR_NV = 3,
        VK_COARSE_SAMPLE_ORDER_TYPE_MAX_ENUM_NV = 2147483647
}

enum VkRayTracingShaderGroupTypeKHR: uint32
{
        VK_RAY_TRACING_SHADER_GROUP_TYPE_GENERAL_KHR = 0,
        VK_RAY_TRACING_SHADER_GROUP_TYPE_TRIANGLES_HIT_GROUP_KHR = 1,
        VK_RAY_TRACING_SHADER_GROUP_TYPE_PROCEDURAL_HIT_GROUP_KHR = 2,
        VK_RAY_TRACING_SHADER_GROUP_TYPE_GENERAL_NV = 0,
        VK_RAY_TRACING_SHADER_GROUP_TYPE_TRIANGLES_HIT_GROUP_NV = 1,
        VK_RAY_TRACING_SHADER_GROUP_TYPE_PROCEDURAL_HIT_GROUP_NV = 2,
        VK_RAY_TRACING_SHADER_GROUP_TYPE_MAX_ENUM_KHR = 2147483647
}

enum VkGeometryTypeKHR: uint32
{
        VK_GEOMETRY_TYPE_TRIANGLES_KHR = 0,
        VK_GEOMETRY_TYPE_AABBS_KHR = 1,
        VK_GEOMETRY_TYPE_INSTANCES_KHR = 2,
        VK_GEOMETRY_TYPE_SPHERES_NV = 1000429004,
        VK_GEOMETRY_TYPE_LINEAR_SWEPT_SPHERES_NV = 1000429005,
        VK_GEOMETRY_TYPE_TRIANGLES_NV = 0,
        VK_GEOMETRY_TYPE_AABBS_NV = 1,
        VK_GEOMETRY_TYPE_MAX_ENUM_KHR = 2147483647
}

enum VkAccelerationStructureTypeKHR: uint32
{
        VK_ACCELERATION_STRUCTURE_TYPE_TOP_LEVEL_KHR = 0,
        VK_ACCELERATION_STRUCTURE_TYPE_BOTTOM_LEVEL_KHR = 1,
        VK_ACCELERATION_STRUCTURE_TYPE_GENERIC_KHR = 2,
        VK_ACCELERATION_STRUCTURE_TYPE_TOP_LEVEL_NV = 0,
        VK_ACCELERATION_STRUCTURE_TYPE_BOTTOM_LEVEL_NV = 1,
        VK_ACCELERATION_STRUCTURE_TYPE_MAX_ENUM_KHR = 2147483647
}

enum VkCopyAccelerationStructureModeKHR: uint32
{
        VK_COPY_ACCELERATION_STRUCTURE_MODE_CLONE_KHR = 0,
        VK_COPY_ACCELERATION_STRUCTURE_MODE_COMPACT_KHR = 1,
        VK_COPY_ACCELERATION_STRUCTURE_MODE_SERIALIZE_KHR = 2,
        VK_COPY_ACCELERATION_STRUCTURE_MODE_DESERIALIZE_KHR = 3,
        VK_COPY_ACCELERATION_STRUCTURE_MODE_CLONE_NV = 0,
        VK_COPY_ACCELERATION_STRUCTURE_MODE_COMPACT_NV = 1,
        VK_COPY_ACCELERATION_STRUCTURE_MODE_MAX_ENUM_KHR = 2147483647
}

enum VkAccelerationStructureMemoryRequirementsTypeNV: uint32
{
        VK_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_TYPE_OBJECT_NV = 0,
        VK_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_TYPE_BUILD_SCRATCH_NV = 1,
        VK_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_TYPE_UPDATE_SCRATCH_NV = 2,
        VK_ACCELERATION_STRUCTURE_MEMORY_REQUIREMENTS_TYPE_MAX_ENUM_NV = 2147483647
}

enum VkGeometryFlagBitsKHR: uint32
{
        VK_GEOMETRY_OPAQUE_BIT_KHR = 1,
        VK_GEOMETRY_NO_DUPLICATE_ANY_HIT_INVOCATION_BIT_KHR = 2,
        VK_GEOMETRY_OPAQUE_BIT_NV = 1,
        VK_GEOMETRY_NO_DUPLICATE_ANY_HIT_INVOCATION_BIT_NV = 2,
        VK_GEOMETRY_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkGeometryInstanceFlagBitsKHR: uint32
{
        VK_GEOMETRY_INSTANCE_TRIANGLE_FACING_CULL_DISABLE_BIT_KHR = 1,
        VK_GEOMETRY_INSTANCE_TRIANGLE_FLIP_FACING_BIT_KHR = 2,
        VK_GEOMETRY_INSTANCE_FORCE_OPAQUE_BIT_KHR = 4,
        VK_GEOMETRY_INSTANCE_FORCE_NO_OPAQUE_BIT_KHR = 8,
        VK_GEOMETRY_INSTANCE_FORCE_OPACITY_MICROMAP_2_STATE_EXT = 16,
        VK_GEOMETRY_INSTANCE_DISABLE_OPACITY_MICROMAPS_EXT = 32,
        VK_GEOMETRY_INSTANCE_TRIANGLE_FRONT_COUNTERCLOCKWISE_BIT_KHR = 2,
        VK_GEOMETRY_INSTANCE_TRIANGLE_CULL_DISABLE_BIT_NV = 1,
        VK_GEOMETRY_INSTANCE_TRIANGLE_FRONT_COUNTERCLOCKWISE_BIT_NV = 2,
        VK_GEOMETRY_INSTANCE_FORCE_OPAQUE_BIT_NV = 4,
        VK_GEOMETRY_INSTANCE_FORCE_NO_OPAQUE_BIT_NV = 8,
        VK_GEOMETRY_INSTANCE_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkBuildAccelerationStructureFlagBitsKHR: uint32
{
        VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_UPDATE_BIT_KHR = 1,
        VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_COMPACTION_BIT_KHR = 2,
        VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_TRACE_BIT_KHR = 4,
        VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_BUILD_BIT_KHR = 8,
        VK_BUILD_ACCELERATION_STRUCTURE_LOW_MEMORY_BIT_KHR = 16,
        VK_BUILD_ACCELERATION_STRUCTURE_MOTION_BIT_NV = 32,
        VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_OPACITY_MICROMAP_UPDATE_EXT = 64,
        VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DISABLE_OPACITY_MICROMAPS_EXT = 128,
        VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_OPACITY_MICROMAP_DATA_UPDATE_EXT = 256,
        VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_DATA_ACCESS_KHR = 2048,
        VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_UPDATE_BIT_NV = 1,
        VK_BUILD_ACCELERATION_STRUCTURE_ALLOW_COMPACTION_BIT_NV = 2,
        VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_TRACE_BIT_NV = 4,
        VK_BUILD_ACCELERATION_STRUCTURE_PREFER_FAST_BUILD_BIT_NV = 8,
        VK_BUILD_ACCELERATION_STRUCTURE_LOW_MEMORY_BIT_NV = 16,
        VK_BUILD_ACCELERATION_STRUCTURE_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkPipelineCompilerControlFlagBitsAMD: uint32
{
        VK_PIPELINE_COMPILER_CONTROL_FLAG_BITS_MAX_ENUM_AMD = 2147483647
}

enum VkMemoryOverallocationBehaviorAMD: uint32
{
        VK_MEMORY_OVERALLOCATION_BEHAVIOR_DEFAULT_AMD = 0,
        VK_MEMORY_OVERALLOCATION_BEHAVIOR_ALLOWED_AMD = 1,
        VK_MEMORY_OVERALLOCATION_BEHAVIOR_DISALLOWED_AMD = 2,
        VK_MEMORY_OVERALLOCATION_BEHAVIOR_MAX_ENUM_AMD = 2147483647
}

enum VkPerformanceConfigurationTypeINTEL: uint32
{
        VK_PERFORMANCE_CONFIGURATION_TYPE_COMMAND_QUEUE_METRICS_DISCOVERY_ACTIVATED_INTEL = 0,
        VK_PERFORMANCE_CONFIGURATION_TYPE_MAX_ENUM_INTEL = 2147483647
}

enum VkQueryPoolSamplingModeINTEL: uint32
{
        VK_QUERY_POOL_SAMPLING_MODE_MANUAL_INTEL = 0,
        VK_QUERY_POOL_SAMPLING_MODE_MAX_ENUM_INTEL = 2147483647
}

enum VkPerformanceOverrideTypeINTEL: uint32
{
        VK_PERFORMANCE_OVERRIDE_TYPE_NULL_HARDWARE_INTEL = 0,
        VK_PERFORMANCE_OVERRIDE_TYPE_FLUSH_GPU_CACHES_INTEL = 1,
        VK_PERFORMANCE_OVERRIDE_TYPE_MAX_ENUM_INTEL = 2147483647
}

enum VkPerformanceParameterTypeINTEL: uint32
{
        VK_PERFORMANCE_PARAMETER_TYPE_HW_COUNTERS_SUPPORTED_INTEL = 0,
        VK_PERFORMANCE_PARAMETER_TYPE_STREAM_MARKER_VALID_BITS_INTEL = 1,
        VK_PERFORMANCE_PARAMETER_TYPE_MAX_ENUM_INTEL = 2147483647
}

enum VkPerformanceValueTypeINTEL: uint32
{
        VK_PERFORMANCE_VALUE_TYPE_UINT32_INTEL = 0,
        VK_PERFORMANCE_VALUE_TYPE_UINT64_INTEL = 1,
        VK_PERFORMANCE_VALUE_TYPE_FLOAT_INTEL = 2,
        VK_PERFORMANCE_VALUE_TYPE_BOOL_INTEL = 3,
        VK_PERFORMANCE_VALUE_TYPE_STRING_INTEL = 4,
        VK_PERFORMANCE_VALUE_TYPE_MAX_ENUM_INTEL = 2147483647
}

enum VkShaderCorePropertiesFlagBitsAMD: uint32
{
        VK_SHADER_CORE_PROPERTIES_FLAG_BITS_MAX_ENUM_AMD = 2147483647
}

enum VkValidationFeatureEnableEXT: uint32
{
        VK_VALIDATION_FEATURE_ENABLE_GPU_ASSISTED_EXT = 0,
        VK_VALIDATION_FEATURE_ENABLE_GPU_ASSISTED_RESERVE_BINDING_SLOT_EXT = 1,
        VK_VALIDATION_FEATURE_ENABLE_BEST_PRACTICES_EXT = 2,
        VK_VALIDATION_FEATURE_ENABLE_DEBUG_PRINTF_EXT = 3,
        VK_VALIDATION_FEATURE_ENABLE_SYNCHRONIZATION_VALIDATION_EXT = 4,
        VK_VALIDATION_FEATURE_ENABLE_MAX_ENUM_EXT = 2147483647
}

enum VkValidationFeatureDisableEXT: uint32
{
        VK_VALIDATION_FEATURE_DISABLE_ALL_EXT = 0,
        VK_VALIDATION_FEATURE_DISABLE_SHADERS_EXT = 1,
        VK_VALIDATION_FEATURE_DISABLE_THREAD_SAFETY_EXT = 2,
        VK_VALIDATION_FEATURE_DISABLE_API_PARAMETERS_EXT = 3,
        VK_VALIDATION_FEATURE_DISABLE_OBJECT_LIFETIMES_EXT = 4,
        VK_VALIDATION_FEATURE_DISABLE_CORE_CHECKS_EXT = 5,
        VK_VALIDATION_FEATURE_DISABLE_UNIQUE_HANDLES_EXT = 6,
        VK_VALIDATION_FEATURE_DISABLE_SHADER_VALIDATION_CACHE_EXT = 7,
        VK_VALIDATION_FEATURE_DISABLE_MAX_ENUM_EXT = 2147483647
}

enum VkCoverageReductionModeNV: uint32
{
        VK_COVERAGE_REDUCTION_MODE_MERGE_NV = 0,
        VK_COVERAGE_REDUCTION_MODE_TRUNCATE_NV = 1,
        VK_COVERAGE_REDUCTION_MODE_MAX_ENUM_NV = 2147483647
}

enum VkProvokingVertexModeEXT: uint32
{
        VK_PROVOKING_VERTEX_MODE_FIRST_VERTEX_EXT = 0,
        VK_PROVOKING_VERTEX_MODE_LAST_VERTEX_EXT = 1,
        VK_PROVOKING_VERTEX_MODE_MAX_ENUM_EXT = 2147483647
}

enum VkPresentScalingFlagBitsEXT: uint32
{
        VK_PRESENT_SCALING_ONE_TO_ONE_BIT_EXT = 1,
        VK_PRESENT_SCALING_ASPECT_RATIO_STRETCH_BIT_EXT = 2,
        VK_PRESENT_SCALING_STRETCH_BIT_EXT = 4,
        VK_PRESENT_SCALING_FLAG_BITS_MAX_ENUM_EXT = 2147483647
}

enum VkPresentGravityFlagBitsEXT: uint32
{
        VK_PRESENT_GRAVITY_MIN_BIT_EXT = 1,
        VK_PRESENT_GRAVITY_MAX_BIT_EXT = 2,
        VK_PRESENT_GRAVITY_CENTERED_BIT_EXT = 4,
        VK_PRESENT_GRAVITY_FLAG_BITS_MAX_ENUM_EXT = 2147483647
}

enum VkIndirectCommandsTokenTypeNV: uint32
{
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_SHADER_GROUP_NV = 0,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_STATE_FLAGS_NV = 1,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_INDEX_BUFFER_NV = 2,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_VERTEX_BUFFER_NV = 3,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_PUSH_CONSTANT_NV = 4,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_INDEXED_NV = 5,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_NV = 6,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_TASKS_NV = 7,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_NV = 1000328000,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_PIPELINE_NV = 1000428003,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_DISPATCH_NV = 1000428004,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_MAX_ENUM_NV = 2147483647
}

enum VkIndirectStateFlagBitsNV: uint32
{
        VK_INDIRECT_STATE_FLAG_FRONTFACE_BIT_NV = 1,
        VK_INDIRECT_STATE_FLAG_BITS_MAX_ENUM_NV = 2147483647
}

enum VkIndirectCommandsLayoutUsageFlagBitsNV: uint32
{
        VK_INDIRECT_COMMANDS_LAYOUT_USAGE_EXPLICIT_PREPROCESS_BIT_NV = 1,
        VK_INDIRECT_COMMANDS_LAYOUT_USAGE_INDEXED_SEQUENCES_BIT_NV = 2,
        VK_INDIRECT_COMMANDS_LAYOUT_USAGE_UNORDERED_SEQUENCES_BIT_NV = 4,
        VK_INDIRECT_COMMANDS_LAYOUT_USAGE_FLAG_BITS_MAX_ENUM_NV = 2147483647
}

enum VkDepthBiasRepresentationEXT: uint32
{
        VK_DEPTH_BIAS_REPRESENTATION_LEAST_REPRESENTABLE_VALUE_FORMAT_EXT = 0,
        VK_DEPTH_BIAS_REPRESENTATION_LEAST_REPRESENTABLE_VALUE_FORCE_UNORM_EXT = 1,
        VK_DEPTH_BIAS_REPRESENTATION_FLOAT_EXT = 2,
        VK_DEPTH_BIAS_REPRESENTATION_MAX_ENUM_EXT = 2147483647
}

enum VkDeviceMemoryReportEventTypeEXT: uint32
{
        VK_DEVICE_MEMORY_REPORT_EVENT_TYPE_ALLOCATE_EXT = 0,
        VK_DEVICE_MEMORY_REPORT_EVENT_TYPE_FREE_EXT = 1,
        VK_DEVICE_MEMORY_REPORT_EVENT_TYPE_IMPORT_EXT = 2,
        VK_DEVICE_MEMORY_REPORT_EVENT_TYPE_UNIMPORT_EXT = 3,
        VK_DEVICE_MEMORY_REPORT_EVENT_TYPE_ALLOCATION_FAILED_EXT = 4,
        VK_DEVICE_MEMORY_REPORT_EVENT_TYPE_MAX_ENUM_EXT = 2147483647
}

enum VkDeviceDiagnosticsConfigFlagBitsNV: uint32
{
        VK_DEVICE_DIAGNOSTICS_CONFIG_ENABLE_SHADER_DEBUG_INFO_BIT_NV = 1,
        VK_DEVICE_DIAGNOSTICS_CONFIG_ENABLE_RESOURCE_TRACKING_BIT_NV = 2,
        VK_DEVICE_DIAGNOSTICS_CONFIG_ENABLE_AUTOMATIC_CHECKPOINTS_BIT_NV = 4,
        VK_DEVICE_DIAGNOSTICS_CONFIG_ENABLE_SHADER_ERROR_REPORTING_BIT_NV = 8,
        VK_DEVICE_DIAGNOSTICS_CONFIG_FLAG_BITS_MAX_ENUM_NV = 2147483647
}

enum VkGraphicsPipelineLibraryFlagBitsEXT: uint32
{
        VK_GRAPHICS_PIPELINE_LIBRARY_VERTEX_INPUT_INTERFACE_BIT_EXT = 1,
        VK_GRAPHICS_PIPELINE_LIBRARY_PRE_RASTERIZATION_SHADERS_BIT_EXT = 2,
        VK_GRAPHICS_PIPELINE_LIBRARY_FRAGMENT_SHADER_BIT_EXT = 4,
        VK_GRAPHICS_PIPELINE_LIBRARY_FRAGMENT_OUTPUT_INTERFACE_BIT_EXT = 8,
        VK_GRAPHICS_PIPELINE_LIBRARY_FLAG_BITS_MAX_ENUM_EXT = 2147483647
}

enum VkFragmentShadingRateTypeNV: uint32
{
        VK_FRAGMENT_SHADING_RATE_TYPE_FRAGMENT_SIZE_NV = 0,
        VK_FRAGMENT_SHADING_RATE_TYPE_ENUMS_NV = 1,
        VK_FRAGMENT_SHADING_RATE_TYPE_MAX_ENUM_NV = 2147483647
}

enum VkFragmentShadingRateNV: uint32
{
        VK_FRAGMENT_SHADING_RATE_1_INVOCATION_PER_PIXEL_NV = 0,
        VK_FRAGMENT_SHADING_RATE_1_INVOCATION_PER_1X2_PIXELS_NV = 1,
        VK_FRAGMENT_SHADING_RATE_1_INVOCATION_PER_2X1_PIXELS_NV = 4,
        VK_FRAGMENT_SHADING_RATE_1_INVOCATION_PER_2X2_PIXELS_NV = 5,
        VK_FRAGMENT_SHADING_RATE_1_INVOCATION_PER_2X4_PIXELS_NV = 6,
        VK_FRAGMENT_SHADING_RATE_1_INVOCATION_PER_4X2_PIXELS_NV = 9,
        VK_FRAGMENT_SHADING_RATE_1_INVOCATION_PER_4X4_PIXELS_NV = 10,
        VK_FRAGMENT_SHADING_RATE_2_INVOCATIONS_PER_PIXEL_NV = 11,
        VK_FRAGMENT_SHADING_RATE_4_INVOCATIONS_PER_PIXEL_NV = 12,
        VK_FRAGMENT_SHADING_RATE_8_INVOCATIONS_PER_PIXEL_NV = 13,
        VK_FRAGMENT_SHADING_RATE_16_INVOCATIONS_PER_PIXEL_NV = 14,
        VK_FRAGMENT_SHADING_RATE_NO_INVOCATIONS_NV = 15,
        VK_FRAGMENT_SHADING_RATE_MAX_ENUM_NV = 2147483647
}

enum VkAccelerationStructureMotionInstanceTypeNV: uint32
{
        VK_ACCELERATION_STRUCTURE_MOTION_INSTANCE_TYPE_STATIC_NV = 0,
        VK_ACCELERATION_STRUCTURE_MOTION_INSTANCE_TYPE_MATRIX_MOTION_NV = 1,
        VK_ACCELERATION_STRUCTURE_MOTION_INSTANCE_TYPE_SRT_MOTION_NV = 2,
        VK_ACCELERATION_STRUCTURE_MOTION_INSTANCE_TYPE_MAX_ENUM_NV = 2147483647
}

enum VkImageCompressionFlagBitsEXT: uint32
{
        VK_IMAGE_COMPRESSION_DEFAULT_EXT = 0,
        VK_IMAGE_COMPRESSION_FIXED_RATE_DEFAULT_EXT = 1,
        VK_IMAGE_COMPRESSION_FIXED_RATE_EXPLICIT_EXT = 2,
        VK_IMAGE_COMPRESSION_DISABLED_EXT = 4,
        VK_IMAGE_COMPRESSION_FLAG_BITS_MAX_ENUM_EXT = 2147483647
}

enum VkImageCompressionFixedRateFlagBitsEXT: uint32
{
        VK_IMAGE_COMPRESSION_FIXED_RATE_NONE_EXT = 0,
        VK_IMAGE_COMPRESSION_FIXED_RATE_1BPC_BIT_EXT = 1,
        VK_IMAGE_COMPRESSION_FIXED_RATE_2BPC_BIT_EXT = 2,
        VK_IMAGE_COMPRESSION_FIXED_RATE_3BPC_BIT_EXT = 4,
        VK_IMAGE_COMPRESSION_FIXED_RATE_4BPC_BIT_EXT = 8,
        VK_IMAGE_COMPRESSION_FIXED_RATE_5BPC_BIT_EXT = 16,
        VK_IMAGE_COMPRESSION_FIXED_RATE_6BPC_BIT_EXT = 32,
        VK_IMAGE_COMPRESSION_FIXED_RATE_7BPC_BIT_EXT = 64,
        VK_IMAGE_COMPRESSION_FIXED_RATE_8BPC_BIT_EXT = 128,
        VK_IMAGE_COMPRESSION_FIXED_RATE_9BPC_BIT_EXT = 256,
        VK_IMAGE_COMPRESSION_FIXED_RATE_10BPC_BIT_EXT = 512,
        VK_IMAGE_COMPRESSION_FIXED_RATE_11BPC_BIT_EXT = 1024,
        VK_IMAGE_COMPRESSION_FIXED_RATE_12BPC_BIT_EXT = 2048,
        VK_IMAGE_COMPRESSION_FIXED_RATE_13BPC_BIT_EXT = 4096,
        VK_IMAGE_COMPRESSION_FIXED_RATE_14BPC_BIT_EXT = 8192,
        VK_IMAGE_COMPRESSION_FIXED_RATE_15BPC_BIT_EXT = 16384,
        VK_IMAGE_COMPRESSION_FIXED_RATE_16BPC_BIT_EXT = 32768,
        VK_IMAGE_COMPRESSION_FIXED_RATE_17BPC_BIT_EXT = 65536,
        VK_IMAGE_COMPRESSION_FIXED_RATE_18BPC_BIT_EXT = 131072,
        VK_IMAGE_COMPRESSION_FIXED_RATE_19BPC_BIT_EXT = 262144,
        VK_IMAGE_COMPRESSION_FIXED_RATE_20BPC_BIT_EXT = 524288,
        VK_IMAGE_COMPRESSION_FIXED_RATE_21BPC_BIT_EXT = 1048576,
        VK_IMAGE_COMPRESSION_FIXED_RATE_22BPC_BIT_EXT = 2097152,
        VK_IMAGE_COMPRESSION_FIXED_RATE_23BPC_BIT_EXT = 4194304,
        VK_IMAGE_COMPRESSION_FIXED_RATE_24BPC_BIT_EXT = 8388608,
        VK_IMAGE_COMPRESSION_FIXED_RATE_FLAG_BITS_MAX_ENUM_EXT = 2147483647
}

enum VkDeviceFaultAddressTypeEXT: uint32
{
        VK_DEVICE_FAULT_ADDRESS_TYPE_NONE_EXT = 0,
        VK_DEVICE_FAULT_ADDRESS_TYPE_READ_INVALID_EXT = 1,
        VK_DEVICE_FAULT_ADDRESS_TYPE_WRITE_INVALID_EXT = 2,
        VK_DEVICE_FAULT_ADDRESS_TYPE_EXECUTE_INVALID_EXT = 3,
        VK_DEVICE_FAULT_ADDRESS_TYPE_INSTRUCTION_POINTER_UNKNOWN_EXT = 4,
        VK_DEVICE_FAULT_ADDRESS_TYPE_INSTRUCTION_POINTER_INVALID_EXT = 5,
        VK_DEVICE_FAULT_ADDRESS_TYPE_INSTRUCTION_POINTER_FAULT_EXT = 6,
        VK_DEVICE_FAULT_ADDRESS_TYPE_MAX_ENUM_EXT = 2147483647
}

enum VkDeviceFaultVendorBinaryHeaderVersionEXT: uint32
{
        VK_DEVICE_FAULT_VENDOR_BINARY_HEADER_VERSION_ONE_EXT = 1,
        VK_DEVICE_FAULT_VENDOR_BINARY_HEADER_VERSION_MAX_ENUM_EXT = 2147483647
}

enum VkDeviceAddressBindingTypeEXT: uint32
{
        VK_DEVICE_ADDRESS_BINDING_TYPE_BIND_EXT = 0,
        VK_DEVICE_ADDRESS_BINDING_TYPE_UNBIND_EXT = 1,
        VK_DEVICE_ADDRESS_BINDING_TYPE_MAX_ENUM_EXT = 2147483647
}

enum VkDeviceAddressBindingFlagBitsEXT: uint32
{
        VK_DEVICE_ADDRESS_BINDING_INTERNAL_OBJECT_BIT_EXT = 1,
        VK_DEVICE_ADDRESS_BINDING_FLAG_BITS_MAX_ENUM_EXT = 2147483647
}

enum VkFrameBoundaryFlagBitsEXT: uint32
{
        VK_FRAME_BOUNDARY_FRAME_END_BIT_EXT = 1,
        VK_FRAME_BOUNDARY_FLAG_BITS_MAX_ENUM_EXT = 2147483647
}

enum VkMicromapTypeEXT: uint32
{
        VK_MICROMAP_TYPE_OPACITY_MICROMAP_EXT = 0,
        VK_MICROMAP_TYPE_MAX_ENUM_EXT = 2147483647
}

enum VkBuildMicromapModeEXT: uint32
{
        VK_BUILD_MICROMAP_MODE_BUILD_EXT = 0,
        VK_BUILD_MICROMAP_MODE_MAX_ENUM_EXT = 2147483647
}

enum VkCopyMicromapModeEXT: uint32
{
        VK_COPY_MICROMAP_MODE_CLONE_EXT = 0,
        VK_COPY_MICROMAP_MODE_SERIALIZE_EXT = 1,
        VK_COPY_MICROMAP_MODE_DESERIALIZE_EXT = 2,
        VK_COPY_MICROMAP_MODE_COMPACT_EXT = 3,
        VK_COPY_MICROMAP_MODE_MAX_ENUM_EXT = 2147483647
}

enum VkOpacityMicromapFormatEXT: uint32
{
        VK_OPACITY_MICROMAP_FORMAT_2_STATE_EXT = 1,
        VK_OPACITY_MICROMAP_FORMAT_4_STATE_EXT = 2,
        VK_OPACITY_MICROMAP_FORMAT_MAX_ENUM_EXT = 2147483647
}

enum VkOpacityMicromapSpecialIndexEXT: uint32
{
        VK_OPACITY_MICROMAP_SPECIAL_INDEX_FULLY_TRANSPARENT_EXT = 4294967295,
        VK_OPACITY_MICROMAP_SPECIAL_INDEX_FULLY_OPAQUE_EXT = 4294967294,
        VK_OPACITY_MICROMAP_SPECIAL_INDEX_FULLY_UNKNOWN_TRANSPARENT_EXT = 4294967293,
        VK_OPACITY_MICROMAP_SPECIAL_INDEX_FULLY_UNKNOWN_OPAQUE_EXT = 4294967292,
        VK_OPACITY_MICROMAP_SPECIAL_INDEX_CLUSTER_GEOMETRY_DISABLE_OPACITY_MICROMAP_NV = 4294967291,
        VK_OPACITY_MICROMAP_SPECIAL_INDEX_MAX_ENUM_EXT = 2147483647
}

enum VkAccelerationStructureCompatibilityKHR: uint32
{
        VK_ACCELERATION_STRUCTURE_COMPATIBILITY_COMPATIBLE_KHR = 0,
        VK_ACCELERATION_STRUCTURE_COMPATIBILITY_INCOMPATIBLE_KHR = 1,
        VK_ACCELERATION_STRUCTURE_COMPATIBILITY_MAX_ENUM_KHR = 2147483647
}

enum VkAccelerationStructureBuildTypeKHR: uint32
{
        VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_KHR = 0,
        VK_ACCELERATION_STRUCTURE_BUILD_TYPE_DEVICE_KHR = 1,
        VK_ACCELERATION_STRUCTURE_BUILD_TYPE_HOST_OR_DEVICE_KHR = 2,
        VK_ACCELERATION_STRUCTURE_BUILD_TYPE_MAX_ENUM_KHR = 2147483647
}

enum VkBuildMicromapFlagBitsEXT: uint32
{
        VK_BUILD_MICROMAP_PREFER_FAST_TRACE_BIT_EXT = 1,
        VK_BUILD_MICROMAP_PREFER_FAST_BUILD_BIT_EXT = 2,
        VK_BUILD_MICROMAP_ALLOW_COMPACTION_BIT_EXT = 4,
        VK_BUILD_MICROMAP_FLAG_BITS_MAX_ENUM_EXT = 2147483647
}

enum VkMicromapCreateFlagBitsEXT: uint32
{
        VK_MICROMAP_CREATE_DEVICE_ADDRESS_CAPTURE_REPLAY_BIT_EXT = 1,
        VK_MICROMAP_CREATE_FLAG_BITS_MAX_ENUM_EXT = 2147483647
}

enum VkRayTracingLssIndexingModeNV: uint32
{
        VK_RAY_TRACING_LSS_INDEXING_MODE_LIST_NV = 0,
        VK_RAY_TRACING_LSS_INDEXING_MODE_SUCCESSIVE_NV = 1,
        VK_RAY_TRACING_LSS_INDEXING_MODE_MAX_ENUM_NV = 2147483647
}

enum VkRayTracingLssPrimitiveEndCapsModeNV: uint32
{
        VK_RAY_TRACING_LSS_PRIMITIVE_END_CAPS_MODE_NONE_NV = 0,
        VK_RAY_TRACING_LSS_PRIMITIVE_END_CAPS_MODE_CHAINED_NV = 1,
        VK_RAY_TRACING_LSS_PRIMITIVE_END_CAPS_MODE_MAX_ENUM_NV = 2147483647
}

enum VkSubpassMergeStatusEXT: uint32
{
        VK_SUBPASS_MERGE_STATUS_MERGED_EXT = 0,
        VK_SUBPASS_MERGE_STATUS_DISALLOWED_EXT = 1,
        VK_SUBPASS_MERGE_STATUS_NOT_MERGED_SIDE_EFFECTS_EXT = 2,
        VK_SUBPASS_MERGE_STATUS_NOT_MERGED_SAMPLES_MISMATCH_EXT = 3,
        VK_SUBPASS_MERGE_STATUS_NOT_MERGED_VIEWS_MISMATCH_EXT = 4,
        VK_SUBPASS_MERGE_STATUS_NOT_MERGED_ALIASING_EXT = 5,
        VK_SUBPASS_MERGE_STATUS_NOT_MERGED_DEPENDENCIES_EXT = 6,
        VK_SUBPASS_MERGE_STATUS_NOT_MERGED_INCOMPATIBLE_INPUT_ATTACHMENT_EXT = 7,
        VK_SUBPASS_MERGE_STATUS_NOT_MERGED_TOO_MANY_ATTACHMENTS_EXT = 8,
        VK_SUBPASS_MERGE_STATUS_NOT_MERGED_INSUFFICIENT_STORAGE_EXT = 9,
        VK_SUBPASS_MERGE_STATUS_NOT_MERGED_DEPTH_STENCIL_COUNT_EXT = 10,
        VK_SUBPASS_MERGE_STATUS_NOT_MERGED_RESOLVE_ATTACHMENT_REUSE_EXT = 11,
        VK_SUBPASS_MERGE_STATUS_NOT_MERGED_SINGLE_SUBPASS_EXT = 12,
        VK_SUBPASS_MERGE_STATUS_NOT_MERGED_UNSPECIFIED_EXT = 13,
        VK_SUBPASS_MERGE_STATUS_MAX_ENUM_EXT = 2147483647
}

enum VkDirectDriverLoadingModeLUNARG: uint32
{
        VK_DIRECT_DRIVER_LOADING_MODE_EXCLUSIVE_LUNARG = 0,
        VK_DIRECT_DRIVER_LOADING_MODE_INCLUSIVE_LUNARG = 1,
        VK_DIRECT_DRIVER_LOADING_MODE_MAX_ENUM_LUNARG = 2147483647
}

enum VkOpticalFlowPerformanceLevelNV: uint32
{
        VK_OPTICAL_FLOW_PERFORMANCE_LEVEL_UNKNOWN_NV = 0,
        VK_OPTICAL_FLOW_PERFORMANCE_LEVEL_SLOW_NV = 1,
        VK_OPTICAL_FLOW_PERFORMANCE_LEVEL_MEDIUM_NV = 2,
        VK_OPTICAL_FLOW_PERFORMANCE_LEVEL_FAST_NV = 3,
        VK_OPTICAL_FLOW_PERFORMANCE_LEVEL_MAX_ENUM_NV = 2147483647
}

enum VkOpticalFlowSessionBindingPointNV: uint32
{
        VK_OPTICAL_FLOW_SESSION_BINDING_POINT_UNKNOWN_NV = 0,
        VK_OPTICAL_FLOW_SESSION_BINDING_POINT_INPUT_NV = 1,
        VK_OPTICAL_FLOW_SESSION_BINDING_POINT_REFERENCE_NV = 2,
        VK_OPTICAL_FLOW_SESSION_BINDING_POINT_HINT_NV = 3,
        VK_OPTICAL_FLOW_SESSION_BINDING_POINT_FLOW_VECTOR_NV = 4,
        VK_OPTICAL_FLOW_SESSION_BINDING_POINT_BACKWARD_FLOW_VECTOR_NV = 5,
        VK_OPTICAL_FLOW_SESSION_BINDING_POINT_COST_NV = 6,
        VK_OPTICAL_FLOW_SESSION_BINDING_POINT_BACKWARD_COST_NV = 7,
        VK_OPTICAL_FLOW_SESSION_BINDING_POINT_GLOBAL_FLOW_NV = 8,
        VK_OPTICAL_FLOW_SESSION_BINDING_POINT_MAX_ENUM_NV = 2147483647
}

enum VkOpticalFlowGridSizeFlagBitsNV: uint32
{
        VK_OPTICAL_FLOW_GRID_SIZE_UNKNOWN_NV = 0,
        VK_OPTICAL_FLOW_GRID_SIZE_1X1_BIT_NV = 1,
        VK_OPTICAL_FLOW_GRID_SIZE_2X2_BIT_NV = 2,
        VK_OPTICAL_FLOW_GRID_SIZE_4X4_BIT_NV = 4,
        VK_OPTICAL_FLOW_GRID_SIZE_8X8_BIT_NV = 8,
        VK_OPTICAL_FLOW_GRID_SIZE_FLAG_BITS_MAX_ENUM_NV = 2147483647
}

enum VkOpticalFlowUsageFlagBitsNV: uint32
{
        VK_OPTICAL_FLOW_USAGE_UNKNOWN_NV = 0,
        VK_OPTICAL_FLOW_USAGE_INPUT_BIT_NV = 1,
        VK_OPTICAL_FLOW_USAGE_OUTPUT_BIT_NV = 2,
        VK_OPTICAL_FLOW_USAGE_HINT_BIT_NV = 4,
        VK_OPTICAL_FLOW_USAGE_COST_BIT_NV = 8,
        VK_OPTICAL_FLOW_USAGE_GLOBAL_FLOW_BIT_NV = 16,
        VK_OPTICAL_FLOW_USAGE_FLAG_BITS_MAX_ENUM_NV = 2147483647
}

enum VkOpticalFlowSessionCreateFlagBitsNV: uint32
{
        VK_OPTICAL_FLOW_SESSION_CREATE_ENABLE_HINT_BIT_NV = 1,
        VK_OPTICAL_FLOW_SESSION_CREATE_ENABLE_COST_BIT_NV = 2,
        VK_OPTICAL_FLOW_SESSION_CREATE_ENABLE_GLOBAL_FLOW_BIT_NV = 4,
        VK_OPTICAL_FLOW_SESSION_CREATE_ALLOW_REGIONS_BIT_NV = 8,
        VK_OPTICAL_FLOW_SESSION_CREATE_BOTH_DIRECTIONS_BIT_NV = 16,
        VK_OPTICAL_FLOW_SESSION_CREATE_FLAG_BITS_MAX_ENUM_NV = 2147483647
}

enum VkOpticalFlowExecuteFlagBitsNV: uint32
{
        VK_OPTICAL_FLOW_EXECUTE_DISABLE_TEMPORAL_HINTS_BIT_NV = 1,
        VK_OPTICAL_FLOW_EXECUTE_FLAG_BITS_MAX_ENUM_NV = 2147483647
}

enum VkAntiLagModeAMD: uint32
{
        VK_ANTI_LAG_MODE_DRIVER_CONTROL_AMD = 0,
        VK_ANTI_LAG_MODE_ON_AMD = 1,
        VK_ANTI_LAG_MODE_OFF_AMD = 2,
        VK_ANTI_LAG_MODE_MAX_ENUM_AMD = 2147483647
}

enum VkAntiLagStageAMD: uint32
{
        VK_ANTI_LAG_STAGE_INPUT_AMD = 0,
        VK_ANTI_LAG_STAGE_PRESENT_AMD = 1,
        VK_ANTI_LAG_STAGE_MAX_ENUM_AMD = 2147483647
}

enum VkShaderCodeTypeEXT: uint32
{
        VK_SHADER_CODE_TYPE_BINARY_EXT = 0,
        VK_SHADER_CODE_TYPE_SPIRV_EXT = 1,
        VK_SHADER_CODE_TYPE_MAX_ENUM_EXT = 2147483647
}

enum VkDepthClampModeEXT: uint32
{
        VK_DEPTH_CLAMP_MODE_VIEWPORT_RANGE_EXT = 0,
        VK_DEPTH_CLAMP_MODE_USER_DEFINED_RANGE_EXT = 1,
        VK_DEPTH_CLAMP_MODE_MAX_ENUM_EXT = 2147483647
}

enum VkShaderCreateFlagBitsEXT: uint32
{
        VK_SHADER_CREATE_LINK_STAGE_BIT_EXT = 1,
        VK_SHADER_CREATE_ALLOW_VARYING_SUBGROUP_SIZE_BIT_EXT = 2,
        VK_SHADER_CREATE_REQUIRE_FULL_SUBGROUPS_BIT_EXT = 4,
        VK_SHADER_CREATE_NO_TASK_SHADER_BIT_EXT = 8,
        VK_SHADER_CREATE_DISPATCH_BASE_BIT_EXT = 16,
        VK_SHADER_CREATE_FRAGMENT_SHADING_RATE_ATTACHMENT_BIT_EXT = 32,
        VK_SHADER_CREATE_FRAGMENT_DENSITY_MAP_ATTACHMENT_BIT_EXT = 64,
        VK_SHADER_CREATE_INDIRECT_BINDABLE_BIT_EXT = 128,
        VK_SHADER_CREATE_FLAG_BITS_MAX_ENUM_EXT = 2147483647
}

enum VkRayTracingInvocationReorderModeNV: uint32
{
        VK_RAY_TRACING_INVOCATION_REORDER_MODE_NONE_NV = 0,
        VK_RAY_TRACING_INVOCATION_REORDER_MODE_REORDER_NV = 1,
        VK_RAY_TRACING_INVOCATION_REORDER_MODE_MAX_ENUM_NV = 2147483647
}

enum VkCooperativeVectorMatrixLayoutNV: uint32
{
        VK_COOPERATIVE_VECTOR_MATRIX_LAYOUT_ROW_MAJOR_NV = 0,
        VK_COOPERATIVE_VECTOR_MATRIX_LAYOUT_COLUMN_MAJOR_NV = 1,
        VK_COOPERATIVE_VECTOR_MATRIX_LAYOUT_INFERENCING_OPTIMAL_NV = 2,
        VK_COOPERATIVE_VECTOR_MATRIX_LAYOUT_TRAINING_OPTIMAL_NV = 3,
        VK_COOPERATIVE_VECTOR_MATRIX_LAYOUT_MAX_ENUM_NV = 2147483647
}

enum VkLayerSettingTypeEXT: uint32
{
        VK_LAYER_SETTING_TYPE_BOOL32_EXT = 0,
        VK_LAYER_SETTING_TYPE_INT32_EXT = 1,
        VK_LAYER_SETTING_TYPE_INT64_EXT = 2,
        VK_LAYER_SETTING_TYPE_UINT32_EXT = 3,
        VK_LAYER_SETTING_TYPE_UINT64_EXT = 4,
        VK_LAYER_SETTING_TYPE_FLOAT32_EXT = 5,
        VK_LAYER_SETTING_TYPE_FLOAT64_EXT = 6,
        VK_LAYER_SETTING_TYPE_STRING_EXT = 7,
        VK_LAYER_SETTING_TYPE_MAX_ENUM_EXT = 2147483647
}

enum VkLatencyMarkerNV: uint32
{
        VK_LATENCY_MARKER_SIMULATION_START_NV = 0,
        VK_LATENCY_MARKER_SIMULATION_END_NV = 1,
        VK_LATENCY_MARKER_RENDERSUBMIT_START_NV = 2,
        VK_LATENCY_MARKER_RENDERSUBMIT_END_NV = 3,
        VK_LATENCY_MARKER_PRESENT_START_NV = 4,
        VK_LATENCY_MARKER_PRESENT_END_NV = 5,
        VK_LATENCY_MARKER_INPUT_SAMPLE_NV = 6,
        VK_LATENCY_MARKER_TRIGGER_FLASH_NV = 7,
        VK_LATENCY_MARKER_OUT_OF_BAND_RENDERSUBMIT_START_NV = 8,
        VK_LATENCY_MARKER_OUT_OF_BAND_RENDERSUBMIT_END_NV = 9,
        VK_LATENCY_MARKER_OUT_OF_BAND_PRESENT_START_NV = 10,
        VK_LATENCY_MARKER_OUT_OF_BAND_PRESENT_END_NV = 11,
        VK_LATENCY_MARKER_MAX_ENUM_NV = 2147483647
}

enum VkOutOfBandQueueTypeNV: uint32
{
        VK_OUT_OF_BAND_QUEUE_TYPE_RENDER_NV = 0,
        VK_OUT_OF_BAND_QUEUE_TYPE_PRESENT_NV = 1,
        VK_OUT_OF_BAND_QUEUE_TYPE_MAX_ENUM_NV = 2147483647
}

enum VkBlockMatchWindowCompareModeQCOM: uint32
{
        VK_BLOCK_MATCH_WINDOW_COMPARE_MODE_MIN_QCOM = 0,
        VK_BLOCK_MATCH_WINDOW_COMPARE_MODE_MAX_QCOM = 1,
        VK_BLOCK_MATCH_WINDOW_COMPARE_MODE_MAX_ENUM_QCOM = 2147483647
}

enum VkCubicFilterWeightsQCOM: uint32
{
        VK_CUBIC_FILTER_WEIGHTS_CATMULL_ROM_QCOM = 0,
        VK_CUBIC_FILTER_WEIGHTS_ZERO_TANGENT_CARDINAL_QCOM = 1,
        VK_CUBIC_FILTER_WEIGHTS_B_SPLINE_QCOM = 2,
        VK_CUBIC_FILTER_WEIGHTS_MITCHELL_NETRAVALI_QCOM = 3,
        VK_CUBIC_FILTER_WEIGHTS_MAX_ENUM_QCOM = 2147483647
}

enum VkLayeredDriverUnderlyingApiMSFT: uint32
{
        VK_LAYERED_DRIVER_UNDERLYING_API_NONE_MSFT = 0,
        VK_LAYERED_DRIVER_UNDERLYING_API_D3D12_MSFT = 1,
        VK_LAYERED_DRIVER_UNDERLYING_API_MAX_ENUM_MSFT = 2147483647
}

enum VkDisplaySurfaceStereoTypeNV: uint32
{
        VK_DISPLAY_SURFACE_STEREO_TYPE_NONE_NV = 0,
        VK_DISPLAY_SURFACE_STEREO_TYPE_ONBOARD_DIN_NV = 1,
        VK_DISPLAY_SURFACE_STEREO_TYPE_HDMI_3D_NV = 2,
        VK_DISPLAY_SURFACE_STEREO_TYPE_INBAND_DISPLAYPORT_NV = 3,
        VK_DISPLAY_SURFACE_STEREO_TYPE_MAX_ENUM_NV = 2147483647
}

enum VkClusterAccelerationStructureTypeNV: uint32
{
        VK_CLUSTER_ACCELERATION_STRUCTURE_TYPE_CLUSTERS_BOTTOM_LEVEL_NV = 0,
        VK_CLUSTER_ACCELERATION_STRUCTURE_TYPE_TRIANGLE_CLUSTER_NV = 1,
        VK_CLUSTER_ACCELERATION_STRUCTURE_TYPE_TRIANGLE_CLUSTER_TEMPLATE_NV = 2,
        VK_CLUSTER_ACCELERATION_STRUCTURE_TYPE_MAX_ENUM_NV = 2147483647
}

enum VkClusterAccelerationStructureOpTypeNV: uint32
{
        VK_CLUSTER_ACCELERATION_STRUCTURE_OP_TYPE_MOVE_OBJECTS_NV = 0,
        VK_CLUSTER_ACCELERATION_STRUCTURE_OP_TYPE_BUILD_CLUSTERS_BOTTOM_LEVEL_NV = 1,
        VK_CLUSTER_ACCELERATION_STRUCTURE_OP_TYPE_BUILD_TRIANGLE_CLUSTER_NV = 2,
        VK_CLUSTER_ACCELERATION_STRUCTURE_OP_TYPE_BUILD_TRIANGLE_CLUSTER_TEMPLATE_NV = 3,
        VK_CLUSTER_ACCELERATION_STRUCTURE_OP_TYPE_INSTANTIATE_TRIANGLE_CLUSTER_NV = 4,
        VK_CLUSTER_ACCELERATION_STRUCTURE_OP_TYPE_MAX_ENUM_NV = 2147483647
}

enum VkClusterAccelerationStructureOpModeNV: uint32
{
        VK_CLUSTER_ACCELERATION_STRUCTURE_OP_MODE_IMPLICIT_DESTINATIONS_NV = 0,
        VK_CLUSTER_ACCELERATION_STRUCTURE_OP_MODE_EXPLICIT_DESTINATIONS_NV = 1,
        VK_CLUSTER_ACCELERATION_STRUCTURE_OP_MODE_COMPUTE_SIZES_NV = 2,
        VK_CLUSTER_ACCELERATION_STRUCTURE_OP_MODE_MAX_ENUM_NV = 2147483647
}

enum VkClusterAccelerationStructureAddressResolutionFlagBitsNV: uint32
{
        VK_CLUSTER_ACCELERATION_STRUCTURE_ADDRESS_RESOLUTION_INDIRECTED_DST_IMPLICIT_DATA_BIT_NV = 1,
        VK_CLUSTER_ACCELERATION_STRUCTURE_ADDRESS_RESOLUTION_INDIRECTED_SCRATCH_DATA_BIT_NV = 2,
        VK_CLUSTER_ACCELERATION_STRUCTURE_ADDRESS_RESOLUTION_INDIRECTED_DST_ADDRESS_ARRAY_BIT_NV = 4,
        VK_CLUSTER_ACCELERATION_STRUCTURE_ADDRESS_RESOLUTION_INDIRECTED_DST_SIZES_ARRAY_BIT_NV = 8,
        VK_CLUSTER_ACCELERATION_STRUCTURE_ADDRESS_RESOLUTION_INDIRECTED_SRC_INFOS_ARRAY_BIT_NV = 16,
        VK_CLUSTER_ACCELERATION_STRUCTURE_ADDRESS_RESOLUTION_INDIRECTED_SRC_INFOS_COUNT_BIT_NV = 32,
        VK_CLUSTER_ACCELERATION_STRUCTURE_ADDRESS_RESOLUTION_FLAG_BITS_MAX_ENUM_NV = 2147483647
}

enum VkClusterAccelerationStructureClusterFlagBitsNV: uint32
{
        VK_CLUSTER_ACCELERATION_STRUCTURE_CLUSTER_ALLOW_DISABLE_OPACITY_MICROMAPS_NV = 1,
        VK_CLUSTER_ACCELERATION_STRUCTURE_CLUSTER_FLAG_BITS_MAX_ENUM_NV = 2147483647
}

enum VkClusterAccelerationStructureGeometryFlagBitsNV: uint32
{
        VK_CLUSTER_ACCELERATION_STRUCTURE_GEOMETRY_CULL_DISABLE_BIT_NV = 1,
        VK_CLUSTER_ACCELERATION_STRUCTURE_GEOMETRY_NO_DUPLICATE_ANYHIT_INVOCATION_BIT_NV = 2,
        VK_CLUSTER_ACCELERATION_STRUCTURE_GEOMETRY_OPAQUE_BIT_NV = 4,
        VK_CLUSTER_ACCELERATION_STRUCTURE_GEOMETRY_FLAG_BITS_MAX_ENUM_NV = 2147483647
}

enum VkClusterAccelerationStructureIndexFormatFlagBitsNV: uint32
{
        VK_CLUSTER_ACCELERATION_STRUCTURE_INDEX_FORMAT_8BIT_NV = 1,
        VK_CLUSTER_ACCELERATION_STRUCTURE_INDEX_FORMAT_16BIT_NV = 2,
        VK_CLUSTER_ACCELERATION_STRUCTURE_INDEX_FORMAT_32BIT_NV = 4,
        VK_CLUSTER_ACCELERATION_STRUCTURE_INDEX_FORMAT_FLAG_BITS_MAX_ENUM_NV = 2147483647
}

enum VkPartitionedAccelerationStructureOpTypeNV: uint32
{
        VK_PARTITIONED_ACCELERATION_STRUCTURE_OP_TYPE_WRITE_INSTANCE_NV = 0,
        VK_PARTITIONED_ACCELERATION_STRUCTURE_OP_TYPE_UPDATE_INSTANCE_NV = 1,
        VK_PARTITIONED_ACCELERATION_STRUCTURE_OP_TYPE_WRITE_PARTITION_TRANSLATION_NV = 2,
        VK_PARTITIONED_ACCELERATION_STRUCTURE_OP_TYPE_MAX_ENUM_NV = 2147483647
}

enum VkPartitionedAccelerationStructureInstanceFlagBitsNV: uint32
{
        VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_TRIANGLE_FACING_CULL_DISABLE_BIT_NV = 1,
        VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_TRIANGLE_FLIP_FACING_BIT_NV = 2,
        VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_FORCE_OPAQUE_BIT_NV = 4,
        VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_FORCE_NO_OPAQUE_BIT_NV = 8,
        VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_ENABLE_EXPLICIT_BOUNDING_BOX_NV = 16,
        VK_PARTITIONED_ACCELERATION_STRUCTURE_INSTANCE_FLAG_BITS_MAX_ENUM_NV = 2147483647
}

enum VkIndirectExecutionSetInfoTypeEXT: uint32
{
        VK_INDIRECT_EXECUTION_SET_INFO_TYPE_PIPELINES_EXT = 0,
        VK_INDIRECT_EXECUTION_SET_INFO_TYPE_SHADER_OBJECTS_EXT = 1,
        VK_INDIRECT_EXECUTION_SET_INFO_TYPE_MAX_ENUM_EXT = 2147483647
}

enum VkIndirectCommandsTokenTypeEXT: uint32
{
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_EXECUTION_SET_EXT = 0,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_PUSH_CONSTANT_EXT = 1,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_SEQUENCE_INDEX_EXT = 2,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_INDEX_BUFFER_EXT = 3,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_VERTEX_BUFFER_EXT = 4,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_INDEXED_EXT = 5,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_EXT = 6,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_INDEXED_COUNT_EXT = 7,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_COUNT_EXT = 8,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_DISPATCH_EXT = 9,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_NV_EXT = 1000202002,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_COUNT_NV_EXT = 1000202003,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_EXT = 1000328000,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_DRAW_MESH_TASKS_COUNT_EXT = 1000328001,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_TRACE_RAYS2_EXT = 1000386004,
        VK_INDIRECT_COMMANDS_TOKEN_TYPE_MAX_ENUM_EXT = 2147483647
}

enum VkIndirectCommandsInputModeFlagBitsEXT: uint32
{
        VK_INDIRECT_COMMANDS_INPUT_MODE_VULKAN_INDEX_BUFFER_EXT = 1,
        VK_INDIRECT_COMMANDS_INPUT_MODE_DXGI_INDEX_BUFFER_EXT = 2,
        VK_INDIRECT_COMMANDS_INPUT_MODE_FLAG_BITS_MAX_ENUM_EXT = 2147483647
}

enum VkIndirectCommandsLayoutUsageFlagBitsEXT: uint32
{
        VK_INDIRECT_COMMANDS_LAYOUT_USAGE_EXPLICIT_PREPROCESS_BIT_EXT = 1,
        VK_INDIRECT_COMMANDS_LAYOUT_USAGE_UNORDERED_SEQUENCES_BIT_EXT = 2,
        VK_INDIRECT_COMMANDS_LAYOUT_USAGE_FLAG_BITS_MAX_ENUM_EXT = 2147483647
}

enum VkBuildAccelerationStructureModeKHR: uint32
{
        VK_BUILD_ACCELERATION_STRUCTURE_MODE_BUILD_KHR = 0,
        VK_BUILD_ACCELERATION_STRUCTURE_MODE_UPDATE_KHR = 1,
        VK_BUILD_ACCELERATION_STRUCTURE_MODE_MAX_ENUM_KHR = 2147483647
}

enum VkAccelerationStructureCreateFlagBitsKHR: uint32
{
        VK_ACCELERATION_STRUCTURE_CREATE_DEVICE_ADDRESS_CAPTURE_REPLAY_BIT_KHR = 1,
        VK_ACCELERATION_STRUCTURE_CREATE_DESCRIPTOR_BUFFER_CAPTURE_REPLAY_BIT_EXT = 8,
        VK_ACCELERATION_STRUCTURE_CREATE_MOTION_BIT_NV = 4,
        VK_ACCELERATION_STRUCTURE_CREATE_FLAG_BITS_MAX_ENUM_KHR = 2147483647
}

enum VkShaderGroupShaderKHR: uint32
{
        VK_SHADER_GROUP_SHADER_GENERAL_KHR = 0,
        VK_SHADER_GROUP_SHADER_CLOSEST_HIT_KHR = 1,
        VK_SHADER_GROUP_SHADER_ANY_HIT_KHR = 2,
        VK_SHADER_GROUP_SHADER_INTERSECTION_KHR = 3,
        VK_SHADER_GROUP_SHADER_MAX_ENUM_KHR = 2147483647
}

state VkBuffer_T
{
    opaque: any
}

state VkImage_T
{
    opaque: any
}

state VkInstance_T
{
    opaque: any
}

state VkPhysicalDevice_T
{
    opaque: any
}

state VkDevice_T
{
    opaque: any
}

state VkQueue_T
{
    opaque: any
}

state VkSemaphore_T
{
    opaque: any
}

state VkCommandBuffer_T
{
    opaque: any
}

state VkFence_T
{
    opaque: any
}

state VkDeviceMemory_T
{
    opaque: any
}

state VkEvent_T
{
    opaque: any
}

state VkQueryPool_T
{
    opaque: any
}

state VkBufferView_T
{
    opaque: any
}

state VkImageView_T
{
    opaque: any
}

state VkShaderModule_T
{
    opaque: any
}

state VkPipelineCache_T
{
    opaque: any
}

state VkPipelineLayout_T
{
    opaque: any
}

state VkPipeline_T
{
    opaque: any
}

state VkRenderPass_T
{
    opaque: any
}

state VkDescriptorSetLayout_T
{
    opaque: any
}

state VkSampler_T
{
    opaque: any
}

state VkDescriptorSet_T
{
    opaque: any
}

state VkDescriptorPool_T
{
    opaque: any
}

state VkFramebuffer_T
{
    opaque: any
}

state VkCommandPool_T
{
    opaque: any
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
        pNext: *VkBaseInStructure
}

state VkBaseOutStructure
{
        sType: VkStructureType,
        pNext: *VkBaseOutStructure
}

state VkBufferMemoryBarrier
{
        sType: VkStructureType,
        pNext: *void,
        srcAccessMask: uint32,
        dstAccessMask: uint32,
        srcQueueFamilyIndex: uint32,
        dstQueueFamilyIndex: uint32,
        buffer: *VkBuffer_T,
        offset: uint64,
        size: uint64
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
        aspectMask: uint32,
        baseMipLevel: uint32,
        levelCount: uint32,
        baseArrayLayer: uint32,
        layerCount: uint32
}

state VkImageMemoryBarrier
{
        sType: VkStructureType,
        pNext: *void,
        srcAccessMask: uint32,
        dstAccessMask: uint32,
        oldLayout: VkImageLayout,
        newLayout: VkImageLayout,
        srcQueueFamilyIndex: uint32,
        dstQueueFamilyIndex: uint32,
        image: *VkImage_T,
        subresourceRange: VkImageSubresourceRange
}

state VkMemoryBarrier
{
        sType: VkStructureType,
        pNext: *void,
        srcAccessMask: uint32,
        dstAccessMask: uint32
}

state VkPipelineCacheHeaderVersionOne
{
        headerSize: uint32,
        headerVersion: VkPipelineCacheHeaderVersion,
        vendorID: uint32,
        deviceID: uint32,
        pipelineCacheUUID: [16]ubyte
}

state VkAllocationCallbacks
{
        pUserData: *void,
        pfnAllocation: ::(),
        pfnReallocation: ::(),
        pfnFree: ::(),
        pfnInternalAllocation: ::(),
        pfnInternalFree: ::()
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
        linearTilingFeatures: uint32,
        optimalTilingFeatures: uint32,
        bufferFeatures: uint32
}

state VkImageFormatProperties
{
        maxExtent: VkExtent3D,
        maxMipLevels: uint32,
        maxArrayLayers: uint32,
        sampleCounts: uint32,
        maxResourceSize: uint64
}

state VkInstanceCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        pApplicationInfo: *VkApplicationInfo,
        enabledLayerCount: uint32,
        ppEnabledLayerNames: **byte,
        enabledExtensionCount: uint32,
        ppEnabledExtensionNames: **byte
}

state VkMemoryHeap
{
        size: uint64,
        flags: uint32
}

state VkMemoryType
{
        propertyFlags: uint32,
        heapIndex: uint32
}

state VkPhysicalDeviceFeatures
{
        robustBufferAccess: uint32,
        fullDrawIndexUint32: uint32,
        imageCubeArray: uint32,
        independentBlend: uint32,
        geometryShader: uint32,
        tessellationShader: uint32,
        sampleRateShading: uint32,
        dualSrcBlend: uint32,
        logicOp: uint32,
        multiDrawIndirect: uint32,
        drawIndirectFirstInstance: uint32,
        depthClamp: uint32,
        depthBiasClamp: uint32,
        fillModeNonSolid: uint32,
        depthBounds: uint32,
        wideLines: uint32,
        largePoints: uint32,
        alphaToOne: uint32,
        multiViewport: uint32,
        samplerAnisotropy: uint32,
        textureCompressionETC2: uint32,
        textureCompressionASTC_LDR: uint32,
        textureCompressionBC: uint32,
        occlusionQueryPrecise: uint32,
        pipelineStatisticsQuery: uint32,
        vertexPipelineStoresAndAtomics: uint32,
        fragmentStoresAndAtomics: uint32,
        shaderTessellationAndGeometryPointSize: uint32,
        shaderImageGatherExtended: uint32,
        shaderStorageImageExtendedFormats: uint32,
        shaderStorageImageMultisample: uint32,
        shaderStorageImageReadWithoutFormat: uint32,
        shaderStorageImageWriteWithoutFormat: uint32,
        shaderUniformBufferArrayDynamicIndexing: uint32,
        shaderSampledImageArrayDynamicIndexing: uint32,
        shaderStorageBufferArrayDynamicIndexing: uint32,
        shaderStorageImageArrayDynamicIndexing: uint32,
        shaderClipDistance: uint32,
        shaderCullDistance: uint32,
        shaderFloat64: uint32,
        shaderInt64: uint32,
        shaderInt16: uint32,
        shaderResourceResidency: uint32,
        shaderResourceMinLod: uint32,
        sparseBinding: uint32,
        sparseResidencyBuffer: uint32,
        sparseResidencyImage2D: uint32,
        sparseResidencyImage3D: uint32,
        sparseResidency2Samples: uint32,
        sparseResidency4Samples: uint32,
        sparseResidency8Samples: uint32,
        sparseResidency16Samples: uint32,
        sparseResidencyAliased: uint32,
        variableMultisampleRate: uint32,
        inheritedQueries: uint32
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
        bufferImageGranularity: uint64,
        sparseAddressSpaceSize: uint64,
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
        maxSamplerLodBias: float32,
        maxSamplerAnisotropy: float32,
        maxViewports: uint32,
        maxViewportDimensions: [2]uint32,
        viewportBoundsRange: [2]float32,
        viewportSubPixelBits: uint32,
        minMemoryMapAlignment: uint64,
        minTexelBufferOffsetAlignment: uint64,
        minUniformBufferOffsetAlignment: uint64,
        minStorageBufferOffsetAlignment: uint64,
        minTexelOffset: int32,
        maxTexelOffset: uint32,
        minTexelGatherOffset: int32,
        maxTexelGatherOffset: uint32,
        minInterpolationOffset: float32,
        maxInterpolationOffset: float32,
        subPixelInterpolationOffsetBits: uint32,
        maxFramebufferWidth: uint32,
        maxFramebufferHeight: uint32,
        maxFramebufferLayers: uint32,
        framebufferColorSampleCounts: uint32,
        framebufferDepthSampleCounts: uint32,
        framebufferStencilSampleCounts: uint32,
        framebufferNoAttachmentsSampleCounts: uint32,
        maxColorAttachments: uint32,
        sampledImageColorSampleCounts: uint32,
        sampledImageIntegerSampleCounts: uint32,
        sampledImageDepthSampleCounts: uint32,
        sampledImageStencilSampleCounts: uint32,
        storageImageSampleCounts: uint32,
        maxSampleMaskWords: uint32,
        timestampComputeAndGraphics: uint32,
        timestampPeriod: float32,
        maxClipDistances: uint32,
        maxCullDistances: uint32,
        maxCombinedClipAndCullDistances: uint32,
        discreteQueuePriorities: uint32,
        pointSizeRange: [2]float32,
        lineWidthRange: [2]float32,
        pointSizeGranularity: float32,
        lineWidthGranularity: float32,
        strictLines: uint32,
        standardSampleLocations: uint32,
        optimalBufferCopyOffsetAlignment: uint64,
        optimalBufferCopyRowPitchAlignment: uint64,
        nonCoherentAtomSize: uint64
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
        residencyStandard2DBlockShape: uint32,
        residencyStandard2DMultisampleBlockShape: uint32,
        residencyStandard3DBlockShape: uint32,
        residencyAlignedMipSize: uint32,
        residencyNonResidentStrict: uint32
}

state VkPhysicalDeviceProperties
{
        apiVersion: uint32,
        driverVersion: uint32,
        vendorID: uint32,
        deviceID: uint32,
        deviceType: VkPhysicalDeviceType,
        deviceName: [256]byte,
        pipelineCacheUUID: [16]ubyte,
        limits: VkPhysicalDeviceLimits,
        sparseProperties: VkPhysicalDeviceSparseProperties
}

state VkQueueFamilyProperties
{
        queueFlags: uint32,
        queueCount: uint32,
        timestampValidBits: uint32,
        minImageTransferGranularity: VkExtent3D
}

state VkDeviceQueueCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        queueFamilyIndex: uint32,
        queueCount: uint32,
        pQueuePriorities: *float32
}

state VkDeviceCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
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
        pWaitSemaphores: **VkSemaphore_T,
        pWaitDstStageMask: *uint32,
        commandBufferCount: uint32,
        pCommandBuffers: **VkCommandBuffer_T,
        signalSemaphoreCount: uint32,
        pSignalSemaphores: **VkSemaphore_T
}

state VkMappedMemoryRange
{
        sType: VkStructureType,
        pNext: *void,
        memory: *VkDeviceMemory_T,
        offset: uint64,
        size: uint64
}

state VkMemoryAllocateInfo
{
        sType: VkStructureType,
        pNext: *void,
        allocationSize: uint64,
        memoryTypeIndex: uint32
}

state VkMemoryRequirements
{
        size: uint64,
        alignment: uint64,
        memoryTypeBits: uint32
}

state VkSparseMemoryBind
{
        resourceOffset: uint64,
        size: uint64,
        memory: *VkDeviceMemory_T,
        memoryOffset: uint64,
        flags: uint32
}

state VkSparseBufferMemoryBindInfo
{
        buffer: *VkBuffer_T,
        bindCount: uint32,
        pBinds: *VkSparseMemoryBind
}

state VkSparseImageOpaqueMemoryBindInfo
{
        image: *VkImage_T,
        bindCount: uint32,
        pBinds: *VkSparseMemoryBind
}

state VkImageSubresource
{
        aspectMask: uint32,
        mipLevel: uint32,
        arrayLayer: uint32
}

state VkSparseImageMemoryBind
{
        subresource: VkImageSubresource,
        offset: VkOffset3D,
        extent: VkExtent3D,
        memory: *VkDeviceMemory_T,
        memoryOffset: uint64,
        flags: uint32
}

state VkSparseImageMemoryBindInfo
{
        image: *VkImage_T,
        bindCount: uint32,
        pBinds: *VkSparseImageMemoryBind
}

state VkBindSparseInfo
{
        sType: VkStructureType,
        pNext: *void,
        waitSemaphoreCount: uint32,
        pWaitSemaphores: **VkSemaphore_T,
        bufferBindCount: uint32,
        pBufferBinds: *VkSparseBufferMemoryBindInfo,
        imageOpaqueBindCount: uint32,
        pImageOpaqueBinds: *VkSparseImageOpaqueMemoryBindInfo,
        imageBindCount: uint32,
        pImageBinds: *VkSparseImageMemoryBindInfo,
        signalSemaphoreCount: uint32,
        pSignalSemaphores: **VkSemaphore_T
}

state VkSparseImageFormatProperties
{
        aspectMask: uint32,
        imageGranularity: VkExtent3D,
        flags: uint32
}

state VkSparseImageMemoryRequirements
{
        formatProperties: VkSparseImageFormatProperties,
        imageMipTailFirstLod: uint32,
        imageMipTailSize: uint64,
        imageMipTailOffset: uint64,
        imageMipTailStride: uint64
}

state VkFenceCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32
}

state VkSemaphoreCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32
}

state VkEventCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32
}

state VkQueryPoolCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        queryType: VkQueryType,
        queryCount: uint32,
        pipelineStatistics: uint32
}

state VkBufferCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        size: uint64,
        usage: uint32,
        sharingMode: VkSharingMode,
        queueFamilyIndexCount: uint32,
        pQueueFamilyIndices: *uint32
}

state VkBufferViewCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        buffer: *VkBuffer_T,
        format: VkFormat,
        offset: uint64,
        range: uint64
}

state VkImageCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        imageType: VkImageType,
        format: VkFormat,
        extent: VkExtent3D,
        mipLevels: uint32,
        arrayLayers: uint32,
        samples: VkSampleCountFlagBits,
        tiling: VkImageTiling,
        usage: uint32,
        sharingMode: VkSharingMode,
        queueFamilyIndexCount: uint32,
        pQueueFamilyIndices: *uint32,
        initialLayout: VkImageLayout
}

state VkSubresourceLayout
{
        offset: uint64,
        size: uint64,
        rowPitch: uint64,
        arrayPitch: uint64,
        depthPitch: uint64
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
        flags: uint32,
        image: *VkImage_T,
        viewType: VkImageViewType,
        format: VkFormat,
        components: VkComponentMapping,
        subresourceRange: VkImageSubresourceRange
}

state VkShaderModuleCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        codeSize: uint64,
        pCode: *uint32
}

state VkPipelineCacheCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        initialDataSize: uint64,
        pInitialData: *void
}

state VkSpecializationMapEntry
{
        constantID: uint32,
        offset: uint32,
        size: uint64
}

state VkSpecializationInfo
{
        mapEntryCount: uint32,
        pMapEntries: *VkSpecializationMapEntry,
        dataSize: uint64,
        pData: *void
}

state VkPipelineShaderStageCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        stage: VkShaderStageFlagBits,
        module: *VkShaderModule_T,
        pName: *byte,
        pSpecializationInfo: *VkSpecializationInfo
}

state VkComputePipelineCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        stage: VkPipelineShaderStageCreateInfo,
        layout: *VkPipelineLayout_T,
        basePipelineHandle: *VkPipeline_T,
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
        flags: uint32,
        vertexBindingDescriptionCount: uint32,
        pVertexBindingDescriptions: *VkVertexInputBindingDescription,
        vertexAttributeDescriptionCount: uint32,
        pVertexAttributeDescriptions: *VkVertexInputAttributeDescription
}

state VkPipelineInputAssemblyStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        topology: VkPrimitiveTopology,
        primitiveRestartEnable: uint32
}

state VkPipelineTessellationStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        patchControlPoints: uint32
}

state VkViewport
{
        x: float32,
        y: float32,
        width: float32,
        height: float32,
        minDepth: float32,
        maxDepth: float32
}

state VkPipelineViewportStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        viewportCount: uint32,
        pViewports: *VkViewport,
        scissorCount: uint32,
        pScissors: *VkRect2D
}

state VkPipelineRasterizationStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        depthClampEnable: uint32,
        rasterizerDiscardEnable: uint32,
        polygonMode: VkPolygonMode,
        cullMode: uint32,
        frontFace: VkFrontFace,
        depthBiasEnable: uint32,
        depthBiasConstantFactor: float32,
        depthBiasClamp: float32,
        depthBiasSlopeFactor: float32,
        lineWidth: float32
}

state VkPipelineMultisampleStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        rasterizationSamples: VkSampleCountFlagBits,
        sampleShadingEnable: uint32,
        minSampleShading: float32,
        pSampleMask: *uint32,
        alphaToCoverageEnable: uint32,
        alphaToOneEnable: uint32
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
        flags: uint32,
        depthTestEnable: uint32,
        depthWriteEnable: uint32,
        depthCompareOp: VkCompareOp,
        depthBoundsTestEnable: uint32,
        stencilTestEnable: uint32,
        front: VkStencilOpState,
        back: VkStencilOpState,
        minDepthBounds: float32,
        maxDepthBounds: float32
}

state VkPipelineColorBlendAttachmentState
{
        blendEnable: uint32,
        srcColorBlendFactor: VkBlendFactor,
        dstColorBlendFactor: VkBlendFactor,
        colorBlendOp: VkBlendOp,
        srcAlphaBlendFactor: VkBlendFactor,
        dstAlphaBlendFactor: VkBlendFactor,
        alphaBlendOp: VkBlendOp,
        colorWriteMask: uint32
}

state VkPipelineColorBlendStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        logicOpEnable: uint32,
        logicOp: VkLogicOp,
        attachmentCount: uint32,
        pAttachments: *VkPipelineColorBlendAttachmentState,
        blendConstants: [4]float32
}

state VkPipelineDynamicStateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        dynamicStateCount: uint32,
        pDynamicStates: *VkDynamicState
}

state VkGraphicsPipelineCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
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
        layout: *VkPipelineLayout_T,
        renderPass: *VkRenderPass_T,
        subpass: uint32,
        basePipelineHandle: *VkPipeline_T,
        basePipelineIndex: int32
}

state VkPushConstantRange
{
        stageFlags: uint32,
        offset: uint32,
        size: uint32
}

state VkPipelineLayoutCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        setLayoutCount: uint32,
        pSetLayouts: **VkDescriptorSetLayout_T,
        pushConstantRangeCount: uint32,
        pPushConstantRanges: *VkPushConstantRange
}

state VkSamplerCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        magFilter: VkFilter,
        minFilter: VkFilter,
        mipmapMode: VkSamplerMipmapMode,
        addressModeU: VkSamplerAddressMode,
        addressModeV: VkSamplerAddressMode,
        addressModeW: VkSamplerAddressMode,
        mipLodBias: float32,
        anisotropyEnable: uint32,
        maxAnisotropy: float32,
        compareEnable: uint32,
        compareOp: VkCompareOp,
        minLod: float32,
        maxLod: float32,
        borderColor: VkBorderColor,
        unnormalizedCoordinates: uint32
}

state VkCopyDescriptorSet
{
        sType: VkStructureType,
        pNext: *void,
        srcSet: *VkDescriptorSet_T,
        srcBinding: uint32,
        srcArrayElement: uint32,
        dstSet: *VkDescriptorSet_T,
        dstBinding: uint32,
        dstArrayElement: uint32,
        descriptorCount: uint32
}

state VkDescriptorBufferInfo
{
        buffer: *VkBuffer_T,
        offset: uint64,
        range: uint64
}

state VkDescriptorImageInfo
{
        sampler: *VkSampler_T,
        imageView: *VkImageView_T,
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
        flags: uint32,
        maxSets: uint32,
        poolSizeCount: uint32,
        pPoolSizes: *VkDescriptorPoolSize
}

state VkDescriptorSetAllocateInfo
{
        sType: VkStructureType,
        pNext: *void,
        descriptorPool: *VkDescriptorPool_T,
        descriptorSetCount: uint32,
        pSetLayouts: **VkDescriptorSetLayout_T
}

state VkDescriptorSetLayoutBinding
{
        binding: uint32,
        descriptorType: VkDescriptorType,
        descriptorCount: uint32,
        stageFlags: uint32,
        pImmutableSamplers: **VkSampler_T
}

state VkDescriptorSetLayoutCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        bindingCount: uint32,
        pBindings: *VkDescriptorSetLayoutBinding
}

state VkWriteDescriptorSet
{
        sType: VkStructureType,
        pNext: *void,
        dstSet: *VkDescriptorSet_T,
        dstBinding: uint32,
        dstArrayElement: uint32,
        descriptorCount: uint32,
        descriptorType: VkDescriptorType,
        pImageInfo: *VkDescriptorImageInfo,
        pBufferInfo: *VkDescriptorBufferInfo,
        pTexelBufferView: **VkBufferView_T
}

state VkAttachmentDescription
{
        flags: uint32,
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
        flags: uint32,
        renderPass: *VkRenderPass_T,
        attachmentCount: uint32,
        pAttachments: **VkImageView_T,
        width: uint32,
        height: uint32,
        layers: uint32
}

state VkSubpassDescription
{
        flags: uint32,
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
        srcStageMask: uint32,
        dstStageMask: uint32,
        srcAccessMask: uint32,
        dstAccessMask: uint32,
        dependencyFlags: uint32
}

state VkRenderPassCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
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
        flags: uint32,
        queueFamilyIndex: uint32
}

state VkCommandBufferAllocateInfo
{
        sType: VkStructureType,
        pNext: *void,
        commandPool: *VkCommandPool_T,
        level: VkCommandBufferLevel,
        commandBufferCount: uint32
}

state VkCommandBufferInheritanceInfo
{
        sType: VkStructureType,
        pNext: *void,
        renderPass: *VkRenderPass_T,
        subpass: uint32,
        framebuffer: *VkFramebuffer_T,
        occlusionQueryEnable: uint32,
        queryFlags: uint32,
        pipelineStatistics: uint32
}

state VkCommandBufferBeginInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        pInheritanceInfo: *VkCommandBufferInheritanceInfo
}

state VkBufferCopy
{
        srcOffset: uint64,
        dstOffset: uint64,
        size: uint64
}

state VkImageSubresourceLayers
{
        aspectMask: uint32,
        mipLevel: uint32,
        baseArrayLayer: uint32,
        layerCount: uint32
}

state VkBufferImageCopy
{
        bufferOffset: uint64,
        bufferRowLength: uint32,
        bufferImageHeight: uint32,
        imageSubresource: VkImageSubresourceLayers,
        imageOffset: VkOffset3D,
        imageExtent: VkExtent3D
}

state VkClearDepthStencilValue
{
        depth: float32,
        stencil: uint32
}

state VkClearAttachment
{
        aspectMask: uint32,
        colorAttachment: uint32,
        clearValue: ?{color: ?{_float32: [4]float32, _int32: [4]int32, _uint32: [4]uint32}, depthStencil: VkClearDepthStencilValue}
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
        renderPass: *VkRenderPass_T,
        framebuffer: *VkFramebuffer_T,
        renderArea: VkRect2D,
        clearValueCount: uint32,
        pClearValues: *?{color: ?{_float32: [4]float32, _int32: [4]int32, _uint32: [4]uint32}, depthStencil: VkClearDepthStencilValue}
}

state VkSamplerYcbcrConversion_T
{
    opaque: any
}

state VkDescriptorUpdateTemplate_T
{
    opaque: any
}

state VkPhysicalDeviceSubgroupProperties
{
        sType: VkStructureType,
        pNext: *void,
        subgroupSize: uint32,
        supportedStages: uint32,
        supportedOperations: uint32,
        quadOperationsInAllStages: uint32
}

state VkBindBufferMemoryInfo
{
        sType: VkStructureType,
        pNext: *void,
        buffer: *VkBuffer_T,
        memory: *VkDeviceMemory_T,
        memoryOffset: uint64
}

state VkBindImageMemoryInfo
{
        sType: VkStructureType,
        pNext: *void,
        image: *VkImage_T,
        memory: *VkDeviceMemory_T,
        memoryOffset: uint64
}

state VkPhysicalDevice16BitStorageFeatures
{
        sType: VkStructureType,
        pNext: *void,
        storageBuffer16BitAccess: uint32,
        uniformAndStorageBuffer16BitAccess: uint32,
        storagePushConstant16: uint32,
        storageInputOutput16: uint32
}

state VkMemoryDedicatedRequirements
{
        sType: VkStructureType,
        pNext: *void,
        prefersDedicatedAllocation: uint32,
        requiresDedicatedAllocation: uint32
}

state VkMemoryDedicatedAllocateInfo
{
        sType: VkStructureType,
        pNext: *void,
        image: *VkImage_T,
        buffer: *VkBuffer_T
}

state VkMemoryAllocateFlagsInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
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
        physicalDevices: [32]*VkPhysicalDevice_T,
        subsetAllocation: uint32
}

state VkDeviceGroupDeviceCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        physicalDeviceCount: uint32,
        pPhysicalDevices: **VkPhysicalDevice_T
}

state VkBufferMemoryRequirementsInfo2
{
        sType: VkStructureType,
        pNext: *void,
        buffer: *VkBuffer_T
}

state VkImageMemoryRequirementsInfo2
{
        sType: VkStructureType,
        pNext: *void,
        image: *VkImage_T
}

state VkImageSparseMemoryRequirementsInfo2
{
        sType: VkStructureType,
        pNext: *void,
        image: *VkImage_T
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
        usage: uint32,
        flags: uint32
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
        usage: uint32,
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
        aspectMask: uint32
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
        usage: uint32
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
        multiview: uint32,
        multiviewGeometryShader: uint32,
        multiviewTessellationShader: uint32
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
        variablePointersStorageBuffer: uint32,
        variablePointers: uint32
}

state VkPhysicalDeviceProtectedMemoryFeatures
{
        sType: VkStructureType,
        pNext: *void,
        protectedMemory: uint32
}

state VkPhysicalDeviceProtectedMemoryProperties
{
        sType: VkStructureType,
        pNext: *void,
        protectedNoFault: uint32
}

state VkDeviceQueueInfo2
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        queueFamilyIndex: uint32,
        queueIndex: uint32
}

state VkProtectedSubmitInfo
{
        sType: VkStructureType,
        pNext: *void,
        protectedSubmit: uint32
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
        forceExplicitReconstruction: uint32
}

state VkSamplerYcbcrConversionInfo
{
        sType: VkStructureType,
        pNext: *void,
        conversion: *VkSamplerYcbcrConversion_T
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
        samplerYcbcrConversion: uint32
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
        offset: uint64,
        stride: uint64
}

state VkDescriptorUpdateTemplateCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        descriptorUpdateEntryCount: uint32,
        pDescriptorUpdateEntries: *VkDescriptorUpdateTemplateEntry,
        templateType: VkDescriptorUpdateTemplateType,
        descriptorSetLayout: *VkDescriptorSetLayout_T,
        pipelineBindPoint: VkPipelineBindPoint,
        pipelineLayout: *VkPipelineLayout_T,
        set: uint32
}

state VkExternalMemoryProperties
{
        externalMemoryFeatures: uint32,
        exportFromImportedHandleTypes: uint32,
        compatibleHandleTypes: uint32
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
        flags: uint32,
        usage: uint32,
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
        deviceUUID: [16]ubyte,
        driverUUID: [16]ubyte,
        deviceLUID: [8]ubyte,
        deviceNodeMask: uint32,
        deviceLUIDValid: uint32
}

state VkExternalMemoryImageCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        handleTypes: uint32
}

state VkExternalMemoryBufferCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        handleTypes: uint32
}

state VkExportMemoryAllocateInfo
{
        sType: VkStructureType,
        pNext: *void,
        handleTypes: uint32
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
        exportFromImportedHandleTypes: uint32,
        compatibleHandleTypes: uint32,
        externalFenceFeatures: uint32
}

state VkExportFenceCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        handleTypes: uint32
}

state VkExportSemaphoreCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        handleTypes: uint32
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
        exportFromImportedHandleTypes: uint32,
        compatibleHandleTypes: uint32,
        externalSemaphoreFeatures: uint32
}

state VkPhysicalDeviceMaintenance3Properties
{
        sType: VkStructureType,
        pNext: *void,
        maxPerSetDescriptors: uint32,
        maxMemoryAllocationSize: uint64
}

state VkDescriptorSetLayoutSupport
{
        sType: VkStructureType,
        pNext: *void,
        supported: uint32
}

state VkPhysicalDeviceShaderDrawParametersFeatures
{
        sType: VkStructureType,
        pNext: *void,
        shaderDrawParameters: uint32
}

state VkPhysicalDeviceVulkan11Features
{
        sType: VkStructureType,
        pNext: *void,
        storageBuffer16BitAccess: uint32,
        uniformAndStorageBuffer16BitAccess: uint32,
        storagePushConstant16: uint32,
        storageInputOutput16: uint32,
        multiview: uint32,
        multiviewGeometryShader: uint32,
        multiviewTessellationShader: uint32,
        variablePointersStorageBuffer: uint32,
        variablePointers: uint32,
        protectedMemory: uint32,
        samplerYcbcrConversion: uint32,
        shaderDrawParameters: uint32
}

state VkPhysicalDeviceVulkan11Properties
{
        sType: VkStructureType,
        pNext: *void,
        deviceUUID: [16]ubyte,
        driverUUID: [16]ubyte,
        deviceLUID: [8]ubyte,
        deviceNodeMask: uint32,
        deviceLUIDValid: uint32,
        subgroupSize: uint32,
        subgroupSupportedStages: uint32,
        subgroupSupportedOperations: uint32,
        subgroupQuadOperationsInAllStages: uint32,
        pointClippingBehavior: VkPointClippingBehavior,
        maxMultiviewViewCount: uint32,
        maxMultiviewInstanceIndex: uint32,
        protectedNoFault: uint32,
        maxPerSetDescriptors: uint32,
        maxMemoryAllocationSize: uint64
}

state VkPhysicalDeviceVulkan12Features
{
        sType: VkStructureType,
        pNext: *void,
        samplerMirrorClampToEdge: uint32,
        drawIndirectCount: uint32,
        storageBuffer8BitAccess: uint32,
        uniformAndStorageBuffer8BitAccess: uint32,
        storagePushConstant8: uint32,
        shaderBufferInt64Atomics: uint32,
        shaderSharedInt64Atomics: uint32,
        shaderFloat16: uint32,
        shaderInt8: uint32,
        descriptorIndexing: uint32,
        shaderInputAttachmentArrayDynamicIndexing: uint32,
        shaderUniformTexelBufferArrayDynamicIndexing: uint32,
        shaderStorageTexelBufferArrayDynamicIndexing: uint32,
        shaderUniformBufferArrayNonUniformIndexing: uint32,
        shaderSampledImageArrayNonUniformIndexing: uint32,
        shaderStorageBufferArrayNonUniformIndexing: uint32,
        shaderStorageImageArrayNonUniformIndexing: uint32,
        shaderInputAttachmentArrayNonUniformIndexing: uint32,
        shaderUniformTexelBufferArrayNonUniformIndexing: uint32,
        shaderStorageTexelBufferArrayNonUniformIndexing: uint32,
        descriptorBindingUniformBufferUpdateAfterBind: uint32,
        descriptorBindingSampledImageUpdateAfterBind: uint32,
        descriptorBindingStorageImageUpdateAfterBind: uint32,
        descriptorBindingStorageBufferUpdateAfterBind: uint32,
        descriptorBindingUniformTexelBufferUpdateAfterBind: uint32,
        descriptorBindingStorageTexelBufferUpdateAfterBind: uint32,
        descriptorBindingUpdateUnusedWhilePending: uint32,
        descriptorBindingPartiallyBound: uint32,
        descriptorBindingVariableDescriptorCount: uint32,
        runtimeDescriptorArray: uint32,
        samplerFilterMinmax: uint32,
        scalarBlockLayout: uint32,
        imagelessFramebuffer: uint32,
        uniformBufferStandardLayout: uint32,
        shaderSubgroupExtendedTypes: uint32,
        separateDepthStencilLayouts: uint32,
        hostQueryReset: uint32,
        timelineSemaphore: uint32,
        bufferDeviceAddress: uint32,
        bufferDeviceAddressCaptureReplay: uint32,
        bufferDeviceAddressMultiDevice: uint32,
        vulkanMemoryModel: uint32,
        vulkanMemoryModelDeviceScope: uint32,
        vulkanMemoryModelAvailabilityVisibilityChains: uint32,
        shaderOutputViewportIndex: uint32,
        shaderOutputLayer: uint32,
        subgroupBroadcastDynamicId: uint32
}

state VkConformanceVersion
{
        major: ubyte,
        minor: ubyte,
        subminor: ubyte,
        patch: ubyte
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
        shaderSignedZeroInfNanPreserveFloat16: uint32,
        shaderSignedZeroInfNanPreserveFloat32: uint32,
        shaderSignedZeroInfNanPreserveFloat64: uint32,
        shaderDenormPreserveFloat16: uint32,
        shaderDenormPreserveFloat32: uint32,
        shaderDenormPreserveFloat64: uint32,
        shaderDenormFlushToZeroFloat16: uint32,
        shaderDenormFlushToZeroFloat32: uint32,
        shaderDenormFlushToZeroFloat64: uint32,
        shaderRoundingModeRTEFloat16: uint32,
        shaderRoundingModeRTEFloat32: uint32,
        shaderRoundingModeRTEFloat64: uint32,
        shaderRoundingModeRTZFloat16: uint32,
        shaderRoundingModeRTZFloat32: uint32,
        shaderRoundingModeRTZFloat64: uint32,
        maxUpdateAfterBindDescriptorsInAllPools: uint32,
        shaderUniformBufferArrayNonUniformIndexingNative: uint32,
        shaderSampledImageArrayNonUniformIndexingNative: uint32,
        shaderStorageBufferArrayNonUniformIndexingNative: uint32,
        shaderStorageImageArrayNonUniformIndexingNative: uint32,
        shaderInputAttachmentArrayNonUniformIndexingNative: uint32,
        robustBufferAccessUpdateAfterBind: uint32,
        quadDivergentImplicitLod: uint32,
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
        supportedDepthResolveModes: uint32,
        supportedStencilResolveModes: uint32,
        independentResolveNone: uint32,
        independentResolve: uint32,
        filterMinmaxSingleComponentFormats: uint32,
        filterMinmaxImageComponentMapping: uint32,
        maxTimelineSemaphoreValueDifference: uint64,
        framebufferIntegerColorSampleCounts: uint32
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
        flags: uint32,
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
        aspectMask: uint32
}

state VkSubpassDescription2
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
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
        srcStageMask: uint32,
        dstStageMask: uint32,
        srcAccessMask: uint32,
        dstAccessMask: uint32,
        dependencyFlags: uint32,
        viewOffset: int32
}

state VkRenderPassCreateInfo2
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
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
        storageBuffer8BitAccess: uint32,
        uniformAndStorageBuffer8BitAccess: uint32,
        storagePushConstant8: uint32
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
        shaderBufferInt64Atomics: uint32,
        shaderSharedInt64Atomics: uint32
}

state VkPhysicalDeviceShaderFloat16Int8Features
{
        sType: VkStructureType,
        pNext: *void,
        shaderFloat16: uint32,
        shaderInt8: uint32
}

state VkPhysicalDeviceFloatControlsProperties
{
        sType: VkStructureType,
        pNext: *void,
        denormBehaviorIndependence: VkShaderFloatControlsIndependence,
        roundingModeIndependence: VkShaderFloatControlsIndependence,
        shaderSignedZeroInfNanPreserveFloat16: uint32,
        shaderSignedZeroInfNanPreserveFloat32: uint32,
        shaderSignedZeroInfNanPreserveFloat64: uint32,
        shaderDenormPreserveFloat16: uint32,
        shaderDenormPreserveFloat32: uint32,
        shaderDenormPreserveFloat64: uint32,
        shaderDenormFlushToZeroFloat16: uint32,
        shaderDenormFlushToZeroFloat32: uint32,
        shaderDenormFlushToZeroFloat64: uint32,
        shaderRoundingModeRTEFloat16: uint32,
        shaderRoundingModeRTEFloat32: uint32,
        shaderRoundingModeRTEFloat64: uint32,
        shaderRoundingModeRTZFloat16: uint32,
        shaderRoundingModeRTZFloat32: uint32,
        shaderRoundingModeRTZFloat64: uint32
}

state VkDescriptorSetLayoutBindingFlagsCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        bindingCount: uint32,
        pBindingFlags: *uint32
}

state VkPhysicalDeviceDescriptorIndexingFeatures
{
        sType: VkStructureType,
        pNext: *void,
        shaderInputAttachmentArrayDynamicIndexing: uint32,
        shaderUniformTexelBufferArrayDynamicIndexing: uint32,
        shaderStorageTexelBufferArrayDynamicIndexing: uint32,
        shaderUniformBufferArrayNonUniformIndexing: uint32,
        shaderSampledImageArrayNonUniformIndexing: uint32,
        shaderStorageBufferArrayNonUniformIndexing: uint32,
        shaderStorageImageArrayNonUniformIndexing: uint32,
        shaderInputAttachmentArrayNonUniformIndexing: uint32,
        shaderUniformTexelBufferArrayNonUniformIndexing: uint32,
        shaderStorageTexelBufferArrayNonUniformIndexing: uint32,
        descriptorBindingUniformBufferUpdateAfterBind: uint32,
        descriptorBindingSampledImageUpdateAfterBind: uint32,
        descriptorBindingStorageImageUpdateAfterBind: uint32,
        descriptorBindingStorageBufferUpdateAfterBind: uint32,
        descriptorBindingUniformTexelBufferUpdateAfterBind: uint32,
        descriptorBindingStorageTexelBufferUpdateAfterBind: uint32,
        descriptorBindingUpdateUnusedWhilePending: uint32,
        descriptorBindingPartiallyBound: uint32,
        descriptorBindingVariableDescriptorCount: uint32,
        runtimeDescriptorArray: uint32
}

state VkPhysicalDeviceDescriptorIndexingProperties
{
        sType: VkStructureType,
        pNext: *void,
        maxUpdateAfterBindDescriptorsInAllPools: uint32,
        shaderUniformBufferArrayNonUniformIndexingNative: uint32,
        shaderSampledImageArrayNonUniformIndexingNative: uint32,
        shaderStorageBufferArrayNonUniformIndexingNative: uint32,
        shaderStorageImageArrayNonUniformIndexingNative: uint32,
        shaderInputAttachmentArrayNonUniformIndexingNative: uint32,
        robustBufferAccessUpdateAfterBind: uint32,
        quadDivergentImplicitLod: uint32,
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
        supportedDepthResolveModes: uint32,
        supportedStencilResolveModes: uint32,
        independentResolveNone: uint32,
        independentResolve: uint32
}

state VkPhysicalDeviceScalarBlockLayoutFeatures
{
        sType: VkStructureType,
        pNext: *void,
        scalarBlockLayout: uint32
}

state VkImageStencilUsageCreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        stencilUsage: uint32
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
        filterMinmaxSingleComponentFormats: uint32,
        filterMinmaxImageComponentMapping: uint32
}

state VkPhysicalDeviceVulkanMemoryModelFeatures
{
        sType: VkStructureType,
        pNext: *void,
        vulkanMemoryModel: uint32,
        vulkanMemoryModelDeviceScope: uint32,
        vulkanMemoryModelAvailabilityVisibilityChains: uint32
}

state VkPhysicalDeviceImagelessFramebufferFeatures
{
        sType: VkStructureType,
        pNext: *void,
        imagelessFramebuffer: uint32
}

state VkFramebufferAttachmentImageInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        usage: uint32,
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
        pAttachments: **VkImageView_T
}

state VkPhysicalDeviceUniformBufferStandardLayoutFeatures
{
        sType: VkStructureType,
        pNext: *void,
        uniformBufferStandardLayout: uint32
}

state VkPhysicalDeviceShaderSubgroupExtendedTypesFeatures
{
        sType: VkStructureType,
        pNext: *void,
        shaderSubgroupExtendedTypes: uint32
}

state VkPhysicalDeviceSeparateDepthStencilLayoutsFeatures
{
        sType: VkStructureType,
        pNext: *void,
        separateDepthStencilLayouts: uint32
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
        hostQueryReset: uint32
}

state VkPhysicalDeviceTimelineSemaphoreFeatures
{
        sType: VkStructureType,
        pNext: *void,
        timelineSemaphore: uint32
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
        flags: uint32,
        semaphoreCount: uint32,
        pSemaphores: **VkSemaphore_T,
        pValues: *uint64
}

state VkSemaphoreSignalInfo
{
        sType: VkStructureType,
        pNext: *void,
        semaphore: *VkSemaphore_T,
        value: uint64
}

state VkPhysicalDeviceBufferDeviceAddressFeatures
{
        sType: VkStructureType,
        pNext: *void,
        bufferDeviceAddress: uint32,
        bufferDeviceAddressCaptureReplay: uint32,
        bufferDeviceAddressMultiDevice: uint32
}

state VkBufferDeviceAddressInfo
{
        sType: VkStructureType,
        pNext: *void,
        buffer: *VkBuffer_T
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
        memory: *VkDeviceMemory_T
}

state VkPrivateDataSlot_T
{
    opaque: any
}

state VkPhysicalDeviceVulkan13Features
{
        sType: VkStructureType,
        pNext: *void,
        robustImageAccess: uint32,
        inlineUniformBlock: uint32,
        descriptorBindingInlineUniformBlockUpdateAfterBind: uint32,
        pipelineCreationCacheControl: uint32,
        privateData: uint32,
        shaderDemoteToHelperInvocation: uint32,
        shaderTerminateInvocation: uint32,
        subgroupSizeControl: uint32,
        computeFullSubgroups: uint32,
        synchronization2: uint32,
        textureCompressionASTC_HDR: uint32,
        shaderZeroInitializeWorkgroupMemory: uint32,
        dynamicRendering: uint32,
        shaderIntegerDotProduct: uint32,
        maintenance4: uint32
}

state VkPhysicalDeviceVulkan13Properties
{
        sType: VkStructureType,
        pNext: *void,
        minSubgroupSize: uint32,
        maxSubgroupSize: uint32,
        maxComputeWorkgroupSubgroups: uint32,
        requiredSubgroupSizeStages: uint32,
        maxInlineUniformBlockSize: uint32,
        maxPerStageDescriptorInlineUniformBlocks: uint32,
        maxPerStageDescriptorUpdateAfterBindInlineUniformBlocks: uint32,
        maxDescriptorSetInlineUniformBlocks: uint32,
        maxDescriptorSetUpdateAfterBindInlineUniformBlocks: uint32,
        maxInlineUniformTotalSize: uint32,
        integerDotProduct8BitUnsignedAccelerated: uint32,
        integerDotProduct8BitSignedAccelerated: uint32,
        integerDotProduct8BitMixedSignednessAccelerated: uint32,
        integerDotProduct4x8BitPackedUnsignedAccelerated: uint32,
        integerDotProduct4x8BitPackedSignedAccelerated: uint32,
        integerDotProduct4x8BitPackedMixedSignednessAccelerated: uint32,
        integerDotProduct16BitUnsignedAccelerated: uint32,
        integerDotProduct16BitSignedAccelerated: uint32,
        integerDotProduct16BitMixedSignednessAccelerated: uint32,
        integerDotProduct32BitUnsignedAccelerated: uint32,
        integerDotProduct32BitSignedAccelerated: uint32,
        integerDotProduct32BitMixedSignednessAccelerated: uint32,
        integerDotProduct64BitUnsignedAccelerated: uint32,
        integerDotProduct64BitSignedAccelerated: uint32,
        integerDotProduct64BitMixedSignednessAccelerated: uint32,
        integerDotProductAccumulatingSaturating8BitUnsignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating8BitSignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating8BitMixedSignednessAccelerated: uint32,
        integerDotProductAccumulatingSaturating4x8BitPackedUnsignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating4x8BitPackedSignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating4x8BitPackedMixedSignednessAccelerated: uint32,
        integerDotProductAccumulatingSaturating16BitUnsignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating16BitSignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating16BitMixedSignednessAccelerated: uint32,
        integerDotProductAccumulatingSaturating32BitUnsignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating32BitSignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating32BitMixedSignednessAccelerated: uint32,
        integerDotProductAccumulatingSaturating64BitUnsignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating64BitSignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating64BitMixedSignednessAccelerated: uint32,
        storageTexelBufferOffsetAlignmentBytes: uint64,
        storageTexelBufferOffsetSingleTexelAlignment: uint32,
        uniformTexelBufferOffsetAlignmentBytes: uint64,
        uniformTexelBufferOffsetSingleTexelAlignment: uint32,
        maxBufferSize: uint64
}

state VkPipelineCreationFeedback
{
        flags: uint32,
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
        shaderTerminateInvocation: uint32
}

state VkPhysicalDeviceToolProperties
{
        sType: VkStructureType,
        pNext: *void,
        name: [256]byte,
        version: [256]byte,
        purposes: uint32,
        description: [256]byte,
        layer: [256]byte
}

state VkPhysicalDeviceShaderDemoteToHelperInvocationFeatures
{
        sType: VkStructureType,
        pNext: *void,
        shaderDemoteToHelperInvocation: uint32
}

state VkPhysicalDevicePrivateDataFeatures
{
        sType: VkStructureType,
        pNext: *void,
        privateData: uint32
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
        flags: uint32
}

state VkPhysicalDevicePipelineCreationCacheControlFeatures
{
        sType: VkStructureType,
        pNext: *void,
        pipelineCreationCacheControl: uint32
}

state VkMemoryBarrier2
{
        sType: VkStructureType,
        pNext: *void,
        srcStageMask: uint64,
        srcAccessMask: uint64,
        dstStageMask: uint64,
        dstAccessMask: uint64
}

state VkBufferMemoryBarrier2
{
        sType: VkStructureType,
        pNext: *void,
        srcStageMask: uint64,
        srcAccessMask: uint64,
        dstStageMask: uint64,
        dstAccessMask: uint64,
        srcQueueFamilyIndex: uint32,
        dstQueueFamilyIndex: uint32,
        buffer: *VkBuffer_T,
        offset: uint64,
        size: uint64
}

state VkImageMemoryBarrier2
{
        sType: VkStructureType,
        pNext: *void,
        srcStageMask: uint64,
        srcAccessMask: uint64,
        dstStageMask: uint64,
        dstAccessMask: uint64,
        oldLayout: VkImageLayout,
        newLayout: VkImageLayout,
        srcQueueFamilyIndex: uint32,
        dstQueueFamilyIndex: uint32,
        image: *VkImage_T,
        subresourceRange: VkImageSubresourceRange
}

state VkDependencyInfo
{
        sType: VkStructureType,
        pNext: *void,
        dependencyFlags: uint32,
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
        semaphore: *VkSemaphore_T,
        value: uint64,
        stageMask: uint64,
        deviceIndex: uint32
}

state VkCommandBufferSubmitInfo
{
        sType: VkStructureType,
        pNext: *void,
        commandBuffer: *VkCommandBuffer_T,
        deviceMask: uint32
}

state VkSubmitInfo2
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
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
        synchronization2: uint32
}

state VkPhysicalDeviceZeroInitializeWorkgroupMemoryFeatures
{
        sType: VkStructureType,
        pNext: *void,
        shaderZeroInitializeWorkgroupMemory: uint32
}

state VkPhysicalDeviceImageRobustnessFeatures
{
        sType: VkStructureType,
        pNext: *void,
        robustImageAccess: uint32
}

state VkBufferCopy2
{
        sType: VkStructureType,
        pNext: *void,
        srcOffset: uint64,
        dstOffset: uint64,
        size: uint64
}

state VkCopyBufferInfo2
{
        sType: VkStructureType,
        pNext: *void,
        srcBuffer: *VkBuffer_T,
        dstBuffer: *VkBuffer_T,
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
        srcImage: *VkImage_T,
        srcImageLayout: VkImageLayout,
        dstImage: *VkImage_T,
        dstImageLayout: VkImageLayout,
        regionCount: uint32,
        pRegions: *VkImageCopy2
}

state VkBufferImageCopy2
{
        sType: VkStructureType,
        pNext: *void,
        bufferOffset: uint64,
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
        srcBuffer: *VkBuffer_T,
        dstImage: *VkImage_T,
        dstImageLayout: VkImageLayout,
        regionCount: uint32,
        pRegions: *VkBufferImageCopy2
}

state VkCopyImageToBufferInfo2
{
        sType: VkStructureType,
        pNext: *void,
        srcImage: *VkImage_T,
        srcImageLayout: VkImageLayout,
        dstBuffer: *VkBuffer_T,
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
        srcImage: *VkImage_T,
        srcImageLayout: VkImageLayout,
        dstImage: *VkImage_T,
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
        srcImage: *VkImage_T,
        srcImageLayout: VkImageLayout,
        dstImage: *VkImage_T,
        dstImageLayout: VkImageLayout,
        regionCount: uint32,
        pRegions: *VkImageResolve2
}

state VkPhysicalDeviceSubgroupSizeControlFeatures
{
        sType: VkStructureType,
        pNext: *void,
        subgroupSizeControl: uint32,
        computeFullSubgroups: uint32
}

state VkPhysicalDeviceSubgroupSizeControlProperties
{
        sType: VkStructureType,
        pNext: *void,
        minSubgroupSize: uint32,
        maxSubgroupSize: uint32,
        maxComputeWorkgroupSubgroups: uint32,
        requiredSubgroupSizeStages: uint32
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
        inlineUniformBlock: uint32,
        descriptorBindingInlineUniformBlockUpdateAfterBind: uint32
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
        textureCompressionASTC_HDR: uint32
}

state VkRenderingAttachmentInfo
{
        sType: VkStructureType,
        pNext: *void,
        imageView: *VkImageView_T,
        imageLayout: VkImageLayout,
        resolveMode: VkResolveModeFlagBits,
        resolveImageView: *VkImageView_T,
        resolveImageLayout: VkImageLayout,
        loadOp: VkAttachmentLoadOp,
        storeOp: VkAttachmentStoreOp,
        clearValue: ?{color: ?{_float32: [4]float32, _int32: [4]int32, _uint32: [4]uint32}, depthStencil: VkClearDepthStencilValue}
}

state VkRenderingInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
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
        dynamicRendering: uint32
}

state VkCommandBufferInheritanceRenderingInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
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
        shaderIntegerDotProduct: uint32
}

state VkPhysicalDeviceShaderIntegerDotProductProperties
{
        sType: VkStructureType,
        pNext: *void,
        integerDotProduct8BitUnsignedAccelerated: uint32,
        integerDotProduct8BitSignedAccelerated: uint32,
        integerDotProduct8BitMixedSignednessAccelerated: uint32,
        integerDotProduct4x8BitPackedUnsignedAccelerated: uint32,
        integerDotProduct4x8BitPackedSignedAccelerated: uint32,
        integerDotProduct4x8BitPackedMixedSignednessAccelerated: uint32,
        integerDotProduct16BitUnsignedAccelerated: uint32,
        integerDotProduct16BitSignedAccelerated: uint32,
        integerDotProduct16BitMixedSignednessAccelerated: uint32,
        integerDotProduct32BitUnsignedAccelerated: uint32,
        integerDotProduct32BitSignedAccelerated: uint32,
        integerDotProduct32BitMixedSignednessAccelerated: uint32,
        integerDotProduct64BitUnsignedAccelerated: uint32,
        integerDotProduct64BitSignedAccelerated: uint32,
        integerDotProduct64BitMixedSignednessAccelerated: uint32,
        integerDotProductAccumulatingSaturating8BitUnsignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating8BitSignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating8BitMixedSignednessAccelerated: uint32,
        integerDotProductAccumulatingSaturating4x8BitPackedUnsignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating4x8BitPackedSignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating4x8BitPackedMixedSignednessAccelerated: uint32,
        integerDotProductAccumulatingSaturating16BitUnsignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating16BitSignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating16BitMixedSignednessAccelerated: uint32,
        integerDotProductAccumulatingSaturating32BitUnsignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating32BitSignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating32BitMixedSignednessAccelerated: uint32,
        integerDotProductAccumulatingSaturating64BitUnsignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating64BitSignedAccelerated: uint32,
        integerDotProductAccumulatingSaturating64BitMixedSignednessAccelerated: uint32
}

state VkPhysicalDeviceTexelBufferAlignmentProperties
{
        sType: VkStructureType,
        pNext: *void,
        storageTexelBufferOffsetAlignmentBytes: uint64,
        storageTexelBufferOffsetSingleTexelAlignment: uint32,
        uniformTexelBufferOffsetAlignmentBytes: uint64,
        uniformTexelBufferOffsetSingleTexelAlignment: uint32
}

state VkFormatProperties3
{
        sType: VkStructureType,
        pNext: *void,
        linearTilingFeatures: uint64,
        optimalTilingFeatures: uint64,
        bufferFeatures: uint64
}

state VkPhysicalDeviceMaintenance4Features
{
        sType: VkStructureType,
        pNext: *void,
        maintenance4: uint32
}

state VkPhysicalDeviceMaintenance4Properties
{
        sType: VkStructureType,
        pNext: *void,
        maxBufferSize: uint64
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
        globalPriorityQuery: uint32,
        shaderSubgroupRotate: uint32,
        shaderSubgroupRotateClustered: uint32,
        shaderFloatControls2: uint32,
        shaderExpectAssume: uint32,
        rectangularLines: uint32,
        bresenhamLines: uint32,
        smoothLines: uint32,
        stippledRectangularLines: uint32,
        stippledBresenhamLines: uint32,
        stippledSmoothLines: uint32,
        vertexAttributeInstanceRateDivisor: uint32,
        vertexAttributeInstanceRateZeroDivisor: uint32,
        indexTypeUint8: uint32,
        dynamicRenderingLocalRead: uint32,
        maintenance5: uint32,
        maintenance6: uint32,
        pipelineProtectedAccess: uint32,
        pipelineRobustness: uint32,
        hostImageCopy: uint32,
        pushDescriptor: uint32
}

state VkPhysicalDeviceVulkan14Properties
{
        sType: VkStructureType,
        pNext: *void,
        lineSubPixelPrecisionBits: uint32,
        maxVertexAttribDivisor: uint32,
        supportsNonZeroFirstInstance: uint32,
        maxPushDescriptors: uint32,
        dynamicRenderingLocalReadDepthStencilAttachments: uint32,
        dynamicRenderingLocalReadMultisampledAttachments: uint32,
        earlyFragmentMultisampleCoverageAfterSampleCounting: uint32,
        earlyFragmentSampleMaskTestBeforeSampleCounting: uint32,
        depthStencilSwizzleOneSupport: uint32,
        polygonModePointSize: uint32,
        nonStrictSinglePixelWideLinesUseParallelogram: uint32,
        nonStrictWideLinesUseParallelogram: uint32,
        blockTexelViewCompatibleMultipleLayers: uint32,
        maxCombinedImageSamplerDescriptorCount: uint32,
        fragmentShadingRateClampCombinerInputs: uint32,
        defaultRobustnessStorageBuffers: VkPipelineRobustnessBufferBehavior,
        defaultRobustnessUniformBuffers: VkPipelineRobustnessBufferBehavior,
        defaultRobustnessVertexInputs: VkPipelineRobustnessBufferBehavior,
        defaultRobustnessImages: VkPipelineRobustnessImageBehavior,
        copySrcLayoutCount: uint32,
        pCopySrcLayouts: *VkImageLayout,
        copyDstLayoutCount: uint32,
        pCopyDstLayouts: *VkImageLayout,
        optimalTilingLayoutUUID: [16]ubyte,
        identicalMemoryTypeRequirements: uint32
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
        globalPriorityQuery: uint32
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
        shaderSubgroupRotate: uint32,
        shaderSubgroupRotateClustered: uint32
}

state VkPhysicalDeviceShaderFloatControls2Features
{
        sType: VkStructureType,
        pNext: *void,
        shaderFloatControls2: uint32
}

state VkPhysicalDeviceShaderExpectAssumeFeatures
{
        sType: VkStructureType,
        pNext: *void,
        shaderExpectAssume: uint32
}

state VkPhysicalDeviceLineRasterizationFeatures
{
        sType: VkStructureType,
        pNext: *void,
        rectangularLines: uint32,
        bresenhamLines: uint32,
        smoothLines: uint32,
        stippledRectangularLines: uint32,
        stippledBresenhamLines: uint32,
        stippledSmoothLines: uint32
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
        stippledLineEnable: uint32,
        lineStippleFactor: uint32,
        lineStipplePattern: uint16
}

state VkPhysicalDeviceVertexAttributeDivisorProperties
{
        sType: VkStructureType,
        pNext: *void,
        maxVertexAttribDivisor: uint32,
        supportsNonZeroFirstInstance: uint32
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
        vertexAttributeInstanceRateDivisor: uint32,
        vertexAttributeInstanceRateZeroDivisor: uint32
}

state VkPhysicalDeviceIndexTypeUint8Features
{
        sType: VkStructureType,
        pNext: *void,
        indexTypeUint8: uint32
}

state VkMemoryMapInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        memory: *VkDeviceMemory_T,
        offset: uint64,
        size: uint64
}

state VkMemoryUnmapInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        memory: *VkDeviceMemory_T
}

state VkPhysicalDeviceMaintenance5Features
{
        sType: VkStructureType,
        pNext: *void,
        maintenance5: uint32
}

state VkPhysicalDeviceMaintenance5Properties
{
        sType: VkStructureType,
        pNext: *void,
        earlyFragmentMultisampleCoverageAfterSampleCounting: uint32,
        earlyFragmentSampleMaskTestBeforeSampleCounting: uint32,
        depthStencilSwizzleOneSupport: uint32,
        polygonModePointSize: uint32,
        nonStrictSinglePixelWideLinesUseParallelogram: uint32,
        nonStrictWideLinesUseParallelogram: uint32
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
        flags: uint64
}

state VkBufferUsageFlags2CreateInfo
{
        sType: VkStructureType,
        pNext: *void,
        usage: uint64
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
        dynamicRenderingLocalRead: uint32
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
        maintenance6: uint32
}

state VkPhysicalDeviceMaintenance6Properties
{
        sType: VkStructureType,
        pNext: *void,
        blockTexelViewCompatibleMultipleLayers: uint32,
        maxCombinedImageSamplerDescriptorCount: uint32,
        fragmentShadingRateClampCombinerInputs: uint32
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
        stageFlags: uint32,
        layout: *VkPipelineLayout_T,
        firstSet: uint32,
        descriptorSetCount: uint32,
        pDescriptorSets: **VkDescriptorSet_T,
        dynamicOffsetCount: uint32,
        pDynamicOffsets: *uint32
}

state VkPushConstantsInfo
{
        sType: VkStructureType,
        pNext: *void,
        layout: *VkPipelineLayout_T,
        stageFlags: uint32,
        offset: uint32,
        size: uint32,
        pValues: *void
}

state VkPushDescriptorSetInfo
{
        sType: VkStructureType,
        pNext: *void,
        stageFlags: uint32,
        layout: *VkPipelineLayout_T,
        set: uint32,
        descriptorWriteCount: uint32,
        pDescriptorWrites: *VkWriteDescriptorSet
}

state VkPushDescriptorSetWithTemplateInfo
{
        sType: VkStructureType,
        pNext: *void,
        descriptorUpdateTemplate: *VkDescriptorUpdateTemplate_T,
        layout: *VkPipelineLayout_T,
        set: uint32,
        pData: *void
}

state VkPhysicalDevicePipelineProtectedAccessFeatures
{
        sType: VkStructureType,
        pNext: *void,
        pipelineProtectedAccess: uint32
}

state VkPhysicalDevicePipelineRobustnessFeatures
{
        sType: VkStructureType,
        pNext: *void,
        pipelineRobustness: uint32
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
        hostImageCopy: uint32
}

state VkPhysicalDeviceHostImageCopyProperties
{
        sType: VkStructureType,
        pNext: *void,
        copySrcLayoutCount: uint32,
        pCopySrcLayouts: *VkImageLayout,
        copyDstLayoutCount: uint32,
        pCopyDstLayouts: *VkImageLayout,
        optimalTilingLayoutUUID: [16]ubyte,
        identicalMemoryTypeRequirements: uint32
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
        flags: uint32,
        dstImage: *VkImage_T,
        dstImageLayout: VkImageLayout,
        regionCount: uint32,
        pRegions: *VkMemoryToImageCopy
}

state VkCopyImageToMemoryInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        srcImage: *VkImage_T,
        srcImageLayout: VkImageLayout,
        regionCount: uint32,
        pRegions: *VkImageToMemoryCopy
}

state VkCopyImageToImageInfo
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        srcImage: *VkImage_T,
        srcImageLayout: VkImageLayout,
        dstImage: *VkImage_T,
        dstImageLayout: VkImageLayout,
        regionCount: uint32,
        pRegions: *VkImageCopy2
}

state VkHostImageLayoutTransitionInfo
{
        sType: VkStructureType,
        pNext: *void,
        image: *VkImage_T,
        oldLayout: VkImageLayout,
        newLayout: VkImageLayout,
        subresourceRange: VkImageSubresourceRange
}

state VkSubresourceHostMemcpySize
{
        sType: VkStructureType,
        pNext: *void,
        size: uint64
}

state VkHostImageCopyDevicePerformanceQuery
{
        sType: VkStructureType,
        pNext: *void,
        optimalDeviceAccess: uint32,
        identicalMemoryLayout: uint32
}

state VkSurfaceKHR_T
{
    opaque: any
}

state VkSurfaceCapabilitiesKHR
{
        minImageCount: uint32,
        maxImageCount: uint32,
        currentExtent: VkExtent2D,
        minImageExtent: VkExtent2D,
        maxImageExtent: VkExtent2D,
        maxImageArrayLayers: uint32,
        supportedTransforms: uint32,
        currentTransform: VkSurfaceTransformFlagBitsKHR,
        supportedCompositeAlpha: uint32,
        supportedUsageFlags: uint32
}

state VkSurfaceFormatKHR
{
        format: VkFormat,
        colorSpace: VkColorSpaceKHR
}

state VkSwapchainKHR_T
{
    opaque: any
}

state VkSwapchainCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        surface: *VkSurfaceKHR_T,
        minImageCount: uint32,
        imageFormat: VkFormat,
        imageColorSpace: VkColorSpaceKHR,
        imageExtent: VkExtent2D,
        imageArrayLayers: uint32,
        imageUsage: uint32,
        imageSharingMode: VkSharingMode,
        queueFamilyIndexCount: uint32,
        pQueueFamilyIndices: *uint32,
        preTransform: VkSurfaceTransformFlagBitsKHR,
        compositeAlpha: VkCompositeAlphaFlagBitsKHR,
        presentMode: VkPresentModeKHR,
        clipped: uint32,
        oldSwapchain: *VkSwapchainKHR_T
}

state VkPresentInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        waitSemaphoreCount: uint32,
        pWaitSemaphores: **VkSemaphore_T,
        swapchainCount: uint32,
        pSwapchains: **VkSwapchainKHR_T,
        pImageIndices: *uint32,
        pResults: *VkResult
}

state VkImageSwapchainCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        swapchain: *VkSwapchainKHR_T
}

state VkBindImageMemorySwapchainInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        swapchain: *VkSwapchainKHR_T,
        imageIndex: uint32
}

state VkAcquireNextImageInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        swapchain: *VkSwapchainKHR_T,
        timeout: uint64,
        semaphore: *VkSemaphore_T,
        fence: *VkFence_T,
        deviceMask: uint32
}

state VkDeviceGroupPresentCapabilitiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        presentMask: [32]uint32,
        modes: uint32
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
        modes: uint32
}

state VkDisplayKHR_T
{
    opaque: any
}

state VkDisplayModeKHR_T
{
    opaque: any
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
        flags: uint32,
        parameters: VkDisplayModeParametersKHR
}

state VkDisplayModePropertiesKHR
{
        displayMode: *VkDisplayModeKHR_T,
        parameters: VkDisplayModeParametersKHR
}

state VkDisplayPlaneCapabilitiesKHR
{
        supportedAlpha: uint32,
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
        currentDisplay: *VkDisplayKHR_T,
        currentStackIndex: uint32
}

state VkDisplayPropertiesKHR
{
        display: *VkDisplayKHR_T,
        displayName: *byte,
        physicalDimensions: VkExtent2D,
        physicalResolution: VkExtent2D,
        supportedTransforms: uint32,
        planeReorderPossible: uint32,
        persistentContent: uint32
}

state VkDisplaySurfaceCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        displayMode: *VkDisplayModeKHR_T,
        planeIndex: uint32,
        planeStackIndex: uint32,
        transform: VkSurfaceTransformFlagBitsKHR,
        globalAlpha: float32,
        alphaMode: VkDisplayPlaneAlphaFlagBitsKHR,
        imageExtent: VkExtent2D
}

state VkDisplayPresentInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        srcRect: VkRect2D,
        dstRect: VkRect2D,
        persistent: uint32
}

state VkVideoSessionKHR_T
{
    opaque: any
}

state VkVideoSessionParametersKHR_T
{
    opaque: any
}

state VkQueueFamilyQueryResultStatusPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        queryResultStatusSupport: uint32
}

state VkQueueFamilyVideoPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        videoCodecOperations: uint32
}

state VkVideoProfileInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        videoCodecOperation: VkVideoCodecOperationFlagBitsKHR,
        chromaSubsampling: uint32,
        lumaBitDepth: uint32,
        chromaBitDepth: uint32
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
        flags: uint32,
        minBitstreamBufferOffsetAlignment: uint64,
        minBitstreamBufferSizeAlignment: uint64,
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
        imageUsage: uint32
}

state VkVideoFormatPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        format: VkFormat,
        componentMapping: VkComponentMapping,
        imageCreateFlags: uint32,
        imageType: VkImageType,
        imageTiling: VkImageTiling,
        imageUsageFlags: uint32
}

state VkVideoPictureResourceInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        codedOffset: VkOffset2D,
        codedExtent: VkExtent2D,
        baseArrayLayer: uint32,
        imageViewBinding: *VkImageView_T
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
        memory: *VkDeviceMemory_T,
        memoryOffset: uint64,
        memorySize: uint64
}

state VkVideoSessionCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        queueFamilyIndex: uint32,
        flags: uint32,
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
        flags: uint32,
        videoSessionParametersTemplate: *VkVideoSessionParametersKHR_T,
        videoSession: *VkVideoSessionKHR_T
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
        flags: uint32,
        videoSession: *VkVideoSessionKHR_T,
        videoSessionParameters: *VkVideoSessionParametersKHR_T,
        referenceSlotCount: uint32,
        pReferenceSlots: *VkVideoReferenceSlotInfoKHR
}

state VkVideoEndCodingInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32
}

state VkVideoCodingControlInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32
}

state VkVideoDecodeCapabilitiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32
}

state VkVideoDecodeUsageInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        videoUsageHints: uint32
}

state VkVideoDecodeInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        srcBuffer: *VkBuffer_T,
        srcBufferOffset: uint64,
        srcBufferRange: uint64,
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
        preferredRateControlFlags: uint32,
        preferredGopFrameCount: uint32,
        preferredIdrPeriod: uint32,
        preferredConsecutiveBFrameCount: uint32,
        preferredTemporalLayerCount: uint32,
        preferredConstantQp: VkVideoEncodeH264QpKHR,
        preferredMaxL0ReferenceCount: uint32,
        preferredMaxL1ReferenceCount: uint32,
        preferredStdEntropyCodingModeFlag: uint32
}

state VkVideoEncodeH264SessionParametersCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        maxStdSPSCount: uint32,
        maxStdPPSCount: uint32,
        //pParametersAddInfo: *VkVideoEncodeH264SessionParametersAddInfoKHR
        pParametersAddInfo: *void
}

state VkVideoEncodeH264SessionParametersGetInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        writeStdSPS: uint32,
        writeStdPPS: uint32,
        stdSPSId: uint32,
        stdPPSId: uint32
}

state VkVideoEncodeH264SessionParametersFeedbackInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        hasStdSPSOverrides: uint32,
        hasStdPPSOverrides: uint32
}

state VkVideoEncodeH264RateControlInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
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
        useMinQp: uint32,
        minQp: VkVideoEncodeH264QpKHR,
        useMaxQp: uint32,
        maxQp: VkVideoEncodeH264QpKHR,
        useMaxFrameSize: uint32,
        maxFrameSize: VkVideoEncodeH264FrameSizeKHR
}

state VkVideoEncodeH264GopRemainingFrameInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        useGopRemainingFrames: uint32,
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
        preferredRateControlFlags: uint32,
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
        // pParametersAddInfo: *VkVideoEncodeH265SessionParametersAddInfoKHR
        pParametersAddInfo: *void
}

state VkVideoEncodeH265SessionParametersGetInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        writeStdVPS: uint32,
        writeStdSPS: uint32,
        writeStdPPS: uint32,
        stdVPSId: uint32,
        stdSPSId: uint32,
        stdPPSId: uint32
}

state VkVideoEncodeH265SessionParametersFeedbackInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        hasStdVPSOverrides: uint32,
        hasStdSPSOverrides: uint32,
        hasStdPPSOverrides: uint32
}

state VkVideoEncodeH265RateControlInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
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
        useMinQp: uint32,
        minQp: VkVideoEncodeH265QpKHR,
        useMaxQp: uint32,
        maxQp: VkVideoEncodeH265QpKHR,
        useMaxFrameSize: uint32,
        maxFrameSize: VkVideoEncodeH265FrameSizeKHR
}

state VkVideoEncodeH265GopRemainingFrameInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        useGopRemainingFrames: uint32,
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
        // pParametersAddInfo: *VkVideoDecodeH264SessionParametersAddInfoKHR
        pParametersAddInfo: *void
}

state VkImportMemoryFdInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        handleType: VkExternalMemoryHandleTypeFlagBits,
        fd: int32
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
        memory: *VkDeviceMemory_T,
        handleType: VkExternalMemoryHandleTypeFlagBits
}

state VkImportSemaphoreFdInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        semaphore: *VkSemaphore_T,
        flags: uint32,
        handleType: VkExternalSemaphoreHandleTypeFlagBits,
        fd: int32
}

state VkSemaphoreGetFdInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        semaphore: *VkSemaphore_T,
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
        sharedPresentSupportedUsageFlags: uint32
}

state VkImportFenceFdInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        fence: *VkFence_T,
        flags: uint32,
        handleType: VkExternalFenceHandleTypeFlagBits,
        fd: int32
}

state VkFenceGetFdInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        fence: *VkFence_T,
        handleType: VkExternalFenceHandleTypeFlagBits
}

state VkPhysicalDevicePerformanceQueryFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        performanceCounterQueryPools: uint32,
        performanceCounterMultipleQueryPools: uint32
}

state VkPhysicalDevicePerformanceQueryPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        allowCommandBufferQueryCopies: uint32
}

state VkPerformanceCounterKHR
{
        sType: VkStructureType,
        pNext: *void,
        unit: VkPerformanceCounterUnitKHR,
        scope: VkPerformanceCounterScopeKHR,
        storage: VkPerformanceCounterStorageKHR,
        uuid: [16]ubyte
}

state VkPerformanceCounterDescriptionKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
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
        flags: uint32,
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
        surface: *VkSurfaceKHR_T
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
        mode: *VkDisplayModeKHR_T,
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
        shaderSubgroupClock: uint32,
        shaderDeviceClock: uint32
}

state VkVideoDecodeH265SessionParametersCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        maxStdVPSCount: uint32,
        maxStdSPSCount: uint32,
        maxStdPPSCount: uint32,
        // pParametersAddInfo: *VkVideoDecodeH265SessionParametersAddInfoKHR
        pParametersAddInfo: *void
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
        pipelineFragmentShadingRate: uint32,
        primitiveFragmentShadingRate: uint32,
        attachmentFragmentShadingRate: uint32
}

state VkPhysicalDeviceFragmentShadingRatePropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        minFragmentShadingRateAttachmentTexelSize: VkExtent2D,
        maxFragmentShadingRateAttachmentTexelSize: VkExtent2D,
        maxFragmentShadingRateAttachmentTexelSizeAspectRatio: uint32,
        primitiveFragmentShadingRateWithMultipleViewports: uint32,
        layeredShadingRateAttachments: uint32,
        fragmentShadingRateNonTrivialCombinerOps: uint32,
        maxFragmentSize: VkExtent2D,
        maxFragmentSizeAspectRatio: uint32,
        maxFragmentShadingRateCoverageSamples: uint32,
        maxFragmentShadingRateRasterizationSamples: VkSampleCountFlagBits,
        fragmentShadingRateWithShaderDepthStencilWrites: uint32,
        fragmentShadingRateWithSampleMask: uint32,
        fragmentShadingRateWithShaderSampleMask: uint32,
        fragmentShadingRateWithConservativeRasterization: uint32,
        fragmentShadingRateWithFragmentShaderInterlock: uint32,
        fragmentShadingRateWithCustomSampleLocations: uint32,
        fragmentShadingRateStrictMultiplyCombiner: uint32
}

state VkPhysicalDeviceFragmentShadingRateKHR
{
        sType: VkStructureType,
        pNext: *void,
        sampleCounts: uint32,
        fragmentSize: VkExtent2D
}

state VkRenderingFragmentShadingRateAttachmentInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        imageView: *VkImageView_T,
        imageLayout: VkImageLayout,
        shadingRateAttachmentTexelSize: VkExtent2D
}

state VkPhysicalDeviceShaderQuadControlFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        shaderQuadControl: uint32
}

state VkSurfaceProtectedCapabilitiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        supportsProtected: uint32
}

state VkPhysicalDevicePresentWaitFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        presentWait: uint32
}

state VkDeferredOperationKHR_T
{
    opaque: any
}

state VkPhysicalDevicePipelineExecutablePropertiesFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        pipelineExecutableInfo: uint32
}

state VkPipelineInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        pipeline: *VkPipeline_T
}

state VkPipelineExecutablePropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        stages: uint32,
        name: [256]byte,
        description: [256]byte,
        subgroupSize: uint32
}

state VkPipelineExecutableInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        pipeline: *VkPipeline_T,
        executableIndex: uint32
}

state VkPipelineExecutableStatisticKHR
{
        sType: VkStructureType,
        pNext: *void,
        name: [256]byte,
        description: [256]byte,
        format: VkPipelineExecutableStatisticFormatKHR,
        value: ?{b32: uint32, i64: int64, u64: uint64, f64: float64}
}

state VkPipelineExecutableInternalRepresentationKHR
{
        sType: VkStructureType,
        pNext: *void,
        name: [256]byte,
        description: [256]byte,
        isText: uint32,
        dataSize: uint64,
        pData: *void
}

state VkPipelineLibraryCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        libraryCount: uint32,
        pLibraries: **VkPipeline_T
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
        presentId: uint32
}

state VkVideoEncodeInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        dstBuffer: *VkBuffer_T,
        dstBufferOffset: uint64,
        dstBufferRange: uint64,
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
        flags: uint32,
        rateControlModes: uint32,
        maxRateControlLayers: uint32,
        maxBitrate: uint64,
        maxQualityLevels: uint32,
        encodeInputPictureGranularity: VkExtent2D,
        supportedEncodeFeedbackFlags: uint32
}

state VkQueryPoolVideoEncodeFeedbackCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        encodeFeedbackFlags: uint32
}

state VkVideoEncodeUsageInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        videoUsageHints: uint32,
        videoContentHints: uint32,
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
        flags: uint32,
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
        videoSessionParameters: *VkVideoSessionParametersKHR_T
}

state VkVideoEncodeSessionParametersFeedbackInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        hasOverrides: uint32
}

state VkPhysicalDeviceFragmentShaderBarycentricFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        fragmentShaderBarycentric: uint32
}

state VkPhysicalDeviceFragmentShaderBarycentricPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        triStripVertexOrderIndependentOfProvokingVertex: uint32
}

state VkPhysicalDeviceShaderSubgroupUniformControlFlowFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        shaderSubgroupUniformControlFlow: uint32
}

state VkPhysicalDeviceWorkgroupMemoryExplicitLayoutFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        workgroupMemoryExplicitLayout: uint32,
        workgroupMemoryExplicitLayoutScalarBlockLayout: uint32,
        workgroupMemoryExplicitLayout8BitAccess: uint32,
        workgroupMemoryExplicitLayout16BitAccess: uint32
}

state VkPhysicalDeviceRayTracingMaintenance1FeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        rayTracingMaintenance1: uint32,
        rayTracingPipelineTraceRaysIndirect2: uint32
}

state VkTraceRaysIndirectCommand2KHR
{
        raygenShaderRecordAddress: uint64,
        raygenShaderRecordSize: uint64,
        missShaderBindingTableAddress: uint64,
        missShaderBindingTableSize: uint64,
        missShaderBindingTableStride: uint64,
        hitShaderBindingTableAddress: uint64,
        hitShaderBindingTableSize: uint64,
        hitShaderBindingTableStride: uint64,
        callableShaderBindingTableAddress: uint64,
        callableShaderBindingTableSize: uint64,
        callableShaderBindingTableStride: uint64,
        width: uint32,
        height: uint32,
        depth: uint32
}

state VkPhysicalDeviceShaderMaximalReconvergenceFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        shaderMaximalReconvergence: uint32
}

state VkPhysicalDeviceRayTracingPositionFetchFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        rayTracingPositionFetch: uint32
}

state VkPipelineBinaryKHR_T
{
    opaque: any
}

state VkPhysicalDevicePipelineBinaryFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        pipelineBinaries: uint32
}

state VkPhysicalDevicePipelineBinaryPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        pipelineBinaryInternalCache: uint32,
        pipelineBinaryInternalCacheControl: uint32,
        pipelineBinaryPrefersInternalCache: uint32,
        pipelineBinaryPrecompiledInternalCache: uint32,
        pipelineBinaryCompressedData: uint32
}

state VkDevicePipelineBinaryInternalCacheControlKHR
{
        sType: VkStructureType,
        pNext: *void,
        disableInternalCache: uint32
}

state VkPipelineBinaryKeyKHR
{
        sType: VkStructureType,
        pNext: *void,
        keySize: uint32,
        key: [32]ubyte
}

state VkPipelineBinaryDataKHR
{
        dataSize: uint64,
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
        pipeline: *VkPipeline_T,
        pPipelineCreateInfo: *VkPipelineCreateInfoKHR
}

state VkPipelineBinaryInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        binaryCount: uint32,
        pPipelineBinaries: **VkPipelineBinaryKHR_T
}

state VkReleaseCapturedPipelineDataInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        pipeline: *VkPipeline_T
}

state VkPipelineBinaryDataInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        pipelineBinary: *VkPipelineBinaryKHR_T
}

state VkPipelineBinaryHandlesInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        pipelineBinaryCount: uint32,
        pPipelineBinaries: **VkPipelineBinaryKHR_T
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
        saturatingAccumulation: uint32,
        scope: VkScopeKHR
}

state VkPhysicalDeviceCooperativeMatrixFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        cooperativeMatrix: uint32,
        cooperativeMatrixRobustBufferAccess: uint32
}

state VkPhysicalDeviceCooperativeMatrixPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        cooperativeMatrixSupportedStages: uint32
}

state VkPhysicalDeviceComputeShaderDerivativesFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        computeDerivativeGroupQuads: uint32,
        computeDerivativeGroupLinear: uint32
}

state VkPhysicalDeviceComputeShaderDerivativesPropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        meshAndTaskShaderDerivatives: uint32
}

state VkPhysicalDeviceVideoEncodeAV1FeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        videoEncodeAV1: uint32
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
        preferredRateControlFlags: uint32,
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
        useGopRemainingFrames: uint32,
        gopRemainingIntra: uint32,
        gopRemainingPredictive: uint32,
        gopRemainingBipredictive: uint32
}

state VkVideoEncodeAV1RateControlInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        gopFrameCount: uint32,
        keyFramePeriod: uint32,
        consecutiveBipredictiveFrameCount: uint32,
        temporalLayerCount: uint32
}

state VkVideoEncodeAV1RateControlLayerInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        useMinQIndex: uint32,
        minQIndex: VkVideoEncodeAV1QIndexKHR,
        useMaxQIndex: uint32,
        maxQIndex: VkVideoEncodeAV1QIndexKHR,
        useMaxFrameSize: uint32,
        maxFrameSize: VkVideoEncodeAV1FrameSizeKHR
}

state VkPhysicalDeviceVideoMaintenance1FeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        videoMaintenance1: uint32
}

state VkVideoInlineQueryInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        queryPool: *VkQueryPool_T,
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
        stageFlags: uint32,
        layout: *VkPipelineLayout_T,
        firstSet: uint32,
        setCount: uint32,
        pBufferIndices: *uint32,
        pOffsets: *uint64
}

state VkBindDescriptorBufferEmbeddedSamplersInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        stageFlags: uint32,
        layout: *VkPipelineLayout_T,
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
        quantizationMap: *VkImageView_T,
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
        videoEncodeQuantizationMap: uint32
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
        compatibleCtbSizes: uint32
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
        compatibleSuperblockSizes: uint32
}

state VkPhysicalDeviceShaderRelaxedExtendedInstructionFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        shaderRelaxedExtendedInstruction: uint32
}

state VkPhysicalDeviceMaintenance7FeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        maintenance7: uint32
}

state VkPhysicalDeviceMaintenance7PropertiesKHR
{
        sType: VkStructureType,
        pNext: *void,
        robustFragmentShadingRateAttachmentAccess: uint32,
        separateDepthStencilAttachmentAccess: uint32,
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
        maintenance8: uint32
}

state VkMemoryBarrierAccessFlags3KHR
{
        sType: VkStructureType,
        pNext: *void,
        srcAccessMask3: uint64,
        dstAccessMask3: uint64
}

state VkPhysicalDeviceVideoMaintenance2FeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        videoMaintenance2: uint32
}

state VkPhysicalDeviceDepthClampZeroOneFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        depthClampZeroOne: uint32
}

state VkDebugReportCallbackEXT_T
{
    opaque: any
}

state VkDebugReportCallbackCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        pfnCallback: ::(),
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
        tagSize: uint64,
        pTag: *void
}

state VkDebugMarkerMarkerInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        pMarkerName: *byte,
        color: [4]float32
}

state VkDedicatedAllocationImageCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        dedicatedAllocation: uint32
}

state VkDedicatedAllocationBufferCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        dedicatedAllocation: uint32
}

state VkDedicatedAllocationMemoryAllocateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        image: *VkImage_T,
        buffer: *VkBuffer_T
}

state VkPhysicalDeviceTransformFeedbackFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        transformFeedback: uint32,
        geometryStreams: uint32
}

state VkPhysicalDeviceTransformFeedbackPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        maxTransformFeedbackStreams: uint32,
        maxTransformFeedbackBuffers: uint32,
        maxTransformFeedbackBufferSize: uint64,
        maxTransformFeedbackStreamDataSize: uint32,
        maxTransformFeedbackBufferDataSize: uint32,
        maxTransformFeedbackBufferDataStride: uint32,
        transformFeedbackQueries: uint32,
        transformFeedbackStreamsLinesTriangles: uint32,
        transformFeedbackRasterizationStreamSelect: uint32,
        transformFeedbackDraw: uint32
}

state VkPipelineRasterizationStateStreamCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        rasterizationStream: uint32
}

state VkCuModuleNVX_T
{
    opaque: any
}

state VkCuFunctionNVX_T
{
    opaque: any
}

state VkCuModuleCreateInfoNVX
{
        sType: VkStructureType,
        pNext: *void,
        dataSize: uint64,
        pData: *void
}

state VkCuModuleTexturingModeCreateInfoNVX
{
        sType: VkStructureType,
        pNext: *void,
        use64bitTexturing: uint32
}

state VkCuFunctionCreateInfoNVX
{
        sType: VkStructureType,
        pNext: *void,
        module: *VkCuModuleNVX_T,
        pName: *byte
}

state VkCuLaunchInfoNVX
{
        sType: VkStructureType,
        pNext: *void,
        function: *VkCuFunctionNVX_T,
        gridDimX: uint32,
        gridDimY: uint32,
        gridDimZ: uint32,
        blockDimX: uint32,
        blockDimY: uint32,
        blockDimZ: uint32,
        sharedMemBytes: uint32,
        paramCount: uint64,
        pParams: **void,
        extraCount: uint64,
        pExtras: **void
}

state VkImageViewHandleInfoNVX
{
        sType: VkStructureType,
        pNext: *void,
        imageView: *VkImageView_T,
        descriptorType: VkDescriptorType,
        sampler: *VkSampler_T
}

state VkImageViewAddressPropertiesNVX
{
        sType: VkStructureType,
        pNext: *void,
        deviceAddress: uint64,
        size: uint64
}

state VkTextureLODGatherFormatPropertiesAMD
{
        sType: VkStructureType,
        pNext: *void,
        supportsTextureGatherLODBiasAMD: uint32
}

state VkShaderResourceUsageAMD
{
        numUsedVgprs: uint32,
        numUsedSgprs: uint32,
        ldsSizePerLocalWorkGroup: uint32,
        ldsUsageSizeInBytes: uint64,
        scratchMemUsageInBytes: uint64
}

state VkShaderStatisticsInfoAMD
{
        shaderStageMask: uint32,
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
        cornerSampledImage: uint32
}

state VkExternalImageFormatPropertiesNV
{
        imageFormatProperties: VkImageFormatProperties,
        externalMemoryFeatures: uint32,
        exportFromImportedHandleTypes: uint32,
        compatibleHandleTypes: uint32
}

state VkExternalMemoryImageCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        handleTypes: uint32
}

state VkExportMemoryAllocateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        handleTypes: uint32
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
        decodeModeSharedExponent: uint32
}

state VkConditionalRenderingBeginInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        buffer: *VkBuffer_T,
        offset: uint64,
        flags: uint32
}

state VkPhysicalDeviceConditionalRenderingFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        conditionalRendering: uint32,
        inheritedConditionalRendering: uint32
}

state VkCommandBufferInheritanceConditionalRenderingInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        conditionalRenderingEnable: uint32
}

state VkViewportWScalingNV
{
        xcoeff: float32,
        ycoeff: float32
}

state VkPipelineViewportWScalingStateCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        viewportWScalingEnable: uint32,
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
        supportedTransforms: uint32,
        currentTransform: VkSurfaceTransformFlagBitsKHR,
        supportedCompositeAlpha: uint32,
        supportedUsageFlags: uint32,
        supportedSurfaceCounters: uint32
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
        surfaceCounters: uint32
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
        perViewPositionAllComponents: uint32
}

state VkMultiviewPerViewAttributesInfoNVX
{
        sType: VkStructureType,
        pNext: *void,
        perViewAttributes: uint32,
        perViewAttributesPositionXOnly: uint32
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
        flags: uint32,
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
        flags: uint32,
        discardRectangleMode: VkDiscardRectangleModeEXT,
        discardRectangleCount: uint32,
        pDiscardRectangles: *VkRect2D
}

state VkPhysicalDeviceConservativeRasterizationPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        primitiveOverestimationSize: float32,
        maxExtraPrimitiveOverestimationSize: float32,
        extraPrimitiveOverestimationSizeGranularity: float32,
        primitiveUnderestimation: uint32,
        conservativePointAndLineRasterization: uint32,
        degenerateTrianglesRasterized: uint32,
        degenerateLinesRasterized: uint32,
        fullyCoveredFragmentShaderInputVariable: uint32,
        conservativeRasterizationPostDepthCoverage: uint32
}

state VkPipelineRasterizationConservativeStateCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        conservativeRasterizationMode: VkConservativeRasterizationModeEXT,
        extraPrimitiveOverestimationSize: float32
}

state VkPhysicalDeviceDepthClipEnableFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        depthClipEnable: uint32
}

state VkPipelineRasterizationDepthClipStateCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        depthClipEnable: uint32
}

state VkXYColorEXT
{
        x: float32,
        y: float32
}

state VkHdrMetadataEXT
{
        sType: VkStructureType,
        pNext: *void,
        displayPrimaryRed: VkXYColorEXT,
        displayPrimaryGreen: VkXYColorEXT,
        displayPrimaryBlue: VkXYColorEXT,
        whitePoint: VkXYColorEXT,
        maxLuminance: float32,
        minLuminance: float32,
        maxContentLightLevel: float32,
        maxFrameAverageLightLevel: float32
}

state VkPhysicalDeviceRelaxedLineRasterizationFeaturesIMG
{
        sType: VkStructureType,
        pNext: *void,
        relaxedLineRasterization: uint32
}

state VkDebugUtilsMessengerEXT_T
{
    opaque: any
}

state VkDebugUtilsLabelEXT
{
        sType: VkStructureType,
        pNext: *void,
        pLabelName: *byte,
        color: [4]float32
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
        flags: uint32,
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
        flags: uint32,
        messageSeverity: uint32,
        messageType: uint32,
        pfnUserCallback: ::(),
        pUserData: *void
}

state VkDebugUtilsObjectTagInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        objectType: VkObjectType,
        objectHandle: uint64,
        tagName: uint64,
        tagSize: uint64,
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
        x: float32,
        y: float32
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
        sampleLocationsEnable: uint32,
        sampleLocationsInfo: VkSampleLocationsInfoEXT
}

state VkPhysicalDeviceSampleLocationsPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        sampleLocationSampleCounts: uint32,
        maxSampleLocationGridSize: VkExtent2D,
        sampleLocationCoordinateRange: [2]float32,
        sampleLocationSubPixelBits: uint32,
        variableSampleLocations: uint32
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
        advancedBlendCoherentOperations: uint32
}

state VkPhysicalDeviceBlendOperationAdvancedPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        advancedBlendMaxColorAttachments: uint32,
        advancedBlendIndependentBlend: uint32,
        advancedBlendNonPremultipliedSrcColor: uint32,
        advancedBlendNonPremultipliedDstColor: uint32,
        advancedBlendCorrelatedOverlap: uint32,
        advancedBlendAllOperations: uint32
}

state VkPipelineColorBlendAdvancedStateCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        srcPremultiplied: uint32,
        dstPremultiplied: uint32,
        blendOverlap: VkBlendOverlapEXT
}

state VkPipelineCoverageToColorStateCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        coverageToColorEnable: uint32,
        coverageToColorLocation: uint32
}

state VkPipelineCoverageModulationStateCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        coverageModulationMode: VkCoverageModulationModeNV,
        coverageModulationTableEnable: uint32,
        coverageModulationTableCount: uint32,
        pCoverageModulationTable: *float32
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
        shaderSMBuiltins: uint32
}

state VkDrmFormatModifierPropertiesEXT
{
        drmFormatModifier: uint64,
        drmFormatModifierPlaneCount: uint32,
        drmFormatModifierTilingFeatures: uint32
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
        drmFormatModifierTilingFeatures: uint64
}

state VkDrmFormatModifierPropertiesList2EXT
{
        sType: VkStructureType,
        pNext: *void,
        drmFormatModifierCount: uint32,
        pDrmFormatModifierProperties: *VkDrmFormatModifierProperties2EXT
}

state VkValidationCacheEXT_T
{
    opaque: any
}

state VkValidationCacheCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        initialDataSize: uint64,
        pInitialData: *void
}

state VkShaderModuleValidationCacheCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        validationCache: *VkValidationCacheEXT_T
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
        shadingRateImageEnable: uint32,
        viewportCount: uint32,
        pShadingRatePalettes: *VkShadingRatePaletteNV
}

state VkPhysicalDeviceShadingRateImageFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        shadingRateImage: uint32,
        shadingRateCoarseSampleOrder: uint32
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

state VkAccelerationStructureNV_T
{
    opaque: any
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
        flags: uint32,
        stageCount: uint32,
        pStages: *VkPipelineShaderStageCreateInfo,
        groupCount: uint32,
        pGroups: *VkRayTracingShaderGroupCreateInfoNV,
        maxRecursionDepth: uint32,
        layout: *VkPipelineLayout_T,
        basePipelineHandle: *VkPipeline_T,
        basePipelineIndex: int32
}

state VkGeometryTrianglesNV
{
        sType: VkStructureType,
        pNext: *void,
        vertexData: *VkBuffer_T,
        vertexOffset: uint64,
        vertexCount: uint32,
        vertexStride: uint64,
        vertexFormat: VkFormat,
        indexData: *VkBuffer_T,
        indexOffset: uint64,
        indexCount: uint32,
        indexType: VkIndexType,
        transformData: *VkBuffer_T,
        transformOffset: uint64
}

state VkGeometryAABBNV
{
        sType: VkStructureType,
        pNext: *void,
        aabbData: *VkBuffer_T,
        numAABBs: uint32,
        stride: uint32,
        offset: uint64
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
        flags: uint32
}

state VkAccelerationStructureInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        type: VkAccelerationStructureTypeKHR,
        flags: uint32,
        instanceCount: uint32,
        geometryCount: uint32,
        pGeometries: *VkGeometryNV
}

state VkAccelerationStructureCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        compactedSize: uint64,
        info: VkAccelerationStructureInfoNV
}

state VkBindAccelerationStructureMemoryInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        accelerationStructure: *VkAccelerationStructureNV_T,
        memory: *VkDeviceMemory_T,
        memoryOffset: uint64,
        deviceIndexCount: uint32,
        pDeviceIndices: *uint32
}

state VkWriteDescriptorSetAccelerationStructureNV
{
        sType: VkStructureType,
        pNext: *void,
        accelerationStructureCount: uint32,
        pAccelerationStructures: **VkAccelerationStructureNV_T
}

state VkAccelerationStructureMemoryRequirementsInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        type: VkAccelerationStructureMemoryRequirementsTypeNV,
        accelerationStructure: *VkAccelerationStructureNV_T
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
        matrix: [3][4]float32
}

state VkAabbPositionsKHR
{
        minX: float32,
        minY: float32,
        minZ: float32,
        maxX: float32,
        maxY: float32,
        maxZ: float32
}

state VkAccelerationStructureInstanceKHR
{
        transform: VkTransformMatrixKHR,
        instanceCustomIndex: [3]ubyte,
        mask: ubyte,
        instanceShaderBindingTableRecordOffset: [3]ubyte,
        flags: ubyte,
        accelerationStructureReference: uint64
}

state VkPhysicalDeviceRepresentativeFragmentTestFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        representativeFragmentTest: uint32
}

state VkPipelineRepresentativeFragmentTestStateCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        representativeFragmentTestEnable: uint32
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
        filterCubic: uint32,
        filterCubicMinmax: uint32
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
        minImportedHostPointerAlignment: uint64
}

state VkPipelineCompilerControlCreateInfoAMD
{
        sType: VkStructureType,
        pNext: *void,
        compilerControlFlags: uint32
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
        taskShader: uint32,
        meshShader: uint32
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
        imageFootprint: uint32
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
        exclusiveScissor: uint32
}

state VkQueueFamilyCheckpointPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        checkpointExecutionStageMask: uint32
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
        checkpointExecutionStageMask: uint64
}

state VkCheckpointData2NV
{
        sType: VkStructureType,
        pNext: *void,
        stage: uint64,
        pCheckpointMarker: *void
}

state VkPhysicalDeviceShaderIntegerFunctions2FeaturesINTEL
{
        sType: VkStructureType,
        pNext: *void,
        shaderIntegerFunctions2: uint32
}

state VkPerformanceConfigurationINTEL_T
{
    opaque: any
}

state VkPerformanceValueINTEL
{
        type: VkPerformanceValueTypeINTEL,
        data: ?{value32: uint32, value64: uint64, valueFloat: float32, valueBool: uint32, valueString: *byte}
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
        enable: uint32,
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
        localDimmingSupport: uint32
}

state VkSwapchainDisplayNativeHdrCreateInfoAMD
{
        sType: VkStructureType,
        pNext: *void,
        localDimmingEnable: uint32
}

state VkPhysicalDeviceFragmentDensityMapFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        fragmentDensityMap: uint32,
        fragmentDensityMapDynamic: uint32,
        fragmentDensityMapNonSubsampledImages: uint32
}

state VkPhysicalDeviceFragmentDensityMapPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        minFragmentDensityTexelSize: VkExtent2D,
        maxFragmentDensityTexelSize: VkExtent2D,
        fragmentDensityInvocations: uint32
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
        imageView: *VkImageView_T,
        imageLayout: VkImageLayout
}

state VkPhysicalDeviceShaderCoreProperties2AMD
{
        sType: VkStructureType,
        pNext: *void,
        shaderCoreFeatures: uint32,
        activeComputeUnitCount: uint32
}

state VkPhysicalDeviceCoherentMemoryFeaturesAMD
{
        sType: VkStructureType,
        pNext: *void,
        deviceCoherentMemory: uint32
}

state VkPhysicalDeviceShaderImageAtomicInt64FeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderImageInt64Atomics: uint32,
        sparseImageInt64Atomics: uint32
}

state VkPhysicalDeviceMemoryBudgetPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        heapBudget: [16]uint64,
        heapUsage: [16]uint64
}

state VkPhysicalDeviceMemoryPriorityFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        memoryPriority: uint32
}

state VkMemoryPriorityAllocateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        priority: float32
}

state VkPhysicalDeviceDedicatedAllocationImageAliasingFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        dedicatedAllocationImageAliasing: uint32
}

state VkPhysicalDeviceBufferDeviceAddressFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        bufferDeviceAddress: uint32,
        bufferDeviceAddressCaptureReplay: uint32,
        bufferDeviceAddressMultiDevice: uint32
}

state VkBufferDeviceAddressCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        deviceAddress: uint64
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
        AType: VkComponentTypeKHR,
        BType: VkComponentTypeKHR,
        CType: VkComponentTypeKHR,
        DType: VkComponentTypeKHR,
        scope: VkScopeKHR
}

state VkPhysicalDeviceCooperativeMatrixFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        cooperativeMatrix: uint32,
        cooperativeMatrixRobustBufferAccess: uint32
}

state VkPhysicalDeviceCooperativeMatrixPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        cooperativeMatrixSupportedStages: uint32
}

state VkPhysicalDeviceCoverageReductionModeFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        coverageReductionMode: uint32
}

state VkPipelineCoverageReductionStateCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        coverageReductionMode: VkCoverageReductionModeNV
}

state VkFramebufferMixedSamplesCombinationNV
{
        sType: VkStructureType,
        pNext: *void,
        coverageReductionMode: VkCoverageReductionModeNV,
        rasterizationSamples: VkSampleCountFlagBits,
        depthStencilSamples: uint32,
        colorSamples: uint32
}

state VkPhysicalDeviceFragmentShaderInterlockFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        fragmentShaderSampleInterlock: uint32,
        fragmentShaderPixelInterlock: uint32,
        fragmentShaderShadingRateInterlock: uint32
}

state VkPhysicalDeviceYcbcrImageArraysFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        ycbcrImageArrays: uint32
}

state VkPhysicalDeviceProvokingVertexFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        provokingVertexLast: uint32,
        transformFeedbackPreservesProvokingVertex: uint32
}

state VkPhysicalDeviceProvokingVertexPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        provokingVertexModePerPipeline: uint32,
        transformFeedbackPreservesTriangleFanProvokingVertex: uint32
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
        flags: uint32
}

state VkPhysicalDeviceShaderAtomicFloatFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderBufferFloat32Atomics: uint32,
        shaderBufferFloat32AtomicAdd: uint32,
        shaderBufferFloat64Atomics: uint32,
        shaderBufferFloat64AtomicAdd: uint32,
        shaderSharedFloat32Atomics: uint32,
        shaderSharedFloat32AtomicAdd: uint32,
        shaderSharedFloat64Atomics: uint32,
        shaderSharedFloat64AtomicAdd: uint32,
        shaderImageFloat32Atomics: uint32,
        shaderImageFloat32AtomicAdd: uint32,
        sparseImageFloat32Atomics: uint32,
        sparseImageFloat32AtomicAdd: uint32
}

state VkPhysicalDeviceExtendedDynamicStateFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        extendedDynamicState: uint32
}

state VkPhysicalDeviceMapMemoryPlacedFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        memoryMapPlaced: uint32,
        memoryMapRangePlaced: uint32,
        memoryUnmapReserve: uint32
}

state VkPhysicalDeviceMapMemoryPlacedPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        minPlacedMemoryMapAlignment: uint64
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
        shaderBufferFloat16Atomics: uint32,
        shaderBufferFloat16AtomicAdd: uint32,
        shaderBufferFloat16AtomicMinMax: uint32,
        shaderBufferFloat32AtomicMinMax: uint32,
        shaderBufferFloat64AtomicMinMax: uint32,
        shaderSharedFloat16Atomics: uint32,
        shaderSharedFloat16AtomicAdd: uint32,
        shaderSharedFloat16AtomicMinMax: uint32,
        shaderSharedFloat32AtomicMinMax: uint32,
        shaderSharedFloat64AtomicMinMax: uint32,
        shaderImageFloat32AtomicMinMax: uint32,
        sparseImageFloat32AtomicMinMax: uint32
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
        supportedPresentScaling: uint32,
        supportedPresentGravityX: uint32,
        supportedPresentGravityY: uint32,
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
        swapchainMaintenance1: uint32
}

state VkSwapchainPresentFenceInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        swapchainCount: uint32,
        pFences: **VkFence_T
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
        scalingBehavior: uint32,
        presentGravityX: uint32,
        presentGravityY: uint32
}

state VkReleaseSwapchainImagesInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        swapchain: *VkSwapchainKHR_T,
        imageIndexCount: uint32,
        pImageIndices: *uint32
}

state VkIndirectCommandsLayoutNV_T
{
    opaque: any
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
        deviceGeneratedCommands: uint32
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
        pPipelines: **VkPipeline_T
}

state VkBindShaderGroupIndirectCommandNV
{
        groupIndex: uint32
}

state VkBindIndexBufferIndirectCommandNV
{
        bufferAddress: uint64,
        size: uint32,
        indexType: VkIndexType
}

state VkBindVertexBufferIndirectCommandNV
{
        bufferAddress: uint64,
        size: uint32,
        stride: uint32
}

state VkSetStateFlagsIndirectCommandNV
{
        data: uint32
}

state VkIndirectCommandsStreamNV
{
        buffer: *VkBuffer_T,
        offset: uint64
}

state VkIndirectCommandsLayoutTokenNV
{
        sType: VkStructureType,
        pNext: *void,
        tokenType: VkIndirectCommandsTokenTypeNV,
        stream: uint32,
        offset: uint32,
        vertexBindingUnit: uint32,
        vertexDynamicStride: uint32,
        pushconstantPipelineLayout: *VkPipelineLayout_T,
        pushconstantShaderStageFlags: uint32,
        pushconstantOffset: uint32,
        pushconstantSize: uint32,
        indirectStateFlags: uint32,
        indexTypeCount: uint32,
        pIndexTypes: *VkIndexType,
        pIndexTypeValues: *uint32
}

state VkIndirectCommandsLayoutCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
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
        pipeline: *VkPipeline_T,
        indirectCommandsLayout: *VkIndirectCommandsLayoutNV_T,
        streamCount: uint32,
        pStreams: *VkIndirectCommandsStreamNV,
        sequencesCount: uint32,
        preprocessBuffer: *VkBuffer_T,
        preprocessOffset: uint64,
        preprocessSize: uint64,
        sequencesCountBuffer: *VkBuffer_T,
        sequencesCountOffset: uint64,
        sequencesIndexBuffer: *VkBuffer_T,
        sequencesIndexOffset: uint64
}

state VkGeneratedCommandsMemoryRequirementsInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        pipelineBindPoint: VkPipelineBindPoint,
        pipeline: *VkPipeline_T,
        indirectCommandsLayout: *VkIndirectCommandsLayoutNV_T,
        maxSequencesCount: uint32
}

state VkPhysicalDeviceInheritedViewportScissorFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        inheritedViewportScissor2D: uint32
}

state VkCommandBufferInheritanceViewportScissorInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        viewportScissor2D: uint32,
        viewportDepthCount: uint32,
        pViewportDepths: *VkViewport
}

state VkPhysicalDeviceTexelBufferAlignmentFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        texelBufferAlignment: uint32
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
        depthBiasControl: uint32,
        leastRepresentableValueForceUnormRepresentation: uint32,
        floatRepresentation: uint32,
        depthBiasExact: uint32
}

state VkDepthBiasInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        depthBiasConstantFactor: float32,
        depthBiasClamp: float32,
        depthBiasSlopeFactor: float32
}

state VkDepthBiasRepresentationInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        depthBiasRepresentation: VkDepthBiasRepresentationEXT,
        depthBiasExact: uint32
}

state VkPhysicalDeviceDeviceMemoryReportFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        deviceMemoryReport: uint32
}

state VkDeviceMemoryReportCallbackDataEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        type: VkDeviceMemoryReportEventTypeEXT,
        memoryObjectId: uint64,
        size: uint64,
        objectType: VkObjectType,
        objectHandle: uint64,
        heapIndex: uint32
}

state VkDeviceDeviceMemoryReportCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        pfnUserCallback: ::(),
        pUserData: *void
}

state VkPhysicalDeviceRobustness2FeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        robustBufferAccess2: uint32,
        robustImageAccess2: uint32,
        nullDescriptor: uint32
}

state VkPhysicalDeviceRobustness2PropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        robustStorageBufferAccessSizeAlignment: uint64,
        robustUniformBufferAccessSizeAlignment: uint64
}

state VkSamplerCustomBorderColorCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        customBorderColor: ?{_float32: [4]float32, _int32: [4]int32, _uint32: [4]uint32},
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
        customBorderColors: uint32,
        customBorderColorWithoutFormat: uint32
}

state VkPhysicalDevicePresentBarrierFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        presentBarrier: uint32
}

state VkSurfaceCapabilitiesPresentBarrierNV
{
        sType: VkStructureType,
        pNext: *void,
        presentBarrierSupported: uint32
}

state VkSwapchainPresentBarrierCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        presentBarrierEnable: uint32
}

state VkPhysicalDeviceDiagnosticsConfigFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        diagnosticsConfig: uint32
}

state VkDeviceDiagnosticsConfigCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32
}

state VkCudaModuleNV_T
{
    opaque: any
}

state VkCudaFunctionNV_T
{
    opaque: any
}

state VkCudaModuleCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        dataSize: uint64,
        pData: *void
}

state VkCudaFunctionCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        module: *VkCudaModuleNV_T,
        pName: *byte
}

state VkCudaLaunchInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        function: *VkCudaFunctionNV_T,
        gridDimX: uint32,
        gridDimY: uint32,
        gridDimZ: uint32,
        blockDimX: uint32,
        blockDimY: uint32,
        blockDimZ: uint32,
        sharedMemBytes: uint32,
        paramCount: uint64,
        pParams: **void,
        extraCount: uint64,
        pExtras: **void
}

state VkPhysicalDeviceCudaKernelLaunchFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        cudaKernelLaunchFeatures: uint32
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

state VkAccelerationStructureKHR_T
{
    opaque: any
}

state VkPhysicalDeviceDescriptorBufferPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        combinedImageSamplerDescriptorSingleArray: uint32,
        bufferlessPushDescriptors: uint32,
        allowSamplerImageViewPostSubmitCreation: uint32,
        descriptorBufferOffsetAlignment: uint64,
        maxDescriptorBufferBindings: uint32,
        maxResourceDescriptorBufferBindings: uint32,
        maxSamplerDescriptorBufferBindings: uint32,
        maxEmbeddedImmutableSamplerBindings: uint32,
        maxEmbeddedImmutableSamplers: uint32,
        bufferCaptureReplayDescriptorDataSize: uint64,
        imageCaptureReplayDescriptorDataSize: uint64,
        imageViewCaptureReplayDescriptorDataSize: uint64,
        samplerCaptureReplayDescriptorDataSize: uint64,
        accelerationStructureCaptureReplayDescriptorDataSize: uint64,
        samplerDescriptorSize: uint64,
        combinedImageSamplerDescriptorSize: uint64,
        sampledImageDescriptorSize: uint64,
        storageImageDescriptorSize: uint64,
        uniformTexelBufferDescriptorSize: uint64,
        robustUniformTexelBufferDescriptorSize: uint64,
        storageTexelBufferDescriptorSize: uint64,
        robustStorageTexelBufferDescriptorSize: uint64,
        uniformBufferDescriptorSize: uint64,
        robustUniformBufferDescriptorSize: uint64,
        storageBufferDescriptorSize: uint64,
        robustStorageBufferDescriptorSize: uint64,
        inputAttachmentDescriptorSize: uint64,
        accelerationStructureDescriptorSize: uint64,
        maxSamplerDescriptorBufferRange: uint64,
        maxResourceDescriptorBufferRange: uint64,
        samplerDescriptorBufferAddressSpaceSize: uint64,
        resourceDescriptorBufferAddressSpaceSize: uint64,
        descriptorBufferAddressSpaceSize: uint64
}

state VkPhysicalDeviceDescriptorBufferDensityMapPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        combinedImageSamplerDensityMapDescriptorSize: uint64
}

state VkPhysicalDeviceDescriptorBufferFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        descriptorBuffer: uint32,
        descriptorBufferCaptureReplay: uint32,
        descriptorBufferImageLayoutIgnored: uint32,
        descriptorBufferPushDescriptors: uint32
}

state VkDescriptorAddressInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        address: uint64,
        range: uint64,
        format: VkFormat
}

state VkDescriptorBufferBindingInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        address: uint64,
        usage: uint32
}

state VkDescriptorBufferBindingPushDescriptorBufferHandleEXT
{
        sType: VkStructureType,
        pNext: *void,
        buffer: *VkBuffer_T
}

state VkDescriptorGetInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        type: VkDescriptorType,
        data: ?{pSampler: **VkSampler_T, pCombinedImageSampler: *VkDescriptorImageInfo, pInputAttachmentImage: *VkDescriptorImageInfo, pSampledImage: *VkDescriptorImageInfo, pStorageImage: *VkDescriptorImageInfo, pUniformTexelBuffer: *VkDescriptorAddressInfoEXT, pStorageTexelBuffer: *VkDescriptorAddressInfoEXT, pUniformBuffer: *VkDescriptorAddressInfoEXT, pStorageBuffer: *VkDescriptorAddressInfoEXT, accelerationStructure: uint64}
}

state VkBufferCaptureDescriptorDataInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        buffer: *VkBuffer_T
}

state VkImageCaptureDescriptorDataInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        image: *VkImage_T
}

state VkImageViewCaptureDescriptorDataInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        imageView: *VkImageView_T
}

state VkSamplerCaptureDescriptorDataInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        sampler: *VkSampler_T
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
        accelerationStructure: *VkAccelerationStructureKHR_T,
        accelerationStructureNV: *VkAccelerationStructureNV_T
}

state VkPhysicalDeviceGraphicsPipelineLibraryFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        graphicsPipelineLibrary: uint32
}

state VkPhysicalDeviceGraphicsPipelineLibraryPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        graphicsPipelineLibraryFastLinking: uint32,
        graphicsPipelineLibraryIndependentInterpolationDecoration: uint32
}

state VkGraphicsPipelineLibraryCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32
}

state VkPhysicalDeviceShaderEarlyAndLateFragmentTestsFeaturesAMD
{
        sType: VkStructureType,
        pNext: *void,
        shaderEarlyAndLateFragmentTests: uint32
}

state VkPhysicalDeviceFragmentShadingRateEnumsFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        fragmentShadingRateEnums: uint32,
        supersampleFragmentShadingRates: uint32,
        noInvocationFragmentShadingRates: uint32
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
        vertexData: ?{deviceAddress: uint64, hostAddress: *void}
}

state VkAccelerationStructureMotionInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        maxInstances: uint32,
        flags: uint32
}

state VkAccelerationStructureMatrixMotionInstanceNV
{
        transformT0: VkTransformMatrixKHR,
        transformT1: VkTransformMatrixKHR,
        instanceCustomIndex: [3]ubyte,
        mask: ubyte,
        instanceShaderBindingTableRecordOffset: [3]ubyte,
        flags: ubyte,
        accelerationStructureReference: uint64
}

state VkSRTDataNV
{
        sx: float32,
        a: float32,
        b: float32,
        pvx: float32,
        sy: float32,
        c: float32,
        pvy: float32,
        sz: float32,
        pvz: float32,
        qx: float32,
        qy: float32,
        qz: float32,
        qw: float32,
        tx: float32,
        ty: float32,
        tz: float32
}

state VkAccelerationStructureSRTMotionInstanceNV
{
        transformT0: VkSRTDataNV,
        transformT1: VkSRTDataNV,
        instanceCustomIndex: [3]ubyte,
        mask: ubyte,
        instanceShaderBindingTableRecordOffset: [3]ubyte,
        flags: ubyte,
        accelerationStructureReference: uint64
}

state VkAccelerationStructureMotionInstanceNV
{
        type: VkAccelerationStructureMotionInstanceTypeNV,
        flags: uint32,
        data: ?{staticInstance: VkAccelerationStructureInstanceKHR, matrixMotionInstance: VkAccelerationStructureMatrixMotionInstanceNV, srtMotionInstance: VkAccelerationStructureSRTMotionInstanceNV}
}

state VkPhysicalDeviceRayTracingMotionBlurFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        rayTracingMotionBlur: uint32,
        rayTracingMotionBlurPipelineTraceRaysIndirect: uint32
}

state VkPhysicalDeviceYcbcr2Plane444FormatsFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        ycbcr2plane444Formats: uint32
}

state VkPhysicalDeviceFragmentDensityMap2FeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        fragmentDensityMapDeferred: uint32
}

state VkPhysicalDeviceFragmentDensityMap2PropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        subsampledLoads: uint32,
        subsampledCoarseReconstructionEarlyAccess: uint32,
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
        imageCompressionControl: uint32
}

state VkImageCompressionControlEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        compressionControlPlaneCount: uint32,
        pFixedRateFlags: *uint32
}

state VkImageCompressionPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        imageCompressionFlags: uint32,
        imageCompressionFixedRateFlags: uint32
}

state VkPhysicalDeviceAttachmentFeedbackLoopLayoutFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        attachmentFeedbackLoopLayout: uint32
}

state VkPhysicalDevice4444FormatsFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        formatA4R4G4B4: uint32,
        formatA4B4G4R4: uint32
}

state VkPhysicalDeviceFaultFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        deviceFault: uint32,
        deviceFaultVendorBinary: uint32
}

state VkDeviceFaultCountsEXT
{
        sType: VkStructureType,
        pNext: *void,
        addressInfoCount: uint32,
        vendorInfoCount: uint32,
        vendorBinarySize: uint64
}

state VkDeviceFaultAddressInfoEXT
{
        addressType: VkDeviceFaultAddressTypeEXT,
        reportedAddress: uint64,
        addressPrecision: uint64
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
        pipelineCacheUUID: [16]ubyte,
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
        rasterizationOrderColorAttachmentAccess: uint32,
        rasterizationOrderDepthAttachmentAccess: uint32,
        rasterizationOrderStencilAttachmentAccess: uint32
}

state VkPhysicalDeviceRGBA10X6FormatsFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        formatRgba10x6WithoutYCbCrSampler: uint32
}

state VkPhysicalDeviceMutableDescriptorTypeFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        mutableDescriptorType: uint32
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
        vertexInputDynamicState: uint32
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
        hasPrimary: uint32,
        hasRender: uint32,
        primaryMajor: int64,
        primaryMinor: int64,
        renderMajor: int64,
        renderMinor: int64
}

state VkPhysicalDeviceAddressBindingReportFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        reportAddressBinding: uint32
}

state VkDeviceAddressBindingCallbackDataEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        baseAddress: uint64,
        size: uint64,
        bindingType: VkDeviceAddressBindingTypeEXT
}

state VkPhysicalDeviceDepthClipControlFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        depthClipControl: uint32
}

state VkPipelineViewportDepthClipControlCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        negativeOneToOne: uint32
}

state VkPhysicalDevicePrimitiveTopologyListRestartFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        primitiveTopologyListRestart: uint32,
        primitiveTopologyPatchListRestart: uint32
}

state VkPhysicalDevicePresentModeFifoLatestReadyFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        presentModeFifoLatestReady: uint32
}

state VkSubpassShadingPipelineCreateInfoHUAWEI
{
        sType: VkStructureType,
        pNext: *void,
        renderPass: *VkRenderPass_T,
        subpass: uint32
}

state VkPhysicalDeviceSubpassShadingFeaturesHUAWEI
{
        sType: VkStructureType,
        pNext: *void,
        subpassShading: uint32
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
        invocationMask: uint32
}

state VkMemoryGetRemoteAddressInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        memory: *VkDeviceMemory_T,
        handleType: VkExternalMemoryHandleTypeFlagBits
}

state VkPhysicalDeviceExternalMemoryRDMAFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        externalMemoryRDMA: uint32
}

state VkPipelinePropertiesIdentifierEXT
{
        sType: VkStructureType,
        pNext: *void,
        pipelineIdentifier: [16]ubyte
}

state VkPhysicalDevicePipelinePropertiesFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        pipelinePropertiesIdentifier: uint32
}

state VkPhysicalDeviceFrameBoundaryFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        frameBoundary: uint32
}

state VkFrameBoundaryEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        frameID: uint64,
        imageCount: uint32,
        pImages: **VkImage_T,
        bufferCount: uint32,
        pBuffers: **VkBuffer_T,
        tagName: uint64,
        tagSize: uint64,
        pTag: *void
}

state VkPhysicalDeviceMultisampledRenderToSingleSampledFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        multisampledRenderToSingleSampled: uint32
}

state VkSubpassResolvePerformanceQueryEXT
{
        sType: VkStructureType,
        pNext: *void,
        optimal: uint32
}

state VkMultisampledRenderToSingleSampledInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        multisampledRenderToSingleSampledEnable: uint32,
        rasterizationSamples: VkSampleCountFlagBits
}

state VkPhysicalDeviceExtendedDynamicState2FeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        extendedDynamicState2: uint32,
        extendedDynamicState2LogicOp: uint32,
        extendedDynamicState2PatchControlPoints: uint32
}

state VkPhysicalDeviceColorWriteEnableFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        colorWriteEnable: uint32
}

state VkPipelineColorWriteCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        attachmentCount: uint32,
        pColorWriteEnables: *uint32
}

state VkPhysicalDevicePrimitivesGeneratedQueryFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        primitivesGeneratedQuery: uint32,
        primitivesGeneratedQueryWithRasterizerDiscard: uint32,
        primitivesGeneratedQueryWithNonZeroStreams: uint32
}

state VkPhysicalDeviceImageViewMinLodFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        minLod: uint32
}

state VkImageViewMinLodCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        minLod: float32
}

state VkPhysicalDeviceMultiDrawFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        multiDraw: uint32
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
        image2DViewOf3D: uint32,
        sampler2DViewOf3D: uint32
}

state VkPhysicalDeviceShaderTileImageFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderTileImageColorReadAccess: uint32,
        shaderTileImageDepthReadAccess: uint32,
        shaderTileImageStencilReadAccess: uint32
}

state VkPhysicalDeviceShaderTileImagePropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderTileImageCoherentReadAccelerated: uint32,
        shaderTileImageReadSampleFromPixelRateInvocation: uint32,
        shaderTileImageReadFromHelperInvocation: uint32
}

state VkMicromapEXT_T
{
    opaque: any
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
        flags: uint32,
        mode: VkBuildMicromapModeEXT,
        dstMicromap: *VkMicromapEXT_T,
        usageCountsCount: uint32,
        pUsageCounts: *VkMicromapUsageEXT,
        ppUsageCounts: **VkMicromapUsageEXT,
        data: ?{deviceAddress: uint64, hostAddress: *void},
        scratchData: ?{deviceAddress: uint64, hostAddress: *void},
        triangleArray: ?{deviceAddress: uint64, hostAddress: *void},
        triangleArrayStride: uint64
}

state VkMicromapCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        createFlags: uint32,
        buffer: *VkBuffer_T,
        offset: uint64,
        size: uint64,
        type: VkMicromapTypeEXT,
        deviceAddress: uint64
}

state VkPhysicalDeviceOpacityMicromapFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        micromap: uint32,
        micromapCaptureReplay: uint32,
        micromapHostCommands: uint32
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
        pVersionData: *ubyte
}

state VkCopyMicromapToMemoryInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        src: *VkMicromapEXT_T,
        dst: ?{deviceAddress: uint64, hostAddress: *void},
        mode: VkCopyMicromapModeEXT
}

state VkCopyMemoryToMicromapInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        src: ?{deviceAddress: uint64, hostAddress: *void},
        dst: *VkMicromapEXT_T,
        mode: VkCopyMicromapModeEXT
}

state VkCopyMicromapInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        src: *VkMicromapEXT_T,
        dst: *VkMicromapEXT_T,
        mode: VkCopyMicromapModeEXT
}

state VkMicromapBuildSizesInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        micromapSize: uint64,
        buildScratchSize: uint64,
        discardable: uint32
}

state VkAccelerationStructureTrianglesOpacityMicromapEXT
{
        sType: VkStructureType,
        pNext: *void,
        indexType: VkIndexType,
        indexBuffer: ?{deviceAddress: uint64, hostAddress: *void},
        indexStride: uint64,
        baseTriangle: uint32,
        usageCountsCount: uint32,
        pUsageCounts: *VkMicromapUsageEXT,
        ppUsageCounts: **VkMicromapUsageEXT,
        micromap: *VkMicromapEXT_T
}

state VkMicromapTriangleEXT
{
        dataOffset: uint32,
        subdivisionLevel: uint16,
        format: uint16
}

state VkPhysicalDeviceClusterCullingShaderFeaturesHUAWEI
{
        sType: VkStructureType,
        pNext: *void,
        clustercullingShader: uint32,
        multiviewClusterCullingShader: uint32
}

state VkPhysicalDeviceClusterCullingShaderPropertiesHUAWEI
{
        sType: VkStructureType,
        pNext: *void,
        maxWorkGroupCount: [3]uint32,
        maxWorkGroupSize: [3]uint32,
        maxOutputClusterCount: uint32,
        indirectBufferOffsetAlignment: uint64
}

state VkPhysicalDeviceClusterCullingShaderVrsFeaturesHUAWEI
{
        sType: VkStructureType,
        pNext: *void,
        clusterShadingRate: uint32
}

state VkPhysicalDeviceBorderColorSwizzleFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        borderColorSwizzle: uint32,
        borderColorSwizzleFromImage: uint32
}

state VkSamplerBorderColorComponentMappingCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        components: VkComponentMapping,
        srgb: uint32
}

state VkPhysicalDevicePageableDeviceLocalMemoryFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        pageableDeviceLocalMemory: uint32
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
        schedulingControls: uint32
}

state VkPhysicalDeviceSchedulingControlsPropertiesARM
{
        sType: VkStructureType,
        pNext: *void,
        schedulingControlsFlags: uint64
}

state VkPhysicalDeviceImageSlicedViewOf3DFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        imageSlicedViewOf3D: uint32
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
        descriptorSetHostMapping: uint32
}

state VkDescriptorSetBindingReferenceVALVE
{
        sType: VkStructureType,
        pNext: *void,
        descriptorSetLayout: *VkDescriptorSetLayout_T,
        binding: uint32
}

state VkDescriptorSetLayoutHostMappingInfoVALVE
{
        sType: VkStructureType,
        pNext: *void,
        descriptorOffset: uint64,
        descriptorSize: uint32
}

state VkPhysicalDeviceNonSeamlessCubeMapFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        nonSeamlessCubeMap: uint32
}

state VkPhysicalDeviceRenderPassStripedFeaturesARM
{
        sType: VkStructureType,
        pNext: *void,
        renderPassStriped: uint32
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
        fragmentDensityMapOffset: uint32
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
        srcAddress: uint64,
        dstAddress: uint64,
        size: uint64
}

state VkCopyMemoryToImageIndirectCommandNV
{
        srcAddress: uint64,
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
        indirectCopy: uint32
}

state VkPhysicalDeviceCopyMemoryIndirectPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        supportedQueues: uint32
}

state VkDecompressMemoryRegionNV
{
        srcAddress: uint64,
        dstAddress: uint64,
        compressedSize: uint64,
        decompressedSize: uint64,
        decompressionMethod: uint64
}

state VkPhysicalDeviceMemoryDecompressionFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        memoryDecompression: uint32
}

state VkPhysicalDeviceMemoryDecompressionPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        decompressionMethods: uint64,
        maxDecompressionIndirectCount: uint64
}

state VkPhysicalDeviceDeviceGeneratedCommandsComputeFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        deviceGeneratedCompute: uint32,
        deviceGeneratedComputePipelines: uint32,
        deviceGeneratedComputeCaptureReplay: uint32
}

state VkComputePipelineIndirectBufferInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        deviceAddress: uint64,
        size: uint64,
        pipelineDeviceAddressCaptureReplay: uint64
}

state VkPipelineIndirectDeviceAddressInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        pipelineBindPoint: VkPipelineBindPoint,
        pipeline: *VkPipeline_T
}

state VkBindPipelineIndirectCommandNV
{
        pipelineAddress: uint64
}

state VkPhysicalDeviceRayTracingLinearSweptSpheresFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        spheres: uint32,
        linearSweptSpheres: uint32
}

state VkAccelerationStructureGeometryLinearSweptSpheresDataNV
{
        sType: VkStructureType,
        pNext: *void,
        vertexFormat: VkFormat,
        vertexData: ?{deviceAddress: uint64, hostAddress: *void},
        vertexStride: uint64,
        radiusFormat: VkFormat,
        radiusData: ?{deviceAddress: uint64, hostAddress: *void},
        radiusStride: uint64,
        indexType: VkIndexType,
        indexData: ?{deviceAddress: uint64, hostAddress: *void},
        indexStride: uint64,
        indexingMode: VkRayTracingLssIndexingModeNV,
        endCapsMode: VkRayTracingLssPrimitiveEndCapsModeNV
}

state VkAccelerationStructureGeometrySpheresDataNV
{
        sType: VkStructureType,
        pNext: *void,
        vertexFormat: VkFormat,
        vertexData: ?{deviceAddress: uint64, hostAddress: *void},
        vertexStride: uint64,
        radiusFormat: VkFormat,
        radiusData: ?{deviceAddress: uint64, hostAddress: *void},
        radiusStride: uint64,
        indexType: VkIndexType,
        indexData: ?{deviceAddress: uint64, hostAddress: *void},
        indexStride: uint64
}

state VkPhysicalDeviceLinearColorAttachmentFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        linearColorAttachment: uint32
}

state VkPhysicalDeviceImageCompressionControlSwapchainFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        imageCompressionControlSwapchain: uint32
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
        textureSampleWeighted: uint32,
        textureBoxFilter: uint32,
        textureBlockMatch: uint32
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
        nestedCommandBuffer: uint32,
        nestedCommandBufferRendering: uint32,
        nestedCommandBufferSimultaneousUse: uint32
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
        acquireUnmodifiedMemory: uint32
}

state VkPhysicalDeviceExtendedDynamicState3FeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        extendedDynamicState3TessellationDomainOrigin: uint32,
        extendedDynamicState3DepthClampEnable: uint32,
        extendedDynamicState3PolygonMode: uint32,
        extendedDynamicState3RasterizationSamples: uint32,
        extendedDynamicState3SampleMask: uint32,
        extendedDynamicState3AlphaToCoverageEnable: uint32,
        extendedDynamicState3AlphaToOneEnable: uint32,
        extendedDynamicState3LogicOpEnable: uint32,
        extendedDynamicState3ColorBlendEnable: uint32,
        extendedDynamicState3ColorBlendEquation: uint32,
        extendedDynamicState3ColorWriteMask: uint32,
        extendedDynamicState3RasterizationStream: uint32,
        extendedDynamicState3ConservativeRasterizationMode: uint32,
        extendedDynamicState3ExtraPrimitiveOverestimationSize: uint32,
        extendedDynamicState3DepthClipEnable: uint32,
        extendedDynamicState3SampleLocationsEnable: uint32,
        extendedDynamicState3ColorBlendAdvanced: uint32,
        extendedDynamicState3ProvokingVertexMode: uint32,
        extendedDynamicState3LineRasterizationMode: uint32,
        extendedDynamicState3LineStippleEnable: uint32,
        extendedDynamicState3DepthClipNegativeOneToOne: uint32,
        extendedDynamicState3ViewportWScalingEnable: uint32,
        extendedDynamicState3ViewportSwizzle: uint32,
        extendedDynamicState3CoverageToColorEnable: uint32,
        extendedDynamicState3CoverageToColorLocation: uint32,
        extendedDynamicState3CoverageModulationMode: uint32,
        extendedDynamicState3CoverageModulationTableEnable: uint32,
        extendedDynamicState3CoverageModulationTable: uint32,
        extendedDynamicState3CoverageReductionMode: uint32,
        extendedDynamicState3RepresentativeFragmentTestEnable: uint32,
        extendedDynamicState3ShadingRateImageEnable: uint32
}

state VkPhysicalDeviceExtendedDynamicState3PropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        dynamicPrimitiveTopologyUnrestricted: uint32
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
        srcPremultiplied: uint32,
        dstPremultiplied: uint32,
        blendOverlap: VkBlendOverlapEXT,
        clampResults: uint32
}

state VkPhysicalDeviceSubpassMergeFeedbackFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        subpassMergeFeedback: uint32
}

state VkRenderPassCreationControlEXT
{
        sType: VkStructureType,
        pNext: *void,
        disallowMerging: uint32
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
        flags: uint32,
        pfnGetInstanceProcAddr: ::()
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
        shaderModuleIdentifier: uint32
}

state VkPhysicalDeviceShaderModuleIdentifierPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderModuleIdentifierAlgorithmUUID: [16]ubyte
}

state VkPipelineShaderStageModuleIdentifierCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        identifierSize: uint32,
        pIdentifier: *ubyte
}

state VkShaderModuleIdentifierEXT
{
        sType: VkStructureType,
        pNext: *void,
        identifierSize: uint32,
        identifier: [32]ubyte
}

state VkOpticalFlowSessionNV_T
{
    opaque: any
}

state VkPhysicalDeviceOpticalFlowFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        opticalFlow: uint32
}

state VkPhysicalDeviceOpticalFlowPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        supportedOutputGridSizes: uint32,
        supportedHintGridSizes: uint32,
        hintSupported: uint32,
        costSupported: uint32,
        bidirectionalFlowSupported: uint32,
        globalFlowSupported: uint32,
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
        usage: uint32
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
        outputGridSize: uint32,
        hintGridSize: uint32,
        performanceLevel: VkOpticalFlowPerformanceLevelNV,
        flags: uint32
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
        flags: uint32,
        regionCount: uint32,
        pRegions: *VkRect2D
}

state VkPhysicalDeviceLegacyDitheringFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        legacyDithering: uint32
}

state VkPhysicalDeviceAntiLagFeaturesAMD
{
        sType: VkStructureType,
        pNext: *void,
        antiLag: uint32
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

state VkShaderEXT_T
{
    opaque: any
}

state VkPhysicalDeviceShaderObjectFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderObject: uint32
}

state VkPhysicalDeviceShaderObjectPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderBinaryUUID: [16]ubyte,
        shaderBinaryVersion: uint32
}

state VkShaderCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        stage: VkShaderStageFlagBits,
        nextStage: uint32,
        codeType: VkShaderCodeTypeEXT,
        codeSize: uint64,
        pCode: *void,
        pName: *byte,
        setLayoutCount: uint32,
        pSetLayouts: **VkDescriptorSetLayout_T,
        pushConstantRangeCount: uint32,
        pPushConstantRanges: *VkPushConstantRange,
        pSpecializationInfo: *VkSpecializationInfo
}

state VkDepthClampRangeEXT
{
        minDepthClamp: float32,
        maxDepthClamp: float32
}

state VkPhysicalDeviceTilePropertiesFeaturesQCOM
{
        sType: VkStructureType,
        pNext: *void,
        tileProperties: uint32
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
        amigoProfiling: uint32
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
        multiviewPerViewViewports: uint32
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
        rayTracingInvocationReorder: uint32
}

state VkPhysicalDeviceCooperativeVectorPropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        cooperativeVectorSupportedStages: uint32,
        cooperativeVectorTrainingFloat16Accumulation: uint32,
        cooperativeVectorTrainingFloat32Accumulation: uint32,
        maxCooperativeVectorComponents: uint32
}

state VkPhysicalDeviceCooperativeVectorFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        cooperativeVector: uint32,
        cooperativeVectorTraining: uint32
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
        transpose: uint32
}

state VkConvertCooperativeVectorMatrixInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        srcSize: uint64,
        srcData: ?{deviceAddress: uint64, hostAddress: *void},
        pDstSize: *uint64,
        dstData: ?{deviceAddress: uint64, hostAddress: *void},
        srcComponentType: VkComponentTypeKHR,
        dstComponentType: VkComponentTypeKHR,
        numRows: uint32,
        numColumns: uint32,
        srcLayout: VkCooperativeVectorMatrixLayoutNV,
        srcStride: uint64,
        dstLayout: VkCooperativeVectorMatrixLayoutNV,
        dstStride: uint64
}

state VkPhysicalDeviceExtendedSparseAddressSpaceFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        extendedSparseAddressSpace: uint32
}

state VkPhysicalDeviceExtendedSparseAddressSpacePropertiesNV
{
        sType: VkStructureType,
        pNext: *void,
        extendedSparseAddressSpaceSize: uint64,
        extendedSparseImageUsageFlags: uint32,
        extendedSparseBufferUsageFlags: uint32
}

state VkPhysicalDeviceLegacyVertexAttributesFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        legacyVertexAttributes: uint32
}

state VkPhysicalDeviceLegacyVertexAttributesPropertiesEXT
{
        sType: VkStructureType,
        pNext: *void,
        nativeUnalignedPerformance: uint32
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
        shaderCoreBuiltins: uint32
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
        pipelineLibraryGroupHandles: uint32
}

state VkPhysicalDeviceDynamicRenderingUnusedAttachmentsFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        dynamicRenderingUnusedAttachments: uint32
}

state VkLatencySleepModeInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        lowLatencyMode: uint32,
        lowLatencyBoost: uint32,
        minimumIntervalUs: uint32
}

state VkLatencySleepInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        signalSemaphore: *VkSemaphore_T,
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
        latencyModeEnable: uint32
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
        multiviewPerViewRenderAreas: uint32
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
        perStageDescriptorSet: uint32,
        dynamicPipelineLayout: uint32
}

state VkPhysicalDeviceImageProcessing2FeaturesQCOM
{
        sType: VkStructureType,
        pNext: *void,
        textureBlockMatch2: uint32
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
        selectableCubicWeights: uint32
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
        ycbcrDegamma: uint32
}

state VkSamplerYcbcrConversionYcbcrDegammaCreateInfoQCOM
{
        sType: VkStructureType,
        pNext: *void,
        enableYDegamma: uint32,
        enableCbCrDegamma: uint32
}

state VkPhysicalDeviceCubicClampFeaturesQCOM
{
        sType: VkStructureType,
        pNext: *void,
        cubicRangeClamp: uint32
}

state VkPhysicalDeviceAttachmentFeedbackLoopDynamicStateFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        attachmentFeedbackLoopDynamicState: uint32
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
        descriptorPoolOverallocation: uint32
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
        hdmi3DSupported: uint32
}

state VkPhysicalDeviceRawAccessChainsFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        shaderRawAccessChains: uint32
}

state VkPhysicalDeviceCommandBufferInheritanceFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        commandBufferInheritance: uint32
}

state VkPhysicalDeviceShaderAtomicFloat16VectorFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        shaderFloat16VectorAtomics: uint32
}

state VkPhysicalDeviceShaderReplicatedCompositesFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderReplicatedComposites: uint32
}

state VkPhysicalDeviceRayTracingValidationFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        rayTracingValidation: uint32
}

state VkPhysicalDeviceClusterAccelerationStructureFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        clusterAccelerationStructure: uint32
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
        noMoveOverlap: uint32,
        maxMovedBytes: uint64
}

state VkClusterAccelerationStructureInputInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        maxAccelerationStructureCount: uint32,
        flags: uint32,
        opType: VkClusterAccelerationStructureOpTypeNV,
        opMode: VkClusterAccelerationStructureOpModeNV,
        opInput: ?{pClustersBottomLevel: *VkClusterAccelerationStructureClustersBottomLevelInputNV, pTriangleClusters: *VkClusterAccelerationStructureTriangleClusterInputNV, pMoveObjects: *VkClusterAccelerationStructureMoveObjectsInputNV}
}

state VkStridedDeviceAddressRegionKHR
{
        deviceAddress: uint64,
        stride: uint64,
        size: uint64
}

state VkClusterAccelerationStructureCommandsInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        input: VkClusterAccelerationStructureInputInfoNV,
        dstImplicitData: uint64,
        scratchData: uint64,
        dstAddressesArray: VkStridedDeviceAddressRegionKHR,
        dstSizesArray: VkStridedDeviceAddressRegionKHR,
        srcInfosArray: VkStridedDeviceAddressRegionKHR,
        srcInfosCount: uint64,
        addressResolutionFlags: uint32
}

state VkStridedDeviceAddressNV
{
        startAddress: uint64,
        strideInBytes: uint64
}

state VkClusterAccelerationStructureGeometryIndexAndGeometryFlagsNV
{
        geometryIndex: [3]ubyte,
        // reserved: 5,
        // geometryFlags: 3
        bitField: ubyte
}

state VkClusterAccelerationStructureMoveObjectsInfoNV
{
        srcAccelerationStructure: uint64
}

state VkClusterAccelerationStructureBuildClustersBottomLevelInfoNV
{
        clusterReferencesCount: uint32,
        clusterReferencesStride: uint32,
        clusterReferences: uint64
}

state VkClusterAccelerationStructureBuildTriangleClusterInfoNV
{
        clusterID: uint32,
        clusterFlags: uint32,
        // triangleCount: 9,
        // vertexCount: 9,
        // positionTruncateBitCount: 6,
        // indexType: 4,
        // opacityMicromapIndexType: 4,
        bitField: [4]ubyte,
        baseGeometryIndexAndGeometryFlags: VkClusterAccelerationStructureGeometryIndexAndGeometryFlagsNV,
        indexBufferStride: uint16,
        vertexBufferStride: uint16,
        geometryIndexAndFlagsBufferStride: uint16,
        opacityMicromapIndexBufferStride: uint16,
        indexBuffer: uint64,
        vertexBuffer: uint64,
        geometryIndexAndFlagsBuffer: uint64,
        opacityMicromapArray: uint64,
        opacityMicromapIndexBuffer: uint64
}

state VkClusterAccelerationStructureBuildTriangleClusterTemplateInfoNV
{
        clusterID: uint32,
        clusterFlags: uint32,
        // triangleCount: 9,
        // vertexCount: 9,
        // positionTruncateBitCount: 6,
        // indexType: 4,
        // opacityMicromapIndexType: 4,
        bitField: [4]ubyte,
        baseGeometryIndexAndGeometryFlags: VkClusterAccelerationStructureGeometryIndexAndGeometryFlagsNV,
        indexBufferStride: uint16,
        vertexBufferStride: uint16,
        geometryIndexAndFlagsBufferStride: uint16,
        opacityMicromapIndexBufferStride: uint16,
        indexBuffer: uint64,
        vertexBuffer: uint64,
        geometryIndexAndFlagsBuffer: uint64,
        opacityMicromapArray: uint64,
        opacityMicromapIndexBuffer: uint64,
        instantiationBoundingBoxLimit: uint64
}

state VkClusterAccelerationStructureInstantiateClusterInfoNV
{
        clusterIdOffset: uint32,
        geometryIndexOffset: [3]ubyte,
        reserved: ubyte,
        clusterTemplateAddress: uint64,
        vertexBuffer: VkStridedDeviceAddressNV
}

state VkAccelerationStructureBuildSizesInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        accelerationStructureSize: uint64,
        updateScratchSize: uint64,
        buildScratchSize: uint64
}

state VkRayTracingPipelineClusterAccelerationStructureCreateInfoNV
{
        sType: VkStructureType,
        pNext: *void,
        allowClusterAccelerationStructure: uint32
}

state VkPhysicalDevicePartitionedAccelerationStructureFeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        partitionedAccelerationStructure: uint32
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
        enablePartitionTranslation: uint32
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
        explicitAABB: [6]float32,
        instanceID: uint32,
        instanceMask: uint32,
        instanceContributionToHitGroupIndex: uint32,
        instanceFlags: uint32,
        instanceIndex: uint32,
        partitionIndex: uint32,
        accelerationStructure: uint64
}

state VkPartitionedAccelerationStructureUpdateInstanceDataNV
{
        instanceIndex: uint32,
        instanceContributionToHitGroupIndex: uint32,
        accelerationStructure: uint64
}

state VkPartitionedAccelerationStructureWritePartitionTranslationDataNV
{
        partitionIndex: uint32,
        partitionTranslation: [3]float32
}

state VkWriteDescriptorSetPartitionedAccelerationStructureNV
{
        sType: VkStructureType,
        pNext: *void,
        accelerationStructureCount: uint32,
        pAccelerationStructures: *uint64
}

state VkPartitionedAccelerationStructureInstancesInputNV
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
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
        srcAccelerationStructureData: uint64,
        dstAccelerationStructureData: uint64,
        scratchData: uint64,
        srcInfos: uint64,
        srcInfosCount: uint64
}

state VkIndirectExecutionSetEXT_T
{
    opaque: any
}

state VkIndirectCommandsLayoutEXT_T
{
    opaque: any
}

state VkPhysicalDeviceDeviceGeneratedCommandsFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        deviceGeneratedCommands: uint32,
        dynamicGeneratedPipelineLayout: uint32
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
        supportedIndirectCommandsInputModes: uint32,
        supportedIndirectCommandsShaderStages: uint32,
        supportedIndirectCommandsShaderStagesPipelineBinding: uint32,
        supportedIndirectCommandsShaderStagesShaderBinding: uint32,
        deviceGeneratedCommandsTransformFeedback: uint32,
        deviceGeneratedCommandsMultiDrawIndirectCount: uint32
}

state VkGeneratedCommandsMemoryRequirementsInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        indirectExecutionSet: *VkIndirectExecutionSetEXT_T,
        indirectCommandsLayout: *VkIndirectCommandsLayoutEXT_T,
        maxSequenceCount: uint32,
        maxDrawCount: uint32
}

state VkIndirectExecutionSetPipelineInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        initialPipeline: *VkPipeline_T,
        maxPipelineCount: uint32
}

state VkIndirectExecutionSetShaderLayoutInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        setLayoutCount: uint32,
        pSetLayouts: **VkDescriptorSetLayout_T
}

state VkIndirectExecutionSetShaderInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderCount: uint32,
        pInitialShaders: **VkShaderEXT_T,
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
        info: ?{pPipelineInfo: *VkIndirectExecutionSetPipelineInfoEXT, pShaderInfo: *VkIndirectExecutionSetShaderInfoEXT}
}

state VkGeneratedCommandsInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderStages: uint32,
        indirectExecutionSet: *VkIndirectExecutionSetEXT_T,
        indirectCommandsLayout: *VkIndirectCommandsLayoutEXT_T,
        indirectAddress: uint64,
        indirectAddressSize: uint64,
        preprocessAddress: uint64,
        preprocessSize: uint64,
        maxSequenceCount: uint32,
        sequenceCountAddress: uint64,
        maxDrawCount: uint32
}

state VkWriteIndirectExecutionSetPipelineEXT
{
        sType: VkStructureType,
        pNext: *void,
        index: uint32,
        pipeline: *VkPipeline_T
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
        shaderStages: uint32
}

state VkIndirectCommandsLayoutTokenEXT
{
        sType: VkStructureType,
        pNext: *void,
        type: VkIndirectCommandsTokenTypeEXT,
        data: ?{pPushConstant: *VkIndirectCommandsPushConstantTokenEXT, pVertexBuffer: *VkIndirectCommandsVertexBufferTokenEXT, pIndexBuffer: *VkIndirectCommandsIndexBufferTokenEXT, pExecutionSet: *VkIndirectCommandsExecutionSetTokenEXT},
        offset: uint32
}

state VkIndirectCommandsLayoutCreateInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        flags: uint32,
        shaderStages: uint32,
        indirectStride: uint32,
        pipelineLayout: *VkPipelineLayout_T,
        tokenCount: uint32,
        pTokens: *VkIndirectCommandsLayoutTokenEXT
}

state VkDrawIndirectCountIndirectCommandEXT
{
        bufferAddress: uint64,
        stride: uint32,
        commandCount: uint32
}

state VkBindVertexBufferIndirectCommandEXT
{
        bufferAddress: uint64,
        size: uint32,
        stride: uint32
}

state VkBindIndexBufferIndirectCommandEXT
{
        bufferAddress: uint64,
        size: uint32,
        indexType: VkIndexType
}

state VkGeneratedCommandsPipelineInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        pipeline: *VkPipeline_T
}

state VkGeneratedCommandsShaderInfoEXT
{
        sType: VkStructureType,
        pNext: *void,
        shaderCount: uint32,
        pShaders: **VkShaderEXT_T
}

state VkWriteIndirectExecutionSetShaderEXT
{
        sType: VkStructureType,
        pNext: *void,
        index: uint32,
        shader: *VkShaderEXT_T
}

state VkPhysicalDeviceImageAlignmentControlFeaturesMESA
{
        sType: VkStructureType,
        pNext: *void,
        imageAlignmentControl: uint32
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
        depthClampControl: uint32
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
        hdrVivid: uint32
}

state VkHdrVividDynamicMetadataHUAWEI
{
        sType: VkStructureType,
        pNext: *void,
        dynamicMetadataSize: uint64,
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
        saturatingAccumulation: uint32,
        scope: VkScopeKHR,
        workgroupInvocations: uint32
}

state VkPhysicalDeviceCooperativeMatrix2FeaturesNV
{
        sType: VkStructureType,
        pNext: *void,
        cooperativeMatrixWorkgroupScope: uint32,
        cooperativeMatrixFlexibleDimensions: uint32,
        cooperativeMatrixReductions: uint32,
        cooperativeMatrixConversions: uint32,
        cooperativeMatrixPerElementOperations: uint32,
        cooperativeMatrixTensorAddressing: uint32,
        cooperativeMatrixBlockLoads: uint32
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
        pipelineOpacityMicromap: uint32
}

state VkPhysicalDeviceVertexAttributeRobustnessFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        vertexAttributeRobustness: uint32
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
        presentMetering: uint32
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
        vertexData: ?{deviceAddress: uint64, hostAddress: *void},
        vertexStride: uint64,
        maxVertex: uint32,
        indexType: VkIndexType,
        indexData: ?{deviceAddress: uint64, hostAddress: *void},
        transformData: ?{deviceAddress: uint64, hostAddress: *void}
}

state VkAccelerationStructureGeometryAabbsDataKHR
{
        sType: VkStructureType,
        pNext: *void,
        data: ?{deviceAddress: uint64, hostAddress: *void},
        stride: uint64
}

state VkAccelerationStructureGeometryInstancesDataKHR
{
        sType: VkStructureType,
        pNext: *void,
        arrayOfPointers: uint32,
        data: ?{deviceAddress: uint64, hostAddress: *void}
}

state VkAccelerationStructureGeometryKHR
{
        sType: VkStructureType,
        pNext: *void,
        geometryType: VkGeometryTypeKHR,
        geometry: ?{triangles: VkAccelerationStructureGeometryTrianglesDataKHR, aabbs: VkAccelerationStructureGeometryAabbsDataKHR, instances: VkAccelerationStructureGeometryInstancesDataKHR},
        flags: uint32
}

state VkAccelerationStructureBuildGeometryInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        type: VkAccelerationStructureTypeKHR,
        flags: uint32,
        mode: VkBuildAccelerationStructureModeKHR,
        srcAccelerationStructure: *VkAccelerationStructureKHR_T,
        dstAccelerationStructure: *VkAccelerationStructureKHR_T,
        geometryCount: uint32,
        pGeometries: *VkAccelerationStructureGeometryKHR,
        ppGeometries: **VkAccelerationStructureGeometryKHR,
        scratchData: ?{deviceAddress: uint64, hostAddress: *void}
}

state VkAccelerationStructureCreateInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        createFlags: uint32,
        buffer: *VkBuffer_T,
        offset: uint64,
        size: uint64,
        type: VkAccelerationStructureTypeKHR,
        deviceAddress: uint64
}

state VkWriteDescriptorSetAccelerationStructureKHR
{
        sType: VkStructureType,
        pNext: *void,
        accelerationStructureCount: uint32,
        pAccelerationStructures: **VkAccelerationStructureKHR_T
}

state VkPhysicalDeviceAccelerationStructureFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        accelerationStructure: uint32,
        accelerationStructureCaptureReplay: uint32,
        accelerationStructureIndirectBuild: uint32,
        accelerationStructureHostCommands: uint32,
        descriptorBindingAccelerationStructureUpdateAfterBind: uint32
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
        accelerationStructure: *VkAccelerationStructureKHR_T
}

state VkAccelerationStructureVersionInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        pVersionData: *ubyte
}

state VkCopyAccelerationStructureToMemoryInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        src: *VkAccelerationStructureKHR_T,
        dst: ?{deviceAddress: uint64, hostAddress: *void},
        mode: VkCopyAccelerationStructureModeKHR
}

state VkCopyMemoryToAccelerationStructureInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        src: ?{deviceAddress: uint64, hostAddress: *void},
        dst: *VkAccelerationStructureKHR_T,
        mode: VkCopyAccelerationStructureModeKHR
}

state VkCopyAccelerationStructureInfoKHR
{
        sType: VkStructureType,
        pNext: *void,
        src: *VkAccelerationStructureKHR_T,
        dst: *VkAccelerationStructureKHR_T,
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
        flags: uint32,
        stageCount: uint32,
        pStages: *VkPipelineShaderStageCreateInfo,
        groupCount: uint32,
        pGroups: *VkRayTracingShaderGroupCreateInfoKHR,
        maxPipelineRayRecursionDepth: uint32,
        pLibraryInfo: *VkPipelineLibraryCreateInfoKHR,
        pLibraryInterface: *VkRayTracingPipelineInterfaceCreateInfoKHR,
        pDynamicState: *VkPipelineDynamicStateCreateInfo,
        layout: *VkPipelineLayout_T,
        basePipelineHandle: *VkPipeline_T,
        basePipelineIndex: int32
}

state VkPhysicalDeviceRayTracingPipelineFeaturesKHR
{
        sType: VkStructureType,
        pNext: *void,
        rayTracingPipeline: uint32,
        rayTracingPipelineShaderGroupHandleCaptureReplay: uint32,
        rayTracingPipelineShaderGroupHandleCaptureReplayMixed: uint32,
        rayTracingPipelineTraceRaysIndirect: uint32,
        rayTraversalPrimitiveCulling: uint32
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
        rayQuery: uint32
}

state VkPhysicalDeviceMeshShaderFeaturesEXT
{
        sType: VkStructureType,
        pNext: *void,
        taskShader: uint32,
        meshShader: uint32,
        multiviewMeshShader: uint32,
        primitiveFragmentShadingRateMeshShader: uint32,
        meshShaderQueries: uint32
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
        prefersLocalInvocationVertexOutput: uint32,
        prefersLocalInvocationPrimitiveOutput: uint32,
        prefersCompactVertexOutput: uint32,
        prefersCompactPrimitiveOutput: uint32
}

state VkDrawMeshTasksIndirectCommandEXT
{
        groupCountX: uint32,
        groupCountY: uint32,
        groupCountZ: uint32
}