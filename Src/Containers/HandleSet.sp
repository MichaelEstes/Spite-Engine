package HandleSet

import ArrayView

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

	handleFlags: ZeroedAllocator<uint32>,
	denseValueArr: Allocator<Value>
}

HandleSet::()
{
	this.handleArr.Alloc(InitialCapacity);
	this.denseValueArr.Alloc(InitialCapacity);

	this.next = 0;
	this.capacity = InitialCapacity;
}

HandleSet::delete 
{
	this.handleArr.Dealloc(this.capacity);
	this.denseValueArr.Dealloc(this.capacity);
}

HandleSet::Expand()
{
	resizedCapacity := ResizeFactor(this.capacity);

	this.handleArr.Resize(resizedCapacity, this.capacity);
	this.denseValueArr.Resize(resizedCapacity, this.capacity);
	this.capacity = resizedCapacity;
}

HandleValue HandleSet::GetNext()
{
	if (this.next >= this.capacity) this.Expand();

	index := this.next;
	handleArr[index]~ = index + 1;

	handleValue := HandleValue<Value>()
	handleValue.handle = index;
	handleValue.value = this.denseValueArr[index];
	
	this.next += 1;
	while (this.handleArr[next] && next < this.capacity) this.next += 1;
	return handleValue;
}

bool HandleSet::Has(key: uint32)
{
	if (key >= this.capacity) return false;
	return this.handleArr[key]~ != 0;
}

HandleSet::Remove(key: uint32)
{
	if (key >= this.capacity) return;
	
}
