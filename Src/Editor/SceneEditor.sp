package Editor

import ECS
import Array
import ArrayView

state SceneEntityComponents
{
    common: ArrayView<Component>,
    sparse: ArrayView<Component>,
    entity: Entity
}

state SceneEntityIterator
{
    scene: *Scene,
    common := Array<Component>(),
    sparse := Array<Component>()
}

SceneEntityIterator::(scene: *Scene)
{
    this.scene = scene;
}

SceneEntityIterator::delete
{
	delete this.common;
	delete this.sparse;
}

Entity SceneEntityIterator::GetEntity(id: uint32)
{
	return Entity(id, uint16(0));
}

Iterator SceneEntityIterator::operator::in()
{
	return {null, -1};
}

bool SceneEntityIterator::next(it: Iterator)
{
	it.index += 1;

    this.common.Clear();
	this.sparse.Clear();

	while (it.index < this.scene.currEntity.Load())
	{
		this.Populate(this.GetEntity(it.index + 1));
		if (this.common.count || this.sparse.count) return true;

		it.index += 1;
	}

	return false;
}

SceneEntityIterator::Populate(entity: Entity)
{
	for (kv in this.scene.commonComponents)
	{
		if (kv.value.Has(entity.id)) this.common.Add(ECS.instance.GetComponentByID(kv.key));
	}

	for (kv in this.scene.sparseComponents)
	{
		if (kv.value.Has(entity.id)) this.sparse.Add(ECS.instance.GetComponentByID(kv.key));
	}
}

SceneEntityComponents SceneEntityIterator::current(it: Iterator)
{
    commonArrView := ArrayView<Component>(this.common[0]@, this.common.count);
    sparseArrView := ArrayView<Component>(this.sparse[0]@, this.sparse.count);
	return { commonArrView, sparseArrView, this.GetEntity(it.index + 1) } as SceneEntityComponents;
}

SceneEntityIterator IterateSceneEntities(scene: *Scene)
{
    return SceneEntityIterator(scene);
}

*_Type GetTypeForComponent(component: Component)
{
    return ECS.instance.componentTypeSet.Get(component.id)~;
}
