package SDL

extern
{
	#link windows "./SDL3";

	bool SDL_PollEvent(event: *Event);
}

state CommonEvent 
{
    reserved: uint32,
    timestamp: uint64   // In nanoseconds, populated using SDL_GetTicksNS()
}

state DisplayEvent 
{
    displayID: uint32,  // The associated display 
    data1: int32,       // event dependent data 
    data2: int32        // event dependent data 
}

state WindowEvent 
{
    windowID: uint32,   // The associated window 
    data1: int32,       // event dependent data 
    data2: int32        // event dependent data 
}

state KeyboardDeviceEvent 
{
    keyboardID: uint32  // The keyboard instance id
}

state KeyboardEvent 
{
    windowID: uint32,   // The window with keyboard focus, if any 
    keyboardID: uint32, // The keyboard instance id, or 0 if unknown or virtual 
    scancode: uint32,   // SDL physical key code 
    key: uint32,        // SDL virtual key code 
    mod: uint32,        // current key modifiers 
    raw: uint16,        // The platform dependent scancode for this event 
    down: bool,         // true if the key is pressed 
    repeat: bool        // true if this is a key repeat 
}

state TextEditingEvent 
{
    windowID: uint32,   // The window with keyboard focus, if any 
    text: *byte,        // The editing text 
    start: int32,       // The start cursor of selected editing text, or -1 if not set 
    length: int32       // The length of selected editing text, or -1 if not set 
}

state TextEditingCandidatesEvent 
{
    windowID: uint32,           // The window with keyboard focus, if any 
    candidates: **byte,         // The list of candidates, or NULL if there are no candidates available 
    num_candidates: int32,      // The number of strings in `candidates` 
    selected_candidate: int32,  // The index of the selected candidate, or -1 if no candidate is selected 
    horizontal: bool,           // true if the list is horizontal, false if it's vertical 
    padding1: byte,
    padding2: byte,
    padding3: byte
}

state TextInputEvent 
{
    windowID: uint32,   // The window with keyboard focus, if any
    text: *byte         // The input text, UTF-8 encoded
}

state MouseDeviceEvent 
{
    mouseID: uint32     // The mouse instance id
}

state MouseMotionEvent 
{
    windowID: uint32,          // The window with mouse focus, if any 
    mouseID: uint32,           // The mouse instance id in relative mode, SDL_TOUCH_MOUSEID for touch events, or 0 
    mouseButtonFlags: uint32,  // The current button state 
    x: float32,                // X coordinate, relative to window 
    y: float32,                // Y coordinate, relative to window 
    xrel: float32,             // The relative motion in the X direction 
    yrel: float32              // The relative motion in the Y direction 
}

state MouseButtonEvent 
{
    windowID: uint32,   // The window with mouse focus, if any 
    mouseID: uint32,    // The mouse instance id in relative mode, SDL_TOUCH_MOUSEID for touch events, or 0 
    button: ubyte,      // The mouse button index 
    down: bool,         // true if the button is pressed 
    clicks: ubyte,      // 1 for single-click, 2 for double-click, etc. 
    padding: byte,
    x: float32,         // X coordinate, relative to window 
    y: float32          // Y coordinate, relative to window 
}

state MouseWheelEvent 
{
    windowID: uint32,   // The window with mouse focus, if any 
    mouseID: uint32,    // The mouse instance id in relative mode or 0 
    x: float32,         // The amount scrolled horizontally, positive to the right and negative to the left 
    y: float32,         // The amount scrolled vertically, positive away from the user and negative toward the user 
    direction: uint32,  // Set to one of the SDL_MOUSEWHEEL_* defines. When FLIPPED the values in X and Y will be opposite. Multiply by -1 to change them back 
    mouse_x: float32,   // X coordinate, relative to window 
    mouse_y: float32    // Y coordinate, relative to window 
}

state JoyDeviceEvent 
{
    joystickID: uint32    // The joystick instance id
}

state JoyAxisEvent 
{
    joystickID: uint32,   // The joystick instance id
    axis: ubyte,          // The joystick axis index
    padding1: byte,
    padding2: byte,
    padding3: byte,
    value: int16,         // The axis value (range: -32768 to 32767)
    padding4: uint16
}

state JoyBallEvent 
{
    joystickID: uint32,   // The joystick instance id
    ball: ubyte,          // The joystick trackball index 
    padding1: byte,
    padding2: byte,
    padding3: byte,
    xrel: int16,          // The relative motion in the X direction 
    yrel: int16           // The relative motion in the Y direction 
}

state JoyHatEvent 
{
    joystickID: uint32,   // The joystick instance id
    hat: ubyte,           // The joystick hat index
    value: ubyte,         // The hat position value.
                          // \sa SDL_HAT_LEFTUP SDL_HAT_UP SDL_HAT_RIGHTUP
                          // \sa SDL_HAT_LEFT SDL_HAT_CENTERED SDL_HAT_RIGHT
                          // \sa SDL_HAT_LEFTDOWN SDL_HAT_DOWN SDL_HAT_RIGHTDOWN
                          // Note that zero means the POV is centered.
    padding1: byte,
    padding2: byte
}

state JoyButtonEvent 
{
    joystickID: uint32,   // The joystick instance id
    button: ubyte,        // The joystick button index 
    down: bool,           // true if the button is pressed 
    padding1: byte,
    padding2: byte
}

state JoyBatteryEvent 
{
    joystickID: uint32,   // The joystick instance id
    batteryState: uint32, // The joystick battery state */
    percent: int32        // The joystick battery percent charge remaining */
}

