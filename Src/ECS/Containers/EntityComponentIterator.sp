package ECS

bool _NextArray<Type>(ecIt: EntityComponentIterator<Type>, it: Iterator) => ecIt.container.array.next(it);

bool _NextMap<Type>(ecIt: EntityComponentIterator<Type>, it: Iterator) => ecIt.container.map.next(it);

EntityComponent<Type> _CurrentArray<Type>(ecIt: EntityComponentIterator<Type>, it: Iterator) => ecIt.container.array.current(it);

EntityComponent<Type> _CurrentMap<Type>(ecIt: EntityComponentIterator<Type>, it: Iterator) => ecIt.container.map.current(it);

state EntityComponentIterator<Type>
{
	container: ?{array: *EntityComponentArray<Type>, map: *EntityComponentMap<Type>},
	nextFunc: ::bool(EntityComponentIterator<Type>, Iterator) = :: bool(ecIt: EntityComponentIterator<Type>, it: Iterator) => false,
	currentFunc: ::EntityComponent<Type>(EntityComponentIterator<Type>, Iterator),
}

EntityComponentIterator::(componentKind: ComponentKind, container: ?{array: *EntityComponentArray<Type>, map: *EntityComponentMap<Type>})
{
	this.container = container;
	switch (componentKind)
	{
		case (ComponentKind.Common)
		{
			this.nextFunc = _NextArray<Type>;
			this.currentFunc = _CurrentArray<Type>;
		}
		case (ComponentKind.Sparse)
		{
			this.nextFunc = _NextMap<Type>;
			this.currentFunc = _CurrentMap<Type>;
		}
	}
}

Iterator EntityComponentIterator::operator::in()
{
	return {null, -1};
}

bool EntityComponentIterator::next(it: Iterator)
{
	return this.nextFunc(this, it);
}

EntityComponent<Type> EntityComponentIterator::current(it: Iterator)
{
	return this.currentFunc(this, it);
}