package SingleConsumerQueue

import Atomic
import Mutex
import Math
import BitArray

NullIndex := uint32(0x000FFFFF);

state AllocRef
{
	val: ?{
		i: uint64,
		bits: BitArray<64>
	}
}

AllocRef::()
{
	this.Set(NullIndex, 0, 0);
}

AllocRef::(alloc: AllocRef)
{
	this.val.i = alloc.val.i;
}

AllocRef::(arrayIndex: uint32, version: uint32)
{
	this.Set(arrayIndex, 0, version);
}

AllocRef::(arrayIndex: uint32, stackIndex: uint32, version: uint32)
{
	this.Set(arrayIndex, stackIndex, version);
}

AllocRef::Set(arrayIndex: uint32, stackIndex: uint32, version: uint32)
{
	this.val.bits.SetRange<uint32>(0, 19, arrayIndex);
	this.val.bits.SetRange<uint32>(20, 39, stackIndex);
	this.val.bits.SetRange<uint32>(40, 63, version);
}

{ arrayIndex: uint32, stackIndex: uint32, version: uint32 } AllocRef::Get()
{
	arrayIndex := this.val.bits.Range<uint32>(0, 19);
	stackIndex := this.val.bits.Range<uint32>(20, 39);
	version := this.val.bits.Range<uint32>(40, 63);

	return { arrayIndex, stackIndex, version };
}

state RefAllocator
{
	freeList: Allocator<AllocRef>,
	top: AllocRef,
	maxSize: uint64
}

RefAllocator::(size: uint64)
{
	this.maxSize = size + 1;
	this.freeList.Alloc(this.maxSize);

	this.freeList[0].Set(NullIndex, 0, 0);
	
	for (i := 1 .. this.maxSize)
	{
		this.freeList[i].Set(i - 1, i, i);
	}

	this.top.val.i = this.freeList[this.maxSize - 1].val.i;
}

RefAllocator::delete 
{
	this.freeList.Dealloc(this.maxSize);
}

bool RefAllocator::IsFull() => this.top.Get().stackIndex == this.maxSize - 1;

bool RefAllocator::IsEmpty() => this.top.Get().stackIndex == 0;

uint32 RefAllocator::Alloc()
{
	while (1)
	{
		top := this.top.Get();
		stackTop := this.freeList[top.stackIndex].Get();

		atomic_compare_exchange_strong_u64(
			this.freeList[top.stackIndex].val.i@, 
			AllocRef(stackTop.arrayIndex, stackTop.stackIndex, top.version - 1).val.i@,
			AllocRef(top.arrayIndex, stackTop.stackIndex, top.version).val.i,
			MemoryOrder.AcquireRelease,
			MemoryOrder.Relaxed
		);

		if (top.stackIndex == 0) continue; // Stack Empty?

		belowTop := this.freeList[top.stackIndex - 1].Get();

		if (
			atomic_compare_exchange_strong_u64(
				this.top.val.i@, 
				AllocRef(top.arrayIndex, top.stackIndex, top.version).val.i@,
				AllocRef(belowTop.arrayIndex, top.stackIndex - 1, belowTop.version + 1).val.i,
				MemoryOrder.AcquireRelease,
				MemoryOrder.Relaxed
			)
		)
		{
			return top.arrayIndex;
		}
	}

	return 0;
}

RefAllocator::Free(arrayIndex: uint32)
{
	while (1)
	{
		top := this.top.Get();
		stackTop := this.freeList[top.stackIndex].Get();

		atomic_compare_exchange_strong_u64(
			this.freeList[top.stackIndex].val.i@,
			AllocRef(stackTop.arrayIndex, stackTop.stackIndex, top.version - 1).val.i@,
			AllocRef(top.arrayIndex, stackTop.stackIndex,top.version).val.i,
			MemoryOrder.AcquireRelease,
			MemoryOrder.Relaxed
		);

		if (top.stackIndex == this.maxSize - 1) continue;
		
		aboveTopCounter := this.freeList[top.stackIndex + 1].Get().version;

		if (
			atomic_compare_exchange_strong_u64(
				this.top.val.i@, 
				AllocRef(top.arrayIndex, top.stackIndex, top.version).val.i@,
				AllocRef(arrayIndex, top.stackIndex + 1, aboveTopCounter + 1).val.i,
				MemoryOrder.AcquireRelease,
				MemoryOrder.Relaxed
			)
		)
		{
			return;
		}
	}
}

