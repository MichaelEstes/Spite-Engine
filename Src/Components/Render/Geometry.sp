package RenderComponents

import Vec
import Common
import ArrayView
import Array

enum GeometryKind: uint16
{
    Triangle,
    TraiangleStrip,
    TriangleFan,
    Line,
    LineStrip,
    LineLoop,
    Point
}

enum IndexKind: uint16
{
    None,
    I16,
    I32
}

// state Geometry
// {
//     vertices: ArrayView<Vec3>,
//     indices: ArrayView<uint16>,
    
//     attributes: Array<ArrayView<byte>>,
//     variables: Array<*void>,

//     defHandle: uint32
// }

// uint32 Geometry::GetAttributeIndex(name: string)
// {
//     vertex := MaterialStageFromHandle(this.defHandle, RenderStage.Vertex);
//     index := FindVariableByName(vertex.attributes, name);
//     return index;
// }

// ref VariableDefinition Geometry::GetAttributeDef(index: uint32)
// {
//     vertex := MaterialStageFromHandle(this.defHandle, RenderStage.Vertex);
//     return vertex.attributes[index];
// }

// uint32 Geometry::GetVariableIndex(name: string)
// {
//     vertex := MaterialStageFromHandle(this.defHandle, RenderStage.Vertex);
//     index := FindVariableByName(vertex.variables, name);
//     return index;
// }

// ref VariableDefinition Geometry::GetVariableDef(index: uint32)
// {
//     vertex := MaterialStageFromHandle(this.defHandle, RenderStage.Vertex);
//     return vertex.variables[index];
// }

state Geometry
{
    vertices: ArrayView<Vec3>,
    indices: ArrayView<uint16>,

    normals: ArrayView<Vec3>,
    tangents: ArrayView<Vec4>,

    colors: ArrayView<Color>,

    uvs: [4]ArrayView<Vec2> = [
        ArrayView<Vec2>(),
        ArrayView<Vec2>(),
        ArrayView<Vec2>(),
        ArrayView<Vec2>()
    ],

    indexKind: IndexKind,
    kind: GeometryKind
}

Geometry::delete
{
}