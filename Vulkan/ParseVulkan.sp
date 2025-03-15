package ParseVulkan

import JSON


enum VulkanTypeKind
{
	Named,
	Pointer,
	Array,
	Primitive
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
		array: {size: uint, type: *VulkanType}
		primitive: VulkanPrimitiveType
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

string GetTag(obj: *JSONObject) => obj.GetMember("tag").String().value;
string GetName(obj: *JSONObject) => obj.GetMember("name").String().value;
*JSONObject GetType(obj: *JSONObject) => obj.GetMember("type").Object();

ParseHeaderJSON(file: string)
{
	functions := []VulkanFunction;
	structs := []VulkanStruct;
	json := JSON.ParseJSONFile(file);
	arr := json.root.Array();
	log arr.values.count;

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
	else if (tag == ":void")
	{
		type.kind = VulkanTypeKind.Named;
		type.type.name = "void";
	}
	else if (tag == ":array")
	{
		type.kind = VulkanTypeKind.Array;
		type.type.array.size = obj.GetMember("size").Number().value as uint;
		type.type.array.type = ParseVulkanType(GetType(obj));
	}
	else
	{
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