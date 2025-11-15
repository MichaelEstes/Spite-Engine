package Input

import Array
import SDL
import Window

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
				if (!mouseState.window)
				{
					input.value.axis = Vec2();
					return input;
				}

				size := Window.GetWindowSize(mouseState.window);
				pos := mouseState.pos;

				x := pos.x / size.width as float32;
				y := pos.y / size.height as float32;
				input.value.axis = Vec2(x, y);
			}

			return input;
		},
		::(mouseState: *MouseState) 
		{
			mouseState.buttonMask = SDL.GetMouseState(mouseState.pos.x@, mouseState.pos.y@);
			mouseState.window = SDL.GetMouseFocus();
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
