package VulkanRenderPass

import VulkanRenderer
import RenderGraph
import ECS

clearPassName := "ClearPass";

clearPass := RegisterRenderPass(
	clearPassName,
	::(graph: RenderGraph<VulkanRenderer>, scene: *Scene) 
	{
		graph.AddPass(
			clearPassName,
			::bool(builder: *RenderPassBuilder<VulkanRenderer>, param: *void) 
			{
				log "Vulkan Clear pass init";
				return true;
			},
			::(context: *RenderPassContext<VulkanRenderer>, param: *void) 
			{
				log "Vulkan Clear pass exec";
			},
			RenderPassStage.Graphics,
			null
		);
	}
);