package ECS

import Math

state EntityComponentArray<Type, InitialCapacity = 1024>
{
	activeArr: ZeroedAllocator<bool>,
	componentArr: Allocator<Type>,

	maxEntityID: uint32,
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

[]EntityIDComponent<Type> EntityComponentArray::log()
{
	arr := []EntityIDComponent<Type>;

	for (i .. this.capacity)
	{
		if (this.activeArr[i]~)
		{
			entity := i as uint32;
			component := this.componentArr[i];
			arr.Add(EntityIDComponent<Type>(entity, component));
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

	while ((it.index == 0) | ((it.index < this.maxEntityID) & !this.activeArr[it.index]~))
	{
		it.index += 1;
	}

	return it.index <= this.maxEntityID;
}

EntityIDComponent<Type> EntityComponentArray::current(it: Iterator)
{
	index := it.index;
	component := this.componentArr[index];
	return EntityIDComponent<Type>(index, component);
}

EntityComponentArray::Resize(amount: uint32)
{
	resizedCapacity := ((amount / InitialCapacity) + 1) * InitialCapacity;

	this.activeArr.Resize(resizedCapacity, this.capacity);
	this.componentArr.Resize(resizedCapacity, this.capacity);
	this.capacity = resizedCapacity;
}

*Type EntityComponentArray::Insert(entityID: uint32, component: Type)
{
	assert entityID, "Cannot insert null entity ID";

	if (entityID >= this.capacity) this.Resize(entityID);

	this.maxEntityID = Math.UMax(this.maxEntityID, entityID);

	index := entityID;
	activePtr := this.activeArr[index];
	activePtr~ = true;

	componentPtr := this.componentArr[index];
	componentPtr~ = component;
	return componentPtr;
}

bool EntityComponentArray::Has(entityID: uint32)
{
	return entityID < this.capacity && this.activeArr[entityID]~;
}

*Component EntityComponentArray::Get(entityID: uint32)
{
	if (!this.Has(entityID)) return null;

	index := entityID;
	return this.componentArr[index];
}

EntityComponentArray::Remove(entityID: uint32)
{
	if (!this.Has(entityID)) return;

	index := entityID;
	this.activeArr[index]~ = false;
}

uint32 EntityComponentArray::Count() => this.capacity;

*any EntityComponentArray::GetUntyped(entityID: uint32, size: uint32)
{
	if (!this.Has(entityID)) return null;

	index := entityID;
	byteArr := this.componentArr.ptr as *byte;
	return byteArr[index * size];
}

*any EntityComponentArray::SetUntyped(entityID: uint32, data: *any, size: uint32)
{
	assert entityID, "Cannot insert null entity";

	if (entityID >= this.capacity) this.Resize(entityID);

	index := entityID;
	activePtr := this.activeArr[index];
	activePtr~ = true;
	
	byteArr := this.componentArr.ptr as *byte;
	dst := byteArr[index * size];
	copy_bytes(dst, data, size);
	return dst;
}
