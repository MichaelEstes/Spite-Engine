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
	swapchain: VulkanSwapchain,
	frames: [frameCount]VulkanFrame,

	shadowMapPass: VulkanRenderPass,
	opaquePass: VulkanRenderPass,
	transparentPass: VulkanRenderPass,
	postProcessPass: VulkanRenderPass,
	uiPass: VulkanRenderPass,



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

	vulkanRenderer.InitializeSurface();

	vulkanRenderer.device.Initialize(vulkanRenderer.surface);
	vulkanRenderer.swapchain.Initialize(vulkanRenderer);

	for (i .. frameCount)
	{
		vulkanRenderer.frames[i].Initialize(vulkanRenderer);
	}

	vulkanRenderer.CreateShadowMapPass();
	vulkanRenderer.CreateOpaquePass();
	vulkanRenderer.CreateTransparentPass();
	vulkanRenderer.CreatePostProcessPass();
	vulkanRenderer.CreateUIPass();

	//vulkanRenderer.DebugLogExtensions();

	return vulkanRenderer;
}

VulkanRenderer::InitializeSurface()
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

VulkanRenderer::CreateShadowMapPass()
{
	depthAttachment := VkAttachmentDescription();
	depthAttachment.format = this.FindDepthFormat();
	depthAttachment.samples = VkSampleCountFlagBits.VK_SAMPLE_COUNT_1_BIT;
	depthAttachment.loadOp = VkAttachmentLoadOp.VK_ATTACHMENT_LOAD_OP_CLEAR;
	depthAttachment.storeOp = VkAttachmentStoreOp.VK_ATTACHMENT_STORE_OP_DONT_CARE;
	depthAttachment.stencilLoadOp = VkAttachmentLoadOp.VK_ATTACHMENT_LOAD_OP_DONT_CARE;
	depthAttachment.stencilStoreOp = VkAttachmentStoreOp.VK_ATTACHMENT_STORE_OP_DONT_CARE;
	depthAttachment.initialLayout = VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED;
	depthAttachment.finalLayout = VkImageLayout.VK_IMAGE_LAYOUT_DEPTH_STENCIL_READ_ONLY_OPTIMAL;

	attachmentRef := VkAttachmentReference();
	attachmentRef.attachment = 0;
	attachmentRef.layout = VkImageLayout.VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;

	subpass := VkSubpassDescription();
	subpass.pipelineBindPoint = VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS;
	subpass.colorAttachmentCount = 0;
	subpass.pColorAttachments = null;
	subpass.pDepthStencilAttachment = attachmentRef@;

	dependency := VkSubpassDependency();
	dependency.srcSubpass = VK_SUBPASS_EXTERNAL;
	dependency.dstSubpass = 0;
	dependency.srcStageMask = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT;
	dependency.srcAccessMask = 0;
	dependency.dstStageMask = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_EARLY_FRAGMENT_TESTS_BIT;
	dependency.dstAccessMask = VkAccessFlagBits.VK_ACCESS_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT;

	renderPassInfo := VkRenderPassCreateInfo();
	renderPassInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
	renderPassInfo.attachmentCount = 1;
	renderPassInfo.pAttachments = depthAttachment@;
	renderPassInfo.subpassCount = 1;
	renderPassInfo.pSubpasses = subpass@;
	renderPassInfo.dependencyCount = 1;
	renderPassInfo.pDependencies = dependency@;

	this.shadowMapPass.Initialize(this@, renderPassInfo);
	log "Created shadow map pass";
}

VulkanRenderer::CreateOpaquePass()
{
	colorFormat := VkFormat.VK_FORMAT_B8G8R8A8_UNORM;
	depthFormat := this.FindDepthFormat();

	colorAttachment := VkAttachmentDescription();
	colorAttachment.format = colorFormat;
	colorAttachment.samples = VkSampleCountFlagBits.VK_SAMPLE_COUNT_4_BIT;
	colorAttachment.loadOp = VkAttachmentLoadOp.VK_ATTACHMENT_LOAD_OP_CLEAR;
	colorAttachment.storeOp = VkAttachmentStoreOp.VK_ATTACHMENT_STORE_OP_DONT_CARE;
	colorAttachment.initialLayout = VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED;
	colorAttachment.finalLayout = VkImageLayout.VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;

	resolveAttachment := VkAttachmentDescription();
	resolveAttachment.format = colorFormat;
	resolveAttachment.samples = VkSampleCountFlagBits.VK_SAMPLE_COUNT_1_BIT;
	resolveAttachment.loadOp = VkAttachmentLoadOp.VK_ATTACHMENT_LOAD_OP_DONT_CARE;
	resolveAttachment.storeOp = VkAttachmentStoreOp.VK_ATTACHMENT_STORE_OP_STORE;
	resolveAttachment.initialLayout = VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED;
	resolveAttachment.finalLayout = VkImageLayout.VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL;

	depthAttachment := VkAttachmentDescription();
	depthAttachment.format = depthFormat;
	depthAttachment.samples = VkSampleCountFlagBits.VK_SAMPLE_COUNT_4_BIT;
	depthAttachment.loadOp = VkAttachmentLoadOp.VK_ATTACHMENT_LOAD_OP_CLEAR;
	depthAttachment.storeOp = VkAttachmentStoreOp.VK_ATTACHMENT_STORE_OP_DONT_CARE;
	depthAttachment.initialLayout = VkImageLayout.VK_IMAGE_LAYOUT_UNDEFINED;
	depthAttachment.finalLayout = VkImageLayout.VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;

	colorAttachmentRef := VkAttachmentReference();
	colorAttachmentRef.attachment = 0;
	colorAttachmentRef.layout = VkImageLayout.VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;

	resolveAttachmentRef := VkAttachmentReference();
	resolveAttachmentRef.attachment = 1;
	resolveAttachmentRef.layout = VkImageLayout.VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL;

	depthAttachmentRef := VkAttachmentReference();
	depthAttachmentRef.attachment = 2;
	depthAttachmentRef.layout = VkImageLayout.VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL;

	subpass := VkSubpassDescription();
	subpass.pipelineBindPoint = VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_GRAPHICS;
	subpass.colorAttachmentCount = 1;
	subpass.pColorAttachments = colorAttachmentRef@;
	subpass.pResolveAttachments = resolveAttachmentRef@;
	subpass.pDepthStencilAttachment = depthAttachmentRef@;

	dependency := VkSubpassDependency();
	dependency.srcSubpass = VK_SUBPASS_EXTERNAL;
	dependency.dstSubpass = 0;
	dependency.srcStageMask = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
	dependency.srcAccessMask = 0;
	dependency.dstStageMask = VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
	dependency.dstAccessMask = VkAccessFlagBits.VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;

	attachments := [colorAttachment, resolveAttachment, depthAttachment];
	renderPassInfo := VkRenderPassCreateInfo();
	renderPassInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_CREATE_INFO;
	renderPassInfo.attachmentCount = 3;
	renderPassInfo.pAttachments = fixed attachments;
	renderPassInfo.subpassCount = 1;
	renderPassInfo.pSubpasses = subpass@;
	renderPassInfo.dependencyCount = 1;
	renderPassInfo.pDependencies = dependency@;

	this.opaquePass.Initialize(this@, renderPassInfo);
	log "Created opaque pass";
}

