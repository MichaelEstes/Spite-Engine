package ImGui

import VulkanRenderer
import SDL
import ECS
import Event
import WindowComponent
import ThreadParamAllocator
import Fiber
import SystemInfo

prevWndProc := null as *void;

InitializeImGui()
{
	ImGui_CreateContext(null);
}

enum ImGuiBackendKind: uint32 
{
	Vulkan,
	None
}

int ImGuiWndProc(hwnd: *void, msg: uint32, wparam: uint, lparam: int)
{
	cImGui_ImplWin32_WndProcHandler(hwnd, msg, wparam, lparam);
	return CallWindowProcA(prevWndProc, hwnd, msg, wparam, lparam);
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
	entity: Entity,
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

ImGuiWindow::InitVulkan(scene: Scene, entity: Entity)
{
	this.entity = entity;

	param := AllocThreadParam<SceneEntity>();
	param.entity = entity;
	param.scene = scene@;

	handle: *JobHandle = null;

	Fiber.RunOnMainThread(::(sceneEntity: *SceneEntity)
	{
		log "Creating ImGui Vulkan Window";
		defer DeallocThreadParam<SceneEntity>(sceneEntity);

		scene := sceneEntity.scene;
		entity := sceneEntity.entity;
		imGuiWindow := scene.GetComponent<ImGuiWindow>(entity);
	    
		windowDesc := WindowDesc();
		windowDesc.title = "";
		windowDesc.flags = SDL.WindowFlags.Vulkan | SDL.WindowFlags.Resizable;
		windowDesc.width = imGuiWindow.width;
		windowDesc.height = imGuiWindow.height;
		windowData := CreateWindowComponent(windowDesc, scene, entity);
		window := windowData.window;

		propsID := SDL.GetWindowProperties(window);
		imGuiWindow.windowHandle = SDL.GetPointerProperty(propsID, SDL.Win32WindowHandle, null);
		initialized := cImGui_ImplWin32_Init(imGuiWindow.windowHandle);
		if (!initialized)
		{
			log "Failed to initialize ImGui Window";
			return;
		}

		if (!prevWndProc)
		{
			prevWndProc = SetWindowEventProc(imGuiWindow.windowHandle, ImGuiWndProc);
		}
		
		imGuiWindow.backend.vulkan.pipelineCache = null;

		renderConfig := VulkanRendererConfig();
		renderConfig.deviceIndex = vulkanInstance.defaultDevice;
		renderConfig.userData.entity = entity;
		renderConfig.maxTextureSets = 8;
		renderConfig.textureDescriptorCount = 8;
		renderConfig.useUBOs = false;
		renderConfig.useEmptyStructures = false;
		renderConfig.onMeshAdded = ::(sceneEntity: SceneEntity, mesh: *Mesh, renderer: *VulkanRenderer) {};
		CreateVulkanRenderer(
			scene, entity,
			Array<string>(["ImGuiPass",]),
			renderConfig
		);
	}, param, handle@);
	WaitForHandle(handle);
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
		imGuiWindow.InitVulkan(scene, entity);
	}
);