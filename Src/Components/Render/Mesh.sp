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

meshComponent := ECS.instance.RegisterComponent<Mesh>(
	ComponentKind.Sparse, 
	::(mesh: *Mesh) {
		delete mesh~;
	}
);