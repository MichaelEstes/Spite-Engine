package VulkanRenderPass

import VulkanRenderer
import RenderGraph
import ECS
import Vec
import SparseSet

state ColorPassState
{
	pipelineLayout: *VkPipelineLayout_T,
	descriptorSetLayout: *VkDescriptorSetLayout_T,

	vertShaderHandle: ResourceHandle,
	fragShaderHandle: ResourceHandle
}

colorStateSet := SparseSet<ColorPassState, 4>();

VulkanPipelineKey CreateColorPassPipelineKey(meshState: VulkanPipelineMeshState, 
											 renderPass: *VkRenderPass_T,
											 colorPassState: ColorPassState)
{
	key := VulkanPipelineKey();
	key.meshState = meshState;
	key.renderPass = renderPass;
	key.layout = colorPassState.pipelineLayout;
	key.vertexShaderHandle = colorPassState.vertShaderHandle;
	key.fragmentShaderHandle = colorPassState.fragShaderHandle;

	key.vertexInputBindings[0] = {uint32(0), uint32(#sizeof Vec3), VkVertexInputRate.VK_VERTEX_INPUT_RATE_VERTEX};
	key.vertexInputBindings[1] = {uint32(1), uint32(#sizeof Vec3), VkVertexInputRate.VK_VERTEX_INPUT_RATE_VERTEX};
	key.vertexInputBindings[2] = {uint32(2), uint32(#sizeof Vec2), VkVertexInputRate.VK_VERTEX_INPUT_RATE_VERTEX};
	
	key.vertexInputAttributes[0] = {uint32(0), uint32(0), VkFormat.VK_FORMAT_R32G32B32_SFLOAT, uint32(0)};
	key.vertexInputAttributes[1] = {uint32(1), uint32(1), VkFormat.VK_FORMAT_R32G32B32_SFLOAT, uint32(0)};
	key.vertexInputAttributes[2] = {uint32(2), uint32(2), VkFormat.VK_FORMAT_R32G32_SFLOAT, uint32(0)};

	return key;
}

colorPassName := "ColorPass";
colorPass := RegisterRenderPass(
	colorPassName,
	::(graph: RenderGraph<VulkanRenderer>, scene: *Scene) 
	{
		graph.AddPass(
			colorPassName,
			::bool(builder: *RenderPassBuilder<VulkanRenderer>, scene: *Scene) 
			{
				//log "Vulkan Color pass init";
				renderer := builder.Renderer();
				builder.Read(renderer.swapchainHandle);
				builder.Write(renderer.swapchainHandle);

				return true;
			},
			::(context: *RenderPassContext<VulkanRenderer>, scene: *Scene) 
			{
				//log "Vulkan Color pass exec";

				renderer := context.renderer;
				device := renderer.device;
				colorPassState := colorStateSet.Get(renderer.deviceIndex)~;
				renderPass := renderer.CastDriverRenderPass(context.driverRenderpass);

				pipelineMeshMap := meshGroupsByScene.Get(scene.id);
				for (kv in pipelineMeshMap)
				{
					pipelineMeshState := kv.key~;
					meshArr := kv.value~;

					pipelineKey := CreateColorPassPipelineKey(pipelineMeshState, renderPass, colorPassState);
					pipeline := FindOrCreatePipeline(
						device,
						pipelineKey, 
						renderer.pipelineCache~
					);

					for (mesh in meshArr)
					{

					}
				}

			},
			RenderPassStage.Graphics,
			scene
		);
	},
	::(renderer: VulkanRenderer) 
	{
		log "Color pass added";

		deviceIndex := renderer.deviceIndex;

		if (colorStateSet.Has(deviceIndex)) return;

		device := renderer.device;

		colorPassState := ColorPassState();
		colorPassState.vertShaderHandle = UseShader(device, "./Resource/Shaders/Compiled/vert.spv", GPUShaderStage.VERTEX);
		colorPassState.fragShaderHandle = UseShader(device, "./Resource/Shaders/Compiled/frag.spv", GPUShaderStage.FRAGMENT);

		uboLayoutBinding := VkDescriptorSetLayoutBinding();
		uboLayoutBinding.binding = 0;
		uboLayoutBinding.descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_UNIFORM_BUFFER;
		uboLayoutBinding.descriptorCount = 1;
		uboLayoutBinding.stageFlags = VkShaderStageFlagBits.VK_SHADER_STAGE_VERTEX_BIT;
		uboLayoutBinding.pImmutableSamplers = null; // Optional

		samplerLayoutBinding := VkDescriptorSetLayoutBinding();
		samplerLayoutBinding.binding = 1;
		samplerLayoutBinding.descriptorCount = 1;
		samplerLayoutBinding.descriptorType = VkDescriptorType.VK_DESCRIPTOR_TYPE_COMBINED_IMAGE_SAMPLER;
		samplerLayoutBinding.pImmutableSamplers = null;
		samplerLayoutBinding.stageFlags = VkShaderStageFlagBits.VK_SHADER_STAGE_FRAGMENT_BIT;

		bindings := [uboLayoutBinding, samplerLayoutBinding];
		layoutInfo := VkDescriptorSetLayoutCreateInfo();
		layoutInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_LAYOUT_CREATE_INFO;
		layoutInfo.bindingCount = 2;
		layoutInfo.pBindings = fixed bindings;
		
		CheckResult(
			vkCreateDescriptorSetLayout(device, layoutInfo@, null, colorPassState.descriptorSetLayout@),
			"Error creating Vulkan descriptor set layout"
		);

		pipelineLayoutInfo := VkPipelineLayoutCreateInfo();
		pipelineLayoutInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_PIPELINE_LAYOUT_CREATE_INFO;
		pipelineLayoutInfo.setLayoutCount = uint32(1);
		pipelineLayoutInfo.pSetLayouts = colorPassState.descriptorSetLayout@;
		//pipelineLayoutInfo.pushConstantRangeCount = uint32(0);
		//pipelineLayoutInfo.pPushConstantRanges = null;

		CheckResult(
			vkCreatePipelineLayout(device, pipelineLayoutInfo@, null, colorPassState.pipelineLayout@),
			"Error creating Vulkan pipeline layout"
		);

		colorStateSet.Insert(deviceIndex, colorPassState);
	}
);