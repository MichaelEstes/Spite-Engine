package Render

state Primitive
{
    geometry: Geometry,
    material: Material
}

Primitive::delete
{
    delete this.geometry;
    delete this.material;
}