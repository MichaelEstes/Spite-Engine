package RenderComponents

import Array
import ArrayView
import Vec
import ECS
import Transform
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

    mesh := Mesh(AssetDefNameToHandle("Line"));
    mesh.geometry.topologyKind = TopologyKind.LineList;
    mesh.geometry.indexKind = IndexKind.I16;

    positionIndex := mesh.geometry.GetAttributeIndex("position");
    colorIndex := mesh.geometry.GetAttributeIndex("color");

    mesh.geometry.GetAttributeValue(positionIndex)~ = ArrayView<byte>(positions[0]@ as *byte, #sizeof Vec3 * 2);
    mesh.geometry.GetAttributeValue(colorIndex)~ = ArrayView<byte>(colors[0]@ as *byte, #sizeof Color * 2);
    mesh.geometry.indices = ArrayView<uint16>(indices[0]@, 2);

    scene.SetComponent<Transform>(entity, Transform());
    scene.SetComponent<Mesh>(entity, mesh);
}

BuildThickLine(entity: Entity, lineMesh: *LineMesh, scene: Scene)
{
    positions := [lineMesh.start, lineMesh.start, lineMesh.end, lineMesh.end];
    otherEnds := [lineMesh.end, lineMesh.end, lineMesh.start, lineMesh.start];
    sides := float32:[1.0, -1.0, 1.0, -1.0];
    colors := [lineMesh.color, lineMesh.color, lineMesh.color, lineMesh.color];
    indices := uint16:[0, 1, 2, 2, 1, 3];

    mesh := Mesh(AssetDefNameToHandle("ThickLine"));
    mesh.geometry.topologyKind = TopologyKind.TriangleList;
    mesh.geometry.indexKind = IndexKind.I16;

    positionIndex := mesh.geometry.GetAttributeIndex("position");
    otherEndIndex := mesh.geometry.GetAttributeIndex("otherEnd");
    sideIndex := mesh.geometry.GetAttributeIndex("side");
    colorIndex := mesh.geometry.GetAttributeIndex("color");

    mesh.geometry.GetAttributeValue(positionIndex)~ = ArrayView<byte>(positions[0]@ as *byte, #sizeof Vec3 * 4);
    mesh.geometry.GetAttributeValue(otherEndIndex)~ = ArrayView<byte>(otherEnds[0]@ as *byte, #sizeof Vec3 * 4);
    mesh.geometry.GetAttributeValue(sideIndex)~ = ArrayView<byte>(sides[0]@ as *byte, #sizeof float32 * 4);
    mesh.geometry.GetAttributeValue(colorIndex)~ = ArrayView<byte>(colors[0]@ as *byte, #sizeof Color * 4);
    mesh.geometry.indices = ArrayView<uint16>(indices[0]@, 6);

    thicknessIndex := mesh.geometry.GetVariableIndex("thickness");
    mesh.geometry.GetVariableValue<float32>(thicknessIndex)~ = lineMesh.thickness;

    scene.SetComponent<Transform>(entity, Transform());
    scene.SetComponent<Mesh>(entity, mesh);
}

LineMeshComponent := ECS.RegisterComponent<LineMesh>(
    ComponentKind.Sparse,
    null,
    ::(entity: Entity, lineMesh: *LineMesh, scene: Scene)
    {
        scene.RemoveComponent<Mesh>(entity);

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
