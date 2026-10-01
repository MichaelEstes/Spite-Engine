package Common

import Vec

state Triangle
{
    verts: [3]Vec3
}

Triangle::(a: Vec3, b: Vec3, c: Vec3)
{
    this.verts = Vec3:[a, b, c];
}