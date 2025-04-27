package Stack

state Stack<Type, InitialCapacity = 16>
{
	mem: Allocator<Type>
	count: uint32,
	capacity: uint32
}

Stack::()
{
	this.mem.Alloc(InitialCapacity);
	this.count = 0;
	this.capacity = InitialCapacity;
}

Stack::Push(value: Type)
{
	if(this.count >= this.capacity) this.Expand();	

	this.mem[this.count]~ = value;
	this.count += 1;
}

Type Stack::Pop()
{
	this.count -= 1;
	return this.mem[this.count]~;
}

Stack::Expand()
{
	this.SizeTo((this.capacity + 1) * 2);
}

Stack::ExpandAtLeastTo(size: uint)
{
	capacity := this.capacity;
	while (capacity < size) capacity = (capacity + 1) * 2;
	this.SizeTo(capacity);
}

Stack::SizeTo(capacity: uint)
{
	this.mem.Resize(capacity, this.capacity);
	this.capacity = capacity;
}