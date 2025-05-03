package SlabAllocator

import Atomic
import BitSet
import SpinLock


state SlabAllocator
{
	slabs: Allocator<byte>,

	slabStatus: BitSet,
	itemStatus: BitSet,
	
	currSlab: uint32,
	itemSize: uint32,
	itemCount: uint32,
	slabCount: uint32,

	lock: SpinLock,
}

SlabAllocator::(itemSize: uint32, itemCount: uint32, slabCount: uint32)
{
	this.itemSize = itemSize;
	this.itemCount = itemCount;
	this.slabCount = slabCount;

	this.slabs.Alloc(itemSize * itemCount * slabCount);

	this.slabStatus = BitSet(slabCount);
	this.itemStatus = BitSet(itemCount * slabCount);
	
	this.currSlab = 0;

	this.lock = SpinLock();
}

SlabAllocator::delete 
{
	this.slabs.Dealloc(0);

	delete this.slabStatus;
	delete this.itemStatus;
}

int SlabAllocator::GetSlabIndex()
{
	start := this.currSlab;

	this.currSlab = (this.currSlab + 1) % this.slabCount;
	while (this.currSlab != start)
	{
		if (!this.slabStatus[this.currSlab]) return this.currSlab;
		this.currSlab = (this.currSlab + 1) % this.slabCount;
	}

	return -1;	
}

*byte SlabAllocator::Alloc()
{
	this.lock.Lock();

	index := this.GetSlabIndex();
	if (index == -1) 
	{
		log "Slab allocator full";
		return null;
	}

	startItemIndex := index * this.itemCount;
	startItemPtr := this.slabs[index * this.itemSize * this.itemCount];
	itemPtr := null as *byte;
	full := true;

	for (i .. this.itemCount)
	{
		itemIndex := startItemIndex + i;
		if (!this.itemStatus[itemIndex])
		{
			if (!itemPtr)
			{
				this.itemStatus.Set(itemIndex);
				itemPtr = startItemPtr + (i * this.itemSize);
			}
			else
			{
				full = false;
				break;
			}
		}
	}

	if (full) this.slabStatus.Set(index);

	this.lock.Unlock();

	return itemPtr;
}

SlabAllocator::Dealloc(ptr: *any)
{
	log "Deallocating";
	offset := (ptr - this.slabs[0]) as uint;
	slabIndex := offset / this.slabCount;
	itemIndex := offset / this.itemSize;
	
	//log "Offset: ", offset;
	//log "Slab Count: ", this.slabCount;
	//log "Deallocating Slab index: ", slabIndex;

	this.lock.Lock();
	{
		this.slabStatus.Clear(slabIndex);
		this.itemStatus.Clear(itemIndex);
	}
	this.lock.Unlock();
}