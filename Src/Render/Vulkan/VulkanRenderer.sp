package VulkanRenderer

import OS
import Math
import Vulkan
import SDL
import Image
import SparseSet
import Event
import Vertex
import UniformBufferObject
import Time
import FixedArray
import ArrayView

import ECS
import Render

UINT64_MAX := uint64(-1);
VkFalse := uint32(0);
VkTrue := uint32(1);

appInfo := {
	VkStructureType.VK_STRUCTURE_TYPE_APPLICATION_INFO,
	null,
	"Spite Engine"[0],
	uint32(0),
	"Spite Engine"[0],
	uint32(0),
	uint32(0),
} as VkApplicationInfo;

validationLayers := ["VK_LAYER_KHRONOS_validation"[0],];
validationCount := #compile uint32 => (#typeof validationLayers).FixedArrayCount();

requiredDeviceExtensions := ["VK_KHR_swapchain"[0],];
requiredDeviceExtensionCount := #compile uint32 => (#typeof requiredDeviceExtensions).FixedArrayCount();

CheckResult(result: VkResult, errorMsg: string)
{
	if (result != VkResult.VK_SUCCESS)
	{
		log errorMsg, result;
	}
}

DestroyAll()
{
	for (scene in ECS.Scenes())
	{
		if (scene.HasSingleton<VulkanRenderer>())
		{
			renderer := scene.GetSingleton<VulkanRenderer>();
			renderer.Destroy();
		}
	}
}

FrameCount := 2;

state VulkanRenderer
{
	vkInstance: *VulkanInstance,
	
	window: *SDL.Window,
	surface: *VkSurfaceKHR_T,

	device: VulkanDevice,
	allocator: VulkanAllocator,

	swapchain: VulkanSwapchain,
	commands: [FrameCount]VulkanCommands,

	passes: Array<RenderPass>,

	renderGraph: RenderGraph<VulkanRenderer>
	
	currentFrame: uint32
}

VulkanRenderer::Destroy()
{

}

VulkanRenderer CreateVulkanRenderer(window: *SDL.Window, passes: Array<string>)
{
	log "Creating Vulkan renderer";
	vulkanRenderer := VulkanRenderer();
	vulkanRenderer.vkInstance = vulkanInstance@;

	vulkanRenderer.window = window;
	vulkanRenderer.CreateSurface();

	vulkanRenderer.device.Create(vulkanRenderer.surface);
	vulkanRenderer.allocator.Create(vulkanRenderer@);

	vulkanRenderer.swapchain.Create(vulkanRenderer@);

	for (i .. FrameCount)
	{
		vulkanRenderer.commands[i].Create(vulkanRenderer@);
	}

	for (passName in passes)
	{
		renderPass := GetRenderPass(passName);
		if (!renderPass)
		{
			log "Unable to find render pass for Vulkan backend with name: ", passName;
			continue;
		}
		vulkanRenderer.passes.Add(renderPass~);
	}

	vulkanRenderer.renderGraph.SetResourceTables(vulkanInstance.resourceTables@);

	return vulkanRenderer;
}

VulkanRenderer::CreateSurface()
{
	if (!SDL.VulkanCreateSurface(this.window, this.vkInstance.instance, null, this.surface@))
	{
		puts(SDL.GetError());
		log "Error creating Vulkan surface";
	}
}

VulkanRenderer::Draw(scene: *Scene)
{
	frame := this.currentFrame % FrameCount;
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

vulkanRendererComponent := ECS.RegisterComponent<VulkanRenderer>(
	ComponentKind.Singleton
);

vulkanDrawSystem := ECS.RegisterSystem(
	::(scene: Scene, dt: float) 
	{
		if (scene.HasSingleton<VulkanRenderer>())
		{
			renderer := scene.GetSingleton<VulkanRenderer>();
			renderer.Draw(scene@);
		}
	},
	SystemStep.Draw
);

sdlDrawCleanupSystem := ECS.RegisterFrameSystem(
	::(dt: float) 
	{
		vulkanInstance.resourceTables.ReleaseTrackedResources();
	},
	FrameSystemStep.End
);
