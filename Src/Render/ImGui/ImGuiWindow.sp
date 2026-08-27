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

state ImGuiRenderFunc
{
	func: ::(*ImGuiWindow, *any),
	data: *any = null,
	onRemove: ::(*any) = null
}

ImGuiRenderFunc::(renderFunc: ::(*ImGuiWindow, *any), data: *any = null, onRemove: ::(*any) = null)
{
	this.func = renderFunc;
	this.data = data;
	this.onRemove = onRemove;
}

state ImGuiWindow
{
	ctx: *ImGuiContext_t,
	window: *SDL.Window,
	windowHandle: *void,
	renderFuncs: Array<ImGuiRenderFunc>,

	renderer: VulkanRenderer,

	entity: Entity,
	width: uint32,
	height: uint32,
	initialized: bool = false
}

ImGuiWindow::(renderFuncs: []ImGuiRenderFunc, width: uint32, height: uint32)
{
	this.ctx = ImGui_CreateContext(null);
	this.renderFuncs = Array<ImGuiRenderFunc>(renderFuncs);
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
	events.Remove(SDL.EventType.KEY_DOWN, UpdateKey);
	events.Remove(SDL.EventType.KEY_UP, UpdateKey);
	events.Remove(SDL.EventType.TEXT_INPUT, UpdateTextInput);

	SDL.StopTextInput(this.window);
	DestroyWindow(this.window);

	for (renderFunc in this.renderFuncs)
	{
		delete renderFunc.data;
	}
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
		events.On(SDL.EventType.KEY_DOWN, UpdateKey);
		events.On(SDL.EventType.KEY_UP, UpdateKey);
		events.On(SDL.EventType.TEXT_INPUT, UpdateTextInput);

		SDL.StartTextInput(window);

		renderConfig := VulkanRendererConfig();
		renderConfig.userData.entity = entity;
		renderConfig.maxMaterialSets = 8;
		renderConfig.materialDescriptorCount = 8;
		renderConfig.useSceneUBO = false;
		renderConfig.meshCallbacks.onMeshAdded = ::(sceneEntity: SceneEntity, mesh: *Mesh, renderer: *VulkanRenderer) {};
		renderConfig.meshCallbacks.onMeshRemoved = ::(sceneEntity: SceneEntity, mesh: *Mesh, renderer: *VulkanRenderer) {};
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
	ImGui_SetCurrentContext(this.ctx);
	for (renderFunc in this.renderFuncs)
	{
		renderFunc.func(this@, renderFunc.data);
	}
}

uint32 ImGuiWindow::AddRenderFunc(renderFunc: ImGuiRenderFunc)
{
	return this.renderFuncs.Add(renderFunc);
}

bool ImGuiWindow::RemoveRenderFunc(renderFunc: ImGuiRenderFunc)
{
	for (curr in this.renderFuncs)
	{
		if (curr.func == renderFunc.func && curr.data == renderFunc.data)
		{
			if (curr.onRemove) curr.onRemove(curr.data);
			break;
		}
	}

	return this.renderFuncs.Remove(renderFunc);
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