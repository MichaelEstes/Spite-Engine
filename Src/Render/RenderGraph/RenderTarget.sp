package RenderGraph


enum RenderTargetKind
{
	Named,
	Desc,
	Direct
}

state RenderTargetDesc
{
	width: uint32,
	height: uint32,

}

state RenderTarget
{
	target: ?{
		name: string,
		desc: RenderTargetDesc
		direct: RenderResource
	},
	kind: RenderTargetKind
}