package FixedArray

state FixedArray<Type>
{
	mem: Allocator<Type>,
	count: uint
}

FixedArray::(count: uint)
{
	this.mem.Alloc(count);
	this.count = count;
}

FixedArray::(count: uint, value: Type)
{
	this.mem.Alloc(count);
	this.count = count;
	for (i .. count) this[i]~ = value;
}

FixedArray::delete 
{
	this.mem.Dealloc(this.count);
}

*Type FixedArray::operator::[](index: uint) => this.mem[index];