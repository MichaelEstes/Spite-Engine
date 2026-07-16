package FixedRingBuffer

state FixedRingBuffer<Type, Size = 64>
{
	mem: [Size]Type,
	next: uint32,
	size: uint32
}

FixedRingBuffer::Init(value: Type)
{
	for (i .. Size)
	{
		this.mem[i] = value;
	}
}

FixedRingBuffer::Insert(value: Type)
{
	this.mem[this.next] = value;
	this.next = (this.next + 1) % Size;
	if (this.size < Size) this.size += 1;
}

ref Type FixedRingBuffer::operator::[](index: uint) => 
{
	offsetIndex := ((this.next - 1) - index) % Size;
	return this.mem[offsetIndex];
}

Iterator FixedRingBuffer::operator::in()
{
	return {null, (this.next as int) - 1};
}

bool FixedRingBuffer::next(it: Iterator)
{
	it.index = (it.index - 1) % Size;
	return it.index < this.size;
}

ref Type FixedRingBuffer::current(it: Iterator)
{
	return this[it.index];	
}