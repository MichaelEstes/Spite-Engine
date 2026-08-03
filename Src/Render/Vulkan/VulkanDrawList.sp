package VulkanRenderer

import ECS
import Transform

InitDrawList(renderer: *VulkanRenderer)
{
	renderer.assetDefDrawSets = SparseSet<VulkanAssetDefDrawSet>();
}

*VulkanAssetDefDrawSet GetOrCreateAssetDefDrawSet(renderer: *VulkanRenderer, assetDefHandle: AssetDefHandle)
{
	key := assetDefHandle.handle;
	existing := renderer.assetDefDrawSets.Get(key);
	if (existing) return existing;

	drawSet := renderer.assetDefDrawSets.Emplace(key);
	drawSet~ = VulkanAssetDefDrawSet();

	pointerArraySize := MaxModelCount * #sizeof uint64;

	for (i .. FrameCount)
	{
		drawSet.frames[i] = VulkanAssetDefDrawFrame();

		drawSet.frames[i].modelBuffer = CreateAddressableStorageBuffer(MaxModelCount * #sizeof ModelUBO);
		drawSet.frames[i].indexedDrawCommands = CreateDeviceIndirectBuffer(MaxModelCount * #sizeof VkDrawIndexedIndirectCommand);
		drawSet.frames[i].drawCommands = CreateDeviceIndirectBuffer(MaxModelCount * #sizeof VkDrawIndirectCommand);
		drawSet.frames[i].geometryVariables = CreateAddressableStorageBuffer(pointerArraySize);
		drawSet.frames[i].geometryAttributeSlots = CreateAddressableStorageBuffer(pointerArraySize);
		drawSet.frames[i].materialVariables = CreateAddressableStorageBuffer(pointerArraySize);
		drawSet.frames[i].materialTextureSlots = CreateAddressableStorageBuffer(pointerArraySize);
	}

	return drawSet;
}

ComputeVulkanDrawList(renderer: VulkanRenderer, scene: *Scene)
{
	frame := renderer.Frame();
	resourceManager := vulkanInstance.resourceManager;

	device := vulkanInstance.device;
	stagingBuffer := vulkanInstance.GetStagingBuffer();
	queue := vulkanInstance.queues.transferQueue;
	commands := vulkanInstance.transferCommands;

	for (kv in renderer.drawList.pipelineMap)
	{
		meshArr := kv.value~;
		if (!meshArr.count) continue;

		meshState := kv.key~;
		drawSet := GetOrCreateAssetDefDrawSet(renderer@, meshState.assetDefHandle);
		frameData := drawSet.frames[frame]@;

		models := ECS.instance.frameAllocator.AllocArray<ModelUBO>(meshArr.count);
		geometryVariables := ECS.instance.frameAllocator.AllocArray<uint64>(meshArr.count);
		geometryAttributeSlots := ECS.instance.frameAllocator.AllocArray<uint64>(meshArr.count);
		materialVariables := ECS.instance.frameAllocator.AllocArray<uint64>(meshArr.count);
		materialTextureSlots := ECS.instance.frameAllocator.AllocArray<uint64>(meshArr.count);
		indexedDrawCommands := ECS.instance.frameAllocator.AllocArray<VkDrawIndexedIndirectCommand>(meshArr.count);
		drawCommands := ECS.instance.frameAllocator.AllocArray<VkDrawIndirectCommand>(meshArr.count);

		currentGeo := uint32(0);

		for (slot .. meshArr.count)
		{
			mesh := meshArr[slot];
			geometry := resourceManager.geometries.Get(mesh.geometryHandle);
			material := resourceManager.materials.Get(mesh.materialHandle);
			
			model := ModelUBO();
			worldTransform := scene.GetComponent<WorldTransform>(mesh.entity);
			if (worldTransform) model.model = worldTransform.mat;
			models.Add(model);

			geometryVariables.Add(GetBufferDeviceAddress(geometry.variables.buffer));
			geometryAttributeSlots.Add(GetBufferDeviceAddress(geometry.attributeSlots.buffer));
			materialVariables.Add(GetBufferDeviceAddress(material.variables.buffer));
			materialTextureSlots.Add(GetBufferDeviceAddress(material.textureSlots.buffer));

			if (mesh.geometryHandle == currentGeo)
			{
				if (geometry.indexCount > 0)
				{
					indexedDrawCommands.Last().instanceCount += 1;
				}
				else
				{
					drawCommands.Last().instanceCount += 1;
				}
				continue;
			}

			if (geometry.indexCount > 0)
			{
				cmd := VkDrawIndexedIndirectCommand();
				cmd.indexCount = geometry.indexCount;
				cmd.instanceCount = 1;
				cmd.firstIndex = geometry.firstIndex;
				cmd.vertexOffset = 0;
				cmd.firstInstance = slot;
				indexedDrawCommands.Add(cmd);
			}
			else
			{
				cmd := VkDrawIndirectCommand();
				cmd.vertexCount = geometry.vertexCount;
				cmd.instanceCount = 1;
				cmd.firstVertex = 0;
				cmd.firstInstance = slot;
				drawCommands.Add(cmd);
			}

			currentGeo = mesh.geometryHandle;
		}

		frameData.indexedCount = indexedDrawCommands.count;
		frameData.nonIndexedCount = drawCommands.count;

		requests := ECS.instance.frameAllocator.AllocArray<VulkanBufferCopyRequest>(7);

		modelRequest := VulkanBufferCopyRequest();
		modelRequest.data = models.mem.ptr as *byte;
		modelRequest.size = models.count * #sizeof ModelUBO;
		modelRequest.dstBuffer = frameData.modelBuffer.buffer;
		requests.Add(modelRequest);

		geometryVariablesRequest := VulkanBufferCopyRequest();
		geometryVariablesRequest.data = geometryVariables.mem.ptr as *byte;
		geometryVariablesRequest.size = geometryVariables.count * #sizeof uint64;
		geometryVariablesRequest.dstBuffer = frameData.geometryVariables.buffer;
		requests.Add(geometryVariablesRequest);

		geometryAttributeSlotsRequest := VulkanBufferCopyRequest();
		geometryAttributeSlotsRequest.data = geometryAttributeSlots.mem.ptr as *byte;
		geometryAttributeSlotsRequest.size = geometryAttributeSlots.count * #sizeof uint64;
		geometryAttributeSlotsRequest.dstBuffer = frameData.geometryAttributeSlots.buffer;
		requests.Add(geometryAttributeSlotsRequest);

		materialVariablesRequest := VulkanBufferCopyRequest();
		materialVariablesRequest.data = materialVariables.mem.ptr as *byte;
		materialVariablesRequest.size = materialVariables.count * #sizeof uint64;
		materialVariablesRequest.dstBuffer = frameData.materialVariables.buffer;
		requests.Add(materialVariablesRequest);

		materialTextureSlotsRequest := VulkanBufferCopyRequest();
		materialTextureSlotsRequest.data = materialTextureSlots.mem.ptr as *byte;
		materialTextureSlotsRequest.size = materialTextureSlots.count * #sizeof uint64;
		materialTextureSlotsRequest.dstBuffer = frameData.materialTextureSlots.buffer;
		requests.Add(materialTextureSlotsRequest);

		if (indexedDrawCommands.count)
		{
			indexedDrawCommandsRequest := VulkanBufferCopyRequest();
			indexedDrawCommandsRequest.data = indexedDrawCommands.mem.ptr as *byte;
			indexedDrawCommandsRequest.size = indexedDrawCommands.count * #sizeof VkDrawIndexedIndirectCommand;
			indexedDrawCommandsRequest.dstBuffer = frameData.indexedDrawCommands.buffer;
			requests.Add(indexedDrawCommandsRequest);
		}

		if (drawCommands.count)
		{
			drawCommandsRequest := VulkanBufferCopyRequest();
			drawCommandsRequest.data = drawCommands.mem.ptr as *byte;
			drawCommandsRequest.size = drawCommands.count * #sizeof VkDrawIndirectCommand;
			drawCommandsRequest.dstBuffer = frameData.drawCommands.buffer;
			requests.Add(drawCommandsRequest);
		}

		stagingBuffer.StagedBufferCopyBatched(device, requests, commands, queue);
	}
}
