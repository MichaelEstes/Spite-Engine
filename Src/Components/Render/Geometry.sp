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