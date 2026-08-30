package EditorPanels

import EditorWindow
import Editor
import ECS
import ImGui

state EditorOptions
{
    options: Map<string, EditorTypedValue>
}

EditorOptions::delete
{
    for (kv in this.options)
    {
        delete kv.key;
        delete kv.value.val;
    }
}

editorOptionsComponent := ECS.RegisterComponent<EditorOptions>(
	ComponentKind.Singleton,
    ::(entity: Entity, options: *EditorOptions, scene: Scene) {
        delete options~;
	}
);

ref T GetEditorOption<T>(scene: *Scene, name: string, defaultValue: T)
{
    if (!scene.HasSingleton<EditorOptions>()) return defaultValue;

    editorOptions := scene.GetSingleton<EditorOptions>();

    if (!editorOptions.options.Has(name))
    {
        type := #typeof T;
        ptr := new T();
        ptr~ = defaultValue;
        editorOptions.options.Insert(name, EditorTypedValue:{ type, ptr });
    }

    return editorOptions.options.Find(name).val~;
}

ImGuiRenderFunc CreateEditorOptions(panel: EditorPanel, entity: Entity, scene: *Scene)
{
    if (!scene.HasSingleton<EditorOptions>())
    {
        scene.SetSingleton<EditorOptions>(EditorOptions());
    }

    return ImGuiRenderFunc(::(window: *ImGuiWindow, scene: *Scene)
	{
        windowOpen := true;
        editorOptions := scene.GetSingleton<EditorOptions>();
        if (!ImGui_Begin("Editor Options"[0], windowOpen@, 0))
        {
            ImGui_End();
            return;
        }

        for (kv in editorOptions.options)
        {
            TypeValueEditor(kv.key~, kv.value~);
        }

        ImGui_End();
	}, scene);
}

EditorOptionsPanel := RegisterEditorPanel(EditorPanel("Editor Options", CreateEditorOptions));