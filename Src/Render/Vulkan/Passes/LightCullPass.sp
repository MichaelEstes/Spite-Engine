package VulkanRenderPass

import VulkanRenderer
import RenderGraph
import ECS
import Array
import Matrix
import Vec
import RenderComponents
import Transform
import Common

ClusterGridX := uint32(16);
ClusterGridY := uint32(9);
ClusterGridZ := uint32(24);
ClusterCount := ClusterGridX * ClusterGridY * ClusterGridZ;

// vec4 minPoint + vec4 maxPoint per cluster.
ClusterAABBSize := uint32((#sizeof Vec4) * 2);

MaxLights := uint32(256);

state GpuLight
{
	positionRadius: Vec4,   // xyz = position, w = radius
	colorIntensity: Vec4    // rgb = color, a = intensity
}
LightSize := (#sizeof GpuLight) as uint32;

state ClusterBuildParams
{
	invProjection: Matrix4,
	screenAndTile: Vec4,   // x,y = screen px ; z,w = tile px
	clusterParams: Vec4,   // x,y,z = grid dims
	zParams: Vec4          // x = zNear ; y = zFar
}

clusterBuildSource := `
#version 460
#pragma shader_stage(compute)

layout(local_size_x = 64) in;

struct ClusterAABB {
	vec4 minPoint;
	vec4 maxPoint;
};

layout(std430, set = 0, binding = 0) buffer Clusters {
	ClusterAABB clusters[];
};

layout(push_constant) uniform Params {
	mat4 invProjection;
	vec4 screenAndTile;   // x,y = screen px ; z,w = tile px
	vec4 clusterParams;   // x,y,z = grid dims
	vec4 zParams;         // x = zNear ; y = zFar
} params;

// Unproject a screen-space pixel coordinate to a view-space ray endpoint.
vec3 screenToView(vec2 screenPx)
{
	vec2 texCoord = screenPx / params.screenAndTile.xy;
	vec4 clip = vec4(texCoord * 2.0 - 1.0, 1.0, 1.0);
	vec4 view = params.invProjection * clip;
	return view.xyz / view.w;
}

// Intersect the line eye->point with the plane z = zDistance (view space).
vec3 lineIntersectZ(vec3 a, vec3 b, float zDistance)
{
	vec3 ab = b - a;
	float t = (zDistance - a.z) / ab.z;
	return a + t * ab;
}

void main()
{
	uint idx = gl_GlobalInvocationID.x;

	uint gridX = uint(params.clusterParams.x);
	uint gridY = uint(params.clusterParams.y);
	uint gridZ = uint(params.clusterParams.z);
	uint total = gridX * gridY * gridZ;
	if (idx >= total) return;

	uint z = idx / (gridX * gridY);
	uint xy = idx % (gridX * gridY);
	uint y = xy / gridX;
	uint x = xy % gridX;

	vec2 tileSize = params.screenAndTile.zw;
	vec2 minScreen = vec2(float(x), float(y)) * tileSize;
	vec2 maxScreen = vec2(float(x + 1u), float(y + 1u)) * tileSize;

	vec3 minView = screenToView(minScreen);
	vec3 maxView = screenToView(maxScreen);

	float zNear = params.zParams.x;
	float zFar = params.zParams.y;

	// View space looks down -Z; cluster slice planes are negative.
	float tileNear = -zNear * pow(zFar / zNear, float(z) / float(gridZ));
	float tileFar  = -zNear * pow(zFar / zNear, float(z + 1u) / float(gridZ));

	vec3 eye = vec3(0.0);
	vec3 minNear = lineIntersectZ(eye, minView, tileNear);
	vec3 minFar  = lineIntersectZ(eye, minView, tileFar);
	vec3 maxNear = lineIntersectZ(eye, maxView, tileNear);
	vec3 maxFar  = lineIntersectZ(eye, maxView, tileFar);

	vec3 aabbMin = min(min(minNear, minFar), min(maxNear, maxFar));
	vec3 aabbMax = max(max(minNear, minFar), max(maxNear, maxFar));

	clusters[idx].minPoint = vec4(aabbMin, 1.0);
	clusters[idx].maxPoint = vec4(aabbMax, 1.0);
}
`;

MaxLightsPerCluster := uint32(64);
// uvec2 (offset, count) per cluster.
LightGridSize := uint32(8);

state ClusterCullParams
{
	view: Matrix4,
	lightCount: uint32,
	clusterCount: uint32,
	maxPerCluster: uint32,
	pad: uint32
}

clusterCullSource := `
#version 460
#pragma shader_stage(compute)

#extension GL_EXT_control_flow_attributes : require

layout(local_size_x = 64) in;

#define MAX_PER_CLUSTER 64

struct ClusterAABB {
	vec4 minPoint;
	vec4 maxPoint;
};

struct Light {
	vec4 positionRadius;
	vec4 colorIntensity;
};

layout(std430, set = 0, binding = 0) readonly buffer Clusters {
	ClusterAABB clusters[];
};

layout(std430, set = 0, binding = 1) readonly buffer Lights {
	Light lights[];
};

layout(std430, set = 0, binding = 2) buffer LightGrid {
	uvec2 lightGrid[];   // x = offset into lightIndices, y = count
};

layout(std430, set = 0, binding = 3) buffer LightIndices {
	uint lightIndices[];
};

layout(std430, set = 0, binding = 4) buffer Counter {
	uint globalCount;
};

layout(push_constant) uniform Params {
	mat4 view;
	uvec4 counts;   // x = lightCount, y = clusterCount, z = maxLightsPerCluster
} params;

bool sphereIntersectsAABB(vec3 center, float radius, vec3 mn, vec3 mx)
{
	float sqDist = 0.0;
	[[unroll]] for (int i = 0; i < 3; i++)
	{
		float v = center[i];
		if (v < mn[i]) sqDist += (mn[i] - v) * (mn[i] - v);
		if (v > mx[i]) sqDist += (v - mx[i]) * (v - mx[i]);
	}
	return sqDist <= radius * radius;
}

void main()
{
	uint idx = gl_GlobalInvocationID.x;
	if (idx >= params.counts.y) return;

	vec3 mn = clusters[idx].minPoint.xyz;
	vec3 mx = clusters[idx].maxPoint.xyz;

	uint lightCount = params.counts.x;
	uint maxPerCluster = min(params.counts.z, uint(MAX_PER_CLUSTER));

	uint localIndices[MAX_PER_CLUSTER];
	uint localCount = 0;

	for (uint i = 0; i < lightCount; i++)
	{
		vec3 worldPos = lights[i].positionRadius.xyz;
		float radius = lights[i].positionRadius.w;
		vec3 viewPos = (params.view * vec4(worldPos, 1.0)).xyz;

		if (sphereIntersectsAABB(viewPos, radius, mn, mx))
		{
			if (localCount < maxPerCluster)
			{
				localIndices[localCount] = i;
				localCount++;
			}
		}
	}

	uint offset = atomicAdd(globalCount, localCount);
	for (uint i = 0; i < localCount; i++)
	{
		lightIndices[offset + i] = localIndices[i];
	}
	lightGrid[idx] = uvec2(offset, localCount);
}
`;

state ClusterInfoData
{
	invProj: Matrix4,
	invView: Matrix4,
	screenAndTile: Vec4,
	clusterX: uint32,
	clusterY: uint32,
	clusterZ: uint32,
	clusterPad: uint32,
	zParams: Vec4          // x = near, y = far
}
ClusterInfoSize := (#sizeof ClusterInfoData) as uint32;

state LightCullFrame
{
	cullSet: *VkDescriptorSet_T,
}

state LightCullState
{
	buildPipeline: *VulkanComputePipeline,
	buildPool: *VkDescriptorPool_T,
	buildSet: *VkDescriptorSet_T,

	cullPipeline: *VulkanComputePipeline,
	cullPool: *VkDescriptorPool_T,
	cullFrames: VulkanFrameResource<LightCullFrame>,

	lightsHandle: RenderResourceHandle,
	lightGridHandle: RenderResourceHandle,
	lightIndexHandle: RenderResourceHandle,
	counterHandle: RenderResourceHandle,
	clusterInfoHandle: RenderResourceHandle,
	clusterBuffer: HandleBuffer,

	buildParams: ClusterBuildParams,
	cullParams: ClusterCullParams,
	lightCount: uint32,

	built: bool
}

LightCullState::GatherLights(scene: *Scene, lightsBuffer: *VkBuffer_T)
{
	renderBuffer := vulkanInstance.resourceManager.renderBufferMap.Find(lightsBuffer);
	lightsPtr := vulkanInstance.allocator.GetAllocationMappedPtr(renderBuffer.handle) as *GpuLight;

	count := uint32(0);
	for (ec in scene.Iterate<PointLight>())
	{
		if (count >= MaxLights) break;

		light := ec.component;
		worldTransform := scene.GetComponentDirect<WorldTransform>(ec.entity, WorldTransformComponent);
		if (!worldTransform) continue;

		gpuLight := GpuLight();
		gpuLight.positionRadius = Vec4(
			worldTransform.mat[3][0], worldTransform.mat[3][1], worldTransform.mat[3][2],
			light.radius
		);
		gpuLight.colorIntensity = Vec4(
			light.color.r, light.color.g, light.color.b, light.intensity
		);

		lightsPtr[count]~ = gpuLight;
		count += 1;
	}

	this.lightCount = count;
}

LightCullState::UpdateCullParams(scene: *Scene, renderer: *VulkanRenderer)
{
	camera := scene.GetComponent<Camera>(renderer.self);

	this.cullParams.view = camera.GetViewMatrix();
	this.cullParams.lightCount = this.lightCount;
	this.cullParams.clusterCount = ClusterCount;
	this.cullParams.maxPerCluster = MaxLightsPerCluster;
}

LightCullState::UpdateBuildParams(scene: *Scene, renderer: *VulkanRenderer)
{
	camera := scene.GetComponent<Camera>(renderer.self);

	projection := Matrix4();
	projection.Perspective(camera.fov, camera.aspect, camera.near, camera.far);
	projection[1][1] *= -1;

	extent := renderer.swapchain.extent;
	screenW := extent.width as float32;
	screenH := extent.height as float32;

	this.buildParams.invProjection = projection.Inverse();
	this.buildParams.screenAndTile = Vec4(
		screenW, screenH,
		screenW / (ClusterGridX as float32), screenH / (ClusterGridY as float32)
	);
	this.buildParams.clusterParams = Vec4(
		ClusterGridX as float32, ClusterGridY as float32, ClusterGridZ as float32, 0.0
	);
	this.buildParams.zParams = Vec4(camera.near, camera.far, 0.0, 0.0);
}

LightCullState::FillClusterInfo(scene: *Scene, renderer: *VulkanRenderer, buffer: *VkBuffer_T)
{
	camera := scene.GetComponent<Camera>(renderer.self);

	renderBuffer := vulkanInstance.resourceManager.renderBufferMap.Find(buffer);
	info := vulkanInstance.allocator.GetAllocationMappedPtr(renderBuffer.handle) as *ClusterInfoData;

	info.invProj = this.buildParams.invProjection;
	info.invView = this.cullParams.view.Inverse();
	info.screenAndTile = this.buildParams.screenAndTile;
	info.clusterX = ClusterGridX;
	info.clusterY = ClusterGridY;
	info.clusterZ = ClusterGridZ;
	info.clusterPad = 0;
	info.zParams = Vec4(camera.near, camera.far, 0.0, 0.0);
}

ComputeBarrier(cmd: *VkCommandBuffer_T,
			   srcAccess: VkAccessFlagBits, dstAccess: VkAccessFlagBits,
			   srcStage: VkPipelineStageFlagBits, dstStage: VkPipelineStageFlagBits)
{
	barrier := VkMemoryBarrier();
	barrier.sType = VkStructureType.VK_STRUCTURE_TYPE_MEMORY_BARRIER;
	barrier.srcAccessMask = srcAccess;
	barrier.dstAccessMask = dstAccess;
	vkCmdPipelineBarrier(
		cmd,
		srcStage, dstStage,
		0,
		1, barrier@,
		0, null,
		0, null
	);
}

lightCullPassName := "LightCullPass";

lightCullPass := RegisterRenderPass(
	lightCullPassName,
	::(graph: RenderGraph<VulkanRenderer>, scene: *Scene, self: *VulkanRenderPass)
	{
		renderer := graph.renderer;
		frame := renderer.Frame();
		lightCull := self.data as *LightCullState;
		lightCull.UpdateBuildParams(scene, renderer);

		graph.AddPass(
			lightCullPassName,
			::bool(builder: *RenderPassBuilder<VulkanRenderer>, data: *LightCullState)
			{
				data.lightsHandle = builder.CreateBuffer(
					"lights",
					StorageBufferDesc((MaxLights * LightSize) as uint, HostVisibleMemory)
				);

				data.lightGridHandle = builder.CreateBuffer(
					"lightGrid",
					StorageBufferDesc((ClusterCount * LightGridSize) as uint, GPUMemoryFlags.GPU)
				);
				builder.Write(data.lightGridHandle, ResourceUsageFlags.StorageWrite);

				data.lightIndexHandle = builder.CreateBuffer(
					"lightIndexList",
					StorageBufferDesc((ClusterCount * MaxLightsPerCluster * uint32(4)) as uint, GPUMemoryFlags.GPU)
				);
				builder.Write(data.lightIndexHandle, ResourceUsageFlags.StorageWrite);

				data.counterHandle = builder.CreateBuffer(
					"lightCounter", StorageBufferDesc(uint(4), GPUMemoryFlags.GPU)
				);

				data.clusterInfoHandle = builder.CreateBuffer(
					"clusterInfo", StorageBufferDesc(ClusterInfoSize as uint, HostVisibleMemory)
				);

				return true;
			},
			::(context: *RenderPassContext<VulkanRenderer>, data: *LightCullState)
			{
				renderer := context.renderer;
				cmd := renderer.GetCommandBuffer(CommandBufferKind.Graphics);
				bindPoint := VkPipelineBindPoint.VK_PIPELINE_BIND_POINT_COMPUTE;
				groups := (ClusterCount + uint32(63)) / uint32(64);
				frame := renderer.Frame();

				resourceManager := vulkanInstance.resourceManager;
				cullFrame := data.cullFrames.frames[frame];

				clusterBuf := data.clusterBuffer.buffer;

				if (!data.built)
				{
					resourceManager.WriteStorageSetBuffer(data.buildSet, 0, clusterBuf);

					vkCmdBindPipeline(cmd, bindPoint, data.buildPipeline.pipeline);
					vkCmdBindDescriptorSets(
						cmd, bindPoint, data.buildPipeline.layout,
						uint32(0), uint32(1), data.buildSet@, uint32(0), null
					);
					vkCmdPushConstants(
						cmd, data.buildPipeline.layout,
						uint32(VkShaderStageFlagBits.VK_SHADER_STAGE_COMPUTE_BIT),
						0, #sizeof ClusterBuildParams, data.buildParams@
					);
					vkCmdDispatch(cmd, groups, uint32(1), uint32(1));

					ComputeBarrier(
						cmd,
						VkAccessFlagBits.VK_ACCESS_SHADER_WRITE_BIT,
						VkAccessFlagBits.VK_ACCESS_SHADER_READ_BIT,
						VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
						VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT
					);

					data.built = true;
				}

				lightsBuf := UseRenderPassBuffer<VulkanRenderer, VkBuffer_T>(context, data.lightsHandle, frame);
				gridBuf := UseRenderPassBuffer<VulkanRenderer, VkBuffer_T>(context, data.lightGridHandle, frame);
				indexBuf := UseRenderPassBuffer<VulkanRenderer, VkBuffer_T>(context, data.lightIndexHandle, frame);
				counterBuf := UseRenderPassBuffer<VulkanRenderer, VkBuffer_T>(context, data.counterHandle, frame);

				resourceManager.WriteStorageSetBuffer(cullFrame.cullSet, 0, clusterBuf);
				resourceManager.WriteStorageSetBuffer(cullFrame.cullSet, 1, lightsBuf);
				resourceManager.WriteStorageSetBuffer(cullFrame.cullSet, 2, gridBuf);
				resourceManager.WriteStorageSetBuffer(cullFrame.cullSet, 3, indexBuf);
				resourceManager.WriteStorageSetBuffer(cullFrame.cullSet, 4, counterBuf);

				vkCmdFillBuffer(cmd, counterBuf, 0, 4, 0);
				ComputeBarrier(
					cmd,
					VkAccessFlagBits.VK_ACCESS_TRANSFER_WRITE_BIT,
					VkAccessFlagBits.VK_ACCESS_SHADER_READ_BIT | VkAccessFlagBits.VK_ACCESS_SHADER_WRITE_BIT,
					VkPipelineStageFlagBits.VK_PIPELINE_STAGE_TRANSFER_BIT,
					VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT
				);

				vkCmdBindPipeline(cmd, bindPoint, data.cullPipeline.pipeline);
				vkCmdBindDescriptorSets(
					cmd, bindPoint, data.cullPipeline.layout,
					uint32(0), uint32(1), cullFrame.cullSet@, uint32(0), null
				);
				vkCmdPushConstants(
					cmd, data.cullPipeline.layout,
					uint32(VkShaderStageFlagBits.VK_SHADER_STAGE_COMPUTE_BIT),
					0, #sizeof ClusterCullParams, data.cullParams@
				);
				vkCmdDispatch(cmd, groups, uint32(1), uint32(1));

				ComputeBarrier(
					cmd,
					VkAccessFlagBits.VK_ACCESS_SHADER_WRITE_BIT,
					VkAccessFlagBits.VK_ACCESS_SHADER_READ_BIT,
					VkPipelineStageFlagBits.VK_PIPELINE_STAGE_COMPUTE_SHADER_BIT,
					VkPipelineStageFlagBits.VK_PIPELINE_STAGE_FRAGMENT_SHADER_BIT
				);
			},
			RenderPassStage.Compute,
			lightCull
		);

		lightsBuf := graph.handles.UseResource(lightCull.lightsHandle, renderer, frame).resource as *VkBuffer_T;
		lightCull.GatherLights(scene, lightsBuf);
		lightCull.UpdateCullParams(scene, renderer);

		clusterInfoBuf := graph.handles.UseResource(lightCull.clusterInfoHandle, renderer, frame).resource as *VkBuffer_T;
		lightCull.FillClusterInfo(scene, renderer, clusterInfoBuf);
	},
	::(renderer: VulkanRenderer, self: *VulkanRenderPass)
	{
		device := vulkanInstance.device;

		lightCull := new LightCullState();
		lightCull.buildPipeline = FindOrCreateComputePipeline("ClusterBuild", clusterBuildSource);
		lightCull.cullPipeline = FindOrCreateComputePipeline("ClusterCull", clusterCullSource);
		lightCull.clusterBuffer = CreateDeviceStorageBuffer(
			(ClusterCount * ClusterAABBSize) as uint32
		);

		buildPoolSize := VkDescriptorPoolSize();
		buildPoolSize.type = VkDescriptorType.VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
		buildPoolSize.descriptorCount = 1;

		buildPoolInfo := VkDescriptorPoolCreateInfo();
		buildPoolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
		buildPoolInfo.poolSizeCount = 1;
		buildPoolInfo.pPoolSizes = buildPoolSize@;
		buildPoolInfo.maxSets = 1;

		CheckResult(
			vkCreateDescriptorPool(device, buildPoolInfo@, null, lightCull.buildPool@),
			"LightCullPass Error creating build descriptor pool"
		);

		buildAllocInfo := VkDescriptorSetAllocateInfo();
		buildAllocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
		buildAllocInfo.descriptorPool = lightCull.buildPool;
		buildAllocInfo.descriptorSetCount = 1;
		buildAllocInfo.pSetLayouts = lightCull.buildPipeline.descSetLayouts[0]@;

		CheckResult(
			vkAllocateDescriptorSets(device, buildAllocInfo@, lightCull.buildSet@),
			"LightCullPass Error allocating build descriptor set"
		);

		cullPoolSize := VkDescriptorPoolSize();
		cullPoolSize.type = VkDescriptorType.VK_DESCRIPTOR_TYPE_STORAGE_BUFFER;
		cullPoolSize.descriptorCount = 5 * FrameCount;

		cullPoolInfo := VkDescriptorPoolCreateInfo();
		cullPoolInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_POOL_CREATE_INFO;
		cullPoolInfo.poolSizeCount = 1;
		cullPoolInfo.pPoolSizes = cullPoolSize@;
		cullPoolInfo.maxSets = FrameCount;

		CheckResult(
			vkCreateDescriptorPool(device, cullPoolInfo@, null, lightCull.cullPool@),
			"LightCullPass Error creating cull descriptor pool"
		);

		for (i .. FrameCount)
		{
			lightCull.cullFrames.frames[i] = LightCullFrame();
			cullAllocInfo := VkDescriptorSetAllocateInfo();
			cullAllocInfo.sType = VkStructureType.VK_STRUCTURE_TYPE_DESCRIPTOR_SET_ALLOCATE_INFO;
			cullAllocInfo.descriptorPool = lightCull.cullPool;
			cullAllocInfo.descriptorSetCount = 1;
			cullAllocInfo.pSetLayouts = lightCull.cullPipeline.descSetLayouts[0]@;

			CheckResult(
				vkAllocateDescriptorSets(device, cullAllocInfo@, lightCull.cullFrames.frames[i].cullSet@),
				"LightCullPass Error allocating cull descriptor set"
			);
		}

		self.data = lightCull;
	},
	::(renderer: VulkanRenderer, self: *VulkanRenderPass)
	{
		lightCull := self.data as *LightCullState;
		vkDestroyDescriptorPool(vulkanInstance.device, lightCull.buildPool, null);
		vkDestroyDescriptorPool(vulkanInstance.device, lightCull.cullPool, null);
		vkDestroyBuffer(vulkanInstance.device, lightCull.clusterBuffer.buffer, null);
		delete lightCull;
	},
	::(renderer: VulkanRenderer, self: *VulkanRenderPass)
	{
		lightCull := self.data as *LightCullState;
		lightCull.built = false;
	}
);
