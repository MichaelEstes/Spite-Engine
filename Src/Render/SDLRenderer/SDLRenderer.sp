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
	windowToRenderer: Map<*Window, SDLRenderer>
}

SDLGPUInstance::AddRenderer(window: *Window, renderer: SDLRenderer)
{
	instance.windowToRenderer.Insert(window, renderer);
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
	window: *Window,
	device: *GPUDevice,
	passes: Array<RenderPass>,
	renderGraph: RenderGraph
}

SDLRenderer CreateSDLRenderer(window: *Window, device: *GPUDevice, passes: Array<RenderPass>)
{
	renderer := SDLRenderer();
	renderer.window = window;
	renderer.passes = passes;
	renderer.device = device;
	renderer.renderGraph.device = device;

	Check(ClaimWindowForGPUDevice(device, window), "Error claiming window for GPU device");

	instance.AddRenderer(window, renderer);

	log "Created SDL Renderer";

	return renderer;
}

SDLRenderer::Draw()
{
	renderGraph := this.renderGraph;

	for (pass in this.passes)
	{
		pass.onDraw(renderGraph, this);
	}

	renderGraph.Compile();
}