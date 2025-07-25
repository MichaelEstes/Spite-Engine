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

transformComponent := ECS.RegisterComponent<Transform>(
	ComponentKind.Common, 
	::(transform: *Transform, scene: Scene) {
		log "Removing transform: ", transform;
	}
);

testComponent := ECS.RegisterComponent<Test>(
	ComponentKind.Sparse, 
	::(test: *Test, scene: Scene) {
		log "Removing test component: ", test;
	}
);

singletonTestComponent := ECS.RegisterComponent<SingletonTest>(
	ComponentKind.Singleton
);

transformSystem := ECS.RegisterSystem(::(scene: Scene, dt: float) {
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

	data := 0;
	handle: *Fiber.JobHandle = null;
	Fiber.AddJob(::(data: *int) {
		for (i .. 10000)
		{
			data~ = i;
		}	
	}, data@, Fiber.JobPriority.High, handle@);
	Fiber.WaitForHandle(handle);

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

//	LoadGLTFResource("./Resource/Models/Box/Box.gltf", scene, ::(handle: ResourceHandle) {
//		log "Loaded gltf: ", handle;
//
//		gltfResource := Resource.TakeResourceRef<GLTFResource>(handle);
//		log "GLTF RESOURCE: ", gltfResource;
//		Resource.ReleaseResourceRef(handle);
//	});

	Core.Start();

	//log gltf;
}