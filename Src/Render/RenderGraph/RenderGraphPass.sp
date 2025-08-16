package RenderGraph

import RenderCommon
import Array
import Common

MaxPassResourceCount := 16;

enum RenderPassStage: uint32
{
	Graphics,
	Compute
}

enum RenderPassFlags: uint32
{
	None = 0,
	SelfManagedRenderPass = 1 << 0,
}

enum ResourceAccess: uint16
{
	Read = 1 << 0,
	Write = 1 << 1
}

ReadWriteMask := ResourceAccess.Read | ResourceAccess.Write;

enum ResourceUsageFlags: uint16
{
	None = 0,

	// Attachment flags
	// Reads
	Sampled = 1 << 0,
	Input = 1 << 1,
	StorageRead = 1 << 2,

	// Writes
	Color = 1 << 3,
	Depth = 1 << 4,
	Stencil = 1 << 5,
	StorageWrite = 1 << 6,
	DepthStencil = ResourceUsageFlags.Depth | ResourceUsageFlags.Stencil,
	
	Vertex = 1 << 7,
	Index = 1 << 8,

	TransferSrc = 1 << 9,
	TransferDst = 1 << 10,

	// Load/Store ops flags
	Load = 1 << 11,
	Clear = 1 << 12,
	Store = 1 << 13,
	LoadUndefined = 1 << 14,
	StoreUndefined = 1 << 15,

	DefaultRead = ResourceUsageFlags.Sampled,
	DefaultWrite = ResourceUsageFlags.Color,
}

AttachmentMask := ResourceUsageFlags.Color | ResourceUsageFlags.DepthStencil | ResourceUsageFlags.Input;

state DepthStencilClear
{
	depth: float32,
    stencil: uint32 = uint32(-1);
}

InvalidColor := { float32(-1.0), float32(-1.0), float32(-1.0), float32(-1.0) } as Color;

state RenderResourceUsage
{
	handle: RenderResourceHandle,
	access: ResourceAccess,
	usage: ResourceUsageFlags,
}

bool RenderResourceUsage::IsRead() => this.access & ResourceAccess.Read;

bool RenderResourceUsage::IsWrite() => this.access & ResourceAccess.Write;

bool RenderResourceUsage::IsReadOnly() => this.IsRead() & !this.IsWrite();

bool RenderResourceUsage::IsReadWrite() => (this.access & ReadWriteMask) == ReadWriteMask;

bool RenderResourceUsage::NeedsAttachment()
{
	hasAttachmentMask := (this.usage & AttachmentMask) != 0;
	isWrite := this.IsWrite();
	isInput := (this.usage & ResourceUsageFlags.Input) != 0;

	return hasAttachmentMask & (isWrite | isInput);
}

state RenderGraphPass<Renderer>
{
	name: string,
	resources: [MaxPassResourceCount]RenderResourceUsage,
	exec: ::(*RenderPassContext<Renderer>, *any),
	clearColor: Color,
	depthStencilClear: DepthStencilClear,
	renderArea: Rect2D,
	data: *any,

	resourceCount: uint32,
	stage: RenderPassStage,
	flags: RenderPassFlags
}

bool RenderGraphPass::ValidClearColor() => this.clearColor.r != float32(-1.0);
bool RenderGraphPass::ValidDepthStencilClear() => this.depthStencilClear.stencil != uint32(-1);

state RenderPassBuilder<Renderer>
{
	renderGraph: *RenderGraph<Renderer>,
	resources: [MaxPassResourceCount]RenderResourceUsage,
	clearColor: Color = InvalidColor,
	depthStencilClear: DepthStencilClear,
	renderArea: Rect2D,
	index: uint32
}

*Renderer RenderPassBuilder::Renderer()
{
	return this.renderGraph.renderer;
}

RenderPassBuilder::Add(handle: RenderResourceHandle, access: ResourceAccess, 
					   usage: ResourceUsageFlags)
{
	for (i .. this.index)
	{
		if (this.resources[i].handle == handle)
		{
			this.resources[i].access |= access;
			this.resources[i].usage |= usage;
			return;
		}
	}

	assert this.index < MaxPassResourceCount, "Resource limit for render pass reached";

	resourceUsage := { handle, access, usage } as RenderResourceUsage;
	this.resources[this.index] = resourceUsage;
	this.index += 1;
}

RenderPassBuilder::Read(target: RenderResourceHandle,
						usage: ResourceUsageFlags = ResourceUsageFlags.DefaultRead)
{
	this.Add(target, ResourceAccess.Read, usage);
}

RenderPassBuilder::Write(target: RenderResourceHandle,
						 usage: ResourceUsageFlags = ResourceUsageFlags.DefaultWrite)
{
	this.Add(target, ResourceAccess.Write, usage);
}

RenderResourceHandle RenderPassBuilder::Create(name: string, desc: ResourceDesc)
{
	return this.renderGraph.RegisterResourceToCreate(name, desc);
}

RenderResourceHandle RenderPassBuilder::CreateTexture(name: string, texture: TextureDesc)
{
	desc := ResourceDesc();
	desc.kind = ResourceKind.Texture;
	desc.desc.texture = texture;

	return this.Create(name, desc);
}

RenderResourceHandle RenderPassBuilder::CreateBuffer(name: string, buffer: BufferDesc)
{
	desc := ResourceDesc();
	desc.kind = ResourceKind.Buffer;
	desc.desc.buffer = buffer;

	return this.renderGraph.RegisterResourceToCreate(name, desc);
}

RenderPassBuilder::SetClearColor(color: Color)
{
	this.clearColor = color;
}

RenderPassBuilder::SetDepthStencilColor(clear: DepthStencilClear)
{
	this.depthStencilClear = clear;
}

RenderPassBuilder::SetRenderArea(rect: Rect2D)
{
	this.renderArea = rect;
}