package BucketAllocator

import Atomic
import BitSet
import SpinLock
import Math

state BucketAllocator
{
	mem: Allocator<byte>,

	bucketStatus: BitSet,
	itemStatus: BitSet,
	
	currBucket: Atomic<uint32>,
	itemSize: uint32,
	itemCount: uint32,
	bucketCount: uint32,
}

BucketAllocator::(itemSize: uint32, itemCount: uint32, bucketCount: uint32)
{
	this.itemSize = itemSize;
	this.itemCount = itemCount;
	this.bucketCount = Math.Max(bucketCount, 2);

	this.mem.Alloc(this.itemSize * this.itemCount * this.bucketCount);

	this.bucketStatus = BitSet(this.bucketCount);
	this.itemStatus = BitSet(this.itemCount * this.bucketCount);
	
	this.currBucket.Init(0);
}

BucketAllocator::delete 
{
	this.mem.Dealloc(0);

	delete this.bucketStatus;
	delete this.itemStatus;
}

uint32 BucketAllocator::IncCurrBucket() => 
{
	this.currBucket.Add(1);
	return this.currBucket.value % this.bucketCount;
}

int BucketAllocator::GetNextBucketIndex()
{
	start := this.currBucket.Load();

	curr := this.IncCurrBucket();
	while (curr != start)
	{
		if (!this.bucketStatus[curr]) return curr;
		curr = this.IncCurrBucket();
	}

	return -1;	
}

*byte BucketAllocator::Alloc(bucketIndex: int = -1)
{
	if (bucketIndex == -1) bucketIndex = this.GetNextBucketIndex();
	if (bucketIndex == -1) 
	{
		log "Bucket allocator full";
		return null;
	}

	itemIndex := this.itemCount * bucketIndex;
	itemPtr := null as *byte;
	full := true;

	for (i .. this.itemCount)
	{
		currItemIndex := itemIndex + i;
		if (!this.itemStatus[currItemIndex])
		{
			if (!itemPtr)
			{
				this.itemStatus.Set(currItemIndex);
				itemPtr = this.mem[this.itemSize * currItemIndex];
			}
			else
			{
				full = false;
				break;
			}
		}
	}

	if (full) this.bucketStatus.Set(bucketIndex);

	return itemPtr;
}

BucketAllocator::Dealloc(ptr: *any)
{
	offset := (ptr - this.mem[0]) as uint32;
	itemIndex := offset / this.itemSize;
	bucketIndex := itemIndex / this.itemCount;
	
	this.itemStatus.Clear(itemIndex);
	this.bucketStatus.Clear(bucketIndex);
}