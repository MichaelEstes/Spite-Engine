package JSON

import Arena
import OS

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
}

*JSONValue JSONObject::GetMember(name: string)
{
	if (this.members.Has(name))
	{
		return this.members.Find(name)~;
	}

	return null;
}

state JSONArray
{
	values: []*JSONValue
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
	value: float,
}

state JSONBoolean
{
	value: bool,
}

state JSON
{
	mem := Arena(),
	root: *JSONValue
}

JSON::delete
{
	delete this.mem;
}

JSON ParseJSON(str: string)
{
	json := JSON();
	json.root = ParseJSONValue(StringView(str), json.mem);
	return json;
}

JSON ParseJSONFile(file: string)
{
	return ParseJSON(OS.ReadFile(file));
}

bool IsJSONWhitespace(char: byte)
{
	return char == byte(0x20) || char == byte(0x09) || char == byte(0x0A) || char == byte(0x0D);
}

JSONEatWhitespace(view: StringView)
{
	while (IsJSONWhitespace(view[0]~)) view.Increment();
}

*JSONValue ParseJSONValue(view: StringView, arena: Arena)
{
	JSONEatWhitespace(view);

	char := view[0]~;

	switch (char)
	{
		case ('{') return ParseJSONObject(view, arena);
		
		case ('[') return ParseJSONArray(view, arena);

		case ('"') return ParseJSONString(view, arena);
		
		case ('-') continue;
		case ('1') continue;
		case ('2') continue;
		case ('3') continue;
		case ('4') continue;
		case ('5') continue;
		case ('6') continue;
		case ('7') continue;
		case ('8') continue;
		case ('9') return ParseJSONNumber(view, arena);
	}

	if (view.StartsWith(trueStr))
	{
		view.Advance(trueStr.count);
		return CreateJSONBoolean(true, arena);
	}
	else if (view.StartsWith(falseStr))
	{
		view.Advance(falseStr.count);
		return CreateJSONBoolean(false, arena);
	}
	else if (view.StartsWith(nullStr))
	{
		view.Advance(nullStr.count);
		nullValue := arena.Emplace<JSONValue>();
		nullValue.kind = JSONValueKind.Null;
		return nullValue;
	}

	return null;
}

string ParseString(view: StringView)
{
	view.Increment();
	start := view[0];
	strCount := 0;
	while (view[0]~ != '"') 
	{
		view.Increment();
		strCount += 1;
	}
	view.Increment();

	strCopy := ZeroedAllocator<byte>().Alloc(strCount + 1);
	copy_bytes(strCopy, start, strCount);
	return string(strCount, strCopy);
}

*JSONValue CreateJSONBoolean(value: bool, arena: Arena)
{
	boolValue := arena.Emplace<JSONValue>();
	boolValue.kind = JSONValueKind.Boolean;
	boolValue.value.boolean = arena.Emplace<JSONBoolean>();
	boolValue.value.boolean.value = value;
	return boolValue;
}

*JSONValue ParseJSONObject(view: StringView, arena: Arena)
{
	objValue := arena.Emplace<JSONValue>();
	objValue.kind = JSONValueKind.Object;
	objValue.value.object = arena.Emplace<JSONObject>();
	view.Increment();
	JSONEatWhitespace(view);

	while (view[0]~ != '}')
	{
		JSONEatWhitespace(view);
		assert view[0]~ == '"', "Expected JSON object member string";

		memberName := ParseString(view);

		JSONEatWhitespace(view);
		assert view[0]~ == ':', "Expected JSON object member name separator ':'";
		view.Increment();

		objValue.value.object.members.Insert(memberName, ParseJSONValue(view, arena));
		
		JSONEatWhitespace(view);
		if (view[0]~ == ',') view.Increment();
	}

	view.Increment();
	return objValue;
}

*JSONValue ParseJSONArray(view: StringView, arena: Arena)
{
	arrValue := arena.Emplace<JSONValue>();
	arrValue.kind = JSONValueKind.Array;
	arrValue.value.array = arena.Emplace<JSONArray>();
	view.Increment();
	JSONEatWhitespace(view);

	while (view[0]~ != ']')
	{
		JSONEatWhitespace(view);
		
		arrValue.value.array.values.Add(ParseJSONValue(view, arena)@);

		JSONEatWhitespace(view);
		if (view[0]~ == ',') view.Increment();
	}

	view.Increment();
	return arrValue;
}

*JSONValue ParseJSONString(view: StringView, arena: Arena)
{
	strValue := arena.Emplace<JSONValue>();
	strValue.kind = JSONValueKind.String;
	strValue.value.str = arena.Emplace<JSONString>();
	strValue.value.str.value = ParseString(view);

	return strValue;
}

bool IsDigit(char: byte)
{
	return char >= '0' && char <= '9';
}

*JSONValue ParseJSONNumber(view: StringView, arena: Arena)
{
	numValue := arena.Emplace<JSONValue>();
	numValue.kind = JSONValueKind.Number;
	numValue.value.number = arena.Emplace<JSONNumber>();
	
	start := view[0];
	count := 0
	
	if (view[0]~ == '-')
	{
		view.Increment();
		count += 1;
	}

	while (IsDigit(view[0]~))
	{
		view.Increment();
		count += 1;
	}

	if (view[0]~ == '.')
	{
		view.Increment();
		count += 1;

		while (IsDigit(view[0]~))
		{
			view.Increment();
			count += 1;
		}

		if (view[0]~ == 'E' || view[0]~ == 'e')
		{
			view.Increment();
			count += 1;

			if (view[0]~ == '-' || view[0]~ == '+')
			{
				view.Increment();
				count += 1;
			}

			while (IsDigit(view[0]~))
			{
				view.Increment();
				count += 1;
			}
		}
	}

	strCopy := ZeroedAllocator<byte>().Alloc(count + 1);
	copy_bytes(strCopy, start, count);
	numValue.value.number.value = atof(strCopy[0]);
	delete strCopy;

	return numValue;
}