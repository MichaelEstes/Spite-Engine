package GLTFManager

import Resource
import Fiber
import ThreadParamAllocator
import GLTF
import Scene
import Entity

state GLTFResource
{
	children: Array<Resource>
}

state GLTFLoadParam
{
	file: string,
	scene: *Scene,
	outEntities: *Array<Entity>
}

state GLTFThreadParam
{

}

GLTFResourceManager := Resource.RegisterResourceManager<GLTFResource, GLTFLoadParam>(GetGLTFKey, LoadGLTFResource);

string GetGLTFKey(params: GLTFLoadParam) => params.file;

LoadGLTFResource(params: ResourceParam<GLTFLoadParam>, onLoad: ::(Resource<GLTFResource>))
{
	loadParam := AllocThreadParam<GLTFLoadParam>();
	loadParam.file = params.file;
	loadParam.scene = params.scene;
	loadParam.outEntities = params.outEntities;

	Fiber.RunOnMainFiber(::(params: *GLTFLoadParam) {
		defer DeallocThreadParam<GLTFLoadParam>(params);

		file := params.file;
		scene := params.scene;
		entities := params.entities;

		gltf := LoadGLTF(file);

		for (gltfScene in gltf.scenes)
		{
			for (nodeIndex in gltfScene.nodes)
			{
				FlushNodeToECS(gltf, scene, nodeIndex, nullEntity, outEntities);
			}
		}

	}, loadParam);
}