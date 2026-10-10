package ECS

import SparseSet
import Time
import Stack
import RingBuffer
import Fiber
import Atomic
import Event
import Math

import Tracy

fixedUpdateRate: float = 1.0 / 60.0;

instance: ECS = ECS();

scenePostFrameZone: Tracy.SourceLocationData = Tracy.SourceLocationData("Scene PostFrame"[0], "ECS::PostFrame"[0], "Src/ECS/ECS.sp"[0], 430, 0);
systemZone: Tracy.SourceLocationData = Tracy.SourceLocationData("System"[0], "RunSystem"[0], "Src/ECS/ECS.sp"[0], 299, 0);
frameSystemZone: Tracy.SourceLocationData = Tracy.SourceLocationData("Frame System"[0], "RunFrameSystem"[0], "Src/ECS/ECS.sp"[0], 328, 0);

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
}

state SceneSystem { scene: *Scene, system: *System, dt: float, handle: **Fiber.JobHandle }
SceneSystem::(scene: *Scene, system: *System, dt: float, handle: **Fiber.JobHandle)
{
	this.scene = scene;
	this.system = system;
	this.dt = dt;
	this.handle = handle;
}

state FrameSystemJob { system: *FrameSystem, handle: **Fiber.JobHandle }
FrameSystemJob::(system: *FrameSystem, handle: **Fiber.JobHandle)
{
	this.system = system;
	this.handle = handle;
}

Component RegisterComponent<Type>(componentKind: ComponentKind = ComponentKind.Sparse,
								  onRemove: ::(Entity, *Type, Scene) = null, 
								  onEnter: ::(Entity, *Type, Scene) = null) 
			=> instance.RegisterComponent<Type>(componentKind, onRemove, onEnter);

TagComponent RegisterTagComponent(serializeName: string
								  onRemove: ::(Entity, Scene) = null, 
								  onEnter: ::(Entity, Scene) = null)
			=> instance.RegisterTagComponent(serializeName, onRemove, onEnter);

*System RegisterSystem(run: ::(Scene, float), 
					   step: SystemStep = SystemStep.Frame,
					   relation: SystemRelation = SystemRelation.Before,
					   relationTo: *System = null)
			=> instance.RegisterSystem(run, step, relation, relationTo);

*FrameSystem RegisterFrameSystem(run: ::(float), 
								 step: FrameSystemStep,
								 relation: SystemRelation = SystemRelation.Before,
								 relationTo: *FrameSystem = null)
			=> instance.RegisterFrameSystem(run, step, relation, relationTo);

*void FrameAlloc<Type>(size: uint32)
{
	alloc := Fiber.GetFrameAllocator();
	return alloc.Alloc(size);
}

*Type FrameAllocType<Type>()
{
	alloc := Fiber.GetFrameAllocator();
	return alloc.AllocType<Type>();
}

Array<Type, InvalidResizeFunc> FrameAllocArray<Type>(count: uint32)
{
	alloc := Fiber.GetFrameAllocator();
	return alloc.AllocArray<Type>(count);
}

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
	fixedAccum: float,

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
									   onRemove: ::(Entity, Scene) = null, 
									   onEnter: ::(Entity, Scene) = null)
{
	assert !this.tagComponentNameMap.Has(serializeName), "Tag component names must be unique";

	defaultCallBack := ::(entity: Entity, scene: Scene) {};
	if (!onRemove) onRemove = defaultCallBack;
	if (!onEnter) onEnter = defaultCallBack;

	tagComponent := { this.tagComponentCount } as TagComponent;
	this.tagComponentNameMap.Insert(serializeName, tagComponent);
	this.tagComponentSerializeMap.Insert(tagComponent.id, serializeName);
	this.tagComponentRemoveCallbacks.Insert(tagComponent.id, onRemove);
	this.tagComponentEnterCallbacks.Insert(tagComponent.id, onEnter);
	this.tagComponentCount += 1;
	return tagComponent;
}

*System ECS::RegisterSystem(run: ::(Scene, float), 
							step: SystemStep = SystemStep.Frame,
							relation: SystemRelation = SystemRelation.Before,
							relationTo: *System = null)
{	
	assert run != null, "Cannot register null systems";

	system := System();
	system.run = run;
	systemID := this.systems.AddSystem(system, step, relationTo, relation);
	return systemID;
}

