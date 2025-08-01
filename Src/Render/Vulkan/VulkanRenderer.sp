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

renderersByWindow := SparseSet<VulkanRenderer>();

CheckResult(result: VkResult, errorMsg: string)
{
	if (result != VkResult.VK_SUCCESS)
	{
		log errorMsg, result;
	}
}

DestroyAll()
{
	for (renderer in renderersByWindow.Values()) renderer.Destroy();
}

frameCount := 2;

state VulkanRenderer
{
	vkInstance: *VulkanInstance,
	
	window: *SDL.Window,
	surface: *VkSurfaceKHR_T,

	device: VulkanDevice,
	allocator: VulkanAllocator,

	swapchain: VulkanSwapchain,
	depthBuffer: VulkanDepthBuffer,
	frames: [frameCount]VulkanFrame,

	passes: Array<RenderPass>,

	currentFrame: uint32
}

vulkanRendererComponent := ECS.RegisterComponent<VulkanRenderer>(
	ComponentKind.Singleton
);

VulkanRenderer::Destroy()
{

}

*VulkanRenderer CreateVulkanRenderer(window: *SDL.Window, passes: Array<string>)
{
	log "Creating Vulkan renderer";
	vulkanRenderer := renderersByWindow.Emplace(window.id);
	vulkanRenderer.vkInstance = vulkanInstance@;

	vulkanRenderer.window = window;

	vulkanRenderer.CreateSurface();

	vulkanRenderer.device.Create(vulkanRenderer.surface);
	vulkanRenderer.allocator.Create(vulkanRenderer);

	vulkanRenderer.swapchain.Create(vulkanRenderer);
	vulkanRenderer.depthBuffer.Create(vulkanRenderer);

	for (i .. frameCount)
	{
		vulkanRenderer.frames[i].Create(vulkanRenderer);
	}

	vulkanRenderer.CreateOpaquePass();
	for (i .. frameCount)
	{
		vulkanRenderer.opaqueFrameBuffers[i].Create(
			vulkanRenderer,
			vulkanRenderer.opaquePass,
			[vulkanRenderer.swapchain.imageViews[i]~, vulkanRenderer.depthBuffer.image.imageView]
		);
	}

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
