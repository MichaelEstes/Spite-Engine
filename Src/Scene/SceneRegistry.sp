package SceneRegistry

import SparseSet
import ECS

state RegisteredScene
{
	name: string,
	init: ::(*Scene)
}

registeredScenes := SparseSet<RegisteredScene>();

RegisterScene(index: uint32, initializer: ::(*Scene), name: string  = "")
{
	registeredScene := RegisteredScene();
	registeredScene.init = initializer;
	registeredScene.name = name;

	registeredScenes.Insert(index, registeredScene);
	log "Registered scene: ", index, name;
}

LoadScene(index: uint32)
{
	registeredScene := registeredScenes.Get(index);
	assert registeredScene, "No scene found for index";

	scene := ECS.instance.CreateScene();
	registeredScene.init(scene);
}