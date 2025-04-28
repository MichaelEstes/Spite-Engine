package Fiber

import Array
import Thread
import SystemInfo
import Queue
import Atomic
import SpinLock

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

NoOpJob := {::(data: *any) {return;}, null} as Job;

state Fibers
{
	threads: Array<uint>,

	jobsHigh := Array<Queue<Job>>(),
	jobsMedium := Array<Queue<Job>>(),
	jobsLow := Array<Queue<Job>>(),
	
	locks := Array<SpinLock>(),

	mainThread: uint,
	jobsMain := Queue<Job>(),

	currentProcess := Atomic<uint32>(),
	processCount: uint32,
}

fibers: *Fibers = null;

InitalizeFibers()
{
	fibers = new Fibers();

	sysInfo := GetSystemInfo()
	fibers.processCount = Math.Max(sysInfo.processorCount - 2, 1);
	
	for (i .. fibers.processCount)
	{
		fibers.jobsHigh.Add(Queue<Job>());
		fibers.jobsMedium.Add(Queue<Job>());
		fibers.jobsLow.Add(Queue<Job>());
		fibers.locks.Add(SpinLock());
		thread := CreateFiberThread(i);
		fibers.threads.Add(thread);
	}
	
	fibers.mainThread = CreateMainFiber();
}

AddJob(func: ::(*any), data: *any = null, priority: JobPriority = JobPriority.Medium)
{
	job := {func, data} as Job;
	index := fibers.currentProcess.Add(1) % fibers.processCount;
	fibers.locks[index].Lock();
	switch (priority)
	{
		case (JobPriority.High) fibers.jobsHigh[index].Enqueue(job);
		case (JobPriority.Medium) fibers.jobsMedium[index].Enqueue(job);
		case (JobPriority.Low) fibers.jobsLow[index].Enqueue(job);
	}
	fibers.locks[index].Unlock();
}

uint CreateMainFiber()
{
	thread := Thread.Create(::int32(data: *void) {
		RunMainFiber();
		return 0;
	});

	return thread;
}

uint CreateFiberThread(index: uint)
{
	thread := Thread.Create(::int32(index: *void) {
		RunFiber(index as uint);
		return 0;
	}, index as *void);

	return thread;
}

RunMainFiber()
{
	//log "Starting main fiber thread: ", GetCurrentThreadID();
	while (true)
	{
		if (fibers.jobsMain.count)
		{
			job := fibers.jobsMain.Dequeue();
			job.func(job.data);
		}
	}
}

Job GetNextJob(index: uint)
{
	job := NoOpJob~;

	fibers.locks[index].Lock();
	if (fibers.jobsHigh[index].count)
	{
		job = fibers.jobsHigh[index].Dequeue();
	}
	else if (fibers.jobsMedium[index].count)
	{
		job = fibers.jobsMedium[index].Dequeue();
	}
	else if (fibers.jobsLow[index].count)
	{
		job = fibers.jobsLow[index].Dequeue();
	}
	fibers.locks[index].Unlock();

	return job;
}

RunFiber(index: uint)
{
	//log "Starting fiber thread", index;
	while (true)
	{
		job := GetNextJob(index);
		job.func(job.data);
	}
}
