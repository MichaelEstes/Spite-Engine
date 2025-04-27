package ValueIterator

state ValueIterator<Value>
{
	values: *Value,
	count: uint
}

Iterator ValueIterator::operator::in()
{
	return {null, -1};
}

bool ValueIterator::next(it: Iterator)
{
	it.index += 1;
	return it.index < this.count;
}

*Value ValueIterator::current(it: Iterator)
{
	return this.values[it.index];
}