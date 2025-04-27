package Arena

DeleteItem<Type>(value: *void)
{
	delete (value as *Type)~;
}

state DeleteContainer
{
	value: *void,
	deleteFunc: ::(*void)
}

state Allocated
{
	alloc: Allocator<byte>,
	end: *void
}

Allocated::(size: uint)
{
	this.alloc.Alloc(size);
	this.end = this.alloc.ptr + size;
}

state Arena
{
	next: *byte,
	curr: Allocated,
	prev: []Allocated,
	toDelete: []DeleteContainer,
	allocatedSize: uint = 0x1000
}

Arena::()
{
	this.CreateCurr();
}

Arena::(size: uint)
{
	this.allocatedSize = size;
	this.CreateCurr();
}

Arena::delete 
{
	this.curr.alloc.Dealloc(this.allocatedSize);
	for (allocated in this.prev) allocated.alloc.Dealloc(this.allocatedSize);
	for (deleteContainer in this.toDelete)
	{
		deleteContainer.deleteFunc(deleteContainer.value);
	}
}

Arena::CreateCurr()
{
	this.curr = Allocated(this.allocatedSize);
	this.next = this.curr.alloc.ptr;
}

Arena::Expand()
{
	this.prev.Add(this.curr);
	this.CreateCurr();
}

*Type Arena::Insert<Type>(value: Type)
{
	size := #sizeof Type;
	if (this.next + size > this.curr.end) this.Expand();

	ptr := this.next as *Type;
	ptr~ = value;
	this.next = this.next + size;
	return ptr;
}

*Type Arena::InsertContainer<Type>(value: Type)
{
	ptr := this.Insert<Type>(value);
	deleteFunc := DeleteItem<Type>;
	this.toDelete.Add({value, deleteFunc});
	return ptr;
}

*Type Arena::Emplace<Type>()
{
	return this.Insert<Type>(Type());
}

