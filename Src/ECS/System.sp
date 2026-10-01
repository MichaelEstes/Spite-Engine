package ECS

import Array
import HandleSet

enum SystemRelation: ubyte
{
	Before,
	After,
	None
}

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
	before: Array<*System>,
	run: ::(Scene, float),
	after: Array<*System>
}

state FrameSystem
{
	before: Array<*FrameSystem>,
	run: ::(float),
	after: Array<*FrameSystem>
}

state Systems
{
	onFixed: Array<*System>,
	onPreFrame: Array<*System>,
	onFrame: Array<*System>,
	onPreDraw: Array<*System>,
	onDraw: Array<*System>,
	onPostFrame: Array<*System>,

	frameStart: Array<*FrameSystem>,
	frameEnd: Array<*FrameSystem>,
	
	onStart: Array<*System>,
	onStop: Array<*System>
}

*System Systems::AddSystem(system: System, step: SystemStep, relationTo: *System, relation: SystemRelation)
{
	stepSystems: *Array<*System> = null;
	switch (step)
	{
		case (SystemStep.Fixed) stepSystems = this.onFixed@;
		case (SystemStep.PreFrame) stepSystems = this.onPreFrame@;
		case (SystemStep.Frame) stepSystems = this.onFrame@;
		case (SystemStep.PostFrame) stepSystems = this.onPostFrame@;
		case (SystemStep.PreDraw) stepSystems = this.onPreDraw@;
		case (SystemStep.Draw) stepSystems = this.onDraw@;
		case (SystemStep.Start) stepSystems = this.onStart@;
		case (SystemStep.Stop) stepSystems = this.onStop@;
		default log "ECS::AddSystem Invalid step for system";
	}

	if (!stepSystems) return null;

	return InsertSystem<System>(system, stepSystems, relationTo, relation);
}

*FrameSystem Systems::AddFrameSystem(system: FrameSystem, step: FrameSystemStep, relationTo: *FrameSystem, relation: SystemRelation)
{
	stepSystems: *Array<*FrameSystem> = null;
	switch (step)
	{
		case (FrameSystemStep.Start) stepSystems = this.frameStart@;
		case (FrameSystemStep.End) stepSystems = this.frameEnd@;
		default log "Systems::AddFrameSystem Invalid step for frame system";
	}

	if (!stepSystems) return null;

	return InsertSystem<FrameSystem>(system, stepSystems, relationTo, relation);
}

*SystemType InsertSystem<SystemType>(system: SystemType, stepSystems: *Array<*SystemType>, relationTo: *SystemType, relation: SystemRelation)
{
	systemRef := new SystemType();
	systemRef~ = system;

	if (!relationTo || relation == SystemRelation.None) stepSystems.Add(systemRef);
	else if (relation == SystemRelation.Before) relationTo.before.Add(systemRef);
	else relationTo.after.Add(systemRef);

	return systemRef;
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