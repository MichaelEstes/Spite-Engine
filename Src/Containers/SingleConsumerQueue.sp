package SingleConsumerQueue

import Atomic
import Mutex
import Math

state SingleConsumerQueue<Type, InitialCapacity = 16>
{
	mutex := Mutex(), 
	mem: Atomic<*Type>,
	front := Atomic<uint32>(0),
	back := Atomic<uint32>(0),
	count := Atomic<uint32>(0),
	capacity: Atomic<uint32>,
}

SingleConsumerQueue::()
{
	capacity := Math.NextPowerOfTwo(InitialCapacity);
	this.capacity.Init(capacity);
	this.mem.Init(Allocator<Type>().Alloc(capacity).ptr);
}

SingleConsumerQueue::Enqueue(value: Type)
{
	if(this.count.Load() >= this.capacity.Load()) this.Expand();	

	this.mem.Load()[this.back.Load()]~ = value;
	this.back.Add(1);
	this.back.And(this.capacity.Load() - 1);
	this.count.Add(1);
}

Type SingleConsumerQueue::Dequeue()
{
	assert this.count.value != 0, "Cannot dequeue from an empty queue";

	value := this.mem.Load()[this.front.Load()]~;
	this.front.Add(1);
	this.front.And(this.capacity.Load() - 1);
	this.count.Sub(1);
	return value;
}

SingleConsumerQueue::Expand()
{
	prevCapacity := this.capacity.Load();
	if (this.mutex.TryLock())
	{
		this.SizeTo(Math.NextPowerOfTwo(prevCapacity + 1), prevCapacity);
		this.mutex.Unlock();
	}
	else
	{
		while (this.capacity.Load() == prevCapacity) {}
	}
}

SingleConsumerQueue::SizeTo(capacity: uint32, prevCapacity: uint32)
{
	prevMem := this.mem.Load();
	newMem := Allocator<Type>().Alloc(capacity).ptr;

	front := this.front.Load();
	count := this.count.Load();
	for (i .. count)
	{
		newMem[i]~ = prevMem[(front + i) & (prevCapacity - 1)]~;
	}

	this.capacity.Store(capacity);
	this.mem.Store(newMem);
	this.front.Store(0);
	delete prevMem;
}