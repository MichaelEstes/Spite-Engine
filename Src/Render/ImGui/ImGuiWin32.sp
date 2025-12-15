package ImGui

extern
{
	bool cImGui_ImplWin32_Init(hwnd: *void);
	bool cImGui_ImplWin32_InitForOpenGL(hwnd: *void);
	void cImGui_ImplWin32_Shutdown();
	void cImGui_ImplWin32_NewFrame();
	void cImGui_ImplWin32_EnableDpiAwareness();
	float32 cImGui_ImplWin32_GetDpiScaleForHwnd(hwnd: *void);
	float32 cImGui_ImplWin32_GetDpiScaleForMonitor(monitor: *void);
	void cImGui_ImplWin32_EnableAlphaCompositing(hwnd: *void);
}
