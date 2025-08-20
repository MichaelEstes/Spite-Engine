package ECS

import BitSet

InvalidIndex := uint32(-1);

// Similar to a normal set, except we can represent the status with a single bit
// due to 0 not being a valid entity
state EntitySet
{
	entities: ZeroedAllocator<Entity>,
	deletedStatus: BitSet,
	count: uint32,
	capacity: uint32
}

EntitySet::()
{
	initialCapacity := 8;
	this.entities.Alloc(initialCapacity);
	this.deletedStatus = BitSet(initialCapacity);
	this.capacity = initialCapacity;
	this.count = 0;
}

EntitySet::delete
{
	this.entities.Dealloc(this.capacity);
	delete this.deletedStatus;
}

[]Entity EntitySet::log()
{
	values := []Entity;
	for(i .. this.capacity)
	{
		if (this.entities[i].id)
		{
			values.Add(this.entities[i]~);
		}
	}

	return values;
}

*Entity EntitySet::operator::[](entity: Entity)
{
	return this.Find(entity);
}

Iterator EntitySet::operator::in()
{
	return {null, -1};
}

bool EntitySet::next(it: Iterator)
{
	it.index += 1;
	while(it.index < this.capacity && !this.entities[it.index].id)
	{
		it.index += 1;
	}
	return it.index < this.capacity;
}

Entity EntitySet::current(it: Iterator)
{
	index := it.index;
	return this.entities[index]~;
}

*Entity EntitySet::Find(entity: Entity)
{
	index := this.FindIndex(entity);

	if(index == InvalidIndex) return null;
	return this.entities[index];
}

bool EntitySet::Empty(index: uint32)
{
	return this.entities[index].id == 0 && !this.deletedStatus[index];
}

uint32 EntitySet::FindIndex(entity: Entity)
{
	index := entity.id % this.capacity;
	start := index;

	while (!this.Empty(index))
	{
		if (this.entities[index].id == entity.id)
			return index;

		index = (index + 1) % this.capacity;
		if (index == start) break;
	}

	return InvalidIndex;
}

bool EntitySet::Has(entity: Entity)
{
	return this.FindIndex(entity) != InvalidIndex;
}

bool EntitySet::Insert(entity: Entity)
{
	if (this.count * 3 >= this.capacity * 2)
	{
		log this.capacity;
		this.ResizeTo((this.capacity + 1) * 2);
	}

	this.count += 1;
	return this.InsertInternal(
			entity, 
			this.entities, 
			this.deletedStatus,
			this.capacity
	);
}

bool EntitySet::Remove(entity: Entity)
{
	index := this.FindIndex(entity);
	if(index == InvalidIndex) return false;
	this.deletedStatus.Set(index);
	this.entities[index]~ = Entity();
	this.count -= 1;
	return true;
}

EntitySet::ResizeTo(capacity: int)
{	
	newEntities := ZeroedAllocator<Entity>();
	newDeletedStatus := BitSet();
	
	newEntities.Alloc(capacity);
	newDeletedStatus.Resize(capacity);

	this.InsertAllInternal(newEntities, newDeletedStatus, capacity);

	this.entities.Dealloc(this.capacity);
	delete this.deletedStatus;

	this.entities = newEntities;
	this.deletedStatus = newDeletedStatus;
	this.capacity = capacity;
}

EntitySet::Clear()
{
	this.count = 0;
	zero_out_bytes(this.entities[0], this.capacity * #sizeof Entity);
	this.deletedStatus.ClearAll();
}

bool EntitySet::InsertInternal(entity: Entity, entities: ZeroedAllocator<Entity>, 
							   deletedStatus: BitSet, capacity: uint)
{
	index := entity.id % capacity;
	start := index;
	deletedIndex := InvalidIndex;

	while (!this.Empty(index))
	{
		if (entities[index].id == entity.id) return false;

		if (deletedStatus[index]) deletedIndex = index;
		
		index = (index + 1) % capacity;
		if (index == start) break;
	}

	if (deletedIndex != InvalidIndex)
	{
		index = deletedIndex;
	}

	entities[index]~ = entity;
	deletedStatus.Clear(index);
	return true;
}

EntitySet::InsertAllInternal(entities: ZeroedAllocator<Entity>, deletedStatus: BitSet, capacity: uint)
{
	for (i .. this.capacity)
	{
		if(entities[i].id)
		{
			entity := this.entities[i]~;
			this.InsertInternal(
				entity, 
				entities, 
				deletedStatus,
				capacity
			);
		}
	}
}
