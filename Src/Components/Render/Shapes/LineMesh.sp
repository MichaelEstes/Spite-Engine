package RenderComponents

import Array
import ArrayView
import Vec
import ECS
import RenderAssetDef
import Common

state LineMesh
{
    start: Vec3,
    end: Vec3,
    color: Color,
    thickness: float32 = 1.0
}

LineMesh::(start: Vec3, end: Vec3, color: Color, thickness: float32 = 1.0)
{
    this.start = start;
    this.end = end;
    this.color = color;
    this.thickness = thickness;
}

BuildThinLine(entity: Entity, lineMesh: *LineMesh, scene: Scene)
{
    positions := [lineMesh.start, lineMesh.end];
    colors := [lineMesh.color, lineMesh.color];
    indices := uint16:[0, 1];

    primitive := Primitive(AssetDefNameToHandle("Line"));
    primitive.geometry.topologyKind = TopologyKind.LineList;
    primitive.geometry.indexKind = IndexKind.I16;

    positionIndex := primitive.geometry.GetAttributeIndex("position");
    colorIndex := primitive.geometry.GetAttributeIndex("color");

    primitive.geometry.GetAttributeValue(positionIndex)~ =
        ArrayView<byte>(positions[0]@ as *byte, #sizeof Vec3 * 2);
    primitive.geometry.GetAttributeValue(colorIndex)~ =
        ArrayView<byte>(colors[0]@ as *byte, #sizeof Color * 2);
    primitive.geometry.indices = ArrayView<uint16>(indices[0]@, 2);

    mesh := Mesh();
    mesh.primitives.Add(primitive);
    scene.SetComponent<Mesh>(entity, mesh);
}

BuildThickLine(entity: Entity, lineMesh: *LineMesh, scene: Scene)
{
    positions := [lineMesh.start, lineMesh.start, lineMesh.end, lineMesh.end];
    otherEnds := [lineMesh.end, lineMesh.end, lineMesh.start, lineMesh.start];
    sides := float32:[1.0, -1.0, 1.0, -1.0];
    colors := [lineMesh.color, lineMesh.color, lineMesh.color, lineMesh.color];
    indices := uint16:[0, 1, 2, 2, 1, 3];

    primitive := Primitive(AssetDefNameToHandle("ThickLine"));
    primitive.geometry.topologyKind = TopologyKind.TriangleList;
    primitive.geometry.indexKind = IndexKind.I16;

    positionIndex := primitive.geometry.GetAttributeIndex("position");
    otherEndIndex := primitive.geometry.GetAttributeIndex("otherEnd");
    sideIndex := primitive.geometry.GetAttributeIndex("side");
    colorIndex := primitive.geometry.GetAttributeIndex("color");

    primitive.geometry.GetAttributeValue(positionIndex)~ =
        ArrayView<byte>(positions[0]@ as *byte, #sizeof Vec3 * 4);
    primitive.geometry.GetAttributeValue(otherEndIndex)~ =
        ArrayView<byte>(otherEnds[0]@ as *byte, #sizeof Vec3 * 4);
    primitive.geometry.GetAttributeValue(sideIndex)~ =
        ArrayView<byte>(sides[0]@ as *byte, #sizeof float32 * 4);
    primitive.geometry.GetAttributeValue(colorIndex)~ =
        ArrayView<byte>(colors[0]@ as *byte, #sizeof Color * 4);
    primitive.geometry.indices = ArrayView<uint16>(indices[0]@, 6);

    thicknessIndex := primitive.geometry.GetVariableIndex("thickness");
    primitive.geometry.GetVariableValue<float32>(thicknessIndex)~ = lineMesh.thickness;

    mesh := Mesh();
    mesh.primitives.Add(primitive);
    scene.SetComponent<Mesh>(entity, mesh);
}

LineMeshComponent := ECS.RegisterComponent<LineMesh>(
    ComponentKind.Sparse,
    null,
    ::(entity: Entity, lineMesh: *LineMesh, scene: Scene)
    {
        if (lineMesh.thickness > 1.0)
        {
            BuildThickLine(entity, lineMesh, scene);
        }
        else
        {
            BuildThinLine(entity, lineMesh, scene);
        }
    }
);
