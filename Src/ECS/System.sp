package ECS

import Array
import SparseSet

enum SystemStep: uint16
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

enum FrameSystemStep: uint16
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

state SystemID
{
	id: uint32,
	step: SystemStep
}

state FrameSystemID
{
	id: uint32, 
	step: FrameSystemStep
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

uint32 Systems::GetSystemCountForStep(step: SystemStep)
{
	count: uint32 = 0;

	switch (step)
	{
		case (SystemStep.Fixed) count += this.onFixed.count;
		case (SystemStep.PreFrame) count += this.onPreFrame.count;
		case (SystemStep.Frame) count += this.onFrame.count;
		case (SystemStep.PostFrame) count += this.onPostFrame.count;
		case (SystemStep.PreDraw) count += this.onPreDraw.count;
		case (SystemStep.Draw) count += this.onDraw.count;
		case (SystemStep.Start) count += this.onStart.count;
		case (SystemStep.Stop) count += this.onStop.count;
		default log "Systems::GetSystemCountForStep Invalid step for system";
	}

	return count;
}