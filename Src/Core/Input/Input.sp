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
	value: uint32
}

InputKey::(value: uint32)
{
	this.value = value;
}

state InputDevice
{
	getter: ::InputValue(InputKey, *any),
	update: ::(*any),
	data: *void
}

InputDevice::(getter: ::InputValue(InputKey, *any), update: ::(*any))
{
	this.getter = getter;
	this.update = update;
}

InputValue InputDevice::GetValueForKey(key: InputKey)
{
	return this.getter(key, this.data);
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



