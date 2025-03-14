package FixedRingBuffer

state FixedRingBuffer<Type, Size = 64>
{
	mem: [Size]Type
	current: uint32
}

*Type FixedRingBuffer::Insert(value: Type)
{
	this.mem[this.current] = value;
	ptr := this.mem[this.current];
	this.current = (this.current + 1) % Size;
	return ptr;
}