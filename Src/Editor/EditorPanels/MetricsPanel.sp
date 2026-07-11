package EditorPanels

import EditorWindow
import ECS
import ImGui

ImGuiRenderFunc CreateMetricsPanel(panel: EditorPanel, entity: Entity, scene: *Scene)
{
    return ImGuiRenderFunc(::(window: *ImGuiWindow, data: *any)
	{
		ImGui_ShowMetricsWindow(true@);
	});
}

MetricsPanel := RegisterEditorPanel(EditorPanel("Metrics", CreateMetricsPanel), true);