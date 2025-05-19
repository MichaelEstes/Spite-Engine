package Resource

import HandleSet

state ResourceManager<Type>
{
	resourceKeyToHandle := Map<string, ResourceHandle>(),
	resources := HandleSet<Resource<Type>>(),

	loader: ::Type(*ParamType),
	onLoad: ::(*Type),
	onRelease: ::(*Type)
}

resourceManager := ResourceManager();

ResourceManager<Type> RegisterResourceManager<ResourceType, ParamType>(loader: ::ResourceType(*any),
															 onLoad: ::(*ResourceType) = null,
															 onRelease: ::(*ResourceType) = null)
{
	handle := ResourceLoaderHandle();
	next := resourceManager.resourceLoaders.GetNext();
	
	handle.id = next.handle;

	loader := next.value as ResourceLoader<ResourceType, ParamType>;
	loader.loader = loader;
	loader.onLoad = onLoad;
	loader.onRelease = onRelease;

	return handle;
}

ResourceHandle LoadResource<Type, ParamType>(loaderHandle: ResourceLoaderHandle, param: *ParamType)
{

}