*FrameSystem ECS::RegisterFrameSystem(run: ::(float), 
									  step: FrameSystemStep,
									  relation: SystemRelation = SystemRelation.Before,
							  		  relationTo: *FrameSystem = null)
{	
	assert run != null, "Cannot register null frame systems";

	system := FrameSystem();
	system.run = run;
	systemID := this.systems.AddFrameSystem(system, step, relationTo, relation);
	return systemID;
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

RunSystem(sceneSystem: *SceneSystem)
{
	Fiber.AddJob(::(data: *SceneSystem) {
		scene := data.scene;
		system := data.system;
		handleRef := data.handle;
		dt := data.dt;

		beforeHandle: *Fiber.JobHandle = null;
		for (before in system.before)
		{
			beforeSceneSystem := FrameAllocType<SceneSystem>();
			beforeSceneSystem~ = SceneSystem(scene, before, dt, beforeHandle@);
			RunSystem(beforeSceneSystem);
		}
		Fiber.WaitForHandle(beforeHandle);

		zone := Tracy.ZoneBeginFunction(system.run as *_Function, systemZone@);
		system.run(scene~, dt);
		Tracy.ZoneEnd(zone);

		for (after in system.after)
		{
			afterSceneSystem := FrameAllocType<SceneSystem>();
			afterSceneSystem~ = SceneSystem(scene, after, dt, handleRef);
			RunSystem(afterSceneSystem);
		}
	}, sceneSystem, sceneSystem.handle);
}

RunFrameSystem(frameSystemJob: *FrameSystemJob)
{
	Fiber.AddJob(::(data: *FrameSystemJob) {
		system := data.system;
		handleRef := data.handle;
		dt := instance.dt;

		beforeHandle: *Fiber.JobHandle = null;
		for (before in system.before)
		{
			beforeFrameSystemJob := FrameAllocType<FrameSystemJob>();
			beforeFrameSystemJob~ = FrameSystemJob(before, beforeHandle@);
			RunFrameSystem(beforeFrameSystemJob);
		}
		Fiber.WaitForHandle(beforeHandle);

		zone := Tracy.ZoneBeginFunction(system.run as *_Function, frameSystemZone@);
		system.run(dt);
		Tracy.ZoneEnd(zone);

		for (after in system.after)
		{
			afterFrameSystemJob := FrameAllocType<FrameSystemJob>();
			afterFrameSystemJob~ = FrameSystemJob(after, handleRef);
			RunFrameSystem(afterFrameSystemJob);
		}
	}, frameSystemJob, frameSystemJob.handle);
}

ECS::RunSystems(systems: Array<*System>, dt: float)
{
	count := this.scenes.count * systems.count;
	if (!count) return;

	handle: *Fiber.JobHandle = null;
	handleRef := handle@;
	for (scene in this.scenes.Values())
	{
		for (system in systems) 
		{
			sceneSystem := FrameAllocType<SceneSystem>();
			sceneSystem~ = SceneSystem(scene@, system, dt, handleRef);
			RunSystem(sceneSystem);
		}
	}

	Fiber.FlushMainThreadJobs();
	Fiber.WaitForHandle(handle);
}

ECS::RunFrameSystems(systems: Array<*FrameSystem>)
{
	if (!systems.count) return;

	handle: *Fiber.JobHandle = null;
	handleRef := handle@;
	for (system in systems)
	{
		frameSystemJob := FrameAllocType<FrameSystemJob>();
		frameSystemJob~ = FrameSystemJob(system, handleRef);
		RunFrameSystem(frameSystemJob);
	}

	Fiber.FlushMainThreadJobs();
	Fiber.WaitForHandle(handle);
}

ECS::Start()
{
	this.RunSystems(this.systems.onStart, this.dt);
}

ECS::Stop()
{
	this.RunSystems(this.systems.onStop, this.dt);
}

ECS::PreFrame()
{
	time := Time.SecondsSinceStart();
	this.dt = Math.FMin(time - this.lastFrameTime, 0.333);
	this.lastFrameTime = time;

	this.fixedAccum = this.fixedAccum + this.dt;
	while (this.fixedAccum > fixedUpdateRate)
	{
		this.RunSystems(this.systems.onFixed, fixedUpdateRate);
		this.fixedAccum = this.fixedAccum - fixedUpdateRate;
	}

	this.RunFrameSystems(this.systems.frameStart);
	this.RunSystems(this.systems.onPreFrame, this.dt);
}

ECS::Frame()
{
	this.RunSystems(this.systems.onFrame, this.dt);
}

ECS::PreDraw()
{
	this.RunSystems(this.systems.onPreDraw, this.dt);
}

ECS::Draw()
{
	this.RunSystems(this.systems.onDraw, this.dt);
}

ECS::PostFrame()
{
	this.RunSystems(this.systems.onPostFrame, this.dt);
	this.RunFrameSystems(this.systems.frameEnd);

	handle: *Fiber.JobHandle = null;
	for (scene in this.scenes.Values())
	{
		Fiber.AddJob(::(scene: *Scene) {
			zone := Tracy.ZoneBegin(scenePostFrameZone@, 1);
			scene.PostFrame();
			Tracy.ZoneEnd(zone);
		}, scene@, handle@);
	}
	Fiber.WaitForHandle(handle);

	Fiber.ClearFrameAllocators();
	this.frameCount += 1;
}