state GamepadDeviceEvent 
{
    joystickID: uint32,   // The joystick instance id
}

state GamepadAxisEvent 
{
    joystickID: uint32,   // The joystick instance id
    axis: ubyte,          // The gamepad axis index
    padding1: byte,
    padding2: byte,
    padding3: byte,
    value: int16,         // The axis value (range: -32768 to 32767)
    padding4: uint16
}

state GamepadButtonEvent 
{
    joystickID: uint32,   // The joystick instance id
    button: ubyte,        // The gamepad button
    down: bool,           // true if the button is pressed 
    padding1: byte,
    padding2: byte
}

state GamepadTouchpadEvent 
{
    joystickID: uint32,   // The joystick instance id
    touchpad: int32,      // The index of the touchpad 
    finger: int32,        // The index of the finger on the touchpad 
    x: float32,           // Normalized in the range 0...1 with 0 being on the left 
    y: float32,           // Normalized in the range 0...1 with 0 being at the top 
    pressure: float32     // Normalized in the range 0...1 
}

state GamepadSensorEvent 
{
    joystickID: uint32,         // The joystick instance id
    sensor: int32,              // The type of the sensor, one of the values of SDL_SensorType
    data: [3]float32,           // Up to 3 values from the sensor, as defined in SDL_sensor.h
    sensor_timestamp: uint64    // The timestamp of the sensor reading in nanoseconds, not necessarily synchronized with the system clock
}

state AudioDeviceEvent 
{
    audioDeviceID: uint32,  // SDL_AudioDeviceID for the device being added or removed or changing 
    recording: bool,        // false if a playback device, true if a recording device. 
    padding1: byte,
    padding2: byte,
    padding3: byte
}

state CameraDeviceEvent 
{
    cameraID: uint32    // SDL_CameraID for the device being added or removed or changing
}

state SensorEvent 
{
    sensorID: uint32,           // The instance ID of the sensor 
    data: [6]float32,           // Up to 6 values from the sensor - additional values can be queried using SDL_GetSensorData() 
    sensor_timestamp: uint64    // The timestamp of the sensor reading in nanoseconds, not necessarily synchronized with the system clock 
}

state UserEvent 
{
    windowID: uint32,   // The associated window if any
    code: int32,        // User defined event code
    data1: *void,       // User defined data pointer
    data2: *void        // User defined data pointer
}

state TouchFingerEvent 
{
    touchID: uint64,    // The touch device id 
    fingerID: uint64,
    x: float32,         // Normalized in the range 0...1 
    y: float32,         // Normalized in the range 0...1 
    dx: float32,        // Normalized in the range -1...1 
    dy: float32,        // Normalized in the range -1...1 
    pressure: float32,  // Normalized in the range 0...1 
    windowID: uint32    // The window underneath the finger, if any 
}

state PenProximityEvent 
{
    windowID: uint32,   // The window with pen focus, if any 
    penID: uint32       // The pen instance id 
}

state PenTouchEvent 
{
    windowID: uint32,   // The window with pen focus, if any 
    penID: uint32,      // The pen instance id 
    pen_state: uint32,  // Complete pen input state at time of event 
    x: float32,         // X coordinate, relative to window 
    y: float32,         // Y coordinate, relative to window 
    eraser: bool,       // true if eraser end is used (not all pens support this). 
    down: bool          // true if the pen is touching or false if the pen is lifted off 
}

state PenMotionEvent 
{
    windowID: uint32,   // The window with pen focus, if any 
    penID: uint32,      // The pen instance id 
    pen_state: uint32,  // Complete pen input state at time of event 
    x: float32,         // X coordinate, relative to window 
    y: float32          // Y coordinate, relative to window 
}

state PenButtonEvent 
{
    windowID: uint32,   // The window with pen focus, if any 
    penID: uint32,      // The pen instance id 
    pen_state: uint32,  // Complete pen input state at time of event 
    x: float32,         // X coordinate, relative to window 
    y: float32,         // Y coordinate, relative to window 
    button: ubyte,      // The pen button index (first button is 1). 
    down: bool          // true if the button is pressed 
}

state PenAxisEvent 
{
    windowID: uint32,   // The window with pen focus, if any 
    penID: uint32,      // The pen instance id 
    pen_state: uint32,  // Complete pen input state at time of event 
    x: float32,         // X coordinate, relative to window 
    y: float32,         // Y coordinate, relative to window 
    axis: uint32,       // Axis that has changed
    value: float32      // New value of axis
}

state RenderEvent 
{
    windowID: uint32    // The window containing the renderer in question.
}

state DropEvent 
{
    windowID: uint32,   // The window that was dropped on, if any 
    x: float32,         // X coordinate, relative to window (not on begin) 
    y: float32,         // Y coordinate, relative to window (not on begin) 
    source: *byte,      // The source app that sent this drop event, or NULL if that isn't available 
    data: *byte         // The text for SDL_EVENT_DROP_TEXT and the file name for SDL_EVENT_DROP_FILE, NULL for other events 
}

state ClipboardEvent 
{
    owner: bool,            // are we owning the clipboard (internal update) 
    num_mime_types: int32,  // number of mime types 
    mime_types: **byte      // current mime types 
}

enum EventType: uint32
{
    FIRST         = 0,     // Unused (do not remove) 

    // Application events 
    QUIT           = 0x100, // User-requested quit 

