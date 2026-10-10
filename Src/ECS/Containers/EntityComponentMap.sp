package ECS

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

state EntityComponentMap<Type, InitialCapacity = 16, InitialSparseCapacity = 1024>
{
	sparseArr: ZeroedAllocator<uint16>,
	entityArr: Allocator<uint32>,
	componentArr: Allocator<Type>,

	sparseCapacity: uint32,
	count: uint16,
	capacity: uint16
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

[]EntityIDComponent<Type> EntityComponentMap::log()
{
	arr := []EntityIDComponent<Type>;

	for (i .. this.count)
	{
		entityID := this.entityArr[i]~;
		component := this.componentArr[i];
		arr.Add(EntityIDComponent<Type>(entityID, component));
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

EntityIDComponent<Type> EntityComponentMap::current(it: Iterator)
{
	index := it.index;
	entityID := this.entityArr[index]~;
	component := this.componentArr[index];
	return EntityIDComponent<Type>(entityID, component);
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

*Type EntityComponentMap::Insert(entityID: uint32, component: Type)
{
	assert entityID, "Cannot insert null entity ID";

	index := this.GetIndex(entityID);
	if (index)
	{
		index -= 1;
		componentPtr := this.componentArr[index];
		componentPtr~ = component;
		return componentPtr;
	}

	if (entityID >= this.sparseCapacity) this.ResizeSparse(entityID);
	if (this.count >= this.capacity) this.ResizeDense();

	this.entityArr[this.count]~ = entityID;
	componentPtr := this.componentArr[this.count];
	componentPtr~ = component;

	this.count += 1;
	this.sparseArr[entityID]~ = this.count;
	return componentPtr;
}

bool EntityComponentMap::Has(entityID: uint32)
{
	if (entityID >= this.sparseCapacity) return false;
	return this.sparseArr[entityID]~ != 0;
}

uint16 EntityComponentMap::GetIndex(entityID: uint32)
{
	if (entityID >= this.sparseCapacity) return uint16(0);
	index := this.sparseArr[entityID]~;
	return index;
}

*Component EntityComponentMap::Get(entityID: uint32)
{
	index := this.GetIndex(entityID);
	if (!index) return null;
	index -= 1;

	return this.componentArr[index];
}

EntityComponentMap::Remove(entityID: uint32)
{
	index := this.GetIndex(entityID);
	if (!index) return;
	index -= 1;

	this.sparseArr[entityID]~ = 0;

	this.count -= 1;
	if (index == this.count) return;

	endEntityID := this.entityArr[this.count]~;
	endComponent := this.componentArr[this.count]~;

	this.entityArr[index]~ = endEntityID;
	this.componentArr[index]~ = endComponent;
	this.sparseArr[endEntityID]~ = index + 1;
}

uint16 EntityComponentMap::Count() => this.count;

*any EntityComponentMap::GetUntyped(entityID: uint32, size: uint32)
{
	index := this.GetIndex(entityID);
	if (!index) return null;
	index -= 1;

	byteArr := this.componentArr.ptr as *byte;
	return byteArr[index * size];
}

*any EntityComponentMap::SetUntyped(entityID: uint32, data: *any, size: uint32)
{
	assert entityID, "Cannot insert null entity ID";

	index := this.GetIndex(entityID);
	if (index)
	{
		index -= 1;
		byteArr := this.componentArr.ptr as *byte;
		dst := byteArr[index * size];
		copy_bytes(dst, data, size);
		return dst;
	}

	if (entityID >= this.sparseCapacity) this.ResizeSparse(entityID);
	if (this.count >= this.capacity) this.ResizeDense();

	this.entityArr[this.count]~ = entityID;
	byteArr := this.componentArr.ptr as *byte;

	dst := byteArr[this.count * size];
	copy_bytes(dst, data, size);

	this.count += 1;
	this.sparseArr[entityID]~ = this.count;
	return dst;
}

EntityComponentMap::RemoveUntyped(entityID: uint32, size: uint32)
{
	index := this.GetIndex(entityID);
	if (!index) return;
	index -= 1;

	this.sparseArr[entityID]~ = 0;

	byteArr := this.componentArr.ptr as *byte;
	componentDst := byteArr[index * size];

	this.count -= 1;
	if (index == this.count) return;

	endEntityID := this.entityArr[this.count]~;
	componentSrc := byteArr[this.count * size];

	this.entityArr[index]~ = endEntityID;
	this.sparseArr[endEntityID]~ = index + 1;

	copy_bytes(componentDst, componentSrc, size);
}
