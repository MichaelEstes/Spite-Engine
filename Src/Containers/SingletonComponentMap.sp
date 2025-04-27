package SingletonComponentMap

import Arena

state SingletonComponentMap
{
	typePtrMap := Map<*_Type, *void>(),
	arena := Arena()
}

SingletonComponentMap::delete
{
	delete this.typePtrMap;
	delete this.arena;
}

SingletonComponentMap::Insert<Type>(value: Type)
{
	type := #typeof Type;
	if (this.typePtrMap.Has(type))
	{
		valuePtr := this.typePtrMap[type]~ as *Type;
		valuePtr~ = value;
		return;
	}
	
	valuePtr := this.arena.Insert<Type>(value);
	this.typePtrMap.Insert(type, valuePtr);
}

*Type SingletonComponentMap::Get<Type>()
{
	type := #typeof Type;
	return this.typePtrMap[type]~;
}