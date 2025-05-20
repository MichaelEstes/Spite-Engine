package Main

import Transform
import Core

import GLTF
import File
import Thread

import Query
import FileManager

import GLTFManager

state Test
{
	i: int
}

state SingletonTest
{
	myValue: float
}

transformComponent := ECS.instance.RegisterComponent<Transform>(
	ComponentKind.Common, 
	::(transform: *Transform) {
		log "Removing transform: ", transform;
	}
);

testComponent := ECS.instance.RegisterComponent<Test>(
	ComponentKind.Sparse, 
	::(test: *Test) {
		log "Removing test component: ", test;
	}
);

transformSystem := ECS.instance.RegisterSystem(::(scene: Scene, dt: float) {
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

testSystem := ECS.instance.RegisterSystem(::(scene: Scene, dt: float) {
	//log "Test System called", dt;
	
	for (item in scene.Iterate<Test>())
	{
		//log item;
	}

	data := 0;
	handle: *Fiber.JobHandle = null;
	Fiber.AddJob(::(data: *int) {
		for (i .. 10000)
		{
			data~ = i;
		}	
	}, data@, Fiber.JobPriority.High, handle@);
	WaitForHandle(handle);

	scene.GetSingleton<SingletonTest>().myValue += 1;
});

Main()
{
	scene := ECS.instance.CreateScene();

	scene.SetSingleton<SingletonTest>({9.0});

	for (i .. 10)
	{
		entity := scene.CreateEntity();
		val := i as float;
		scene.SetComponent<Transform>(entity, Transform(val, val, val));

		if (i > 5)
		{
			scene.SetComponent<Test>(entity, i as Test);
		}
	}

	//scene.RemoveEntity(Entity(5));
	//scene.RemoveComponent<Transform>(Entity(6));
	//scene.RemoveComponent<Test>(Entity(7));

	Core.Initialize();

	LoadGLTFResource("./Resource/Models/Box/Box.gltf", scene, ::(handle: ResourceHandle) {
		log "Loaded gltf: ", handle;
	});

	Core.Start();

	//log gltf;
}