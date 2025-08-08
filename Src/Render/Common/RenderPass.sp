package RenderCommon

state Attachment
{
	format: GPUTextureFormat,
	samples: GPUSampleCount,
	layout: GPUTextureLayout
}

state RenderPass
{
	attachments: Array<VkAttachmentDescription>,
	attachmentRefs: Array<VkAttachmentReference>,
	subpasses: Array<VkSubpassDescription>,
	dependecies: Array<VkSubpassDependency>
}