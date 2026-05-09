package MultipleConsumerQueue

import Atomic

import Fiber

CacheLineSize := 64;

state AlignedAtomic
{
	atomic: Atomic<uint>,
	padding: [CacheLineSize - #sizeof Atomic<uint>]byte
}

AlignedAtomic::()
{
	this.atomic.Init(0);
}

state QueueSlot<Type>
{
	turn := AlignedAtomic(),
	item: Type,
}

state MultipleConsumerQueue<Type>
{
	capacity: uint,
	slots: Allocator<QueueSlot<Type>>,
	head: AlignedAtomic,
	tail: AlignedAtomic,
}

MultipleConsumerQueue::(capacity: uint)
{
	this.capacity = capacity;
	this.slots.Alloc(capacity + 1);
	
	for (i .. this.capacity)
	{
		this.slots[i]~ = QueueSlot<Type>();
	}

	this.head.atomic.Init(0);
	this.tail.atomic.Init(0);
}

MultipleConsumerQueue::delete
{
	this.slots.Dealloc(this.capacity);
}

uint MultipleConsumerQueue::Index(i: uint) => i % this.capacity;
uint MultipleConsumerQueue::Turn(i: uint) => i / this.capacity;

void MultipleConsumerQueue::Enqueue(item: Type)
{
	head := this.head.atomic.Add(1);
	slot := this.slots[this.Index(head)];
	
	while (this.Turn(head) * 2 != slot.turn.atomic.Load(MemoryOrder.Acquire)) {}

	slot.item = item;
	slot.turn.atomic.Store(this.Turn(head) * 2 + 1, MemoryOrder.Release);
}

bool MultipleConsumerQueue::TryEnqueue(item: Type)
{
	head := this.head.atomic.Load(MemoryOrder.Acquire);

	while (true)
	{
		slot := this.slots[this.Index(head)];
		if (this.Turn(head) * 2 == slot.turn.atomic.Load(MemoryOrder.Acquire)) 
		{
			if (this.head.atomic.CompareExchange(head@, head + 1))
			{
				slot.item = item;
				slot.turn.atomic.Store(this.Turn(head) * 2 + 1, MemoryOrder.Release);
				return true;
			}
		}
		else
		{
			prevHead := head;
			head = this.head.atomic.Load(MemoryOrder.Acquire);
			if (head == prevHead) return false;
		}
	}

	return false;
}

Type MultipleConsumerQueue::Dequeue()
{
	tail := this.tail.atomic.Add(1);
	slot := this.slots[this.Index(tail)];

	while (this.Turn(tail) * 2 + 1 != slot.turn.atomic.Load(MemoryOrder.Acquire)) {}

	item := slot.item~;
	slot.turn.atomic.Store(this.Turn(tail) * 2 + 2, MemoryOrder.Release);
	return item;
}

bool MultipleConsumerQueue::TryDequeue(item: *Type)
{
	tail := this.tail.atomic.Load(MemoryOrder.Acquire);

	while (true)
	{
		slot := this.slots[this.Index(tail)];
		if (this.Turn(tail) * 2 + 1 == slot.turn.atomic.Load(MemoryOrder.Acquire))
		{
			if (this.tail.atomic.CompareExchange(tail@, tail + 1))
			{
				item~ = slot.item;
				slot.turn.atomic.Store(this.Turn(tail) * 2 + 2, MemoryOrder.Release);
				return true;
			}
		}
		else
		{
			prevTail := tail;
			tail = this.tail.atomic.Load(MemoryOrder.Acquire)
			if (tail == prevTail) return false;
		}
	}

	return false;
}
