package Scene0

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

_ := SceneRegistry.RegisterScene(
	0,
	::(scene: *Scene) {
		log "Loading Main Scene";
		
		camera := Camera();
		camera.position = Vec3(0.0, 0.0, 4.0);
		camera.fov = Math.Deg2Rad(70.0);
		camera.aspect = 1.0;
		camera.near = 0.1;
		camera.far = 1000.0;
		camera.LookAt(Vec3(0.0, 0.0, 0.0));

		scene.SetSingleton<Camera>(camera);
		scene.SetSingleton<CameraOrbit>(CameraOrbit());

		scene.SetSingleton<SceneDesc>({
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
		gltfEntities := AllocThreadParam<Array<Entity>>();
		gltfEntities~ = Array<Entity>();
		gltfHandle := LoadGLTFResource(
			model,
			scene,
			::(handle: ResourceHandle, param: *GLTFLoadParam) 
			{
				outEntities := param.outEntities;
				defer 
				{
					delete outEntities~
					DeallocThreadParam<Array<Entity>>(outEntities);
				}

				scene := param.scene;
				log "Loaded gltf: ", outEntities.count, outEntities~;

				//for (entity in outEntities)
				//{
				//	rotate := RotateOverTime();
				//	rotate.axis = Vec3(0.0, 0.0, 1.0) as Norm<Vec3>;
				//	rotate.speed = 0.25;
				//	scene.SetComponent<RotateOverTime>(entity, rotate);
				//}
			},
			gltfEntities
		);

		log "Loaded Main Scene";

	},
	"Main Scene"
)