package Array

int32 DefaultResizeFunc(capacity: int32) => (capacity + 1) * 2;
int32 InvalidResizeFunc(capacity: int32)
{
	assert false, "Array:: Resize called on non resizable array"
	return 0;
}

IntroSortInsertionThreshold := 16;

uint32 Log2Floor(value: uint32)
{
	result := uint32(0);
	while (value > 1)
	{
		value = value / 2;
		result += 1;
	}
	return result;
}

state Array<Type, ResizeFunc = DefaultResizeFunc>
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

Array::Free()
{
	this.mem.Dealloc(this.count);
}

[]Type Array::log()
{
	return this.AsBuiltin();
}

[]Type Array::AsBuiltin()
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

*Type Array::Last()
{
	if (!this.count) return null;
	return this[this.count - 1]@;
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
	while (capacity < size) capacity = ResizeFunc(capacity);
	this.SizeTo(capacity);
}

Array::SizeTo(capacity: uint32)
{
	this.mem.Resize(capacity, this.capacity)
	this.capacity = capacity;
}

Array::Clear()
{
	this.count = 0;
}

Array<Type> Array::Copy(valCopy: ::Type(Type) = ::Type(val: Type) => val)
{
	arr := Array<Type>();
	arr.SizeTo(this.count);
	for (val in this)
	{
		arr.Add(valCopy(val));
	}
	return arr;
}

Array::Sort(compare: ::byte(Type, Type))
{
	depthLimit := Log2Floor(this.count) * 2;
	this.IntroSort(0, this.count, depthLimit, compare);
}

Array::QuickSort(low: uint32, high: uint32, compare: ::byte(Type, Type))
{
	if (high - low < 2) return;

	pivot := this[high - 1];
	i := low;

	for (j := low .. high - 1)
	{
		if (compare(this[j], pivot) < 0)
		{
			this.Swap(i, j);
			i += 1;
		}
	}
	this.Swap(i, high - 1);

	this.QuickSort(low, i, compare);
	this.QuickSort(i + 1, high, compare);
}

Array::IntroSort(low: uint32, high: uint32, depthLimit: uint32, compare: ::byte(Type, Type))
{
	if (high - low < 2) return;

	if (high - low <= IntroSortInsertionThreshold)
	{
		this.InsertionSort(low, high, compare);
		return;
	}

	if (depthLimit == 0)
	{
		this.HeapSort(low, high, compare);
		return;
	}

	pivot := this[high - 1];
	i := low;

	for (j := low .. high - 1)
	{
		if (compare(this[j], pivot) < 0)
		{
			this.Swap(i, j);
			i += 1;
		}
	}
	this.Swap(i, high - 1);

	this.IntroSort(low, i, depthLimit - 1, compare);
	this.IntroSort(i + 1, high, depthLimit - 1, compare);
}

Array::InsertionSort(low: uint32, high: uint32, compare: ::byte(Type, Type))
{
	for (i := low + 1 .. high)
	{
		val := this[i];
		j := i;
		while (j > low && compare(this[j - 1], val) > 0)
		{
			this[j] = this[j - 1];
			j -= 1;
		}
		this[j] = val;
	}
}

Array::HeapSort(low: uint32, high: uint32, compare: ::byte(Type, Type))
{
	n := high - low;

	i := n / 2;
	while (i > 0)
	{
		i -= 1;
		this.SiftDown(low, i, n, compare);
	}

	end := n;
	while (end > 1)
	{
		end -= 1;
		this.Swap(low, low + end);
		this.SiftDown(low, 0, end, compare);
	}
}

Array::SiftDown(low: uint32, start: uint32, n: uint32, compare: ::byte(Type, Type))
{
	root := start;
	while (root * 2 + 1 < n)
	{
		child := root * 2 + 1;
		if (child + 1 < n && compare(this[low + child], this[low + child + 1]) < 0) child += 1;

		if (compare(this[low + root], this[low + child]) < 0)
		{
			this.Swap(low + root, low + child);
			root = child;
		}
		else
		{
			return;
		}
	}
}

Array::Swap(left: uint32, right: uint32)
{
	temp := this[left]~;
	this[left] = this[right];
	this[right] = temp;
}

uint32 Array::SortedInsert(item: Type, compare: ::byte(Type, Type))
{
	if (this.count && compare(this[this.count - 1], item) <= 0)
	{
		return this.Add(item);
	}

	low := uint32(0);
	high := this.count;
	while (low < high)
	{
		mid := low + (high - low) / 2;
		if (compare(this[mid], item) > 0) high = mid;
		else low = mid + 1;
	}

	if (this.count >= this.capacity) this.Expand();

	i := this.count;
	while (i > low)
	{
		this[i] = this[i - 1];
		i -= 1;
	}

	this[low] = item;
	this.count += 1;
	return low;
}