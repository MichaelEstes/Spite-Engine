echo $VULKAN_SDK
$VULKAN_SDK/bin/glslc Shader.vert -o vert.spv
$VULKAN_SDK/bin/glslc Shader.frag -o frag.spv
