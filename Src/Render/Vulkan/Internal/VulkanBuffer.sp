package VulkanRenderer

import Vec

*VkBuffer_T CreateVkBuffer(device: *VkDevice_T, createInfo: VkBufferCreateInfo)
{
	buffer: *VkBuffer_T = null;
	CheckResult(
		vkCreateBuffer(device, createInfo@, null, buffer@),
		"Error creating Vulkan buffer"
	);

	return buffer;
}

state EmptyVertexBuffers
{
	normals: *VkBuffer_T,
	tangents: *VkBuffer_T,
	color: *VkBuffer_T,
	uv: *VkBuffer_T,

	normalsHandle: VulkanAllocHandle,
	tangentsHandle: VulkanAllocHandle,
	colorHandle: VulkanAllocHandle,
	uvHandle: VulkanAllocHandle
}

EmptyVertexBuffers::CreateInternal<Type>(renderer: VulkanRenderer
										 bufRef: **VkBuffer_T, handleRef: *VulkanAllocHandle
										 data: Type)
{
	device := renderer.device;
	commands := renderer.transferCommands;
	queue := renderer.queues.transferQueue;
	size := #sizeof Type;

	bufRef~ = CreateVkBuffer(device, VertexBufferCreateInfo(size));
	handleRef~ = renderer.allocator.AllocBuffer(bufRef~, VulkanMemoryFlags.GPU);
	renderer.stagingBuffer.StagedBufferCopy(
		renderer.device,
		data@ as *byte
		size,
		bufRef~,
		commands,
		queue
	);
}

EmptyVertexBuffers::Init(renderer: VulkanRenderer)
{
	this.CreateInternal<Vec3>(
		renderer, 
		this.normals@, this.normalsHandle@, 
		Vec3(0.0, 0.0, 1.0)
	);

	this.CreateInternal<Vec4>(
		renderer, 
		this.tangents@, this.tangentsHandle@, 
		Vec4(1.0, 0.0, 0.0, 1.0)
	);

	this.CreateInternal<Vec4>(
		renderer, 
		this.color@, this.colorHandle@, 
		Vec4(1.0, 1.0, 1.0, 1.0)
	);

	this.CreateInternal<Vec2>(
		renderer, 
		this.uv@, this.uvHandle@, 
		Vec2(0.0, 0.0)
	);
}