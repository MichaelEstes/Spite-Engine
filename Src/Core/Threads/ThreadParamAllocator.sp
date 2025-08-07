package ThreadParamAllocator

import BucketAllocator

BucketCount := 4;

state ThreadParamAllocator
{
	slabs := [
		BucketAllocator(32,  64,  BucketCount),
		BucketAllocator(64,  32,  BucketCount),
		BucketAllocator(128, 16,  BucketCount),
		BucketAllocator(256, 8,   BucketCount)
	],
	
	indices := uint32:[
		0,
		0,
		0,
		0
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
	bucketIndex := paramAllocator.indices[index] + 1;
	paramAllocator.indices[index] = bucketIndex;

	slab := paramAllocator.slabs[index];
	return slab.Alloc(bucketIndex) as *Type;
}

DeallocThreadParam<Type>(value: *Type)
{
	index := GetSlabIndex<Type>();

	slab := paramAllocator.slabs[index];
	slab.Dealloc(value);
}