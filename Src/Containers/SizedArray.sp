package SizedArray

state SizedArray<Type, Count>
{
	mem: [Count]Type
}

SizedArray::(value: Type)
{
	for (i .. Count) this[i] = value;
}

ref Type SizedArray::operator::[](index: uint) => this.mem[index];

Iterator SizedArray::operator::in()
{
	return {null, -1};
}

bool SizedArray::next(it: Iterator)
{
	it.index += 1;
	return it.index < Count;
}

ref Type SizedArray::current(it: Iterator)
{
	return this[it.index];	
}

uint SizedArray::Count() => Count;