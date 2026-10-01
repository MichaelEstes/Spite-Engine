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

import ParseHeader
import Array

import Time

import Common

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

tagTestComponent := ECS.RegisterTagComponent(
	"Test sparse tag",
	::(entity: Entity, scene: Scene) {
		//log "Removing test sparse tag component: ", entity;
	}
	::(entity: Entity, scene: Scene) {
		//log "Adding test sparse tag component: ", entity;
	}
);

queryTestSystem := ECS.RegisterSystem(::(scene: Scene, dt: float) {
	// log "Transform System called", dt;
	
	for (item in scene.Iterate<Transform>())
	{
		// log item;
	}

	// query := Query(scene@).With<Transform>().Without<Test>();
	// result := query.Result();
	// defer {
	// 	delete query;
	// }

	// for (entity in result)
	// {
	// 	log "Query entity: ", entity;
	// }
}, SystemStep.PreDraw, SystemRelation.Before, TransformUpdateSystem);

testSystem := ECS.RegisterSystem(::(scene: Scene, dt: float) {
	// log "Test System called", dt;
	for (item in scene.Iterate<Test>())
	{
		//log item;
	}

	for (tagEntity in scene.IterateTagComponent(tagTestComponent))
	{
		//log "Tag entity: ", tagEntity;
		//scene.RemoveTagComponent(tagEntity, tagTestComponent);
	}

	handle := null as *Fiber.JobHandle;
	for (i .. 20)
	{
		Fiber.AddJob(::(data: *int) {
			val := 0;
			for (i .. 10)
			{
				val += i;
			}
			//log UIntToString(data as uint) + " : Run";
		}, (i as uint) as *uint, handle@);
	}
	Fiber.WaitForHandle(handle);

	//log "Data: ", data;

	if (scene.HasSingleton<SingletonTest>()) scene.GetSingleton<SingletonTest>().myValue += 1;
}, SystemStep.PreDraw, SystemRelation.After, queryTestSystem);

Main()
{
	Core.Initialize();
	Core.Start();
}