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
}

state WinSecurityAttributes
{
	nLength: uint32,
	lpSecurityDescriptor: *void,
	bInheritHandle: bool
}

uint CreateThreadWin(func: ::uint32(*void), data: *void)
{
	return WinCreateThread(null, 0, func, data, 0, null) as uint;
}

uint CreateThreadLinux(func: ::uint32(*void), data: *void)
{
	return 0;
}

uint Create(func: ::uint32(*any), data: *any = null) 
{
	create := #compile ::uint(::int32(*void), *void) 
	{
		if(targetOs == OS_Kind.Windows) return CreateThreadWin;
		else return CreateThreadLinux;
	}

	return create(func, data);
}

int32 WaitThreadWin(thread: *void)
{
	return WaitForSingleObject(thread, uint32(-1));
}

int32 WaitThreadLinux(thread: *void)
{
	return 0;
}

int32 Wait(thread: uint) 
{
	wait := #compile ::uint(*void) 
	{
		if(targetOs == OS_Kind.Windows) return WaitThreadWin;
		else return WaitThreadLinux;
	}

	return wait(thread as *void);
}