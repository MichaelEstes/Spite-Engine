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

	data := 0;
	handle: *Fiber.JobHandle = null;
	Fiber.AddJob(::(data: *int) {
		for (i .. 10000)
		{
			data~ = i;
		}	
	}, data@, handle@);
	Fiber.WaitForHandle(handle);

	//log "Data: ", data;

	if (scene.HasSingleton<SingletonTest>()) scene.GetSingleton<SingletonTest>().myValue += 1;
});

Main()
{
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