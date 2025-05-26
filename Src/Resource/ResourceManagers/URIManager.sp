package URIManager

import Resource
import OS

state URIResource
{
	buffer: *byte,
	count: uint
}

state URIParam
{
	uri: string,
	basePath: string,
	parent: ResourceHandle
}

URIResourceManager := Resource.CreateResourceManager<URIResource, URIParam>(
	['u', 'r', 'i', '_'],
	GetURIKey, 
	URIManagerLoad,
	::(handle: ResourceHandle) {
		resource := Resource.GetResource<URIResource>(handle);
		delete resource.data.buffer;
	}
);

URIResourceManagerID := Resource.RegisterResourceManager(URIResourceManager@);

string GetURIKey(param: URIParam) => OS.JoinPaths([param.basePath, param.uri]);

URIManagerLoad(uriResourceParam: *ResourceParam<URIResource, URIParam>)
{
	handle := uriResourceParam.handle;
	param := uriResourceParam.param;
	
	uri := param.uri;
	parent := param.parent;

	resourceManager := uriResourceParam.manager;
	resource := resourceManager.GetResource(handle);

	resource.parent = param.parent;
	resourceData := resource.data;

	if (File.IsDataURI(uri))
    {
		
    }
    else
    {
		path := uriResourceParam.key;

        fileContent := OS.ReadFile(path);
		resourceData.buffer = fileContent[0];
		resourceData.count = fileContent.count;
	}

	uriResourceParam.onResourceLoad(uriResourceParam, ResourceResult.Loaded);
}

ResourceHandle LoadURIResource(uri: string, basePath: string = "", parent: ResourceHandle = InvalidResourceHandle)
{
	uriParam := URIParam();
	uriParam.uri = uri;
	uriParam.basePath = basePath;
	uriParam.parent = parent;

	return URIResourceManager.LoadResource(uriParam, ::(handle: ResourceHandle){});
}