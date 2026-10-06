package Resource

state ResourceArg<ArgType>
{
	manager: *ResourceManager<ArgType>,
	arg: *ArgType,
	key: ResourceKey,
	handle: ResourceHandle,
}

state ResourceOrSubresource<Type>
{
    val: ?{
        resource: Resource<Type>,
        subResource: SubResource<Type>
    }
}

state ResourceManager<ArgType>
{
    resourceKeyToHandle := Map<ResourceKey, ResourceHandle, HashResourceKey, ResourceKeyEquals>(),
    resources := Map<*_Type, UntypedHandleSet>(),

    deleteCallbacks := Map<*_Type, ::(*any)>(),
    keyCallbacks := Map<*_Type, ::ResourceKey(*any)>(),
    loadCallbacks := Map<*_Type, ::(*ResourceArg<any>, *ResourceOrSubresource<any>)>(),

    getResourceType: ::*_Type(*ArgType),
	onRelease: ::(ResourceHandle),

	id: uint32
}

ResourceManager::RegisterResourceType<Type>(
    createKey: ::ResourceKey(*any),
    load: ::(*ResourceArg<any>, *Resource<Type>)
)
{
    type := #typeof Type;
    resourceTypeSize := #sizeof Resource<Type>;

    this.resources.Insert(type, UntypedHandleSet(resourceTypeSize));
    this.deleteCallbacks.Insert(type, ::(valPtr: *Type) {
        delete valPtr~;
    });
    this.keyCallbacks.Insert(type, createKey);
    this.loadCallbacks.Insert(type, load);
}

ResourceManager::RegisterSubResourceType<Type>(
    createKey: ::ResourceKey(*any),
    load: ::(*ResourceArg<any>, *SubResource<Type>)
)
{
    type := #typeof Type;

    this.deleteCallbacks.Insert(type, ::(valPtr: *Type) {
        delete valPtr~;
    });
    this.keyCallbacks.Insert(type, createKey);
    this.loadCallbacks.Insert(type, load);
}

ResourceHandle ResourceManager::LoadResource(arg: ArgType)
{
    resourceType := this.getResourceType(arg@);
    assert this.keyCallbacks.Has(resourceType), "Create key function missing for type";
    assert this.resources.Has(resourceType), "Resources set missing for type";
    assert this.loadCallbacks.Has(resourceType), "Load callback missing for type";

    createKeyFunc := this.keyCallbacks.Find(resourceType)~;
	resourceKey := createKeyFunc(arg@);

    if (this.resourceKeyToHandle.Has(resourceKey))
    {
        handle := this.resourceKeyToHandle.Find(resourceKey)~;
        delete resourceKey;
        return handle;
    }

    resourceSet := this.resources.Find(resourceType);
    resourceHandleValue := resourceSet.GetNext();

    resource := resourceHandleValue.value as *Resource<any>;
    resource~ = Resource<any>();
    resource.key = resourceKey;
    resource.refCount = Atomic<uint32>(0);
    resource.result = ResourceResult.Loading;

    handle := ResourceHandle();
    handle.type = resourceType;
	handle.id = resourceHandleValue.handle;
	handle.manager = this.id;

    resourceArg := ResourceArg<ArgType>();
    resourceArg.manager = this@;
    resourceArg.arg = arg@;
    resourceArg.key = resourceKey;
    resourceArg.handle = handle;

    loadFunc := this.loadCallbacks.Find(resourceType)~;
    loadFunc(resourceArg@, resource as *ResourceOrSubresource<any>);

    this.resourceKeyToHandle.Insert(resourceKey, handle);

    return handle;
}

*Resource<Type> ResourceManager::GetResource<Type>(handle: ResourceHandle)
{
    if (!this.resources.Has(handle.type)) return null;

    resources := this.resources[handle.type];
    if (!resources.Has(handle.id)) return null;

    return resources.Get(handle.id) as *Resource<Type>;
}

*Resource<Type> ResourceManager::ReferenceResource<Type>(handle: ResourceHandle)
{
    resource := this.GetResource<Type>(handle);
    if (resource) resource.refCount.Add(1);
    return resource;
}

ResourceManager::DeleteResource(type: *_Type, val: *any)
{
    if (this.deleteCallbacks.Has(type))
    {
        deleteCallback := this.deleteCallbacks[type]~;
        deleteCallback(val);
    }
}

