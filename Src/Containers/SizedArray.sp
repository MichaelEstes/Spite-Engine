package SizedArray

state SizedArray<Type, Capacity>
{
	count: uint,
	mem: [Capacity]Type
}

SizedArray::(value: Type)
{
	for (i .. Capacity) this[i] = value;
	this.count = Capacity;
}

ref Type SizedArray::operator::[](index: uint) => this.mem[index];

Iterator SizedArray::operator::in()
{
	return {null, -1};
}

bool SizedArray::next(it: Iterator)
{
	it.index += 1;
	return it.index < this.count;
}

ref Type SizedArray::current(it: Iterator)
{
	return this[it.index];	
}

uint32 SizedArray::Capacity() => Capacity;

uint32 SizedArray::Add(item: Type)
{
	if(this.count >= Capacity)
	{
		log "SizedArray::Add Array at capacity, not adding item";
		return this.count;
	}

	index := this.count;
	this.mem[index] = item;
	this.count += 1;
	return index;
}

SizedArray::Clear()
{
	this.count = 0;
}