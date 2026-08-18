package ECS

state EntityComponentIterator<Type>
{
	container: ?{array: *EntityComponentArray<Type>, map: *EntityComponentMap<Type>},
	kind: ComponentKind
}

EntityComponentIterator::(componentKind: ComponentKind, container: ?{array: *EntityComponentArray<Type>, map: *EntityComponentMap<Type>})
{
	this.container = container;
	this.kind = componentKind;
}

Iterator EntityComponentIterator::operator::in()
{
	return {null, -1};
}

bool EntityComponentIterator::next(it: Iterator)
{
	switch (this.kind)
	{
		case (ComponentKind.Common)
		{
			return this.container.array.next(it);
		}
		case (ComponentKind.Sparse)
		{
			return this.container.map.next(it);
		}
	}

	return false;
}

EntityComponent<Type> EntityComponentIterator::current(it: Iterator)
{
	switch (this.kind)
	{
		case (ComponentKind.Common)
		{
			return this.container.array.current(it);
		}
		case (ComponentKind.Sparse)
		{
			return this.container.map.current(it);
		}
	}

	return EntityComponent<Type>();
}