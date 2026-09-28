package ECS

import SparseSet
import ArrayView
import Atomic
import Stack

state Scene
{
	commonComponents := SparseSet<EntityComponentArray<any>>(),
	sparseComponents := SparseSet<EntityComponentMap<any>>(),

	tagComponents := SparseSet<BitSet>(),

	entityVersions := SparseSet<Atomic<uint16>>(),

	recycledEntities := Stack<uint32>(),

	singletonComponents := SingletonComponentMap(),
	currEntity := Atomic<uint32>(uint32(1)),
	id: uint16
}

Scene::(id: uint16)
{
	this.id = id;

	this.entityVersions.Insert(uint32(0), uint16(0));
}

Scene::delete
{
	for (kv in this.commonComponents)
	{
		delete kv.value~;
	}

	for (kv in this.sparseComponents)
	{
		delete kv.value~;
	}

	for (kv in this.tagComponents)
	{
		delete kv.value~;
	}

	delete this.entityVersions;
	delete this.recycledEntities;

	delete this.commonComponents;
	delete this.sparseComponents;
	delete this.singletonComponents;
}

EntityComponentIterator<Type> Scene::Iterate<Type>()
{
	component := instance.GetComponent<Type>();
	switch (component.kind)
	{
		case (ComponentKind.Common)
		{
			componentArrPtr := this.GetCommon<Type>(component.id);
			if (!componentArrPtr) break;

			return EntityComponentIterator<Type>(this@, ComponentKind.Common, componentArrPtr);
		}
		case (ComponentKind.Sparse)
		{
			componentMapPtr := this.GetSparse<Type>(component.id);
			if (!componentMapPtr) break;
			
			return EntityComponentIterator<Type>(this@, ComponentKind.Sparse, componentMapPtr);
		}
	}

	return EntityComponentIterator<Type>(this@, ComponentKind.Singleton, null);
}

*EntityComponentArray<Type> Scene::GetCommon<Type>(componentID: uint32)
{
	if (!this.commonComponents.Has(componentID)) return null;
	return this.commonComponents.Get(componentID) as *EntityComponentArray<Type>;
}

*EntityComponentArray<Type> Scene::GetOrCreateCommon<Type>(componentID: uint32)
{
	common := this.GetCommon<Type>(componentID);
	if (!common)
	{
		this.commonComponents.Insert(componentID, EntityComponentArray<Type>());
		common = this.GetCommon<Type>(componentID);
	}

	return common;
}

*EntityComponentMap<Type> Scene::GetSparse<Type>(componentID: uint32)
{
	if (!this.sparseComponents.Has(componentID)) return null;
	return this.sparseComponents.Get(componentID) as *EntityComponentMap<Type>;
}

*EntityComponentMap<Type> Scene::GetOrCreateSparse<Type>(componentID: uint32)
{
	sparse := this.GetSparse<Type>(componentID);
	if (!sparse)
	{
		this.sparseComponents.Insert(componentID, EntityComponentMap<Type>());
		sparse = this.GetSparse<Type>(componentID);
	}

	return sparse;
}

Entity Scene::RegisterEntity(id: uint32)
{
	version := this.entityVersions.Get(id).Load();
	entity := Entity(id, version);
	return entity;
}

Entity Scene::CreateEntity()
{
	currEntity := this.currEntity.Add(1);
	this.entityVersions.Insert(currEntity, Atomic<uint16>(1));
	return this.RegisterEntity(currEntity);
}

bool Scene::IsValidEntity(entity: Entity) => 
		entity.version == this.entityVersions.Get(entity.id).Load();

Scene::RemoveEntity(entity: Entity)
{
	if (!this.IsValidEntity(entity)) return;
	entityID := entity.id;

	for (keyValue in this.commonComponents)
	{
		componentID := keyValue.key;
		component := instance.GetComponentByID(componentID);
		if (keyValue.value.Has(entityID))
		{
			componentData := keyValue.value.GetUntyped(entityID, component.size);
			instance.OnComponentRemove(componentID, entity, componentData, this);
			keyValue.value.Remove(entityID);
		}
	}

	for (keyValue in this.sparseComponents)
	{
		componentID := keyValue.key;
		component := instance.GetComponentByID(componentID);
		if (keyValue.value.Has(entityID))
		{
			componentData := keyValue.value.GetUntyped(entityID, component.size);
			instance.OnComponentRemove(componentID, entity, componentData, this);
			keyValue.value.RemoveUntyped(entityID, component.size);
		}
	}

	for (keyValue in this.tagComponents)
	{
		componentID := keyValue.key;
		bitSet := keyValue.value~;
		if (bitSet[entityID])
		{
			bitSet.Clear(entityID);
			instance.OnTagComponentRemove(componentID, entity, this);
		}
	}
}

