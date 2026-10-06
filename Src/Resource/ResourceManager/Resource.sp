package Resource

import Atomic
import UntypedHandleSet

InvalidResourceHandle := ResourceHandle();

enum ResourceResult: uint32
{
	Loading,
	Loaded,
	NotFound,
	LoadFailed,
	Released,
	Invalid
}

state ResourceKey
{
	value: ?{
		name: string,
		id: uint
	}
}

ResourceKey::(name: string)
{
	assert name.count, "Resource keys cannot be empty";
	this.value.name = name;
}

ResourceKey::(id: uint)
{
	zero_out_bytes(this@, #sizeof ResourceKey);
	this.value.id = id;
}

ResourceKey::delete
{
	if (this.IsString()) delete this.value.name;
}

bool ResourceKey::IsString()
{
	return (this.value as [2]uint)[1];
}

uint HashResourceKey(resourceKey: ResourceKey)
{
	if (resourceKey.IsString())
	{
		return DefaultHash<string>(resourceKey.value.name);
	}

	return resourceKey.value.id;
}

bool ResourceKeyEquals(left: ResourceKey, right: ResourceKey)
{
	if (left.IsString())
	{
		if (right.IsString())
		{
			return left.value.name == right.value.name;
		}

		return false;
	}

	return left.value.id == right.value.id;
}

state ResourceRef
{
    type: *_Type,
    id: uint32
}

bool ResourceRef::operator::==(right: ResourceRef)
{
	return this.type == right.type && this.id == right.id;
}

bool ResourceRef::Valid() => return this.id;

state ResourceHandle
{
    parent: ResourceRef,

    type: *_Type,
    id: uint32,
	manager: uint32
}

bool ResourceHandle::operator::==(right: ResourceHandle)
{
	return this.parent == right.parent &&
		   this.type == right.type &&
		   this.id == right.id &&
		   this.manager == right.manager;
}

bool ResourceHandle::Valid() => return this.id;

state SubResource<Type>
{
    key: ResourceKey,
    data: Type
}

state Resource<Type>
{
    key: ResourceKey,
    refCount: Atomic<uint32>,
    result: ResourceResult,

    subResourceToHandle: Map<*_Type, Map<ResourceKey, ResourceHandle, HashResourceKey, ResourceKeyEquals>>,
    subResources: Map<*_Type, UntypedHandleSet>,

    data: Type 
}