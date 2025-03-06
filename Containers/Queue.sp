package Queue

state Queue<Type, InitialCapacity = 16>
{
	mem: Allocator<Type>
	front: uint32,
	back: uint32
	count: uint32,
	capacity: uint32
}

Queue::()
{
	this.mem.Alloc(InitialCapacity);
	this.capacity = InitialCapacity;
}

Queue::Enqueue(value: Type)
{
	if(this.count >= this.capacity) this.Expand();	

	this.mem[this.back]~ = value;
	this.back = (this.back + 1) % this.capacity;
	this.count += 1;
}

Type Queue::Dequeue()
{
	assert this.count != 0, "Cannot dequeue from an empty queue";

	value := this.mem[this.front]~;
	this.front = (this.front + 1) % this.capacity;
	this.count -= 1;
	return value;
}

Queue::Expand()
{
	this.SizeTo((this.capacity + 1) * 2);
}

Queue::ExpandAtLeastTo(size: uint)
{
	capacity := this.capacity;
	while (capacity < size) capacity = (capacity + 1) * 2;
	this.SizeTo(capacity);
}

Queue::SizeTo(capacity: uint)
{
	this.mem.Resize(capacity, this.capacity);
	this.capacity = capacity;
}