    // These application events have special meaning on iOS and Android, see README-ios.md and README-android.md for details 
    TERMINATING,      // The application is being terminated by the OS. This event must be handled in a callback set with SDL_AddEventWatch().
                      // Called on iOS in applicationWillTerminate()
                      // Called on Android in onDestroy()

    LOW_MEMORY,       // The application is low on memory, free memory if possible. This event must be handled in a callback set with SDL_AddEventWatch().
                      // Called on iOS in applicationDidReceiveMemoryWarning()
                      // Called on Android in onTrimMemory()

    WILL_ENTER_BACKGROUND, // The application is about to enter the background. This event must be handled in a callback set with SDL_AddEventWatch().
                           // Called on iOS in applicationWillResignActive()
                           // Called on Android in onPause()

    DID_ENTER_BACKGROUND,  // The application did enter the background and may not get CPU for some time. This event must be handled in a callback set with SDL_AddEventWatch().
                           // Called on iOS in applicationDidEnterBackground()
                           // Called on Android in onPause()

    WILL_ENTER_FOREGROUND, // The application is about to enter the foreground. This event must be handled in a callback set with SDL_AddEventWatch().
                           // Called on iOS in applicationWillEnterForeground()
                           // Called on Android in onResume()

    DID_ENTER_FOREGROUND,  // The application is now interactive. This event must be handled in a callback set with SDL_AddEventWatch().
                           // Called on iOS in applicationDidBecomeActive()
                           // Called on Android in onResume()

    LOCALE_CHANGED,        // The user's locale preferences have changed. 

    SYSTEM_THEME_CHANGED,  // The system theme changed 

    // Display events 
    // 0x150 was SDL_DISPLAYEVENT, reserve the number for sdl2-compat 
    DISPLAY_ORIENTATION = 0x151,   // Display orientation has changed to data1 
    DISPLAY_ADDED,                 // Display has been added to the system 
    DISPLAY_REMOVED,               // Display has been removed from the system 
    DISPLAY_MOVED,                 // Display has changed position 
    DISPLAY_DESKTOP_MODE_CHANGED,  // Display has changed desktop mode 
    DISPLAY_CURRENT_MODE_CHANGED,  // Display has changed current mode 
    DISPLAY_CONTENT_SCALE_CHANGED, // Display has changed content scale 
    DISPLAY_FIRST = EventType.DISPLAY_ORIENTATION,
    DISPLAY_LAST = EventType.DISPLAY_CONTENT_SCALE_CHANGED,

    // Window events 
    // 0x200 was SDL_WINDOWEVENT, reserve the number for sdl2-compat 
    // 0x201 was SDL_SYSWMEVENT, reserve the number for sdl2-compat 
    WINDOW_SHOWN = 0x202,     // Window has been shown 
    WINDOW_HIDDEN,            // Window has been hidden 
    WINDOW_EXPOSED,           // Window has been exposed and should be redrawn, and can be redrawn directly from event watchers for this event 
    WINDOW_MOVED,             // Window has been moved to data1, data2 
    WINDOW_RESIZED,           // Window has been resized to data1xdata2 
    WINDOW_PIXEL_SIZE_CHANGED,// The pixel size of the window has changed to data1xdata2 
    WINDOW_METAL_VIEW_RESIZED,// The pixel size of a Metal view associated with the window has changed 
    WINDOW_MINIMIZED,         // Window has been minimized 
    WINDOW_MAXIMIZED,         // Window has been maximized 
    WINDOW_RESTORED,          // Window has been restored to normal size and position 
    WINDOW_MOUSE_ENTER,       // Window has gained mouse focus 
    WINDOW_MOUSE_LEAVE,       // Window has lost mouse focus 
    WINDOW_FOCUS_GAINED,      // Window has gained keyboard focus 
    WINDOW_FOCUS_LOST,        // Window has lost keyboard focus 
    WINDOW_CLOSE_REQUESTED,   // The window manager requests that the window be closed 
    WINDOW_HIT_TEST,          // Window had a hit test that wasn't SDL_HITTEST_NORMAL 
    WINDOW_ICCPROF_CHANGED,   // The ICC profile of the window's display has changed 
    WINDOW_DISPLAY_CHANGED,   // Window has been moved to display data1 
    WINDOW_DISPLAY_SCALE_CHANGED, // Window display scale has been changed 
    WINDOW_SAFE_AREA_CHANGED, // The window safe area has been changed 
    WINDOW_OCCLUDED,          // The window has been occluded 
    WINDOW_ENTER_FULLSCREEN,  // The window has entered fullscreen mode 
    WINDOW_LEAVE_FULLSCREEN,  // The window has left fullscreen mode 
    WINDOW_DESTROYED,         // The window with the associated ID is being or has been destroyed. If this message is being handled
                              // in an event watcher, the window handle is still valid and can still be used to retrieve any properties
                              // associated with the window. Otherwise, the handle has already been destroyed and all resources
                              // associated with it are invalid

    WINDOW_HDR_STATE_CHANGED, // Window HDR properties have changed 
    WINDOW_FIRST = EventType.WINDOW_SHOWN,
    WINDOW_LAST = EventType.WINDOW_HDR_STATE_CHANGED,

    // Keyboard events 
    KEY_DOWN        = 0x300, // Key pressed 
    KEY_UP,                  // Key released 
    TEXT_EDITING,            // Keyboard text editing (composition) 
    TEXT_INPUT,              // Keyboard text input 
    KEYMAP_CHANGED,          // Keymap changed due to a system event such as input language or keyboard layout change. 
    KEYBOARD_ADDED,          // A new keyboard has been inserted into the system 
    KEYBOARD_REMOVED,        // A keyboard has been removed 
    TEXT_EDITING_CANDIDATES, // Keyboard text editing candidates 

