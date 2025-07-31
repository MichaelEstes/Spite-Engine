package Semaphore
import SDL

state Semaphore
{
	value: *SDL.Semaphore
}

Semaphore::()
{
	this.value = SDL.CreateSemaphore(0);
}

Semaphore::(value: uint32)
{
	this.value = SDL.CreateSemaphore(value);
}

Semaphore::delete
{
	SDL.DestroySemaphore(this.value);
}

uint32 Semaphore::Value() => SDL.GetSemaphoreValue(this.value);
Semaphore::Signal() => SDL.LockMutex(this.value);
Semaphore::Wait() => SDL.WaitSemaphore(this.value);
bool Semaphore::TryWait() => SDL.TryWaitSemaphore(this.value);
bool Semaphore::TryWait(timeout: uint32) => SDL.WaitSemaphoreTimeout(this.value, timeout);