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
	Common = 0,
	Sparse = 1,
	Singleton = 2
}

state Component
{
	id: uint32,
	kind: ComponentKind,
	size: uint32
}

state TagComponent
{
	id: uint32,
	kind: ComponentKind
}

state SceneSystem { scene: *Scene, system: *System }

Component RegisterComponent<Type>(componentKind: ComponentKind = ComponentKind.Sparse,
								  onRemove: ::(Entity, *Type, Scene) = null, 
								  onEnter: ::(Entity, *Type, Scene) = null)
			=> instance.RegisterComponent<Type>(componentKind, onRemove, onEnter);

TagComponent RegisterTagComponent(serializeName: string
								  componentKind: ComponentKind = ComponentKind.Sparse,
								  onRemove: ::(Entity, Scene) = null, 
								  onEnter: ::(Entity, Scene) = null)
			=> instance.RegisterTagComponent(serializeName, componentKind, onRemove, onEnter);

SystemID RegisterSystem(run: ::(Scene, float), step: SystemStep = SystemStep.Frame)
			=> instance.RegisterSystem(run, step);

FrameSystemID RegisterFrameSystem(run: ::(float), step: FrameSystemStep)
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
	systems := Systems(),

	componentTypeMap := Map<*_Type, Component>(),
	componentIDMap := SparseSet<Component>(),
	tagComponentNameMap := Map<string, TagComponent>(),
	tagComponentSerializeMap := SparseSet<string>(),
	
	componentRemoveCallbacks := SparseSet<::(Entity, *any, Scene)>(),
	componentEnterCallbacks := SparseSet<::(Entity, *any, Scene)>(),
	tagComponentRemoveCallbacks := SparseSet<::(Entity, Scene)>(),
	tagComponentEnterCallbacks := SparseSet<::(Entity, Scene)>(),

	recycledScenes := Stack<uint16>(),
	systemBuffer := RingBuffer<SceneSystem>(),
	events := Event.Emitter(),
	frameCount: uint,
	lastFrameTime: float,
	dt: float,
	componentCount: uint32,
	tagComponentCount: uint32,
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

TagComponent ECS::RegisterTagComponent(serializeName: string
									   componentKind: ComponentKind = ComponentKind.Sparse,
									   onRemove: ::(Entity, Scene) = null, 
									   onEnter: ::(Entity, Scene) = null)
{
	assert !this.tagComponentNameMap.Has(serializeName), "Tag component names must be unique";

	tagComponent := { this.tagComponentCount, componentKind } as TagComponent;
	this.tagComponentNameMap.Insert(serializeName, tagComponent);
	this.tagComponentSerializeMap.Insert(tagComponent.id, serializeName);
	if (onRemove) this.tagComponentRemoveCallbacks.Insert(tagComponent.id, onRemove);
	if (onEnter) this.tagComponentEnterCallbacks.Insert(tagComponent.id, onEnter);
	this.tagComponentCount += 1;
	return tagComponent;
}

SystemID ECS::RegisterSystem(run: ::(Scene, float), step: SystemStep = SystemStep.Frame)
{	
	assert run != null, "Cannot register null systems";

	system := {run} as System;
	data := this.AddSystem(system, step);
	this.ExpandSystemBuffer(this.systems.GetSystemCountForStep(step));
	return data;
}

FrameSystemID ECS::RegisterFrameSystem(run: ::(float), step: FrameSystemStep)
{	
	assert run != null, "Cannot register null frame systems";

	system := {run} as FrameSystem;
	id := uint32(0);

	switch (step)
	{
		case (FrameSystemStep.Start) id = this.systems.frameStart.Add(system);
		case (FrameSystemStep.End) id = this.systems.frameEnd.Add(system);
		default log "ECS::RegisterFrameSystem Invalid step for frame system";
	}
	
	this.ExpandSystemBuffer(id);
	return { id, step };
}

SystemID ECS::AddSystem(system: System, step: SystemStep)
{
	id := uint32(0);
	
	switch (step)
	{
		case (SystemStep.Fixed) id = this.systems.onFixed.Add(system);
		case (SystemStep.PreFrame) id = this.systems.onPreFrame.Add(system);
		case (SystemStep.Frame) id = this.systems.onFrame.Add(system);
		case (SystemStep.PostFrame) id = this.systems.onPostFrame.Add(system);
		case (SystemStep.PreDraw) id = this.systems.onPreDraw.Add(system);
		case (SystemStep.Draw) id = this.systems.onDraw.Add(system);
		case (SystemStep.Start) id = this.systems.onStart.Add(system);
		case (SystemStep.Stop) id = this.systems.onStop.Add(system);
		default log "ECS::AddSystem Invalid step for system";
	}

	return { id, step };
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

ECS::OnTagComponentRemove(id: uint32, entity: Entity, scene: Scene)
{
	if (!this.tagComponentRemoveCallbacks.Has(id)) return;

	callback := this.tagComponentRemoveCallbacks.Get(id)~;
	callback(entity, scene);
}

ECS::OnTagComponentEnter(id: uint32, entity: Entity, scene: Scene)
{
	if (!this.tagComponentEnterCallbacks.Has(id)) return;

	callback := this.tagComponentEnterCallbacks.Get(id)~;
	callback(entity, scene);
}

ECS::RunSystems(systems: Array<System>)
{
	count := this.scenes.count * systems.count;
	if (!count) return;

	handle: *Fiber.JobHandle = null;
	for (scene in this.scenes.Values())
	{
		for (system in systems) 
		{
			sceneSystem := instance.systemBuffer.Insert({scene@, system@} as SceneSystem);
			Fiber.AddJob(::(data: *SceneSystem) {
				scene := data.scene;
				system := data.system;
				dt := instance.dt;
				
				system.run(scene~, dt);
			}, sceneSystem, handle@);
		}
	}

	Fiber.WaitForHandle(handle);
}

ECS::RunFrameSystems(systems: Array<FrameSystem>)
{
	if (!systems.count) return;

	handle: *Fiber.JobHandle = null;
	for (system in systems) 
	{
		Fiber.AddJob(::(system: *void) {
			func := system as ::(float);
			dt := instance.dt;
			
			func(dt);
		}, system.run as *void, handle@);
	}

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
	time := Time.SecondsSinceStart();
	this.dt = time - this.lastFrameTime;
	this.lastFrameTime = time;

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

	this.frameAllocator.Clear();
	this.frameCount += 1;
}
