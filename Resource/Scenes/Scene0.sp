package Scene0

import Array
import SceneRegistry
import SDL
import SDLRenderPass
import SceneDescription

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
				Array<string>(["ClearPass", "DepthPass"]),
				RendererFlags.SDL
			}
		});
	},
	"Main Scene"
)