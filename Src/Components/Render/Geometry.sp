package RenderComponents

import RenderAssetDef
import Vec
import Common
import ArrayView
import Array

state GeometryVariableUpdate
{
    geometry: *Geometry,
    index: VariableSetIndex
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

    defHandle: AssetDefHandle,

    gpuResourceID: uint32 = uint32(0),

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

VariableSetIndex Geometry::GetVariableIndex(name: string)
{
    assetDef := GetAssetDefWithHandle(this.defHandle);
    vertex := assetDef.vertex;
    index := FindVariableSetIndexByName(vertex.variables, name);
    return index;
}

ref VariableDefinition Geometry::GetVariableDef(index: VariableSetIndex)
{
    assetDef := GetAssetDefWithHandle(this.defHandle);
    vertex := assetDef.vertex;
    set := vertex.variables.sets[index.setIndex];
    var := set[index.varIndex];
    return var.def;
}

*T Geometry::GetVariableValue<T>(index: VariableSetIndex)
{
    assetDef := GetAssetDefWithHandle(this.defHandle);
    vertex := assetDef.vertex;
    offset := FindVariableSetOffsetAtIndex(vertex.variables, index);
    return (this.variables + offset) as *T;
}

Geometry::UpdatedVariableSet(index: VariableSetIndex)
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

