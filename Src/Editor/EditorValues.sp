package Editor

import ImGui

state EditorTypedValue
{
    meta: *_Type,
    val: *any
}

bool ByteValueEditor(label: string, val: *byte)
{
    return ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_S8, val);
}

bool UByteValueEditor(label: string, val: *ubyte)
{
    return ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_U8, val);
}

bool Int16ValueEditor(label: string, val: *int16)
{
    return ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_S16, val);
}

bool UInt16ValueEditor(label: string, val: *uint16)
{
    return ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_U16, val);
}

bool Int32ValueEditor(label: string, val: *int32)
{
    return ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_S32, val);
}

bool UInt32ValueEditor(label: string, val: *uint32)
{
    return ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_U32, val);
}

bool IntValueEditor(label: string, val: *int)
{
    return ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_S64, val);
}

bool UIntValueEditor(label: string, val: *uint)
{
    return ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_U64, val);
}

bool Float32ValueEditor(label: string, val: *float32)
{
    return ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_Float, val);
}

bool Float64ValueEditor(label: string, val: *float64)
{
    return ImGui_InputScalar(label[0], ImGuiDataType_.ImGuiDataType_Double, val);
}

bool BoolValueEditor(label: string, val: *bool)
{
    return ImGui_Checkbox(label[0], val);
}

bool TypeValueEditor(label: string, val: EditorTypedValue)
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
                case (_PrimitiveKind.Bool) return BoolValueEditor(label, valuePtr);
                case (_PrimitiveKind.Byte)
                {
                    if (typeData.primitive.isSigned) return ByteValueEditor(label, valuePtr);
                    else return UByteValueEditor(label, valuePtr);
                }
                case (_PrimitiveKind.I16)
                {
                    if (typeData.primitive.isSigned) return Int16ValueEditor(label, valuePtr);
                    else return UInt16ValueEditor(label, valuePtr);
                }
                case (_PrimitiveKind.I32)
                {
                    if (typeData.primitive.isSigned) return Int32ValueEditor(label, valuePtr);
                    else return UInt32ValueEditor(label, valuePtr);
                }
                case (_PrimitiveKind.I64) continue;
                case (_PrimitiveKind.Int)
                {
                    if (typeData.primitive.isSigned) return IntValueEditor(label, valuePtr);
                    else return UIntValueEditor(label, valuePtr);
                }
                case (_PrimitiveKind.F32) return Float32ValueEditor(label, valuePtr);
                case (_PrimitiveKind.Float) return Float64ValueEditor(label, valuePtr);
            }
        }
        case (_TypeKind.StateType)
        {
            _state := typeData.stateType;
            if (ImGui_TreeNode(label[0]))
            {
                changed := false;
                for (member: **_Member in _state.members)
                {
                    memberLabel := member.value.name.ToString();
                    memberPtr := (valuePtr as *byte) + member.offset;
                    memberChanged := TypeValueEditor(memberLabel, EditorTypedValue:{ member.value.type, memberPtr });
                    changed = changed | memberChanged;
                }

                ImGui_TreePop();
                return changed;
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

    return false;
}