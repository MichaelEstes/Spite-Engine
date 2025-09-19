package ECS

import BitSet

state EntityComponentArray<Type, InitialCapacity = 1024>
{
	capacity: uint32,

	entitySet: BitSet,
	componentArr: Allocator<Type>
}

EntityComponentArray::()
{
	this.entitySet = BitSet(InitialCapacity);
	this.componentArr.Alloc(InitialCapacity);
	this.capacity = InitialCapacity;
}

EntityComponentArray::delete
{
	delete this.entitySet;
	this.componentArr.Dealloc(this.capacity);
}

[]EntityComponent<Type> EntityComponentArray::log()
{
	arr := []EntityComponent<Type>;

	for (i .. this.capacity)
	{
		if (this.entitySet[i])
		{
			entity := Entity(i);
			component := this.componentArr[i];
			arr.Add({ entity, component });
		}
	}

	return arr;
}

Iterator EntityComponentArray::operator::in()
{
	return {null, -1};
}

bool EntityComponentArray::next(it: Iterator)
{
	it.index += 1;
	while (it.index < this.capacity && !this.entitySet[it.index]) it.index += 1;
	return it.index < this.capacity;
}

EntityComponent<Type> EntityComponentArray::current(it: Iterator)
{
	index := it.index;
	entity := Entity(index);
	component := this.componentArr[index];
	return {entity, component} as EntityComponent<Type>;
}

EntityComponentArray::Resize(amount: uint32)
{
	resizedCapacity := (((amount + (InitialCapacity - 1)) / InitialCapacity) * 
						InitialCapacity) * 2;

	this.componentArr.Resize(resizedCapacity, this.capacity);
	this.capacity = resizedCapacity;
}

EntityComponentArray::Insert(entity: Entity, component: Type)
{
	assert !!entity, "Cannot insert null entity";

	if (entity.id >= this.capacity) this.Resize(entity.id);

	index := entity.id;
	this.entitySet.Set(index);
	this.componentArr[index]~ = component;
}

bool EntityComponentArray::Has(entity: Entity)
{
	return this.entitySet[entity.id];
}

*Component EntityComponentArray::Get(entity: Entity)
{
	if (!this.Has(entity)) return null;

	index := entity.id;
	return this.componentArr[index];
}

*any EntityComponentArray::GetUntyped(entity: Entity, size: uint32)
{
	if (!this.Has(entity)) return null;

	index := entity.id;
	byteArr := this.componentArr.ptr as *byte;
	return byteArr[index * size];
}

EntityComponentArray::Remove(entity: Entity)
{
	if (!this.Has(entity)) return;

	index := entity.id;
	this.entitySet.Clear(index);
}