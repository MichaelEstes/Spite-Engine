package SlabAllocator

import Atomic

state SlabAllocator
{
	slots: Allocator<byte>,
	freeStack: Allocator<Atomic<int32>>,
	
	end: Atomic<int32>,
	slotSize: uint32,
	capacity: uint32
}

SlabAllocator::(slotSize: uint32, capacity: uint32)
{
	this.slotSize = align_up(slotSize, 16);
	this.capacity = capacity;
	this.slots.Alloc(this.slotSize * capacity);
	this.freeStack.Alloc(capacity);

	for (i: uint32 .. capacity)
	{
		this.freeStack[i].Store(i);
	}
	this.freeStack[capacity - 1].Store(int32(-1));
	this.end = Atomic<int32>(0);
}

SlabAllocator::delete 
{
	this.slots.Dealloc(this.slotSize * this.capacity);
	this.freeStack.Dealloc(this.capacity);
}

*byte SlabAllocator::Alloc()
{
	currEnd := this.end.Load(MemoryOrder.Relaxed);

	while (currEnd != -1)
	{
		next := this.freeStack[currEnd].Load(MemoryOrder.Acquire);
		if (this.end.CompareExchange(currEnd@, next))
		{
			return this.slots[currEnd * this.slotSize];
		}
	}

	return null;
}

SlabAllocator::Dealloc(ptr: *any)
{
	offset := (ptr - this.slots[0]) as uint;
	index := (offset / this.slotSize) as int32;

	currEnd := this.end.Load(MemoryOrder.Relaxed);
	
	this.freeStack[index].Store(currEnd, MemoryOrder.Release);
	while (!this.end.CompareExchange(currEnd@, index))
	{
		this.freeStack[index].Store(currEnd, MemoryOrder.Release);
	}
}