    // Mouse events 
    MOUSE_MOTION    = 0x400, // Mouse moved 
    MOUSE_BUTTON_DOWN,       // Mouse button pressed 
    MOUSE_BUTTON_UP,         // Mouse button released 
    MOUSE_WHEEL,             // Mouse wheel motion 
    MOUSE_ADDED,             // A new mouse has been inserted into the system 
    MOUSE_REMOVED,           // A mouse has been removed 

    // Joystick events 
    JOYSTICK_AXIS_MOTION  = 0x600, // Joystick axis motion 
    JOYSTICK_BALL_MOTION,          // Joystick trackball motion 
    JOYSTICK_HAT_MOTION,           // Joystick hat position change 
    JOYSTICK_BUTTON_DOWN,          // Joystick button pressed 
    JOYSTICK_BUTTON_UP,            // Joystick button released 
    JOYSTICK_ADDED,                // A new joystick has been inserted into the system 
    JOYSTICK_REMOVED,              // An opened joystick has been removed 
    JOYSTICK_BATTERY_UPDATED,      // Joystick battery level change 
    JOYSTICK_UPDATE_COMPLETE,      // Joystick update is complete 

    // Gamepad events 
    GAMEPAD_AXIS_MOTION  = 0x650, // Gamepad axis motion 
    GAMEPAD_BUTTON_DOWN,          // Gamepad button pressed 
    GAMEPAD_BUTTON_UP,            // Gamepad button released 
    GAMEPAD_ADDED,                // A new gamepad has been inserted into the system 
    GAMEPAD_REMOVED,              // A gamepad has been removed 
    GAMEPAD_REMAPPED,             // The gamepad mapping was updated 
    GAMEPAD_TOUCHPAD_DOWN,        // Gamepad touchpad was touched 
    GAMEPAD_TOUCHPAD_MOTION,      // Gamepad touchpad finger was moved 
    GAMEPAD_TOUCHPAD_UP,          // Gamepad touchpad finger was lifted 
    GAMEPAD_SENSOR_UPDATE,        // Gamepad sensor was updated 
    GAMEPAD_UPDATE_COMPLETE,      // Gamepad update is complete 
    GAMEPAD_STEAM_HANDLE_UPDATED, // Gamepad Steam handle has changed 

    // Touch events 
    FINGER_DOWN      = 0x700,
    FINGER_UP,
    FINGER_MOTION,
    FINGER_CANCELED,

    // 0x800, 0x801, and 0x802 were the Gesture events from SDL2. Do not reuse these values! sdl2-compat needs them! 

    // Clipboard events 
    CLIPBOARD_UPDATE = 0x900, // The clipboard or primary selection changed 

    // Drag and drop events 
    DROP_FILE        = 0x1000, // The system requests a file open 
    DROP_TEXT,                 // text/plain drag-and-drop event 
    DROP_BEGIN,                // A new set of drops is beginning (NULL filename) 
    DROP_COMPLETE,             // Current set of drops is now complete (NULL filename) 
    DROP_POSITION,             // Position while moving over the window 

    // Audio hotplug events 
    AUDIO_DEVICE_ADDED = 0x1100,  // A new audio device is available 
    AUDIO_DEVICE_REMOVED,         // An audio device has been removed. 
    AUDIO_DEVICE_FORMAT_CHANGED,  // An audio device's format has been changed by the system. 

    // Sensor events 
    SENSOR_UPDATE = 0x1200,     // A sensor was updated 

    // Pressure-sensitive pen events 
    PEN_PROXIMITY_IN = 0x1300,  // Pressure-sensitive pen has become available 
    PEN_PROXIMITY_OUT,          // Pressure-sensitive pen has become unavailable 
    PEN_DOWN,                   // Pressure-sensitive pen touched drawing surface 
    PEN_UP,                     // Pressure-sensitive pen stopped touching drawing surface 
    PEN_BUTTON_DOWN,            // Pressure-sensitive pen button pressed 
    PEN_BUTTON_UP,              // Pressure-sensitive pen button released 
    PEN_MOTION,                 // Pressure-sensitive pen is moving on the tablet 
    PEN_AXIS,                   // Pressure-sensitive pen angle/pressure/etc changed 

    // Camera hotplug events 
    CAMERA_DEVICE_ADDED = 0x1400,  // A new camera device is available 
    CAMERA_DEVICE_REMOVED,         // A camera device has been removed. 
    CAMERA_DEVICE_APPROVED,        // A camera device has been approved for use by the user. 
    CAMERA_DEVICE_DENIED,          // A camera device has been denied for use by the user. 

    // Render events 
    RENDER_TARGETS_RESET = 0x2000, // The render targets have been reset and their contents need to be updated 
    RENDER_DEVICE_RESET,           // The device has been reset and all textures need to be recreated 
    RENDER_DEVICE_LOST,            // The device has been lost and can't be recovered. 

    // Reserved events for private platforms 
    PRIVATE0 = 0x4000,
    PRIVATE1,
    PRIVATE2,
    PRIVATE3,

    // Internal events 
    POLL_SENTINEL = 0x7F00, // Signals the end of an event poll cycle 

    // Events USER through LAST are for your use,
    // and should be allocated with SDL_RegisterEvents()
    USER    = 0x8000,

