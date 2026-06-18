package VulkanRenderer

import Vec
import Common

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

EmptyVertexBuffers::CreateInternal<Type>(
	device: *VkDevice_T
	renderer: VulkanRenderer
	bufRef: **VkBuffer_T, handleRef: *VulkanAllocHandle
	data: Type
)
{
	queue := vulkanInstance.queues.transferQueue;
	stagingBuffer := vulkanInstance.stagingBuffer;
	allocator := vulkanInstance.allocator;

	commands := renderer.transferCommands;
	size := #sizeof Type;

	bufRef~ = CreateVkBuffer(device, VertexBufferCreateInfo(size));
	handleRef~ = allocator.AllocBuffer(bufRef~, VulkanMemoryFlags.GPU);
	stagingBuffer.StagedBufferCopy(
		device,
		data@ as *byte
		size,
		bufRef~,
		commands,
		queue
	);
}

EmptyVertexBuffers::Init(renderer: VulkanRenderer)
{
	device := vulkanInstance.device;

	this.CreateInternal<Vec3>(
		device,
		renderer, 
		this.normals@, this.normalsHandle@, 
		Vec3(0.0, 0.0, 1.0)
	);

	this.CreateInternal<Vec4>(
		device,
		renderer, 
		this.tangents@, this.tangentsHandle@, 
		Vec4(1.0, 0.0, 0.0, 1.0)
	);

	this.CreateInternal<Color>(
		device,
		renderer, 
		this.color@, this.colorHandle@, 
		Color(1.0, 1.0, 1.0, 1.0)
	);

	this.CreateInternal<Vec2>(
		device,
		renderer, 
		this.uv@, this.uvHandle@, 
		Vec2(0.0, 0.0)
	);
}