package SDLRenderer

import SDL
import OS
import Array
import ArrayView
import RenderGraph
import ECS
import Fiber

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
	device: *SDL.GPUDevice,
	initialized := false
}

InitializeSDLGPUInstance()
{
	if (instance.initialized) return;

	log "Initializing SDL GPU Instance";
	Check(ShaderCross_Init(), "Error initializing Shadercross");
	instance.initialized = true;
	instance.device = CreateGPUDevice(GPUShaderFormat.SPIRV, true, null);
}

*SDL.GPUDevice GetSDLInstanceDevice() => instance.device;

state SDLRenderer
{
	device: *SDL.GPUDevice,
	window: *SDL.Window,
	passes: Array<RenderPass>,
	renderGraph: SDLRenderGraph
}

SDLRenderer::Draw(scene: *Scene)
{
	device := this.device;
	renderGraph := this.renderGraph;

	for (pass in this.passes)
	{
		pass.onDraw(renderGraph, this, scene);
	}

	renderGraph.Compile();
	
	commandBuffer := SDL.AcquireGPUCommandBuffer(device);
	if (!commandBuffer)
	{
		log "Error creating commandBuffer";
	}
	context := renderGraph.CreateContext(commandBuffer);

	renderGraph.Execute(context);
}

SDLRenderer CreateSDLRenderer(window: *SDL.Window, device: *SDL.GPUDevice, passes: Array<string>)
{
	renderer := SDLRenderer();
	renderer.device = device;
	renderer.window = window;
	renderer.renderGraph.device = device;
	renderer.renderGraph.window = window;

	renderPasses := Array<RenderPass>();
	for (passName in passes)
	{
		renderPasses.Add(GetRenderPass(passName));
	}
	renderer.passes = renderPasses;

	Check(ClaimWindowForGPUDevice(device, window), "Error claiming window for GPU device");

	log "Created SDL Renderer";

	return renderer;
}

sdlRendererComponent := ECS.RegisterComponent<SDLRenderer>(
	ComponentKind.Singleton
);

sdlDrawSystem := ECS.RegisterSystem(
	::(scene: Scene, dt: float) 
	{
		if (scene.HasSingleton<SDLRenderer>())
		{
			Fiber.RunOnMainThread(::(scene: *Scene) 
			{
				renderer := scene.GetSingleton<SDLRenderer>();
				renderer.Draw(scene);
			}, scene@);
		}
	},
	SystemStep.Draw
);

sdlDrawCleanupSystem := ECS.RegisterFrameSystem(
	::(dt: float) 
	{
		log "Frame end", dt;
		ReleaseTrackedResources();
	},
	FrameSystemStep.End
);