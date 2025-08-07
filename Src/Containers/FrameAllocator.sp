package FrameAllocator

state FrameAllocator
{
	mem: Allocator<*byte>,

	blockSize: uint32 = 0x1000,
	blockCount: uint32,

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
	
	block := this.mem[this.currBlock];
	ptr := block + this.currIndex;
	this.currIndex += size;
	return ptr;
}

*Type FrameAllocator::AllocType<Type>()
{
	size := #sizeof Type;
	if (this.currIndex + size > this.blockSize) this.NextOrExpand();
	
	block := this.mem[this.currBlock];
	ptr := block + this.currIndex;
	this.currIndex += size;
	return ptr as *Type;
}

FrameAllocator::NextOrExpand()
{
	if (this.currBlock < this.blockCount - 1)
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

	prevCount := this.blockCount;
	this.blockCount += 1;
	this.mem.Resize(this.blockCount, prevCount);
	this.mem[prevCount]~ = blockPtr;

	this.currBlock = prevCount;
	this.currIndex = 0;
}

FrameAllocator::Clear()
{
	this.currBlock = 0;
	this.currIndex = 0;
}