package ParseHeader

import JSON
import OS

enum HeaderTypeKind
{
	Named,
	Pointer,
	Array,
	Primitive,
	Union
}

state HeaderContext
{
	typeDefLookup := Map<string, *JSONObject>(),
	unionLookup := Map<string, *JSONObject>()
}

HeaderContext::delete
{
	delete this.typeDefLookup;
	delete this.unionLookup;
}

state HeaderPrimitiveType
{
	size: uint,
	signed: bool
}

state HeaderType
{
	kind: HeaderTypeKind,
	type: ?{
		name: string,
		pointer: *HeaderType,
		array: {size: uint, type: *HeaderType},
		primitive: HeaderPrimitiveType,
		union: []{name: string, type: *HeaderType}
	}
}

HeaderType::delete
{
	if(this.kind == HeaderTypeKind.Union)
	{
		for (union in this.type.union) delete union.type;
		delete this.type.union;
	}
	else if (this.kind == HeaderTypeKind.Pointer)
	{
		delete this.type.pointer;
	}
	else if (this.kind == HeaderTypeKind.Array)
	{
		delete this.type.array.type;
	}
}

state HeaderFunction
{
	name: string,
	params: []{name: string, type: *HeaderType},
	returnType: *HeaderType
}

HeaderFunction::delete
{
	for (param in this.params) delete param.type;
	delete this.params;
	delete this.returnType;
}

state HeaderStruct
{
	name: string,
	members: []{name: string, type: *HeaderType}
}

HeaderStruct::delete
{
	for (member in this.members) delete member.type;
	delete this.members;
}

state HeaderEnum
{
	name: string,
	fields: []{name: string, value: uint}
}

HeaderEnum::delete
{
	delete this.fields;
}

string GetTag(obj: *JSONObject) => obj.GetMember("tag").String().value;
string GetName(obj: *JSONObject) => obj.GetMember("name").String().value;
*JSONObject GetType(obj: *JSONObject) => obj.GetMember("type").Object();

ParseHeaderJSON(file: string, outFile: string)
{
	json := JSON.ParseJSONFile(file);
	defer delete json;
	if (!json.root)
	{
		log "ParseHeaderJSON Unable to read JSON file";
		return;
	}

	context := HeaderContext();
	functions := []HeaderFunction;
	structs := []HeaderStruct;
	enums := []HeaderEnum;

	arr := json.root.Array();

	defer 
	{
		for (function in functions) delete function;
		for (struct in structs) delete struct;
		for (enum_ in enums) delete enum_;
		delete context;
		delete functions;
		delete structs;
		delete enums;
	}

	for (val in arr.values)
	{
		obj := val.Object();
		tag := GetTag(obj);
		if (tag == "typedef")
		{
			name := GetName(obj);
			type := obj.GetMember("type").Object();
			context.typeDefLookup.Insert(name, type);
		}

		if (tag == "union")
		{
			name := GetName(obj);
			context.unionLookup.Insert(name, obj);
		}
	}

	for (val in arr.values)
	{
		obj := val.Object();
		tag := GetTag(obj);
		if (tag == "function")
		{
			ParseHeaderFunction(obj, functions, context);
		}

		if (tag == "struct")
		{
			ParseHeaderStruct(obj, structs, context);
		}

		if (tag == "enum")
		{
			ParseHeaderEnum(obj, enums);
		}
	}

	str := "";

	str.AppendIn(PrintFunctions(functions));
	str.AppendIn("\n");
	str.AppendIn(PrintEnums(enums));
	str.AppendIn(PrintStructs(structs));

	OS.WriteFile(outFile, str);
}

ParseHeaderFunction(obj: *JSONObject, functions: []HeaderFunction, context: HeaderContext)
{
	function := HeaderFunction();
	function.name = GetName(obj);
	params := obj.GetMember("parameters").Array();
	for (param in params.values)
	{
		paramObj := param.Object();
		paramName := GetName(paramObj);
		typeObj := GetType(paramObj);
		type := ParseHeaderType(typeObj, context);
		function.params.Add({paramName, type});
	}
	function.returnType = ParseHeaderType(obj.GetMember("return-type").Object(), context);

	functions.Add(function);
}

