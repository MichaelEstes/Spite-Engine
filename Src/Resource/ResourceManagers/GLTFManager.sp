package GLTFManager

import Resource
import Fiber
import ThreadParamAllocator
import GLTF
import Scene
import Entity

state GLTFResource
{
	children: Array<Resource<any>>
}

state GLTFLoadParam
{
	file: string,
	scene: *Scene,
	outEntities: *Array<Entity>
}

GLTFResourceManager := Resource.RegisterResourceManager<GLTFResource, GLTFLoadParam>(GetGLTFKey, GLTFManagerLoad);

string GetGLTFKey(param: GLTFLoadParam) => param.file;

GLTFManagerLoad(param: *ResourceParam<GLTFResource, GLTFLoadParam>)
{
	Fiber.RunOnMainFiber(::(resourceParam: *ResourceParam<GLTFResource, GLTFLoadParam>) 
	{
		param := resourceParam.param;
	
		file := param.file;
		scene := param.scene;
		outEntities := param.outEntities;

		gltf := LoadGLTF(file);

		for (gltfScene in gltf.scenes)
		{
			for (nodeIndex in gltfScene.nodes)
			{
				//FlushNodeToECS(gltf, scene, nodeIndex, nullEntity, outEntities);
			}
		}

		resourceParam.onResourceLoad(resourceParam);
	}, param);
}

ResourceHandle LoadGLTFResource(file: string, scene: *Scene, onLoad: ::(ResourceHandle), outEntities: *Array<Entity> = null)
{
	gltfParam := GLTFLoadParam();
	gltfParam.file = file;
	gltfParam.scene = scene;
	gltfParam.outEntities = outEntities;
	
	return GLTFResourceManager.LoadResource(gltfParam, onLoad);
}