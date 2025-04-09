package FixedArray

state FixedArray<Type, Count>
{
	mem := Allocator<Type>.Alloc(Count)
}

FixedArray::delete 
{
	this.mem.Dealloc(Count);
}

uint32 FixedArray::Count() => Count;

*Type FixedArray::operator::[](index: uint) => this.mem[index];