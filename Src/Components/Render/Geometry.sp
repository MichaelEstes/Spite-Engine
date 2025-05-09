package Render

import Vec
import Color
import ArrayView
import Array

enum GeometryKind: uint32
{
    Triangle,
    TraiangleStrip,
    TriangleFan,
    Line,
    LineStrip,
    LineLoop,
    Point
}

state Geometry
{
    vertices: ArrayView<Vec3>,
    indices: ArrayView<uint16>,

    normals: ArrayView<Vec3>,
    tangents: ArrayView<Vec4>,

    uvs: Array<ArrayView<Vec2>>,

    colors: Array<ArrayView<Color>>,

    kind: GeometryKind
}