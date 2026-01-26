package Scene0

import ECS
import Math
import Array
import SceneRegistry
import SDL
import SceneDescription

import SDLRenderPass
import VulkanRenderPass

import GLTFManager
import RenderComponents

import ThreadParamAllocator

import ImGui

import Utils

_ := SceneRegistry.RegisterScene(
	0,
	::(scene: *Scene) {
		log "Loading Main Scene";
		
		sceneEntity := scene.CreateEntity();

		camera := Camera();
		camera.position = Vec3(2.0, 1.0, 4.0);
		camera.fov = Math.Deg2Rad(70.0);
		camera.aspect = 1.0;
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
				Array<string>(["ClearPass", "ColorPass"]),
				RendererFlags.Vulkan
				//RendererFlags.SDL
			}
		});

		//model := "./Resource/Models/Box/Box.gltf";
		//model := "./Resource/Models/BoxTextured/BoxTextured.gltf";
		//model := "./Resource/Models/BrainStem/BrainStem.gltf";
		model := "./Resource/Models/DamagedHelmet/DamagedHelmet.gltf";
		log "Loading GLTF: ", model;
		gltfHandle := LoadGLTFResource(
			model, scene,
			::(handle: ResourceHandle, param: *GLTFLoadParam) 
			{
				scene := param.scene;
				log "Loaded gltf: ", param.rootEntity;

				//for (entity in outEntities)
				//{
				//	rotate := RotateOverTime();
				//	rotate.axis = Vec3(0.0, 1.0, 0.0) as Norm<Vec3>;
				//	rotate.speed = 0.25;
				//	scene.SetComponent<RotateOverTime>(entity, rotate);
				//}
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

		log "Loaded Main Scene";

	},
	"Main Scene"
)