    // This last event is only for bounding internal arrays
    LAST    = 0xFFFF,
}

LogEventType(type: EventType)
{
    switch (type)
    {
        case (EventType.FIRST) log "FIRST";
        case (EventType.QUIT) log "QUIT";
        case (EventType.TERMINATING) log "TERMINATING";
        case (EventType.LOW_MEMORY) log "LOW_MEMORY";
        case (EventType.WILL_ENTER_BACKGROUND) log "WILL_ENTER_BACKGROUND";
        case (EventType.DID_ENTER_BACKGROUND) log "DID_ENTER_BACKGROUND";
        case (EventType.WILL_ENTER_FOREGROUND) log "WILL_ENTER_FOREGROUND";
        case (EventType.DID_ENTER_FOREGROUND) log "DID_ENTER_FOREGROUND";
        case (EventType.LOCALE_CHANGED) log "LOCALE_CHANGED";
        case (EventType.SYSTEM_THEME_CHANGED) log "SYSTEM_THEME_CHANGED";
        case (EventType.DISPLAY_ORIENTATION) log "DISPLAY_ORIENTATION";
        case (EventType.DISPLAY_ADDED) log "DISPLAY_ADDED";
        case (EventType.DISPLAY_REMOVED) log "DISPLAY_REMOVED";
        case (EventType.DISPLAY_MOVED) log "DISPLAY_MOVED";
        case (EventType.DISPLAY_DESKTOP_MODE_CHANGED) log "DISPLAY_DESKTOP_MODE_CHANGED";
        case (EventType.DISPLAY_CURRENT_MODE_CHANGED) log "DISPLAY_CURRENT_MODE_CHANGED";
        case (EventType.DISPLAY_CONTENT_SCALE_CHANGED) log "DISPLAY_CONTENT_SCALE_CHANGED";
        case (EventType.WINDOW_SHOWN) log "WINDOW_SHOWN";
        case (EventType.WINDOW_HIDDEN) log "WINDOW_HIDDEN";
        case (EventType.WINDOW_EXPOSED) log "WINDOW_EXPOSED";
        case (EventType.WINDOW_MOVED) log "WINDOW_MOVED";
        case (EventType.WINDOW_RESIZED) log "WINDOW_RESIZED";
        case (EventType.WINDOW_PIXEL_SIZE_CHANGED) log "WINDOW_PIXEL_SIZE_CHANGED";
        case (EventType.WINDOW_METAL_VIEW_RESIZED) log "WINDOW_METAL_VIEW_RESIZED";
        case (EventType.WINDOW_MINIMIZED) log "WINDOW_MINIMIZED";
        case (EventType.WINDOW_MAXIMIZED) log "WINDOW_MAXIMIZED";
        case (EventType.WINDOW_RESTORED) log "WINDOW_RESTORED";
        case (EventType.WINDOW_MOUSE_ENTER) log "WINDOW_MOUSE_ENTER";
        case (EventType.WINDOW_MOUSE_LEAVE) log "WINDOW_MOUSE_LEAVE";
        case (EventType.WINDOW_FOCUS_GAINED) log "WINDOW_FOCUS_GAINED";
        case (EventType.WINDOW_FOCUS_LOST) log "WINDOW_FOCUS_LOST";
        case (EventType.WINDOW_CLOSE_REQUESTED) log "WINDOW_CLOSE_REQUESTED";
        case (EventType.WINDOW_HIT_TEST) log "WINDOW_HIT_TEST";
        case (EventType.WINDOW_ICCPROF_CHANGED) log "WINDOW_ICCPROF_CHANGED";
        case (EventType.WINDOW_DISPLAY_CHANGED) log "WINDOW_DISPLAY_CHANGED";
        case (EventType.WINDOW_DISPLAY_SCALE_CHANGED) log "WINDOW_DISPLAY_SCALE_CHANGED";
        case (EventType.WINDOW_SAFE_AREA_CHANGED) log "WINDOW_SAFE_AREA_CHANGED";
        case (EventType.WINDOW_OCCLUDED) log "WINDOW_OCCLUDED";
        case (EventType.WINDOW_ENTER_FULLSCREEN) log "WINDOW_ENTER_FULLSCREEN";
        case (EventType.WINDOW_LEAVE_FULLSCREEN) log "WINDOW_LEAVE_FULLSCREEN";
        case (EventType.WINDOW_DESTROYED) log "WINDOW_DESTROYED";
        case (EventType.WINDOW_HDR_STATE_CHANGED) log "WINDOW_HDR_STATE_CHANGED";
        case (EventType.KEY_DOWN) log "KEY_DOWN";
        case (EventType.KEY_UP) log "KEY_UP";
        case (EventType.TEXT_EDITING) log "TEXT_EDITING";
        case (EventType.TEXT_INPUT) log "TEXT_INPUT";
        case (EventType.KEYMAP_CHANGED) log "KEYMAP_CHANGED";
        case (EventType.KEYBOARD_ADDED) log "KEYBOARD_ADDED";
        case (EventType.KEYBOARD_REMOVED) log "KEYBOARD_REMOVED";
        case (EventType.TEXT_EDITING_CANDIDATES) log "TEXT_EDITING_CANDIDATES";
        case (EventType.MOUSE_MOTION) log "MOUSE_MOTION";
        case (EventType.MOUSE_BUTTON_DOWN) log "MOUSE_BUTTON_DOWN";
        case (EventType.MOUSE_BUTTON_UP) log "MOUSE_BUTTON_UP";
        case (EventType.MOUSE_WHEEL) log "MOUSE_WHEEL";
        case (EventType.MOUSE_ADDED) log "MOUSE_ADDED";
        case (EventType.MOUSE_REMOVED) log "MOUSE_REMOVED";
        case (EventType.JOYSTICK_AXIS_MOTION) log "JOYSTICK_AXIS_MOTION";
        case (EventType.JOYSTICK_BALL_MOTION) log "JOYSTICK_BALL_MOTION";
        case (EventType.JOYSTICK_HAT_MOTION) log "JOYSTICK_HAT_MOTION";
        case (EventType.JOYSTICK_BUTTON_DOWN) log "JOYSTICK_BUTTON_DOWN";
        case (EventType.JOYSTICK_BUTTON_UP) log "JOYSTICK_BUTTON_UP";
        case (EventType.JOYSTICK_ADDED) log "JOYSTICK_ADDED";
        case (EventType.JOYSTICK_REMOVED) log "JOYSTICK_REMOVED";
        case (EventType.JOYSTICK_BATTERY_UPDATED) log "JOYSTICK_BATTERY_UPDATED";
        case (EventType.JOYSTICK_UPDATE_COMPLETE) log "JOYSTICK_UPDATE_COMPLETE";
        case (EventType.GAMEPAD_AXIS_MOTION) log "GAMEPAD_AXIS_MOTION";
        case (EventType.GAMEPAD_BUTTON_DOWN) log "GAMEPAD_BUTTON_DOWN";
        case (EventType.GAMEPAD_BUTTON_UP) log "GAMEPAD_BUTTON_UP";
        case (EventType.GAMEPAD_ADDED) log "GAMEPAD_ADDED";
        case (EventType.GAMEPAD_REMOVED) log "GAMEPAD_REMOVED";
        case (EventType.GAMEPAD_REMAPPED) log "GAMEPAD_REMAPPED";
        case (EventType.GAMEPAD_TOUCHPAD_DOWN) log "GAMEPAD_TOUCHPAD_DOWN";
        case (EventType.GAMEPAD_TOUCHPAD_MOTION) log "GAMEPAD_TOUCHPAD_MOTION";
        case (EventType.GAMEPAD_TOUCHPAD_UP) log "GAMEPAD_TOUCHPAD_UP";
        case (EventType.GAMEPAD_SENSOR_UPDATE) log "GAMEPAD_SENSOR_UPDATE";
        case (EventType.GAMEPAD_UPDATE_COMPLETE) log "GAMEPAD_UPDATE_COMPLETE";
        case (EventType.GAMEPAD_STEAM_HANDLE_UPDATED) log "GAMEPAD_STEAM_HANDLE_UPDATED";
        case (EventType.FINGER_DOWN) log "FINGER_DOWN";
        case (EventType.FINGER_UP) log "FINGER_UP";
        case (EventType.FINGER_MOTION) log "FINGER_MOTION";
        case (EventType.FINGER_CANCELED) log "FINGER_CANCELED";
        case (EventType.CLIPBOARD_UPDATE) log "CLIPBOARD_UPDATE";
        case (EventType.DROP_FILE) log "DROP_FILE";
        case (EventType.DROP_TEXT) log "DROP_TEXT";
        case (EventType.DROP_BEGIN) log "DROP_BEGIN";
        case (EventType.DROP_COMPLETE) log "DROP_COMPLETE";
        case (EventType.DROP_POSITION) log "DROP_POSITION";
        case (EventType.AUDIO_DEVICE_ADDED) log "AUDIO_DEVICE_ADDED";
        case (EventType.AUDIO_DEVICE_REMOVED) log "AUDIO_DEVICE_REMOVED";
        case (EventType.AUDIO_DEVICE_FORMAT_CHANGED) log "AUDIO_DEVICE_FORMAT_CHANGED";
        case (EventType.SENSOR_UPDATE) log "SENSOR_UPDATE";
        case (EventType.PEN_PROXIMITY_IN) log "PEN_PROXIMITY_IN";
        case (EventType.PEN_PROXIMITY_OUT) log "PEN_PROXIMITY_OUT";
        case (EventType.PEN_DOWN) log "PEN_DOWN";
        case (EventType.PEN_UP) log "PEN_UP";
        case (EventType.PEN_BUTTON_DOWN) log "PEN_BUTTON_DOWN";
        case (EventType.PEN_BUTTON_UP) log "PEN_BUTTON_UP";
        case (EventType.PEN_MOTION) log "PEN_MOTION";
        case (EventType.PEN_AXIS) log "PEN_AXIS";
        case (EventType.CAMERA_DEVICE_ADDED) log "CAMERA_DEVICE_ADDED";
        case (EventType.CAMERA_DEVICE_REMOVED) log "CAMERA_DEVICE_REMOVED";
        case (EventType.CAMERA_DEVICE_APPROVED) log "CAMERA_DEVICE_APPROVED";
        case (EventType.CAMERA_DEVICE_DENIED) log "CAMERA_DEVICE_DENIED";
        case (EventType.RENDER_TARGETS_RESET) log "RENDER_TARGETS_RESET";
        case (EventType.RENDER_DEVICE_RESET) log "RENDER_DEVICE_RESET";
        case (EventType.RENDER_DEVICE_LOST) log "RENDER_DEVICE_LOST";
        case (EventType.PRIVATE0) log "PRIVATE0";
        case (EventType.PRIVATE1) log "PRIVATE1";
        case (EventType.PRIVATE2) log "PRIVATE2";
        case (EventType.PRIVATE3) log "PRIVATE3";
        case (EventType.POLL_SENTINEL) log "POLL_SENTINEL";
        case (EventType.USER) log "USER";
        case (EventType.LAST) log "LAST";
        default log "Invalid Event Type", type;
    }
}

