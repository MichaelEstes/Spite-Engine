package VulkanRenderer

import OS
import Math
import Vulkan
import SDL
import Image
import SparseSet
import Event
import Array
import ArrayView
import WindowComponent

import ECS
import RenderComponents
import RenderAssetDef
import UniformBufferObject
import Transform

CheckResult(result: VkResult, errorMsg: string)
{
	if (result != VkResult.VK_SUCCESS)
	{
		log errorMsg, result;
	}
}

DestroyAllRenderers()
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

state VulkanDrawID
{
	index: uint32,
	drawIndex: uint32
}

VulkanDrawIDComponent := ECS.RegisterComponent<VulkanDrawID>(
	ComponentKind.Common
);

state VulkanDrawMesh
{
	entity: Entity,
	meshHandle: uint32
}

state VulkanBatchBuffers
{
	modelBuffer: BufferHandle,
	geometryVariables: BufferHandle,
	geometryAttributeSlots: BufferHandle,
	materialVariables: BufferHandle,
	materialTextureSlots: BufferHandle,

	indexedDrawCommands: BufferHandle,
	drawCommands: BufferHandle,

	culledIndexedDrawCommands: BufferHandle,
	culledDrawCommands: BufferHandle
	culledIndexedDrawCount: BufferHandle,
	culledDrawCount: BufferHandle,

	modelBufferAddress: uint64,
	geometryVariablesAddress: uint64,
	geometryAttributeSlotsAddress: uint64,
	materialVariablesAddress: uint64,
	materialTextureSlotsAddress: uint64,

	indexedDrawCommandsAddress: uint64,
	drawCommandsAddress: uint64,

	culledIndexedDrawCommandsAddress: uint64,
	culledDrawCommandsAddress: uint64,
	culledIndexedDrawCountAddress: uint64,
	culledDrawCountAddress: uint64,
}

state VulkanDrawBatch
{
	buffers: VulkanBatchBuffers,
	meshes: Array<VulkanDrawMesh>,
	meshState: VulkanPipelineMeshState,

	indexedCount: uint32,
	nonIndexedCount: uint32,

	dirtyIndex: uint32 = uint32(-1)
}

state VulkanDrawList
{
	batchMap := Map<VulkanPipelineMeshState, VulkanDrawBatch, HashPipelineMeshState>()
}

