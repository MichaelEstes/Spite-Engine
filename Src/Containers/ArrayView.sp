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