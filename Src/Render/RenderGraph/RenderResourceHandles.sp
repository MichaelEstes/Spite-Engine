package RenderGraph

import HandleSet
import SparseSet

state RenderResourceHandle
{
	handle: uint32
}

state RenderResourceHandles<Renderer>
{
	handles := HandleSet<ResourceDesc>(),
	handleToName := SparseSet<string>(),
	nameToHandle := Map<string, uint32>(),
	resources := SparseSet<RenderResource>(),
	resourceTables: *ResourceTables<Renderer>
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

RenderResourceHandle RenderResourceHandles::AddExternalResource(name: string, resource: *any, kind: ResourceKind
																resourceDesc: *ResourceDesc = null)
{
	handle := RenderResourceHandle();

	if (resourceDesc)
	{
		handle = this.CreateHandle(name, resourceDesc~);
	}
	else
	{
		desc := ResourceDesc();
		desc.kind = kind;
		handle = this.CreateHandle(name, desc);
	}

	renderResource := RenderResource();
	renderResource.resource = resource;
	renderResource.kind = kind;

	this.resources.Insert(handle.handle, renderResource);
	return handle;
}

RenderResourceHandle RenderResourceHandles::AddExternalTextureResource(name: string, texture: *any, 
																	   resourceDesc: *ResourceDesc = null)
{
	return this.AddExternalResource(name, texture, ResourceKind.Texture, resourceDesc);
}

RenderResourceHandle RenderResourceHandles::AddExternalBufferResource(name: string, buffer: *any, 
																	  resourceDesc: *ResourceDesc = null)
{
	return this.AddExternalResource(name, buffer, ResourceKind.Buffer, resourceDesc);
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