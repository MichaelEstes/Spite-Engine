package RenderComponents

import RenderAssetDef
import Vec
import Common
import ArrayView
import Array
import Resource

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
    bounds: AABB,

    defHandle: AssetDefHandle,
        
    topologyKind: TopologyKind = TopologyKind.TriangleList,
    indexKind: IndexKind
}

Geometry::(defHandle: AssetDefHandle)
{
    this.defHandle = defHandle;
    this.Allocate();
}

Geometry::delete
{
    delete this.attributes;
    FreeFragmentVariableSet(this.defHandle, this.variables);
}

Geometry::Allocate()
{
    defHandle := this.defHandle;
    this.variables = AllocateVertexVariableSet(defHandle);

    attrCount := GetAssetDefVertexAttributeCount(defHandle);
    this.attributes.SizeTo(attrCount);
    for (i .. attrCount) this.attributes.Add(ArrayView<byte>());
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
    positions := this.GetPositionAttr();
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

    center := Vec3(
        (min.x + max.x) * 0.5,
        (min.y + max.y) * 0.5,
        (min.z + max.z) * 0.5
    );
    this.bounds.center = Vec4(center, 1.0);
    this.bounds.half = Vec4(max - center, 1.0);
}

ArrayView<Vec3> Geometry::GetPositionAttr() => this.attributes[0] as ArrayView<Vec3>;

uint32 Geometry::GetIndexCount() =>
{
    if (this.indexKind == IndexKind.None)
    {
        return this.GetPositionAttr().count;
    }

    return this.indices.count;
}

uint32 Geometry::GetIndex(i: uint32) =>
{
    if (this.indexKind == IndexKind.I16)
    {
        return this.indices[i];
    }
    else if (this.indexKind == IndexKind.I32)
    {
        return (this.indices as ArrayView<uint32>)[i];
    }

    return i;
}

state GeoTriangleIterator
{
    geo: *Geometry
}

Iterator GeoTriangleIterator::operator::in()
{
	return {null, -3};
}

bool GeoTriangleIterator::next(it: Iterator)
{
	it.index += 3;
	return it.index + 2 < this.geo.GetIndexCount();
}

Triangle GeoTriangleIterator::current(it: Iterator)
{
	positions := this.geo.GetPositionAttr();
	return Triangle(
		positions[this.geo.GetIndex(it.index)],
		positions[this.geo.GetIndex(it.index + 1)],
		positions[this.geo.GetIndex(it.index + 2)]
	);
}

GeoTriangleIterator Geometry::IterateTriangles()
{
    return GeoTriangleIterator:{this@};
}

