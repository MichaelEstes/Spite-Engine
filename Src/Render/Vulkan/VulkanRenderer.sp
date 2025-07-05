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

import Scene
import Query
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

	opaquePass: VulkanRenderPass,
	opaqueFrameBuffers: [frameCount]VulkanFrameBuffer,

	pipeline: VulkanPipeline,

	currentFrame: uint32
}

VulkanRenderer::Destroy()
{

}

*VulkanRenderer CreateVulkanRenderer(window: *SDL.Window)
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

	vulkanRenderer.CreatePipeline();

	//vulkanRenderer.DebugLogExtensions();

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

VkFormat VulkanRenderer::FindSupportedFormat(candidates: []VkFormat, tiling: VkImageTiling, features: uint32)
{
	for (format in candidates)
	{
		props := VkFormatProperties();
		vkGetPhysicalDeviceFormatProperties(this.device.GetPhysicalDevice(), format, props@);
		if (tiling == VkImageTiling.VK_IMAGE_TILING_LINEAR && 
			(props.linearTilingFeatures & features) == features) 
		{
            return format;
        } 
		else if (tiling == VkImageTiling.VK_IMAGE_TILING_OPTIMAL && 
					(props.optimalTilingFeatures & features) == features) 
		{
            return format;
        }
	}

	log "Error: no supported format found";
	return -1
}

VkFormat VulkanRenderer::FindDepthFormat()
{
	return this.FindSupportedFormat(
		[
			VkFormat.VK_FORMAT_D32_SFLOAT, 
			VkFormat.VK_FORMAT_D32_SFLOAT_S8_UINT, 
			VkFormat.VK_FORMAT_D24_UNORM_S8_UINT
		],
		VkImageTiling.VK_IMAGE_TILING_OPTIMAL,
		VkFormatFeatureFlagBits.VK_FORMAT_FEATURE_DEPTH_STENCIL_ATTACHMENT_BIT
	);
}

uint32 FindMemoryType(physicalDevice: *VkPhysicalDevice_T, typeFilter: uint32, properties: uint32)
{
	memProperties := VkPhysicalDeviceMemoryProperties();
	vkGetPhysicalDeviceMemoryProperties(physicalDevice, memProperties@);

	for (i .. memProperties.memoryTypeCount)
	{
		if (typeFilter & (1 << i) && (memProperties.memoryTypes[i].propertyFlags & properties) == properties)
		{
			return i;
		}
	}

	log "Error: no supported memory type found";
	return -1;
}

VulkanRenderer::CreateOpaquePass()
{
	colorFormat := this.swapchain.imageFormat;
	depthFormat := this.FindDepthFormat();

	this.opaquePass
		.AddAttachment(
			colorFormat,
			VkSampleCountFlagBits.VK_SAMPLE_COUNT_1_BIT,
			VkAttachmentLoadOp.VK_ATTACHMENT_LOAD_OP_CLEAR,
			VkAttachmentStoreOp.VK_ATTACHMENT_STORE_OP_STORE,
			VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED,
			VkImageLayout.VK_IMAGE_LAYOUT_PRESENT_SRC_KHR,
			VkImageLayout.VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL
		)
		.AddAttachment(
			depthFormat,
			VkSampleCountFlagBits.VK_SAMPLE_COUNT_1_BIT,
			VkAttachmentLoadOp.VK_ATTACHMENT_LOAD_OP_CLEAR,
			VkAttachmentStoreOp.VK_ATTACHMENT_STORE_OP_DONT_CARE,
			VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED,
			VkImageLayout.VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL,
			VkImageLayout.VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL
		)
		.AddSubpass(
			VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS,
			uint32:[0,],
			uint32(1)@
		)
		.AddDependency(
			VK_SUBPASS_EXTERNAL,
			0,

			VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT | 
			VkPipelineStageFlagBits.VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT,
			VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT | 
			VkPipelineStageFlagBits.VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT,

			0,
			VkAccessFlagBits.VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT |
			VkAccessFlagBits.VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT,

			0
		)
		.Create(this@);

	log "Created opaque pass";
}

VulkanRenderer::CreatePipeline()
{
	this.pipeline = VulkanPipeline(this@)
		.AddShader(this@, "./Resource/Shaders/Compiled/vert.spv", VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT)
		.AddShader(this@, "./Resource/Shaders/Compiled/frag.spv", VkShaderStageFlagBits.VK_SHADER_STAGE_FRAGMENT_BIT)
		.Create(this.opaquePass, 0);

	log "Created pipeline";

}

