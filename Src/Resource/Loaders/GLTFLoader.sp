package GLTFLoader

import Resource
import Fiber
import ThreadParamAllocator
import GLTF
import Scene
import Entity

state GLTFLoadParam
{
	file: string,
	scene: *Scene,
	entities: *Array<Entity>
}

LoadGLTFResource(file: string, scene: *Scene, onLoad: ::(ResourceHandle), outEntities: *Array<Entity> = null)
{
	loadParam := AllocThreadParam<GLTFLoadParam>();
	loadParam.file = file;
	loadParam.scene = scene;
	loadParam.entities = outEntities;

	Fiber.RunOnMainFiber(::(param: *GLTFLoadParam) {
		defer DeallocThreadParam<GLTFLoadParam>(param);



		file := param.file;
		scene := param.scene;
		entities := param.entities;

		gltf := LoadGLTF(param.file);

		for (gltfScene in gltf.scenes)
		{
			for (nodeIndex in gltfScene.nodes)
			{
				FlushNodeToECS(gltf, scene, nodeIndex, nullEntity, outEntities);
			}
		}

	}, loadParam);
}