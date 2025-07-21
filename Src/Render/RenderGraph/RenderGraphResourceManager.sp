package RenderGraph

import Array
import SDL

state TrackedResource<Type>
{
	resource: Type,
	claimed: bool
}

TrackedResource::(resource: Type, claimed: bool)
{
	this.resource = resource;
	this.claimed = claimed;
}

state ResourceTable<Resource, CreateInfo>
{
	descToResource: Map<CreateInfo, Array<TrackedResource<Resource>>>,
}

Resource ResourceTable::GetOrCreateResource(createInfo: CreateInfo, device: *GPUDevice,
											create: ::Resource(CreateInfo, *GPUDevice))
{
	if (this.descToResource.Has(createInfo))
	{
		trackedResources := this.descToResource[createInfo]~;
		for (tracked in trackedResources)
		{
			if (!tracked.claimed)
			{
				tracked.claimed = true;
				return tracked.resource;
			}
		}
	}

	resource := create(createInfo, device)
	trackedResource := TrackedResource<Resource>(resource, true);
	if (this.descToResource.Has(createInfo))
	{
		trackedArr := this.descToResource[createInfo];
		trackedArr.Add(trackedResource)
	}
	else
	{
		trackedArr := Array<TrackedResource<Resource>>();
		trackedArr.Add(trackedResource);
		this.descToResource.Insert(createInfo, trackedArr);
	}
	return resource;
}

state ResourceTables
{
	textureTable: ResourceTable<*GPUTexture, GPUTextureCreateInfo>,
	bufferTable: ResourceTable<*GPUBuffer, GPUBufferCreateInfo>,
}

renderResourcesTable := ResourceTables();

RenderResource UseTexture(createInfo: GPUTextureCreateInfo, device: *GPUDevice)
{
	table := renderResourcesTable.textureTable;
	texture := table.GetOrCreateResource(
		createInfo,
		device,
		::*GPUTexture(createInfo: GPUTextureCreateInfo, device: *GPUDevice) {
			return SDL.CreateGPUTexture(device, createInfo@)
		}
	);

	return RenderResource().FromTexture(texture);
}

RenderResource UseBuffer(createInfo: GPUBufferCreateInfo, device: *GPUDevice)
{
	table := renderResourcesTable.bufferTable;
	buffer := table.GetOrCreateResource(
		createInfo,
		device,
		::*GPUBuffer(createInfo: GPUBufferCreateInfo, device: *GPUDevice) {
			return SDL.CreateGPUBuffer(device, createInfo@)
		}
	);

	return RenderResource().FromBuffer(buffer);
}

RenderResource UseResource(resourceDesc: ResourceDesc, device: *GPUDevice)
{
	switch (resourceDesc.kind)
	{
		case (ResourceKind.Texture)
		{
			return UseTexture(resourceDesc.desc.texture, device);
		}
		case (ResourceKind.Buffer)
		{
			return UseBuffer(resourceDesc.desc.buffer, device);
		}
	}

	return RenderResource().Null();
}