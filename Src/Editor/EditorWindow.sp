package EditorWindow

import ECS
import Array
import ImGui

state EditorPanel
{
    title: string,
    create: ::ImGuiRenderFunc(EditorPanel, Entity, *Scene),
    data: *any
}

EditorPanel::(title: string, create: ::ImGuiRenderFunc(EditorPanel, Entity, *Scene), data: *any = null)
{
    this.title = title;
    this.create = create;
    this.data = data;
}

registeredEditorPanels := Array<EditorPanel>();

uint32 RegisterEditorPanel(panel: EditorPanel)
{
    return registeredEditorPanels.Add(panel);
}

state EditorWindow
{
    panels: Array<EditorPanel>
    active: Array<bool>
    renderFuncs: Array<ImGuiRenderFunc>
    sceneEntity: *SceneEntity
}

EditorWindow::(scene: *Scene)
{
    this.sceneEntity = new SceneEntity();
    this.sceneEntity.scene = scene;
    for (panel in registeredEditorPanels)
    {
        this.panels.Add(panel);
        this.active.Add(false);
    }
    this.renderFuncs = Array<ImGuiRenderFunc>(this.panels.count);
}

EditorWindow::delete
{
    delete this.panels;
    delete this.active;
    delete this.renderFuncs;
    delete this.sceneEntity;
}

EditorWindowComponent := ECS.RegisterComponent<EditorWindow>(
	ComponentKind.Sparse, 
	::(entity: Entity, editorWindow: *EditorWindow, scene: Scene) 
	{
        scene.RemoveComponent<ImGuiWindow>(entity);
		delete editorWindow~;
	},
    ::(entity: Entity, editorWindow: *EditorWindow, scene: Scene)
	{
        editorWindow.sceneEntity.entity = entity;
        scene.SetComponent<ImGuiWindow>(entity, ImGuiWindow(
			[
				ImGuiRenderFunc(::(window: *ImGuiWindow, sceneEntity: *SceneEntity)
				{
                    scene := sceneEntity.scene;
                    entity := sceneEntity.entity;
					editorWindow := scene.GetComponent<EditorWindow>(entity);

					windowOpen := true;
					if (!ImGui_Begin("Editor"[0], windowOpen@, 0))
					{
						ImGui_End();
						return;
					}

					for (i .. editorWindow.panels.count)
					{
						panel := editorWindow.panels[i];
						if (ImGui_Checkbox(panel.title[0], editorWindow.active[i]@))
                        {
                            active := editorWindow.active[i];
                            if (active)
                            {
                                editorWindow.renderFuncs[i] = panel.create(panel, entity, scene);
                                window.AddRenderFunc(editorWindow.renderFuncs[i]);
                            }
                            else
                            {
                                window.RemoveRenderFunc(editorWindow.renderFuncs[i]);
                            }
                        }
					}

					ImGui_End();
				}, editorWindow.sceneEntity),
			],
			uint32(1000),
			uint32(1000)
		));
	}
);

Entity CreateEditorWindow(scene: *Scene)
{
    editorWindowEntity := scene.CreateEntity();
    editorWindow := EditorWindow(scene);
    scene.SetComponent<EditorWindow>(editorWindowEntity, editorWindow);
    return editorWindowEntity;
}