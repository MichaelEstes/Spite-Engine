package RenderGraph

import Array
import SDL
import RenderCommon

state TrackedResource
{
	resource: *any,
	claimed: bool
}

TrackedResource::(resource: *any, claimed: bool)
{
	this.resource = resource;
	this.claimed = claimed;
}

state ResourceTable<CreateDesc>
{
	descToResource := Map<CreateDesc, Array<TrackedResource>>()
}

*any ResourceTable::GetOrCreateResource(createDesc: CreateDesc, device: *any,
											create: ::*any(CreateDesc, *any))
{
	if (this.descToResource.Has(createDesc))
	{
		trackedResources := this.descToResource[createDesc]~;
		for (tracked in trackedResources)
		{
			if (!tracked.claimed)
			{
				tracked.claimed = true;
				return tracked.resource;
			}
		}
	}

	resource := create(createDesc, device)
	trackedResource := TrackedResource<Resource>(resource, true);
	if (this.descToResource.Has(createDesc))
	{
		trackedArr := this.descToResource[createDesc];
		trackedArr.Add(trackedResource)
	}
	else
	{
		trackedArr := Array<TrackedResource<Resource>>();
		trackedArr.Add(trackedResource);
		this.descToResource.Insert(createDesc, trackedArr);
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

state ResourceTables
{
	textureTable: ResourceTable<TextureDesc>,
	bufferTable: ResourceTable<BufferDesc>,
	createTexture: ::*any(TextureDesc, *any),
	createBuffer: ::*any(BufferDesc, *any)
}

ResourceTables::(createTexture: ::*any(TextureDesc, *any), createBuffer: ::*any(BufferDesc, *any))
{
	this.createTexture = createTexture;
	this.createBuffer = createBuffer;
}

RenderResource ResourceTables::UseTexture(createInfo: TextureDesc, device: *any)
{
	table := renderResourcesTable.textureTable;
	texture := table.GetOrCreateResource(
		createInfo,
		device,
		this.createTexture
	);

	return RenderResource().FromTexture(texture);
}

RenderResource ResourceTables::UseBuffer(createInfo: BufferDesc, device: *any)
{
	table := renderResourcesTable.bufferTable;
	buffer := table.GetOrCreateResource(
		createInfo,
		device,
		this.createBuffer
	);

	return RenderResource().FromBuffer(buffer);
}

RenderResource ResourceTables::UseResource(resourceDesc: ResourceDesc, device: *any)
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