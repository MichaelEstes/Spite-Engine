package SDLRenderer

import SDL
import OS
import Array
import ArrayView
import RenderGraph
import ECS
import Fiber
import RenderCommon

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
	resourceTables: ResourceTables,
	initialized := false
}

GPUTextureCreateInfo TextureDescToCreateInfo(createDesc: TextureDesc)
{
	createInfo := GPUTextureCreateInfo();
	createInfo.type = createDesc.type;
	createInfo.format = createDesc.format;
	createInfo.usage = createDesc.usage;
	createInfo.width = createDesc.width;
	createInfo.height = createDesc.height;
	createInfo.layer_count_or_depth = createDesc.layerCount;
	createInfo.num_levels = createDesc.mipLevels;
	createInfo.sample_count = createDesc.samples;

	return createInfo;
}

GPUBufferCreateInfo BufferDescToCreateInfo(createDesc: BufferDesc)
{
	createInfo := GPUBufferCreateInfo();
	createInfo.usage = createDesc.usage;
	createInfo.size = createDesc.size;

	return createInfo;
}

InitializeSDLGPUInstance()
{
	if (instance.initialized) return;

	log "Initializing SDL GPU Instance";
	Check(ShaderCross_Init(), "Error initializing Shadercross");
	instance.initialized = true;
	instance.device = CreateGPUDevice(GPUShaderFormat.SPIRV, true, null);
	instance.resourceTables = ResourceTables(
		::*GPUTexture(createDesc: TextureDesc, device: *GPUDevice) {
			return SDL.CreateGPUTexture(device, TextureDescToCreateInfo(createDesc)@);
		},
		::*GPUBuffer(createDesc: BufferDesc, device: *GPUDevice) {
			return SDL.CreateGPUBuffer(device, BufferDescToCreateInfo(createDesc)@);
		}
	)
}

*SDL.GPUDevice GetSDLInstanceDevice() => instance.device;

state SDLRenderer
{
	device: *SDL.GPUDevice,
	window: *SDL.Window,
	passes: Array<RenderPass>,
	renderGraph: RenderGraph<SDLRenderer>
}

SDLRenderer::Draw(scene: *Scene)
{
	device := this.device;
	renderGraph := this.renderGraph;
	renderGraph.SetRenderer(this@);

	for (pass in this.passes)
	{
		pass.onDraw(renderGraph, scene);
	}

	renderGraph.Compile();
	
	context := renderGraph.CreateContext();
	renderGraph.Execute(context);
}

SDLRenderer CreateSDLRenderer(window: *SDL.Window, device: *SDL.GPUDevice, passes: Array<string>)
{
	renderer := SDLRenderer();
	renderer.device = device;
	renderer.window = window;
	renderer.renderGraph.SetResourceTables(instance.resourceTables@);

	for (passName in passes)
	{
		renderPass := GetRenderPass(passName);
		if (!renderPass)
		{
			log "Unable to find render pass for SDL backend with name: ", passName;
			continue;
		}
		renderer.passes.Add(renderPass~);
	}

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
		instance.resourceTables.ReleaseTrackedResources();
	},
	FrameSystemStep.End
);