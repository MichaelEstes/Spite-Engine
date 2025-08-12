package RenderGraph

import Array
import RenderCommon

state RenderPassPool
{
	pool: Array<RenderPass>
}

RenderPassPool::ClearRenderPass(renderPass: RenderPass)
{
	renderPass.attachments.Clear();
	for (subpass in renderPass.subpasses)
	{
		subpass.inputAttachments.Clear();
		subpass.colorAttachments.Clear();
		subpass.depthStencilAttachment = AttachmentRef();
	}
	renderPass.subpasses.Clear();
	renderPass.dependecies.Clear();

}

uint32 RenderPassPool::GetNextIndex()
{
	if (this.pool.count >= this.pool.capacity)
	{
		return this.pool.Add(RenderPass());
	}

	index := this.pool.count;
	renderPass := this.pool[index];
	this.ClearRenderPass(renderPass);
	return index;
}

ref RenderPass RenderPassPool::operator::[](index: uint32)
{
	return this.pool[index];
}