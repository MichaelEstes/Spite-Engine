package Fiber

import Thread
import SystemInfo
import Queue

enum JobPriority
{
	High,
	Medium,
	Low
}

state Job
{
	func: ::(*any),
	data: *any
}

state Fibers
{
	threads: []uint,
	jobsHigh := Queue<Job>(),
	jobsMedium := Queue<Job>(),
	jobsLow := Queue<Job>(),

	mainThread: uint,
	jobsMain := Queue<Job>()
}

fibers: *Fibers = null;

InitalizeFibers()
{
	fibers = new Fibers();

	processCount := Math.Max(GetSystemInfo().processorCount as int - 1, 1);

	for (i .. processCount)
	{
		thread := CreateFiberThread();
		fibers.threads.Add(thread);
	}

	fibers.mainThread = CreateMainFiber();
}

uint CreateMainFiber()
{
	thread := Thread.Create(::int32(data: *void) {
		RunMainFiber();
		return 0;
	});

	return thread;
}

RunMainFiber()
{
	log "Starting main fiber thread: ", GetCurrentThreadID();
	while (true)
	{
		if (fibers.jobsMain.count)
		{
			job := fibers.jobsMain.Dequeue();
			job.func(job.data);
		}
	}
}

uint CreateFiberThread()
{
	thread := Thread.Create(::int32(data: *void) {
		RunFiber();
		return 0;
	});

	return thread;
}

Job GetNextJob()
{
	if (fibers.jobsHigh.count)
	{
		fibers.jobsHigh.Dequeue();
	}
	else if (fibers.jobsMedium.count)
	{
		fibers.jobsMedium.Dequeue();
	}
	else if (fibers.jobsLow.count)
	{
		fibers.jobsLow.Dequeue();
	}

	return Job();
}

RunFiber()
{
	log "Starting fiber thread", GetCurrentThreadID();
	while (true)
	{
		job := GetNextJob();
		if (job.func)
		{
			job.func(job.data);
		}
	}
}
