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
	return 0;
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

uint32 WaitThreadWin(thread: *void)
{
	return WaitForSingleObject(thread, uint32(-1));
}

uint32 WaitThreadLinux(thread: *void)
{
	return 0;
}

uint32 Wait(thread: uint) 
{
	wait := #compile ::uint32(*void) 
	{
		if(targetOs == OS_Kind.Windows) return WaitThreadWin;
		else return WaitThreadLinux;
	}

	return wait(thread as *void);
}

uint32 GetCurrentThreadIDWin()
{
	return GetCurrentThreadId();
}

uint32 GetCurrentThreadIDLinux()
{
	return 0;
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