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
import Math

float32 SRGBToLinear(channel: float32)
{
	if (channel <= 0.04045) return channel / 12.92;
	return Math.Powf((channel + 0.055) / 1.055, 2.4);
}

ImVec4_t ImGuiColor(r: uint32, g: uint32, b: uint32, a: uint32 = 255)
{
	color := ImVec4_t();
	color.x = SRGBToLinear((r as float32) / float32(255.0));
	color.y = SRGBToLinear((g as float32) / float32(255.0));
	color.z = SRGBToLinear((b as float32) / float32(255.0));
	color.w = (a as float32) / float32(255.0);
	return color;
}

SetImGuiStyleColor(style: *ImGuiStyle_t, col: ImGuiCol_, color: ImVec4_t)
{
	style.Colors[col as uint32] = color;
}

SetupImGuiDefaultStyle(style: *ImGuiStyle_t)
{
	style.FontSizeBase = float32(15.0);

	style.WindowPadding = { float32(18.0), float32(16.0) };
	style.FramePadding = { float32(12.0), float32(8.0) };
	style.ItemSpacing = { float32(12.0), float32(10.0) };
	style.ItemInnerSpacing = { float32(10.0), float32(8.0) };
	style.CellPadding = { float32(10.0), float32(7.0) };
	style.SeparatorTextPadding = { float32(20.0), float32(8.0) };
	style.IndentSpacing = float32(22.0);
	style.ScrollbarSize = float32(10.0);
	style.GrabMinSize = float32(12.0);

	style.WindowRounding = float32(0.0);
	style.ChildRounding = float32(0.0);
	style.PopupRounding = float32(0.0);
	style.FrameRounding = float32(0.0);
	style.ScrollbarRounding = float32(0.0);
	style.GrabRounding = float32(0.0);
	style.TabRounding = float32(0.0);

	style.WindowBorderSize = float32(1.0);
	style.ChildBorderSize = float32(1.0);
	style.PopupBorderSize = float32(1.0);
	style.FrameBorderSize = float32(1.0);
	style.TabBorderSize = float32(1.0);
	style.TabBarBorderSize = float32(2.0);
	style.TabBarOverlineSize = float32(3.0);
	style.SeparatorTextBorderSize = float32(3.0);
	style.DockingSeparatorSize = float32(2.0);
	style.TreeLinesFlags = ImGuiTreeNodeFlags_.ImGuiTreeNodeFlags_DrawLinesToNodes as int32;
	style.TreeLinesSize = float32(1.0);

	parchment := ImGuiColor(226, 214, 182);
	tarnish := ImGuiColor(124, 112, 86);
	pitch := ImGuiColor(7, 7, 5);
	panel := ImGuiColor(17, 17, 13, 230);
	panelRaised := ImGuiColor(28, 28, 20);
	oliveDark := ImGuiColor(46, 38, 18);
	olive := ImGuiColor(62, 50, 22);
	goldDim := ImGuiColor(132, 104, 38);
	gold := ImGuiColor(198, 158, 58);
	amber := ImGuiColor(232, 178, 54);
	amberBright := ImGuiColor(255, 206, 92);
	copper := ImGuiColor(196, 104, 28);

	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_Text, parchment);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TextDisabled, tarnish);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_WindowBg, panel);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_ChildBg, ImGuiColor(0, 0, 0, 0));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_PopupBg, ImGuiColor(11, 11, 8, 250));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_Border, goldDim);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_BorderShadow, ImGuiColor(0, 0, 0, 0));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_FrameBg, pitch);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_FrameBgHovered, oliveDark);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_FrameBgActive, olive);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TitleBg, ImGuiColor(9, 9, 7));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TitleBgActive, oliveDark);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TitleBgCollapsed, ImGuiColor(9, 9, 7));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_MenuBarBg, ImGuiColor(9, 9, 7));

	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_ScrollbarBg, ImGuiColor(0, 0, 0, 0));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_ScrollbarGrab, goldDim);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_ScrollbarGrabHovered, gold);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_ScrollbarGrabActive, amber);

	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_CheckMark, amber);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_SliderGrab, gold);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_SliderGrabActive, amberBright);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_Button, panelRaised);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_ButtonHovered, olive);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_ButtonActive, gold);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_Header, ImGuiColor(232, 178, 54, 60));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_HeaderHovered, ImGuiColor(232, 178, 54, 110));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_HeaderActive, ImGuiColor(232, 178, 54, 170));

	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_Separator, goldDim);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_SeparatorHovered, gold);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_SeparatorActive, amber);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_ResizeGrip, ImGuiColor(198, 158, 58, 70));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_ResizeGripHovered, ImGuiColor(232, 178, 54, 170));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_ResizeGripActive, amberBright);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_InputTextCursor, amber);

	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_Tab, ImGuiColor(15, 15, 11));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TabHovered, olive);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TabSelected, oliveDark);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TabSelectedOverline, amber);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TabDimmed, ImGuiColor(11, 11, 8));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TabDimmedSelected, panelRaised);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TabDimmedSelectedOverline, goldDim);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_DockingPreview, ImGuiColor(232, 178, 54, 110));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_DockingEmptyBg, ImGuiColor(9, 9, 7));

	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_PlotLines, ImGuiColor(180, 168, 136));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_PlotLinesHovered, copper);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_PlotHistogram, gold);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_PlotHistogramHovered, amberBright);

	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TableHeaderBg, oliveDark);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TableBorderStrong, goldDim);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TableBorderLight, ImGuiColor(58, 48, 26));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TableRowBg, ImGuiColor(0, 0, 0, 0));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TableRowBgAlt, ImGuiColor(255, 220, 150, 8));

	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TextLink, amberBright);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TextSelectedBg, ImGuiColor(198, 158, 58, 110));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_TreeLines, goldDim);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_DragDropTarget, copper);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_DragDropTargetBg, ImGuiColor(196, 104, 28, 45));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_UnsavedMarker, copper);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_NavCursor, amber);
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_NavWindowingHighlight, ImGuiColor(226, 214, 182, 180));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_NavWindowingDimBg, ImGuiColor(4, 3, 2, 150));
	SetImGuiStyleColor(style, ImGuiCol_.ImGuiCol_ModalWindowDimBg, ImGuiColor(4, 3, 2, 170));
}

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
	SetupImGuiDefaultStyle(ImGui_GetStyle());
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