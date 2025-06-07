echo $VULKAN_SDK
$VULKAN_SDK/bin/glslc Shadows.vert -o Compiled/shadows.spv
$VULKAN_SDK/bin/glslc Shader.vert -o Compiled/vert.spv
$VULKAN_SDK/bin/glslc Shader.frag -o Compiled/frag.spv
