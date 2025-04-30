package ThreadParamAllocator

import SlabAllocator

state ThreadParamAllocator
{
	slabs := [
		SlabAllocator(32, 1024),
		SlabAllocator(64, 512),
		SlabAllocator(128, 256),
		SlabAllocator(256, 128)
	]
}

paramAllocator := ThreadParamAllocator();

int GetSlabIndex<Type>()
{
	index := #compile int {
		size := #sizeof Type;
		assert size <= 256, "Type too large for thread param allocator";
		
		if (size <= 32)
		{
			return 0;
		}
		else if (size <= 64)
		{
			return 1;
		}
		else if (size <= 128)
		{
			return 2;
		}

		return 3;
	}

	return index;
}

*Type AllocThreadParam<Type>()
{
	index := GetSlabIndex<Type>();

	slab := paramAllocator.slabs[index];
	return slab.Alloc() as *Type;
}

DeallocThreadParam<Type>(value: *Type)
{
	index := GetSlabIndex<Type>();

	slab := paramAllocator.slabs[index];
	slab.Dealloc(value);
}