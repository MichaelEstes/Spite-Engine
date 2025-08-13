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
	renderPass.subpass.inputAttachments.Clear();
	renderPass.subpass.colorAttachments.Clear();
	renderPass.subpass.depthStencilAttachment = AttachmentRef();
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
	this.pool.count += 1;
	return index;
}

ref RenderPass RenderPassPool::operator::[](index: uint32)
{
	return this.pool[index];
}