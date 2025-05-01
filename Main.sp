package Main

import Transform
import Core

import GLTF
import File

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
});

testSystem := ECS.instance.RegisterSystem(::(scene: Scene, dt: float) {
	//log "Test System called", dt;
	
	for (item in scene.Iterate<Test>())
	{
		//log item;
	}

	contents := "";
	handle := LoadFileFiber("./Resource/Models/BrainStem.gltf", contents@);
	WaitForHandle(handle);
	log "Waited for contents on fiber thread", contents.count;
	delete contents;

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

	gltf := LoadGLTF("./Resource/Models/BrainStem.gltf");

	//gltf := LoadGLTF("C:\\Users\\Flynn\\Documents\\Spite Engine\\Files\\GLTF\\Resource\\Cameras.gltf");

	Core.Initialize();
	Core.Start();

	//contents := "";
	//handle := LoadFileFiber("./Resource/Models/BrainStem.gltf", contents@);
	//WaitForHandle(handle);
	//log "Waited for contents", contents.count;
}