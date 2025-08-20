package Hierarchy

import ECS
import Array

state Hierarchy
{
	parent: Entity,
	children := EntitySet()
}

HierarchyComponent := ECS.RegisterComponent<Hierarchy>(
	ComponentKind.Common, 
	::(hierarchy: *Hierarchy, scene: Scene) 
	{
		delete hierarchy.children;
	}
);

ParentEntity(parent: Entity, child: Entity, scene: *Scene)
{
	parentHierarchy := scene.GetComponentDirect<Hierarchy>(parent, HierarchyComponent);
	childHierarchy := scene.GetComponentDirect<Hierarchy>(child, HierarchyComponent);

	if (childHierarchy.parent.id)
	{
		prevParentHierarchy := scene.GetComponentDirect<Hierarchy>(childHierarchy.parent, HierarchyComponent);
		prevParentHierarchy.children.Remove(child);
	}

	parentHierarchy.children.Insert(child);
	childHierarchy.parent = parent;
}