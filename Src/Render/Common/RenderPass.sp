package RenderCommon

import SizedArray
import MurmurHash

MaxAttachmentCount := 8;
InvalidAttchmentIndex := uint32(-1);

enum LoadOp: uint16
{
	Load,
	Clear,
	Undefined
}

enum StoreOp: uint16
{
	Store,
	Undefined
}

enum StageFlags: uint32
{
	None = 0,
	Top = 1 << 0,
    DrawIndirect = 1 << 1,
    VertexInput = 1 << 2,
    VertexShader = 1 << 3,
    TessellationControl = 1 << 4,
    TessellationEvaluation = 1 << 5,
    GeometryShader = 1 << 6,
    FragmentShader = 1 << 7,
    EarlyFragmentTest = 1 << 8,
    LateFragmentTest = 1 << 9,
    ColorOutput = 1 << 10,
    ComputeShader = 1 << 11,
    Transfer = 1 << 12,
    Bottom = 1 << 13,
    Host = 1 << 14,
    AllGraphics = 1 << 15,
    AllCommands = 1 << 16,
}

enum AccessFlags: uint32
{
	None = 0,
	IndirectRead = 1 << 0,
	IndexRead = 1 << 1,
	VertexRead = 1 << 2,
	UniformRead = 1 << 3,
	InputRead = 1 << 4,

	ShaderRead = 1 << 5,
	ShaderWrite = 1 << 6,

	ColorRead = 1 << 7,
	ColorWrite = 1 << 8,

	DepthRead = 1 << 9,
	DepthWrite = 1 << 10,

	TransferRead = 1 << 11,
	TransferWrite = 1 << 12,
	HostRead = 1 << 13,
	HostWrite = 1 << 14,
	MemoryRead = 1 << 15,
	MemoryWrite = 1 << 16
}

state Attachment
{
	format: GPUTextureFormat,
	samples: GPUSampleCount,
	
	fromLayout: GPUTextureLayout,
	toLayout: GPUTextureLayout,

	load: LoadOp,
	store: StoreOp,
	stencilLoad: LoadOp,
	stencilStore: StoreOp
}

state AttachmentRef
{
	attachmentIndex: uint32 = InvalidAttchmentIndex,
	layout: GPUTextureLayout
}

state Subpass
{
	inputAttachments: SizedArray<AttachmentRef, 8>,
	colorAttachments: SizedArray<AttachmentRef, 8>,
	depthStencilAttachment: AttachmentRef
}

state SubpassDependency
{
	fromSubpassIndex: uint16,
	toSubpassIndex: uint16,

	fromStageMask: StageFlags,
	toStageMask: StageFlags,

	fromAccessMask: AccessFlags,
	toAccessMask: AccessFlags,
}

state RenderPass
{
	attachments: SizedArray<Attachment, 8>,
	subpass: Subpass
}

uint HashRenderPass(renderPass: RenderPass)
{
	return MHash<RenderPass>(renderPass);
}

bool RenderPassEquals(left: RenderPass, right: RenderPass)
{
	if (left.attachments.count != right.attachments.count ||
		left.subpass.inputAttachments.count != right.subpass.inputAttachments.count ||
		left.subpass.colorAttachments.count != right.subpass.colorAttachments.count) return false;

	attachmentEqual := ::bool(left: Attachment, right: Attachment) {
		return left.format == right.format &&
			   left.samples == right.samples &&
			   left.fromLayout == right.fromLayout &&
			   left.toLayout == right.toLayout &&
			   left.load == right.load &&
			   left.store == right.store &&
			   left.stencilLoad == right.stencilLoad &&
			   left.stencilStore == right.stencilStore;
	}

	attachmentRefEqual := ::bool(left: AttachmentRef, right: AttachmentRef) {
		return left.attachmentIndex == right.attachmentIndex &&
			   left.layout == right.layout;
	}

	for (i .. left.attachments.count)
	{
		if (!attachmentEqual(left.attachments[i], right.attachments[i])) return false;
	}

	for (i .. left.subpass.inputAttachments.count)
	{
		if (!attachmentRefEqual(left.subpass.inputAttachments[i], right.subpass.inputAttachments[i])) return false;
	}

	for (i .. left.subpass.colorAttachments.count)
	{
		if (!attachmentRefEqual(left.subpass.colorAttachments[i], right.subpass.colorAttachments[i])) return false;
	}

	return attachmentRefEqual(left.subpass.depthStencilAttachment, right.subpass.depthStencilAttachment);
}