package ImageManager

import Resource
import RenderComponents
import Image
import SDL

state ImageResource
{
	image: *SDL.Surface
}

state ImageResourceArg
{
	uri: string,
	basePath: string,
	parent: ResourceHandle,
	uriIsImage := false
}

ImageResourceManager := Resource.CreateResourceManager<ImageResourceArg>(
	['i', 'm', 'g', '_'],
	::(manager: *ResourceManager<ImageResourceArg>) {
		manager.RegisterResourceType<ImageResource>(CreateImageKey, ImageManagerLoad);
	},
	::*_Type(param: *ImageResourceArg) => return #typeof ImageResource,
	::(handle: ResourceHandle) {
		resource := Resource.GetResource<ImageResource>(handle);
		SDL.DestroySurface(resource.data.image);
	}
);

ResourceKey CreateImageKey(param: *ImageResourceArg)
{
	if (param.uriIsImage)
	{
		return ResourceKey(param.uri.mem as uint);
	}

	return ResourceKey(OS.JoinPaths([param.basePath, param.uri]));
}

ImageManagerLoad(resourceArg: *ResourceArg<ImageResourceArg>, resource: *Resource<ImageResource>)
{
	param := resourceArg.arg;

	uri := param.uri;
	uriIsImage := param.uriIsImage;

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
		path := resourceArg.key.value.name;
		resourceData.image = Image.LoadTextureImage(path);
	}

	resource.result = ResourceResult.Loaded;
}

ResourceHandle LoadImageResource(uri: string, basePath: string = "", parent: ResourceHandle = InvalidResourceHandle)
{
	textureParam := ImageResourceArg();
	textureParam.uri = uri;
	textureParam.basePath = basePath;
	textureParam.parent = parent;

	return ImageResourceManager.LoadResource(textureParam);
}

ResourceHandle CreateImageResource(imageData: string, basePath: string = "", parent: ResourceHandle = InvalidResourceHandle)
{
	textureParam := ImageResourceArg();
	textureParam.uri = imageData;
	textureParam.basePath = basePath;
	textureParam.parent = parent;
	textureParam.uriIsImage = true;

	return ImageResourceManager.LoadResource(textureParam);
}
