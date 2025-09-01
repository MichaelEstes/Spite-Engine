package BitArray

import ArrayUtils

bitsInByte := 8;

state BitArray<NumBits = 64>
{
	mem := [(((bitsInByte - NumBits % bitsInByte) + NumBits) / bitsInByte) - 1]ubyte(),
}

Type BitArray::Range<Type>(from: uint32, to: uint32)
{
	val := Type();
	valPtr := val@ as *ubyte;
	
	bitCount := to - from + 1;

	for (i .. bitCount)
	{
		bitIndex := from + i;
		byteIndex := bitIndex / bitsInByte;
		bitOffset := bitIndex % bitsInByte;

		bitVal := (this.mem[byteIndex] >> bitOffset) & 1;

		valByteIndex := i / 8;
		valBitOffset := i % 8;
		(valPtr + valByteIndex)~ |= (bitVal << valBitOffset);
	}

	return val;
}

BitArray::SetRange<Type>(from: uint32, to: uint32, val: Type)
{
	valPtr := val@ as *ubyte;
	
	bitCount := to - from + 1;

	for (i .. bitCount)
	{
		bitIndex := from + i;
		byteIndex := bitIndex / bitsInByte;
		bitOffset := bitIndex % bitsInByte;

		valByteIndex := i / 8;
		valBitOffset := i % 8;
		bitVal := ((valPtr + valByteIndex)~ >> valBitOffset) & 1;

		this.mem[byteIndex] = this.mem[byteIndex] &^ (1 << bitOffset);
		this.mem[byteIndex] |= (bitVal << bitOffset);
	}
}