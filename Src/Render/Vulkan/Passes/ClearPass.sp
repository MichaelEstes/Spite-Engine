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
				return true;
			},
			::(context: *RenderPassContext<VulkanRenderer>, param: *void) 
			{
				log "Clearing Screen";
			},
			RenderPassStage.Graphics,
			null
		);
	}
);