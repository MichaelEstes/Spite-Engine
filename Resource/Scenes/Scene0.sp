package Scene0

import Array
import SceneRegistry
import SDL
import SceneDescription

import SDLRenderPass
import VulkanRenderPass

import GLTFManager

boxEntities := Array<Entity>();

_ := SceneRegistry.RegisterScene(
	0,
	::(scene: *Scene) {
		log "Loading Main Scene";

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
		boxGLTFHandle := LoadGLTFResource(
			"./Resource/Models/Box/Box.gltf", 
			scene, 
			::(handle: ResourceHandle) 
			{
				log "Loaded gltf: ", boxEntities;
			}, 
			boxEntities@
		);

	},
	"Main Scene"
)