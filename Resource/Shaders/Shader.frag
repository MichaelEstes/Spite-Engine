#version 450
#pragma shader_stage(fragment)

layout(set = 2, binding = 0) uniform sampler2D colorTexture;

layout(location = 0) in vec4 color;
layout(location = 1) in vec2 uv0;

layout(location = 0) out vec4 outColor;

void main() 
{
    outColor = texture(colorTexture, uv0) * color;
}