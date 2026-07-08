package Editor

import ImGui

state TypeValue
{
    meta: *_Type,
    val: *any
}

ByteValueEditor(label: string, val: *byte)
{
    ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_S8, val);
}

UByteValueEditor(label: string, val: *ubyte)
{
    ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_U8, val);
}

Int16ValueEditor(label: string, val: *int16)
{
    ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_S16, val);
}

UInt16ValueEditor(label: string, val: *uint16)
{
    ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_U16, val);
}

Int32ValueEditor(label: string, val: *int32)
{
    ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_S32, val);
}

UInt32ValueEditor(label: string, val: *uint32)
{
    ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_U32, val);
}

IntValueEditor(label: string, val: *int)
{
    ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_S64, val);
}

UIntValueEditor(label: string, val: *uint)
{
    ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_U64, val);
}

Float32ValueEditor(label: string, val: *float32)
{
    ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_Float, val);
}

Float64ValueEditor(label: string, val: *float64)
{
    ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_Double, val);
}

BoolValueEditor(label: string, val: *bool)
{
    ImGui_Checkbox(label[0], val);
}

TypeValueEditor(label: string, val: TypeValue)
{
    type := val.meta;
    typeData := type.type;
    valuePtr := val.val;

    switch (type.kind)
    {
        case (_TypeKind.PrimitiveType)
        {
            switch (typeData.primitive.primitiveKind)
            {
                case (_PrimitiveKind.Bool) BoolValueEditor(label, valuePtr);
                case (_PrimitiveKind.Byte)
                {
                    if (typeData.primitive.isSigned) ByteValueEditor(label, valuePtr);
                    else UByteValueEditor(label, valuePtr);
                }
                case (_PrimitiveKind.I16)
                {
                    if (typeData.primitive.isSigned) Int16ValueEditor(label, valuePtr);
                    else UInt16ValueEditor(label, valuePtr);
                }
                case (_PrimitiveKind.I32)
                {
                    if (typeData.primitive.isSigned) Int32ValueEditor(label, valuePtr);
                    else UInt32ValueEditor(label, valuePtr);
                }
                case (_PrimitiveKind.I64) continue;
                case (_PrimitiveKind.Int)
                {
                    if (typeData.primitive.isSigned) IntValueEditor(label, valuePtr);
                    else UIntValueEditor(label, valuePtr);
                }
                case (_PrimitiveKind.F32) Float32ValueEditor(label, valuePtr);
                case (_PrimitiveKind.Float) Float64ValueEditor(label, valuePtr);
            }
        }
        case (_TypeKind.StateType)
        {
            _state := typeData.stateType;
            if (ImGui_TreeNode(label[0]))
            {
                for (member: **_Member in _state.members)
                {
                    memberLabel := member.value.name.ToString();
                    memberPtr := (valuePtr as *byte) + member.offset;
                    TypeValueEditor(memberLabel, { member.value.type, memberPtr } as TypeValue);
                }

                ImGui_TreePop();
            }
        }
        case (_TypeKind.StructureType) {}
        case (_TypeKind.UnionType) {}
        case (_TypeKind.FunctionType) continue;
        case (_TypeKind.PointerType) {}
        case (_TypeKind.ReferenceType) {}
        case (_TypeKind.DynamicArrayType) {}
        case (_TypeKind.FixedArrayType) {}
    }
}