package ImGui

import Vulkan

extern
{
	#link windows "./extern/ImGui";

	bool cImGui_ImplVulkan_Init(info: *ImGui_ImplVulkan_InitInfo_t);
	void cImGui_ImplVulkan_Shutdown();
	void cImGui_ImplVulkan_NewFrame();
	void cImGui_ImplVulkan_RenderDrawData(draw_data: *ImDrawData_t, command_buffer: *VkCommandBuffer_T);
	void cImGui_ImplVulkan_RenderDrawDataEx(draw_data: *ImDrawData_t, command_buffer: *VkCommandBuffer_T, pipeline: VkPipeline);
	void cImGui_ImplVulkan_SetMinImageCount(min_image_count: uint32);
	void cImGui_ImplVulkan_CreateMainPipeline(info: *ImGui_ImplVulkan_PipelineInfo_t);
	void cImGui_ImplVulkan_UpdateTexture(tex: *ImTextureData);
	VkDescriptorSet cImGui_ImplVulkan_AddTexture(sampler: VkSampler, image_view: VkImageView, image_layout: VkImageLayout);
	void cImGui_ImplVulkan_RemoveTexture(descriptor_set: VkDescriptorSet);
	bool cImGui_ImplVulkan_LoadFunctions(api_version: uint32, loader_func: ::());
	bool cImGui_ImplVulkan_LoadFunctionsEx(api_version: uint32, loader_func: ::(), user_data: *void);
	void cImGui_ImplVulkanH_CreateOrResizeWindow(instance: *VkInstance_T, physical_device: *VkPhysicalDevice_T, device: VkDevice, wd: *ImGui_ImplVulkanH_Window_t, queue_family: uint32, allocator: *VkAllocationCallbacks, w: int32, h: int32, min_image_count: uint32, image_usage: VkImageUsageFlags);
	void cImGui_ImplVulkanH_DestroyWindow(instance: *VkInstance_T, device: *VkDevice_T, wd: *ImGui_ImplVulkanH_Window_t, allocator: *VkAllocationCallbacks);
	VkSurfaceFormatKHR cImGui_ImplVulkanH_SelectSurfaceFormat(physical_device: *VkPhysicalDevice_T, surface: VkSurfaceKHR, request_formats: *VkFormat, request_formats_count: int32, request_color_space: VkColorSpaceKHR);
	VkPresentModeKHR cImGui_ImplVulkanH_SelectPresentMode(physical_device: *VkPhysicalDevice_T, surface: VkSurfaceKHR, request_modes: *VkPresentModeKHR, request_modes_count: int32);
	*VkPhysicalDevice_T cImGui_ImplVulkanH_SelectPhysicalDevice(instance: *VkInstance_T);
	uint32 cImGui_ImplVulkanH_SelectQueueFamilyIndex(physical_device: *VkPhysicalDevice_T);
	int32 cImGui_ImplVulkanH_GetMinImageCountFromPresentMode(present_mode: VkPresentModeKHR);
	*ImGui_ImplVulkanH_Window_t cImGui_ImplVulkanH_GetWindowDataFromViewport(viewport: *ImGuiViewport);
}

state ImGui_ImplVulkan_PipelineInfo_t
{
	RenderPass: *VkRenderPass_T,
	Subpass: uint32,
	MSAASamples: VkSampleCountFlagBits,
	PipelineRenderingCreateInfo: VkPipelineRenderingCreateInfo,
	SwapChainImageUsage: VkImageUsageFlagBits
}

state ImGui_ImplVulkan_InitInfo_t
{
	ApiVersion: uint32,
	Instance: *VkInstance_T,
	PhysicalDevice: *VkPhysicalDevice_T,
	Device: *VkDevice_T,
	QueueFamily: uint32,
	Queue: VkQueue,
	DescriptorPool: *VkDescriptorPool_T,
	DescriptorPoolSize: uint32,
	MinImageCount: uint32,
	ImageCount: uint32,
	PipelineCache: *VkPipelineCache_T,
	PipelineInfoMain: ImGui_ImplVulkan_PipelineInfo_t,
	PipelineInfoForViewports: ImGui_ImplVulkan_PipelineInfo_t,
	UseDynamicRendering: bool,
	Allocator: *VkAllocationCallbacks,
	CheckVkResultFn: ::(),
	MinAllocationSize: uint64,
	CustomShaderVertCreateInfo: VkShaderModuleCreateInfo,
	CustomShaderFragCreateInfo: VkShaderModuleCreateInfo
}

state ImGui_ImplVulkan_RenderState_t
{
	CommandBuffer: *VkCommandBuffer_T,
	Pipeline: *VkPipeline_T,
	PipelineLayout: *VkPipelineLayout_T
}

state ImGui_ImplVulkanH_Frame_t
{
	CommandPool: *VkCommandPool_T,
	CommandBuffer: *VkCommandBuffer_T,
	Fence: *VkFence_T,
	Backbuffer: *VkImage_T,
	BackbufferView: *VkImageView_T,
	Framebuffer: *VkFramebuffer_T
}

state ImVector_ImGui_ImplVulkanH_Frame_t
{
	Size: int32,
	Capacity: int32,
	Data: *ImGui_ImplVulkanH_Frame_t
}

state ImGui_ImplVulkanH_FrameSemaphores_t
{
	ImageAcquiredSemaphore: *VkSemaphore_T,
	RenderCompleteSemaphore: *VkSemaphore_T
}

state ImVector_ImGui_ImplVulkanH_FrameSemaphores_t
{
	Size: int32,
	Capacity: int32,
	Data: *ImGui_ImplVulkanH_FrameSemaphores_t
}

state ImGui_ImplVulkanH_Window_t
{
	Width: int32,
	Height: int32,
	Swapchain: *VkSwapchainKHR_T,
	Surface: *VkSurfaceKHR_T,
	SurfaceFormat: VkSurfaceFormatKHR,
	PresentMode: VkPresentModeKHR,
	RenderPass: *VkRenderPass_T,
	UseDynamicRendering: bool,
	ClearEnable: bool,
	ClearValue: VkClearValue,
	FrameIndex: uint32,
	ImageCount: uint32,
	SemaphoreCount: uint32,
	SemaphoreIndex: uint32,
	Frames: ImVector_ImGui_ImplVulkanH_Frame_t,
	FrameSemaphores: ImVector_ImGui_ImplVulkanH_FrameSemaphores_t
}

