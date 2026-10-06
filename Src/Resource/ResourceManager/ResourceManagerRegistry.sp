package Resource

resourceManagers := Map<uint32, *ResourceManager<any>>();

*ResourceManager<ArgType> CreateResourceManager<ArgType>(
		name: [4]byte,
		initializeTypes: ::(*ResourceManager<ArgType>),
		getResourceType: ::*_Type(*ArgType),
		onRelease: ::(ResourceHandle) = null
	)
{
	id := ((fixed name) as *uint32)~;
	assert id, "Resource manager name can be not null";

	resourceManager := new ResourceManager<ArgType>();
	resourceManager.id = id;
	resourceManager.getResourceType = getResourceType;
	resourceManager.onRelease = onRelease;

	initializeTypes(resourceManager);

	resourceManagers.Insert(id, resourceManager as *ResourceManager<any>);

	return resourceManager;
}

*Resource<Type> GetResource<Type>(handle: ResourceHandle)
{
	resourceManager := resourceManagers[handle.manager]~;
	return resourceManager.GetResource<Type>(handle);
}

*Resource<Type> TakeResourceRef<Type>(handle: ResourceHandle)
{
	resourceManager := resourceManagers[handle.manager]~;
	return resourceManager.ReferenceResource<Type>(handle);
}

ReleaseResourceRef(handle: ResourceHandle)
{
	resourceManager := resourceManagers[handle.manager]~;
	resourceManager.ReleaseResource(handle);
}

ResourceHandle CreateSubResource<Type>(parent: ResourceHandle, arg: *any)
{
	resourceManager := resourceManagers[parent.manager]~;
	return resourceManager.CreateSubResource<Type>(parent, arg);
}

AddSubResource(parent: ResourceHandle, dependency: ResourceHandle)
{
	resourceManager := resourceManagers[parent.manager]~;
	resourceManager.AddSubResource(parent, dependency);
}

bool ResourceHasReference(handle: ResourceHandle)
{
	if (!handle.Valid()) return false;
	resourceManager := resourceManagers[handle.manager]~;
	return resourceManager.ResourceHasReference(handle);
}