package Scene0

import ECS
import Math
import Array
import SceneRegistry
import SDL
import SceneDescription

import VulkanRenderPass

import GLTFManager
import RenderComponents
import SceneComponents
import Transform
import Common

import ImGui
import Utils

import Editor

_ := SceneRegistry.RegisterScene(
	0,
	::(scene: *Scene) {
		log "Loading Main Scene";
		
		sceneEntity := scene.CreateEntity();

		camera := Camera();
		camera.position = Vec3(0, 1.0, 4.0);
		camera.fov = Math.Deg2Rad(70.0);
		camera.near = 0.1;
		camera.far = 1000.0;
		camera.LookAt(Vec3(0.0, 0.0, 0.0));
		scene.SetComponent<Camera>(sceneEntity, camera);
		scene.SetComponent<CameraOrbit>(sceneEntity, CameraOrbit());

		scene.SetComponent<SceneDesc>(sceneEntity, {
			{
				"Main Window",
				SDL.WindowFlags.Vulkan | SDL.WindowFlags.Resizable,
				uint32(1000),
				uint32(1000)
			},
			{
				Array<string>(["ClearPass", "LightCullPass", "AssetPass"]),
				RendererFlags.Vulkan
			}
		});

		lightPositions := [
			Vec3(-2.0, 0.0, 0.0),   // left
			Vec3(2.0, 0.0, 0.0),    // right
			Vec3(0.0, 0.0, 2.0)     // front
		];
		lightColors := [
			Color(0.0, 0.0, 1.0, 1.0),
			Color(1.0, 0.0, 0.0, 1.0),
			Color(0.0, 1.0, 0.0, 1.0)
		];

		for (i .. 3)
		{
			lightEntity := scene.CreateEntity();
			scene.SetComponent<Transform>(lightEntity, Transform(lightPositions[i]));

			pointLight := PointLight();
			pointLight.color = lightColors[i];
			pointLight.intensity = 6.0;
			pointLight.radius = 2.0;
			scene.SetComponent<PointLight>(lightEntity, pointLight);
		}

		sunEntity := scene.CreateEntity();
		directionalLight := DirectionalLight();
		directionalLight.direction = Vec3(0.0, -1.0, 0.0);
		directionalLight.color = Color(1.0, 0.85, 0.45, 1.0);
		directionalLight.intensity = 3.0;
		directionalLight.castShadow = false;
		scene.SetComponent<DirectionalLight>(sunEntity, directionalLight);

		lineEntity := scene.CreateEntity();
		scene.SetComponent<LineMesh>(lineEntity, LineMesh(
			Vec3(-1.0, 0.0, 0.0),
			Vec3(1.0, 0.0, 0.0),
			Color(1.0, 0.0, 0.0, 1.0)
		));

		thickLineEntity := scene.CreateEntity();
		scene.SetComponent<LineMesh>(thickLineEntity, LineMesh(
			Vec3(-1.0, 0.5, 0.0),
			Vec3(1.0, 0.5, 0.0),
			Color(0.0, 1.0, 0.0, 1.0),
			8.0
		));

		// model := "./Resource/Models/Box/Box.gltf";
		// model := "./Resource/Models/BoxTextured/BoxTextured.gltf";
		// model := "./Resource/Models/BrainStem/BrainStem.gltf";
		model := "./Resource/Models/DamagedHelmet/DamagedHelmet.gltf";
		log "Loading GLTF: ", model;
		gltfHandle := UseGLTFResource(
			model, scene,
			::(scene: *Scene, rootEntity: Entity) 
			{
				log "Loaded gltf: ", rootEntity;

				// IterateHierarchy(
				// 	rootEntity, scene,
				// 	::(entity: Entity, scene: *Scene) 
				// 	{
				// 		rotate := RotateOverTime();
				// 		rotate.axis = Vec3(0.0, 1.0, 0.0) as Norm<Vec3>;
				// 		rotate.speed = 0.25;
				// 		scene.SetComponent<RotateOverTime>(entity, rotate);
				// 	}
				// );
			},
		);

		imGuiWindowEntity := scene.CreateEntity();
		scene.SetComponent<ImGuiWindow>(imGuiWindowEntity, ImGuiWindow(
			[
				ImGuiRenderFunc(::(window: *ImGuiWindow, data: *any) 
				{
					ImGui_ShowMetricsWindow(true@);
				}),
			],
			uint32(1000),
			uint32(1000)
		));

		CreateSceneGraphEditor(imGuiWindowEntity, scene);

		//AddProfilerToWindow(scene, imGuiWindowEntity);

		log "Loaded Main Scene";

	},
	"Main Scene"
)