ResourceManager::ReleaseResource(handle: ResourceHandle)
{
    assert !handle.parent.Valid(), "A sub-resource cannot be released";

    id := handle.id;
    type := handle.type;

    if (!this.resources.Has(type)) return;

    resources := this.resources[type]; 
    resource := resources.Get(id) as *Resource<any>;
    if (!resource) return;

    if (resource.refCount.Sub(1) == 1)
    {
        if (this.onRelease) this.onRelease(handle);

        resourceKey := resource.key;
        this.DeleteResource(type, resource.data@);
        
        resources.Remove(id);
        this.resourceKeyToHandle.Remove(resourceKey);

        for (kv in resource.subResources)
        {
            subResourceType := kv.key~;
            for (handleValue in kv.value)
            {
                subResource := handleValue.value as *SubResource<any>;
                this.DeleteResource(subResourceType, subResource.data@);
            }
        }

        for (kv in resource.subResourceToHandle)
        {
            subResourceMap := kv.value~;

            for (handleKV in subResourceMap)
            {
                key := handleKV.key~;
                handle := handleKV.value;
                if (handle.manager != this.id)
                {
                    ReleaseResourceRef(handle~);
                }
                else
                {
                    delete key;
                }
            }

            delete subResourceMap;
        }
        resource.subResources.DeleteValues();
        delete resource.subResourceToHandle;
        delete resource.subResources;
    }
}

ResourceHandle ResourceManager::CreateSubResource<Type>(parent: ResourceHandle, arg: *any)
{
    subResourceType := #typeof Type;
    subResourceSize := #sizeof SubResource<Type>;
    assert this.keyCallbacks.Has(subResourceType), "Create key function missing for subresource type";
    assert this.loadCallbacks.Has(subResourceType), "Load callback missing for subresource type";

    parentResource := this.GetResource<any>(parent);

    if (!parentResource.subResourceToHandle.Has(subResourceType))
    {
        parentResource.subResourceToHandle.Insert(subResourceType, Map<ResourceKey, ResourceHandle, HashResourceKey, ResourceKeyEquals>());
        parentResource.subResources.Insert(subResourceType, UntypedHandleSet(subResourceSize));
    }

    subResourceHandleMap := parentResource.subResourceToHandle.Find(subResourceType);

    createKeyFunc := this.keyCallbacks.Find(subResourceType)~;
	subResourceKey := createKeyFunc(arg);

    if (subResourceHandleMap.Has(subResourceKey))
    {
        handle := subResourceHandleMap.Find(subResourceKey)~;
        delete subResourceKey;
        return handle;
    }

    subResourceSet := parentResource.subResources.Find(subResourceType);
    resourceHandleValue := subResourceSet.GetNext();

    subResource := resourceHandleValue.value as *SubResource<Type>;
    subResource~ = SubResource<Type>();
    subResource.key = subResourceKey;

    handle := ResourceHandle();
    handle.type = subResourceType;
	handle.id = resourceHandleValue.handle;
	handle.manager = this.id;
    handle.parent.type = parent.type;
    handle.parent.id = parent.id;

    resourceArg := ResourceArg<any>();
    resourceArg.manager = this@;
    resourceArg.arg = arg;
    resourceArg.key = subResourceKey;
    resourceArg.handle = handle;

    loadFunc := this.loadCallbacks.Find(subResourceType)~;
    loadFunc(resourceArg@, subResource as *ResourceOrSubresource<Type>);

    subResourceHandleMap.Insert(subResourceKey, handle);

    return handle;
}

*SubResource<Type> ResourceManager::GetSubResource<Type>(handle: ResourceHandle)
{
    parent := ResourceHandle();
    parent.type = handle.parent.type;
    parent.id = handle.parent.id;

    parentResource := this.GetResource<any>(parent);
    if (!parentResource) return null;
    if (!parentResource.subResources.Has(handle.type)) return null;

    subResources := parentResource.subResources[handle.type];
    if (!subResources.Has(handle.id)) return null;

    return subResources.Get(handle.id) as *SubResource<Type>;
}

ResourceManager::AddSubResource(parent: ResourceHandle, dependency: ResourceHandle)
{
    dependencyType := dependency.type;

    parentResource := this.GetResource<any>(parent);
    dependencyResource := GetResource<any>(dependency);

    dependencyKey := dependencyResource.key;

    if (!parentResource.subResourceToHandle.Has(dependencyType))
    {
        parentResource.subResourceToHandle.Insert(dependencyType, Map<ResourceKey, ResourceHandle, HashResourceKey, ResourceKeyEquals>());
    }

    subResourceHandleMap := parentResource.subResourceToHandle.Find(dependencyType);

    if (subResourceHandleMap.Has(dependencyKey)) return;

    TakeResourceRef<any>(dependency);
    subResourceHandleMap.Insert(dependencyKey, dependency);
}

bool ResourceManager::ResourceHasReference(handle: ResourceHandle)
{
	resource := this.GetResource<any>(handle);
    return resource.refCount.Load();
}
