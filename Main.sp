package Main

import Transform
import Core

import GLTF
import File
import Thread

import ECS
import FileManager

import GLTFManager

import Scenes

import SingleConsumerQueue
import FixedArray
import Math

import ParseHeader

state Test
{
	i: int
}

state SingletonTest
{
	myValue: float
}

testComponent := ECS.RegisterComponent<Test>(
	ComponentKind.Sparse, 
	::(entity: Entity, test: *Test, scene: Scene) {
		//log "Removing test component: ", test;
	}
);

singletonTestComponent := ECS.RegisterComponent<SingletonTest>(
	ComponentKind.Singleton
);

tagSparseTestComponent := ECS.RegisterTagComponent(
	"Test sparse tag",
	ComponentKind.Sparse,
	::(entity: Entity, scene: Scene) {
		//log "Removing test sparse tag component: ", entity;
	}
	::(entity: Entity, scene: Scene) {
		//log "Adding test sparse tag component: ", entity;
	}
);

tagCommonTestComponent := ECS.RegisterTagComponent(
	"Test common tag",
	ComponentKind.Common,
	::(entity: Entity, scene: Scene) {
		//log "Removing test common tag component: ", entity;
	}
	::(entity: Entity, scene: Scene) {
		//log "Adding test common tag component: ", entity;
	}
);

queryTestSystem := ECS.RegisterSystem(::(scene: Scene, dt: float) {
	//log "Transform System called", dt;
	
	for (item in scene.Iterate<Transform>())
	{
		//log item;
	}

	query := Query(scene@).With<Transform>().Without<Test>();
	result := query.Result();
	defer {
		delete query;
		delete result;
	}

	for (entity in result)
	{
		//log "Query entity: ", entity;
	}
});

testSystem := ECS.RegisterSystem(::(scene: Scene, dt: float) {
	//log "Test System called", dt;
	
	for (item in scene.Iterate<Test>())
	{
		//log item;
	}

	for (sparseTagEntity in scene.IterateTagComponent(tagSparseTestComponent))
	{
		//log "Sparse tag entity: ", sparseTagEntity;
		//scene.RemoveTagComponent(sparseTagEntity, tagSparseTestComponent);
	}

	for (commonTagEntity in scene.IterateTagComponent(tagCommonTestComponent))
	{
		//log "Common tag entity: ", commonTagEntity;
		//scene.RemoveTagComponent(commonTagEntity, tagCommonTestComponent);
	}

	//data := 0;
	//handle: *Fiber.JobHandle = null;
	//Fiber.AddJob(::(data: *int) {
	//	for (i .. 10)
	//	{
	//		data~ = i;
	//	}	
	//	log "JOB FINISHED: ", i;
	//}, data@, handle@);
	//Fiber.WaitForHandle(handle);

	//log "Data: ", data;

	if (scene.HasSingleton<SingletonTest>()) scene.GetSingleton<SingletonTest>().myValue += 1;
});

queueCount := 8;
queues := FixedArray<SingleConsumerQueue<uint>>(queueCount);

TestQueue()
{
	for (i: uint .. queueCount)
	{
		queues[i]~ = SingleConsumerQueue<uint>(128);
	}

	for (j: uint .. queueCount)
	{
		Thread.Create(::int32(data: *void) {
			index := data as uint;
			queue := queues[index];
			indexStr := UIntToString(index);
			
			while (true)
			{
				val := queue.Dequeue();
				msg := "Dequeued value ";
				valStr := UIntToString(val);
				msg = msg.Append(valStr);
				msg = msg.Append(" on thread ");
				msg = msg.Append(indexStr);
				msg = msg.Append(" top ");
				msg = msg.Append(ToString<{ arrayIndex: uint32, stackIndex: uint32, version: uint32 }>(
					queue.refAllocator.top.Get()
				));
				log msg;
				Thread.Sleep(200);
			}

			return 0;
		}, j as *void, null);
	}

	Thread.Create(::int32(data: *void) {
		val := uint(1);
		while (true)
		{
			index := Math.RandBetween(0, queueCount - 1);
			indexStr := UIntToString(index);
			for (i .. Math.RandBetween(64, 128 * 2))
			{
				queue := queues[index];

				msg := "Enqueuing value ";
				valStr := UIntToString(val);
				msg = msg.Append(valStr);
				msg = msg.Append(" on thread ");
				msg = msg.Append(indexStr);
				msg = msg.Append(" top ");
				msg = msg.Append(ToString<{ arrayIndex: uint16, stackIndex: uint16, version: uint32 }>(
					queue.refAllocator.top.Get()
				));
				log msg;

				queue.Enqueue(val);

				val += 1;
			}
		}

		return 0;
	}, null, null);

	while (true) {}
}

Main()
{
	//TestQueue();

	scene := ECS.instance.CreateScene();
	
	scene.SetSingleton<SingletonTest>({9.0});

	
	for (i .. 10)
	{
		entity := scene.CreateEntity();
		val := i as float;
		pos := Vec3(val, val, val);
		scene.SetComponent<Transform>(entity, Transform(pos));
	
		if (i > 5)
		{
			scene.SetComponent<Test>(entity, i as Test);
			scene.SetTagComponent(entity, tagSparseTestComponent);
		}
		else
		{
			scene.SetTagComponent(entity, tagCommonTestComponent);
		}
	}
	
	scene.RemoveEntity(Entity(5));
	scene.RemoveComponent<Transform>(Entity(6));
	scene.RemoveComponent<Test>(Entity(7));

	Core.Initialize();
	Core.Start();
}