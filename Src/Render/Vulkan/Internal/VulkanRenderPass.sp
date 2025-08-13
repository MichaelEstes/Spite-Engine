package VulkanRenderer

import RenderCommon

state VulkanRenderPassCache
{
	renderPassMap := Map<RenderPass, *VkRenderPass_T, 
						 RenderCommon.HashRenderPass, RenderCommon.RenderPassEquals>()
}

*VkRenderPass_T CreateVulkanRenderPass(device: *VkDevice_T, createInfo: VkRenderPassCreateInfo)
{
	renderPass: *VkRenderPass_T = null;
	CheckResult(
		vkCreateRenderPass(device, createInfo@, null, renderPass@),
		"Error creating Vulkan render pass"
	);

	return renderPass;
}

VkRenderPassCreateInfo RenderPassToCreateInfo(renderPass: RenderPass)
{
	createInfo := VkRenderPassCreateInfo();
	createInfo.attachmentCount = renderPass.attachments.count;

	return createInfo;
}
