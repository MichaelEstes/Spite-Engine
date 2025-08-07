package RenderGraph

import SDL
import Array

MaxPassCountForResource := 32

state PassResourceArray
{
	values: [MaxPassCountForResource]uint32,
	count: uint32
}

state RenderPassContext<Renderer>
{
	renderer: *Renderer,
	handles: *RenderResourceHandles<Renderer>
}

*Texture RenderPassContext::UseTexture<Texture>(handle: RenderResourceHandle)
{
	return this.handles.UseResource(handle, this.renderer).resource as *Texture;
}

*Buffer RenderPassContext::UseBuffer<Buffer>(handle: RenderResourceHandle)
{
	return this.handles.UseResource(handle, this.renderer).resource as *Buffer;
}

state RenderGraph<Renderer>
{
	passes: Array<RenderGraphPass<Renderer>>,
	renderer: *Renderer,
	handles: RenderResourceHandles<Renderer>,
	readersByResource := SparseSet<PassResourceArray>(),
	readersByPass := SparseSet<PassResourceArray>(),
	writersByResource := SparseSet<PassResourceArray>(),
	passOrder: Array<uint32>,
}

RenderGraph::SetResourceTables(resourceTables: *ResourceTables<Renderer>)
{
	this.handles.resourceTables = resourceTables;
}

RenderGraph::SetRenderer(renderer: *Renderer)
{
	this.renderer = renderer;
}

RenderGraph::AddPass(name: string, 
					 init: ::bool(*RenderPassBuilder<Renderer>, *any), 
					 exec: ::(*RenderPassContext<Renderer>, *any),
					 stage: RenderPassStage, data: *any = null)
{
	builder := RenderPassBuilder<Renderer>();
	builder.renderGraph = this@;
	builder.index = 0;
	if (init(builder@, data))
	{
		pass := RenderGraphPass<Renderer>()
		pass.name = name;
		pass.resources = builder.resources;
		pass.count = builder.index;
		pass.exec = exec;
		pass.stage = stage;
		pass.data = data;
		this.passes.Add(pass);
	}
}

RenderResourceHandle RenderGraph::RegisterResourceToCreate(name: string, desc: ResourceDesc)
{
	return this.handles.CreateHandle(name, desc);
}
 
RenderPassContext<Renderer> RenderGraph::CreateContext()
{
	context := RenderPassContext<Renderer>();
	context.renderer = this.renderer;
	context.handles = this.handles@;

	return context;
}

RenderGraph::AddHandleToPassIndexSet(key: uint32, value: uint32, set: SparseSet<PassResourceArray>)
{
	if (set.Has(key))
	{
		arr := set.Get(key);
		arr.values[arr.count] = value;
		arr.count += 1;
		return;
	}

	arr := PassResourceArray();
	arr.values[0] = value;
	arr.count = 1;
	set.Insert(key, arr);
}

RenderGraph::Compile()
{
	for (i .. this.passes.count)
	{
		pass := this.passes[i];
		for (ix .. pass.count)
		{
			resource := pass.resources[ix]
			if (resource.access == ResourceAccess.Read)
			{
				this.AddHandleToPassIndexSet(resource.handle.handle, i, this.readersByResource);
				this.AddHandleToPassIndexSet(i, resource.handle.handle, this.readersByPass);
			}
			else
			{
				this.AddHandleToPassIndexSet(resource.handle.handle, i, this.writersByResource);
			}
		}
	}

	for (readerKV in this.readersByResource)
	{
		resourceHandle := readerKV.key~;
		passes := readerKV.value~;
		this.WalkResources(resourceHandle, passes);
	}

	for (i .. this.passes.count)
	{
		if (!this.passOrder.Has(i))
		{
			this.passOrder.Add(i);
		}
	}
}

RenderGraph::WalkResources(resourceHandle: uint32, passes: PassResourceArray)
{
	for (i .. passes.count)
	{
		passIndex := passes.values[i];
		if (this.passOrder.Has(passIndex)) continue;
		if (this.readersByPass.Has(passIndex))
		{
			resourcesRead := this.readersByPass.Get(passIndex);
			for (ix .. resourcesRead.count)
			{
				readResourceHandle := resourcesRead.values[ix];
				if (this.writersByResource.Has(readResourceHandle))
				{
					passesWritingResource := this.writersByResource.Get(readResourceHandle)~;
					this.WalkResources(readResourceHandle, passesWritingResource);
				}
			}
		}

		this.passOrder.Add(i);
	}
}

RenderGraph::Execute(context: RenderPassContext<Renderer>)
{
	for (passIndex in this.passOrder)
	{
		pass := this.passes[passIndex];
		pass.exec(context@, pass.data);
	}

	this.Clear();
}

RenderGraph::Clear()
{
	this.passes.Clear();
	this.handles.Clear();
	this.readersByResource.Clear();
	this.readersByPass.Clear();
	this.writersByResource.Clear();
	this.passOrder.Clear();
}

