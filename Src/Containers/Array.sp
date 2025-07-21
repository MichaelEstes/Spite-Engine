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

Array::(arr: []Type)
{
	this.mem.Alloc(arr.count);
	this.capacity = arr.count;
	for (item in arr)
	{
		this.Add(item);
	}
}

Array::delete 
{
	for (item in this) delete item~;
	this.mem.Dealloc(this.count);
}

[]Type Array::log()
{
	return this.AsArray()
}

[]Type Array::AsArray()
{
	arr := []Type;
	arr.count = this.count;
	arr.capacity = this.capacity;
	arr.memory = this.mem;
	return arr;
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
uint32 Array::Add(item: Type)
{
	if(this.count >= this.capacity) this.Expand();	

	index := this.count;
	this.mem[index]~ = item;
	this.count += 1;
	return index;
}

Array::AddAll(items: []Type)
{
	newCount := this.count + items.count;
	if(newCount >= this.capacity) this.ExpandAtLeastTo(newCount);

	for (i .. items.count) this[this.count + i] = items[i];
	this.count = newCount;
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
			this.count -= 1;
			return true;
		}
	}

	return false;
}

bool Array::RemoveAll(item: Type, equals: ::bool(Type, Type) = DefaultEqual<Type>)
{
    writeIndex := uint32(0);
    removed := false;
    
    for (i .. this.count)
    {
        if (!equals(this[i], item))
        {
            if (i != writeIndex)
            {
                this[writeIndex] = this[i];
            }
            writeIndex += 1;
        }
        else
        {
            removed = true;
        }
    }
    
    this.count = writeIndex;
    
    return removed;
}

bool Array::Has(item: Type, equals: ::bool(Type, Type) = DefaultEqual<Type>)
{
	for (i .. this.count)
	{
		arrItem := this[i];
		if (equals(arrItem, item)) return true;
	}

	return false;
}

Array::Expand()
{
	this.SizeTo((this.capacity + 1) * 2);
}

Array::ExpandAtLeastTo(size: uint32)
{
	capacity := this.capacity;
	while (capacity < size) capacity = (capacity + 1) * 2;
	this.SizeTo(capacity);
}

Array::SizeTo(capacity: uint32)
{
	this.mem.Resize(capacity, this.capacity)
	this.capacity = capacity;
}