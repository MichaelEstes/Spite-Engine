package Query

import BitSet
import ECS
import Scene

state QuerySet
{
	entitySet: BitSet
}

QuerySet::delete
{
	delete this.entitySet;
}

Iterator QuerySet::operator::in()
{
	return {null, -1};
}

bool QuerySet::next(it: Iterator)
{
	it.index += 1;
	while (it.index < this.entitySet.bitCount && !this.entitySet[it.index]) it.index += 1;
	return it.index < this.entitySet.bitCount;
}

Entity QuerySet::current(it: Iterator)
{
	return Entity(it.index);	
}

state Query
{
	scene: *Scene,
	with: Array<Component>,
	without: Array<Component>
}

Query::(scene: *Scene)
{
	this.scene = scene;
}

Query::delete
{
	delete this.with;
	delete this.without;
}

ref Query Query::Scene(scene: *Scene)
{
	this.scene = scene;
	
	return this;
}

ref Query Query::With<Type>()
{
	component := ECS.instance.GetComponent<Type>();
	this.with.Add(component);
	
	return this;
}

ref Query Query::WithAll(components: []Component)
{
	for (component in components)
	{
		this.with.Add(component);
	}

	return this;
}

ref Query Query::Without<Type>()
{
	component := ECS.instance.GetComponent<Type>();
	this.without.Add(component);
	
	return this;
}

ref Query Query::WithoutAll(components: []Component)
{
	for (component in components)
	{
		this.without.Add(component);
	}

	return this;
}

QuerySet Query::Result()
{
	result := QuerySet();
	if (!this.with.count) return result;

	first := this.with[0];
	switch (first.kind)
	{
		case (ComponentKind.Common)
		{
			compArr := this.scene.commonComponents.Get(first.id);
			result.entitySet = compArr.entitySet.Clone();
		}
		case (ComponentKind.Sparse)
		{
			compMap := this.scene.sparseComponents.Get(first.id);
			
			maxEntity := uint32(0);
			for (i .. compMap.count)
			{
				entity := compMap.entityArr[i]~;
				if (entity.id > maxEntity) maxEntity = entity.id;
			}

			result.entitySet = BitSet(maxEntity);

			for (i .. compMap.count)
			{
				entity := compMap.entityArr[i]~;
				result.entitySet.Set(entity.id);
			}
		}
		default
		{
			return result;
		}
	}


	for (i := 1 .. this.with.count)
	{
		comp := this.with[i];

		switch (comp.kind)
		{
			case (ComponentKind.Common)
			{
				compArr := this.scene.commonComponents.Get(comp.id);
				for (i .. result.entitySet.bitCount)
				{
					if (result.entitySet[i] && !compArr.Has(Entity(i)))
						result.entitySet.Clear(i);
				}
			}
			case (ComponentKind.Sparse)
			{
				compMap := this.scene.sparseComponents.Get(comp.id);
				for (i .. result.entitySet.bitCount)
				{
					if (result.entitySet[i] && !compMap.Has(Entity(i)))
						result.entitySet.Clear(i);
				}
			}
		}
	}

	for (comp in this.without)
	{
		switch (comp.kind)
		{
			case (ComponentKind.Common)
			{
				compArr := this.scene.commonComponents.Get(comp.id);
				for (i .. result.entitySet.bitCount)
				{
					if (result.entitySet[i] && compArr.Has(Entity(i)))
						result.entitySet.Clear(i);
				}
			}
			case (ComponentKind.Sparse)
			{
				compMap := this.scene.sparseComponents.Get(comp.id);
				for (i .. result.entitySet.bitCount)
				{
					if (result.entitySet[i] && compMap.Has(Entity(i)))
						result.entitySet.Clear(i);
				}
			}
		}
	}

	return result;
}