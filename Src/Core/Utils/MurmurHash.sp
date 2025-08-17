package MurmurHash

uint MHash<Type>(value: Type, seed: uint = 0x9747B28C)
{
	c1 := 0xCC9E2D51;
    c2 := 0x1B873593;
    r1 := 15;
    r2 := 13;
    m  := 5;
    n  := 0xE6546B64;

	hash := seed;

	size := #sizeof Type;
	start := value@ as *ubyte;
	index := 0;

	while (index + 4 <= size)
	{
		val := (start[index] as *uint32)~;

		val *= c1;
		val = (val << r1);
		val *= c2;

		hash = hash ^ val;
		hash = hash << r2;
		hash = (hash * m) + n;

		index += 4;
	}

	rem := uint32(0);
	while (index < size)
	{
		rem = rem << 8;
		rem = rem | start[index]~;

		index += 1;
	}
	rem *= c1;
	rem = (rem << r1);
	rem *= c2;
	hash = hash ^ rem;

	hash = hash ^ size;
	hash = hash ^ (hash >> 16);
	hash *= 0x85EbCA6B;
	hash = hash ^ (hash >> 13);
	hash *= 0xC2B2AE35;
	hash = hash ^ (hash >> 16);

	return hash;
}