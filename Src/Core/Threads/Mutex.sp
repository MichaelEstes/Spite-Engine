package Mutex
import SDL

state Mutex
{
	value: *SDL.Mutex
}

Mutex::()
{
	this.value = SDL.CreateMutex();
}

Mutex::delete
{
	SDL.DestroyMutex(this.value);
}

Mutex::Lock() => SDL.LockMutex(this.value);
bool Mutex::TryLock() => SDL.TryLockMutex(this.value);
Mutex::Unlock() => SDL.UnlockMutex(this.value);