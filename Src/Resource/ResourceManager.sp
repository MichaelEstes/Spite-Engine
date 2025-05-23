package Resource

import HandleSet
import ThreadParamAllocator

enum ResourceResult: uint32
{
	Loading,
	Loaded,
	NotFound,
	LoadFailed,
	Invalid
}

state ResourceHandle
{
	id: uint32
}

state ResourceParam<Type, ParamType>
{
	key: string,
	manager: *ResourceManager<Type, ParamType>,
	onResourceLoad: ::(*ResourceParam<Type, ParamType>),
	onLoad: ::(ResourceHandle),
	resource: *Resource<Type>,
	param: ParamType,
	handle: ResourceHandle
}

state Resource<Type>
{
	data: Type,
	metadata: *void

	parent: ResourceHandle,
	result: ResourceResult,
	refCount: uint32
}

state ResourceManager<Type, ParamType>
{
	resourceKeyToHandle := Map<string, ResourceHandle>(),
	resources := HandleSet<Resource<Type>>(),

	getKey: ::string(ParamType)
	loader: ::(*ResourceParam<Type, ParamType>),
	onLoad: ::(ResourceHandle),
	onRelease: ::(ResourceHandle)
}

ResourceManager::delete
{
	delete this.resourceKeyToHandle;
	delete this.resources;
}

ResourceHandle ResourceManager::LoadResource(param: ParamType, onLoad: ::(ResourceHandle))
{
	resourceKey := this.getKey(param);

	if (this.resourceKeyToHandle.Has(resourceKey))
	{
		handle := this.resourceKeyToHandle[resourceKey]~;
		onLoad(handle);
		return handle;
	}

	handleValue := this.resources.GetNext();

	handle := handleValue.handle as ResourceHandle;

	resource := handleValue.value;
	resource~ = Resource<Type>();
	resource.result = ResourceResult.Loading;

	resourceParam := AllocThreadParam<ResourceParam<Type, ParamType>>();
	resourceParam.key = resourceKey;
	resourceParam.manager = this@;
	resourceParam.onLoad = onLoad;
	resourceParam.param = param;
	resourceParam.handle = handle;
	resourceParam.resource = resource;

	resourceParam.onResourceLoad = ::(param: *ResourceParam<Type,ParamType>) {
		defer DeallocThreadParam<ResourceParam<Type, ParamType>>(param);

		handle := param.handle;
		resourceManager := param.manager;
		
		if (resourceManager.onLoad) resourceManager.onLoad(handle)
		param.onLoad(handle);
	};

	this.loader(resourceParam);

	return handle;
}

ResourceManager<ResourceType, ParamType> RegisterResourceManager<ResourceType, ParamType>(
		getKey: ::string(ParamType), 
		loader: ::(*ResourceParam<ResourceType, ParamType>),
		onLoad: ::(ResourceHandle) = null, 
		onRelease: ::(ResourceHandle) = null
	)
{
	resourceManager := ResourceManager<ResourceType, ParamType>();
	resourceManager.getKey = getKey;
	resourceManager.loader = loader;
	resourceManager.onLoad = onLoad;
	resourceManager.onRelease = onRelease;

	return resourceManager;
}

