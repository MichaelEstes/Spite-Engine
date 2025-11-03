package Input

import Array


inputManager := InputManager();

state InputManager
{
	devices: Array<InputDevice>,

	keyboardID: uint32,
	mouseID: uint32
}

state InputQuery
{

}

InputValue QueryInput(deviceID: uint32, inputKey: InputKey)
{
	value := InputValue();

	return value;
}
