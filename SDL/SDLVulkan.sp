package SDL

import Vulkan

extern
{
	#link windows "./SDL3";

	bool SDL_Vulkan_LoadLibrary(path: *byte);
	**byte SDL_Vulkan_GetInstanceExtensions(count: *uint32);
	bool SDL_Vulkan_CreateSurface(window: *Window,
                                  instance: *VkInstance_T,
                                  allocator: *VkAllocationCallbacks,
                                  surface: **VkSurfaceKHR_T);

}

bool VulkanLoadLibrary(path: *byte) => SDL_Vulkan_LoadLibrary(path);
**byte VulkanGetInstanceExtensions(count: *uint32) => SDL_Vulkan_GetInstanceExtensions(count);
bool VulkanCreateSurface(
    window: *Window, 
    instance: *VkInstance_T,
    allocator: *VkAllocationCallbacks,
    surface: **VkSurfaceKHR_T
) => SDL_Vulkan_CreateSurface(window, instance, allocator, surface); 
    