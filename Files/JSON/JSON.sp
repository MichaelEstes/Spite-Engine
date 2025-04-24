package JSON

import Arena
import StrArena
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
	value: ?{i: int, f: float},
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
	delete this.mem;
	delete this.strs;
}

JSON ParseJSON(str: string)
{
	json := JSON();
	json.root = ParseJSONValue(StringView(str), json);
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

*JSONValue ParseJSONValue(view: StringView, json: JSON)
{
	JSONEatWhitespace(view);

	char := view[0]~;

	switch (char)
	{
		case ('{') return ParseJSONObject(view, json);
		
		case ('[') return ParseJSONArray(view, json);

		case ('"') return ParseJSONString(view, json);
		
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
		case ('9') return ParseJSONNumber(view, json);
	}

	if (view.StartsWith(trueStr))
	{
		view.Advance(trueStr.count);
		return CreateJSONBoolean(true, json);
	}
	else if (view.StartsWith(falseStr))
	{
		view.Advance(falseStr.count);
		return CreateJSONBoolean(false, json);
	}
	else if (view.StartsWith(nullStr))
	{
		view.Advance(nullStr.count);
		nullValue := json.mem.Emplace<JSONValue>();
		nullValue.kind = JSONValueKind.Null;
		return nullValue;
	}

	return null;
}

string ParseString(view: StringView, json: JSON)
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

*JSONValue ParseJSONObject(view: StringView, json: JSON)
{
	objValue := json.mem.Emplace<JSONValue>();
	objValue.kind = JSONValueKind.Object;
	objValue.value.object = json.mem.Emplace<JSONObject>();
	view.Increment();
	JSONEatWhitespace(view);

	while (view[0]~ != '}')
	{
		JSONEatWhitespace(view);
		assert view[0]~ == '"', "Expected JSON object member string";

		memberName := ParseString(view, json);

		JSONEatWhitespace(view);
		assert view[0]~ == ':', "Expected JSON object member name separator ':'";
		view.Increment();

		objValue.value.object.members.Insert(memberName, ParseJSONValue(view, json));
		
		JSONEatWhitespace(view);
		if (view[0]~ == ',') view.Increment();
	}

	view.Increment();
	return objValue;
}

*JSONValue ParseJSONArray(view: StringView, json: JSON)
{
	arrValue := json.mem.Emplace<JSONValue>();
	arrValue.kind = JSONValueKind.Array;
	arrValue.value.array = json.mem.Emplace<JSONArray>();
	view.Increment();
	JSONEatWhitespace(view);

	while (view[0]~ != ']')
	{
		JSONEatWhitespace(view);
		
		arrValue.value.array.values.Add(ParseJSONValue(view, json)@);

		JSONEatWhitespace(view);
		if (view[0]~ == ',') view.Increment();
	}

	view.Increment();
	return arrValue;
}

*JSONValue ParseJSONString(view: StringView, json: JSON)
{
	strValue := json.mem.Emplace<JSONValue>();
	strValue.kind = JSONValueKind.String;
	strValue.value.str = json.mem.Emplace<JSONString>();
	strValue.value.str.value = ParseString(view, json);

	return strValue;
}

bool IsDigit(char: byte)
{
	return char >= '0' && char <= '9';
}

*JSONValue ParseJSONNumber(view: StringView, json: JSON)
{
	numValue := json.mem.Emplace<JSONValue>();
	numValue.kind = JSONValueKind.Number;
	numValue.value.number = json.mem.Emplace<JSONNumber>();
	
	start := view[0];
	count := 0;
	
	isFloat := false;

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
		isFloat = true;
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

	//RFC 7159 max expected value of a JSON number
	strCopy := [40]byte;
	copy_bytes(fixed strCopy, start, count);
	strCopy[count + 1] = 0

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