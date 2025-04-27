package Thread

extern
{
	#link windows "kernel32";

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

state WinSecurityAttributes
{
	nLength: uint32,
	lpSecurityDescriptor: *void,
	bInheritHandle: bool
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