package Event

import SDL
import SparseSet

state Emitter
{
	callbacks := SparseSet<[]::(any)>(),
	onceCallbacks := SparseSet<[]::(any)>()
}

Emitter::On(id: uint32, callback: ::(any))
{
	if (this.callbacks.Has(id))
	{
		this.callbacks.Get(id).Add(callback);
	}
	else
	{
		this.callbacks.Insert(id, [callback,]);
	}
}

Emitter::Once(id: uint32, callback: ::(any))
{
	if (this.onceCallbacks.Has(id))
	{
		this.onceCallbacks.Get(id).Add(callback);
	}
	else
	{
		this.onceCallbacks.Insert(id, [callback,]);
	}
}

Emitter::Emit<Arg>(id: uint32, arg: Arg)
{
	if (this.callbacks.Has(id))
	{
		for (callback in this.callbacks.Get(id)) (callback as ::(Arg))(arg);
	}

	if (this.onceCallbacks.Has(id))
	{
		onceArr := this.onceCallbacks.Get(id)~;
		for (callback in onceArr) (callback as ::(Arg))(arg);
		this.onceCallbacks.Remove(id);
		delete onceArr;
	}
}

Emitter::Remove(id: uint32, callback: ::(any))
{
	if (this.callbacks.Has(id))
	{
		callbackArr := this.callbacks.Get(id);
		index := 0;
		for (curr in callbackArr)
		{
			if (curr == callback)
			{
				callbackArr.Remove(index);
				return;
			}
			index += 1;
		}
	}
}

Emitter::RemoveOnce(id: uint32, callback: ::(any))
{
	if (this.onceCallbacks.Has(id))
	{
		callbackArr := this.onceCallbacks.Get(id);
		index := 0;
		for (curr in callbackArr)
		{
			if (curr == callback)
			{
				callbackArr.Remove(index);
				return;
			}
			index += 1;
		}
	}
}