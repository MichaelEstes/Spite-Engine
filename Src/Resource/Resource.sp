package Resource

enum ResourceType: uint32
{
	File,
	GLTF,
}

enum ResourceResult: uint32
{
	Loaded,
	NotFound,
	LoadFailed,
	Invalid
}

enum ResourceFlags: uint32
{
	Packed,
}

state ResourceData
{
	contents: *void,
	byteCount: uint,
	metadata: *void
}

state ResourceHandle
{
	id: uint32
}

state Resource
{
	path: string,
	data: ResourceData,

	handle: ResourceHandle,
	type: ResourceType,
	flags: ResourceFlags
}