package SceneDescription

import ECS

enum WindowFlags: uint
{
	None = 0
	Fullscreen = 1
}

state WindowDesc
{
	flags: WindowFlags,
	width: uint32,
	height: uint32
}

enum RendererFlags: uint
{
	SDL = 0,
	Vulkan = 1
}

state RendererDesc
{
	passes: Array<string>
	flags: RendererFlags
}

state SceneDesc
{
	window: WindowDesc,
	renderer: RendererDesc
}

SceneDescComponent := ECS.instance.RegisterComponent<SceneDesc>(
	ComponentKind.Singleton, 
	::(sceneDesc: *SceneDesc) {
		
	}
);