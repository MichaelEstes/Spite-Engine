package VulkanRenderer

import SparseSet

//state VulkanPipelineLayoutCache
//{
//	
//}

*VkDescriptorSetLayout_T FindOrCreateDescSetLayout(device: *VkDevice_T, 
												   shaderMetadata: []*GraphicsShaderMetadata,
												   metadataCount: uint32)
{
	for (i .. metadataCount)
	{
		metadata := shaderMetadata[i];
		for (ix .. metadata.num_inputs)
		{
			input := metadata.inputs[ix];
			log "Input: ", input;
		}
		log "Shader metadata: ", metadata;
	}

	return null;
}