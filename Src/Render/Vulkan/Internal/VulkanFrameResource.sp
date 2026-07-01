package VulkanRenderer

state VulkanFrameResource<T>
{
	frames: [FrameCount]T
}

VulkanFrameResource::Init(create: ::T(uint32))
{
	for (i .. FrameCount)
	{
		this.frames[i] = create(i);
	}
}

ref T VulkanFrameResource::Get(frame: uint32)
{
	return this.frames[frame % FrameCount];
}
