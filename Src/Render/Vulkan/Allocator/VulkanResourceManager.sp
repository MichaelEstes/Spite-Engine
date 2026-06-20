package VulkanRenderer

import HandleSet
import RenderComponents
import RenderAssetDef
import Array
import ArrayView

state VulkanResourceHandle
{
	handle: uint32
}

state VulkanRenderTarget
{
	image: *VkImage_T,
	imageView: *VkImageView_T,
	handle: VulkanAllocHandle
}

state VulkanResourceManager
{
	renderTargetMap := Map<*VkImage_T, VulkanRenderTarget>(),

	geometries := HandleSet<VulkanGeometry>(),
	materials := HandleSet<VulkanMaterial>()
}

VkBufferCreateInfo VertexBufferCreateInfo(size: uint32)
{
	createInfo := VkBufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.usage = VkBufferUsageFlagBits.VK_BUFFER_USAGE_VERTEX_BUFFER_BIT |
					   VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_DST_BIT;
	createInfo.size = size;
	createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

	return createInfo;
}

VkBufferCreateInfo IndexBufferCreateInfo(size: uint32)
{
	createInfo := VkBufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.usage = VkBufferUsageFlagBits.VK_BUFFER_USAGE_INDEX_BUFFER_BIT |
					   VkBufferUsageFlagBits.VK_BUFFER_USAGE_TRANSFER_DST_BIT;
	createInfo.size = size;
	createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

	return createInfo;
}

VkBufferCreateInfo UniformBufferCreateInfo(size: uint32)
{
	createInfo := VkBufferCreateInfo();
	createInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.usage = VkBufferUsageFlagBits.VK_BUFFER_USAGE_UNIFORM_BUFFER_BIT;
	createInfo.size = size;
	createInfo.sharingMode = VkSharingMode.VK_SHARING_MODE_EXCLUSIVE;

	return createInfo;
}

VulkanAllocHandle UploadBuffer(createInfo: VkBufferCreateInfo, data: *byte, size: uint)
{
	device := vulkanInstance.device;
	allocator := vulkanInstance.allocator;
	stagingBuffer := vulkanInstance.GetStagingBuffer();
	queue := vulkanInstance.queues.transferQueue;
	commands := vulkanInstance.transferCommands;

	buffer := CreateVkBuffer(device, createInfo);
	handle := allocator.AllocBuffer(buffer, VulkanMemoryFlags.GPU);
	stagingBuffer.StagedBufferCopy(device, data, size, buffer, commands, queue);

	return handle;
}

Array<VulkanAllocHandle> UploadVariableSets(variables: *void, variableSets: VariableSets)
{
	device := vulkanInstance.device;
	allocator := vulkanInstance.allocator;

	handles := Array<VulkanAllocHandle>(variableSets.sets.count);

	offset := uint32(0);
	for (set in variableSets.sets)
	{
		setSize := uint32(0);
		for (var in set)
		{
			setSize += var.def.ValueSize();
		}

		buffer := CreateVkBuffer(device, UniformBufferCreateInfo(setSize));
		handle := allocator.AllocBuffer(
			buffer,
			VulkanMemoryFlags.Shared | VulkanMemoryFlags.Coherent | VulkanMemoryFlags.Mapped
		);

		mappedPtr := allocator.GetAllocationMappedPtr(handle) as *byte;
		copy_bytes(mappedPtr, (variables as *byte) + offset, setSize);

		handles.Add(handle);
		offset += setSize;
	}

	return handles;
}

uint32 VulkanResourceManager::UploadGeometry(geometry: *Geometry)
{
	handleValue := this.geometries.GetNext();
	vulkanGeometry := handleValue.value;
	vulkanGeometry~ = VulkanGeometry();

	attributeCount := geometry.attributes.count;
	vulkanGeometry.attributes = Array<VulkanAllocHandle>(attributeCount);
	for (i .. attributeCount)
	{
		attribute := geometry.attributes[i];
		bufferHandle := UploadBuffer(
			VertexBufferCreateInfo(uint32(attribute.count)),
			attribute.start,
			attribute.count
		);
		vulkanGeometry.attributes.Add(bufferHandle);
	}

	if (geometry.indexKind != IndexKind.None)
	{
		indices := geometry.indices;
		indexSize := indices.count * #sizeof uint16;

		vulkanGeometry.indexHandle = UploadBuffer(
			IndexBufferCreateInfo(uint32(indexSize)),
			indices.start as *byte,
			indexSize
		);
		vulkanGeometry.indexCount = uint32(indices.count);
		vulkanGeometry.indexKind = VkIndexType.VK_INDEX_TYPE_UINT16;
	}

	assetDef := GetAssetDefWithHandle(geometry.defHandle);
	vulkanGeometry.variables = UploadVariableSets(geometry.variables, assetDef.vertex.variables);

	geometry.gpuResourceID = handleValue.handle;
	return handleValue.handle;
}