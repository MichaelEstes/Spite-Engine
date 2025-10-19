#version 450
#pragma shader_stage(fragment)

layout(set = 1, binding = 0) uniform MaterialUBO 
{
    vec4 baseColor;
	vec3 emissiveFactor;

	float normalScale;
	float metallicFactor;
	float roughnessFactor;
	float occlusionStrength;
	float alphaCutoff;
} material;

layout(set = 2, binding = 0) uniform sampler2D colorTexture;

layout(location = 0) in vec4 color;
layout(location = 1) in vec2 uv0;

layout(location = 0) out vec4 outColor;

void main() 
{
	outColor = material.baseColor;
    //outColor = color * material.baseColor * texture(colorTexture, uv0);
}