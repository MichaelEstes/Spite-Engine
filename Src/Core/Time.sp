package Time

extern
{
	#link windows "kernel32";

	bool QueryPerformanceFrequency(frequency: *int64);
	bool QueryPerformanceCounter(performanceCount: *int64);
}

extern
{
	#link linux "libc";

	int32 clock_gettime(clk_id: int32, timespec: *TimeSpec);
	int32 clock_getres(clk_id: int32, timespec: *TimeSpec);
}

CLOCK_MONOTONIC := int32(1);
state TimeSpec
{
    tv_sec: int64,   // seconds
    tv_nsec: int64   // nanoseconds
}

frequency: int64 = 0;
startTime: int64 = 0;

InitializeTimeWindows()
{
	QueryPerformanceFrequency(frequency@);
	QueryPerformanceCounter(startTime@);
}

InitializeTimeLinux()
{
	frequency = 1000000000;
    
    spec := TimeSpec();
    clock_gettime(CLOCK_MONOTONIC, spec@);
    startTime = (spec.tv_sec * frequency) + spec.tv_nsec;
}

InitializeTime()
{
	init := #compile ::() 
	{
		if(targetOs == OS_Kind.Windows) return InitializeTimeWindows;
		else return InitializeTimeLinux;
	}

	init();
}


int64 TicksWindows()
{
	ticks := int64(0);
	QueryPerformanceCounter(ticks@);
	return ticks;
}

int64 TicksLinux()
{
	spec := TimeSpec();
    clock_gettime(CLOCK_MONOTONIC, spec@);
    return (spec.tv_sec * frequency) + spec.tv_nsec;
}

int64 Ticks()
{
	get := #compile ::int64() 
	{
		if(targetOs == OS_Kind.Windows) return TicksWindows;
		else return TicksLinux;
	}

	return get();
}

int64 TicksSinceStart()
{
	ticks := Ticks() - startTime;
	seconds := ticks / frequency;
	rem := ticks % frequency;
	
	res := (rem * 1000000) / frequency;
	res += seconds * 1000000;
	return res;
}

float64 SecondsSinceStart()
{
	ticks := Ticks();
	return (ticks - startTime) / frequency as float64;
}


