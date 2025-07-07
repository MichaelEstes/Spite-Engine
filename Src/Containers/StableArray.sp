package StableArray

import Array

state StableArray<Type, BlockSize = 32>
{
	blocks: Array<*[BlockSize]Type>,
	index: uint32
}

StableArray::delete
{
	delete this.blocks;
}

uint StableArray::Add(item: Type)
{
	if (this.index >= BlockSize) this.AddBlock();
	
	blockIndex := this.blocks.count - 1
	currIndex := blockIndex * BlockSize + this.index;
	block := this.blocks[blockIndex]~;
	block[this.index] = item;
	this.index += 1;
}

StableArray::AddBlock()
{
	blockPtr := Allocator<[BlockSize]Type>().Alloc(1).ptr;
	this.blocks.Add(blockPtr);
	this.index = 0;
}

