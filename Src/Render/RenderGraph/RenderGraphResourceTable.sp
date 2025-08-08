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
										create: ::*any(CreateDesc, *Renderer), created: *bool = null)
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

	resource := create(createDesc, renderer);
	if (created) created~ = true;

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
	textureToLayout: Map<*any, GPUTextureLayout>,
	createTexture: ::*any(TextureDesc, *Renderer),
	createBuffer: ::*any(BufferDesc, *Renderer)
}

ResourceTables::(createTexture: ::*any(TextureDesc, *any), createBuffer: ::*any(BufferDesc, *Renderer))
{
	this.createTexture = createTexture;
	this.createBuffer = createBuffer;
}

RenderResource ResourceTables::UseTexture(createInfo: TextureDesc, renderer: *Renderer, created: *bool)
{
	table := this.textureTable;
	texture := table.GetOrCreateResource(
		createInfo,
		renderer,
		this.createTexture,
		created
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
			created := false;
			texture := this.UseTexture(resourceDesc.desc.texture, renderer, created@);
			if (created)
			{
				this.SetCurrentTextureLayout(texture.resource, resourceDesc.desc.texture.layout);
			}
			return texture;
		}
		case (ResourceKind.Buffer)
		{
			return this.UseBuffer(resourceDesc.desc.buffer, renderer);
		}
	}

	return RenderResource().Null();
}

ResourceTables::SetCurrentTextureLayout(texture: *any, layout: GPUTextureLayout)
{
	this.textureToLayout.Insert(texture, layout);
}

GPUTextureLayout ResourceTables::GetCurrentTextureLayout(texture: *any)
{
	layout := this.textureToLayout[texture];
	if (layout) return layout~;

	return GPUTextureLayout.Undefined;
}

ResourceTables::ReleaseTrackedResources()
{
	this.textureTable.ReleaseResources();
	this.bufferTable.ReleaseResources();
}