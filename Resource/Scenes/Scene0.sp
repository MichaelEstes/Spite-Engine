package Scene0

import Array
import SceneRegistry
import SDL
import SceneDescription

import SDLRenderPass
import VulkanRenderPass

import GLTFManager

gltfEntities := Array<Entity>();

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
				Array<string>(["ClearPass",]),
				RendererFlags.Vulkan
				//RendererFlags.SDL
			}
		});

		LoadGLTFResource("./Resource/Models/Box/Box.gltf", scene, ::(handle: ResourceHandle) {
			log "Loaded gltf: ", handle;

			gltfResource := Resource.TakeResourceRef<GLTFResource>(handle);
			log "GLTF RESOURCE: ", gltfResource;
			Resource.ReleaseResourceRef(handle);
		}, gltfEntities@);

	},
	"Main Scene"
)