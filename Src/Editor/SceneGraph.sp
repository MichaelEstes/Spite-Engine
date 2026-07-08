package Editor

import ECS
import ImGui

entityLabelStr := "Entity ";

ImGuiRenderFunc CreateSceneGraphEditor(imGuiWindowEntity: Entity, scene: *Scene)
{
    imGuiWindow := scene.GetComponent<ImGuiWindow>(imGuiWindowEntity);

    sceneGraphRender := ImGuiRenderFunc(::(window: *ImGuiWindow, scene: *Scene)
	{
        windowOpen := true;
        if (!ImGui_Begin("Scene Graph"[0], windowOpen@, 0))
        {
            ImGui_End();
            return;
        }

        IntValueEditor("Test", 0@);

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
                for (common in entityComponents.common)
                {
                    type := GetTypeForComponent(common);
                    data := scene.GetComponentUntyped(entity, common);
                    TypeValueEditor(type.StateName(), { type, data } as TypeValue);
                }

                for (sparse in entityComponents.sparse)
                {
                    type := GetTypeForComponent(sparse);
                    data := scene.GetComponentUntyped(entity, sparse);
                    TypeValueEditor(type.StateName(), { type, data } as TypeValue);
                }

                ImGui_TreePop();
            }
        }

        ImGui_End();
	}, scene);

    imGuiWindow.AddRenderFunc(sceneGraphRender);

    return sceneGraphRender;
}