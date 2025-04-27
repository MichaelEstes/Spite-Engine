package SystemInfo

extern
{
	#link windows "kernel32";

	void GetSystemInfo(lpSystemInfo: *_SystemInfoWin) as _GetSystemInfoWin;
}

extern
{
    #link linux "libc";

    int32 sysconf(name: int32);
    int32 getpagesize();
}

// Linux sysconf constants
_SC_NPROCESSORS_ONLN: int32 = 84;

state SystemInfo
{
	processorCount: uint32,
	pageSize: uint32
}

state _SystemInfoWin {
	dummy: ?{
		dwOemId: uint32,
		struct: {
			wProcessorArchitecture: uint16,
			wReserved: uint16
		}
	},
	dwPageSize: uint32,
	lpMinimumApplicationAddress: *void,
	lpMaximumApplicationAddress: *void,
	dwActiveProcessorMask: uint,
	dwNumberOfProcessors: uint32,
	dwProcessorType: uint32,
	dwAllocationGranularity: uint32,
	wProcessorLevel: uint16,
	wProcessorRevision: uint16,
}

SystemInfo GetSystemInfoWin()
{
	info := SystemInfo();
	infoWin := _SystemInfoWin();
	_GetSystemInfoWin(infoWin@);
	info.processorCount = infoWin.dwNumberOfProcessors;
	info.pageSize = infoWin.dwPageSize;
	return info;
}

SystemInfo GetSystemInfoLinux()
{
	sysInfo := SystemInfo();
	sysInfo.processorCount = sysconf(_SC_NPROCESSORS_ONLN);
	sysInfo.pageSize = getpagesize();
	return sysInfo;
}

SystemInfo GetSystemInfo()
{
	get := #compile ::SystemInfo() 
	{
		if(targetOs == OS_Kind.Windows) return GetSystemInfoWin;
		else return GetSystemInfoLinux;
	}

	return get();
}