Scene::RemoveEntities(entities: []Entity)
{
	for (keyValue in this.commonComponents)
	{
		componentID := keyValue.key;
		component := instance.GetComponentByID(componentID);
		for (entity in entities) 
		{
			if (!this.IsValidEntity(entity)) continue;
			entityID := entity.id;
			if (keyValue.value.Has(entityID))
			{
				componentData := keyValue.value.GetUntyped(entityID, component.size);
				instance.OnComponentRemove(componentID, entity, componentData, this);
				keyValue.value.Remove(entityID);
			}
		}
	}

	for (keyValue in this.sparseComponents)
	{
		componentID := keyValue.key;
		component := instance.GetComponentByID(componentID);
		for (entity in entities) 
		{
			if (!this.IsValidEntity(entity)) continue;
			entityID := entity.id;
			if (keyValue.value.Has(entityID))
			{
				componentData := keyValue.value.GetUntyped(entityID, component.size);
				instance.OnComponentRemove(componentID, entity, componentData, this);
				keyValue.value.RemoveUntyped(entityID, component.size);
			}
		}
	}

	for (keyValue in this.tagComponents)
	{
		componentID := keyValue.key;
		bitSet := keyValue.value~;
		for (entity in entities) 
		{
			if (!this.IsValidEntity(entity)) continue;
			entityID := entity.id;
			if (bitSet[entityID])
			{
				bitSet.Clear(entityID);
				instance.OnTagComponentRemove(componentID, entity, this);
			}
		}
	}
}

Scene::SetComponent<Type>(entity: Entity, value: Type)
{
	component := instance.GetComponent<Type>();
	this.SetComponentDirect<Type>(entity, value, component);
}

Scene::SetComponentDirect<Type>(entity: Entity, value: Type, component: Component)
{
	if (!this.IsValidEntity(entity)) return;
	id := component.id
	entityID := entity.id;

	inserted: *Type = null;
	switch (component.kind)
	{
		case (ComponentKind.Common)
		{
			componentArrPtr := this.GetOrCreateCommon<Type>(id);
			inserted = componentArrPtr.Insert(entityID, value);
		}
		case (ComponentKind.Sparse)
		{
			componentMapPtr := this.GetOrCreateSparse<Type>(id);			
			inserted = componentMapPtr.Insert(entityID, value);
		}
		default return;
	}

	instance.OnComponentEnter(id, entity, inserted, this);
}

Scene::SetComponentUntyped(entity: Entity, data: *any, component: Component)
{
	if (!this.IsValidEntity(entity)) return;
	id := component.id;
	entityID := entity.id;

	inserted: *any = null;
	switch (component.kind)
	{
		case (ComponentKind.Common)
		{
			componentArrPtr := this.GetCommon<any>(id);
			if (!componentArrPtr)
			{
				log "Scene::SetComponentUntyped Cannot create common component container in untyped flow";
				return;
			}
			inserted = componentArrPtr.SetUntyped(entityID, data, component.size);
		}
		case (ComponentKind.Sparse)
		{
			componentMapPtr := this.GetSparse<any>(id);
			if (!componentMapPtr)
			{
				log "Scene::SetComponentUntyped Cannot create sparse component container in untyped flow";
				return;
			}
			inserted = componentMapPtr.SetUntyped(entityID, data, component.size);
		}
		default return;
	}

	instance.OnComponentEnter(id, entity, inserted, this);
}

*Type Scene::GetComponent<Type>(entity: Entity)
{
	component := instance.GetComponent<Type>();
	return this.GetComponentDirect<Type>(entity, component);
}

*Type Scene::GetComponentDirect<Type>(entity: Entity, component: Component)
{
	if (!this.IsValidEntity(entity)) return null;
	id := component.id
	entityID := entity.id;

	switch (component.kind)
	{
		case (ComponentKind.Common)
		{
			componentArrPtr := this.GetCommon<Type>(id);
			if (!componentArrPtr) break;

			return componentArrPtr.Get(entityID);
		}
		case (ComponentKind.Sparse)
		{
			componentMapPtr := this.GetSparse<Type>(id);
			if (!componentMapPtr) break;
			
			return componentMapPtr.Get(entityID);
		}
	}

	return null;
}

