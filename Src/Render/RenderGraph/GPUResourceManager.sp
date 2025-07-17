package RenderGraph

import Array
import SDL

state TrackedResource<Type>
{
	resource: Type,
	claimed: bool
}

state ResourceTable<Resource, CreateInfo>
{
	descToResource: Map<CreateInfo, Array<TrackedResource<Resource>>>,
	nameToResource: Map<string, Resource>
}

Resource ResourceTable::GetOrCreateNamedResource(name: string, createInfo: CreateInfo, device: *GPUDevice,
												 create: ::Resource(CreateInfo, *GPUDevice))
{
	if (this.nameToResource.Has(name))
	{
		return nameToResource.Find(name)~;
	}

	if (this.descToResource.Has(createInfo))
	{
		trackedResources := this.descToResource[createInfo]~;
		for (tracked in trackedResources)
		{
			if (!tracked.claimed)
			{
				this.nameToResource.Insert(name, resource);
				tracked.claimed = true;
				return tracked.resource;
			}
		}
	}

	resource := create(createInfo, device)
	this.nameToResource.Insert(name, resource);
	this.descToResource.Insert(createInfo, {resource, true});
	return resource;
}

state ResourcesTable
{
	textureTable: ResourceTable<*GPUTexture, GPUTextureCreateInfo>,
	bufferTable: ResourceTable<*GPUBuffer, GPUBufferCreateInfo>,
}

RenderResourcesTable := ResourcesTable();

RenderResource UseNamedTexture(name: string, createInfo: GPUTextureCreateInfo, device: *GPUDevice)
{
	table := RenderResourcesTable.textureTable;
	resource := GetOrCreateNamedResource(name, createInfo, ::*GPUTexture(createInfo: GPUTextureCreateInfo) {
		return CreateGPUTexture(instance)
	})
}

RenderResource UseNamedBuffer(name: string, createInfo: GPUBufferCreateInfo, device: *GPUDevice)
{

	resource := RenderResourcesTable.bufferTable.nameToResource[name]~;
	if (!resource)
	{
		resource := SDL.CreateGPUBuffer(instance.device, &createInfo);
		RenderResourcesTable.bufferTable.nameToResource.Insert(name, resource);
	}

	return RenderResource(RenderResourceHandle(RenderResourcesTable.bufferTable.resources.Add(resource)), ResourceKind.Buffer);
}

RenderResource UseNamedResource(name: string, resourceDesc: ResourceDesc, device: *GPUDevice)
{
	switch (resourceDesc.kind)
	{
		case (ResourceKind.Texture)
		{
			return UseNamedTexture(name, resourceDesc.desc.texture);
		}
		case (ResourceKind.Buffer)
		{
			return UseNamedBuffer(name, resourceDesc.desc.buffer);
		}
	}
}