package URIManager

import Resource
import OS

state URIResource
{
	buffer: *byte,
	count: uint
}

state URIResourceArg
{
	uri: string,
	basePath: string,
	parent: ResourceHandle
}

URIResourceManager := Resource.CreateResourceManager<URIResourceArg>(
	['u', 'r', 'i', '_'],
	::(manager: *ResourceManager<URIResourceArg>) {
		manager.RegisterResourceType<URIResource>(CreateURIKey, URIManagerLoad);
	},
	::*_Type(param: *URIResourceArg) => return #typeof URIResource,
	::(handle: ResourceHandle) {
		resource := Resource.GetResource<URIResource>(handle);
		delete resource.data.buffer;
	}
);

ResourceKey CreateURIKey(param: *URIResourceArg) => ResourceKey(OS.JoinPaths([param.basePath, param.uri]));

URIManagerLoad(resourceArg: *ResourceArg<URIResourceArg>, resource: *Resource<URIResource>)
{
	param := resourceArg.arg;

	uri := param.uri;

	resourceData := resource.data;

	if (File.IsDataURI(uri))
    {

    }
    else
    {
		path := resourceArg.key.value.name;

        fileContent := OS.ReadFile(path);
		resourceData.buffer = fileContent[0];
		resourceData.count = fileContent.count;
	}

	resource.result = ResourceResult.Loaded;
}

ResourceHandle LoadURIResource(uri: string, basePath: string = "", parent: ResourceHandle = InvalidResourceHandle)
{
	uriParam := URIResourceArg();
	uriParam.uri = uri;
	uriParam.basePath = basePath;
	uriParam.parent = parent;

	return URIResourceManager.LoadResource(uriParam);
}
