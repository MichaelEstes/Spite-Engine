package JSON

import Arena
import StrArena
import OS
import Array

extern
{
	#link linux "libc";
	#link windows "msvcrt";

	float64 atof(str: *byte);
}

trueStr := "true";
falseStr := "false";
nullStr := "null";

enum JSONValueKind: uint32
{
	Object,
	Array,
	String,
	Number,
	Boolean,
	Null
}

state JSONValue
{
	value: ?{
		object: *JSONObject,
		array: *JSONArray,
		str: *JSONString,
		number: *JSONNumber,
		boolean: *JSONBoolean
	},
	kind: JSONValueKind
}

JSONValue::delete
{
	switch (this.kind)
	{
		case (JSONValueKind.Object) delete this.value.object~;
		case (JSONValueKind.Array) delete this.value.array~;
		case (JSONValueKind.String) break;
		case (JSONValueKind.Number) break;
		case (JSONValueKind.Boolean) break;
		case (JSONValueKind.Null) break;
	}
}

JSONValue::log()
{
	switch (this.kind)
	{
		case (JSONValueKind.Object) log this.value.object.members;
		case (JSONValueKind.Array) log this.value.array;
		case (JSONValueKind.String) log this.value.str;
		case (JSONValueKind.Number) log this.value.number;
		case (JSONValueKind.Boolean) log this.value.boolean;
		case (JSONValueKind.Null) log "null";
	}
}

*JSONObject JSONValue::Object()
{
	if (this.kind != JSONValueKind.Object) return null;
	return this.value.object;
}

*JSONArray JSONValue::Array()
{
	if (this.kind != JSONValueKind.Array) return null;
	return this.value.array;
}

*JSONString JSONValue::String()
{
	if (this.kind != JSONValueKind.String) return null;
	return this.value.str;
}

*JSONNumber JSONValue::Number()
{
	if (this.kind != JSONValueKind.Number) return null;
	return this.value.number;
}

*JSONBoolean JSONValue::Boolean()
{
	if (this.kind != JSONValueKind.Boolean) return null;
	return this.value.boolean;
}

state JSONObject
{
	members := Map<string, *JSONValue>(),
	order: Array<string>
}

JSONObject::delete
{
	for (kv in this.members) delete kv.value~~;
	delete this.members;
}

*JSONValue JSONObject::GetMember(name: string)
{
	if (this.members.Has(name))
	{
		return this.members.Find(name)~;
	}

	return null;
}

*JSONValue JSONObject::operator::[](name: string)
{
	return this.GetMember(name);
}

Iterator JSONObject::operator::in()
{
	return {null, -1};
}

bool JSONObject::next(it: Iterator)
{
	it.index += 1;
	return it.index < this.order.count;
}

{key: string, value: *JSONValue} JSONObject::current(it: Iterator)
{
	name := this.order[it.index];
	return { name, this.GetMember(name) };	
}

state JSONArray
{
	values: []*JSONValue
}

JSONArray::delete
{
	for (value in this.values) delete value~;
	delete this.values;
}

*JSONValue JSONArray::GetValue(index: uint)
{
	if (this.values.count > index)
	{
		return this.values[index];
	}

	return null;
}

state JSONString
{
	value: string,
}

state JSONNumber
{
	value: ?{i: int, f: float},
	isFloat: bool
}

float JSONNumber::AsFloat()
{
	if (this.isFloat) return this.value.f;
	return this.value.i as float;
}

int JSONNumber::AsInt()
{
	if (this.isFloat) return this.value.f as int;
	return this.value.i;
}

state JSONBoolean
{
	value: bool,
}

state JSON
{
	mem := Arena(),
	strs := StrArena(),
	root: *JSONValue
}

JSON::delete
{
	if (this.root) delete this.root~;
	delete this.mem;
	delete this.strs;
}

state JSONParseContext
{
	view: StringView,
	file: string,
	line: uint32,
	column: uint32,
	lastChar: byte
}

JSON ParseJSON(str: string, file: string = "")
{
	json := JSON();
	context := JSONParseContext();
	context.view = StringView(str);
	context.file = file;
	context.line = 0;
	context.column = 0;
	context.lastChar = 0;
	JSONEatWhitespace(context);
	json.root = ParseJSONValue(context, json);
	return json;
}

JSON ParseJSONFile(file: string)
{
	contents := OS.ReadFile(file);
	defer delete contents;
	return ParseJSON(contents, file);
}

