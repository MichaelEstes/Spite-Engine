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
	basePath: string
}

URIResourceManager := Resource.CreateResourceManager<URIResource, URIParam>(
	['u', 'r', 'i', '_'],
	GetURIKey, 
	URIManagerLoad,
	::(handle: ResourceHandle) {
		resource := Resource.GetResource<URIResource>(handle);
		log "RELEASING URI RESOURCE", resource;
		delete resource.data.buffer;
	}
);

URIResourceManagerID := Resource.RegisterResourceManager(URIResourceManager@);

string GetURIKey(param: URIParam) => param.uri;

URIManagerLoad(uriParam: *ResourceParam<URIResource, URIParam>)
{
	uri := uriParam.param.uri;
	basePath := uriParam.param.basePath;
	resource := uriParam.resource.data;
	
	if (File.IsDataURI(uri))
    {
		
    }
    else
    {
		path := OS.JoinPaths([basePath, uri]);
		defer delete path;

        fileContent := OS.ReadFile(path);
		resource.buffer = fileContent[0];
		resource.count = fileContent.count;
	}

	uriParam.onResourceLoad(uriParam);
}

ResourceHandle LoadURIResource(uri: string, basePath: string = "")
{
	uriParam := URIParam();
	uriParam.uri = uri;
	uriParam.basePath = basePath;

	return URIResourceManager.LoadResource(uriParam, ::(handle: ResourceHandle){});
}