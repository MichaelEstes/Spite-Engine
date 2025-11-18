package Input

import Vec
import SDL

enum MouseButtonBits: uint32
{
	Left = 1 << 0,
	Middle = 1 << 1,
	Right = 1 << 2,
	Side1 = 1 << 3,
	Side2 = 1 << 4,

	WheelUpdated = 1 << 5 
}

state MouseState 
{
	window: *SDL.Window,
	pos: Vec2,
	wheel: Vec2,
	buttonMask: uint32,
}

mouseStateGlobal := MouseState();

Mouse := {
	device := InputDevice(),

	Left := InputKey(0),
	Middle := InputKey(1),
	Right := InputKey(2),
	Side1 := InputKey(3),
	Side2 := InputKey(4),

	Position := InputKey(5),
	Wheel := InputKey(6)
}