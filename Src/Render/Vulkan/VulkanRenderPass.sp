package VulkanRenderer

state VulkanRenderPass
{
	renderPass: *VkRenderPass_T,
}

VulkanRenderPass::Initialize(renderer: *VulkanRenderer, createInfo: VkRenderPassCreateInfo)
{
	device := renderer.device.device;
	CheckResult(
		vkCreateRenderPass(device, createInfo@, null, this.renderPass@),
		"Error creating Vulkan render pass"
	);
}