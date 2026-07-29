package BitSet

import Atomic

bitsInByte := 8;
initialBytes := 8;

state BitSet
{
	bitCount: uint,
	mem: ?{
		alloc: ZeroedAllocator<byte>,
		bytes: [24]byte
	}
}

BitSet::()
{
	this = BitSet(initialBytes);
}

BitSet::(count: uint)
{
	byteCount := (count + bitsInByte - 1) / bitsInByte;

	this.bitCount = byteCount * bitsInByte;

	if (this.IsAllocated())
	{
		this.mem.alloc.Alloc(byteCount);
	}
	else
	{
		byteCount = #sizeof this.mem.bytes;
		this.bitCount = byteCount * bitsInByte;
		for (i .. byteCount)
		{
			this.mem.bytes[i] = byte(0);
		}
	}
}

BitSet::delete 
{
	if (this.IsAllocated())
	{
		this.mem.alloc.Dealloc(this.bitCount / bitsInByte);
	}
}

BitSet::Resize(count: uint)
{
	this.CheckResize(count);
}

bool BitSet::IsAllocated()
{
	return this.bitCount / bitsInByte > #sizeof this.mem.bytes;
}

*byte BitSet::GetIndex(index: uint)
{
	if (this.IsAllocated())
	{
		return this.mem.alloc[index];
	}

	return this.mem.bytes[index]@;
}

bool BitSet::operator::[](i: uint)  
{ 
	if(!this.Inbounds(i)) return false;
	index := i / bitsInByte;
	offset := i % bitsInByte;
	return (this.GetIndex(index)~ >> offset) & 1;
}

bool BitSet::Inbounds(i: uint)
{
	return i < this.bitCount;
}

BitSet::CheckResize(i: uint)
{
	if(!this.Inbounds(i))
	{
		amount := i / bitsInByte;
		resizedCapacity := (((amount + (initialBytes - 1)) / initialBytes) * initialBytes) * 2;
		if (this.IsAllocated())
		{
			this.mem.alloc.Resize(resizedCapacity, this.bitCount / bitsInByte);
		}
		else
		{
			this.mem.alloc.Alloc(resizedCapacity);
		}
		this.bitCount = resizedCapacity * bitsInByte;
	}
}

BitSet::Set(i: uint)
{
	this.CheckResize(i);
	index := i / bitsInByte;
	offset := i % bitsInByte;
	this.GetIndex(index)~ = this.GetIndex(index)~ | (1 << offset);
}

BitSet::AtomicSet(i: uint)
{
	this.CheckResize(i);
	index := i / bitsInByte;
	offset := i % bitsInByte;
	mask := byte(1 << offset);
	atomicValue := this.GetIndex(index) as *Atomic<byte>;

	while (1)
	{
		expected := atomicValue.Load(MemoryOrder.Relaxed);
		value := expected | mask;

		if (expected == value)
		{
			return;
		}

		if (atomicValue.CompareExchange(expected@, value, MemoryOrder.Sequential, MemoryOrder.Relaxed))
		{
			return;
		}
	}
}

BitSet::Clear(i: uint)
{
	if(!this.Inbounds(i)) return;
	index := i / bitsInByte;
	offset := i % bitsInByte;
	this.GetIndex(index)~ = this.GetIndex(index)~ &^ (1 << offset);
}

BitSet::AtomicClear(i: uint)
{
	if(!this.Inbounds(i)) return;
	index := i / bitsInByte;
	offset := i % bitsInByte;
	mask := byte(1 << offset);
	atomicValue := this.GetIndex(index) as *Atomic<byte>;

	while (1)
	{
		expected := atomicValue.Load(MemoryOrder.Relaxed);
		value := expected &^ mask;

		if (expected == value)
		{
			return;
		}

		if (atomicValue.CompareExchange(expected@, value, MemoryOrder.Sequential, MemoryOrder.Relaxed))
		{
			return;
		}
	}
}

BitSet::Toggle(i: uint)
{
	this.CheckResize(i);
	index := i / bitsInByte;
	offset := i % bitsInByte;
	this.GetIndex(index)~ = this.GetIndex(index)~ ^ (1 << offset);
}

BitSet::AtomicToggle(i: uint)
{
	this.CheckResize(i);
	index := i / bitsInByte;
	offset := i % bitsInByte;
	atomicValue := this.GetIndex(index) as *Atomic<byte>;
	atomicValue.XOr(1 << offset);
}

BitSet BitSet::Clone()
{
	cloned := BitSet(this.bitCount);
	byteCount := this.bitCount / bitsInByte;
	copy_bytes(cloned.GetIndex(0), this.GetIndex(0), byteCount);

	return cloned;
}

BitSet::ClearAll()
{
	byteCount := this.bitCount / bitsInByte;
	zero_out_bytes(this.GetIndex(0), byteCount);
}

uint BitSet::SetBitsCount()
{
	count := uint(0);
	byteCount := this.bitCount / bitsInByte;
	for (i .. byteCount)
	{
		value := this.GetIndex(i)~;
		while (value != byte(0))
		{
			value = value & (value - byte(1));
			count = count + 1;
		}
	}

	return count;
}