state Event
{
	type: EventType,                                  // Event type, shared with all events, Uint32 to cover user events which are not in the SDL_EventType enumeration 
    reserved: uint32,
    timestamp: uint64,                                // In nanoseconds, populated using SDL_GetTicksNS() 
    data: ?{
        display: DisplayEvent,                        // Display event data 
        window: WindowEvent,                          // Window event data 
        kdevice: KeyboardDeviceEvent,                 // Keyboard device change event data 
        key: KeyboardEvent,                           // Keyboard event data 
        edit: TextEditingEvent,                       // Text editing event data 
        edit_candidates: TextEditingCandidatesEvent,  // Text editing candidates event data 
        text: TextInputEvent,                         // Text input event data 
        mdevice: MouseDeviceEvent,                    // Mouse device change event data 
        motion: MouseMotionEvent,                     // Mouse motion event data 
        button: MouseButtonEvent,                     // Mouse button event data 
        wheel: MouseWheelEvent,                       // Mouse wheel event data 
        jdevice: JoyDeviceEvent,                      // Joystick device change event data 
        jaxis: JoyAxisEvent,                          // Joystick axis event data 
        jball: JoyBallEvent,                          // Joystick ball event data 
        jhat: JoyHatEvent,                            // Joystick hat event data 
        jbutton: JoyButtonEvent,                      // Joystick button event data 
        jbattery: JoyBatteryEvent,                    // Joystick battery event data 
        gdevice: GamepadDeviceEvent,                  // Gamepad device event data 
        gaxis: GamepadAxisEvent,                      // Gamepad axis event data 
        gbutton: GamepadButtonEvent,                  // Gamepad button event data 
        gtouchpad: GamepadTouchpadEvent,              // Gamepad touchpad event data 
        gsensor: GamepadSensorEvent,                  // Gamepad sensor event data 
        adevice: AudioDeviceEvent,                    // Audio device event data 
        cdevice: CameraDeviceEvent,                   // Camera device event data 
        sensor: SensorEvent,                          // Sensor event data 
        user: UserEvent,                              // Custom event data 
        tfinger: TouchFingerEvent,                    // Touch finger event data 
        pproximity: PenProximityEvent,                // Pen proximity event data 
        ptouch: PenTouchEvent,                        // Pen tip touching event data 
        pmotion: PenMotionEvent,                      // Pen motion event data 
        pbutton: PenButtonEvent,                      // Pen button event data 
        paxis: PenAxisEvent,                          // Pen axis event data 
        render: RenderEvent,                          // Render event data 
        drop: DropEvent,                              // Drag and drop event data 
        clipboard: ClipboardEvent                     // Clipboard event data 
    }
}

