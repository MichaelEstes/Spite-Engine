package System

import Scene
import Array

enum SystemStep: byte
{
	OnFixed,
	OnEarlyFrame,
	OnFrame,
	OnDraw,
	OnPostFrame,
	
	OnStart,
	OnStop
}

state System
{
	run: ::(Scene, float)
}

state Systems
{
	onFixed: Array<System>,
	onEarlyFrame: Array<System>,
	onFrame: Array<System>,
	onDraw: Array<System>,
	onPostFrame: Array<System>,
	
	onStart: Array<System>,
	onStop: Array<System>
}