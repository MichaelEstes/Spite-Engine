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

FixedArray::(from: []Type)
{
	this.mem = from[0]@ as Allocator<Type>;
	this.count = from.count;
}

FixedArray::delete 
{
	this.mem.Dealloc(this.count);
}

*Type FixedArray::operator::[](index: uint) => this.mem[index];

Iterator FixedArray::operator::in()
{
	return {null, -1};
}

bool FixedArray::next(it: Iterator)
{
	it.index += 1;
	return it.index < this.count;
}

ref Type FixedArray::current(it: Iterator)
{
	return this[it.index];	
}