VulkanDrawBatch::CreateBatchBuffers()
{
	drawBuffers := this.buffers@;

	pointerArraySize := MaxModelCount * #sizeof uint64;

	drawBuffers.modelBuffer = CreateAddressableStorageBuffer(MaxModelCount * #sizeof ModelUBO);
	drawBuffers.geometryVariables = CreateAddressableStorageBuffer(pointerArraySize);
	drawBuffers.geometryAttributeSlots = CreateAddressableStorageBuffer(pointerArraySize);
	drawBuffers.materialVariables = CreateAddressableStorageBuffer(pointerArraySize);
	drawBuffers.materialTextureSlots = CreateAddressableStorageBuffer(pointerArraySize);

	drawBuffers.indexedDrawCommands = CreateDeviceIndirectBuffer(MaxModelCount * #sizeof VkDrawIndexedIndirectCommand);
	drawBuffers.drawCommands = CreateDeviceIndirectBuffer(MaxModelCount * #sizeof VkDrawIndirectCommand);

	drawBuffers.culledIndexedDrawCommands = CreateDeviceIndirectBuffer(MaxModelCount * #sizeof VkDrawIndexedIndirectCommand);
	drawBuffers.culledDrawCommands = CreateDeviceIndirectBuffer(MaxModelCount * #sizeof VkDrawIndirectCommand);
	drawBuffers.culledIndexedDrawCount = CreateDeviceIndirectBuffer(#sizeof uint32);
	drawBuffers.culledDrawCount = CreateDeviceIndirectBuffer(#sizeof uint32);

	drawBuffers.modelBufferAddress = GetBufferDeviceAddress(drawBuffers.modelBuffer.buffer);
	drawBuffers.geometryVariablesAddress = GetBufferDeviceAddress(drawBuffers.geometryVariables.buffer);
	drawBuffers.geometryAttributeSlotsAddress = GetBufferDeviceAddress(drawBuffers.geometryAttributeSlots.buffer);
	drawBuffers.materialVariablesAddress = GetBufferDeviceAddress(drawBuffers.materialVariables.buffer);
	drawBuffers.materialTextureSlotsAddress = GetBufferDeviceAddress(drawBuffers.materialTextureSlots.buffer);

	drawBuffers.indexedDrawCommandsAddress = GetBufferDeviceAddress(drawBuffers.indexedDrawCommands.buffer);
	drawBuffers.drawCommandsAddress = GetBufferDeviceAddress(drawBuffers.drawCommands.buffer);

	drawBuffers.culledIndexedDrawCommandsAddress = GetBufferDeviceAddress(drawBuffers.culledIndexedDrawCommands.buffer);
	drawBuffers.culledDrawCommandsAddress = GetBufferDeviceAddress(drawBuffers.culledDrawCommands.buffer);
	drawBuffers.culledIndexedDrawCountAddress = GetBufferDeviceAddress(drawBuffers.culledIndexedDrawCount.buffer);
	drawBuffers.culledDrawCountAddress = GetBufferDeviceAddress(drawBuffers.culledDrawCount.buffer);

}

state VulkanMeshCallbacks
{
	onMeshAdded: ::(SceneEntity, *Mesh, *VulkanRenderer) = 
			::(sceneEntity: SceneEntity, mesh: *Mesh, renderer: *VulkanRenderer) 
			{
				renderer.MeshUpdated(sceneEntity, mesh);
			},

	onMeshRemoved: ::(SceneEntity, *Mesh, *VulkanRenderer) = 
			::(sceneEntity: SceneEntity, mesh: *Mesh, renderer: *VulkanRenderer) 
			{
				renderer.MeshRemoved(sceneEntity, mesh);
			},
	
	drawListUpdate: ::(*Scene, *VulkanRenderer) = null
}

state VulkanRendererConfig
{
	meshCallbacks := VulkanMeshCallbacks(),
	userData: ?{ ptr: *void, i: uint, entity: Entity } = null,
	materialDescriptorCount: uint32 = 1000,
	maxMaterialSets: uint32 = 1000,
	useSceneUBO: bool = true,
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
	needsRecreate: bool,
}

VulkanRenderer::Destroy()
{

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
		renderPassBase := GetRenderPass(passName);
		if (!renderPassBase)
		{
			log "Unable to find render pass for Vulkan backend with name: ", passName;
			continue;
		}

		renderPass := renderPassBase~;
		if (renderPass.onInit) renderPass.onInit(vulkanRenderer, renderPass@);
		vulkanRenderer.passes.Add(renderPass);
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
					if (textureDesc.flags & GPUTextureFlags.SizeSwapchainRelative)
					{
						textureDesc.width = renderer.swapchain.extent.width;
						textureDesc.height = renderer.swapchain.extent.height;
					}
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

*VulkanRenderPass VulkanRenderer::GetRenderPassByName(name: string)
{
	for (pass in this.passes)
	{
		if (pass.name == name) return pass@;
	}

	return null;
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
	log "Recreating Swapchain";
	device := vulkanInstance.device;
	vkDeviceWaitIdle(device);

	resourceManager := vulkanInstance.resourceManager;
	for (i .. this.swapchain.imageCount)
	{
		image := this.swapchain.images[i]~;
		resourceManager.renderTargetMap.Remove(image);
	}

	resourceTables := vulkanInstance.resourceTables;
	for (i .. FrameCount)
	{
		textureTable := resourceTables.textureTables[i];
		for (arr in textureTable.descToResource.Values())
		{
			for (tracked in arr)
			{
				image := tracked.resource as *VkImage_T;
				renderTarget := resourceManager.renderTargetMap.Find(image);
				if (renderTarget)
				{
					vkDestroyImageView(device, renderTarget.imageView, null);
					vkDestroyImage(device, image, null);
					resourceManager.renderTargetMap.Remove(image);
				}
				resourceTables.textureToLayout.Remove(image);
			}
		}
		textureTable.descToResource.Clear();
	}

	frameBufferCache := vulkanInstance.frameBufferCache;
	for (kv in frameBufferCache.frameBufferMap)
	{
		vkDestroyFramebuffer(device, kv.value~, null);
	}
	frameBufferCache.frameBufferMap.Clear();

	this.swapchain.Destroy(device);

	this.CreateSwapchain();

	for (pass in this.passes)
	{
		if (pass.onResize) pass.onResize(this, pass@);
	}
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
	if (result != VkResult.VK_SUCCESS && result != VkResult.VK_SUBOPTIMAL_KHR)
	{
		return result;
	}
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
	camera := scene.GetComponent<Camera>(this.self);
	if (!camera) return;

	if (camera.autoAspect)
	{
		camera.aspect = this.swapchain.extent.width as float32 /
						this.swapchain.extent.height as float32;
	}

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

	sceneUBO.screenSize = Vec2(
		this.swapchain.extent.width as float32,
		this.swapchain.extent.height as float32
	);

	this.sceneShared.Update(frame, sceneUBO);
}

Query CreateUpdatedTransformQuery()
{
	query := Query().With<Mesh>().With<VulkanDrawID>().WithTag(TransformUpdatedTag);
	return query;
}

updatedTransformQuery := CreateUpdatedTransformQuery();

VulkanRenderer::UpdateTransforms(scene: *Scene)
{
	commandBuffer := this.GetCommandBuffer(CommandBufferKind.Graphics);

	result := updatedTransformQuery.Scene(scene).Result();

	if (result.Empty())
	{
		return;
	}

	for (entity in result)
	{
		mesh := scene.GetComponent<Mesh>(entity);
		transform := scene.GetComponent<WorldTransform>(entity);
		drawID := scene.GetComponent<VulkanDrawID>(entity);

		meshState := CreatePipelineStateFromMesh(mesh);
		batch := this.drawList.batchMap.Find(meshState);
		drawBuffers := batch.buffers;

		model := ModelUBO();
		model.model = transform.mat;

		UpdateBufferCopy(
			commandBuffer, drawBuffers.modelBuffer.buffer,
			model@ as *byte, #sizeof ModelUBO, drawID.index * #sizeof ModelUBO
		);
	}
}

VulkanRenderer::UpdateBatches(scene: *Scene)
{
	commandBuffer := this.GetCommandBuffer(CommandBufferKind.Graphics);
	resourceManager := vulkanInstance.resourceManager;

	for (batch in this.drawList.batchMap.Values())
	{
		if (batch.dirtyIndex == uint32(-1)) continue;

		drawBuffers := batch.buffers;

		drawIndex := uint32(0);
		instanceCount := uint32(0);
		indexedCount := uint32(0);
		nonIndexedCount := uint32(0);
		for (index .. batch.dirtyIndex)
		{
			drawMesh := batch.meshes[index];
			if (index && batch.meshes[index - 1].meshHandle == drawMesh.meshHandle)
			{
				instanceCount += uint32(1);
				continue;
			}

			drawIndex = index;
			instanceCount = uint32(1);

			vulkanMesh := resourceManager.meshes.Get(drawMesh.meshHandle);
			if (vulkanMesh.geometry.indexCount > 0) indexedCount += uint32(1);
			else nonIndexedCount += uint32(1);
		}

		for (index := batch.dirtyIndex .. batch.meshes.count)
		{
			drawMesh := batch.meshes[index];

			instanced := index && batch.meshes[index - 1].meshHandle == drawMesh.meshHandle;
			if (instanced)
			{
				instanceCount += uint32(1);
			}
			else
			{
				drawIndex = index;
				instanceCount = uint32(1);
			}

			drawID := VulkanDrawID();
			drawID.index = index;
			drawID.drawIndex = drawIndex;
			scene.SetComponentDirect<VulkanDrawID>(drawMesh.entity, drawID, VulkanDrawIDComponent);

			vulkanMesh := resourceManager.meshes.Get(drawMesh.meshHandle);
			geometry := vulkanMesh.geometry;
			material := vulkanMesh.material;

			geometryVariablesAddress := GetBufferDeviceAddress(geometry.variables.buffer);
			UpdateBufferCopy(
				commandBuffer, drawBuffers.geometryVariables.buffer,
				geometryVariablesAddress@ as *byte, #sizeof uint64, index * #sizeof uint64
			);

			geometryAttributeSlotsAddress := GetBufferDeviceAddress(geometry.attributeSlots.buffer);
			UpdateBufferCopy(
				commandBuffer, drawBuffers.geometryAttributeSlots.buffer,
				geometryAttributeSlotsAddress@ as *byte, #sizeof uint64, index * #sizeof uint64
			);

			materialVariablesAddress := GetBufferDeviceAddress(material.variables.buffer);
			UpdateBufferCopy(
				commandBuffer, drawBuffers.materialVariables.buffer,
				materialVariablesAddress@ as *byte, #sizeof uint64, index * #sizeof uint64
			);

			materialTextureSlotsAddress := GetBufferDeviceAddress(material.textureSlots.buffer);
			UpdateBufferCopy(
				commandBuffer, drawBuffers.materialTextureSlots.buffer,
				materialTextureSlotsAddress@ as *byte, #sizeof uint64, index * #sizeof uint64
			);

			if (instanced)
			{
				if (geometry.indexCount > 0)
				{
					UpdateBufferCopy(
						commandBuffer, drawBuffers.indexedDrawCommands.buffer,
						instanceCount@ as *byte, #sizeof uint32,
						(indexedCount - 1) * #sizeof VkDrawIndexedIndirectCommand + #offsetof(VkDrawIndexedIndirectCommand, instanceCount)
					);
				}
				else
				{
					UpdateBufferCopy(
						commandBuffer, drawBuffers.drawCommands.buffer,
						instanceCount@ as *byte, #sizeof uint32,
						(nonIndexedCount - 1) * #sizeof VkDrawIndirectCommand + #offsetof(VkDrawIndirectCommand, instanceCount)
					);
				}
			}
			else
			{
				if (geometry.indexCount > 0)
				{
					currentIndexedCmd := VkDrawIndexedIndirectCommand();
					currentIndexedCmd.indexCount = geometry.indexCount;
					currentIndexedCmd.instanceCount = 1;
					currentIndexedCmd.firstIndex = geometry.firstIndex;
					currentIndexedCmd.vertexOffset = 0;
					currentIndexedCmd.firstInstance = index;
					UpdateBufferCopy(
						commandBuffer, drawBuffers.indexedDrawCommands.buffer,
						currentIndexedCmd@ as *byte, #sizeof VkDrawIndexedIndirectCommand,
						indexedCount * #sizeof VkDrawIndexedIndirectCommand
					);
					indexedCount += 1;
				}
				else
				{
					currentDrawCmd := VkDrawIndirectCommand();
					currentDrawCmd.vertexCount = geometry.vertexCount;
					currentDrawCmd.instanceCount = 1;
					currentDrawCmd.firstVertex = 0;
					currentDrawCmd.firstInstance = index;
					UpdateBufferCopy(
						commandBuffer, drawBuffers.drawCommands.buffer,
						currentDrawCmd@ as *byte, #sizeof VkDrawIndirectCommand,
						nonIndexedCount * #sizeof VkDrawIndirectCommand
					);
					nonIndexedCount += 1;
				}
			}
		}

		batch.indexedCount = indexedCount;
		batch.nonIndexedCount = nonIndexedCount;
		batch.dirtyIndex = uint32(-1);
	}
}

VulkanRenderer::UpdateScene(scene: *Scene, frame: uint32)
{
	if (!this.sceneShared.Valid()) return;

	this.UpdateSceneUBO(scene, frame);
	this.UpdateBatches(scene);
	this.UpdateTransforms(scene);
	ComputeVulkanDrawList(this, scene);
}

VulkanRenderer::Draw(scene: *Scene)
{
	device := vulkanInstance.device;

	if (this.needsRecreate)
	{
		this.RecreateSwapchain();
		this.needsRecreate = false;
	}

	frame := this.Frame();
	renderGraph := this.renderGraph;
	renderGraph.SetRenderer(this@);
	resourceTables := renderGraph.handles.resourceTables;

	result := this.WaitAndAcquireSwapchain(frame);
	if (result == VkResult.VK_ERROR_OUT_OF_DATE_KHR)
	{
		this.needsRecreate = true;
		return;
	}

	swapchainImage := this.swapchain.GetCurrentSwapchainImage();
	swapchainDesc := this.swapchain.GetSwapchainDesc();
	this.swapchainHandle = renderGraph.handles.AddExternalTextureResource(
		"swapchain", 
		swapchainImage,
		swapchainDesc
	);

	for (pass in this.passes)
	{
		pass.onDraw(renderGraph, scene, pass@);
	}

	renderGraph.Compile();
	
	graphicsCommandBuffer := this.GetCommandBuffer(CommandBufferKind.Graphics);
	this.Begin(graphicsCommandBuffer);
	{
		this.UpdateScene(scene, frame);
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

	presentResult := this.swapchain.Present(vulkanInstance.queues.presentQueue, frame);
	if (presentResult == VkResult.VK_ERROR_OUT_OF_DATE_KHR ||
		presentResult == VkResult.VK_SUBOPTIMAL_KHR)
	{
		this.needsRecreate = true;
	}
	this.currentFrame += 1;
}

VulkanRenderer::MeshUpdated(sceneEntity: SceneEntity, mesh: *Mesh)
{
	entity := sceneEntity.entity;
	meshHandle := mesh.gpuResourceID;

	if (!meshHandle) return;

	meshState := CreatePipelineStateFromMesh(mesh);

	drawMesh := VulkanDrawMesh();
	drawMesh.entity = entity;
	drawMesh.meshHandle = meshHandle;

	batch := this.drawList.batchMap.Find(meshState);
	if (!batch)
	{
		this.drawList.batchMap.Insert(meshState, VulkanDrawBatch());
		batch = this.drawList.batchMap.Find(meshState);
		batch.meshState = meshState;
		batch.CreateBatchBuffers();
	}

	index := batch.meshes.SortedInsert(
		drawMesh, 
		::byte(left: VulkanDrawMesh, right: VulkanDrawMesh) 
		{
			if (left.meshHandle < right.meshHandle) return -1;
			if (left.meshHandle > right.meshHandle) return 1;
			return 0;
		}
	);
	if (index < batch.dirtyIndex) batch.dirtyIndex = index;
}

VulkanRenderer::MeshRemoved(sceneEntity: SceneEntity, mesh: *Mesh)
{
	
}

VulkanRendererComponent := ECS.RegisterComponent<VulkanRenderer>(
	ComponentKind.Sparse
);

vulkanDrawSystem := ECS.RegisterSystem(
	::(scene: Scene, dt: float) 
	{
		for (ec in scene.Iterate<VulkanRenderer>())
		{
			renderer := ec.component;
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
