package FrameAllocator

import Array
import Math

DefaultBlockSize: uint32 = 4096 * 4;

state FrameBlock
{
	mem: *byte,

	curr: uint32,
	size: uint32
}

FrameBlock::(size: uint32)
{
	this.mem = Allocator<byte>().Alloc(size)[0];
	this.curr = 0;
	this.size = size;
}

state FrameAllocator
{
	blocks: Array<FrameBlock>
}

FrameAllocator::()
{
	this.Expand(DefaultBlockSize);
}

FrameAllocator::(blockSize: uint32)
{
	this.Expand(blockSize);
}

*void FrameAllocator::Alloc(size: uint32)
{
	for (i .. this.blocks.count)
	{
		block := this.blocks[i]@;
		if (block.curr + size <= block.size)
		{
			ptr := block.mem + block.curr;
			block.curr += size;
			return ptr;
		}
	}

	block := this.Expand(Math.Max(size, DefaultBlockSize));
	ptr := block.mem;
	block.curr = size;
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

*FrameBlock FrameAllocator::Expand(size: uint32)
{
	index := this.blocks.Add(FrameBlock(size));
	return this.blocks[index]@;
}

FrameAllocator::Clear()
{
	for (i .. this.blocks.count)
	{
		block := this.blocks[i]@;
		block.curr = 0;
	}
}