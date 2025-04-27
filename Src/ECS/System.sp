package System

import Scene

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
	onFixed: []System,
	onEarlyFrame: []System,
	onFrame: []System,
	onPostFrame: []System,
	
	onStart: []System,
	onStop: []System
}