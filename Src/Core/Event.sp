package Event

import SDL
import SparseSet

SDLEvents := SparseSet<Event.Emitter>();

*Event.Emitter GetGlobalEventEmitter() => SDLEvents.Get(0);
*Event.Emitter GetEventEmitterForWindow(window: *SDL.Window) => SDLEvents.Get(window.id);

currEventID := uint32(0);

// Generic 'Type' here is just for reference of what type to use in the callbacks
uint32 RegisterEvent<Type>()
{
	eventID := currEventID;
	currEventID += 1;
	return eventID;
}

state EventCallback
{
	func: ::(any, *any),
	data: *any
}

EventCallback::(func: ::(any, *any), data: *any)
{
	this.func = func;
	this.data = data;
}

state Emitter
{
	callbacks := SparseSet<[]EventCallback>(),
	onceCallbacks := SparseSet<[]EventCallback>()
}

Emitter::On(id: uint32, callback: ::(any, *any), data: *any = null)
{
	eventCallback := EventCallback(callback, data);

	if (this.callbacks.Has(id))
	{
		this.callbacks.Get(id).Add(eventCallback);
	}
	else
	{
		this.callbacks.Insert(id, [eventCallback,]);
	}
}

Emitter::Once(id: uint32, callback: ::(any, *any), data: *any = null)
{
	eventCallback := EventCallback(callback, data);

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
		for (callback in this.callbacks.Get(id)) (callback.func as ::(Arg, *any))(arg, callback.data);
	}

	if (this.onceCallbacks.Has(id))
	{
		onceArr := this.onceCallbacks.Get(id)~;
		for (callback in onceArr) (callback.func as ::(Arg, *any))(arg, callback.data);
		this.onceCallbacks.Remove(id);
		delete onceArr;
	}
}

Emitter::Remove(id: uint32, callback: ::(any, *any), data: *any = null)
{
	if (this.callbacks.Has(id))
	{
		callbackArr := this.callbacks.Get(id);
		index := 0;
		for (curr in callbackArr)
		{
			if (curr.func == callback && curr.data == data)
			{
				callbackArr.Remove(index);
				return;
			}
			index += 1;
		}
	}
}

Emitter::RemoveOnce(id: uint32, callback: ::(any, *any), data: *any = null)
{
	if (this.onceCallbacks.Has(id))
	{
		callbackArr := this.onceCallbacks.Get(id);
		index := 0;
		for (curr in callbackArr)
		{
			if (curr.func == callback && curr.data == data)
			{
				callbackArr.Remove(index);
				return;
			}
			index += 1;
		}
	}
}