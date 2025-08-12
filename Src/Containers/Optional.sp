package Optional

state Optional<Type>
{
	value: Type,
	has: bool
}

*Value Optional::Get()
{
	if (this.has) return this.value@;

	return null;
}

Optional::Set(value: Type)
{
	this.value = value;
	this.has = true;
}