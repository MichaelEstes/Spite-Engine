package HandleSet

import ArrayView
import BitSet

int32 DefaultResizeFactor(capacity: int32) => (capacity + 1) * 2;

state HandleValue<Value>
{
	handle: uint32,
	value: *Value
}

state HandleSet<Value, InitialCapacity = 16, ResizeFactor = DefaultResizeFactor>
{
	next: uint32,
	capacity: uint32,

	handleFlags: BitSet,
	denseValueArr: Allocator<Value>
}

HandleSet::()
{
	this.handleFlags = BitSet(InitialCapacity);
	this.denseValueArr.Alloc(InitialCapacity);

	this.next = 0;
	this.capacity = InitialCapacity;
}

HandleSet::delete 
{
	delete this.handleFlags;
	this.denseValueArr.Dealloc(this.capacity);
}

HandleSet::Expand()
{
	resizedCapacity := ResizeFactor(this.capacity);

	this.handleArr.Resize(resizedCapacity);
	this.denseValueArr.Resize(resizedCapacity, this.capacity);
	this.capacity = resizedCapacity;
}

HandleValue HandleSet::GetNext()
{
	if (this.next >= this.capacity) this.Expand();

	index := this.next;
	this.handleFlags.Set(index);

	handleValue := HandleValue<Value>();
	handleValue.handle = index;
	handleValue.value = this.denseValueArr[index];
	
	this.next += 1;
	while (this.handleFlags[this.next] && this.next < this.capacity) this.next += 1;
	return handleValue;
}

bool HandleSet::Has(key: uint32)
{
	if (key >= this.capacity) return false;
	return this.handleFlags[key];
}

HandleSet::Remove(key: uint32)
{
	if (key > this.capacity) return;
	
	if (key < this.next) this.next = key;
	this.handleFlags.Clear(key);
}
