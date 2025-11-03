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
	key: uint32,
	kind: InputValueKind
}

state InputDevice
{
	buttonStates: Array<bool>,
	linearStates: Array<float32>,
	axisStates: Array<Vec2>,
	
	inputs: Array<InputKey>,

	id: uint32
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

state InputEvent
{
	value: InputValue,
	
	deviceID: uint32,
	inputKey: uint32
}



