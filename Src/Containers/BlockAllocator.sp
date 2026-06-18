package BlockAllocator

import Array
import Queue

state Block
{
    mem: Allocator<byte>
}

state BlockAllocator
{
    blocks: Array<Block>,
    freeList := Queue<*void>(),

    current: *byte,

    blockSize: uint32,
    blockItemSize: uint32
}

BlockAllocator::(blockSize: uint32, blockItemSize: uint32)
{
    if (blockItemSize)
    {
        this.blockItemSize = align_up(blockItemSize, #sizeof int);
        this.blockSize = blockSize;
        if (blockSize % this.blockItemSize)
        {
            this.blockSize = blockSize + (this.blockItemSize - blockSize % this.blockItemSize);
        }

        this.AllocBlock();
    }
}

BlockAllocator::delete
{
    for (block in this.blocks)
    {
        block.mem.Dealloc(this.blockSize);
    }
    delete this.blocks;
    delete this.freeList;
}

BlockAllocator::AllocBlock()
{
    block := Block();
    block.mem.Alloc(this.blockSize);
    this.blocks.Add(block);
    this.current = block.mem.ptr;
}

Block BlockAllocator::GetCurrentBlock() => 
{
    return this.blocks[this.blocks.count - 1];
}

*byte BlockAllocator::CurrentBlockEnd() =>
{
    return this.GetCurrentBlock().mem.ptr + this.blockSize;
}

*void BlockAllocator::Alloc()
{
    if (!this.blockItemSize) return null;

    if (this.freeList.count)
    {
        return this.freeList.Dequeue();
    }

    if ((this.CurrentBlockEnd() - this.current) < this.blockItemSize)
    {
        this.AllocBlock();
    }

    next := this.current;
    this.current += this.blockItemSize;

    return next;
}

BlockAllocator::Free(blockItem: *void)
{
    if (!blockItem) return;
    
    this.freeList.Enqueue(blockItem)
}
