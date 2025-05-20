package Resource

import HandleSet

state ResourceManager<Type, ParamType>
{
	resourceKeyToHandle := Map<string, ResourceHandle>(),
	resources := HandleSet<Resource<Type>>(),

	getKey: ::string(ParamType)
	loader: ::(ParamType, ::(Resource<Type>, ResourceParam<ParamType>)),
	onLoad: ::(*Type),
	onRelease: ::(*Type)
}

ResourceManager::delete
{
	delete this.resourceKeyToHandle;
	delete this.resources;
}

ResourceManager::LoadResource(param: ParamType, onLoad: ::(ResourceHandle))
{
	resourceKey := this.getKey(param);

	if (this.resourceKeyToHandle.Has(resourceKey))
	{
		handle := this.resourceKeyToHandle[resourceKey]~;
		onLoad(handle);
		return;
	}

	resourceParam := ResourceParam<ParamType>();
	resourceParam.key = resourceKey;
	resourceParam.onLoad = onLoad;
	resourceParam.data = param;

	this.loader(resourceParam, ::(resource: Resource<Type>, param: ResourceParam<ParamType>) {

	});
}

ResourceManager<Type> RegisterResourceManager<ResourceType, ParamType>(
		getKey: ::string(ParamType), 
		loader: ::(ResourceParam<ParamType>, ::(Resource<ResourceType>, ResourceParam<ParamType>)),
		onLoad: ::(*ResourceType) = null, onRelease: ::(*ResourceType) = null
	)
{
	resourceManager := ResourceManager<ResourceType, ParamType>();
	resourceManager.loader = loader;
	resourceManager.onLoad = onLoad;
	resourceManager.onRelease = onRelease;

	return resourceManager;
}

