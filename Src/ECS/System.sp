package System

import Scene
import Array

enum SystemStep: byte
{
	OnFixed,
	OnEarlyFrame,
	OnFrame,
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
	onPostFrame: Array<System>,
	
	onStart: Array<System>,
	onStop: Array<System>
}