state SingleConsumerQueue<Type>
{
	refAllocator: RefAllocator, 
	mem: Allocator<Type>,
	queue: Allocator<AllocRef>,

	front := uint32(0),
	back := uint32(0),
	capacity := uint32(0)
}

SingleConsumerQueue::(capacity: uint32)
{
	this.refAllocator = RefAllocator(capacity);

	maxSize := capacity + 1;
	this.mem.Alloc(maxSize);
	this.queue.Alloc(maxSize);
	this.capacity = maxSize;

	for (i .. maxSize)
	{
		this.queue[i]~ = AllocRef();
	}
}

uint32 SingleConsumerQueue::Count()
{
	return Math.Abs(this.back - this.front + this.capacity) % this.capacity;
}

void SingleConsumerQueue::Enqueue(item: Type)
{
	index := NullIndex;

	while (index == NullIndex)
	{
		index = this.refAllocator.Alloc();
	}

	if (index > this.capacity)
	{
		log "UHOH", index, this.capacity;
	}
	this.mem[index]~ = item;

	while (1)
	{
		tail := this.back;
		alloc := this.queue[tail % this.capacity]~;
		head := this.front;

		if (tail != this.back) 
		{
			continue;
		}

		if (tail == this.front + this.capacity)
		{
			if (this.queue[head % this.capacity].Get().arrayIndex != NullIndex)
			{
				if (head == this.front)
				{
					continue; //Queue is full.
				}
			}

			atomic_compare_exchange_strong_u32(
				this.front@, 
				head@,
				head + 1,
				MemoryOrder.AcquireRelease,
				MemoryOrder.Relaxed
			);
			continue;
		}

		allocBits := alloc.Get();
		if (allocBits.arrayIndex == NullIndex)
		{
			if (
				atomic_compare_exchange_strong_u64(
					this.queue[tail % this.capacity].val.i@, 
					alloc.val.i@,
					AllocRef(index, allocBits.version + 1).val.i,
					MemoryOrder.AcquireRelease,
					MemoryOrder.Relaxed
				)
			)
			{
				atomic_compare_exchange_strong_u32(
					this.back@, 
					tail@,
					tail + 1,
					MemoryOrder.AcquireRelease,
					MemoryOrder.Relaxed
				);

				return;
			}
		}
		else if (this.queue[tail % this.capacity].Get().arrayIndex != NullIndex)
		{
			atomic_compare_exchange_strong_u32(
				this.back@, 
				tail@,
				tail + 1,
				MemoryOrder.AcquireRelease,
				MemoryOrder.Relaxed
			);
		}
	}
}

Type SingleConsumerQueue::Dequeue(retOnEmpty: bool = false)
{
	log "Queue Count: ", this.Count();
	while (1)
	{
		head := this.front;
		alloc := this.queue[head % this.capacity]~;
		tail := this.back;

		if (head != this.front) 
		{
			continue;
		}

		if (head == this.back)
		{
			if (this.queue[tail % this.capacity].Get().arrayIndex == NullIndex)
			{
				if (tail == this.back) 
				{
					if (retOnEmpty) 
					{
						return Type();
					}

					continue; // Queue is empty.
				}
			}

			atomic_compare_exchange_strong_u32(
				this.back@, 
				tail@,
				tail + 1,
				MemoryOrder.AcquireRelease,
				MemoryOrder.Relaxed
			);
		}

		allocBits := alloc.Get();
		if (allocBits.arrayIndex != NullIndex)
		{
			if (
				atomic_compare_exchange_strong_u64(
					this.queue[head % this.capacity].val.i@, 
					alloc.val.i@,
					AllocRef(NullIndex, allocBits.version + 1).val.i,
					MemoryOrder.AcquireRelease,
					MemoryOrder.Relaxed
				)
			)
			{
				atomic_compare_exchange_strong_u32(
					this.front@, 
					head@,
					head + 1,
					MemoryOrder.AcquireRelease,
					MemoryOrder.Relaxed
				);

				item := this.mem[allocBits.arrayIndex]~;
				this.refAllocator.Free(allocBits.arrayIndex);
				return item;
			}
		}
		else if (this.queue[head % this.capacity].Get().arrayIndex == NullIndex)
		{
			atomic_compare_exchange_strong_u32(
				this.front@, 
				head@,
				head + 1,
				MemoryOrder.AcquireRelease,
				MemoryOrder.Relaxed
			);
		}
	}

	return Type();
}