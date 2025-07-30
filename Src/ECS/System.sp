package ECS

import Array

enum SystemStep: byte
{
	Fixed,
	PreFrame,
	Frame,
	PreDraw
	Draw,
	PostFrame,
	
	Start,
	Stop
}

enum FrameSystemStep: byte
{
	Start,
	End
}

state System
{
	run: ::(Scene, float)
}

state FrameSystem
{
	run: ::(float)
}

state Systems
{
	onFixed: Array<System>,
	onPreFrame: Array<System>,
	onFrame: Array<System>,
	onPreDraw: Array<System>,
	onDraw: Array<System>,
	onPostFrame: Array<System>,

	frameStart: Array<FrameSystem>,
	frameEnd: Array<FrameSystem>,
	
	onStart: Array<System>,
	onStop: Array<System>
}