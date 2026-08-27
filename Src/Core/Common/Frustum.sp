package Common

import Vec
import Matrix

state Frustum
{
    left: Vec4,
    right: Vec4,
    bottom:Vec4,
    top: Vec4,
    near: Vec4,
    far: Vec4
}

ref Frustum Frustum::FromViewProjection(mat: Matrix4)
{
    for (i .. 4)
    {
        this.left[i]   = mat[i][3] + mat[i][0];
        this.right[i]  = mat[i][3] - mat[i][0];
        this.bottom[i] = mat[i][3] + mat[i][1];
        this.top[i]    = mat[i][3] - mat[i][1];
        this.near[i]   = mat[i][2];
        this.far[i]    = mat[i][3] - mat[i][2];
    }

    this.left = this.left / Vec3(this.left).Length();
    this.right = this.right / Vec3(this.right).Length();
    this.bottom = this.bottom / Vec3(this.bottom).Length();
    this.top = this.top / Vec3(this.top).Length();
    this.near = this.near / Vec3(this.near).Length();
    this.far = this.far / Vec3(this.far).Length();

    return this;
}