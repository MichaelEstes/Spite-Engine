package SDL

extern
{
	#link windows "./extern/SDL3";
    #link linux "./extern/libSDL3";

	*Window SDL_CreateWindow(title: *byte, w: int32, h: int32, flags: uint64);
	void SDL_DestroyWindow(window: *Window);
	bool SDL_Init(flags: uint32);
	void SDL_Quit();
	bool SDL_GetWindowSizeInPixels(window: *Window, width: *int32, height: *int32);
	*byte SDL_GetError();

    *Surface SDL_ConvertSurface(surface: *Surface, format: PixelFormat);
    void SDL_DestroySurface(surface: *Surface);
}

enum InitFlags
{
	AUDIO      = 0x00000010,	// `SDL_INIT_AUDIO` implies `SDL_INIT_EVENTS` */
	VIDEO      = 0x00000020,	// `SDL_INIT_VIDEO` implies `SDL_INIT_EVENTS`, should be initialized on the main thread */
	JOYSTICK   = 0x00000200,	// `SDL_INIT_JOYSTICK` implies `SDL_INIT_EVENTS`, should be initialized on the same thread as SDL_INIT_VIDEO on Windows if you don't set SDL_HINT_JOYSTICK_THREAD */
	HAPTIC     = 0x00001000,	
	GAMEPAD    = 0x00002000,	// `SDL_INIT_GAMEPAD` implies `SDL_INIT_JOYSTICK` */
	EVENTS     = 0x00004000,	
	SENSOR     = 0x00008000,	// `SDL_INIT_SENSOR` implies `SDL_INIT_EVENTS` */
	CAMERA     = 0x00010000		// `SDL_INIT_CAMERA` implies `SDL_INIT_EVENTS` */
}

enum WindowFlags: uint64
{
	Fullscreen          = 0x0000000000000001,	// window is in fullscreen mode 
	OpenGL              = 0x0000000000000002,	// window usable with OpenGL context 
	Occluded            = 0x0000000000000004,	// window is occluded 
	Hidden              = 0x0000000000000008,	// window is neither mapped onto the desktop nor shown in the taskbar/dock/window list; SDL_ShowWindow() is required for it to become visible 
	Borderless          = 0x0000000000000010,	// no window decoration 
	Resizable           = 0x0000000000000020,	// window can be resized 
	Minimized           = 0x0000000000000040,	// window is minimized 
	Maximized           = 0x0000000000000080,	// window is maximized 
	MouseGrabbed        = 0x0000000000000100,	// window has grabbed mouse input 
	InputFocus          = 0x0000000000000200,	// window has input focus 
	MouseFocus          = 0x0000000000000400,	// window has mouse focus 
	External            = 0x0000000000000800,	// window not created by SDL 
	Modal               = 0x0000000000001000,	// window is modal 
	HighPixelDensity    = 0x0000000000002000,	// window uses high pixel density back buffer if possible 
	MouseCapture        = 0x0000000000004000,	// window has mouse captured (unrelated to MouseGrabbed) 
	MouseRelativeMode   = 0x0000000000008000,	// window has relative mode enabled 
	AlwaysOnTop         = 0x0000000000010000,	// window should always be above others 
	Utility             = 0x0000000000020000,	// window should be treated as a utility window, not showing in the task bar and window list 
	Tooltip             = 0x0000000000040000,	// window should be treated as a tooltip and does not get mouse or keyboard focus, requires a parent window 
	PopupMenu           = 0x0000000000080000,	// window should be treated as a popup menu, requires a parent window 
	KeyboardGrabbed     = 0x0000000000100000,	// window has grabbed keyboard input 
	Vulkan              = 0x0000000010000000,	// window usable for Vulkan surface 
	Metal               = 0x0000000020000000,	// window usable for Metal view 
	Transparent         = 0x0000000040000000,	// window with transparent buffer 
	NotFocusable        = 0x0000000080000000	// window should not be focusable 
}

