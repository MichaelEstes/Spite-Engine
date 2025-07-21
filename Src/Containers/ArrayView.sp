package ArrayView

state ArrayView<Type>
{
	start: *Type,
	count: uint
}

ArrayView::(start: *Type, count: uint)
{
	this.start = start;
	this.count = count;
}

ArrayView::(arr: []Type)
{
	this.start = arr[0]@;
	this.count = arr.count;
}

ref Type ArrayView::operator::[](index: uint32)
{
	return this.start[index]~;
}

Iterator ArrayView::operator::in()
{
	return {null, -1};
}

bool ArrayView::next(it: Iterator)
{
	it.index += 1;
	return it.index < this.count;
}

ref Type ArrayView::current(it: Iterator)
{
	return this.start[it.index]~;
}