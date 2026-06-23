package VulkanRenderer

import OS
import Math
import Vulkan
import SDL
import Image
import SparseSet
import Event
import ArrayView
import WindowComponent

import ECS
import RenderComponents
import RenderAssetDef
import UniformBufferObject

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
		for (ec in scene.Iterate<VulkanRenderer>())
		{
			renderer := ec.component;
			renderer.Destroy();
		}
	}
}

FrameCount := 2;

state VulkanDrawMesh
{
	entity: Entity,
	geometry: uint32, 
	material: uint32
}

state VulkanDrawList
{
	pipelineMap := Map<VulkanPipelineMeshState, Array<VulkanDrawMesh>, HashPipelineMeshState>()
}

state VulkanMeshCallbacks
{
	onMeshAdded: ::(SceneEntity, *Mesh, *VulkanRenderer) = 
			::(sceneEntity: SceneEntity, mesh: *Mesh, renderer: *VulkanRenderer) {},
	onMeshRemoved: ::(SceneEntity, *Mesh, *VulkanRenderer) = 
			::(sceneEntity: SceneEntity, mesh: *Mesh, renderer: *VulkanRenderer) {},
	
	drawListUpdate: ::(*Scene, *VulkanRenderer) = null
}

state VulkanRenderer
{	
	window: *SDL.Window,
	surface: *VkSurfaceKHR_T,

	swapchain: VulkanSwapchain,
	graphicsCommands: VulkanCommands,
	computeCommands: VulkanCommands,
	transferCommands: VulkanCommands,
	
	sceneShared: SharedUBO<SceneUBO>,
	
	materialPool: *VkDescriptorPool_T,

	frameFences: [FrameCount]*VkFence_T,

	passes: Array<VulkanRenderPass>,

	renderGraph: RenderGraph<VulkanRenderer>,

	drawList: VulkanDrawList,

	meshCallbacks: VulkanMeshCallbacks,

	userData: ?{
		ptr: *void,
		i: uint,
		entity: Entity
	},

	self: Entity,
	swapchainHandle: RenderResourceHandle,
	swapchainImageIndex: uint32,
	currentFrame: uint32,	
}

VulkanRenderer::Destroy()
{

}

state VulkanRendererConfig
{
	meshCallbacks := VulkanMeshCallbacks(),
	userData: ?{ ptr: *void, i: uint, entity: Entity } = null,
	materialDescriptorCount: uint32 = 1000,
	maxMaterialSets: uint32 = 1000,
	useSceneUBO: bool = true,
}

