package ImGui

import VulkanRenderer
import SDL
import ECS
import Event
import Window

ImGuiWindowAddedEvent := RegisterEvent<SceneEntity>();

InitializeImGui()
{
	ImGui_CreateContext(null);
}

state ImGuiWindow
{
	window: *SDL.Window,
	windowHandle: *void,
	renderFunc: ::(*ImGuiWindow, *any),
	data: *any,

	width: uint32,
	height: uint32
}

ImGuiWindow::(renderFunc: ::(*ImGuiWindow, *any), data: *any, width: uint32, height: uint32)
{
	this.renderFunc = renderFunc;
	this.data = data;
	this.width = width;
	this.height = height;
}

ImGuiWindow::delete
{
	DestroyWindow(this.window);
	delete this.data;
}

ImGuiWindow::InitVulkan(renderer: *VulkanRenderer)
{
	this.window = CreateWindow(
		null, this.width, this.height, 
		SDL.WindowFlags.Vulkan | SDL.WindowFlags.Resizable
	);
	propsID := SDL.GetWindowProperties(this.window);
	this.windowHandle = SDL.GetPointerProperty(propsID, SDL.Win32WindowHandle, null);
	initialized := cImGui_ImplWin32_Init(this.windowHandle);
	if (!initialized)
	{
		log "Failed to initialize ImGui Window";
		return;
	}

	initInfo := ImGui_ImplVulkan_InitInfo_t();
	initInfo.Instance = renderer.vkInstance.instance;
    initInfo.PhysicalDevice = renderer.physicalDevice;
    initInfo.Device = renderer.device;
    initInfo.QueueFamily = renderer.queues.graphicsQueueIndex;
    initInfo.Queue = renderer.queues.graphicsQueue;
    initInfo.PipelineCache = g_PipelineCache;
    initInfo.DescriptorPool = g_DescriptorPool;
    initInfo.MinImageCount = g_MinImageCount;
    initInfo.ImageCount = wd->ImageCount;
    initInfo.Allocator = g_Allocator;
    initInfo.PipelineInfoMain.RenderPass = wd->RenderPass;
    initInfo.PipelineInfoMain.Subpass = 0;
    initInfo.PipelineInfoMain.MSAASamples = VK_SAMPLE_COUNT_1_BIT;
    initInfo.CheckVkResultFn = check_vk_result;

}

ImGuiWindow::Render()
{
	this.renderFunc(this@, this.data);
}

ImGuiComponent := ECS.RegisterComponent<ImGuiWindow>(
	ComponentKind.Sparse, 
	::(entity: Entity, imGuiWindow: *ImGuiWindow, scene: Scene) 
	{
		delete imGuiWindow~;
	}
	::(entity: Entity, imGuiWindow: *ImGuiWindow, scene: Scene) 
	{
		ECS.instance.events.Emit<SceneEntity>(ImGuiWindowAddedEvent, SceneEntity(scene@, entity));
	}
);