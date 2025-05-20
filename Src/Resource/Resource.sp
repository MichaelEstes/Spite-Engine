package Resource

import Array

enum ResourceResult: uint32
{
	NotLoaded,
	Loading,
	Loaded,
	NotFound,
	LoadFailed
}

state ResourceHandle
{
	id: uint32
}

state ResourceParam<Type>
{
	key: string,
	onLoad: ::(ResourceHandle),
	data: Type
}

state Resource<Type>
{
	key: string,
	data: Type,
	metadata: *void

	parent: ResourceHandle,
	result: ResourceResult,
	refCount: uint32
}