enum PixelFormat: uint32
{
    UNKNOWN = 0,
    INDEX1LSB = 0x11100100,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX1, SDL_BITMAPORDER_4321, 0, 1, 0), 
    INDEX1MSB = 0x11200100,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX1, SDL_BITMAPORDER_1234, 0, 1, 0), 
    INDEX2LSB = 0x1c100200,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX2, SDL_BITMAPORDER_4321, 0, 2, 0), 
    INDEX2MSB = 0x1c200200,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX2, SDL_BITMAPORDER_1234, 0, 2, 0), 
    INDEX4LSB = 0x12100400,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX4, SDL_BITMAPORDER_4321, 0, 4, 0), 
    INDEX4MSB = 0x12200400,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX4, SDL_BITMAPORDER_1234, 0, 4, 0), 
    INDEX8 = 0x13000801,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_INDEX8, 0, 0, 8, 1), 
    RGB332 = 0x14110801,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED8, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_332, 8, 1), 
    XRGB4444 = 0x15120c02,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_4444, 12, 2), 
    XBGR4444 = 0x15520c02,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_4444, 12, 2), 
    XRGB1555 = 0x15130f02,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_1555, 15, 2), 
    XBGR1555 = 0x15530f02,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_1555, 15, 2), 
    ARGB4444 = 0x15321002,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_4444, 16, 2), 
    RGBA4444 = 0x15421002,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_RGBA, SDL_PACKEDLAYOUT_4444, 16, 2), 
    ABGR4444 = 0x15721002,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_4444, 16, 2), 
    BGRA4444 = 0x15821002,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_BGRA, SDL_PACKEDLAYOUT_4444, 16, 2), 
    ARGB1555 = 0x15331002,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_1555, 16, 2), 
    RGBA5551 = 0x15441002,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_RGBA, SDL_PACKEDLAYOUT_5551, 16, 2), 
    ABGR1555 = 0x15731002,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_1555, 16, 2), 
    BGRA5551 = 0x15841002,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_BGRA, SDL_PACKEDLAYOUT_5551, 16, 2), 
    RGB565 = 0x15151002,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_565, 16, 2), 
    BGR565 = 0x15551002,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED16, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_565, 16, 2), 
    RGB24 = 0x17101803,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU8, SDL_ARRAYORDER_RGB, 0, 24, 3), 
    BGR24 = 0x17401803,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU8, SDL_ARRAYORDER_BGR, 0, 24, 3), 
    XRGB8888 = 0x16161804,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_8888, 24, 4), 
    RGBX8888 = 0x16261804,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_RGBX, SDL_PACKEDLAYOUT_8888, 24, 4), 
    XBGR8888 = 0x16561804,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_8888, 24, 4), 
    BGRX8888 = 0x16661804,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_BGRX, SDL_PACKEDLAYOUT_8888, 24, 4), 
    ARGB8888 = 0x16362004,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_8888, 32, 4), 
    RGBA8888 = 0x16462004,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_RGBA, SDL_PACKEDLAYOUT_8888, 32, 4), 
    ABGR8888 = 0x16762004,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_8888, 32, 4), 
    BGRA8888 = 0x16862004,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_BGRA, SDL_PACKEDLAYOUT_8888, 32, 4), 
    XRGB2101010 = 0x16172004,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XRGB, SDL_PACKEDLAYOUT_2101010, 32, 4), 
    XBGR2101010 = 0x16572004,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_XBGR, SDL_PACKEDLAYOUT_2101010, 32, 4), 
    ARGB2101010 = 0x16372004,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ARGB, SDL_PACKEDLAYOUT_2101010, 32, 4), 
    ABGR2101010 = 0x16772004,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_PACKED32, SDL_PACKEDORDER_ABGR, SDL_PACKEDLAYOUT_2101010, 32, 4), 
    RGB48 = 0x18103006,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_RGB, 0, 48, 6), 
    BGR48 = 0x18403006,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_BGR, 0, 48, 6), 
    RGBA64 = 0x18204008,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_RGBA, 0, 64, 8), 
    ARGB64 = 0x18304008,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_ARGB, 0, 64, 8), 
    BGRA64 = 0x18504008,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_BGRA, 0, 64, 8), 
    ABGR64 = 0x18604008,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYU16, SDL_ARRAYORDER_ABGR, 0, 64, 8), 
    RGB48_FLOAT = 0x1a103006,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_RGB, 0, 48, 6), 
    BGR48_FLOAT = 0x1a403006,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_BGR, 0, 48, 6), 
    RGBA64_FLOAT = 0x1a204008,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_RGBA, 0, 64, 8), 
    ARGB64_FLOAT = 0x1a304008,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_ARGB, 0, 64, 8), 
    BGRA64_FLOAT = 0x1a504008,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_BGRA, 0, 64, 8), 
    ABGR64_FLOAT = 0x1a604008,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF16, SDL_ARRAYORDER_ABGR, 0, 64, 8), 
    RGB96_FLOAT = 0x1b10600c,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_RGB, 0, 96, 12), 
    BGR96_FLOAT = 0x1b40600c,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_BGR, 0, 96, 12), 
    RGBA128_FLOAT = 0x1b208010,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_RGBA, 0, 128, 16), 
    ARGB128_FLOAT = 0x1b308010,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_ARGB, 0, 128, 16), 
    BGRA128_FLOAT = 0x1b508010,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_BGRA, 0, 128, 16), 
    ABGR128_FLOAT = 0x1b608010,
    // SDL_DEFINE_PIXELFORMAT(SDL_PIXELTYPE_ARRAYF32, SDL_ARRAYORDER_ABGR, 0, 128, 16), 

    YV12 = 0x32315659,      // Planar mode: Y + V + U  (3 planes) */
    // SDL_DEFINE_PIXELFOURCC('Y', 'V', '1', '2'), 
    IYUV = 0x56555949,      // Planar mode: Y + U + V  (3 planes) */
    // SDL_DEFINE_PIXELFOURCC('I', 'Y', 'U', 'V'), 
    YUY2 = 0x32595559,      // Packed mode: Y0+U0+Y1+V0 (1 plane) */
    // SDL_DEFINE_PIXELFOURCC('Y', 'U', 'Y', '2'), 
    UYVY = 0x59565955,      // Packed mode: U0+Y0+V0+Y1 (1 plane) */
    // SDL_DEFINE_PIXELFOURCC('U', 'Y', 'V', 'Y'), 
    YVYU = 0x55595659,      // Packed mode: Y0+V0+Y1+U0 (1 plane) */
    // SDL_DEFINE_PIXELFOURCC('Y', 'V', 'Y', 'U'), 
    NV12 = 0x3231564e,      // Planar mode: Y + U/V interleaved  (2 planes) */
    // SDL_DEFINE_PIXELFOURCC('N', 'V', '1', '2'), 
    NV21 = 0x3132564e,      // Planar mode: Y + V/U interleaved  (2 planes) */
    // SDL_DEFINE_PIXELFOURCC('N', 'V', '2', '1'), 
    P010 = 0x30313050,      // Planar mode: Y + U/V interleaved  (2 planes) */
    // SDL_DEFINE_PIXELFOURCC('P', '0', '1', '0'), 
    EXTERNAL_OES = 0x2053454f,     // Android video texture format */
    // SDL_DEFINE_PIXELFOURCC('O', 'E', 'S', ' ') 

    MJPG = 0x47504a4d,      // Motion JPEG */
    // SDL_DEFINE_PIXELFOURCC('M', 'J', 'P', 'G') 

    RGBA32 = PixelFormat.ABGR8888,
    ARGB32 = PixelFormat.BGRA8888,
    BGRA32 = PixelFormat.ARGB8888,
    ABGR32 = PixelFormat.RGBA8888,
    RGBX32 = PixelFormat.XBGR8888,
    XRGB32 = PixelFormat.BGRX8888,
    BGRX32 = PixelFormat.XRGB8888,
    XBGR32 = PixelFormat.RGBX8888
}

state Window
{
	id: uint32,
	title: *byte
}

state Surface
{
	flags: uint32,
    format: PixelFormat,
    w: int32,
    h: int32,
    pitch: int32,
    pixels: *void,
    refCount: int32,
    reserved: *void
}

bool Init(flags: uint32) => SDL_Init(flags);
Quit() => SDL_Quit();
*byte GetError() => SDL_GetError();

void Check(error: bool, onError: ::(*byte))
{
    if (error)
    {
        errMsg := GetError();
        onError(errMsg);
    }
}

*Window CreateWindow(title: *byte, w: int32, h: int32, flags: uint) => SDL_CreateWindow(title, w, h, flags);
void DestroyWindow(window: *Window) => SDL_DestroyWindow(window);
bool GetWindowSizeInPixels(window: *Window, width: *int32, height: *int32) => SDL_GetWindowSizeInPixels(window, width, height);

*Surface ConvertSurface(surface: *Surface, format: PixelFormat) => SDL_ConvertSurface(surface, format);
DestroySurface(surface: *Surface) => SDL_DestroySurface(surface);