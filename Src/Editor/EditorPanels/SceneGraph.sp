package EditorPanels

import EditorWindow
import Editor
import ECS
import ImGui

entityLabelStr := "Entity ";

ImGuiRenderFunc CreateSceneGraphEditor(panel: EditorPanel, entity: Entity, scene: *Scene)
{
    return ImGuiRenderFunc(::(window: *ImGuiWindow, scene: *Scene)
	{
        windowOpen := true;
        if (!ImGui_Begin("Scene Graph"[0], windowOpen@, 0))
        {
            ImGui_End();
            return;
        }

        sceneIter := IterateSceneEntities(scene);
        defer delete sceneIter;

        for (entityComponents in sceneIter)
        {
            entity := entityComponents.entity;

            entityIDStr := UIntToString(entity.id);
            entityLabel := entityLabelStr.Copy();
            entityLabel.AppendIn(entityIDStr);
            defer {
                delete entityIDStr;
                delete entityLabel;
            }

            if (ImGui_TreeNode(entityLabel[0]))
            {
                for (commonComponent in entityComponents.common)
                {
                    type := GetTypeForComponent(commonComponent);
                    data := scene.GetComponentUntyped(entity, commonComponent);
                    if (TypeValueEditor(type.StateName(), { type, data } as TypeValue))
                    {
                        scene.SetComponentUntyped(entity, data, commonComponent);
                    }
                }

                for (sparseComponent in entityComponents.sparse)
                {
                    type := GetTypeForComponent(sparseComponent);
                    data := scene.GetComponentUntyped(entity, sparseComponent);
                    if (TypeValueEditor(type.StateName(), { type, data } as TypeValue))
                    {
                        scene.SetComponentUntyped(entity, data, sparseComponent);
                    }
                }

                ImGui_TreePop();
            }
        }

        ImGui_End();
	}, scene);
}

SceneGraphPanel := RegisterEditorPanel(EditorPanel("Scene Graph", CreateSceneGraphEditor));