CreateVulkanRenderer(scene: *Scene, entity: Entity, passes: Array<string>, 
					 config: VulkanRendererConfig = VulkanRendererConfig())
{
	log "Creating Vulkan renderer";

	InitializeVulkanInstance();

	windowData := scene.GetComponent<WindowData>(entity);

	vulkanRenderer := VulkanRenderer();
	vulkanRenderer.meshCallbacks = config.meshCallbacks;
	vulkanRenderer.userData = config.userData;

	vulkanRenderer.window = windowData.window;
	vulkanRenderer.CreateSurface();

	vulkanRenderer.self = entity;

	vulkanRenderer.CreateSwapchain();

	log "Created swapchain image views";

	device := vulkanInstance.device;
	queues := vulkanInstance.queues;
	allocator := vulkanInstance.allocator;

	for (i := 0 .. FrameCount)
	{
		vulkanRenderer.frameFences[i] = CreateFence(device);
	}

	vulkanRenderer.graphicsCommands.Create(
		device, 
		queues.graphicsQueueIndex,
		FrameCount
	);
	vulkanRenderer.computeCommands.Create(
		device, 
		queues.computeQueueIndex,
		FrameCount
	);
	vulkanRenderer.transferCommands.Create(
		device, 
		queues.transferQueueIndex,
		FrameCount
	);

	if (config.useSceneUBO)
	{
		vulkanRenderer.sceneShared.Init(device, allocator, 0, VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT);
	}

	vulkanRenderer.CreateMaterialDescPool(config.materialDescriptorCount, config.maxMaterialSets);

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

	vulkanRenderer.renderGraph.SetResourceTables(vulkanInstance.resourceTables@);
	vulkanRenderer.renderGraph.SetRenderPassFuncs(
		::*VkRenderPass_T(pass: RenderGraphPass<VulkanRenderer>, renderPass: RenderPass, 
						  renderer: *VulkanRenderer)
		{
			device := vulkanInstance.device;
			renderPassCache := vulkanInstance.renderPassCache;
			frameBufferCache := vulkanInstance.frameBufferCache;
			resourceManager := vulkanInstance.resourceManager;
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

	scene.SetComponent<VulkanRenderer>(entity, vulkanRenderer);
}

VulkanRenderer::CreateSwapchain()
{
	this.swapchain.Create(this@);
	resourceManager := vulkanInstance.resourceManager;
	for (i .. this.swapchain.imageCount)
	{
		image := this.swapchain.images[i]~;
		imageView := this.swapchain.imageViews[i]~;
		renderTarget := VulkanRenderTarget();
		renderTarget.image = image;
		renderTarget.imageView = imageView;
		resourceManager.renderTargetMap.Insert(image, renderTarget);
	}
}

VulkanRenderer::RecreateSwapchain()
{
	device := vulkanInstance.device;
	vkDeviceWaitIdle(device);

	resourceManager := vulkanInstance.resourceManager;
	for (i .. this.swapchain.imageCount)
	{
		image := this.swapchain.images[i]~;
		resourceManager.renderTargetMap.Remove(image);
	}

	frameBufferCache := vulkanInstance.frameBufferCache;
	for (kv in frameBufferCache.frameBufferMap)
	{
		vkDestroyFramebuffer(device, kv.value~, null);
	}
	frameBufferCache.frameBufferMap.Clear();

	this.swapchain.Destroy(device);

	this.CreateSwapchain();
}

VulkanRenderer::CreateSurface()
{
	if (!SDL.VulkanCreateSurface(this.window, vulkanInstance.instance, null, this.surface@))
	{
		puts(SDL.GetError());
		log "Error creating Vulkan surface";
	}
}

VulkanRenderer::CreateMaterialDescPool(descriptorCount: uint32, maxSet: uint32)
{
	device := vulkanInstance.device;

	poolSizes := [VkDescriptorPoolSize(), VkDescriptorPoolSize()];
	poolSizes[0].type = VkDescriptorType.VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
	poolSizes[0].descriptorCount = descriptorCount;
	poolSizes[1].type = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
	poolSizes[1].descriptorCount = descriptorCount;

	poolInfo := VkDescriptorPoolCreateInfo();
	poolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
	poolInfo.poolSizeCount = 2;
	poolInfo.pPoolSizes = fixed poolSizes;
	poolInfo.maxSets = maxSet;

	CheckResult(
		vkCreateDescriptorPool(device, poolInfo@, null, this.materialPool@),
		"VulkanRenderer::CreateMaterialDescPool Error allocating Vulkan descriptor pool"
	);
}

*VkRenderPass_T VulkanRenderer::CastDriverRenderPass(renderPass: *any)
{
	return renderPass as *VkRenderPass_T;
}

VulkanRenderer::SetViewportAndScissor(commandBuffer: *VkCommandBuffer_T)
{
	this.SetViewport(commandBuffer);
	this.SetScissor(commandBuffer);
}

VulkanRenderer::SetViewport(commandBuffer: *VkCommandBuffer_T)
{
	viewport := VkViewport();
	viewport.x = float32(0.0);
	viewport.y = float32(0.0);
	viewport.width = this.swapchain.extent.width as float32;
	viewport.height = this.swapchain.extent.height as float32;
	viewport.minDepth = float32(0.0);
	viewport.maxDepth = float32(1.0);
	vkCmdSetViewport(commandBuffer, uint32(0), uint32(1), viewport@);
}

VulkanRenderer::SetScissor(commandBuffer: *VkCommandBuffer_T)
{
	scissor := VkRect2D();
	scissor.offset = {int32(0), int32(0)};
	scissor.extent = this.swapchain.extent;
	vkCmdSetScissor(commandBuffer, uint32(0), uint32(1), scissor@);
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
	device := vulkanInstance.device;

	fence := this.frameFences[frame]@;
	vkWaitForFences(device, 1, fence, VkTrue, UINT64_MAX);
	result := this.swapchain.AcquireNext(device, frame);
	vkResetFences(device, 1, fence);

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

VulkanRenderer::TransitionSwapchainPresent(image: *VkImage_T, currentLayout: GPUTextureLayout, 
										   format: GPUFormat)
{
	device := vulkanInstance.device;
	oldLayout := GPUTextureLayoutToVkLayout(currentLayout);
	vkFormat := format;
	
	barrier := VkImageMemoryBarrier();
	barrier.sType = VkStructureType.VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER;
	barrier.oldLayout = oldLayout;
	barrier.newLayout = VkImageLayout.VK_IMAGE_LAYOUT_PRESENT_SRC_KHR;
	barrier.srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
	barrier.dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
	barrier.image = image;
	barrier.subresourceRange.aspectMask = VkImageAspectFlagBits.VK_IMAGE_ASPECT_COLOR_BIT;
	barrier.subresourceRange.baseMipLevel = 0;
	barrier.subresourceRange.levelCount = 1;
	barrier.subresourceRange.baseArrayLayer = 0;
	barrier.subresourceRange.layerCount = 1;
	barrier.srcAccessMask = VkAccessFlagBits.VK_ACCESS_COLOR_ATTACHMENT_WRITE_BIT;
	barrier.dstAccessMask = 0;

	sourceStage := VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COLOR_ATTACHMENT_OUTPUT_BIT;
	destinationStage := VkPipelineStageFlagBits.VK_PIPELINE_STAGE_BOTTOM_OF_PIPE_BIT;

	vkCmdPipelineBarrier(
		this.GetCommandBuffer(CommandBufferKind.Graphics),
		sourceStage,
		destinationStage,
		0,
		0, 
		null,
		0, 
		null,
		1, 
		barrier@
	);
}

VulkanRenderer::UpdateSceneUBO(scene: *Scene, frame: uint32)
{
	if (!this.sceneShared.Valid()) return;

	camera := scene.GetComponent<Camera>(this.self);
	if (!camera) return;

	cameraViewMatrix := camera.GetViewMatrix();

	sceneUBO := SceneUBO();
	sceneUBO.view = cameraViewMatrix;
	sceneUBO.projection.Perspective(
		camera.fov,
		camera.aspect, 
		camera.near,
		camera.far
	);
	sceneUBO.projection[1][1] *= -1;

	this.sceneShared.Update(frame, sceneUBO);
}

VulkanRenderer::UpdateScene(scene: *Scene)
{
	frame := this.Frame();
	this.UpdateSceneUBO(scene, frame);
}

VulkanRenderer::Draw(scene: *Scene)
{
	device := vulkanInstance.device;
	frame := this.Frame();
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
			this.TransitionSwapchainPresent(
				swapchainImage,
				currentSwapchainLayout,
				swapchainDesc.format
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
		vkQueueSubmit(vulkanInstance.queues.graphicsQueue, 1, submitInfo@, fence),
		"Error submitting Vulkan draw command buffer"
	);

	this.swapchain.Present(vulkanInstance.queues.presentQueue, frame);
	this.currentFrame += 1;
}

VulkanRenderer::UpdateDrawList(scene: *Scene)
{
	if (this.meshCallbacks.drawListUpdate)
	{
		this.meshCallbacks.drawListUpdate(scene, this@);
		return;
	}

	for (kv in this.drawList.pipelineMap)
	{
		kv.value~.Clear();
	}

	for (ec in scene.Iterate<Mesh>())
	{
		entity := ec.entity;
		mesh := ec.component;

		for (primitive in mesh.primitives)
		{
			if (!primitive.geometry.gpuResourceID || !primitive.material.gpuResourceID) continue;

			assetDef := GetAssetDefWithHandle(primitive.defHandle);

			meshState := VulkanPipelineMeshState();
			meshState.assetDefHandle = primitive.defHandle;
			// TODO: topology source
			meshState.SetTopology(VkPrimitiveTopology.VK_PRIMITIVE_TOPOLOGY_TRIANGLE_LIST);
			meshState.alphaMode = assetDef.fragment.alphaMode as uint16;

			drawMesh := VulkanDrawMesh();
			drawMesh.entity = entity;
			drawMesh.geometry = primitive.geometry.gpuResourceID;
			drawMesh.material = primitive.material.gpuResourceID;

			meshArr := this.drawList.pipelineMap.Find(meshState);
			if (!meshArr)
			{
				this.drawList.pipelineMap.Insert(meshState, Array<VulkanDrawMesh>());
				meshArr = this.drawList.pipelineMap.Find(meshState);
			}
			meshArr.Add(drawMesh);
		}
	}
}

VulkanRendererComponent := ECS.RegisterComponent<VulkanRenderer>(
	ComponentKind.Sparse
);

vulkanPreDrawSystem := ECS.RegisterSystem(
	::(scene: Scene, dt: float) 
	{
		for (ec in scene.Iterate<VulkanRenderer>())
		{
			renderer := ec.component;
			renderer.UpdateDrawList(scene@);
		}
	},
	SystemStep.PreDraw
);

vulkanDrawSystem := ECS.RegisterSystem(
	::(scene: Scene, dt: float) 
	{
		for (ec in scene.Iterate<VulkanRenderer>())
		{
			renderer := ec.component;
			renderer.UpdateScene(scene@);
			renderer.Draw(scene@);
		}
	},
	SystemStep.Draw
);

vulkanDrawCleanupSystem := ECS.RegisterFrameSystem(
	::(dt: float) 
	{
		vulkanInstance.resourceTables.ReleaseTrackedResources();
	},
	FrameSystemStep.End
);
