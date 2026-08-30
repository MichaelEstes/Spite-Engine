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

state SceneSystem { scene: *Scene, system: System }
SceneSystem::(scene: *Scene, system: System)
{
	this.scene = scene;
	this.system = system;
}

Component RegisterComponent<Type>(componentKind: ComponentKind = ComponentKind.Sparse,
								  onRemove: ::(Entity, *Type, Scene) = null, 
								  onEnter: ::(Entity, *Type, Scene) = null) 
{
	return instance.RegisterComponent<Type>(componentKind, onRemove, onEnter);
}

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

OnSceneCreated(callback: ::(*Scene, *any), data: *any = null)
{
	ECS.instance.events.On(
		SceneCreatedEvent, 
		callback,
		data
	);
}

OnSceneRemoved(callback: ::(*Scene, *any), data: *any = null)
{
	ECS.instance.events.On(
		SceneRemovedEvent, 
		callback,
		data
	);
}

state ECS
{
	frameAllocator := FrameAllocator(),
	scenes := SparseSet<Scene>(),
	systems := Systems(),

	componentTypeMap := Map<*_Type, Component>(),
	componentIDSet := SparseSet<Component>(),
	componentTypeSet := SparseSet<*_Type>(),
	tagComponentNameMap := Map<string, TagComponent>(),
	tagComponentSerializeMap := SparseSet<string>(),
	
	componentRemoveCallbacks := SparseSet<::(Entity, *any, Scene)>(),
	componentEnterCallbacks := SparseSet<::(Entity, *any, Scene)>(),
	tagComponentRemoveCallbacks := SparseSet<::(Entity, Scene)>(),
	tagComponentEnterCallbacks := SparseSet<::(Entity, Scene)>(),

	recycledScenes := Stack<uint16>(),
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

	// log "Registering Component: ", type.StateName(), (type as *void);
	
	defaultCallBack := ::(entity: Entity, comp: *Type, scene: Scene) {};
	if (!onRemove) onRemove = defaultCallBack;
	if (!onEnter) onEnter = defaultCallBack;


	component := { this.componentCount, componentKind, uint32(#sizeof Type) } as Component;
	this.componentTypeMap.Insert(type, component);
	this.componentIDSet.Insert(component.id, component);
	this.componentTypeSet.Insert(component.id, type);
	this.componentRemoveCallbacks.Insert(component.id, onRemove);
	this.componentEnterCallbacks.Insert(component.id, onEnter);
	this.componentCount += 1;
	return component;
}

TagComponent ECS::RegisterTagComponent(serializeName: string
									   componentKind: ComponentKind = ComponentKind.Sparse,
									   onRemove: ::(Entity, Scene) = null, 
									   onEnter: ::(Entity, Scene) = null)
{
	assert !this.tagComponentNameMap.Has(serializeName), "Tag component names must be unique";

	defaultCallBack := ::(entity: Entity, scene: Scene) {};
	if (!onRemove) onRemove = defaultCallBack;
	if (!onEnter) onEnter = defaultCallBack;

	tagComponent := { this.tagComponentCount, componentKind } as TagComponent;
	this.tagComponentNameMap.Insert(serializeName, tagComponent);
	this.tagComponentSerializeMap.Insert(tagComponent.id, serializeName);
	this.tagComponentRemoveCallbacks.Insert(tagComponent.id, onRemove);
	this.tagComponentEnterCallbacks.Insert(tagComponent.id, onEnter);
	this.tagComponentCount += 1;
	return tagComponent;
}

SystemID ECS::RegisterSystem(run: ::(Scene, float), step: SystemStep = SystemStep.Frame)
{	
	assert run != null, "Cannot register null systems";

	system := System();
	system.run = run;
	data := this.AddSystem(system, step);
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

*Scene ECS::GetScene(sceneID: uint16) => this.scenes.Get(sceneID);

ECS::RemoveScene(sceneID: uint16)
{
	scene := this.GetScene(sceneID);
	this.events.Emit<*Scene>(SceneRemovedEvent, scene);
	delete scene~;
	this.scenes.Remove(sceneID);
	this.recycledScenes.Push(sceneID);
}

Entity ECS::CreateEntity(sceneID: uint16) => this.GetScene(sceneID).CreateEntity();

Component ECS::GetComponent<Type>()
{
	type := #typeof Type;

	componentPtr := this.componentTypeMap[type];
	assert !!componentPtr, "No component found for type, component is not registered";
	return componentPtr~;
}

Component ECS::GetComponentByID(id: uint32)
{
	return this.componentIDSet.Get(id)~;
}

ECS::OnComponentRemove(id: uint32, entity: Entity, componentData: *any, scene: Scene)
{
	callback := this.componentRemoveCallbacks.Get(id)~;
	callback(entity, componentData, scene);
}

ECS::OnComponentEnter(id: uint32, entity: Entity, componentData: *any, scene: Scene)
{
	callback := this.componentEnterCallbacks.Get(id)~;
	callback(entity, componentData, scene);
}

ECS::OnTagComponentRemove(id: uint32, entity: Entity, scene: Scene)
{
	callback := this.tagComponentRemoveCallbacks.Get(id)~;
	callback(entity, scene);
}

ECS::OnTagComponentEnter(id: uint32, entity: Entity, scene: Scene)
{
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
			sceneSystem := instance.frameAllocator.AllocType<SceneSystem>();
			sceneSystem~ = SceneSystem(scene@, system);
			Fiber.AddJob(::(data: *SceneSystem) {
				scene := data.scene;
				system := data.system;
				dt := instance.dt;
				
				system.run(scene~, dt);
			}, sceneSystem, handle@);
		}
	}

	Fiber.FlushMainThreadJobs();
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
