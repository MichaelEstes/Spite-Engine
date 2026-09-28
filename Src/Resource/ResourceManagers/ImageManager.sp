package ImageManager

import Resource
import RenderComponents
import Image
import SDL

state ImageResource
{
	image: *SDL.Surface
}

state ImageParam
{
	uri: string,
	basePath: string,
	parent: ResourceHandle,
	uriIsImage := false
}

ImageResourceManager := Resource.CreateResourceManager<ImageResource, ImageParam>(
	['i', 'm', 'g', '_'],
	GetImageKey, 
	ImageManagerLoad,
	::(handle: ResourceHandle) {
		resource := Resource.GetResource<ImageResource>(handle);
		SDL.DestroySurface(resource.data.image);
	}
);

ImageResourceManagerID := Resource.RegisterResourceManager(ImageResourceManager@);

ResourceKey GetImageKey(param: ImageParam) 
{
	if (param.uriIsImage)
	{
		return ResourceKey(param.uri.mem as uint);
	}
	
	return ResourceKey(OS.JoinPaths([param.basePath, param.uri]));
}

ImageManagerLoad(imageResourceParam: *ResourceParam<ImageResource, ImageParam>)
{
	handle := imageResourceParam.handle;
	param := imageResourceParam.param;
	
	uri := param.uri;
	parent := param.parent;
	uriIsImage := param.uriIsImage;

	resourceManager := imageResourceParam.manager;
	resource := resourceManager.GetResource(handle);

	resource.parent = param.parent;
	resourceData := resource.data;

	if (uriIsImage)
	{
		resourceData.image = Image.CreateTextureImage(uri[0], uri.count);
	}
	else if (File.IsDataURI(uri))
    {
		
    }
    else
    {
		path := imageResourceParam.key.value.name;
		resourceData.image = Image.LoadTextureImage(path);
	}

	imageResourceParam.onResourceLoad(imageResourceParam, ResourceResult.Loaded);
}

ResourceHandle LoadImageResource(uri: string, basePath: string = "", parent: ResourceHandle = InvalidResourceHandle)
{
	textureParam := ImageParam();
	textureParam.uri = uri;
	textureParam.basePath = basePath;
	textureParam.parent = parent;

	return ImageResourceManager.LoadResource(textureParam, null);
}

ResourceHandle CreateImageResource(imageData: string, basePath: string = "", parent: ResourceHandle = InvalidResourceHandle)
{
	textureParam := ImageParam();
	textureParam.uri = imageData;
	textureParam.basePath = basePath;
	textureParam.parent = parent;
	textureParam.uriIsImage = true;

	return ImageResourceManager.LoadResource(textureParam, null);
}