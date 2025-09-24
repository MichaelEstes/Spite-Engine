package Scene0

import Math
import Array
import SceneRegistry
import SDL
import SceneDescription

import SDLRenderPass
import VulkanRenderPass

import GLTFManager
import Render

import ThreadParamAllocator

boxEntities := Array<Entity>();

_ := SceneRegistry.RegisterScene(
	0,
	::(scene: *Scene) {
		log "Loading Main Scene";
		
		camera := Camera();
		camera.position = Vec3(2.0, 2.0, 2.0);
		camera.fov = Math.Deg2Rad(45.0);
		camera.aspect = 1.0;
		camera.near = 0.1;
		camera.far = 10.0;
		camera.LookAt(Vec3(0.0, 0.0, 0.0));
		scene.SetSingleton<Camera>(camera);

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

		log "Loading Box GLTF";
		gltfEntities := AllocThreadParam<Array<Entity>>();
		boxGLTFHandle := LoadGLTFResource(
			"./Resource/Models/Box/Box.gltf",
			//"./Resource/Models/BrainStem/BrainStem.gltf",
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
				log "Loaded gltf: ", boxEntities;

				for (entity in outEntities)
				{
					rotate := RotateOverTime();
					rotate.axis = Vec3(0.0, 0.0, 1.0) as Norm<Vec3>;
					rotate.speed = 0.25;
					scene.SetComponent<RotateOverTime>(entity, rotate);
				}
			},
			gltfEntities
		);

	},
	"Main Scene"
)