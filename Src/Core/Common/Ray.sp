package Common

import Vec

RayInf: float32 = 1000000000000000000000000000000.0;

state RayIntersection
{
    dist: float32 = RayInf
}

state Ray
{
    origin: Vec3,
    direction: Vec3
}

Ray::(origin: Vec3, direction: Vec3)
{
    this.origin = origin;
    this.direction = direction;
}

bool Ray::IntersectTri(tri: Triangle, intersection: *RayIntersection)
{
    intersection~ = RayIntersection();
    edge1 := tri.verts[1] - tri.verts[0];
    edge2 := tri.verts[2] - tri.verts[0];
    triNorm := edge1.Cross(edge2);
    rayDotNorm := triNorm.Dot(this.direction);
    if (rayDotNorm >= 0.0) return false;

    triPoint := tri.verts[0];
    pointToPlaneDir := triPoint - this.origin;
    planeNormDotPointToPlaneDir := triNorm.Dot(pointToPlaneDir);
    rayDirDotPlaneNorm := this.direction.Dot(triNorm);

    dist := planeNormDotPointToPlaneDir / rayDirDotPlaneNorm;
    intersection.dist = dist;
    if (dist < 0.0) return false;

    scaledDir := this.direction * dist;
    pointOnPlane := this.origin + scaledDir;

    tri0ToPoint := pointOnPlane - tri.verts[0];
    if (triNorm.Dot(edge1.Cross(tri0ToPoint)) < 0.0) return false;

    edge1To2 := tri.verts[2] - tri.verts[1];
    tri1ToPoint := pointOnPlane - tri.verts[1];
    if (triNorm.Dot(edge1To2.Cross(tri1ToPoint)) < 0.0) return false;

    edge2To0 := tri.verts[0] - tri.verts[2];
    tri2ToPoint := pointOnPlane - tri.verts[2];
    if (triNorm.Dot(edge2To0.Cross(tri2ToPoint)) < 0.0) return false;

    return true;
}