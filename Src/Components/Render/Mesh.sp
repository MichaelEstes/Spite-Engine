package Render

import Array
import ECS

state Mesh
{
    primitives: Array<Primitive>
}

Mesh::delete
{
	delete this.primitives;
}

meshComponent := ECS.RegisterComponent<Mesh>(
	ComponentKind.Sparse, 
	::(mesh: *Mesh, scene: Scene) {
		delete mesh~;
	}
);