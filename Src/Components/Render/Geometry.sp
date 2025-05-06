package Render

import Vec
import Color

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
    vertices: Array<Vec3>,
    indicies: Array<uint32>,

    normals: Array<Vec3>,
    uvs: Array<Array<Vec2>>,

    colors: Array<Array<Color>>,

    kind: GeometryKind
}