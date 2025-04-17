package Array

state Array<Type>
{
	mem: Allocator<Type>,
	count: uint32,
	capacity: uint32
}

Array::(initialCapacity: uint32)
{
	this.mem.Alloc(initialCapacity);
	this.capacity = initialCapacity;
}

Array::delete 
{
	this.mem.Dealloc(this.count);
}

*Type Array::operator::[](index: uint32)
{
	return this.mem[index];
}

Iterator Array::operator::in()
{
	return {null, -1};
}

bool Array::next(it: Iterator)
{
	it.index += 1;
	return it.index < this.count;
}

ref Type Array::current(it: Iterator)
{
	return this.mem[it.index];	
}

// Returns the index of the item added
int Array::Add(item: Type)
{
	if(this.count >= this.capacity) this.Expand();	

	index := this.count;
	this.mem[index]~ = item;
	this.count += 1;
	return index;
}

Array::Expand()
{
	this.SizeTo((this.capacity + 1) * 2);
}

Array::SizeTo(capacity: uint32)
{
	this.mem.Resize(capacity, this.capacity)
	this.capacity = capacity;
}