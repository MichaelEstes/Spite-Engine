package HandleSet

import ArrayView
import BitSet

int32 DefaultResizeFactor(capacity: int32) => (capacity + 1) * 2;

InvalidHandle := uint32(0);

state HandleValue<Value>
{
	handle: uint32,
	value: *Value
}

state HandleSet<Value, StartAt = 1, InitialCapacity = 16, ResizeFactor = DefaultResizeFactor>
{
	handleFlags: BitSet,
	denseValueArr: Allocator<Value>,

	next: uint32,
	capacity: uint32
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

*Value HandleSet::operator::[](handle: uint32)
{
	index := handle - StartAt;
	if (index >= this.capacity) return null;
	return this.denseValueArr[index];
}

Iterator HandleSet::operator::in()
{
	return {null, -1};
}

bool HandleSet::next(it: Iterator)
{
	it.index += 1;
	while(it.index < this.capacity && !this.Has(it.index)) it.index += 1;
	return it.index < this.capacity;
}

HandleValue<Value> HandleSet::current(it: Iterator)
{
	handle := (it.index - StartAt) as uint32;
	return {handle, this[it.index]} as HandleValue<Value>;
}

HandleSet::Expand()
{
	resizedCapacity := ResizeFactor(this.capacity);

	this.handleFlags.Resize(resizedCapacity);
	this.denseValueArr.Resize(resizedCapacity, this.capacity);
	this.capacity = resizedCapacity;
}

HandleValue<Value> HandleSet::GetNext()
{
	if (this.next >= this.capacity) this.Expand();

	index := this.next;
	this.handleFlags.Set(index);

	handleValue := HandleValue<Value>();
	handleValue.handle = index + StartAt;
	handleValue.value = this.denseValueArr[index];
	
	this.next += 1;
	while (this.next < this.capacity && this.handleFlags[this.next]) this.next += 1;
	return handleValue;
}

uint32 HandleSet::Emplace(val: Value)
{
	handleValue := this.GetNext();
	handleValue.value~ = val;
	return handleValue.handle;
}

bool HandleSet::Has(key: uint32)
{
	index := key - StartAt;
	if (index >= this.capacity) return false;
	return this.handleFlags[index];
}

*Value HandleSet::Get(key: uint32)
{
	return this[key];
}

HandleSet::Remove(key: uint32)
{
	index := key - StartAt;
	if (index > this.capacity) return;
	
	if (key < this.next) this.next = key;
	this.handleFlags.Clear(index);
}

HandleSet::Clear()
{
	this.next = 0;
	this.handleFlags.ClearAll();
}
