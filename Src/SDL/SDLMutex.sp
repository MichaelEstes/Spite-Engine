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
}

state Mutex
{
	opaque: *void
}

*Mutex CreateMutex() => SDL_CreateMutex();
void DestroyMutex(mutex: *Mutex) => SDL_DestroyMutex(mutex);
void LockMutex(mutex: *Mutex) => SDL_LockMutex(mutex);
bool TryLockMutex(mutex: *Mutex) => SDL_TryLockMutex(mutex);
void UnlockMutex(mutex: *Mutex) => SDL_UnlockMutex(mutex);