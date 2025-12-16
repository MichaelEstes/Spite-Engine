package ImGui

import SDL
import Vulkan
import ECS
import Event

ImGuiWindowAddedEvent := RegisterEvent<SceneEntity>();

state ImGuiWindow
{
	window: *SDL.Window,
	windowHandle: *void,
	renderFunc: ::(*ImGuiWindow, *any),
	data: *any
}

ImGuiWindow::(renderFunc: ::(*ImGuiWindow, *any), data: *any)
{
	this.renderFunc = renderFunc;
	this.data = data;
}

ImGuiWindow::InitVulkan(renderer: *VulkanRenderer)
{

}

ImGuiComponent := ECS.RegisterComponent<ImGuiWindow>(
	ComponentKind.Sparse, 
	::(entity: Entity, imGuiWindow: *ImGuiWindow, scene: Scene) {}
	::(entity: Entity, imGuiWindow: *ImGuiWindow, scene: Scene) 
	{
		ECS.instance.events.Emit<SceneEntity>(ImGuiWindowAddedEvent, SceneEntity(scene@, entity));
	}
);