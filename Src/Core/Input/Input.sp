package Input

import Vec

enum InputValueKind: uint32
{
	Button,
	Linear,
	Axis
}

state InputKey
{
	key: uint32
}

InputKey::(key: uint32)
{
	this.key = key;
}

state InputDevice
{
	get: ::InputValue(InputKey, *any),
	data: *void
}

InputDevice::(getter: ::InputValue(InputKey, *any))
{
	this.get = getter;
}

InputValue InputDevice::GetValueForKey(key: InputKey)
{
	return this.get(key, this.data);
}

state InputValue
{
	value: ?{
		down: bool,
		linear: float32,
		axis: Vec2
	},
	kind: InputValueKind
}

InputValue::(kind: InputValueKind)
{
	this.kind = kind;
}



