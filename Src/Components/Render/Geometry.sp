package RenderComponents

import RenderAssetDef
import Vec
import Common
import ArrayView
import Array

state GeometryVariableUpdate
{
    geometry: *Geometry,
    index: uint32
}

state GeometryAttributeUpdate
{
    geometry: *Geometry,
    index: uint32
}

GeometryVariableUpdateEvent := RegisterEvent<GeometryVariableUpdate>();
GeometryAttributeUpdateEvent := RegisterEvent<GeometryAttributeUpdate>();

enum TopologyKind: ubyte
{
    PointList
    LineList,
    LineStrip,
    TriangleList,
    TraiangleStrip,
    TriangleFan,
    LineLoop,
}

enum IndexKind: ubyte
{
    None,
    I16,
    I32
}

state Geometry
{
    attributes: Array<ArrayView<byte>>,
    variables: *void,
    indices: ArrayView<uint16>,
    bounds: BoundingBox,

    defHandle: AssetDefHandle,
        
    topologyKind: TopologyKind = TopologyKind.TriangleList,
    indexKind: IndexKind
}

Geometry::(defHandle: AssetDefHandle)
{
    this.defHandle = defHandle;
    this.variables = AllocateVertexVariableSet(defHandle);

    attrCount := GetAssetDefVertexAttributeCount(defHandle);
    this.attributes.SizeTo(attrCount);
    for (i .. attrCount) this.attributes.Add(ArrayView<byte>());
}

Geometry::delete
{
    delete this.attributes;
    delete this.variables;
}

uint32 Geometry::GetAttributeIndex(name: string)
{
    assetDef := GetAssetDefWithHandle(this.defHandle);
    vertex := assetDef.vertex;
    index := FindVariableIndexByName(vertex.attributes, name);
    return index;
}

ref VariableDefinition Geometry::GetAttributeDef(index: uint32)
{
    assetDef := GetAssetDefWithHandle(this.defHandle);
    vertex := assetDef.vertex;
    var := vertex.attributes[index];
    return var.def;
}

*ArrayView<byte> Geometry::GetAttributeValue(index: uint32)
{
    return this.attributes[index]@;
}

uint32 Geometry::GetVariableIndex(name: string)
{
    assetDef := GetAssetDefWithHandle(this.defHandle);
    vertex := assetDef.vertex;
    return FindVariableIndexByName(vertex.variables.sets, name);
}

ref VariableDefinition Geometry::GetVariableDef(index: uint32)
{
    assetDef := GetAssetDefWithHandle(this.defHandle);
    vertex := assetDef.vertex;
    var := vertex.variables.sets[index];
    return var.def;
}

*T Geometry::GetVariableValue<T>(index: uint32)
{
    assetDef := GetAssetDefWithHandle(this.defHandle);
    vertex := assetDef.vertex;
    offset := FindVariableSetOffsetAtIndex(vertex.variables, index);
    return (this.variables + offset) as *T;
}

Geometry::UpdatedVariableSet(index: uint32)
{
    event := GeometryVariableUpdate();
    event.geometry = this@;
    event.index = index;
    ECS.instance.events.Emit<GeometryVariableUpdate>(GeometryVariableUpdateEvent, event);
}

Geometry::UpdatedAttribute(index: uint32)
{
    event := GeometryAttributeUpdate();
    event.geometry = this@;
    event.index = index;
    ECS.instance.events.Emit<GeometryAttributeUpdate>(GeometryAttributeUpdateEvent, event);
}

Geometry::ComputeBounds()
{
    positions := this.attributes[0]~ as ArrayView<Vec3>;
    positions.count = positions.count / #sizeof Vec3;

    min := positions[0]~;
    max := positions[0]~;

    for (i := 1 .. positions.count)
    {
        point := positions[i];
        
        if (point.x < min.x) min.x = point.x;
        if (point.y < min.y) min.y = point.y;
        if (point.z < min.z) min.z = point.z;

        if (point.x > max.x) max.x = point.x;
        if (point.y > max.y) max.y = point.y;
        if (point.z > max.z) max.z = point.z;
    }

    this.bounds.min = min;
    this.bounds.max = max;
}
