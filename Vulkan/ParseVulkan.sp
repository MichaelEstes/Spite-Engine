package ParseVulkan

import JSON

enum VulkanTypeKind
{
	Named,
	Pointer,
	Array,
	Primitive,
	Union
}

state VulkanPrimitiveType
{
	size: uint,
	signed: bool
}

state VulkanType
{
	kind: VulkanTypeKind,
	type: ?{
		name: string,
		pointer: *VulkanType,
		array: {size: uint, type: *VulkanType},
		primitive: VulkanPrimitiveType,
		union: []{name: string, type: *VulkanType}
	}
}

state VulkanFunction
{
	name: string,
	params: []{name: string, type: *VulkanType},
	returnType: *VulkanType
}

state VulkanStruct
{
	name: string,
	members: []{name: string, type: *VulkanType}
}

state VulkanEnum
{
	name: string,
	fields: []{name: string, value: uint}
}

string GetTag(obj: *JSONObject) => obj.GetMember("tag").String().value;
string GetName(obj: *JSONObject) => obj.GetMember("name").String().value;
*JSONObject GetType(obj: *JSONObject) => obj.GetMember("type").Object();

typeDefLookup := Map<string, *JSONObject>();
unionLookup := Map<string, *JSONObject>();

ParseHeaderJSON(file: string)
{
	functions := []VulkanFunction;
	structs := []VulkanStruct;
	enums := []VulkanEnum;
	json := JSON.ParseJSONFile(file);
	arr := json.root.Array();
	log arr.values.count;

	for (val in arr.values)
	{
		obj := val.Object();
		tag := GetTag(obj);
		if (tag == "typedef")
		{
			name := GetName(obj);
			type := obj.GetMember("type").Object();
			typeDefLookup.Insert(name, type);
		}

		if (tag == "union")
		{
			name := GetName(obj);
			unionLookup.Insert(name, obj);
		}
	}

	for (val in arr.values)
	{
		obj := val.Object();
		tag := GetTag(obj);
		//if (tag == "function")
		//{
		//	ParseVulkanFunction(obj, functions);
		//}

		if (tag == "struct")
		{
			ParseVulkanStruct(obj, structs);
		}

		//if (tag == "enum")
		//{
		//	ParseVulkanEnum(obj, enums);
		//}
	}

	//PrintFunctions(functions);
	//PrintStructs(structs);
}

ParseVulkanFunction(obj: *JSONObject, functions: []VulkanFunction)
{
	function := VulkanFunction();
	function.name = GetName(obj);
	params := obj.GetMember("parameters").Array();
	for (param in params.values)
	{
		paramObj := param.Object();
		paramName := GetName(paramObj);
		typeObj := GetType(paramObj);
		type := ParseVulkanType(typeObj);
		function.params.Add({paramName, type});
	}
	function.returnType = ParseVulkanType(obj.GetMember("return-type").Object());

	log PrintFunction(function);
	functions.Add(function);
}

*VulkanType ParseVulkanType(obj: *JSONObject)
{
	tag := GetTag(obj);
	type := new VulkanType();
	if (tag == ":pointer")
	{
		type.kind = VulkanTypeKind.Pointer;
		type.type.pointer = ParseVulkanType(GetType(obj));
	}
	else if (tag == ":array")
	{
		type.kind = VulkanTypeKind.Array;
		type.type.array.size = obj.GetMember("size").Number().value as uint;
		type.type.array.type = ParseVulkanType(GetType(obj));
	}
	else if (tag == ":void")
	{
		type.kind = VulkanTypeKind.Named;
		type.type.name = "void";
	}
	else if (tag == ":float")
	{
		type.kind = VulkanTypeKind.Named;
		type.type.name = "float32";
	}
	else if (tag == ":int")
	{
		type.kind = VulkanTypeKind.Named;
		type.type.name = "int32";
	}
	else if (tag == ":unsigned-int")
	{
		type.kind = VulkanTypeKind.Named;
		type.type.name = "uint32";
	}
	else if (tag == ":long")
	{
		type.kind = VulkanTypeKind.Named;
		type.type.name = "int64";
	}
	else if (tag == ":unsigned-long")
	{
		type.kind = VulkanTypeKind.Named;
		type.type.name = "uint64";
	}
	else if (tag == ":signed-char")
	{
		type.kind = VulkanTypeKind.Named;
		type.type.name = "byte";
	}
	else if (tag == ":char")
	{
		type.kind = VulkanTypeKind.Named;
		type.type.name = "byte";
	}
	else if (tag == ":unsigned-char")
	{
		type.kind = VulkanTypeKind.Named;
		type.type.name = "ubyte";
	}
	else if (tag == ":short")
	{
		type.kind = VulkanTypeKind.Named;
		type.type.name = "int16";
	}
	else if (tag == ":unsigned-short")
	{
		type.kind = VulkanTypeKind.Named;
		type.type.name = "uint16";
	}
	else if (tag == ":function-pointer")
	{
		type.kind = VulkanTypeKind.Named;
		type.type.name = "::()";
	}
	else if (tag == ":enum" || tag == ":struct" || tag == "struct")
	{
		type.kind = VulkanTypeKind.Named;
		type.type.name = GetName(obj);
	}
	else if (tag == ":union")
	{
		type.kind = VulkanTypeKind.Union;

		unionName := GetName(obj);
		unionObj := unionLookup.Find(unionName)~;

		fields := unionObj.GetMember("fields").Array();
		unionValues := []{name: string, type: *VulkanType};

		for (field in fields.values)
		{
			fieldObj := field.Object();
			name := GetName(fieldObj);
			unionType := GetType(fieldObj);
			value := {name, ParseVulkanType(unionType)};
			unionValues.Add(value);
		}
		type.type.union = unionValues;
	}
	else
	{
		if (typeDefLookup.Has(tag))
		{
			return ParseVulkanType(typeDefLookup[tag]~);
		}
		type.kind = VulkanTypeKind.Named;
		type.type.name = tag;
	}

	return type;
}