bool IsJSONWhitespace(char: byte)
{
	return char == byte(0x20) || 
		   char == byte(0x09) || 
		   char == byte(0x0A) || 
		   char == byte(0x0D) ||
		   char == byte(0);
}

bool JSONIncrement(context: JSONParseContext)
{
	char := context.view[0]~;
	if (!context.view.Increment())
	{
		return false;
	}

	if (char == byte(0x0D))
	{
		context.line += 1;
		context.column = 0;
	}
	else if (char == byte(0x0A))
	{
		if (context.lastChar != byte(0x0D))
		{
			context.line += 1;
			context.column = 0;
		}
	}
	else
	{
		context.column += 1;
	}

	context.lastChar = char;
	return true;
}

bool JSONAdvance(context: JSONParseContext, count: uint)
{
	i := uint(0);
	while (i < count)
	{
		if (!JSONIncrement(context))
		{
			return false;
		}

		i += 1;
	}

	return true;
}

JSONLogParseError(context: JSONParseContext, message: string)
{
	log "JSON parse error: ", message;
	log "File: ", context.file;
	log "Line: ", context.line, " Column: ", context.column;
	log "Character: ", context.view[0]~;
}

JSONEatWhitespace(context: JSONParseContext)
{
	while (IsJSONWhitespace(context.view[0]~)) 
	{
		if (!JSONIncrement(context)) 
		{
			return;
		}
	}
}

*JSONValue ParseJSONValue(context: JSONParseContext, json: JSON)
{
	JSONEatWhitespace(context);

	char := context.view[0]~;

	switch (char)
	{
		case ('{') return ParseJSONObject(context, json);

		case ('[') return ParseJSONArray(context, json);

		case ('"') continue;
		case ('\'') continue;
		case ('`') return ParseJSONString(context, json);

		case ('-') continue;
		case ('0') continue;
		case ('1') continue;
		case ('2') continue;
		case ('3') continue;
		case ('4') continue;
		case ('5') continue;
		case ('6') continue;
		case ('7') continue;
		case ('8') continue;
		case ('9') return ParseJSONNumber(context, json);
	}

	if (context.view.StartsWith(trueStr))
	{
		JSONAdvance(context, trueStr.count);
		return CreateJSONBoolean(true, json);
	}
	else if (context.view.StartsWith(falseStr))
	{
		JSONAdvance(context, falseStr.count);
		return CreateJSONBoolean(false, json);
	}
	else if (context.view.StartsWith(nullStr))
	{
		JSONAdvance(context, nullStr.count);
		nullValue := json.mem.Emplace<JSONValue>();
		nullValue.kind = JSONValueKind.Null;
		return nullValue;
	}
	else if (IsIdentifierStart(char))
	{
		return ParseJSONBareString(context, json);
	}

	log "ParseJSONValue Invalid JSON character: ", char;
	return null;
}

string ParseString(context: JSONParseContext, json: JSON)
{
	delim := context.view[0]~;
	JSONIncrement(context);
	start := context.view[0];
	strCount := 0;
	while (context.view[0]~ != delim)
	{
		if (delim == '"' && context.view[0]~ == '\\')
		{
			JSONIncrement(context);
			strCount += 1;
		}
		JSONIncrement(context);
		strCount += 1;
	}
	JSONIncrement(context);

	str := json.strs.Get(strCount);
	copy_bytes(str[0], start, strCount);

	return str;
}

*JSONValue CreateJSONBoolean(value: bool, json: JSON)
{
	boolValue := json.mem.Emplace<JSONValue>();
	boolValue.kind = JSONValueKind.Boolean;
	boolValue.value.boolean = json.mem.Emplace<JSONBoolean>();
	boolValue.value.boolean.value = value;
	return boolValue;
}

*JSONValue ParseJSONObject(context: JSONParseContext, json: JSON)
{
	objValue := json.mem.Emplace<JSONValue>();
	objValue.kind = JSONValueKind.Object;
	objValue.value.object = json.mem.Emplace<JSONObject>();
	JSONIncrement(context);
	JSONEatWhitespace(context);

	while (context.view[0]~ != '}')
	{
		JSONEatWhitespace(context);

		memberName := "";
		if (IsStringDelim(context.view[0]~))
			memberName = ParseString(context, json);
		else
			memberName = ParseIdentifier(context, json);

		JSONEatWhitespace(context);
		if (context.view[0]~ != ':')
		{
			JSONLogParseError(context, "Expected JSON object member name separator ':'");
			assert false, "Expected JSON object member name separator ':'";
		}
		JSONIncrement(context);

		objValue.value.object.members.Insert(memberName, ParseJSONValue(context, json));
		objValue.value.object.order.Add(memberName);

		JSONEatWhitespace(context);
		if (context.view[0]~ == ',') JSONIncrement(context);
	}

	JSONIncrement(context);
	return objValue;
}

