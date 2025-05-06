package Render

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
    indicies: Array<uint32>,
    vertices: Array<float32>,
    kind: GeometryKind
}