package RenderComponents

import Array
import ArrayView
import Vec
import ECS
import Transform
import RenderAssetDef
import Common
import Math

state SphereMesh
{
    color: Color,
    radius: float32,
    widthSegments: uint32,
    heightSegments: uint32
}

SphereMesh::(radius: float32, widthSegments: uint32, heightSegments: uint32, color: Color = Color(1.0, 1.0, 1.0, 1.0))
{
    this.radius = radius;
    this.widthSegments = widthSegments;
    this.heightSegments = heightSegments;
    this.color = color;
}

SphereMeshComponent := ECS.RegisterComponent<SphereMesh>(
    ComponentKind.Sparse,
    null,
    ::(entity: Entity, sphereMesh: *SphereMesh, scene: Scene)
    {
        scene.RemoveComponent<Mesh>(entity);

        points := Array<Vec3>();
        indices := Array<uint16>();

        radius := sphereMesh.radius;
        vertical := sphereMesh.heightSegments;
        horizontal := sphereMesh.widthSegments;

        for (i .. vertical + 1)
        {
            for (j .. horizontal + 1)
            {
                x := radius * Math.Sin(Math.Pi * i / vertical) * Math.Cos(Math.Pi * 2 * j / horizontal);
                y := radius * Math.Sin(Math.Pi * i / vertical) * Math.Sin(Math.Pi * 2 * j / horizontal);
                z := radius * Math.Cos(Math.Pi * i / vertical);
                points.Add(Vec3(x, y, z));
            }
        }

        for (i .. vertical)
        {
            for (j .. horizontal)
            {
                a := i * (horizontal + 1) + j;
                b := (i + 1) * (horizontal + 1) + j;
                c := (i + 1) * (horizontal + 1) + j + 1;
                d := i * (horizontal + 1) + j + 1;

                indices.Add(a);
                indices.Add(b);
                indices.Add(c);

                indices.Add(a);
                indices.Add(c);
                indices.Add(d);
            }
        }

        mesh := Mesh(AssetDefNameToHandle("Line"));
        mesh.geometry.topologyKind = TopologyKind.TriangleList;
        mesh.geometry.indexKind = IndexKind.I16;

        positionIndex := mesh.geometry.GetAttributeIndex("position");

        mesh.geometry.GetAttributeValue(positionIndex)~ = ArrayView<byte>(points[0]@ as *byte, #sizeof Vec3 * points.count);
        mesh.geometry.indices = ArrayView<uint16>(indices[0]@, indices.count);
        
        colorIndex := mesh.material.GetVariableIndex("color");
        mesh.material.GetVariableValue<Color>(colorIndex)~ = sphereMesh.color;

        scene.SetComponent<Mesh>(entity, mesh);
    }
);