*JSONValue ParseJSONArray(context: JSONParseContext, json: JSON)
{
	arrValue := json.mem.Emplace<JSONValue>();
	arrValue.kind = JSONValueKind.Array;
	arrValue.value.array = json.mem.Emplace<JSONArray>();
	JSONIncrement(context);
	JSONEatWhitespace(context);

	while (context.view[0]~ != ']')
	{
		JSONEatWhitespace(context);
		
		arrValue.value.array.values.Add(ParseJSONValue(context, json)@);

		JSONEatWhitespace(context);
		if (context.view[0]~ == ',') JSONIncrement(context);
	}

	JSONIncrement(context);
	return arrValue;
}

*JSONValue ParseJSONString(context: JSONParseContext, json: JSON)
{
	strValue := json.mem.Emplace<JSONValue>();
	strValue.kind = JSONValueKind.String;
	strValue.value.str = json.mem.Emplace<JSONString>();
	strValue.value.str.value = ParseString(context, json);

	return strValue;
}

bool IsDigit(char: byte)
{
	return char >= '0' && char <= '9';
}

bool IsIdentifierStart(char: byte)
{
	return (char >= 'a' && char <= 'z') ||
	       (char >= 'A' && char <= 'Z') ||
	       char == '_';
}

bool IsIdentifierChar(char: byte)
{
	return IsIdentifierStart(char) || IsDigit(char);
}

string ParseIdentifier(context: JSONParseContext, json: JSON)
{
	start := context.view[0];
	count := 0;
	while (IsIdentifierChar(context.view[0]~))
	{
		JSONIncrement(context);
		count += 1;
	}
	str := json.strs.Get(count);
	copy_bytes(str[0], start, count);
	return str;
}

*JSONValue ParseJSONBareString(context: JSONParseContext, json: JSON)
{
	strValue := json.mem.Emplace<JSONValue>();
	strValue.kind = JSONValueKind.String;
	strValue.value.str = json.mem.Emplace<JSONString>();
	strValue.value.str.value = ParseIdentifier(context, json);
	return strValue;
}

bool IsStringDelim(char: byte)
{
	return char == '"' || char == '\'' || char == '`';
}

*JSONValue ParseJSONNumber(context: JSONParseContext, json: JSON)
{
	numValue := json.mem.Emplace<JSONValue>();
	numValue.kind = JSONValueKind.Number;
	numValue.value.number = json.mem.Emplace<JSONNumber>();
	
	start := context.view[0];
	count := 0;
	
	isFloat := false;

	if (context.view[0]~ == '-')
	{
		JSONIncrement(context);
		count += 1;
	}

	while (IsDigit(context.view[0]~))
	{
		JSONIncrement(context);
		count += 1;
	}

	if (context.view[0]~ == '.')
	{
		isFloat = true;
		JSONIncrement(context);
		count += 1;

		while (IsDigit(context.view[0]~))
		{
			JSONIncrement(context);
			count += 1;
		}

		if (context.view[0]~ == 'E' || context.view[0]~ == 'e')
		{
			JSONIncrement(context);
			count += 1;

			if (context.view[0]~ == '-' || context.view[0]~ == '+')
			{
				JSONIncrement(context);
				count += 1;
			}

			while (IsDigit(context.view[0]~))
			{
				JSONIncrement(context);
				count += 1;
			}
		}
	}

	//RFC 7159 max expected value of a JSON number
	strCopy := [40]byte;
	copy_bytes(fixed strCopy, start, count);
	strCopy[count + 1] = 0

	numValue.value.number.isFloat = isFloat;
	if (isFloat)
	{
		numValue.value.number.value.f = atof(fixed strCopy);
	}
	else
	{
		numValue.value.number.value.i = StringToInt(string(count, fixed strCopy));
	}

	return numValue;
}

Type JSONDeserialize<Type>(file: string)
{
	ret := Type();
	json := ParseJSONFile(file);

	type := #typeof Type;


	return ret;
}
