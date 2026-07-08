package ImGui

import SDL

UpdateMousePos(event: SDL.Event, data: *void) 
{
	io := ImGui_GetIO();
	x := event.data.motion.x;
	y := event.data.motion.y;

	source := ImGuiMouseSource_.ImGuiMouseSource_Mouse;
	if (event.data.motion.mouseID == uint32(-1))
	{
		source = ImGuiMouseSource_.ImGuiMouseSource_TouchScreen;
	}

	ImGuiIO_AddMouseSourceEvent(io, source);
	ImGuiIO_AddMousePosEvent(io, x, y);
}

UpdateMouseWheel(event: SDL.Event, data: *void) 
{
	io := ImGui_GetIO();
	x := -event.data.wheel.x;
	y := event.data.wheel.y;

	source := ImGuiMouseSource_.ImGuiMouseSource_Mouse;
	if (event.data.motion.mouseID == uint32(-1))
	{
		source = ImGuiMouseSource_.ImGuiMouseSource_TouchScreen;
	}

	ImGuiIO_AddMouseSourceEvent(io, source);
	ImGuiIO_AddMouseWheelEvent(io, x, y);
}

UpdateMouseButton(event: SDL.Event, data: *void) 
{
	io := ImGui_GetIO();
	mouseButton := int32(-1);
	
	switch (event.data.button.button as uint32)
	{
		case (SDL.MouseButton.Left) mouseButton = 0;
		case (SDL.MouseButton.Right) mouseButton = 1;
		case (SDL.MouseButton.Middle) mouseButton = 2;
		case (SDL.MouseButton.X1) mouseButton = 3;
		case (SDL.MouseButton.X2) mouseButton = 4;
	}
	if (mouseButton == -1) return;

	source := ImGuiMouseSource_.ImGuiMouseSource_Mouse;
	if (event.data.motion.mouseID == uint32(-1))
	{
		source = ImGuiMouseSource_.ImGuiMouseSource_TouchScreen;
	}

	ImGuiIO_AddMouseSourceEvent(io, source);
	ImGuiIO_AddMouseButtonEvent(io, mouseButton, event.data.button.down);
}

UpdateKeyModifiers(mods: uint32)
{
	io := ImGui_GetIO();

	ImGuiIO_AddKeyEvent(io, ImGuiKey_.ImGuiMod_Ctrl, (mods & SDL.Keymod.Ctrl) != 0);
	ImGuiIO_AddKeyEvent(io, ImGuiKey_.ImGuiMod_Shift, (mods & SDL.Keymod.Shift) != 0);
	ImGuiIO_AddKeyEvent(io, ImGuiKey_.ImGuiMod_Alt, (mods & SDL.Keymod.Alt) != 0);
	ImGuiIO_AddKeyEvent(io, ImGuiKey_.ImGuiMod_Super, (mods & SDL.Keymod.Gui) != 0);
}

