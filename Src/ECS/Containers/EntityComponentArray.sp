package ECS

state EntityComponentArray<Type, InitialCapacity = 1024>
{
	activeArr: ZeroedAllocator<bool>,
	componentArr: Allocator<Type>,

	capacity: uint32,
}

EntityComponentArray::()
{
	this.activeArr.Alloc(InitialCapacity);
	this.componentArr.Alloc(InitialCapacity);
	this.capacity = InitialCapacity;
}

EntityComponentArray::delete
{
	this.activeArr.Dealloc(this.capacity);
	this.componentArr.Dealloc(this.capacity);
}

[]EntityComponent<Type> EntityComponentArray::log()
{
	arr := []EntityComponent<Type>;

	for (i .. this.capacity)
	{
		if (this.activeArr[i]~)
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
	resizedCapacity := ((amount / InitialCapacity) + 1) * InitialCapacity;

	this.activeArr.Resize(resizedCapacity, this.capacity);
	this.componentArr.Resize(resizedCapacity, this.capacity);
	this.capacity = resizedCapacity;
}

*Type EntityComponentArray::Insert(entity: Entity, component: Type)
{
	assert !!entity, "Cannot insert null entity";

	if (entity.id >= this.capacity) this.Resize(entity.id);

	index := entity.id;
	activePtr := this.activeArr[index];
	activePtr~ = true;

	componentPtr := this.componentArr[index];
	componentPtr~ = component;
	return componentPtr;
}

bool EntityComponentArray::Has(entity: Entity)
{
	return entity.id < this.capacity && this.activeArr[entity.id]~;
}

*Component EntityComponentArray::Get(entity: Entity)
{
	if (!this.Has(entity)) return null;

	index := entity.id;
	return this.componentArr[index];
}

EntityComponentArray::Remove(entity: Entity)
{
	if (!this.Has(entity)) return;

	index := entity.id;
	this.activeArr[index]~ = false;
}

uint32 EntityComponentArray::Count() => this.capacity;

*any EntityComponentArray::GetUntyped(entity: Entity, size: uint32)
{
	if (!this.Has(entity)) return null;

	index := entity.id;
	byteArr := this.componentArr.ptr as *byte;
	return byteArr[index * size];
}

*any EntityComponentArray::SetUntyped(entity: Entity, data: *any, size: uint32)
{
	assert !!entity, "Cannot insert null entity";

	if (entity.id >= this.capacity) this.Resize(entity.id);

	index := entity.id;
	activePtr := this.activeArr[index];
	activePtr~ = true;
	
	byteArr := this.componentArr.ptr as *byte;
	dst := byteArr[index * size];
	copy_bytes(dst, data, size);
	return dst;
}
