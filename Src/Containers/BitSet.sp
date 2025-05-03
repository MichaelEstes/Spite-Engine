package BitSet

bitsInByte := 8;
initialBytes := 128;

state BitSet
{
	bitCount: uint,
	alloc: ZeroedAllocator<byte>
}

BitSet::()
{
	this.bitCount = initialBytes * bitsInByte;
	this.alloc.Alloc(initialBytes);
}

BitSet::(count: uint)
{
	byteCount := (((bitsInByte - count % bitsInByte) + count) / bitsInByte) - 1;
	this.bitCount = byteCount * bitsInByte;
	this.alloc.Alloc(byteCount);
}

BitSet::delete 
{
	this.alloc.Dealloc(this.bitCount / bitsInByte);
}

bool BitSet::operator::[](i: uint)  
{ 
	if(!this.Inbounds(i)) return false;
	index := i / bitsInByte;
	offset := i % bitsInByte;
	return (this.alloc[index]~ >> offset) & 1;
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
		resizedCapacity := (((amount + (initialBytes - 1)) / initialBytes) * 
						initialBytes) * 2;
		this.alloc.Resize(resizedCapacity, this.bitCount / bitsInByte);
		this.bitCount = resizedCapacity * bitsInByte;
	}
}

BitSet::Set(i: uint)
{
	this.CheckResize(i);
	index := i / bitsInByte;
	offset := i % bitsInByte;
	this.alloc[index]~ = this.alloc[index]~ | (1 << offset);
}

BitSet::Clear(i: uint)
{
	if(!this.Inbounds(i)) return;
	index := i / bitsInByte;
	offset := i % bitsInByte;
	this.alloc[index]~ = this.alloc[index]~ &^ (1 << offset);
}

BitSet::Toggle(i: uint)
{
	this.CheckResize(i);
	index := i / bitsInByte;
	offset := i % bitsInByte;
	this.alloc[index]~ = this.alloc[index]~ ^ (1 << offset);
}