Event::log()
{
    LogEventType(this.type);
    log this.timestamp;
    switch (this.type)
    {
        case (EventType.FIRST) break;
        case (EventType.QUIT) break;
        case (EventType.TERMINATING) break;
        case (EventType.LOW_MEMORY) break;
        case (EventType.WILL_ENTER_BACKGROUND) break;
        case (EventType.DID_ENTER_BACKGROUND) break;
        case (EventType.WILL_ENTER_FOREGROUND) break;
        case (EventType.DID_ENTER_FOREGROUND) break;
        case (EventType.LOCALE_CHANGED) break;
        case (EventType.SYSTEM_THEME_CHANGED) break;

        case (EventType.DISPLAY_ORIENTATION) continue;
        case (EventType.DISPLAY_ADDED) continue;
        case (EventType.DISPLAY_REMOVED) continue;
        case (EventType.DISPLAY_MOVED) continue;
        case (EventType.DISPLAY_DESKTOP_MODE_CHANGED) continue;
        case (EventType.DISPLAY_CURRENT_MODE_CHANGED) continue;
        case (EventType.DISPLAY_CONTENT_SCALE_CHANGED) log this.data.display;
        
        case (EventType.WINDOW_SHOWN) continue;
        case (EventType.WINDOW_HIDDEN) continue;
        case (EventType.WINDOW_EXPOSED) continue;
        case (EventType.WINDOW_MOVED) continue;
        case (EventType.WINDOW_RESIZED) continue;
        case (EventType.WINDOW_PIXEL_SIZE_CHANGED) continue;
        case (EventType.WINDOW_METAL_VIEW_RESIZED) continue;
        case (EventType.WINDOW_MINIMIZED) continue;
        case (EventType.WINDOW_MAXIMIZED) continue;
        case (EventType.WINDOW_RESTORED) continue;
        case (EventType.WINDOW_MOUSE_ENTER) continue;
        case (EventType.WINDOW_MOUSE_LEAVE) continue;
        case (EventType.WINDOW_FOCUS_GAINED) continue;
        case (EventType.WINDOW_FOCUS_LOST) continue;
        case (EventType.WINDOW_CLOSE_REQUESTED) continue;
        case (EventType.WINDOW_HIT_TEST) continue;
        case (EventType.WINDOW_ICCPROF_CHANGED) continue;
        case (EventType.WINDOW_DISPLAY_CHANGED) continue;
        case (EventType.WINDOW_DISPLAY_SCALE_CHANGED) continue;
        case (EventType.WINDOW_SAFE_AREA_CHANGED) continue;
        case (EventType.WINDOW_OCCLUDED) continue;
        case (EventType.WINDOW_ENTER_FULLSCREEN) continue;
        case (EventType.WINDOW_LEAVE_FULLSCREEN) continue;
        case (EventType.WINDOW_DESTROYED) continue;
        case (EventType.WINDOW_HDR_STATE_CHANGED) log this.data.window;
        
        case (EventType.KEY_DOWN) continue;
        case (EventType.KEY_UP) log this.data.key;

        case (EventType.TEXT_EDITING) log this.data.edit;
        case (EventType.TEXT_INPUT) log this.data.text;
        case (EventType.KEYMAP_CHANGED) break;
        
        case (EventType.KEYBOARD_ADDED) continue;
        case (EventType.KEYBOARD_REMOVED) log this.data.kdevice;
        
        case (EventType.TEXT_EDITING_CANDIDATES) log this.data.edit_candidates;

        case (EventType.MOUSE_MOTION) log this.data.motion;

        case (EventType.MOUSE_BUTTON_DOWN) continue;
        case (EventType.MOUSE_BUTTON_UP) log this.data.button;

        case (EventType.MOUSE_WHEEL) log this.data.wheel;

        case (EventType.MOUSE_ADDED) continue;
        case (EventType.MOUSE_REMOVED) log this.data.mdevice;
        
        case (EventType.JOYSTICK_AXIS_MOTION) log this.data.jaxis;
        case (EventType.JOYSTICK_BALL_MOTION) log this.data.jball;
        case (EventType.JOYSTICK_HAT_MOTION) log this.data.jhat;
        case (EventType.JOYSTICK_BUTTON_DOWN) continue;
        case (EventType.JOYSTICK_BUTTON_UP) log this.data.jbutton;
        case (EventType.JOYSTICK_ADDED) continue;
        case (EventType.JOYSTICK_REMOVED) continue;
        case (EventType.JOYSTICK_UPDATE_COMPLETE) log this.data.jdevice;
        case (EventType.JOYSTICK_BATTERY_UPDATED) log this.data.jbattery;
        
        case (EventType.GAMEPAD_AXIS_MOTION) log this.data.gaxis;
        case (EventType.GAMEPAD_BUTTON_DOWN) continue;
        case (EventType.GAMEPAD_BUTTON_UP) log this.data.gbutton;
        case (EventType.GAMEPAD_ADDED) continue;
        case (EventType.GAMEPAD_REMOVED) continue;
        case (EventType.GAMEPAD_UPDATE_COMPLETE) continue;
        case (EventType.GAMEPAD_STEAM_HANDLE_UPDATED) continue;
        case (EventType.GAMEPAD_REMAPPED) log this.data.gdevice;
        case (EventType.GAMEPAD_TOUCHPAD_DOWN) continue;
        case (EventType.GAMEPAD_TOUCHPAD_MOTION) continue;
        case (EventType.GAMEPAD_TOUCHPAD_UP) log this.data.gtouchpad;
        case (EventType.GAMEPAD_SENSOR_UPDATE) log this.data.gsensor;
        
        case (EventType.FINGER_DOWN) continue;
        case (EventType.FINGER_UP) continue;
        case (EventType.FINGER_MOTION) log this.data.tfinger;
        case (EventType.FINGER_CANCELED) break;

        case (EventType.CLIPBOARD_UPDATE) log this.data.clipboard;

        case (EventType.DROP_FILE) continue;
        case (EventType.DROP_TEXT) continue;
        case (EventType.DROP_BEGIN) continue;
        case (EventType.DROP_COMPLETE) continue;
        case (EventType.DROP_POSITION) log this.data.drop;
        
        case (EventType.AUDIO_DEVICE_ADDED) continue;
        case (EventType.AUDIO_DEVICE_REMOVED) continue;
        case (EventType.AUDIO_DEVICE_FORMAT_CHANGED) log this.data.adevice;

        case (EventType.SENSOR_UPDATE) log this.data.sensor;

        case (EventType.PEN_PROXIMITY_IN) continue;
        case (EventType.PEN_PROXIMITY_OUT) log this.data.pproximity;
        case (EventType.PEN_DOWN) continue;
        case (EventType.PEN_UP) log this.data.ptouch;
        case (EventType.PEN_BUTTON_DOWN) continue;
        case (EventType.PEN_BUTTON_UP) log this.data.pbutton;
        case (EventType.PEN_MOTION) log this.data.pmotion;
        case (EventType.PEN_AXIS) log this.data.paxis;

        case (EventType.CAMERA_DEVICE_ADDED) continue;
        case (EventType.CAMERA_DEVICE_REMOVED) continue;
        case (EventType.CAMERA_DEVICE_APPROVED) continue;
        case (EventType.CAMERA_DEVICE_DENIED) log this.data.cdevice;
        
        case (EventType.RENDER_TARGETS_RESET) continue;
        case (EventType.RENDER_DEVICE_RESET) continue;
        case (EventType.RENDER_DEVICE_LOST) log this.data.render;

        case (EventType.PRIVATE0) break;
        case (EventType.PRIVATE1) break;
        case (EventType.PRIVATE2) break;
        case (EventType.PRIVATE3) break;
        case (EventType.POLL_SENTINEL) break;

        case (EventType.USER) log this.data.user;

        case (EventType.LAST) break;
        default break;
    }
}

bool PollEvent(outEvent: *Event) => SDL_PollEvent(outEvent);
