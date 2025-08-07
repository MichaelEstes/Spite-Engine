package ECS

import SparseSet
import ArrayView

state Scene
{
	commonComponents := SparseSet<EntityComponentArray<any>>(),
	sparseComponents := SparseSet<EntityComponentMap<any>>(),
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
			instance.OnComponentRemove(componentID, componentData, this);
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
			instance.OnComponentRemove(componentID, componentData, this);
			keyValue.value.RemoveUntyped(entity, component.size);
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
				instance.OnComponentRemove(componentID, componentData, this);
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
				instance.OnComponentRemove(componentID, componentData, this);
				keyValue.value.RemoveUntyped(entity, component.size);
			}
		}
	}
}

Scene::SetComponent<Type>(entity: Entity, value: Type)
{
	component := instance.GetComponent<Type>();
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

	instance.OnComponentEnter(id, value@, this);
}

*Type Scene::GetComponent<Type>(entity: Entity)
{
	component := instance.GetComponent<Type>();
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
				instance.OnComponentRemove(id, componentData, this);
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
				instance.OnComponentRemove(id, componentData, this);
				componentMapPtr.Remove(entity);
			}
		}
	}
}

Scene::SetSingleton<Type>(value: Type)
{
	log "Setting Singleton: ", value;
	this.singletonComponents.Insert<Type>(value);
	component := instance.GetComponent<Type>();
	instance.OnComponentEnter(component.id, this.GetSingleton<Type>(), this);
}

bool Scene::HasSingleton<Type>()
{
	return this.singletonComponents.Has<Type>();
}

*Type Scene::GetSingleton<Type>()
{
	return this.singletonComponents.Get<Type>();
}