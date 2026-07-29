package FrameAllocator

import Array

state FrameAllocator
{
	blocks: Array<*byte>,

	blockSize: uint32 = 0x1000,

	currBlock: uint32,
	currIndex: uint32
}

FrameAllocator::()
{
	this.Expand();
}

FrameAllocator::(blockSize: uint32)
{
	this.blockSize = blockSize;
	this.Expand();
}

*void FrameAllocator::Alloc(size: uint32)
{
	if (this.currIndex + size > this.blockSize) this.NextOrExpand();
	
	block := this.blocks[this.currBlock];
	ptr := block + this.currIndex;
	this.currIndex += size;
	return ptr;
}

*Type FrameAllocator::AllocType<Type>()
{
	size := #sizeof Type;
	return this.Alloc(size) as *Type;
}

Array<Type, InvalidResizeFunc> FrameAllocator::AllocArray<Type>(count: uint32)
{
	itemSize := #sizeof Type;
	totalSize := itemSize * count;
	ptr := this.Alloc(totalSize);

	arr := Array<Type, InvalidResizeFunc>();
	arr.count = 0;
	arr.capacity = count;
	arr.mem.ptr = ptr;
	return arr;
}

FrameAllocator::NextOrExpand()
{
	if (this.currBlock < this.blocks.count - 1)
	{
		this.currBlock += 1;
		this.currIndex = 0;
	}
	else
	{
		this.Expand();
	}
}

FrameAllocator::Expand()
{
	blockPtr := Allocator<byte>().Alloc(this.blockSize)[0];

	this.currBlock = this.blocks.Add(blockPtr);
	this.currIndex = 0;
}

FrameAllocator::Clear()
{
	this.currBlock = 0;
	this.currIndex = 0;
}