package UntypedHandleSet

import HandleSet
import BitSet

state UntypedHandleSet
{
	handleFlags: BitSet,
	denseValueArr: Allocator<byte>,

	itemSize: uint32,
	startAt: uint32,
	next: uint32,
	capacity: uint32
}

UntypedHandleSet::(itemSize: uint32, startAt: uint32 = 1, initialCapacity: uint32 = 16)
{
	this.handleFlags = BitSet(initialCapacity);
	this.denseValueArr.Alloc(initialCapacity * itemSize);

	this.itemSize = itemSize;
	this.startAt = startAt;
	this.next = 0;
	this.capacity = initialCapacity;
}

UntypedHandleSet::delete
{
	delete this.handleFlags;
	this.denseValueArr.Dealloc(this.capacity * this.itemSize);
}

*any UntypedHandleSet::operator::[](handle: uint32)
{
	index := handle - this.startAt;
	if (index >= this.capacity) return null;
	return this.denseValueArr[index * this.itemSize];
}

Iterator UntypedHandleSet::operator::in()
{
	return {null, -1};
}

bool UntypedHandleSet::next(it: Iterator)
{
	it.index += 1;
	while(it.index < this.capacity && !this.handleFlags[it.index]) it.index += 1;
	return it.index < this.capacity;
}

HandleValue<any> UntypedHandleSet::current(it: Iterator)
{
	handle := (it.index + this.startAt) as uint32;
	return {handle, this.denseValueArr[it.index * this.itemSize]} as HandleValue<any>;
}

UntypedHandleSet::Expand()
{
	resizedCapacity := DefaultResizeFactor(this.capacity);

	this.handleFlags.Resize(resizedCapacity);
	this.denseValueArr.Resize(resizedCapacity * this.itemSize, this.capacity * this.itemSize);
	this.capacity = resizedCapacity;
}

HandleValue<any> UntypedHandleSet::GetNext()
{
	if (this.next >= this.capacity) this.Expand();

	index := this.next;
	this.handleFlags.Set(index);

	handleValue := HandleValue<any>();
	handleValue.handle = index + this.startAt;
	handleValue.value = this.denseValueArr[index * this.itemSize];

	this.next += 1;
	while (this.next < this.capacity && this.handleFlags[this.next]) this.next += 1;
	return handleValue;
}

uint32 UntypedHandleSet::Emplace(val: *any)
{
	handleValue := this.GetNext();
	copy_bytes(handleValue.value, val, this.itemSize);
	return handleValue.handle;
}

bool UntypedHandleSet::Has(key: uint32)
{
	index := key - this.startAt;
	if (index >= this.capacity) return false;
	return this.handleFlags[index];
}

*any UntypedHandleSet::Get(key: uint32)
{
	return this[key];
}

UntypedHandleSet::Remove(key: uint32)
{
	index := key - this.startAt;
	if (index >= this.capacity) return;

	if (index < this.next) this.next = index;
	this.handleFlags.Clear(index);
}

UntypedHandleSet::Clear()
{
	this.next = 0;
	this.handleFlags.ClearAll();
}
