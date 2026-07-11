package VulkanRenderer

import Array

VKDebug := true;

debugRequiredDeviceExtensions := ["VK_KHR_swapchain"[0], "VK_EXT_memory_budget"[0]];
debugDeviceExtensionCount := #compile uint32 => (#typeof debugRequiredDeviceExtensions).FixedArrayCount();

state VulkanDebugInfo
{
	memoryBudget: VkPhysicalDeviceMemoryBudgetPropertiesEXT,
}

vulkanDebugInfo := VulkanDebugInfo();

InitializeVulkanDebug()
{
}

VulkanDebugQueryMemoryBudget(physicalDevice: *VkPhysicalDevice_T)
{
	if (!VKDebug) return;

	vulkanDebugInfo.memoryBudget.sType = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_BUDGET_PROPERTIES_EXT;

	props2 := VkPhysicalDeviceMemoryProperties2();
	props2.sType = VkStructureType.VK_STRUCTURE_TYPE_PHYSICAL_DEVICE_MEMORY_PROPERTIES_2;
	props2.pNext = vulkanDebugInfo.memoryBudget@ as *void;

	vkGetPhysicalDeviceMemoryProperties2(physicalDevice, props2@);
}
