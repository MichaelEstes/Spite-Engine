package VulkanRenderer

import ECS
import Transform
import RenderAssetDef

ComputeVulkanDrawList(renderer: VulkanRenderer, scene: *Scene)
{
	frame := renderer.Frame();
	resourceManager := vulkanInstance.resourceManager;

	device := vulkanInstance.device;
	stagingBuffer := vulkanInstance.GetStagingBuffer();
	queue := vulkanInstance.queues.transferQueue;
	commands := vulkanInstance.transferCommands;

	for (batch in renderer.drawList.batchMap.Values())
	{
		meshes := batch.meshes;
		if (!meshes.count) continue;

		drawBuffers := batch.buffers;

		currentMesh := uint32(0);
		currentIndexedCmd := VkDrawIndexedIndirectCommand();
		currentDrawCmd := VkDrawIndirectCommand();
		indexedCount := uint32(0);
		nonIndexedCount := uint32(0);

		for (slot .. meshes.count)
		{
			drawMesh := meshes[slot];
			mesh := resourceManager.meshes.Get(drawMesh.meshHandle);
			geometry := mesh.geometry;
			material := mesh.material;

			model := ModelUBO();
			worldTransform := scene.GetComponent<WorldTransform>(drawMesh.entity);
			model.model = worldTransform.mat;
			stagingBuffer.StagedBufferCopy(device, model@ as *byte, #sizeof ModelUBO, drawBuffers.modelBuffer.buffer, commands, queue, slot * #sizeof ModelUBO);

			geometryVariablesAddress := GetBufferDeviceAddress(geometry.variables.buffer);
			stagingBuffer.StagedBufferCopy(device, geometryVariablesAddress@ as *byte, #sizeof uint64, drawBuffers.geometryVariables.buffer, commands, queue, slot * #sizeof uint64);

			geometryAttributeSlotsAddress := GetBufferDeviceAddress(geometry.attributeSlots.buffer);
			stagingBuffer.StagedBufferCopy(device, geometryAttributeSlotsAddress@ as *byte, #sizeof uint64, drawBuffers.geometryAttributeSlots.buffer, commands, queue, slot * #sizeof uint64);

			materialVariablesAddress := GetBufferDeviceAddress(material.variables.buffer);
			stagingBuffer.StagedBufferCopy(device, materialVariablesAddress@ as *byte, #sizeof uint64, drawBuffers.materialVariables.buffer, commands, queue, slot * #sizeof uint64);

			materialTextureSlotsAddress := GetBufferDeviceAddress(material.textureSlots.buffer);
			stagingBuffer.StagedBufferCopy(device, materialTextureSlotsAddress@ as *byte, #sizeof uint64, drawBuffers.materialTextureSlots.buffer, commands, queue, slot * #sizeof uint64);

			if (drawMesh.meshHandle == currentMesh)
			{
				if (geometry.indexCount > 0)
				{
					currentIndexedCmd.instanceCount += 1;
					stagingBuffer.StagedBufferCopy(device, currentIndexedCmd@ as *byte, #sizeof VkDrawIndexedIndirectCommand, drawBuffers.indexedDrawCommands.buffer, commands, queue, (indexedCount - 1) * #sizeof VkDrawIndexedIndirectCommand);
				}
				else
				{
					currentDrawCmd.instanceCount += 1;
					stagingBuffer.StagedBufferCopy(device, currentDrawCmd@ as *byte, #sizeof VkDrawIndirectCommand, drawBuffers.drawCommands.buffer, commands, queue, (nonIndexedCount - 1) * #sizeof VkDrawIndirectCommand);
				}
				continue;
			}

			if (geometry.indexCount > 0)
			{
				currentIndexedCmd = VkDrawIndexedIndirectCommand();
				currentIndexedCmd.indexCount = geometry.indexCount;
				currentIndexedCmd.instanceCount = 1;
				currentIndexedCmd.firstIndex = geometry.firstIndex;
				currentIndexedCmd.vertexOffset = 0;
				currentIndexedCmd.firstInstance = slot;
				stagingBuffer.StagedBufferCopy(device, currentIndexedCmd@ as *byte, #sizeof VkDrawIndexedIndirectCommand, drawBuffers.indexedDrawCommands.buffer, commands, queue, indexedCount * #sizeof VkDrawIndexedIndirectCommand);
				indexedCount += 1;
			}
			else
			{
				currentDrawCmd = VkDrawIndirectCommand();
				currentDrawCmd.vertexCount = geometry.vertexCount;
				currentDrawCmd.instanceCount = 1;
				currentDrawCmd.firstVertex = 0;
				currentDrawCmd.firstInstance = slot;
				stagingBuffer.StagedBufferCopy(device, currentDrawCmd@ as *byte, #sizeof VkDrawIndirectCommand, drawBuffers.drawCommands.buffer, commands, queue, nonIndexedCount * #sizeof VkDrawIndirectCommand);
				nonIndexedCount += 1;
			}

			currentMesh = drawMesh.meshHandle;
		}

		batch.indexedCount = indexedCount;
		batch.nonIndexedCount = nonIndexedCount;
	}
}
