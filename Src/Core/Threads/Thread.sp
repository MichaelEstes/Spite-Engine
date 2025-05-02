package Thread

import Time

extern
{
	#link windows "kernel32";

    void Sleep(dwMilliseconds: uint32) as WinSleep;

	*void CreateThread(
		lpThreadAttributes: *WinSecurityAttributes,
		dwStackSize: uint,
		lpStartAddress: ::uint32(*void),
		lpParameter: *void,
		dwCreationFlags: uint32,
		lpThreadId: *uint32
	) as WinCreateThread;

	uint32 WaitForSingleObject(hHandle: *void, dwMilliseconds: uint32);
	uint32 GetCurrentThreadId();
}

extern
{
	#link linux "libpthread";

	int32 pthread_create(
		thread: *uint32, 
		attr: *void, 
		start_routine: ::uint32(*void), 
		arg: *void
	);
	int32 pthread_join(thread: uint32, value_ptr: **void)
	uint32 pthread_self();
}

extern
{
	#link linux "libc";

	int32 nanosleep(req: *TimeSpec, rem: *TimeSpec);
}

state WinSecurityAttributes
{
	nLength: uint32,
	lpSecurityDescriptor: *void,
	bInheritHandle: bool
}

void SleepWindows(milliseconds: uint32)
{
    WinSleep(milliseconds);
}

void SleepLinux(milliseconds: uint32)
{
    // Convert milliseconds to seconds and nanoseconds
    ts := TimeSpec();
    ts.tv_sec = milliseconds / 1000;
    ts.tv_nsec = (milliseconds % 1000) * 1000000; // Convert remaining ms to ns
    
    nanosleep(ts@, null);
}

void Sleep(milliseconds: uint32)
{
    sleep := #compile ::void(uint32) 
    {
        if(targetOs == OS_Kind.Windows) return SleepWindows;
        else return SleepLinux;
    }
    
    sleep(milliseconds);
}

uint CreateThreadWin(func: ::uint32(*void), data: *void, id: *uint32)
{
	return WinCreateThread(null, 0, func, data, 0, id) as uint;
}

uint CreateThreadLinux(func: ::uint32(*void), data: *void, id: *uint32)
{
	threadId := uint32(0);
	ret := pthread_create(threadId@, null, func, data);
	if (id) id~ = threadId;
	return ret;
}

uint Create(func: ::uint32(*any), data: *any = null, id: *uint32 = null) 
{
	create := #compile ::uint(::int32(*void), *void, *uint32) 
	{
		if(targetOs == OS_Kind.Windows) return CreateThreadWin;
		else return CreateThreadLinux;
	}

	return create(func, data, id);
}

uint32 WaitThreadWin(thread: uint)
{
	return WaitForSingleObject(thread as *void, uint32(-1));
}

uint32 WaitThreadLinux(thread: uint)
{
	return pthread_join(thread, null);
}

uint32 Wait(thread: uint) 
{
	wait := #compile ::uint32(uint) 
	{
		if(targetOs == OS_Kind.Windows) return WaitThreadWin;
		else return WaitThreadLinux;
	}

	return wait(thread);
}

uint32 GetCurrentThreadIDWin()
{
	return GetCurrentThreadId();
}

uint32 GetCurrentThreadIDLinux()
{
	return pthread_self();
}

uint32 GetCurrentThreadID()
{
	get := #compile ::uint32() 
	{
		if(targetOs == OS_Kind.Windows) return GetCurrentThreadIDWin;
		else return GetCurrentThreadIDLinux;
	}

	return get();
}