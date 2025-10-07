#version 450
#pragma shader_stage(vertex)

layout(set = 0, binding = 0) uniform SceneUBO 
{
    mat4 view;
    mat4 proj;
} scene;

layout(set = 1, binding = 0) uniform ModelUBO 
{
    mat4 model;
} model;

layout(location = 0) in vec3 position;
layout(location = 1) in vec3 normal;
layout(location = 2) in vec4 tangents;
layout(location = 3) in vec4 color;
layout(location = 4) in vec2 uv0;
layout(location = 5) in vec2 uv1;
layout(location = 6) in vec2 uv2;
layout(location = 7) in vec2 uv3;

layout(location = 0) out vec4 outColor;
layout(location = 1) out vec2 outUv0;

void main() 
{
    gl_Position = scene.proj * scene.view * model.model * vec4(position, 1.0);

    outColor = color;
    outUv0 = uv0;
}
