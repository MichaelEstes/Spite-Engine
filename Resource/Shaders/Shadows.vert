#version 450
layout(location = 0) in vec3 inPosition;

layout(set = 0, binding = 0) uniform ShadowVP {
    mat4 lightViewProj;
} ubo;

void main() {
    gl_Position = ubo.lightViewProj * vec4(inPosition, 1.0);
}