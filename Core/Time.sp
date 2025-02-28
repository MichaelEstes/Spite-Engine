package Time

extern
{
	#link windows "kernel32";

	bool QueryPerformanceFrequency(frequency: *int64);
	bool QueryPerformanceCounter(performanceCount: *int64);
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
	return int64(0);
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


