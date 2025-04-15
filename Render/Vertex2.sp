package Vertex

import Vec
import Vulkan
import Array

state Vertex2
{
	pos: Vec2,
	color: Vec3,
	texCoord: Vec2
}

VkVertexInputBindingDescription Vertex2BindingDescription()
{
	bindingDescription := VkVertexInputBindingDescription();
	bindingDescription.binding = 0;
	bindingDescription.stride = #sizeof Vertex2;
	bindingDescription.inputRate = VkVertexInputRate.VK_VERTEX_INPUT_RATE_VERTEX;
	
	return bindingDescription;
}

Array<VkVertexInputAttributeDescription> Vertex2AttributeDescriptions()
{
	attributeDescriptions := Array<VkVertexInputAttributeDescription>(3);
	attributeDescriptions.Add(VkVertexInputAttributeDescription());
	attributeDescriptions.Add(VkVertexInputAttributeDescription());
	attributeDescriptions.Add(VkVertexInputAttributeDescription());
	
	attributeDescriptions[0].binding = 0;
	attributeDescriptions[0].location = 0;
	attributeDescriptions[0].format = VkFormat.VK_FORMAT_R32G32_SFLOAT;
	attributeDescriptions[0].offset = #offsetof(Vertex2, pos);

	attributeDescriptions[1].binding = 0;
	attributeDescriptions[1].location = 1;
	attributeDescriptions[1].format = VkFormat.VK_FORMAT_R32G32B32_SFLOAT;
	attributeDescriptions[1].offset = #offsetof(Vertex2, color);

	attributeDescriptions[2].binding = 0;
    attributeDescriptions[2].location = 2;
    attributeDescriptions[2].format = VkFormat.VK_FORMAT_R32G32_SFLOAT;
    attributeDescriptions[2].offset = #offsetof(Vertex2, texCoord);

	return attributeDescriptions;
}