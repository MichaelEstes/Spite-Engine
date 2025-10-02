#version 450
#pragma shader_stage(vertex)

layout(binding = 0) uniform SceneData 
{
    mat4 view;
    mat4 proj;
} scene;

layout(binding = 1) uniform ModelData 
{
    mat4 model;
} scene;

layout(location = 0) in vec3 inPosition;
//layout(location = 1) in vec3 inColor;
//layout(location = 2) in vec2 inTexCoord;

layout(location = 0) out vec3 fragColor;
//layout(location = 1) out vec2 fragTexCoord;

void main() 
{
    gl_Position = scene.proj * scene.view * scene.model * vec4(inPosition, 1.0);
    fragColor = vec3(1.0, 0.0, 0.0);
    //fragColor = inColor;
    //fragTexCoord = inTexCoord;
}