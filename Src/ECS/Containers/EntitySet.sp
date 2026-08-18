package ECS

import BitSet

InvalidIndex := uint32(0);

state EntitySet
{
	entities: Allocator<Entity>,
	sparse: ZeroedAllocator<uint32>,

	count: uint32,
	capacity: uint32,
	sparseCapacity: uint32
}

EntitySet::()
{
	initialCapacity := 8;
	initialSparseCapacity := initialCapacity * 2;
	this.entities.Alloc(initialCapacity);
	this.sparse.Alloc(initialSparseCapacity);

	this.count = 0;
	this.capacity = initialCapacity;
	this.sparseCapacity = initialSparseCapacity;
}

EntitySet::delete
{
	this.entities.Dealloc(this.capacity);
	this.sparse.Dealloc(this.sparseCapacity);
}

[]Entity EntitySet::log()
{
	values := []Entity;
	values.count = this.count;
	values.capacity = this.capacity;
	values.memory = this.entities as Allocator<byte>;

	return values;
}

Entity EntitySet::operator::[](entity: Entity)
{
	return this.Find(entity);
}

Iterator EntitySet::operator::in()
{
	return {null, 0};
}

bool EntitySet::next(it: Iterator)
{
	it.index += 1;
	return it.index <= this.count;
}

Entity EntitySet::current(it: Iterator)
{
	index := it.index;
	return this.entities[index]~;
}

Entity EntitySet::Find(entity: Entity)
{
	index := this.FindIndex(entity);
	if (!index) return NullEntity;

	return this.entities[index]~;
}

uint32 EntitySet::FindIndex(entity: Entity) =>
{
	if (entity.id >= this.sparseCapacity) return uint32(0);

	return this.sparse[entity.id]~;
}

bool EntitySet::Has(entity: Entity)
{
	return this.FindIndex(entity) != uint32(0);
}

EntitySet::ResizeDense()
{
	resizedCapacity := (this.capacity + 1) * 2;

	this.entities.Resize(resizedCapacity, this.capacity);
	this.capacity = resizedCapacity;
}

EntitySet::ResizeSparse(amount: uint32)
{
	resizedCapacity := ((amount / this.sparseCapacity) + 1) * this.sparseCapacity;

	this.sparse.Resize(resizedCapacity, this.sparseCapacity);
	this.sparseCapacity = resizedCapacity;
}

bool EntitySet::Insert(entity: Entity)
{
	if (!this.Has(entity))
	{
		if (this.count + 1 >= this.capacity) this.ResizeDense();
		if (entity.id >= this.sparseCapacity) this.ResizeSparse(entity.id);

		this.count += 1;
		this.entities[this.count]~ = entity;
		this.sparse[entity.id]~ = this.count;
		return true;
	}

	return false;
}

bool EntitySet::Remove(entity: Entity)
{
	index := this.FindIndex(entity);
	if(index == uint32(0)) return false;

	this.sparse[entity.id]~ = uint32(0);

	if (index != this.count)
	{
		endEntity := this.entities[this.count]~;
		this.entities[index]~ = endEntity;
		this.sparse[endEntity.id]~ = index;
	}

	this.count -= 1;
	return true;
}

EntitySet::Clear()
{
	this.count = 0;
	zero_out_bytes(this.sparse[0], this.sparseCapacity * #sizeof uint32);
}