package ImGui

import VulkanRenderer
import SDL
import ECS
import Event
import WindowComponent
import ThreadParamAllocator
import Fiber
import SystemInfo
import Array

InitializeImGui()
{
	ImGui_CreateContext(null);
}

state ImGuiWindow
{
	window: *SDL.Window,
	windowHandle: *void,
	renderFuncs: Array<::(*ImGuiWindow, *any)>,
	data: *any,

	renderer: VulkanRenderer,

	entity: Entity,
	width: uint32,
	height: uint32,
	initialized: bool = false
}

ImGuiWindow::(renderFuncs: []::(*ImGuiWindow, *any), data: *any, width: uint32, height: uint32)
{
	this.renderFuncs = Array<::(*ImGuiWindow, *any)>(renderFuncs);
	this.data = data;
	this.width = width;
	this.height = height;
}

ImGuiWindow::delete
{
	events := GetEventEmitterForWindow(this.window);
	events.Remove(SDL.EventType.MOUSE_MOTION, UpdateMousePos);
	events.Remove(SDL.EventType.MOUSE_WHEEL, UpdateMouseWheel);
	events.Remove(SDL.EventType.MOUSE_BUTTON_DOWN, UpdateMouseButton);
	events.Remove(SDL.EventType.MOUSE_BUTTON_UP, UpdateMouseButton);

	DestroyWindow(this.window);
	delete this.data;
}

ImGuiWindow::InitVulkan(scene: Scene, entity: Entity)
{
	log "Init ImGui Vulkan Window";
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

		imGuiWindow.window = window;

		propsID := SDL.GetWindowProperties(window);
		imGuiWindow.windowHandle = SDL.GetPointerProperty(propsID, SDL.Win32WindowHandle, null);
		initialized := cImGui_ImplWin32_Init(imGuiWindow.windowHandle);
		if (!initialized)
		{
			log "Failed to initialize ImGui Window";
			return;
		}

		events := GetEventEmitterForWindow(window);
		events.On(SDL.EventType.MOUSE_MOTION, UpdateMousePos);
		events.On(SDL.EventType.MOUSE_WHEEL, UpdateMouseWheel);
		events.On(SDL.EventType.MOUSE_BUTTON_DOWN, UpdateMouseButton);
		events.On(SDL.EventType.MOUSE_BUTTON_UP, UpdateMouseButton);
		
		renderConfig := VulkanRendererConfig();
		renderConfig.userData.entity = entity;
		renderConfig.maxMaterialSets = 8;
		renderConfig.materialDescriptorCount = 8;
		renderConfig.useSceneUBO = false;
		renderConfig.meshCallbacks.drawListUpdate = ::(scene: *Scene, renderer: *VulkanRenderer) {};
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
	for (renderFunc in this.renderFuncs) renderFunc(this@, this.data);
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