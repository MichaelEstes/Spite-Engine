package Main

import Transform
import Core
import SDL

import OS
import JSON

import Thread
import SystemInfo
import Fiber


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

system := ECS.instance.RegisterSystem(::(scene: Scene, dt: float) {
	//log "System called", dt;
	
	for (item in scene.Iterate<Transform>())
	{
		log item;
	}
	
	for (item in scene.Iterate<Test>())
	{
		log item;
	}

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
		scene.SetComponent<Test>(entity, i as Test);
	}

	//scene.RemoveEntity(Entity(5));
	//scene.RemoveComponent<Transform>(Entity(6));
	//scene.RemoveComponent<Test>(Entity(7));
	//ECS.instance.Update();

	//log OS.ReadFile("C:\\Users\\Flynn\\Documents\\Spite Engine\\Text.txt");

	//json := JSON.ParseJSONFile("C:\\Users\\Flynn\\Documents\\Spite Engine\\Text.txt");
	//obj := json.root.Object().GetMember("widget").Object().members;
	//log obj;
	
	Fiber.InitalizeFibers();

	Fiber.AddJob(::(num: *void) {
		log "Running fiber job", num;
	}, 7777777 as *any);

	thread := Thread.Create(::int32(data: *void) {
		log "Running on a thread", data;
		return 0;
	}, 9999999 as *any);

	Thread.Wait(thread);

	log GetSystemInfo();

	//Core.Initialize();
	//SDL.OnEvent(::int(userdata: *void, event: *SDL.Event) {
	//	log "Event Callback: ", event;
	//	return 1;
	//}, null)
	//Core.Start();
}