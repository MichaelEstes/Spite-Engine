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

state ResourceTable<Renderer, CreateDesc>
{
	descToResource := Map<CreateDesc, Array<TrackedResource>>()
}

*any ResourceTable::GetOrCreateResource(createDesc: CreateDesc, renderer: *Renderer,
										create: ::*any(CreateDesc, *Renderer))
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

	resource := create(createDesc, renderer)
	trackedResource := TrackedResource(resource, true);
	if (this.descToResource.Has(createDesc))
	{
		trackedArr := this.descToResource[createDesc];
		trackedArr.Add(trackedResource)
	}
	else
	{
		trackedArr := Array<TrackedResource>();
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

state ResourceTables<Renderer>
{
	textureTable: ResourceTable<Renderer, TextureDesc>,
	bufferTable: ResourceTable<Renderer, BufferDesc>,
	createTexture: ::*any(TextureDesc, *Renderer),
	createBuffer: ::*any(BufferDesc, *Renderer)
}

ResourceTables::(createTexture: ::*any(TextureDesc, *any), createBuffer: ::*any(BufferDesc, *Renderer))
{
	this.createTexture = createTexture;
	this.createBuffer = createBuffer;
}

RenderResource ResourceTables::UseTexture(createInfo: TextureDesc, renderer: *Renderer)
{
	table := this.textureTable;
	texture := table.GetOrCreateResource(
		createInfo,
		renderer,
		this.createTexture
	);

	return RenderResource().FromTexture(texture);
}

RenderResource ResourceTables::UseBuffer(createInfo: BufferDesc, renderer: *Renderer)
{
	table := this.bufferTable;
	buffer := table.GetOrCreateResource(
		createInfo,
		renderer,
		this.createBuffer
	);

	return RenderResource().FromBuffer(buffer);
}

RenderResource ResourceTables::UseResource(resourceDesc: ResourceDesc, renderer: *Renderer)
{
	switch (resourceDesc.kind)
	{
		case (ResourceKind.Texture)
		{
			return this.UseTexture(resourceDesc.desc.texture, renderer);
		}
		case (ResourceKind.Buffer)
		{
			return this.UseBuffer(resourceDesc.desc.buffer, renderer);
		}
	}

	return RenderResource().Null();
}

ResourceTables::ReleaseTrackedResources()
{
	this.textureTable.ReleaseResources();
	this.bufferTable.ReleaseResources();
}