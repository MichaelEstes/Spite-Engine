package Input

import Array


inputManager := InputManager();

state InputManager
{
	devices: Array<*InputDevice>,
}

InitializeInput()
{
	Keyboard.device = InputDevice(
		::InputValue(key: InputKey, keyboardState: *bool) 
		{
			input := InputValue(InputValueKind.Button);
			input.value.down = keyboardState[key.key]~;
			return input;
		}
	);
	Keyboard.device.data = SDL.GetKeyboardState(null);

	inputManager.devices.Add(Keyboard.device@);
}

//state InputQuery
//{
//
//}

InputValue QueryInput(device: InputDevice, key: InputKey)
{
	return device.GetValueForKey(key);
}
