package Input

import Array
import SDL

inputManager := InputManager();

state InputManager
{
	devices: Array<*InputDevice>,
}

InputManager::Update()
{
	for (device in this.devices)
	{
		device.update(device.data);
	}
}

InitializeInput()
{
	Keyboard.device = InputDevice(
		::InputValue(key: InputKey, keyboardState: *bool) 
		{
			input := InputValue(InputValueKind.Button);
			input.value.down = keyboardState[key.value]~;
			return input;
		},
		::(keyboardState: *bool) {}
	);
	Keyboard.device.data = SDL.GetKeyboardState(null);

	Mouse.device = InputDevice(
		::InputValue(key: InputKey, mouseState: *MouseState) 
		{
			input := InputValue();

			if (key.value < Mouse.Position.value)
			{
				input.kind = InputValueKind.Button;
				bit := 1 << key.value;
				input.value.down = mouseState.buttonMask & bit;
			}
			else
			{
				input.kind = InputValueKind.Axis;
				input.value.axis = mouseState.pos;
			}

			return input;
		},
		::(mouseState: *MouseState) 
		{
			mouseState.buttonMask = SDL.GetMouseState(mouseState.pos.x@, mouseState.pos.y@);
		}
	);
	Mouse.device.data = mouseStateGlobal@;

	inputManager.devices.Add(Keyboard.device@);
	inputManager.devices.Add(Mouse.device@);
}

UpdateInput()
{
	inputManager.Update();
}

//state InputQuery
//{
//
//}

InputValue QueryInput(device: InputDevice, key: InputKey)
{
	return device.GetValueForKey(key);
}
