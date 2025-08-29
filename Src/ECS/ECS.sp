package ECS

import SparseSet
import Time
import Stack
import RingBuffer
import Fiber
import Atomic
import FrameAllocator
import Event

instance: ECS = ECS();

SceneCreatedEvent := RegisterEvent<*Scene>();
SceneRemovedEvent := RegisterEvent<*Scene>();

enum ComponentKind: uint32
{
	Common,
	Sparse,
	Singleton
}

state Component
{
	id: uint32,
	kind: ComponentKind,
	size: uint32
}

state SceneSystem { scene: *Scene, system: *System, time: float64 }

Component RegisterComponent<Type>(componentKind: ComponentKind = ComponentKind.Sparse,
								  onRemove: ::(Entity, *Type, Scene) = null, 
								  onEnter: ::(Entity, *Type, Scene) = null)
			=> instance.RegisterComponent<Type>(componentKind, onRemove, onEnter);

{id: uint32, step: SystemStep} RegisterSystem(run: ::(Scene, float), step: SystemStep = SystemStep.Frame)
			=> instance.RegisterSystem(run, step);

{id: uint32, step: FrameSystemStep} RegisterFrameSystem(run: ::(float), step: FrameSystemStep)
			=> instance.RegisterFrameSystem(run, step);

*void FrameAlloc<Type>(size: uint32) => instance.frameAllocator.Alloc(size);
*Type FrameAllocType<Type>() => instance.frameAllocator.AllocType<Type>();

ArrayView<Scene> Scenes() => instance.scenes.Values();

OnSceneCreated(callback: ::(*Scene))
{
	ECS.instance.events.On(
		SceneCreatedEvent, 
		callback
	);
}

OnSceneRemoved(callback: ::(*Scene))
{
	ECS.instance.events.On(
		SceneRemovedEvent, 
		callback
	);
}

state ECS
{
	frameAllocator := FrameAllocator(),
	scenes := SparseSet<Scene>(),
	systems: Systems,
	componentTypeMap := Map<*_Type, Component>(),
	componentIDMap := SparseSet<Component>(),
	componentRemoveCallbacks := SparseSet<::(Entity, *any, Scene)>(),
	componentEnterCallbacks := SparseSet<::(Entity, *any, Scene)>(),
	recycledScenes := Stack<uint16>(),
	systemBuffer := RingBuffer<SceneSystem>(),
	events := Event.Emitter(),
	frameCount: uint,
	lastFrameTime: float,
	componentCount: uint32,
	sceneCount: uint16
}

