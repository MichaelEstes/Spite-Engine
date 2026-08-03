package ECS

import BitSet

state QueryIterator
{
	scene: *Scene,
	unionOf: Component,
	with: Array<Component>,
	without: Array<Component>,
	withTags: Array<TagComponent>,
	withoutTags: Array<TagComponent>,
}

state QueryIndex
{
	entityID: uint,
	itIndex: int
}

QueryIndex QueryIterator::operator::in()
{
	return QueryIndex:{0, -1};
}

bool QueryIterator::next(it: QueryIndex)
{
	nextEntity := NullEntity;

	while (!nextEntity)
	{
		iterator := Iterator(null, it.itIndex);
		switch (this.unionOf.kind)
		{
			case (ComponentKind.Common)
			{
				compArr := this.scene.commonComponents.Get(this.unionOf.id);
				if (!compArr.next(iterator)) return false;
				it.entityID = iterator.index;
				it.itIndex = iterator.index;
			}
			case (ComponentKind.Sparse)
			{
				compMap := this.scene.sparseComponents.Get(this.unionOf.id);
				if (!compMap.next(iterator)) return false;
				it.entityID = compMap.entityArr[iterator.index].id;
				it.itIndex = iterator.index;
			}
		}

		nextEntity = Entity(it.entityID);

		for (with in this.with)
		{
			if (with.id == this.unionOf.id) continue;
			if (with.kind == ComponentKind.Common)
			{
				compArr := this.scene.commonComponents.Get(with.id);
				if (!compArr || !compArr.Has(nextEntity))
				{
					nextEntity = NullEntity;
					break;
				}
			}
			else if (with.kind == ComponentKind.Sparse)
			{
				compMap := this.scene.sparseComponents.Get(with.id);
				if (!compMap || !compMap.Has(nextEntity))
				{
					nextEntity = NullEntity;
					break;
				}
			}
		}

		if (!nextEntity) continue;

		for (withTag in this.withTags)
		{
			if (!this.scene.HasTagComponent(nextEntity, withTag))
			{
				nextEntity = NullEntity;
				break;
			}
		}

		if (!nextEntity) continue;

		for (without in this.without)
		{
			if (without.kind == ComponentKind.Common)
			{
				compArr := this.scene.commonComponents.Get(without.id);
				if (compArr && compArr.Has(nextEntity))
				{
					nextEntity = NullEntity;
					break;
				}
			}
			else if (without.kind == ComponentKind.Sparse)
			{
				compMap := this.scene.sparseComponents.Get(without.id);
				if (compMap && compMap.Has(nextEntity))
				{
					nextEntity = NullEntity;
					break;
				}
			}
		}

		if (!nextEntity) continue;

		for (withoutTag in this.withoutTags)
		{
			if (this.scene.HasTagComponent(nextEntity, withoutTag))
			{
				nextEntity = NullEntity;
				break;
			}
		}
	}

	return true;
}

Entity QueryIterator::current(it: QueryIndex)
{
	return Entity(it.entityID);	
}

state Query
{
	scene: *Scene,
	with: Array<Component>,
	without: Array<Component>,
	withTags: Array<TagComponent>,
	withoutTags: Array<TagComponent>,
}

Query::(scene: *Scene)
{
	this.scene = scene;
}

Query::delete
{
	delete this.with;
	delete this.without;
	delete this.withTags;
	delete this.withoutTags;
}

ref Query Query::Scene(scene: *Scene)
{
	this.scene = scene;
	
	return this;
}

ref Query Query::With<Type>()
{
	component := instance.GetComponent<Type>();
	this.with.Add(component);
	
	return this;
}

ref Query Query::Without<Type>()
{
	component := instance.GetComponent<Type>();
	this.without.Add(component);
	
	return this;
}

ref Query Query::WithTag(tagComponent: TagComponent)
{
	this.withTags.Add(tagComponent);
	
	return this;
}

ref Query Query::WithoutTag(tagComponent: TagComponent)
{
	this.withoutTags.Add(tagComponent);
	
	return this;
}

QueryIterator Query::Result()
{
	result := QueryIterator();
	if (!this.with.count) return result;

	leastComponent := Component();
	leastComponentCount := uint(-1);
	for (component in this.with)
	{
		switch (component.kind)
		{
			case (ComponentKind.Common)
			{
				compArr := this.scene.commonComponents.Get(component.id);
				if (compArr)
				{
					currCount := compArr.Count();
					if (currCount < leastComponentCount)
					{
						leastComponentCount = currCount;
						leastComponent = component;
					}
				}
			}
			case (ComponentKind.Sparse)
			{
				compMap := this.scene.sparseComponents.Get(component.id);
				if (compMap)
				{
					currCount := compMap.Count() as uint;
					if (currCount < leastComponentCount)
					{
						leastComponentCount = currCount;
						leastComponent = component;
					}
				}
			}
		}
	}

	result.scene = this.scene;
	result.unionOf = leastComponent;
	result.with = this.with;
	result.without = this.without;
	result.withTags = this.withTags;
	result.withoutTags = this.withoutTags;

	return result;
}