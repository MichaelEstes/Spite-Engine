package AllocArray

state AllocArray<Type>
{
	mem: Allocator<Type>,
	count: uint,
}

AllocArray::(count: uint)
{
	this.mem.Alloc(count);
	this.count = count;
}

AllocArray::delete 
{
	this.mem.Dealloc(this.count);
}

*Type AllocArray::operator::[](index: uint)
{
	return this.mem[index];
}

AllocArray::SizeTo(capacity: uint)
{
	this.mem.Resize(capacity, this.count);
}