int32 MapScancodeToImGuiKey(scancode: SDL.Scancode)
{
	switch (scancode)
	{
		case (SDL.Scancode.A) return ImGuiKey_.ImGuiKey_A;
		case (SDL.Scancode.B) return ImGuiKey_.ImGuiKey_B;
		case (SDL.Scancode.C) return ImGuiKey_.ImGuiKey_C;
		case (SDL.Scancode.D) return ImGuiKey_.ImGuiKey_D;
		case (SDL.Scancode.E) return ImGuiKey_.ImGuiKey_E;
		case (SDL.Scancode.F) return ImGuiKey_.ImGuiKey_F;
		case (SDL.Scancode.G) return ImGuiKey_.ImGuiKey_G;
		case (SDL.Scancode.H) return ImGuiKey_.ImGuiKey_H;
		case (SDL.Scancode.I) return ImGuiKey_.ImGuiKey_I;
		case (SDL.Scancode.J) return ImGuiKey_.ImGuiKey_J;
		case (SDL.Scancode.K) return ImGuiKey_.ImGuiKey_K;
		case (SDL.Scancode.L) return ImGuiKey_.ImGuiKey_L;
		case (SDL.Scancode.M) return ImGuiKey_.ImGuiKey_M;
		case (SDL.Scancode.N) return ImGuiKey_.ImGuiKey_N;
		case (SDL.Scancode.O) return ImGuiKey_.ImGuiKey_O;
		case (SDL.Scancode.P) return ImGuiKey_.ImGuiKey_P;
		case (SDL.Scancode.Q) return ImGuiKey_.ImGuiKey_Q;
		case (SDL.Scancode.R) return ImGuiKey_.ImGuiKey_R;
		case (SDL.Scancode.S) return ImGuiKey_.ImGuiKey_S;
		case (SDL.Scancode.T) return ImGuiKey_.ImGuiKey_T;
		case (SDL.Scancode.U) return ImGuiKey_.ImGuiKey_U;
		case (SDL.Scancode.V) return ImGuiKey_.ImGuiKey_V;
		case (SDL.Scancode.W) return ImGuiKey_.ImGuiKey_W;
		case (SDL.Scancode.X) return ImGuiKey_.ImGuiKey_X;
		case (SDL.Scancode.Y) return ImGuiKey_.ImGuiKey_Y;
		case (SDL.Scancode.Z) return ImGuiKey_.ImGuiKey_Z;
		case (SDL.Scancode._1) return ImGuiKey_.ImGuiKey_1;
		case (SDL.Scancode._2) return ImGuiKey_.ImGuiKey_2;
		case (SDL.Scancode._3) return ImGuiKey_.ImGuiKey_3;
		case (SDL.Scancode._4) return ImGuiKey_.ImGuiKey_4;
		case (SDL.Scancode._5) return ImGuiKey_.ImGuiKey_5;
		case (SDL.Scancode._6) return ImGuiKey_.ImGuiKey_6;
		case (SDL.Scancode._7) return ImGuiKey_.ImGuiKey_7;
		case (SDL.Scancode._8) return ImGuiKey_.ImGuiKey_8;
		case (SDL.Scancode._9) return ImGuiKey_.ImGuiKey_9;
		case (SDL.Scancode._0) return ImGuiKey_.ImGuiKey_0;
		case (SDL.Scancode.RETURN) return ImGuiKey_.ImGuiKey_Enter;
		case (SDL.Scancode.ESCAPE) return ImGuiKey_.ImGuiKey_Escape;
		case (SDL.Scancode.BACKSPACE) return ImGuiKey_.ImGuiKey_Backspace;
		case (SDL.Scancode.TAB) return ImGuiKey_.ImGuiKey_Tab;
		case (SDL.Scancode.SPACE) return ImGuiKey_.ImGuiKey_Space;
		case (SDL.Scancode.MINUS) return ImGuiKey_.ImGuiKey_Minus;
		case (SDL.Scancode.EQUALS) return ImGuiKey_.ImGuiKey_Equal;
		case (SDL.Scancode.LEFTBRACKET) return ImGuiKey_.ImGuiKey_LeftBracket;
		case (SDL.Scancode.RIGHTBRACKET) return ImGuiKey_.ImGuiKey_RightBracket;
		case (SDL.Scancode.BACKSLASH) return ImGuiKey_.ImGuiKey_Backslash;
		case (SDL.Scancode.SEMICOLON) return ImGuiKey_.ImGuiKey_Semicolon;
		case (SDL.Scancode.APOSTROPHE) return ImGuiKey_.ImGuiKey_Apostrophe;
		case (SDL.Scancode.GRAVE) return ImGuiKey_.ImGuiKey_GraveAccent;
		case (SDL.Scancode.COMMA) return ImGuiKey_.ImGuiKey_Comma;
		case (SDL.Scancode.PERIOD) return ImGuiKey_.ImGuiKey_Period;
		case (SDL.Scancode.SLASH) return ImGuiKey_.ImGuiKey_Slash;
		case (SDL.Scancode.CAPSLOCK) return ImGuiKey_.ImGuiKey_CapsLock;
		case (SDL.Scancode.F1) return ImGuiKey_.ImGuiKey_F1;
		case (SDL.Scancode.F2) return ImGuiKey_.ImGuiKey_F2;
		case (SDL.Scancode.F3) return ImGuiKey_.ImGuiKey_F3;
		case (SDL.Scancode.F4) return ImGuiKey_.ImGuiKey_F4;
		case (SDL.Scancode.F5) return ImGuiKey_.ImGuiKey_F5;
		case (SDL.Scancode.F6) return ImGuiKey_.ImGuiKey_F6;
		case (SDL.Scancode.F7) return ImGuiKey_.ImGuiKey_F7;
		case (SDL.Scancode.F8) return ImGuiKey_.ImGuiKey_F8;
		case (SDL.Scancode.F9) return ImGuiKey_.ImGuiKey_F9;
		case (SDL.Scancode.F10) return ImGuiKey_.ImGuiKey_F10;
		case (SDL.Scancode.F11) return ImGuiKey_.ImGuiKey_F11;
		case (SDL.Scancode.F12) return ImGuiKey_.ImGuiKey_F12;
		case (SDL.Scancode.PRINTSCREEN) return ImGuiKey_.ImGuiKey_PrintScreen;
		case (SDL.Scancode.SCROLLLOCK) return ImGuiKey_.ImGuiKey_ScrollLock;
		case (SDL.Scancode.PAUSE) return ImGuiKey_.ImGuiKey_Pause;
		case (SDL.Scancode.INSERT) return ImGuiKey_.ImGuiKey_Insert;
		case (SDL.Scancode.HOME) return ImGuiKey_.ImGuiKey_Home;
		case (SDL.Scancode.PAGEUP) return ImGuiKey_.ImGuiKey_PageUp;
		case (SDL.Scancode.DELETE) return ImGuiKey_.ImGuiKey_Delete;
		case (SDL.Scancode.END) return ImGuiKey_.ImGuiKey_End;
		case (SDL.Scancode.PAGEDOWN) return ImGuiKey_.ImGuiKey_PageDown;
		case (SDL.Scancode.RIGHT) return ImGuiKey_.ImGuiKey_RightArrow;
		case (SDL.Scancode.LEFT) return ImGuiKey_.ImGuiKey_LeftArrow;
		case (SDL.Scancode.DOWN) return ImGuiKey_.ImGuiKey_DownArrow;
		case (SDL.Scancode.UP) return ImGuiKey_.ImGuiKey_UpArrow;
		case (SDL.Scancode.NUMLOCKCLEAR) return ImGuiKey_.ImGuiKey_NumLock;
		case (SDL.Scancode.KP_DIVIDE) return ImGuiKey_.ImGuiKey_KeypadDivide;
		case (SDL.Scancode.KP_MULTIPLY) return ImGuiKey_.ImGuiKey_KeypadMultiply;
		case (SDL.Scancode.KP_MINUS) return ImGuiKey_.ImGuiKey_KeypadSubtract;
		case (SDL.Scancode.KP_PLUS) return ImGuiKey_.ImGuiKey_KeypadAdd;
		case (SDL.Scancode.KP_ENTER) return ImGuiKey_.ImGuiKey_KeypadEnter;
		case (SDL.Scancode.KP_1) return ImGuiKey_.ImGuiKey_Keypad1;
		case (SDL.Scancode.KP_2) return ImGuiKey_.ImGuiKey_Keypad2;
		case (SDL.Scancode.KP_3) return ImGuiKey_.ImGuiKey_Keypad3;
		case (SDL.Scancode.KP_4) return ImGuiKey_.ImGuiKey_Keypad4;
		case (SDL.Scancode.KP_5) return ImGuiKey_.ImGuiKey_Keypad5;
		case (SDL.Scancode.KP_6) return ImGuiKey_.ImGuiKey_Keypad6;
		case (SDL.Scancode.KP_7) return ImGuiKey_.ImGuiKey_Keypad7;
		case (SDL.Scancode.KP_8) return ImGuiKey_.ImGuiKey_Keypad8;
		case (SDL.Scancode.KP_9) return ImGuiKey_.ImGuiKey_Keypad9;
		case (SDL.Scancode.KP_0) return ImGuiKey_.ImGuiKey_Keypad0;
		case (SDL.Scancode.KP_PERIOD) return ImGuiKey_.ImGuiKey_KeypadDecimal;
		case (SDL.Scancode.KP_EQUALS) return ImGuiKey_.ImGuiKey_KeypadEqual;
		case (SDL.Scancode.NONUSBACKSLASH) return ImGuiKey_.ImGuiKey_Oem102;
		case (SDL.Scancode.APPLICATION) return ImGuiKey_.ImGuiKey_Menu;
		case (SDL.Scancode.F13) return ImGuiKey_.ImGuiKey_F13;
		case (SDL.Scancode.F14) return ImGuiKey_.ImGuiKey_F14;
		case (SDL.Scancode.F15) return ImGuiKey_.ImGuiKey_F15;
		case (SDL.Scancode.F16) return ImGuiKey_.ImGuiKey_F16;
		case (SDL.Scancode.F17) return ImGuiKey_.ImGuiKey_F17;
		case (SDL.Scancode.F18) return ImGuiKey_.ImGuiKey_F18;
		case (SDL.Scancode.F19) return ImGuiKey_.ImGuiKey_F19;
		case (SDL.Scancode.F20) return ImGuiKey_.ImGuiKey_F20;
		case (SDL.Scancode.F21) return ImGuiKey_.ImGuiKey_F21;
		case (SDL.Scancode.F22) return ImGuiKey_.ImGuiKey_F22;
		case (SDL.Scancode.F23) return ImGuiKey_.ImGuiKey_F23;
		case (SDL.Scancode.F24) return ImGuiKey_.ImGuiKey_F24;
		case (SDL.Scancode.AC_BACK) return ImGuiKey_.ImGuiKey_AppBack;
		case (SDL.Scancode.AC_FORWARD) return ImGuiKey_.ImGuiKey_AppForward;
		case (SDL.Scancode.LCTRL) return ImGuiKey_.ImGuiKey_LeftCtrl;
		case (SDL.Scancode.LSHIFT) return ImGuiKey_.ImGuiKey_LeftShift;
		case (SDL.Scancode.LALT) return ImGuiKey_.ImGuiKey_LeftAlt;
		case (SDL.Scancode.LGUI) return ImGuiKey_.ImGuiKey_LeftSuper;
		case (SDL.Scancode.RCTRL) return ImGuiKey_.ImGuiKey_RightCtrl;
		case (SDL.Scancode.RSHIFT) return ImGuiKey_.ImGuiKey_RightShift;
		case (SDL.Scancode.RALT) return ImGuiKey_.ImGuiKey_RightAlt;
		case (SDL.Scancode.RGUI) return ImGuiKey_.ImGuiKey_RightSuper;
	}

	return ImGuiKey_.ImGuiKey_None;
}

UpdateKey(event: SDL.Event, data: *void)
{
	io := ImGui_GetIO();
	keyEvent := event.data.key;

	UpdateKeyModifiers(keyEvent.mod);

	key := MapScancodeToImGuiKey(keyEvent.scancode as SDL.Scancode);
	ImGuiIO_AddKeyEvent(io, key, keyEvent.down);
}

UpdateTextInput(event: SDL.Event, data: *void)
{
	io := ImGui_GetIO();
	ImGuiIO_AddInputCharactersUTF8(io, event.data.text.text);
}