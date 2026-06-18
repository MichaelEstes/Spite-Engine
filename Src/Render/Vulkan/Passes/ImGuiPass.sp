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
			ImGuiPassName,
			::bool(builder: *RenderPassBuilder<VulkanRenderer>, scene: *Scene) 
			{
				renderer := builder.Renderer();
				builder.Read(renderer.swapchainHandle, ResourceUsageFlags.Sampled | ResourceUsageFlags.LoadUndefined);
				builder.Write(renderer.swapchainHandle);
				builder.SetClearColor(renderer.swapchainHandle, Color(0.12, 0.12, 0.12, 0.0));

				return true;
			},
			::(context: *RenderPassContext<VulkanRenderer>, scene: *Scene) 
			{
				renderer := context.renderer;
				imGuiWindowEntity := renderer.userData.entity;
				imGuiWindow := scene.GetComponent<ImGuiWindow>(imGuiWindowEntity);
				
				commandBuffer := renderer.GetCommandBuffer(CommandBufferKind.Graphics);

				if (!imGuiWindow.initialized)
				{
					renderPass := renderer.CastDriverRenderPass(context.driverRenderpass);

					initInfo := ImGui_ImplVulkan_InitInfo_t();
					initInfo.Instance = vulkanInstance.instance;
					initInfo.PhysicalDevice = vulkanInstance.GetPhysicalDevice();
					initInfo.Device = vulkanInstance.device;
					initInfo.QueueFamily = vulkanInstance.queues.graphicsQueueIndex;
					initInfo.Queue = vulkanInstance.queues.graphicsQueue;
					initInfo.PipelineCache = null;
					initInfo.DescriptorPool = renderer.materialPool;
					initInfo.MinImageCount = 2;
					initInfo.ImageCount = VulkanRenderer.FrameCount;
					initInfo.Allocator = null;
					initInfo.PipelineInfoMain.RenderPass = renderPass;
					initInfo.PipelineInfoMain.Subpass = 0;
					initInfo.PipelineInfoMain.MSAASamples = 0;

					cImGui_ImplVulkan_Init(initInfo@);
					imGuiWindow.initialized = true;
					log "ImGui Vulkan initialized";
				}

				cImGui_ImplVulkan_NewFrame();
				cImGui_ImplWin32_NewFrame();
				ImGui_NewFrame();

				imGuiWindow.Render();

				ImGui_Render();
				drawData := ImGui_GetDrawData();

				cImGui_ImplVulkan_RenderDrawData(drawData, commandBuffer);

				ImGui_EndFrame();

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