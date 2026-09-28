package ECS

state EntityTagComponentIterator
{
	scene: *Scene,
	container: *BitSet,
	kind: ComponentKind
}

EntityTagComponentIterator::(scene: *Scene, componentKind: ComponentKind, 
							 container: *BitSet)
{
	this.scene = scene;
	this.container = container;
	this.kind = componentKind;
}

Iterator EntityTagComponentIterator::operator::in()
{
	return {null, -1};
}

bool EntityTagComponentIterator::next(it: Iterator)
{
	if (!this.container) return false;
	it.index += 1;
	bitSet := this.container~;
	while (it.index < bitSet.bitCount && !bitSet[it.index]) it.index += 1;
	return it.index < bitSet.bitCount;
}

Entity EntityTagComponentIterator::current(it: Iterator)
{
	return this.scene.RegisterEntity(it.index);
}