*any Scene::GetComponentUntyped(entity: Entity, component: Component)
{
	if (!this.IsValidEntity(entity)) return null;
	id := component.id;
	entityID := entity.id;

	switch (component.kind)
	{
		case (ComponentKind.Common)
		{
			if (!this.commonComponents.Has(id)) break;
			return this.commonComponents.Get(id).GetUntyped(entityID, component.size);
		}
		case (ComponentKind.Sparse)
		{
			if (!this.sparseComponents.Has(id)) break;
			return this.sparseComponents.Get(id).GetUntyped(entityID, component.size);
		}
	}

	return null;
}

Scene::RemoveComponent<Type>(entity: Entity)
{
	component := instance.GetComponent<Type>();
	this.RemoveComponentDirect<Type>(entity, component);
}

Scene::RemoveComponentDirect<Type>(entity: Entity, component: Component)
{
	if (!this.IsValidEntity(entity)) return;
	id := component.id
	entityID := entity.id;

	switch (component.kind)
	{
		case (ComponentKind.Common)
		{
			componentArrPtr := this.GetCommon<Type>(id);
			if (!componentArrPtr) break;

			if (componentArrPtr.Has(entityID))
			{
				componentData := componentArrPtr.Get(entityID);
				instance.OnComponentRemove(id, entity, componentData, this);
				componentArrPtr.Remove(entityID);
			}
		}
		case (ComponentKind.Sparse)
		{
			componentMapPtr := this.GetSparse<Type>(id);
			if (!componentMapPtr) break;
			
			if (componentMapPtr.Has(entityID))
			{
				componentData := componentMapPtr.Get(entityID);
				instance.OnComponentRemove(id, entity, componentData, this);
				componentMapPtr.Remove(entityID);
			}
		}
	}
}

Scene::SetTagComponent(entity: Entity, tagComponent: TagComponent)
{
	if (!this.IsValidEntity(entity)) return;
	id := tagComponent.id;

	if (!this.tagComponents.Has(id))
	{
		this.tagComponents.Insert(id, BitSet());
	}

	bitSet := this.tagComponents.Get(id)
	bitSet.Set(entity.id);

	instance.OnTagComponentEnter(id, entity, this);
}

Scene::RemoveTagComponent(entity: Entity, tagComponent: TagComponent)
{
	if (!this.IsValidEntity(entity)) return;
	id := tagComponent.id;

	if (this.tagComponents.Has(id))
	{
		bitSet := this.tagComponents.Get(id)
		bitSet.Clear(entity.id);
		instance.OnTagComponentRemove(id, entity, this);
	}
}

bool Scene::HasTagComponent(entity: Entity, tagComponent: TagComponent)
{
	if (!this.IsValidEntity(entity)) return false;
	id := tagComponent.id;

	if (!this.tagComponents.Has(id)) return false;

	bitSet := this.tagComponents.Get(id)~;
	return bitSet[entity.id];
}

EntityTagComponentIterator Scene::IterateTagComponent(tagComponent: TagComponent)
{
	id := tagComponent.id;

	if (this.tagComponents.Has(id))
	{
		bitSet := this.tagComponents.Get(id);
		return EntityTagComponentIterator(this@, ComponentKind.Common, bitSet);
	}

	return EntityTagComponentIterator(this@, ComponentKind.Singleton, null);
}

// Does not call the "on remove" callback for the tag component
Scene::ClearTagComponent(tagComponent: TagComponent)
{
	id := tagComponent.id;

	if (this.tagComponents.Has(id))
	{
		bitSet := this.tagComponents.Get(id);
		bitSet.ClearAll();
	}
}

Scene::SetSingleton<Type>(value: Type)
{
	this.singletonComponents.Insert<Type>(value);
	component := instance.GetComponent<Type>();

	valuePtr := this.GetSingleton<Type>();
	instance.OnComponentEnter(component.id, NullEntity, valuePtr, this);
}

bool Scene::HasSingleton<Type>()
{
	return this.singletonComponents.Has<Type>();
}

*Type Scene::GetSingleton<Type>()
{
	return this.singletonComponents.Get<Type>();
}