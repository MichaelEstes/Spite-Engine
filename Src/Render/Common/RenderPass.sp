package RenderCommon

import Array

enum LoadOp: uint32
{
	Load,
	Clear,
	Undefined
}

enum StoreOp: uint32
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
	load: LoadOp,
	store: StoreOp,
	stencilLoad: LoadOp,
	stencilStore: StoreOp,
	fromLayout: GPUTextureLayout,
	toLayout: GPUTextureLayout
}

state AttachmentRef
{
	attachmentIndex: uint32,
	layout: GPUTextureLayout
}

state Subpass
{
	inputAttachments: Array<AttachmentRef>,
	colorAttachments: Array<AttachmentRef>,
	depthStencilAttachment: AttachmentRef
}

state SubpassDependency
{
	fromSubpassIndex: uint32,
	toSubpassIndex: uint32,

	fromStageMask: StageFlags,
	toStageMask: StageFlags,

	fromAccessMask: AccessFlags,
	toAccessMask: AccessFlags,
}

state RenderPass
{
	attachments: Array<Attachment>,
	subpasses: Array<Subpass>,
	dependecies: Array<SubpassDependency>
}