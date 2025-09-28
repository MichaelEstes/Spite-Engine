package Shaders

import Array

state ShaderHandle
{
	handle: uint32
}

registeredShaders := Array<RegisteredShader>();

state RegisteredShader
{
	file: string

}

uint32 RegisterShader(file: string)
{

	return 0;
}

DefaultVertShader := "./Resource/Shaders/Compiled/vert.spv";
DefaultFragShader := "./Resource/Shaders/Compiled/frag.spv";