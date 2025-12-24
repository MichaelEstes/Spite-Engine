package ImGui

import VulkanRenderer
import SDL
import ECS
import Event
import Window

InitializeImGui()
{
	ImGui_CreateContext(null);
}

enum ImGuiBackendKind: uint32 
{
	Vulkan,
	None
}

state ImGuiWindow
{
	window: *SDL.Window,
	windowHandle: *void,
	renderFunc: ::(*ImGuiWindow, *any),
	data: *any,

	backend: ?{
		vulkan: {
			renderer: VulkanRenderer,
			pipelineCache: *VkPipelineCache_T,
			initialized: bool
		},
		none: *void
	}

	backendKind: ImGuiBackendKind,
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

ImGuiWindow::InitVulkan(entity: Entity)
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

	renderConfig := VulkanRendererConfig();
	renderConfig.deviceIndex = vulkanInstance.defaultDevice;
	renderConfig.userData.entity = entity;
	renderConfig.maxTextureSets = 8;
	renderConfig.textureDescriptorCount = 8;
	renderConfig.useUBOs = false;
	renderConfig.useEmptyStructures = false;
	this.backend.vulkan.renderer = CreateVulkanRenderer(this.window, Array<string>(["ImGuiPass",]), renderConfig);

	renderer := this.backend.vulkan.renderer;
	device :=  renderer.device;
	
	this.backend.vulkan.pipelineCache = null;
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
	},
	::(entity: Entity, imGuiWindow: *ImGuiWindow, scene: Scene) 
	{
		imGuiWindow.InitVulkan(entity);
	}
);

imGuiDrawSystem := ECS.RegisterSystem(
	::(scene: Scene, dt: float) 
	{
		for (entityComponent in scene.Iterate<ImGuiWindow>())
		{
			imGuiWindow := entityComponent.component;
			imGuiWindow.backend.vulkan.renderer.Draw(scene@);
		}
	},
	SystemStep.Draw
);