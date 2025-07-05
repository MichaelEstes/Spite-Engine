package System

import Scene
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

state System
{
	run: ::(Scene, float)
}

state Systems
{
	onFixed: Array<System>,
	onPreFrame: Array<System>,
	onFrame: Array<System>,
	onPreDraw: Array<System>,
	onDraw: Array<System>,
	onPostFrame: Array<System>,
	
	onStart: Array<System>,
	onStop: Array<System>
}