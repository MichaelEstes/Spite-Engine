package FixedArray

state FixedArray<Type, Count>
{
	mem := Allocator<Type>.Alloc(Count)
}

uint32 FixedArray::Count() => Count;