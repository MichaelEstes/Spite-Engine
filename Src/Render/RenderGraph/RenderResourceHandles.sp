package RenderGraph

import HandleSet
import SparseSet

state RenderResourceHandle
{
	handle: uint32
}

state RenderResourceHandles
{
	handles: HandleSet<ResourceDesc>,
	handleToName: SparseSet<string>,
	nameToHandle: Map<string, uint32>
	resources: SparseSet<RenderResource>
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