package ECS

state EntityTagComponentIterator
{
	container: ?{bitSet: *BitSet, entitySet: *EntitySet},
	kind: ComponentKind
}

EntityTagComponentIterator::(componentKind: ComponentKind, 
							 container: ?{bitSet: *BitSet, entitySet: *EntitySet})
{
	this.container = container;
	this.kind = componentKind;
}

Iterator EntityTagComponentIterator::operator::in()
{
	return {null, -1};
}

bool EntityTagComponentIterator::next(it: Iterator)
{
	switch (this.kind)
	{
		case (ComponentKind.Common)
		{
			it.index += 1;
			bitSet := this.container.bitSet~;
			while (it.index < bitSet.bitCount && !bitSet[it.index]) it.index += 1;
			return it.index < bitSet.bitCount;
		}
		case (ComponentKind.Sparse)
		{
			return this.container.entitySet.next(it);
		}
	}

	return false;
}

Entity EntityTagComponentIterator::current(it: Iterator)
{
	switch (this.kind)
	{
		case (ComponentKind.Common)
		{
			return Entity(it.index);
		}
		case (ComponentKind.Sparse)
		{
			return this.container.entitySet.current(it);
		}
	}

	return NullEntity;
}