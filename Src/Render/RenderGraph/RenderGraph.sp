package RenderGraph

import SDL
import Array
import BitSet
import SparseSet
import RenderCommon

MaxPassCountForResource := 32;

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
	readerResourceToPasses := SparseSet<PassResourceArray>(),
	readerPassToResources := SparseSet<PassResourceArray>(),
	writerResourceToPasses := SparseSet<PassResourceArray>(),
	writerPassToResources := SparseSet<PassResourceArray>(),
	passOrder: Array<uint32>,
	passSet := BitSet(MaxPassCountForResource),
	renderPassPool: RenderPassPool,

	transitionTexture: ::(*any, GPUTextureLayout, GPUTextureLayout, GPUTextureFormat, *Renderer)
}

RenderGraph::SetResourceTables(resourceTables: *ResourceTables<Renderer>)
{
	this.handles.resourceTables = resourceTables;
}

RenderGraph::SetTransitionTextureFunc(transitionTexture: ::(*any, GPUTextureLayout, GPUTextureLayout, 
															GPUTextureFormat, *Renderer))
{
	this.transitionTexture = transitionTexture;
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
		pass.resourceCount = builder.index;
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
		for (ix .. pass.resourceCount)
		{
			resource := pass.resources[ix]
			if (resource.IsRead())
			{
				this.AddHandleToPassIndexSet(resource.handle.handle, i, this.readerResourceToPasses);
				this.AddHandleToPassIndexSet(i, resource.handle.handle, this.readerPassToResources);
			}
			else
			{
				this.AddHandleToPassIndexSet(resource.handle.handle, i, this.writerResourceToPasses);
				this.AddHandleToPassIndexSet(i, resource.handle.handle, this.writerPassToResources);
			}
		}
	}

	for (readerKV in this.readerResourceToPasses)
	{
		resourceHandle := readerKV.key~;
		passes := readerKV.value~;
		this.WalkResources(resourceHandle, passes);
	}

	for (i .. this.passes.count)
	{
		if (!this.passSet[i])
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
		if (this.readerPassToResources.Has(passIndex))
		{
			resourcesRead := this.readerPassToResources.Get(passIndex);
			for (ix .. resourcesRead.count)
			{
				readResourceHandle := resourcesRead.values[ix];
				if (this.writerResourceToPasses.Has(readResourceHandle))
				{
					passesWritingResource := this.writerResourceToPasses.Get(readResourceHandle)~;
					this.WalkResources(readResourceHandle, passesWritingResource);
				}
			}
		}

		this.passSet.Set(i);
		this.passOrder.Add(i);
	}
}

bool RenderGraph::HasPreviousWrite(resourceHandle: RenderResourceHandle, passOrderIndex: uint32)
{
	handle := resourceHandle.handle;
	currIndex := passOrderIndex - 1;

	while (currIndex != uint32(-1))
	{
		prevPassIndex := this.passOrder[currIndex];
		if (this.writerPassToResources.Has(prevPassIndex))
		{
			passResourceArr := this.writerPassToResources.Get(handle);
			for (i .. passResourceArr.count)
			{
				if (passResourceArr.values[i] == handle) return true;
			}
		}

		currIndex -= 1;
	}

	return false;
}

LoadOp RenderGraph::GetLoadOpForResource(resourceUsage: RenderResourceUsage, passOrderIndex: uint32)
{
	if (resourceUsage.usage & ResourceUsageFlags.Load) return LoadOp.Load;
	else if (resourceUsage.usage & ResourceUsageFlags.Clear) return LoadOp.Clear;
	else if (resourceUsage.usage & ResourceUsageFlags.LoadUndefined) return LoadOp.Undefined;

	if (resourceUsage.IsRead() && 
		this.HasPreviousWrite(resourceUsage.handle, passOrderIndex))
	{
		return LoadOp.Load;
	}

	return LoadOp.Undefined;
}

StoreOp RenderGraph::GetStoreOpForResource(resourceUsage: RenderResourceUsage)
{
	if (resourceUsage.usage & ResourceUsageFlags.Store) return StoreOp.Store;
	else if (resourceUsage.usage & ResourceUsageFlags.StoreUndefined) return StoreOp.Undefined;

	if (resourceUsage.IsWrite())
	{
		return StoreOp.Store;
	}

	return StoreOp.Undefined;
}

RenderPass RenderGraph::CreateRenderPass(pass: RenderGraphPass<Renderer>, passOrderIndex: uint32)
{
	renderPassIndex := this.renderPassPool.GetNextIndex();
	renderPass := this.renderPassPool[renderPassIndex];

	for (i .. pass.resourceCount)
	{
		resourceUsage := pass.resources[i];
		resourceHandle := resourceUsage.handle;
		resourceDesc := this.handles.GetResourceDesc(resourceHandle);

		if (resourceUsage.NeedsAttachment() && resourceDesc.kind == ResourceKind.Texture)
		{
			textureDesc := resourceDesc.desc.texture;
			attachment := Attachment();
			attachment.format = textureDesc.format;
			attachment.samples = textureDesc.samples;
			attachment.load = this.GetLoadOpForResource(resourceUsage, passOrderIndex);
			attachment.store = this.GetStoreOpForResource(resourceUsage);
		}
	}


	return renderPass;
}

RenderGraph::Execute(context: RenderPassContext<Renderer>)
{
	for (i .. this.passOrder.count)
	{
		passIndex := this.passOrder[i];
		pass := this.passes[passIndex];

		renderPass := this.CreateRenderPass(pass, i);
		pass.exec(context@, pass.data);
	}

	this.Clear();
}

RenderGraph::Clear()
{
	this.passes.Clear();
	this.handles.Clear();
	this.readerResourceToPasses.Clear();
	this.readerPassToResources.Clear();
	this.writerResourceToPasses.Clear();
	this.writerPassToResources.Clear();
	this.passOrder.Clear();
	this.passSet.ClearAll();
}

