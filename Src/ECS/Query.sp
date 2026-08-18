package ECS

import BitSet

state QueryIterator
{
	scene: *Scene,
	unionOf: ?{
		comp: Component,
		tag: TagComponent
	},
	with: Array<Component>,
	without: Array<Component>,
	withTags: Array<TagComponent>,
	withoutTags: Array<TagComponent>,
	unionOfCount: uint32,
	isUnionOfTag: bool = false
}

state QueryIndex
{
	entityID: uint,
	itIndex: int
}

bool QueryIterator::Empty()
{
	return this.unionOfCount == 0;
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
		if (!this.isUnionOfTag)
		{
			switch (this.unionOf.comp.kind)
			{
				case (ComponentKind.Common)
				{
					compArr := this.scene.commonComponents.Get(this.unionOf.comp.id);
					if (!compArr.next(iterator)) return false;
					it.entityID = iterator.index;
					it.itIndex = iterator.index;
				}
				case (ComponentKind.Sparse)
				{
					compMap := this.scene.sparseComponents.Get(this.unionOf.comp.id);
					if (!compMap.next(iterator)) return false;
					it.entityID = compMap.entityArr[iterator.index].id;
					it.itIndex = iterator.index;
				}
			}
		}
		else
		{
			tagIterator := this.scene.IterateTagComponent(this.unionOf.tag);
			if (!tagIterator.next(iterator)) return false;
			it.entityID = tagIterator.current(iterator).id;
			it.itIndex = iterator.index;
		}

		nextEntity = Entity(it.entityID);

		for (with in this.with)
		{
			if (!this.isUnionOfTag && with.id == this.unionOf.comp.id) continue;
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
			if (this.isUnionOfTag && withTag.id == this.unionOf.tag.id) continue;
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

	leastComponent: ?{comp: Component, tag: TagComponent} = Component();
	leastComponentCount := uint(-1);
	leastComponentIsTag := false;
	for (component in this.with)
	{
		switch (component.kind)
		{
			case (ComponentKind.Common)
			{
				compArr := this.scene.commonComponents.Get(component.id);
				if (compArr)
				{
					currCount := compArr.Count() as uint;
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

	for (tagComponent in this.withTags)
	{
		switch (tagComponent.kind)
		{
			case (ComponentKind.Common)
			{
				compArr := this.scene.commonTagComponents.Get(tagComponent.id);
				if (compArr)
				{
					currCount := compArr.SetBitsCount();
					if (currCount < leastComponentCount)
					{
						leastComponentCount = currCount;
						leastComponent = tagComponent;
						leastComponentIsTag = true;
					}
				}
			}
			case (ComponentKind.Sparse)
			{
				compMap := this.scene.sparseTagComponents.Get(tagComponent.id);
				if (compMap)
				{
					currCount := compMap.count as uint;
					if (currCount < leastComponentCount)
					{
						leastComponentCount = currCount;
						leastComponent = tagComponent;
						leastComponentIsTag = true;
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
	result.unionOfCount = leastComponentCount;
	result.isUnionOfTag = leastComponentIsTag;

	return result;
}