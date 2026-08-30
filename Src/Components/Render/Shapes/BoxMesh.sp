package RenderComponents

import Array
import ArrayView
import Vec
import ECS
import Transform
import RenderAssetDef
import Common

state BoxMesh
{
    color: Color,
    width: float32,
    height: float32,
    depth: float32
}

BoxMesh::(width: float32, height: float32, depth: float32, color: Color)
{
    this.color = color;
    this.width = width;
    this.height = height;
    this.depth = depth;
}

BoxMeshComponent := ECS.RegisterComponent<BoxMesh>(
    ComponentKind.Sparse,
    null,
    ::(entity: Entity, boxMesh: *BoxMesh, scene: Scene)
    {
        scene.RemoveComponent<Mesh>(entity);

        halfWidth := boxMesh.width * 0.5;
        halfHeight := boxMesh.height * 0.5;
        halfDepth := boxMesh.depth * 0.5;

        positions := [
            Vec3(-halfWidth, -halfHeight, -halfDepth),
            Vec3(halfWidth, -halfHeight, -halfDepth),
            Vec3(-halfWidth, halfHeight, -halfDepth),
            Vec3(halfWidth, halfHeight, -halfDepth),
            Vec3(-halfWidth, -halfHeight, halfDepth),
            Vec3(halfWidth, -halfHeight, halfDepth),
            Vec3(-halfWidth, halfHeight, halfDepth),
            Vec3(halfWidth, halfHeight, halfDepth)
        ];
        colors := [
            boxMesh.color, boxMesh.color, boxMesh.color, boxMesh.color,
            boxMesh.color, boxMesh.color, boxMesh.color, boxMesh.color
        ];
        indices := uint16:[
            4, 5, 6, 6, 5, 7,
            1, 0, 3, 3, 0, 2,
            0, 4, 2, 2, 4, 6,
            5, 1, 7, 7, 1, 3,
            6, 7, 2, 2, 7, 3,
            0, 1, 4, 4, 1, 5
        ];

        mesh := Mesh(AssetDefNameToHandle("Line"));
        mesh.geometry.topologyKind = TopologyKind.TriangleList;
        mesh.geometry.indexKind = IndexKind.I16;

        positionIndex := mesh.geometry.GetAttributeIndex("position");
        colorIndex := mesh.geometry.GetAttributeIndex("color");

        mesh.geometry.GetAttributeValue(positionIndex)~ = ArrayView<byte>(positions[0]@ as *byte, #sizeof Vec3 * 8);
        mesh.geometry.GetAttributeValue(colorIndex)~ = ArrayView<byte>(colors[0]@ as *byte, #sizeof Color * 8);
        mesh.geometry.indices = ArrayView<uint16>(indices[0]@, 36);

        scene.SetComponent<Transform>(entity, Transform());
        scene.SetComponent<Mesh>(entity, mesh);
    }
);
