package ECS

import SparseSet
import ArrayView

state Scene
{
	commonComponents := SparseSet<EntityComponentArray<any>>(),
	sparseComponents := SparseSet<EntityComponentMap<any>>(),

	commonTagComponents := SparseSet<BitSet>(),
	sparseTagComponents := SparseSet<EntitySet>(),

	singletonComponents := SingletonComponentMap(),
	currEntity: uint32,
	id: uint16
}

Scene::(id: uint16)
{
	this.id = id;
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

	for (kv in this.commonTagComponents)
	{
		delete kv.value~;
	}

	for (kv in this.sparseTagComponents)
	{
		delete kv.value~;
	}

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

			return EntityComponentIterator<Type>(ComponentKind.Common, componentArrPtr);
		}
		case (ComponentKind.Sparse)
		{
			componentMapPtr := this.GetSparse<Type>(component.id);
			if (!componentMapPtr) break;
			
			return EntityComponentIterator<Type>(ComponentKind.Sparse, componentMapPtr);
		}
	}

	return EntityComponentIterator<Type>();
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

Entity Scene::CreateEntity()
{
	this.currEntity += 1;
	return Entity(this.currEntity);
}

Scene::RemoveEntity(entity: Entity)
{
	for (keyValue in this.commonComponents)
	{
		componentID := keyValue.key;
		component := instance.GetComponentByID(componentID);
		if (keyValue.value.Has(entity))
		{
			componentData := keyValue.value.GetUntyped(entity, component.size);
			instance.OnComponentRemove(componentID, entity, componentData, this);
			keyValue.value.Remove(entity);
		}
	}

	for (keyValue in this.sparseComponents)
	{
		componentID := keyValue.key;
		component := instance.GetComponentByID(componentID);
		if (keyValue.value.Has(entity))
		{
			componentData := keyValue.value.GetUntyped(entity, component.size);
			instance.OnComponentRemove(componentID, entity, componentData, this);
			keyValue.value.RemoveUntyped(entity, component.size);
		}
	}

	for (keyValue in this.commonTagComponents)
	{
		componentID := keyValue.key;
		bitSet := keyValue.value~;
		id := entity.id;
		if (bitSet[id])
		{
			bitSet.Clear(id);
			instance.OnTagComponentRemove(componentID, entity, this);
		}
	}

	for (keyValue in this.sparseTagComponents)
	{
		componentID := keyValue.key;
		entitySet := keyValue.value;
		if (entitySet.Has(entity))
		{
			entitySet.Remove(entity)
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
			if (keyValue.value.Has(entity))
			{
				componentData := keyValue.value.GetUntyped(entity, component.size);
				instance.OnComponentRemove(componentID, entity, componentData, this);
				keyValue.value.Remove(entity);
			}
		}
	}

	for (keyValue in this.sparseComponents)
	{
		componentID := keyValue.key;
		component := instance.GetComponentByID(componentID);
		for (entity in entities) 
		{
			if (keyValue.value.Has(entity))
			{
				componentData := keyValue.value.GetUntyped(entity, component.size);
				instance.OnComponentRemove(componentID, entity, componentData, this);
				keyValue.value.RemoveUntyped(entity, component.size);
			}
		}
	}

	for (keyValue in this.commonTagComponents)
	{
		componentID := keyValue.key;
		bitSet := keyValue.value~;
		for (entity in entities) 
		{
			id := entity.id;
			if (bitSet[id])
			{
				bitSet.Clear(id);
				instance.OnTagComponentRemove(componentID, entity, this);
			}
		}
	}

	for (keyValue in this.sparseTagComponents)
	{
		componentID := keyValue.key;
		entitySet := keyValue.value;
		for (entity in entities) 
		{
			if (entitySet.Has(entity))
			{
				entitySet.Remove(entity)
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
	id := component.id

	switch (component.kind)
	{
		case (ComponentKind.Common)
		{
			componentArrPtr := this.GetOrCreateCommon<Type>(id);
			componentArrPtr.Insert(entity, value);
		}
		case (ComponentKind.Sparse)
		{
			componentMapPtr := this.GetOrCreateSparse<Type>(id);			
			componentMapPtr.Insert(entity, value);
		}
	}

	instance.OnComponentEnter(id, entity, value@, this);
}

*Type Scene::GetComponent<Type>(entity: Entity)
{
	component := instance.GetComponent<Type>();
	return this.GetComponentDirect<Type>(entity, component);
}

*Type Scene::GetComponentDirect<Type>(entity: Entity, component: Component)
{
	id := component.id

	switch (component.kind)
	{
		case (ComponentKind.Common)
		{
			componentArrPtr := this.GetCommon<Type>(id);
			if (!componentArrPtr) break;

			return componentArrPtr.Get(entity);
		}
		case (ComponentKind.Sparse)
		{
			componentMapPtr := this.GetSparse<Type>(id);
			if (!componentMapPtr) break;
			
			return componentMapPtr.Get(entity);
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
	id := component.id

	switch (component.kind)
	{
		case (ComponentKind.Common)
		{
			componentArrPtr := this.GetCommon<Type>(id);
			if (!componentArrPtr) break;

			if (componentArrPtr.Has(entity))
			{
				componentData := componentArrPtr.Get(entity);
				instance.OnComponentRemove(id, entity, componentData, this);
				componentArrPtr.Remove(entity);
			}
		}
		case (ComponentKind.Sparse)
		{
			componentMapPtr := this.GetSparse<Type>(id);
			if (!componentMapPtr) break;
			
			if (componentMapPtr.Has(entity))
			{
				componentData := componentMapPtr.Get(entity);
				instance.OnComponentRemove(id, entity, componentData, this);
				componentMapPtr.Remove(entity);
			}
		}
	}
}

Scene::SetTagComponent(entity: Entity, tagComponent: TagComponent)
{
	id := tagComponent.id;

	switch (tagComponent.kind)
	{
		case (ComponentKind.Common)
		{
			if (!this.commonTagComponents.Has(id))
			{
				this.commonTagComponents.Insert(id, BitSet());
			}

			bitSet := this.commonTagComponents.Get(id)
			bitSet.Set(entity.id);
		}
		case (ComponentKind.Sparse)
		{
			if (!this.sparseTagComponents.Has(id))
			{
				this.sparseTagComponents.Insert(id, EntitySet());
			}
			
			entitySet := this.sparseTagComponents.Get(id);
			entitySet.Insert(entity);
		}
	}

	instance.OnTagComponentEnter(id, entity, this);
}

Scene::RemoveTagComponent(entity: Entity, tagComponent: TagComponent)
{
	id := tagComponent.id;
	removed := false;

	switch (tagComponent.kind)
	{
		case (ComponentKind.Common)
		{
			if (!this.commonTagComponents.Has(id)) break;

			bitSet := this.commonTagComponents.Get(id)
			bitSet.Clear(entity.id);
			removed = true;
		}
		case (ComponentKind.Sparse)
		{
			if (!this.sparseTagComponents.Has(id)) break;
			
			entitySet := this.sparseTagComponents.Get(id);
			entitySet.Remove(entity);
			removed = true;
		}
	}

	if (removed) instance.OnTagComponentRemove(id, entity, this);
}

bool Scene::HasTagComponent(entity: Entity, tagComponent: TagComponent)
{
	id := tagComponent.id;

	switch (tagComponent.kind)
	{
		case (ComponentKind.Common)
		{
			if (!this.commonTagComponents.Has(id)) return false;

			bitSet := this.commonTagComponents.Get(id)~;
			return bitSet[entity.id];
		}
		case (ComponentKind.Sparse)
		{
			if (!this.sparseTagComponents.Has(id)) return false;
			
			entitySet := this.sparseTagComponents.Get(id);
			return entitySet.Has(entity);
		}
	}

	return false;
}

EntityTagComponentIterator Scene::IterateTagComponent(tagComponent: TagComponent)
{
	id := tagComponent.id;

	switch (tagComponent.kind)
	{
		case (ComponentKind.Common)
		{
			if (!this.commonTagComponents.Has(id)) break;

			bitSet := this.commonTagComponents.Get(id);
			return EntityTagComponentIterator(ComponentKind.Common, bitSet);
		}
		case (ComponentKind.Sparse)
		{
			if (!this.sparseTagComponents.Has(id)) break;
			
			entitySet := this.sparseTagComponents.Get(id);
			return EntityTagComponentIterator(ComponentKind.Sparse, entitySet);
		}
	}

	return EntityTagComponentIterator(ComponentKind.Singleton, null);
}

Scene::SetSingleton<Type>(value: Type)
{
	log "Singleton set";
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