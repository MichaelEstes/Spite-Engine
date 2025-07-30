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
}

InitializeSDLGPUInstance()
{
	log "Initializing SDL GPU Instance";
	Check(ShaderCross_Init(), "Error initializing Shadercross");
	instance.device = CreateGPUDevice(GPUShaderFormat.SPIRV, true, null);
}

*SDL.GPUDevice GetSDLInstanceDevice() => instance.device;

state SDLRenderer
{
	device: *SDL.GPUDevice,
	window: *SDL.Window,
	passes: Array<RenderPass>,
	renderGraph: RenderGraph
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

SDLRenderer CreateSDLRenderer(window: *SDL.Window, device: *SDL.GPUDevice, passes: Array<RenderPass>)
{
	renderer := SDLRenderer();
	renderer.device = device;
	renderer.window = window;
	renderer.passes = passes;
	renderer.renderGraph.device = device;
	renderer.renderGraph.window = window;

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
			handle: *Fiber.JobHandle = null;
			Fiber.RunOnMainFiber(::(scene: *Scene) 
			{
				renderer := scene.GetSingleton<SDLRenderer>();
				renderer.Draw(scene);
			}, scene@, handle@);
			Fiber.WaitForHandle(handle);
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