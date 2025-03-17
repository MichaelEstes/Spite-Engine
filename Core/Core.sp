package Core

import ECS
import Time
import Window
import SDL
import Event
import Vulkan

running := false;

SDLEventEmitter := Event.Emitter();

appInfo := {
	VkStructureType.VK_STRUCTURE_TYPE_APPLICATION_INFO,
	null,
	"Spite Engine"[0],
	uint32(0),
	"Spite Engine"[0],
	uint32(0),
	uint32(0),
} as VkApplicationInfo;

InitializeVulkan(window: *SDL.Window)
{
	extensionCount := uint32(0);
    extensionNames := SDL.VulkanGetInstanceExtensions(extensionCount@);
    instanceCreateInfo := {
        VkStructureType.VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO, 
        null,													
        uint32(0),												
        appInfo@,													
        uint32(0),												
        null,												
        extensionCount,											
        extensionNames,											
    } as VkInstanceCreateInfo;

    vkInstance: *VkInstance_T = null;
    createResult := vkCreateInstance(instanceCreateInfo@, null, vkInstance@);
	assert createResult == VkResult.VK_SUCCESS, "Error creating Vulkan instance";

	physicalDeviceCount := uint32(0);
	physicalDevices := Allocator<*VkPhysicalDevice_T>();
    vkEnumeratePhysicalDevices(vkInstance, physicalDeviceCount@, null);
	physicalDevices.Alloc(physicalDeviceCount);
    deviceResult := vkEnumeratePhysicalDevices(vkInstance, physicalDeviceCount@, physicalDevices[0]);
    assert createResult == VkResult.VK_SUCCESS, "Error finding device for Vulkan";

	physicalDevice := physicalDevices[0]~;
	log "Device count: ", physicalDeviceCount;
	log physicalDevice;

	queueFamilyCount := uint32(0);
	queueFamilies := Allocator<VkQueueFamilyProperties>();
    vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, queueFamilyCount@, null);
	queueFamilies.Alloc(queueFamilyCount);
    vkGetPhysicalDeviceQueueFamilyProperties(physicalDevice, queueFamilyCount@, queueFamilies[0]);

	log "Queue family count: ", queueFamilyCount;

	vkSurface: *VkSurfaceKHR_T = null;
	surfaceResult := SDL.VulkanCreateSurface(window, vkInstance, null, vkSurface@);
	assert surfaceResult, "Error creating Vulkan surface";

	log "VkSurface: ", vkSurface;
}

Initialize()
{
	InitializeTime();
	//Fiber.InitalizeFibers();

	SDL.Init(SDL.InitFlags.VIDEO);
	SDL.VulkanLoadLibrary(null);
	mainWindow := InitializeMainWindow();

	InitializeVulkan(mainWindow);

	SDLEventEmitter.On(SDL.EventType.QUIT, ::(event: SDL.Event) {
		running = false;
	});

	SDLEventEmitter.On(SDL.EventType.WINDOW_CLOSE_REQUESTED, ::(event: SDL.Event) {
		windowID := event.data.window.windowID;
		Window.DestroyWindow(Window.GetWindowForID(windowID))
	});
}

Start()
{
	ECS.instance.Start();
	MainLoop();
}

MainLoop()
{
	running = true;

	currEvent := SDL.Event();
	while (running)
	{
		while (SDL.PollEvent(currEvent@)) HandleSDLEvent(currEvent);
		
		ECS.instance.Update();
	}

	ECS.instance.Stop();
}

HandleSDLEvent(event: SDL.Event)
{
	SDLEventEmitter.Emit<SDL.Event>(event.type, event);
	//log event;
}

Stop()
{
	running = false;
}