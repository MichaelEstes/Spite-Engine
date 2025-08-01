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

state ResourceTable<Device, Resource, CreateInfo>
{
	descToResource := Map<CreateInfo, Array<TrackedResource<Resource>>>()
}

Resource ResourceTable::GetOrCreateResource(createInfo: CreateInfo, device: *Device,
											create: ::Resource(CreateInfo, *Device))
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

ResourceTable::ReleaseResources()
{
	for (arr in this.descToResource.Values())
	{
		for (tracked in arr)
		{
			tracked.claimed = false;
		}
	}
}

state ResourceTables<Device, Texture, Buffer, TextureInfo, BufferInfo>
{
	textureTable: ResourceTable<Device, *Texture, TextureInfo>,
	bufferTable: ResourceTable<Device, *Buffer, BufferInfo>,
	createTexture: ::*Texture(TextureInfo, *Device),
	createBuffer: ::*Buffer(BufferInfo, *Device),
}

RenderResource ResourceTables::UseTexture(createInfo: TextureInfo, device: *Device)
{
	table := renderResourcesTable.textureTable;
	texture := table.GetOrCreateResource(
		createInfo,
		device,
		this.createTexture
	);

	return RenderResource().FromTexture(texture);
}

RenderResource ResourceTables::UseBuffer(createInfo: BufferInfo, device: *Device)
{
	table := renderResourcesTable.bufferTable;
	buffer := table.GetOrCreateResource(
		createInfo,
		device,
		this.createBuffer
	);

	return RenderResource().FromBuffer(buffer);
}

RenderResource ResourceTables::UseResource(resourceDesc: ResourceDesc<TextureInfo, BufferInfo>, device: *Device)
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

ResourceTables::ReleaseTrackedResources()
{
	renderResourcesTable.textureTable.ReleaseResources();
	renderResourcesTable.bufferTable.ReleaseResources();
}