package EntityComponentMap

import Entity

MaxSize := 65535;

uint16 ResizeFactor(capacity: uint16)
{
	resized := (capacity + 1) * 2;
	if (resized >= MaxSize) 
	{
		log "Warning: EntityComponentMap has reached max size"
		return MaxSize;
	}
	return resized;
}

state EntityComponentMap<Component, InitialCapacity = 16, InitialSparseCapacity = 1024>
{
	count: uint16,
	capacity: uint16,
	sparseCapacity: uint32,

	sparseArr: ZeroedAllocator<uint16>,
	entityArr: Allocator<Entity>,
	componentArr: Allocator<Component>
}

EntityComponentMap::()
{
	this.sparseArr.Alloc(InitialSparseCapacity);
	this.entityArr.Alloc(InitialCapacity);
	this.componentArr.Alloc(InitialCapacity);

	this.count = 0;
	this.capacity = InitialCapacity;
	this.sparseCapacity = InitialSparseCapacity;
}

EntityComponentMap::delete 
{
	this.sparseArr.Dealloc(this.sparseCapacity);
	this.entityArr.Dealloc(this.capacity);
	this.componentArr.Dealloc(this.capacity);
}

[]EntityComponent<Component> EntityComponentMap::log()
{
	arr := []EntityComponent<Component>;

	for (i .. this.count)
	{
		entity := this.entityArr[i]~;
		component := this.componentArr[i];
		arr.Add({ entity, component });
	}

	return arr;
}

Iterator EntityComponentMap::operator::in()
{
	return {null, -1};
}

bool EntityComponentMap::next(it: Iterator)
{
	it.index += 1;
	return it.index < this.count;
}

EntityComponent<Component> EntityComponentMap::current(it: Iterator)
{
	index := it.index;
	entity := this.entityArr[index]~;
	component := this.componentArr[index];
	return {entity, component} as EntityComponent<Component>;
}

EntityComponentMap::ResizeSparse(amount: uint32)
{
	resizedCapacity := (((amount + (InitialSparseCapacity - 1)) / InitialSparseCapacity) * 
						InitialSparseCapacity) * 2;

	this.sparseArr.Resize(resizedCapacity, this.sparseCapacity);
	this.sparseCapacity = resizedCapacity;
}

EntityComponentMap::ResizeDense()
{
	resizedCapacity := ResizeFactor(this.capacity);

	this.entityArr.Resize(resizedCapacity, this.capacity);
	this.componentArr.Resize(resizedCapacity, this.capacity);
	this.capacity = resizedCapacity;
}

EntityComponentMap::Insert(entity: Entity, component: Component)
{
	assert !!entity, "Cannot insert null entity";

	if (entity.id >= this.sparseCapacity) this.ResizeSparse(entity.id);
	if (this.count >= this.capacity) this.ResizeDense();

	this.entityArr[this.count]~ = entity;
	this.componentArr[this.count]~ = component;

	this.count += 1;
	this.sparseArr[entity.id]~ = this.count;
}

bool EntityComponentMap::Has(entity: Entity)
{
	if (entity.id >= this.sparseCapacity) return false;
	return this.sparseArr[entity.id]~ != 0;
}

uint16 EntityComponentMap::GetIndex(entity: Entity)
{
	if (entity.id >= this.sparseCapacity) return uint16(0);
	index := this.sparseArr[entity.id]~;
	return index;
}

*Component EntityComponentMap::Get(entity: Entity)
{
	index := this.GetIndex(entity);
	if (!index) return null;
	index -= 1;

	return this.componentArr[index];
}

*any EntityComponentMap::GetUntyped(entity: Entity, size: uint32)
{
	index := this.GetIndex(entity);
	if (!index) return null;
	index -= 1;

	byteArr := this.componentArr.ptr as *byte;
	return byteArr[index * size];
}

EntityComponentMap::Remove(entity: Entity)
{
	index := this.GetIndex(entity);
	if (!index) return;
	index -= 1;

	this.sparseArr[entity.id]~ = 0;

	this.count -= 1;
	if (!this.count) return;

	endEntity := this.entityArr[this.count]~;
	endComponent := this.componentArr[this.count]~;

	this.entityArr[index]~ = endEntity;
	this.componentArr[index]~ = endComponent;
	this.sparseArr[endEntity.id]~ = index + 1;
}

EntityComponentMap::RemoveUntyped(entity: Entity, size: uint32)
{
	index := this.GetIndex(entity);
	if (!index) return;
	index -= 1;

	this.sparseArr[entity.id]~ = 0;

	byteArr := this.componentArr.ptr as *byte;
	componentDst := byteArr[index * size];

	this.count -= 1;
	if (!this.count) return;

	endEntity := this.entityArr[this.count]~;
	componentSrc := byteArr[this.count * size];

	this.entityArr[index]~ = endEntity;
	this.sparseArr[endEntity.id]~ = index + 1;

	copy_bytes(componentDst, componentSrc, size);
}
