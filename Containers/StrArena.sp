package StrArena

state StrAllocated
{
	alloc: ZeroedAllocator<byte>,
	end: *void
}

StrAllocated::(size: uint)
{
	this.alloc.Alloc(size);
	this.end = this.alloc.ptr + size;
}

state StrArena
{
	next: *byte,
	curr: StrAllocated,
	prev: []StrAllocated,
	allocatedSize: uint = 0x1000
}

StrArena::()
{
	this.CreateCurr();
}

StrArena::(size: uint)
{
	this.allocatedSize = size;
	this.CreateCurr();
}

StrArena::delete 
{
	this.curr.alloc.Dealloc(this.allocatedSize);
	for (allocated in this.prev) allocated.alloc.Dealloc(this.allocatedSize);
}

StrArena::CreateCurr()
{
	this.curr = StrAllocated(this.allocatedSize);
	this.next = this.curr.alloc.ptr;
}

StrArena::Expand()
{
	this.prev.Add(this.curr);
	this.CreateCurr();
}

string StrArena::Get(count: uint)
{
	terminatedCount := count + 1;
	if (this.next + terminatedCount > this.curr.end) this.Expand();

	ptr := this.next as *byte;
	this.next = this.next + terminatedCount;
	(this.next - 1)~ = byte(0);
	return string(count, ptr);
}

string StrArena::Copy(str: string)
{
	copied := this.Get(str.count);
	copy_bytes(copied[0], str[0], str.count);
	return copied;
}