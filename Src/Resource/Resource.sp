package Resource

import Array

enum ResourceResult: uint32
{
	Loaded,
	NotFound,
	LoadFailed
}

state ResourceHandle
{
	id: uint32
}

state Resource<Type>
{
	key: string,
	data: *Type,
	metadata: *void

	parent: ResourceHandle,
	result: ResourceResult,
	refCount: uint32
}