package Fiber

import Array
import Thread
import SystemInfo
import Queue
import Atomic
import SpinLock

enum JobPriority: byte
{
	High,
	Medium,
	Low
}

state JobHandle
{
	counter: Atomic<uint32>
}

state Job
{
	func: ::(*any),
	data: *any,
	handle: *JobHandle
}

state Fibers
{
	threads: Array<uint>,

	// Jobs indexed by priority
	jobs := [Array<Queue<Job>>(), Array<Queue<Job>>(), Array<Queue<Job>>()],
	
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
	// - 3, executable start thread, main fiber thread, IO thread
	fibers.processCount = Math.Max(sysInfo.processorCount - 3, 1);
	
	for (i .. fibers.processCount)
	{
		for (jobArr in fibers.jobs)
		{
			jobArr.Add(Queue<Job>());
		}

		fibers.locks.Add(SpinLock());

		thread := CreateFiberThread(i);
		fibers.threads.Add(thread);
	}
	
	fibers.mainThread = CreateMainFiber();
}

AddJob(func: ::(*any), data: *any = null, priority: JobPriority = JobPriority.Medium, handle: *JobHandle = null)
{
	if (handle)
	{
		handle.counter = Atomic<uint32>(1);
	}

	job := {func, data, handle} as Job;

	index := fibers.currentProcess.Add(1) % fibers.processCount;
	
	fibers.locks[index].Lock();
	{
		fibers.jobs[priority][index].Enqueue(job);
	}
	fibers.locks[index].Unlock();
}

WaitForJob(handle: *JobHandle)
{
	currThread := GetCurrentThreadID();

	// Waiting for a job on a fiber thread, continue running jobs
	for (i .. fibers.processCount)
	{
		thread := fibers.threads[i];
		if (currThread == thread)
		{
			while (handle.counter.Load(MemoryOrder.Acquire) != 0)
			{
				RunNext(i);
			}
		}
	}

	// Waiting on a non fiber thread, spin. Add sleep here?
	while (handle.counter.Load(MemoryOrder.Acquire) != 0) {}
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
	job := Job();

	fibers.locks[index].Lock();
	{
		for (jobArr in fibers.jobs)
		{
			jobQueue := jobArr[index];
			if (jobQueue.count)
			{
				job = jobQueue.Dequeue();
				break;
			}
		}
	}
	fibers.locks[index].Unlock();

	return job;
}

RunNext(index: uint) =>
{
	job := GetNextJob(index);
	if (job.func)
	{
		job.func(job.data);
		if (job.handle)
		{
			job.handle.counter.Sub(uint32(1));
		}
	}
}

RunFiber(index: uint)
{
	//log "Starting fiber thread", index;
	while (true)
	{
		RunNext(index);
	}
}
