package ThreadParamAllocator

import BucketAllocator

state ThreadParamAllocator
{
	slabs := [
		BucketAllocator(32, 64, 4),
		BucketAllocator(64, 32, 4),
		BucketAllocator(128, 16, 4),
		BucketAllocator(256, 8, 4)
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