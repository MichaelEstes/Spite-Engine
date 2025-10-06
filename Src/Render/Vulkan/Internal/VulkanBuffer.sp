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
	normal: *VkBuffer_T,
	tangents: *VkBuffer_T,
	color: *VkBuffer_T,
	uv0: *VkBuffer_T,
	uv1: *VkBuffer_T,
	uv2: *VkBuffer_T,
	uv3: *VkBuffer_T,

	normalHandle: VulkanAllocHandle,
	tangentsHandle: VulkanAllocHandle,
	colorHandle: VulkanAllocHandle,
	uv0Handle: VulkanAllocHandle,
	uv1Handle: VulkanAllocHandle,
	uv2Handle: VulkanAllocHandle,
	uv3Handle: VulkanAllocHandle
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
		this.normal@, this.normalHandle@, 
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
		this.uv0@, this.uv0Handle@, 
		Vec2(0.0, 0.0)
	);
	this.CreateInternal<Vec2>(
		renderer, 
		this.uv1@, this.uv1Handle@, 
		Vec2(0.0, 0.0)
	);
	this.CreateInternal<Vec2>(
		renderer, 
		this.uv2@, this.uv2Handle@, 
		Vec2(0.0, 0.0)
	);
	this.CreateInternal<Vec2>(
		renderer, 
		this.uv3@, this.uv3Handle@, 
		Vec2(0.0, 0.0)
	);
}