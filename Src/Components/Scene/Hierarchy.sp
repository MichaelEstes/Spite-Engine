package SceneComponents

import ECS
import Array

state Hierarchy
{
	parent: Entity,
	children := EntitySet()
}

HierarchyComponent := ECS.RegisterComponent<Hierarchy>(
	ComponentKind.Common, 
	::(entity: Entity, hierarchy: *Hierarchy, scene: Scene) 
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

IterateHierarchy(entity: Entity, scene: *Scene, iterateFunc: ::(Entity, *Scene))
{
	iterateFunc(entity, scene);

	hierarchy := scene.GetComponentDirect<Hierarchy>(entity, HierarchyComponent);
	for (child in hierarchy.children)
	{
		IterateHierarchy(child, scene, iterateFunc);
	}
}