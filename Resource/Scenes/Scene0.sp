package Scene0

import SceneRegistry
import SDLRenderer
import SceneDescription
import Array

_ := SceneRegistry.RegisterScene(
	0,
	::(scene: *Scene) {
		log "Loading Main Scene"

		scene.SetSingleton<SceneDesc>({
			{
				0,
				1000,
				1000
			},
			{
				Array<string>(["DepthPass",]),
				RendererFlags.SDL
			}
		});

	},
	"Main Scene"
)