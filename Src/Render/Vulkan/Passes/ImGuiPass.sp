package VulkanRenderPass

import VulkanRenderer
import RenderGraph
import ECS
import ImGui

ImGuiPassName := "ImGuiPass";
ImGuiPass := RegisterRenderPass(
	ImGuiPassName,
	::(graph: RenderGraph<VulkanRenderer>, scene: *Scene) 
	{
		graph.AddPass(
			colorPassName,
			::bool(builder: *RenderPassBuilder<VulkanRenderer>, scene: *Scene) 
			{
				renderer := builder.Renderer();
				builder.Read(renderer.swapchainHandle);
				builder.Write(renderer.swapchainHandle);

				return true;
			},
			::(context: *RenderPassContext<VulkanRenderer>, scene: *Scene) 
			{
				renderer := context.renderer;
				imGuiWindowEntity := renderer.userData.entity;
				imGuiWindow := scene.GetComponent<ImGuiWindow>(imGuiWindowEntity);
				vulkanBackend := imGuiWindow.backend.vulkan;

				if (!vulkanBackend.initialized)
				{
					renderPass := renderer.CastDriverRenderPass(context.driverRenderpass);

					initInfo := ImGui_ImplVulkan_InitInfo_t();
					initInfo.Instance = renderer.vkInstance.instance;
					initInfo.PhysicalDevice = renderer.physicalDevice;
					initInfo.Device = renderer.device;
					initInfo.QueueFamily = renderer.queues.graphicsQueueIndex;
					initInfo.Queue = renderer.queues.graphicsQueue;
					initInfo.PipelineCache = vulkanBackend.pipelineCache;
					initInfo.DescriptorPool = renderer.texturePool;
					initInfo.MinImageCount = 2;
					initInfo.ImageCount = VulkanRenderer.FrameCount;
					initInfo.Allocator = null;
					initInfo.PipelineInfoMain.RenderPass = renderPass;
					initInfo.PipelineInfoMain.Subpass = 0;
					initInfo.PipelineInfoMain.MSAASamples = 0;

					cImGui_ImplVulkan_Init(initInfo@);
					log "ImGui Vulkan initialized";

					vulkanBackend.initialized = true;
				}

			},
			RenderPassStage.Graphics,
			scene
		);
	},
	::(renderer: VulkanRenderer) 
	{
		log "ImGui pass added";
	}
);