package ParseVulkan

import JSON


enum VulkanTypeKind
{
	Named,
	Pointer,
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
		primitive: VulkanPrimitiveType
	}
}

state VulkanFunction
{
	name: string,
	params: []{name: string, type: *VulkanType},
	returnType: string
}

string GetTag(obj: *JSONObject) => obj.GetMember("tag").String().value;
string GetName(obj: *JSONObject) => obj.GetMember("name").String().value;
*JSONObject GetType(obj: *JSONObject) => obj.GetMember("type").Object();

ParseHeaderJSON(file: string)
{
	functions := []VulkanFunction;
	json := JSON.ParseJSONFile(file);
	arr := json.root.Array();
	log arr.values.count;

	for (val in arr.values)
	{
		obj := val.Object();
		tag := GetTag(obj);
		if (tag == "function")
		{
			ParseVulkanFunction(obj, functions);
		}
	}

	PrintFunctions(functions);
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
	function.returnType = GetTag(obj.GetMember("return-type").Object());
	functions.Add(function);
}

*VulkanType ParseVulkanType(obj: *JSONObject)
{
	tag := GetTag(obj);
	type := new VulkanType();
	if (tag.StartsWith(":pointer"))
	{
		type.kind = VulkanTypeKind.Pointer;
		type.type.pointer = ParseVulkanType(GetType(obj));
	}
	else if (tag.StartsWith(":void"))
	{
		type.kind = VulkanTypeKind.Named;
		type.type.name = "void";
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

	return type.type.name;
}

PrintFunctions(functions: []VulkanFunction)
{
	str := ""

	for (function in functions)
	{
		str = str + function.returnType + " ";
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
		str = str + ");\n";
	}

	log str;
}