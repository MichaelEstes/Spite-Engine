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

		lightPositions := [
			Vec3(0.0, 0.5, 0.0),
			Vec3(3.0, 0.5, 0.0),
			Vec3(6.0, 0.5, 0.0)
		];
		lightColors := [
			Color(1.0, 0.0, 0.0, 1.0),
			Color(0.0, 1.0, 0.0, 1.0),
			Color(0.0, 0.0, 1.0, 1.0)
		];

		for (i .. 3)
		{
			lightEntity := scene.CreateEntity();
			scene.SetComponent<Transform>(lightEntity, Transform(lightPositions[i]));

			pointLight := PointLight();
			pointLight.radius = 3.0;
			pointLight.data.color = lightColors[i];
			pointLight.data.intensity = 16.0;
			scene.SetComponent<PointLight>(lightEntity, pointLight);
		}

		sunEntity := scene.CreateEntity();
		directionalLight := DirectionalLight();
		directionalLight.data.temperature = 5500.0;
		directionalLight.direction = Vec3(0.4, -1.0, 0.4);
		scene.SetComponent<DirectionalLight>(sunEntity, directionalLight);

		scene.SetComponent<SceneDesc>(sceneEntity, {
			{
				"Main Window",
				SDL.WindowFlags.Vulkan | SDL.WindowFlags.Resizable,
				uint32(1000),
				uint32(1000)
			},
			{
				Array<string>(
					[
						"ShadowPass", 
						"LightCullPass", 
						"DepthPass",
						"AssetPass",
						// "PostProcessPass",
						"PresentPass"
					]
				),
				RendererFlags.Vulkan
			}
		});

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

		boxEntity := scene.CreateEntity();
		scene.SetComponent<BoxMesh>(lineEntity, BoxMesh(
			1.0,
			1.0,
			1.0,
			Color(1.0, 0.0, 0.0, 1.0)
		));

		// model := "./Resource/Models/Box/Box.gltf";
		// model := "./Resource/Models/BoxTextured/BoxTextured.gltf";
		// model := "./Resource/Models/BrainStem/BrainStem.gltf";
		// model := "./Resource/Models/DamagedHelmet/DamagedHelmet.gltf";
		model := "./Resource/Models/Sponza/Sponza.gltf";
		log "Loading GLTF: ", model;
		gltfHandle := UseGLTFResource(
			model, scene,
			::(scene: *Scene, rootEntity: Entity, arg: *void)
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

				// rotate := RotateOverTime();
				// rotate.axis = Vec3(0.0, 1.0, 0.0) as Norm<Vec3>;
				// rotate.speed = 0.25;
				// scene.SetComponent<RotateOverTime>(rootEntity, rotate);
			},
		);

		// for (x .. 32)
		// {
		// 	for (y .. 32)
		// 	{
		// 		pos: {x: int32, y: int32} = {x as int32, y as int32};
		// 		UseGLTFResource(
		// 			model, scene,
		// 			::(scene: *Scene, rootEntity: Entity, arg: *int)
		// 			{
		// 				pos := arg as {x: int32, y: int32};
		// 				// log "Loaded gltf instance: ", rootEntity, pos;
		// 				scene.SetComponent<Transform>(rootEntity, Transform(Vec3(2 * pos.x, 2 * pos.y, 0.0)));
		// 			},
		// 			pos as *int
		// 		);
		// 	}
		// }

		CreateEditorWindow(scene);

		log "Loaded Main Scene";

	},
	"Main Scene"
)