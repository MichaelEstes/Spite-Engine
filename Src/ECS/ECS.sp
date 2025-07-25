package ECS

import SparseSet
import Time
import Stack
import RingBuffer
import Fiber
import Atomic
import FrameAllocator

instance: ECS = ECS();

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
								  onRemove: ::(*Type, Scene) = null, onEnter: ::(*Type, Scene) = null)
			=> instance.RegisterComponent<Type>(componentKind, onRemove, onEnter);

{id: uint, step: SystemStep} RegisterSystem(run: ::(Scene, float), 
												 step: SystemStep = SystemStep.Frame)
			=> instance.RegisterSystem(run, step);

*Type FrameAlloc<Type>() => instance.frameAllocator.Alloc<Type>();

state ECS
{
	frameAllocator := FrameAllocator(),
	scenes := SparseSet<Scene>(),
	systems: Systems,
	componentTypeMap := Map<*_Type, Component>(),
	componentIDMap := SparseSet<Component>(),
	componentRemoveCallbacks := SparseSet<::(*any, Scene)>(),
	componentEnterCallbacks := SparseSet<::(*any, Scene)>(),
	recycledScenes := Stack<uint16>(),
	systemBuffer := RingBuffer<SceneSystem>(),
	componentCount: uint32,
	sceneCount: uint16
}

Component ECS::RegisterComponent<Type>(componentKind: ComponentKind = ComponentKind.Sparse,
									   onRemove: ::(*Type, Scene) = null, onEnter: ::(*Type, Scene) = null)
{
	type := #typeof Type;
	assert !this.componentTypeMap.Has(type), "Cannot register a component twice";

	component := { this.componentCount, componentKind, uint32(#sizeof Type)} as Component;
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
	// Make sure systemBuffer is always large enough to hold the largest array of systems
	this.systemBuffer.Expand(data.id);
	return data;
}

{id: uint, step: SystemStep} ECS::AddSystem(system: System, step: SystemStep)
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
	}

	return { -1, step };
}

*Scene ECS::CreateScene()
{
	sceneID := this.sceneCount;

	if (this.recycledScenes.count) sceneID = this.recycledScenes.Pop();
	else this.sceneCount += 1;

	this.scenes.Insert(sceneID, Scene(sceneID));
	return this.GetScene(sceneID);
}

*Scene ECS::GetScene(id: uint16) => this.scenes.Get(id);

ECS::RemoveScene(id: uint16)
{
	delete this.GetScene(id)~;
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

Component ECS::GetComponentByID(id: uint16)
{
	return this.componentIDMap.Get(id)~;
}

ECS::OnComponentRemove(id: uint16, componentData: *any, scene: Scene)
{
	if (!this.componentRemoveCallbacks.Has(id)) return;

	callback := this.componentRemoveCallbacks.Get(id)~;
	callback(componentData, scene);
}

ECS::OnComponentEnter(id: uint16, componentData: *any, scene: Scene)
{
	if (!this.componentEnterCallbacks.Has(id)) return;

	callback := this.componentEnterCallbacks.Get(id)~;
	callback(componentData, scene);
}

ECS::RunSystems(systems: Array<System>)
{
	count := this.scenes.count * systems.count
	if (!count) return;

	time := Time.SecondsSinceStart();
	handle: *Fiber.JobHandle = null;
	for (scene in this.scenes.Values())
	{
		for (system in systems) 
		{
			sceneSystem := instance.systemBuffer.Insert({scene@, system@, time} as SceneSystem);
			Fiber.AddJob(::(data: *SceneSystem) {
				scene := data.scene;
				system := data.system;
				time := data.time;

				dt := time - scene.lastFrameTime;
				scene.lastFrameTime = time;
				
				system.run(scene~, dt);
			}, sceneSystem, Fiber.JobPriority.High, handle@);
		}
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

	this.frameAllocator.Clear();
}
