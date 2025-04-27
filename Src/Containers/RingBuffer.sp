package RingBuffer

state RingBuffer<Type, InitialCapacity = 64>
{
	mem: Allocator<Type>
	current: uint32,
	capacity: uint32
}

RingBuffer::()
{
	this.mem.Alloc(InitialCapacity);
	this.current = 0;
	this.capacity = InitialCapacity;
}

*Type RingBuffer::Insert(value: Type)
{
	this.mem[this.current]~ = value;
	ptr := this.mem[this.current];
	this.current = (this.current + 1) % this.capacity;
	return ptr;
}

RingBuffer::Expand(capacity: uint32)
{
	if (capacity <= this.capacity) return;
	this.mem.Resize(capacity, this.capacity);
	this.capacity = capacity;
}