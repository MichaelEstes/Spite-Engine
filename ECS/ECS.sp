package ECS

import System
import Entity
import Scene
import SparseSet
import Time
import Stack
import RingBuffer
import Fiber
import Atomic

instance: ECS = ECS();

enum ComponentKind: uint32
{
	Common,
	Sparse
}

state Component
{
	id: uint32,
	kind: ComponentKind,
	size: uint32
}

state SceneSystem { scene: *Scene, system: *System }

state ECS
{
	scenes := SparseSet<Scene>(),
	systems: Systems,
	componentTypeMap := Map<*_Type, Component>(),
	componentIDMap := SparseSet<Component>(),
	componentRemoveCallbacks := SparseSet<::(*any)>(),
	recycledScenes := Stack<uint16>(),
	systemBuffer := RingBuffer<SceneSystem>(),
	systemFrameCount := Atomic<uint32>(0),
	componentCount: uint32,
	sceneCount: uint16
}

Component ECS::RegisterComponent<Type>(componentKind: ComponentKind = ComponentKind.Sparse,
										onRemove: ::(*Type) = null)
{
	type := #typeof Type;
	assert !this.componentTypeMap.Has(type), "Cannot register a component twice";

	component := { this.componentCount, componentKind, uint32(#sizeof Type)} as Component;
	this.componentTypeMap.Insert(type, component);
	this.componentIDMap.Insert(component.id, component);
	if (onRemove) this.componentRemoveCallbacks.Insert(component.id, onRemove);
	this.componentCount += 1;
	return component;
}

{id: uint, step: SystemStep} ECS::RegisterSystem(run: ::(Scene, float), step: SystemStep = SystemStep.OnFrame)
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
		case (SystemStep.OnFixed) return { this.systems.onFixed.Add(system), step };
		case (SystemStep.OnEarlyFrame) return { this.systems.onEarlyFrame.Add(system), step };
		case (SystemStep.OnFrame) return { this.systems.onFrame.Add(system), step };
		case (SystemStep.OnPostFrame) return { this.systems.onPostFrame.Add(system), step };
		case (SystemStep.OnStart) return { this.systems.onStart.Add(system), step };
		case (SystemStep.OnStop) return { this.systems.onStop.Add(system), step };
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
	this.scenes.Remove(id);
	this.recycledScenes.Push(id);
}

Entity ECS::CreateEntity(sceneID: uint) => this.GetScene(sceneID).CreateEntity();

Component ECS::GetComponent<Type>()
{
	type := #typeof Type;
	return this.componentTypeMap[type]~;
}

Component ECS::GetComponentByID(id: uint16)
{
	return this.componentIDMap.Get(id)~;
}

ECS::OnComponentRemove(id: uint16, componentData: *any)
{
	if (!this.componentRemoveCallbacks.Has(id)) return;

	callback := this.componentRemoveCallbacks.Get(id)~;
	callback(componentData);
}

ECS::RunSystems(systems: []System)
{
	for (scene in this.scenes.Values())
	{
		for (system in systems) 
		{
			sceneSystem := instance.systemBuffer.Insert({scene, system@} as SceneSystem);
			Fiber.AddJob(::(data: *SceneSystem) {
				scene := data.scene;
				system := data.system;

				currTime := Time.SecondsSinceStart();
				dt := currTime - scene.lastFrameTime;
				scene.lastFrameTime = currTime;
				
				system.run(scene~, dt);
				instance.systemFrameCount.Add(1, MemoryOrder.Relaxed);
			}, sceneSystem);
		}
	}

	while (instance.systemFrameCount.Load(MemoryOrder.Relaxed) != systems.count) {}
	instance.systemFrameCount.Store(0, MemoryOrder.Relaxed);
}

ECS::Start()
{
	this.RunSystems(this.systems.onStart);
}

ECS::Stop()
{
	this.RunSystems(this.systems.onStop);
}

ECS::Update()
{
	this.RunSystems(this.systems.onFrame);
}
