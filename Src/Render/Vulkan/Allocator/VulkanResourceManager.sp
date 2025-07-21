package VulkanRenderer

import Resource

state VulkanResource
{
	allocation: VulkanAllocation,
	allocator: *VulkanAllocator
}

VulkanResourceManager := Resource.CreateResourceManager<VulkanResource, VulkanResource>(
	['v', 'u', 'l', 'k'],
	GetResourceKey, 
	VulkanManagerLoad,
	::(handle: ResourceHandle) {
		resource := Resource.GetResource<VulkanResource>(handle);
	}
);

VulkanResourceManagerID := Resource.RegisterResourceManager(VulkanResourceManager@);

string GetResourceKey(param: VulkanResource) => 
{
	allocation := param.allocation;
	hash := param.allocator as uint;
	hash -= allocation.offset;
	hash -= allocation.index;
	hash -= allocation.blockIndex;

	keyBuf := ZeroedAllocator<uint>().Alloc(1)[0];
	keyBuf~ = hash;
	return string(#sizeof uint, keyBuf as *byte)
}

VulkanManagerLoad(vulkanResourceParam: *ResourceParam<VulkanResource, VulkanResource>)
{
	handle := vulkanResourceParam.handle;
	param := vulkanResourceParam.param;
	
	resourceManager := vulkanResourceParam.manager;
	resource := resourceManager.GetResource(handle);

	resourceData := resource.data;
	resourceData.allocator = param.allocator;
	resourceData.allocation = param.allocation;

	vulkanResourceParam.onResourceLoad(vulkanResourceParam, ResourceResult.Loaded);
}