string PrintType(type: *VulkanType)
{
	if (type.kind == VulkanTypeKind.Pointer)
	{
		return "*" + PrintType(type.type.pointer);
	}
	else if (type.kind == VulkanTypeKind.Array)
	{
		return "[" + IntToString(type.type.array.size) + "]" + PrintType(type.type.array.type);
	}
	else if (type.kind == VulkanTypeKind.Union)
	{
		str := "?{";
		for (i .. type.type.union.count)
		{
			value := type.type.union[i];
			str = str + value.name;
			str = str + ": ";
			str = str + PrintType(value.type);
			if (i != type.type.union.count - 1)
			{
				str = str + ", ";
			}
		}
		str = str + "}";
		return str;
	}

	return type.type.name;
}

string PrintFunction(function: VulkanFunction)
{
	str := PrintType(function.returnType) + " ";
	str = str + function.name;
	str = str + "("
	for (i .. function.params.count)
	{
		param := function.params[i];
		str = str + param.name + ": ";
		str = str + PrintType(param.type);
		if (i != function.params.count - 1)
		{
			str = str + ", ";
		}
	}
	str = str + ");";
	return str;
}

PrintFunctions(functions: []VulkanFunction)
{
	str := ""

	for (function in functions)
	{
		str = str + PrintFunction(function) + "\n";
	}

	log str;
}

ParseVulkanStruct(obj: *JSONObject, structs: []VulkanStruct)
{
	struct := VulkanStruct();
	struct.name = GetName(obj);
	fields := obj.GetMember("fields").Array();
	for (field in fields.values)
	{
		fieldObj := field.Object();
		fieldName := GetName(fieldObj);
		typeObj := GetType(fieldObj);
		type := ParseVulkanType(typeObj);
		struct.members.Add({fieldName, type});
	}

	log PrintStruct(struct);
	structs.Add(struct);
}

string PrintStruct(struct: VulkanStruct)
{
	str := "state ";
	str = str + struct.name;
	str = str + "\n{\n";
	for (i .. struct.members.count)
	{
		member := struct.members[i];
		str = str + "\t";
		str = str + member.name + ": ";
		str = str + PrintType(member.type);
		if (i != struct.members.count - 1)
		{
			str = str + ",\n";
		}
	}
	if (!struct.members.count)
	{
		str = str + "opaque: any";
	}
	str = str + "\n}\n";
	return str;
}

PrintStructs(structs: []VulkanStruct)
{
	str := ""

	for (struct in structs)
	{
		str = str + PrintStruct(struct);
	}

	log str;
}

ParseVulkanEnum(obj: *JSONObject, enums: []VulkanEnum)
{
	_enum := VulkanEnum();
	_enum.name = GetName(obj);
	fields := obj.GetMember("fields").Array();
	for (field in fields.values)
	{
		fieldObj := field.Object();
		fieldName := GetName(fieldObj);
		value := fieldObj.GetMember("value").Number().value as uint;
		_enum.fields.Add({fieldName, value});
	}

	log PrintEnum(_enum);
	enums.Add(_enum);
}

string PrintEnum(_enum: VulkanEnum)
{
	str := "enum ";
	str = str + _enum.name;
	str = str + ": uint32\n{\n";
	for (i .. _enum.fields.count)
	{
		field := _enum.fields[i];
		str = str + "\t";
		str = str + field.name + " = ";
		str = str + IntToString(field.value);
		if (i != _enum.fields.count - 1)
		{
			str = str + ",\n";
		}
	}
	str = str + "\n}\n";
	return str;
}

PrintEnums(enums: []VulkanEnum)
{
	str := ""

	for (_enum in enums)
	{
		str = str + PrintEnum(_enum);
	}

	log str;
}