Component ECS::RegisterComponent<Type>(componentKind: ComponentKind = ComponentKind.Sparse,
									   onRemove: ::(Entity, *Type, Scene) = null, 
									   onEnter: ::(Entity, *Type, Scene) = null)
{
	type := #typeof Type;
	assert !this.componentTypeMap.Has(type), "Cannot register a component twice";

	component := { this.componentCount, componentKind, uint32(#sizeof Type) } as Component;
	this.componentTypeMap.Insert(type, component);
	this.componentIDMap.Insert(component.id, component);
	if (onRemove) this.componentRemoveCallbacks.Insert(component.id, onRemove);
	if (onEnter) this.componentEnterCallbacks.Insert(component.id, onEnter);
	this.componentCount += 1;
	return component;
}

{id: uint, step: SystemStep} ECS::RegisterSystem(run: ::(Scene, float), step: SystemStep = SystemStep.Frame)
{	
	assert run != null, "Cannot register null systems";

	system := {run} as System;
	data := this.AddSystem(system, step);
	this.ExpandSystemBuffer(data.id);
	return data;
}

{id: uint32, step: FrameSystemStep} ECS::RegisterFrameSystem(run: ::(float), step: FrameSystemStep)
{	
	assert run != null, "Cannot register null frame systems";

	system := {run} as FrameSystem;
	id := uint32(0);

	switch (step)
	{
		case (FrameSystemStep.Start) id = this.systems.frameStart.Add(system);
		case (FrameSystemStep.End) id = this.systems.frameEnd.Add(system);
		default log "Invalid step for frame system";
	}
	
	this.ExpandSystemBuffer(id);
	return {id, step};
}

{id: uint32, step: SystemStep} ECS::AddSystem(system: System, step: SystemStep)
{
	switch (step)
	{
		case (SystemStep.Fixed) return { this.systems.onFixed.Add(system), step };
		case (SystemStep.PreFrame) return { this.systems.onPreFrame.Add(system), step };
		case (SystemStep.Frame) return { this.systems.onFrame.Add(system), step };
		case (SystemStep.PostFrame) return { this.systems.onPostFrame.Add(system), step };
		case (SystemStep.PreDraw) return { this.systems.onPreDraw.Add(system), step };
		case (SystemStep.Draw) return { this.systems.onDraw.Add(system), step };
		case (SystemStep.Start) return { this.systems.onStart.Add(system), step };
		case (SystemStep.Stop) return { this.systems.onStop.Add(system), step };
		default log "Invalid step for system";
	}

	return { uint32(0), step };
}

ECS::ExpandSystemBuffer(count: uint32)
{
	// Make sure systemBuffer is always large enough to hold the largest array of systems
	this.systemBuffer.Expand(count);
}

*Scene ECS::CreateScene()
{
	sceneID := this.sceneCount;

	if (this.recycledScenes.count) sceneID = this.recycledScenes.Pop();
	else this.sceneCount += 1;

	this.scenes.Insert(sceneID, Scene(sceneID));
	scene := this.GetScene(sceneID);
	this.events.Emit<*Scene>(SceneCreatedEvent, scene);
	return scene;
}

*Scene ECS::GetScene(id: uint16) => this.scenes.Get(id);

ECS::RemoveScene(id: uint16)
{
	scene := this.GetScene(id);
	this.events.Emit<*Scene>(SceneRemovedEvent, scene);
	delete scene~;
	this.scenes.Remove(id);
	this.recycledScenes.Push(id);
}

Entity ECS::CreateEntity(sceneID: uint) => this.GetScene(sceneID).CreateEntity();

Component ECS::GetComponent<Type>()
{
	type := #typeof Type;
	componentPtr := this.componentTypeMap[type];
	assert !!componentPtr, "No component found for type, component is not registered";
	return componentPtr~;
}

Component ECS::GetComponentByID(id: uint32)
{
	return this.componentIDMap.Get(id)~;
}

ECS::OnComponentRemove(id: uint32, entity: Entity, componentData: *any, scene: Scene)
{
	if (!this.componentRemoveCallbacks.Has(id)) return;

	callback := this.componentRemoveCallbacks.Get(id)~;
	callback(entity, componentData, scene);
}

ECS::OnComponentEnter(id: uint32, entity: Entity, componentData: *any, scene: Scene)
{
	if (!this.componentEnterCallbacks.Has(id)) return;

	callback := this.componentEnterCallbacks.Get(id)~;
	callback(entity, componentData, scene);
}

ECS::RunSystems(systems: Array<System>)
{
	count := this.scenes.count * systems.count
	if (!count) return;

	time := Time.SecondsSinceStart();
	dt := time - instance.lastFrameTime;
	handle: *Fiber.JobHandle = null;
	for (scene in this.scenes.Values())
	{
		for (system in systems) 
		{
			sceneSystem := instance.systemBuffer.Insert({scene@, system@, dt} as SceneSystem);
			Fiber.AddJob(::(data: *SceneSystem) {
				scene := data.scene;
				system := data.system;
				dt := data.time;
				
				system.run(scene~, dt);
			}, sceneSystem, handle@, Fiber.JobPriority.High);
		}
	}

	Fiber.FlushMainThreadJobs();
	Fiber.WaitForHandle(handle);
}

ECS::RunFrameSystems(systems: Array<FrameSystem>)
{
	if (!systems.count) return;

	time := Time.SecondsSinceStart();
	dt := time - instance.lastFrameTime;
	handle: *Fiber.JobHandle = null;
	for (system in systems) 
	{
		sceneSystem := instance.systemBuffer.Insert({null, system@, dt} as SceneSystem);
		Fiber.AddJob(::(data: *SceneSystem) {
			system := data.system;
			dt := data.time;
			
			(system~ as FrameSystem).run(dt);
		}, sceneSystem, handle@, Fiber.JobPriority.High);
	}

	Fiber.FlushMainThreadJobs();
	Fiber.WaitForHandle(handle);
}

ECS::Start()
{
	this.RunSystems(this.systems.onStart);
}

ECS::Stop()
{
	this.RunSystems(this.systems.onStop);
}

ECS::PreFrame()
{
	this.RunFrameSystems(this.systems.frameStart);
	this.RunSystems(this.systems.onPreFrame);
}

ECS::Frame()
{
	this.RunSystems(this.systems.onFrame);
}

ECS::PreDraw()
{
	this.RunSystems(this.systems.onPreDraw);
}

ECS::Draw()
{
	this.RunSystems(this.systems.onDraw);
}

ECS::PostFrame()
{
	this.RunSystems(this.systems.onPostFrame);
	this.RunFrameSystems(this.systems.frameEnd);

	this.lastFrameTime = Time.SecondsSinceStart();
	this.frameAllocator.Clear();
	this.frameCount += 1;
}
