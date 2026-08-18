package Time

extern
{
	#link windows "kernel32";

	bool QueryPerformanceFrequency(frequency: *int64);
	bool QueryPerformanceCounter(performanceCount: *int64);
	
	void Sleep(dwMilliseconds: uint32) as WinSleep;
}

extern
{
	#link linux "libc";

	int32 clock_gettime(clk_id: int32, timespec: *TimeSpec);
	int32 clock_getres(clk_id: int32, timespec: *TimeSpec);

	int32 nanosleep(req: *TimeSpec, rem: *TimeSpec);
}

CLOCK_MONOTONIC := int32(1);
state TimeSpec
{
    tv_sec: int64,   // seconds
    tv_nsec: int64   // nanoseconds
}

Frequency: int64 = 0;
StartTime: int64 = 0;

InitializeTimeWindows()
{
	QueryPerformanceFrequency(Frequency@);
	QueryPerformanceCounter(StartTime@);
}

InitializeTimeLinux()
{
	Frequency = 1000000000;
    
    spec := TimeSpec();
    clock_gettime(CLOCK_MONOTONIC, spec@);
    StartTime = (spec.tv_sec * Frequency) + spec.tv_nsec;
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

int64 TimeNow()
{
	timeNow := #compile ::int64() 
	{
		if(targetOs == OS_Kind.Windows) return ::int64() => {
			time: int64 = 0;
			QueryPerformanceCounter(time@);
			return time;
		};
		else return ::int64() => {
			spec := TimeSpec();
			clock_gettime(CLOCK_MONOTONIC, spec@);
			return (spec.tv_sec * Frequency) + spec.tv_nsec;
		};
	}

	return timeNow();
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
    return (spec.tv_sec * Frequency) + spec.tv_nsec;
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
	ticks := Ticks() - StartTime;
	seconds := ticks / Frequency;
	rem := ticks % Frequency;
	
	res := (rem * 1000000) / Frequency;
	res += seconds * 1000000;
	return res;
}

float64 SecondsSinceStart()
{
	ticks := Ticks();
	return (ticks - StartTime) / Frequency as float64;
}

state Profiler
{
	time: int64
}

Profiler::()
{
	this.time = Ticks();
}

float64 Profiler::End()
{
	ticks := Ticks();
	elapsed := ticks - this.time;
	return (elapsed as float64) / (Frequency as float64);
}


