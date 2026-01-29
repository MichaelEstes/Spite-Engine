package Input

import Array
import SDL
import Window
import Event

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
			else if (key.value == Mouse.Position.value)
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
			else if (key.value == Mouse.Wheel.value)
			{
				input.kind = InputValueKind.Axis;
				input.value.axis = mouseState.wheel;
			}
			else if (key.value == Mouse.Delta.value)
			{
				input.kind = InputValueKind.Axis;
				input.value.axis = mouseState.delta;
			}

			return input;
		},
		::(mouseState: *MouseState) 
		{
			if ((mouseState.buttonMask & MouseButtonBits.WheelUpdated) == 0)
			{
				mouseState.wheel = Vec2();
			}
			prevPos := Vec2(mouseState.pos.x, mouseState.pos.y);
			mouseState.buttonMask = SDL.GetMouseState(mouseState.pos.x@, mouseState.pos.y@);
			mouseState.window = SDL.GetMouseFocus();
			mouseState.delta = mouseState.pos - prevPos;
		}
	);
	Mouse.device.data = mouseStateGlobal@;

	globalEvents := GetGlobalEventEmitter();
	globalEvents.On(SDL.EventType.MOUSE_WHEEL, ::(event: SDL.Event, data: *void) 
		{
			wheelEvent := event.data.wheel;
			mouseState := Mouse.device.data as *MouseState;
			mouseState.buttonMask |= MouseButtonBits.WheelUpdated;
			mouseState.wheel = Vec2(wheelEvent.x, wheelEvent.y);
		}
	);

	inputManager.devices.Add(Keyboard.device@);
	inputManager.devices.Add(Mouse.device@);
}

UpdateInput()
{
	inputManager.Update();
}

InputValue QueryInput(device: InputDevice, key: InputKey, window: *SDL.Window = null)
{
	if (window && window != GetFocusedWindow()) return InputValue();

	return device.GetValueForKey(key);
}
