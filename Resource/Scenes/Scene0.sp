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
			Vec3(-2.0, 1.0, 0.0),
			Vec3(2.0, 1.0, 0.0),
			Vec3(0.0, 1.5, -2.0),
			Vec3(0.0, 2.0, 2.0),
			Vec3(0.0, -1.5, 0.5),
			Vec3(-1.5, -1.0, 1.5)
		];
		lightColors := [
			Color(1.0, 0.4, 0.2, 1.0),   // orange
			Color(0.2, 0.5, 1.0, 1.0),   // blue
			Color(0.3, 1.0, 0.4, 1.0),   // green
			Color(1.0, 0.9, 0.4, 1.0),   // yellow
			Color(1.0, 0.3, 0.8, 1.0),   // magenta
			Color(0.4, 1.0, 1.0, 1.0)    // cyan
		];

		for (i .. 6)
		{
			lightEntity := scene.CreateEntity();
			scene.SetComponent<Transform>(lightEntity, Transform(lightPositions[i]));

			pointLight := PointLight();
			pointLight.color = lightColors[i];
			pointLight.intensity = 5.0;
			pointLight.radius = 3.0;
			scene.SetComponent<PointLight>(lightEntity, pointLight);
		}

		// model := "./Resource/Models/Box/Box.gltf";
		// model := "./Resource/Models/BoxTextured/BoxTextured.gltf";
		// model := "./Resource/Models/BrainStem/BrainStem.gltf";
		model := "./Resource/Models/DamagedHelmet/DamagedHelmet.gltf";
		log "Loading GLTF: ", model;
		gltfHandle := LoadGLTFResource(
			model, scene,
			::(handle: ResourceHandle, param: *GLTFLoadParam) 
			{
				rootEntity := param.rootEntity;
				scene := param.scene;
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
			[::(window: *ImGuiWindow, data: *any) 
			{
				ImGui_ShowDemoWindow(true@);
				ImGui_ShowMetricsWindow(true@);
				ImGui_ShowDebugLogWindow(true@);
			},],
			null,
			uint32(1000),
			uint32(1000)
		));

		//AddProfilerToWindow(scene, imGuiWindowEntity);

		log "Loaded Main Scene";

	},
	"Main Scene"
)