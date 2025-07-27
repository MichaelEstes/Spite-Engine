package SDLRenderer

import SDL
import OS
import Array
import ArrayView
import RenderGraph
import ECS

Check(success: bool, errMsg: string)
{
	if (!success)
	{
		log errMsg;
	}
}

instance := SDLGPUInstance();

state SDLGPUInstance
{
	device: *GPUDevice,
}

InitializeSDLGPUInstance()
{
	log "Initializing SDL GPU Instance";
	Check(ShaderCross_Init(), "Error initializing Shadercross");
	instance.device = CreateGPUDevice(GPUShaderFormat.SPIRV, true, null);
}

*GPUDevice GetSDLInstanceDevice() => instance.device;

state SDLRenderer
{
	window: *SDL.Window,
	device: *GPUDevice,
	passes: Array<RenderPass>,
	renderGraph: RenderGraph
}

sdlRendererComponent := ECS.RegisterComponent<SDLRenderer>(
	ComponentKind.Singleton
);

SDLRenderer CreateSDLRenderer(window: *SDL.Window, device: *GPUDevice, passes: Array<RenderPass>)
{
	renderer := SDLRenderer();
	renderer.window = window;
	renderer.passes = passes;
	renderer.device = device;
	renderer.renderGraph.device = device;

	Check(ClaimWindowForGPUDevice(device, window), "Error claiming window for GPU device");

	log "Created SDL Renderer";

	return renderer;
}

sdlDrawSystem := ECS.RegisterSystem(::(scene: Scene, dt: float) {
	log "SDL drawing scene", dt;
	
	if (scene.HasSingleton<SDLRenderer>())
	{
		renderer := scene.GetSingleton<SDLRenderer>();
		renderer.Draw(scene@);
	}
});

SDLRenderer::Draw(scene: *Scene)
{
	renderGraph := this.renderGraph;

	for (pass in this.passes)
	{
		pass.onDraw(renderGraph, this, scene);
	}

	renderGraph.Compile();
}