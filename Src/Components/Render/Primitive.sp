package RenderComponents

import RenderAssetDef

state Primitive
{
    geometry: Geometry,
    material: Material,

    defHandle: AssetDefHandle
}

Primitive::(defHandle: AssetDefHandle)
{
    this.defHandle = defHandle;
    this.geometry = Geometry(defHandle);
    this.material = Material(defHandle);
}

Primitive::delete
{
    delete this.geometry;
    delete this.material;
}