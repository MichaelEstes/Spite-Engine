package Optional

state Optional<Type>
{
	value: Type,
	has: bool
}

ref Type Optional::Get()
{
	if (!this.has) return null;
	return this.value;
}

Optional::Set(value: Type)
{
	this.value = value;
	this.has = true;
}