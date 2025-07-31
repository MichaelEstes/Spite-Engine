package SDL

extern
{
	#link windows "./extern/SDL3";
    #link linux "./extern/libSDL3";

	*Mutex SDL_CreateMutex();
	void SDL_DestroyMutex(mutex: *Mutex);
	void SDL_LockMutex(mutex: *Mutex);
	bool SDL_TryLockMutex(mutex: *Mutex);
	void SDL_UnlockMutex(mutex: *Mutex);

	*Semaphore SDL_CreateSemaphore(init: uint32);
	void SDL_DestroySemaphore(sem: *Semaphore);
	void SDL_SignalSemaphore(sem: *Semaphore);
	void SDL_WaitSemaphore(sem: *Semaphore);
	bool SDL_TryWaitSemaphore(sem: *Semaphore);
	bool SDL_WaitSemaphoreTimeout(sem: *Semaphore, timeout: uint32);
	uint32 SDL_GetSemaphoreValue(sem: *Semaphore);
}

state Mutex
{
	opaque: *void
}

state Semaphore
{
	opaque: *void
}

*Mutex CreateMutex() => SDL_CreateMutex();
void DestroyMutex(mutex: *Mutex) => SDL_DestroyMutex(mutex);
void LockMutex(mutex: *Mutex) => SDL_LockMutex(mutex);
bool TryLockMutex(mutex: *Mutex) => SDL_TryLockMutex(mutex);
void UnlockMutex(mutex: *Mutex) => SDL_UnlockMutex(mutex);

*Semaphore CreateSemaphore(init: uint32) => SDL_CreateSemaphore(init);
void DestroySemaphore(sem: *Semaphore) => SDL_DestroySemaphore(sem);
void SignalSemaphore(sem: *Semaphore) => SDL_SignalSemaphore(sem);
void WaitSemaphore(sem: *Semaphore) => SDL_WaitSemaphore(sem);
bool TryWaitSemaphore(sem: *Semaphore) => SDL_TryWaitSemaphore(sem);
bool WaitSemaphoreTimeout(sem: *Semaphore, timeout: uint32) => SDL_WaitSemaphoreTimeout(sem, timeout);
uint32 GetSemaphoreValue(sem: *Semaphore) => SDL_GetSemaphoreValue(sem);
