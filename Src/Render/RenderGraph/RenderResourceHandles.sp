package RenderGraph

import HandleSet
import SparseSet

state RenderResourceHandle
{
	handle: uint32
}

bool RenderResourceHandle::operator::==(right: RenderResourceHandle)
			=> this.handle == right.handle;

state RenderResourceHandles<Renderer>
{
	handles := HandleSet<ResourceDesc>(),
	handleToName := SparseSet<string>(),
	nameToHandle := Map<string, uint32>(),
	resources := SparseSet<RenderResource>(),
	resourceTables: *ResourceTables<Renderer>
}

*ResourceDesc RenderResourceHandles::GetResourceDesc(resourceHandle: RenderResourceHandle)
{
	return this.handles[resourceHandle.handle];
}

RenderResourceHandle RenderResourceHandles::CreateHandle(name: string, desc: ResourceDesc)
{
	if (this.nameToHandle.Has(name))
	{
		handle := this.nameToHandle[name]~;
		return handle as RenderResourceHandle;
	}

	handleValue := this.handles.GetNext();
	handleValue.value~ = desc;

	handle := handleValue.handle;
	this.handleToName.Insert(handle, name);

	return handle as RenderResourceHandle;
}

RenderResourceHandle RenderResourceHandles::AddExternalResource(name: string, resource: *any,
																resourceDesc: ResourceDesc)
{
	kind := resourceDesc.kind;
	handle := this.CreateHandle(name, resourceDesc);

	renderResource := RenderResource();
	renderResource.resource = resource;
	renderResource.kind = kind;

	this.resources.Insert(handle.handle, renderResource);
	return handle;
}

RenderResourceHandle RenderResourceHandles::AddExternalTextureResource(name: string, texture: *any, 
																	   textureDesc: TextureDesc)
{
	resourceDesc := ResourceDesc();
	resourceDesc.kind = ResourceKind.Texture;
	resourceDesc.desc.texture = textureDesc;

	handle := this.AddExternalResource(name, texture, resourceDesc);
	this.resourceTables.SetCurrentTextureLayout(texture, textureDesc.layout);

	return handle;
}

RenderResourceHandle RenderResourceHandles::AddExternalBufferResource(name: string, buffer: *any, 
																	  bufferDesc: BufferDesc)
{
	resourceDesc := ResourceDesc();
	resourceDesc.kind = ResourceKind.Buffer;
	resourceDesc.desc.buffer = bufferDesc;

	return this.AddExternalResource(name, buffer, resourceDesc);
}

RenderResource RenderResourceHandles::UseResource(resourceHandle: RenderResourceHandle, renderer: *any)
{
	handle := resourceHandle.handle;
	if (this.resources.Has(handle))
	{
		return this.resources.Get(handle)~;
	}

	desc := this.handles[handle]~;
	resource := this.resourceTables.UseResource(desc, renderer);
	this.resources.Insert(handle, resource);

	return resource;
}

RenderResourceHandles::Clear()
{
	this.handles.Clear();
	this.handleToName.Clear();
	this.nameToHandle.Clear();
	this.resources.Clear();
}