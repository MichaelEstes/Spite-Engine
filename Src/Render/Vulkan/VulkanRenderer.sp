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
import ArrayView

import ECS
import Render

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

	device: *VkDevice_T,
	queues: *VulkanQueues,
	physicalDevice: *VkPhysicalDevice_T
	allocator: *VulkanAllocator,
	stagingBuffer: *VulkanStagingBuffer,
	pipelineCache: *VulkanPipelineCache,

	swapchain: VulkanSwapchain,
	graphicsCommands: VulkanCommands,
	computeCommands: VulkanCommands,
	transferCommands: VulkanCommands,
	
	frameFences: [FrameCount]*VkFence_T,

	passes: Array<VulkanRenderPass>,

	renderGraph: RenderGraph<VulkanRenderer>,
	
	deviceIndex: uint32,
	swapchainHandle: RenderResourceHandle,
	swapchainImageIndex: uint32,
	currentFrame: uint32
}

VulkanRenderer::Destroy()
{

}

VulkanRenderer CreateVulkanRenderer(window: *SDL.Window, passes: Array<string>, 
								    deviceIndex: uint32 = vulkanInstance.defaultDevice)
{
	log "Creating Vulkan renderer";

	vulkanInstance.InitializeDevice(deviceIndex);

	vulkanRenderer := VulkanRenderer();
	vulkanRenderer.vkInstance = vulkanInstance@;

	vulkanRenderer.window = window;
	vulkanRenderer.CreateSurface();

	vulkanRenderer.deviceIndex = deviceIndex;
	vulkanRenderer.device = vulkanInstance.devices[deviceIndex]~;
	vulkanRenderer.queues = vulkanInstance.queues[deviceIndex];
	vulkanRenderer.physicalDevice = vulkanInstance.physicalDevices[deviceIndex]~;
	vulkanRenderer.allocator = vulkanInstance.allocators[deviceIndex];
	vulkanRenderer.stagingBuffer = vulkanInstance.GetStagingBuffer(deviceIndex);
	vulkanRenderer.pipelineCache = vulkanInstance.pipelineCaches[deviceIndex];

	vulkanRenderer.swapchain.Create(vulkanRenderer@);
	resourceManager := vulkanInstance.resourceManagers[deviceIndex];
	for (i .. vulkanRenderer.swapchain.imageCount)
	{
		image := vulkanRenderer.swapchain.images[i]~;
		imageView := vulkanRenderer.swapchain.imageViews[i]~;
		renderTarget := VulkanRenderTarget();
		renderTarget.image = image;
		renderTarget.imageView = imageView;
		resourceManager.renderTargetMap.Insert(image, renderTarget);
	}

	for (i := 0 .. FrameCount)
	{
		vulkanRenderer.frameFences[i] = CreateFence(vulkanRenderer.device);
	}

	vulkanRenderer.graphicsCommands.Create(
		vulkanRenderer.device, 
		vulkanRenderer.queues.graphicsQueueIndex,
		FrameCount
	);
	vulkanRenderer.computeCommands.Create(
		vulkanRenderer.device, 
		vulkanRenderer.queues.computeQueueIndex,
		FrameCount
	);
	vulkanRenderer.transferCommands.Create(
		vulkanRenderer.device, 
		vulkanRenderer.queues.transferQueueIndex,
		FrameCount
	);

	for (passName in passes)
	{
		renderPass := GetRenderPass(passName);
		if (!renderPass)
		{
			log "Unable to find render pass for Vulkan backend with name: ", passName;
			continue;
		}
		if (renderPass.onInit) renderPass.onInit(vulkanRenderer);
		vulkanRenderer.passes.Add(renderPass~);
	}

	vulkanRenderer.renderGraph.SetResourceTables(vulkanInstance.resourceTables[deviceIndex]);
	vulkanRenderer.renderGraph.SetRenderPassFuncs(
		::*VkRenderPass_T(pass: RenderGraphPass<VulkanRenderer>, renderPass: RenderPass, 
							 renderer: *VulkanRenderer)
		{
			deviceIndex := renderer.deviceIndex;
			device := renderer.device;
			renderPassCache := vulkanInstance.renderPassCaches[deviceIndex]~;
			frameBufferCache := vulkanInstance.frameBufferCaches[deviceIndex]~;
			resourceManager := vulkanInstance.resourceManagers[deviceIndex]~;
			renderGraph := renderer.renderGraph;

			vkRenderPass := FindOrCreateRenderPass(renderPass, renderPassCache, device);
			assert vkRenderPass, "Unable to create Vulkan render pass";

			commandBuffer := renderer.GetCommandBuffer(CommandBufferKind.Graphics);
			
			clearCount := 0;
			width := uint16(0);
			height := uint16(0);
			layers := uint16(1);

			clearValues := [8]VkClearValue;
			attachmentImageViews := [8]*VkImageView_T;
			for (imageView in attachmentImageViews) imageView = null;
	
			attachmentIndex := 0;
			for (i .. pass.resourceCount)
			{
				resourceUsage := pass.resources[i];
				handle := resourceUsage.handle;
				imageResource := renderGraph.handles.UseResource(handle, renderer);
				if (imageResource.kind == ResourceKind.Texture)
				{
					image := imageResource.resource as *VkImage_T;
					renderTarget := resourceManager.renderTargetMap.Find(image);
					attachmentImageViews[attachmentIndex] = renderTarget.imageView;
					clearValues[attachmentIndex] = resourceUsage.clearValue as VkClearValue;
					attachmentIndex += 1;

					textureDesc := renderGraph.handles.GetResourceDesc(handle).desc.texture;
					if (textureDesc.width > width) width = textureDesc.width;
					if (textureDesc.height > height) height = textureDesc.height;
				}
			}

			frameBuffer := FindOrCreateFramebuffer(
				vkRenderPass, frameBufferCache, device,
				width, height, layers,
				attachmentImageViews
			);
			assert frameBuffer, "Unable to create Vulkan frame buffer";

			renderArea := pass.renderArea~ as VkRect2D;
			if (!renderArea.extent.width) renderArea.extent.width = width;
			if (!renderArea.extent.height) renderArea.extent.height = height;

			renderPassInfo := VkRenderPassBeginInfo();
			renderPassInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_RENDER_PASS_BEGIN_INFO;
			renderPassInfo.renderPass = vkRenderPass;
			renderPassInfo.framebuffer = frameBuffer;
			renderPassInfo.renderArea = renderArea;
			renderPassInfo.clearValueCount = attachmentIndex;
			renderPassInfo.pClearValues = fixed clearValues;
			
			vkCmdBeginRenderPass(commandBuffer, renderPassInfo@, VkSubpassContents.VK_SUBPASS_CONTENTS_INLINE);

			return vkRenderPass;
		},
		::(vkRenderPass: *VkRenderPass_T, renderer: *VulkanRenderer)
		{
			commandBuffer := renderer.GetCommandBuffer(CommandBufferKind.Graphics);
			vkCmdEndRenderPass(commandBuffer);
		}
	);

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

uint32 VulkanRenderer::Frame() => this.currentFrame % FrameCount;

enum CommandBufferKind: uint32
{
	Graphics,
	Compute
}

*VkCommandBuffer_T VulkanRenderer::GetCommandBuffer(kind: CommandBufferKind)
{
	frame := this.Frame();
	if (kind == CommandBufferKind.Compute && this.computeCommands.bufferCount)
	{
		return this.computeCommands.commandBuffers[frame]~;
	}

	return this.graphicsCommands.commandBuffers[frame]~;
}

VkResult VulkanRenderer::WaitAndAcquireSwapchain(frame: uint32)
{
	fence := this.frameFences[frame]@;
	vkWaitForFences(this.device, 1, fence, VkTrue, UINT64_MAX);
	result := this.swapchain.AcquireNext(this.device, frame);
	vkResetFences(this.device, 1, fence);

	return result;
}

*VkImage_T VulkanRenderer::GetSwapchainImage() => this.swapchain.GetCurrentSwapchainImage();

VulkanRenderer::Begin(commandBuffer: *VkCommandBuffer_T)
{
	CheckResult(vkResetCommandBuffer(commandBuffer, 0), "Error resetting Vulkan command buffer");

	beginInfo := VkCommandBufferBeginInfo();
	beginInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
	beginInfo.flags = VkCommandBufferUsageFlagBits.VK_COMMAND_BUFFER_USAGE_SIMULTANEOUS_USE_BIT;
	CheckResult(
		vkBeginCommandBuffer(commandBuffer, beginInfo@), 
		"Error beginning Vulkan command buffer recording"
	);
}

VulkanRenderer::End(commandBuffer: *VkCommandBuffer_T)
{
	vkEndCommandBuffer(commandBuffer);
}

VulkanRenderer::TransitionTexture(image: *VkImage_T, currentLayout: GPUTextureLayout, targetLayout: GPUTextureLayout, 
								  format: GPUFormat, renderer: *VulkanRenderer)
{
	oldLayout := GPUTextureLayoutToVkLayout(currentLayout);
	newLayout := GPUTextureLayoutToVkLayout(targetLayout);
	vkFormat := format;
	//log "Transitioning image: ", oldLayout, newLayout, vkFormat;

	commandBuffer := renderer.GetCommandBuffer(CommandBufferKind.Graphics);
	TransitionImageLayout(
		commandBuffer,
		image,
		oldLayout,
		newLayout,
		vkFormat
	);
}

VulkanRenderer::Draw(scene: *Scene)
{
	frame := this.Frame();
	device := this.device;
	renderGraph := this.renderGraph;
	renderGraph.SetRenderer(this@);
	resourceTables := renderGraph.handles.resourceTables;

	this.WaitAndAcquireSwapchain(frame);

	swapchainImage := this.swapchain.GetCurrentSwapchainImage();
	swapchainDesc := this.swapchain.GetSwapchainDesc();
	this.swapchainHandle = renderGraph.handles.AddExternalTextureResource(
		"swapchain", 
		swapchainImage,
		swapchainDesc
	);

	for (pass in this.passes)
	{
		pass.onDraw(renderGraph, scene);
	}

	renderGraph.Compile();
	
	graphicsCommandBuffer := this.GetCommandBuffer(CommandBufferKind.Graphics);
	this.Begin(graphicsCommandBuffer);
	{
		renderGraph.Execute();

		currentSwapchainLayout := resourceTables.GetCurrentTextureLayout(swapchainImage);
		if (currentSwapchainLayout != GPUTextureLayout.Present)
		{
			this.TransitionTexture(
				swapchainImage,
				currentSwapchainLayout,
				GPUTextureLayout.Present,
				swapchainDesc.format,
				this@
			);
		}
	}
	this.End(graphicsCommandBuffer);

	waitSemaphores := [this.swapchain.waitSemaphores[frame],];
	waitStages := [VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT,];
	signalSemaphores := [this.swapchain.signalSemaphores[frame],];
	fence := this.frameFences[frame];

	submitInfo := VkSubmitInfo();
	submitInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_SUBMIT_INFO;
	submitInfo.waitSemaphoreCount = 1;
	submitInfo.pWaitSemaphores = fixed waitSemaphores;
	submitInfo.pWaitDstStageMask = fixed waitStages;
	submitInfo.commandBufferCount = 1;
	submitInfo.pCommandBuffers = graphicsCommandBuffer@;
	submitInfo.signalSemaphoreCount = 1;
	submitInfo.pSignalSemaphores = fixed signalSemaphores;

	CheckResult(
		vkQueueSubmit(this.queues.graphicsQueue, 1, submitInfo@, fence),
		"Error submitting Vulkan draw command buffer"
	);

	this.swapchain.Present(this.queues.presentQueue, frame);
	this.currentFrame += 1;
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

vulkanDrawCleanupSystem := ECS.RegisterFrameSystem(
	::(dt: float) 
	{
		for (i .. vulkanInstance.physicalDeviceCount)
		{
			vulkanInstance.resourceTables[i].ReleaseTrackedResources();
		}
	},
	FrameSystemStep.End
);
