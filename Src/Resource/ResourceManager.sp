package Resource

import HandleSet
import ThreadParamAllocator

enum ResourceResult: uint32
{
	Loading,
	Loaded,
	NotFound,
	LoadFailed,
	Released,
	Invalid
}

state ResourceHandle
{
	id: uint32
	manager: uint32
}

InvalidResourceHandle := ResourceHandle();

state ResourceParam<Type, ParamType>
{
	key: string,
	manager: *ResourceManager<Type, ParamType>,
	onResourceLoad: ::(*ResourceParam<Type, ParamType>, ResourceResult),
	onLoad: ::(ResourceHandle),
	param: ParamType,
	handle: ResourceHandle
}

state Resource<Type>
{
	metadata: *void

	parent: ResourceHandle,
	result: ResourceResult,

	refCount: int,
	
	//Data needs to be last in so the other fields can be accessed in a type erased context
	data: Type
}

state ResourceManager<Type, ParamType>
{
	resourceKeyToHandle := Map<string, ResourceHandle>(),
	resources := HandleSet<Resource<Type>>(),

	getResourceKey: ::string(ParamType)
	loader: ::(*ResourceParam<Type, ParamType>),
	onRelease: ::(ResourceHandle),
	onChildRelease: ::(ResourceHandle, ResourceHandle),

	id: uint32
}

ResourceManager::delete
{
	delete this.resourceKeyToHandle;
	delete this.resources;
}

ResourceManager::RemoveResource(handle: ResourceHandle)
{
    id := handle.id;
    if (!this.resources.Has(id)) return;

	if (this.onRelease) this.onRelease(handle);
    this.resources.Remove(id);
	for (kv in this.resourceKeyToHandle)
	{
		if (kv.value.id == id)
		{
			key := kv.key~;
			this.resourceKeyToHandle.Remove(key);
			delete key;
			break;
		}
	}
}

ResourceHandle ResourceManager::LoadResource(param: ParamType, onLoad: ::(ResourceHandle))
{
	resourceKey := this.getResourceKey(param);

	if (this.resourceKeyToHandle.Has(resourceKey))
	{
		handle := this.resourceKeyToHandle[resourceKey]~;
		onLoad(handle);
		return handle;
	}

	handleValue := this.resources.GetNext();

	handle := ResourceHandle();
	handle.id = handleValue.handle;
	handle.manager = this.id;

	this.resourceKeyToHandle.Insert(resourceKey, handle);

	resource := handleValue.value;
	resource~ = Resource<Type>();
	resource.result = ResourceResult.Loading;

	resourceParam := AllocThreadParam<ResourceParam<Type, ParamType>>();
	resourceParam.key = resourceKey;
	resourceParam.manager = this@;
	resourceParam.onLoad = onLoad;
	resourceParam.param = param;
	resourceParam.handle = handle;

	resourceParam.onResourceLoad = ::(param: *ResourceParam<Type,ParamType>, result: ResourceResult) {
		defer DeallocThreadParam<ResourceParam<Type, ParamType>>(param);

		handle := param.handle;
		resourceManager := param.manager;

		resource := resourceManager.GetResource(handle);
		resource.result = result;
		
		param.onLoad(handle);
	};

	this.loader(resourceParam);

	return handle;
}

ref Resource<Type> ResourceManager::GetResource(handle: ResourceHandle)
{
    resource := this.resources[handle.id];
	return resource~;
}

ref Resource<Type> ResourceManager::TakeResourceRef(handle: ResourceHandle)
{
    resource := this.resources[handle.id];
	resource.refCount += 1;
	return resource~;
}

ResourceManager::ReleaseResourceRef(handle: ResourceHandle)
{
    id := handle.id;
    if (!this.resources.Has(id)) return;

    resource := this.resources[id];
	resource.refCount -= 1;
    if (resource.refCount <= 0)
    {
		if (resource.parent.id) ChildResourceReleased(resource.parent, handle);
        this.RemoveResource(handle);
    }
}

resourceManagers := Map<uint32, *ResourceManager<any, any>>();

ResourceManager<ResourceType, ParamType> CreateResourceManager<ResourceType, ParamType>(
		name: [4]byte
		getResourceKey: ::string(ParamType), 
		loader: ::(*ResourceParam<ResourceType, ParamType>),
		onRelease: ::(ResourceHandle) = null,
		onChildRelease: ::(ResourceHandle, ResourceHandle) = null,
	)
{
	id := ((fixed name) as *uint32)~;
	assert id, "Resource manager name can be not null";

	resourceManager := ResourceManager<ResourceType, ParamType>();
	resourceManager.id = id;
	resourceManager.getResourceKey = getResourceKey;
	resourceManager.loader = loader;
	resourceManager.onRelease = onRelease;
	resourceManager.onChildRelease = onChildRelease;

	return resourceManager;
}

uint32 RegisterResourceManager(resourceManager: *ResourceManager<any, any>)
{
	id := resourceManager.id;
	resourceManagers.Insert(id, resourceManager);
	return id;
}

ref Resource<Type> GetResource<Type>(handle: ResourceHandle)
{
	resourceManager := resourceManagers[handle.manager]~ as *ResourceManager<Type, any>;
	return resourceManager.GetResource(handle);
}

ref Resource<Type> TakeResourceRef<Type>(handle: ResourceHandle)
{
	resourceManager := resourceManagers[handle.manager]~ as *ResourceManager<Type, any>;
	return resourceManager.TakeResourceRef(handle);
}

ReleaseResourceRef(handle: ResourceHandle)
{
	resourceManager := resourceManagers[handle.manager]~;
	resourceManager.ReleaseResourceRef(handle);
}

ChildResourceReleased(handle: ResourceHandle, child: ResourceHandle)
{
	resourceManager := resourceManagers[handle.manager]~;
	if (resourceManager.onChildRelease) resourceManager.onChildRelease(handle, child);
}
