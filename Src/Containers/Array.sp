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
	for (item in this) delete item;
	this.mem.Dealloc(this.count);
}

ref Type Array::operator::[](index: uint32)
{
	return this.mem[index]~;
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
	return this.mem[it.index]~;	
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

Array::Insert(item: Type, index: uint32)
{
	this[index] = item;
}

Array::Shift(index: uint32)
{
	while (index + 1 < this.count)
	{
		toShift := this[index + 1];
		this.Insert(toShift, index);
		index += 1;
	}
}

Array::ShiftRange(index: uint32, end: uint32)
{
	while (index + 1 < end)
	{
		toShift := this[index + 1];
		this.Insert(toShift, index);
		index += 1;
	}
}

bool Array::Remove(item: Type, equals: ::bool(Type, Type) = DefaultEqual<Type>)
{
	for (i .. this.count)
	{
		arrItem := this[i];
		if (equals(arrItem, item)) 
		{
			this.Shift(i);
			return true;
		}
	}

	return false;
}

bool Array::RemoveAll(item: Type, equals: ::bool(Type, Type) = DefaultEqual<Type>)
{
	removeIndicies := Array<uint32>();
	for (i .. this.count)
	{
		if (equals(arrItem, item)) 
		{
			removeIndicies.Add(i);
		}
	}

	if (removeIndicies.count > 0)
	{
		for (i .. removeIndicies.count - 1)
		{

		}
	}

	return removeIndicies.count > 0;
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