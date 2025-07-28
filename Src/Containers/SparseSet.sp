package SparseSet

import ArrayView

int32 DefaultResizeFactor(capacity: int32) => (capacity + 1) * 2;

state SparseSet<Value, InitialCapacity = 16, InitialSparseCapacity = 32, ResizeFactor = DefaultResizeFactor>
{
	count: uint32,
	capacity: uint32,
	sparseCapacity: uint32,

	sparseArr: ZeroedAllocator<uint32>,
	denseKeyArr: ZeroedAllocator<uint32>,
	denseValueArr: Allocator<Value>
}

SparseSet::()
{
	this.sparseArr.Alloc(InitialSparseCapacity);
	this.denseKeyArr.Alloc(InitialCapacity);
	this.denseValueArr.Alloc(InitialCapacity);

	this.count = 0;
	this.capacity = InitialCapacity;
	this.sparseCapacity = InitialSparseCapacity;
}

SparseSet::delete 
{
	this.sparseArr.Dealloc(this.sparseCapacity);
	this.denseKeyArr.Dealloc(this.capacity);
	this.denseValueArr.Dealloc(this.capacity);
}

[]{key: uint32, value: *Value} SparseSet::log()
{
	arr := []{key: uint32, value: *Value};

	for (i .. this.count)
	{
		key := this.denseKeyArr[i]~;
		value := this.denseValueArr[i];
		arr.Add({ key, value });
	}

	return arr;
}

Iterator SparseSet::operator::in()
{
	return {null, -1};
}

bool SparseSet::next(it: Iterator)
{
	it.index += 1;
	return it.index < this.count;
}

{key: uint32, value: *Value} SparseSet::current(it: Iterator)
{
	index := it.index;
	key := this.denseKeyArr[index]~;
	value := this.denseValueArr[index];
	return {key, value};
}

ArrayView<Value> SparseSet::Values()
{
	return ArrayView<Value>(this.denseValueArr[0], this.count as uint);
}

SparseSet::ResizeSparse(amount: uint32)
{
	resizedCapacity := (((amount + (InitialSparseCapacity - 1)) / InitialSparseCapacity) * 
						InitialSparseCapacity) * 2;

	this.sparseArr.Resize(resizedCapacity, this.sparseCapacity);
	this.sparseCapacity = resizedCapacity;
}

SparseSet::ResizeDense()
{
	resizedCapacity := ResizeFactor(this.capacity);

	this.denseKeyArr.Resize(resizedCapacity, this.capacity);
	this.denseValueArr.Resize(resizedCapacity, this.capacity);
	this.capacity = resizedCapacity;
}

SparseSet::Insert(key: uint32, value: Value)
{
	if (key >= this.sparseCapacity) this.ResizeSparse(key);
	if (this.count >= this.capacity) this.ResizeDense();

	this.denseKeyArr[this.count]~ = key;
	this.denseValueArr[this.count]~ = value;

	this.count += 1;
	this.sparseArr[key]~ = this.count;
}

*Value SparseSet::Emplace(key: uint32)
{
	this.Insert(key, Value());
	return this.Get(key);
}

bool SparseSet::Has(key: uint32)
{
	if (key >= this.sparseCapacity) return false;
	return this.sparseArr[key]~ != 0;
}

uint32 SparseSet::GetIndex(key: uint32)
{
	if (key >= this.sparseCapacity) return uint32(0);
	index := this.sparseArr[key]~;
	return index;
}

*Value SparseSet::Get(key: uint32)
{
	index := this.GetIndex(key);
	if (!index) return null;
	index -= 1;

	return this.denseValueArr[index];
}

SparseSet::Remove(key: uint32)
{
	index := this.GetIndex(key);
	if (!index) return;
	index -= 1;

	this.sparseArr[key]~ = 0;

	this.count -= 1;
	if (!this.count) return;
	
	endKey := this.denseKeyArr[this.count]~;
	endValue := this.denseValueArr[this.count]~;

	this.denseKeyArr[index]~ = endKey;
	this.denseValueArr[index]~ = endValue;
	this.sparseArr[endKey]~ = index + 1;
}

SparseSet::Clear()
{
	this.count = 0;
	zero_out_bytes(this.sparseArr[0], this.sparseCapacity);
}