*HeaderType ParseHeaderType(obj: *JSONObject, context: HeaderContext)
{
	tag := GetTag(obj);
	type := new HeaderType();
	if (tag == ":pointer")
	{
		type.kind = HeaderTypeKind.Pointer;
		type.type.pointer = ParseHeaderType(GetType(obj), context);
	}
	else if (tag == ":array")
	{
		type.kind = HeaderTypeKind.Array;
		type.type.array.size = obj.GetMember("size").Number().value as uint;
		type.type.array.type = ParseHeaderType(GetType(obj), context);
	}
	else if (tag == ":void")
	{
		type.kind = HeaderTypeKind.Named;
		type.type.name = "void";
	}
	else if (tag == ":float")
	{
		type.kind = HeaderTypeKind.Named;
		type.type.name = "float32";
	}
	else if (tag == ":int")
	{
		type.kind = HeaderTypeKind.Named;
		type.type.name = "int32";
	}
	else if (tag == ":unsigned-int")
	{
		type.kind = HeaderTypeKind.Named;
		type.type.name = "uint32";
	}
	else if (tag == ":long")
	{
		type.kind = HeaderTypeKind.Named;
		type.type.name = "int64";
	}
	else if (tag == ":unsigned-long")
	{
		type.kind = HeaderTypeKind.Named;
		type.type.name = "uint64";
	}
	else if (tag == ":signed-char")
	{
		type.kind = HeaderTypeKind.Named;
		type.type.name = "byte";
	}
	else if (tag == ":char")
	{
		type.kind = HeaderTypeKind.Named;
		type.type.name = "byte";
	}
	else if (tag == ":unsigned-char")
	{
		type.kind = HeaderTypeKind.Named;
		type.type.name = "ubyte";
	}
	else if (tag == ":short")
	{
		type.kind = HeaderTypeKind.Named;
		type.type.name = "int16";
	}
	else if (tag == ":unsigned-short")
	{
		type.kind = HeaderTypeKind.Named;
		type.type.name = "uint16";
	}
	else if (tag == ":function-pointer")
	{
		type.kind = HeaderTypeKind.Named;
		type.type.name = "::()";
	}
	else if (tag == ":enum" || tag == ":struct" || tag == "struct")
	{
		type.kind = HeaderTypeKind.Named;
		type.type.name = GetName(obj);
	}
	else if (tag == ":union")
	{
		type.kind = HeaderTypeKind.Union;

		unionName := GetName(obj);
		unionObj := context.unionLookup.Find(unionName)~;

		fields := unionObj.GetMember("fields").Array();
		unionValues := []{name: string, type: *HeaderType};

		for (field in fields.values)
		{
			fieldObj := field.Object();
			name := GetName(fieldObj);
			unionType := GetType(fieldObj);
			value := {name, ParseHeaderType(unionType, context)};
			unionValues.Add(value);
		}
		type.type.union = unionValues;
	}
	else
	{
		if (context.typeDefLookup.Has(tag))
		{
			return ParseHeaderType(context.typeDefLookup[tag]~, context);
		}
		type.kind = HeaderTypeKind.Named;
		type.type.name = tag;
	}

	return type;
}

string PrintType(type: *HeaderType)
{
	if (type.kind == HeaderTypeKind.Pointer)
	{
		return "*" + PrintType(type.type.pointer);
	}
	else if (type.kind == HeaderTypeKind.Array)
	{
		return "[" + IntToString(type.type.array.size) + "]" + PrintType(type.type.array.type);
	}
	else if (type.kind == HeaderTypeKind.Union)
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

string PrintFunction(function: HeaderFunction)
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

string PrintFunctions(functions: []HeaderFunction)
{
	str := ""

	for (function in functions)
	{
		str = str + PrintFunction(function) + "\n";
	}

	return str;
}

ParseHeaderStruct(obj: *JSONObject, structs: []HeaderStruct, context: HeaderContext)
{
	struct := HeaderStruct();
	struct.name = GetName(obj);
	fields := obj.GetMember("fields").Array();
	for (field in fields.values)
	{
		fieldObj := field.Object();
		fieldName := GetName(fieldObj);
		typeObj := GetType(fieldObj);
		type := ParseHeaderType(typeObj, context);
		struct.members.Add({fieldName, type});
	}

	structs.Add(struct);
}

string PrintStruct(struct: HeaderStruct)
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
	str = str + "\n}\n\n";
	return str;
}

string PrintStructs(structs: []HeaderStruct)
{
	str := ""

	for (struct in structs)
	{
		str = str + PrintStruct(struct);
	}

	return str;
}

ParseHeaderEnum(obj: *JSONObject, enums: []HeaderEnum)
{
	_enum := HeaderEnum();
	_enum.name = GetName(obj);
	fields := obj.GetMember("fields").Array();
	for (field in fields.values)
	{
		fieldObj := field.Object();
		fieldName := GetName(fieldObj);
		value := fieldObj.GetMember("value").Number().value as uint;
		_enum.fields.Add({fieldName, value});
	}

	enums.Add(_enum);
}

string PrintEnum(_enum: HeaderEnum)
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
	str = str + "\n}\n\n";
	return str;
}

string PrintEnums(enums: []HeaderEnum)
{
	str := ""

	for (_enum in enums)
	{
		str = str + PrintEnum(_enum);
	}

	return str;
}