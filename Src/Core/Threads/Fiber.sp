package Fiber

import Array
import Thread
import SystemInfo
import Queue
import Atomic
import SpinLock
import SlabAllocator

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
	threadIDs: Array<uint32>,

	// Jobs indexed by priority
	jobs := [Array<Queue<Job>>(), Array<Queue<Job>>(), Array<Queue<Job>>()],
	
	locks := Array<SpinLock>(),

	mainThread: uint,
	jobsMain := Queue<Job>(),

	handleAllocator: SlabAllocator,

	currentProcess := Atomic<uint32>(),
	processCount: uint32,

	mainLock := SpinLock(),
	running := true
}

fibers: *Fibers = null;

InitalizeFibers()
{
	fibers = new Fibers();

	sysInfo := GetSystemInfo();
	// - 2, executable start thread, main (IO) fiber thread
	fibers.processCount = Math.Max(sysInfo.processorCount - 2, 1);
	fibers.handleAllocator = SlabAllocator(#sizeof JobHandle, 32, fibers.processCount);

	for (i .. fibers.processCount)
	{
		for (jobArr in fibers.jobs)
		{
			jobArr.Add(Queue<Job>());
		}

		fibers.locks.Add(SpinLock());

		fibers.threadIDs.Add(0);
		thread := CreateFiberThread(i);
		fibers.threads.Add(thread);
	}
	
	fibers.mainThread = CreateMainFiber();
}

*JobHandle CreateJobHandle(count: uint32)
{
	handle := fibers.handleAllocator.Alloc() as *JobHandle;
	assert handle != null, "Failed to allocate job handle";

	handle.counter = Atomic<uint32>(count);
	return handle;
}

DeallocJobHandle(handle: *JobHandle)
{
	fibers.handleAllocator.Dealloc(handle);
}

AddJob(func: ::(*any), data: *any = null, priority: JobPriority = JobPriority.Medium, handle: **JobHandle = null)
{
	job := {func, data, null} as Job;
	if (handle)
	{
		job.handle = CreateJobHandle(1);
		handle~ = job.handle;
	}

	index := fibers.currentProcess.Add(1) % fibers.processCount;
	
	fibers.locks[index].Lock();
	{
		fibers.jobs[priority][index].Enqueue(job);
	}
	fibers.locks[index].Unlock();
}

AddJobs(funcs: []::(*any), data: []*any, priority: JobPriority = JobPriority.Medium, handle: **JobHandle = null)
{
	count := funcs.count;
	jobHandle: *JobHandle = null;
	if (handle)
	{
		jobHandle = CreateJobHandle(count);
		handle~ = jobHandle;
	}	

	for (i .. count)
	{
		func := funcs[i];
		data := data[i];
		job := {func, data, jobHandle} as Job;

		index := fibers.currentProcess.Add(1) % fibers.processCount;

		fibers.locks[index].Lock();
		{
			fibers.jobs[priority][index].Enqueue(job);
		}
		fibers.locks[index].Unlock();	
	}
}

WaitForHandle(handle: *JobHandle)
{
	assert handle != null, "Cannot wait for a null handle";

	currThread := GetCurrentThreadID();
	
	for (i .. fibers.processCount)
	{
		thread := fibers.threadIDs[i];
		
		// Waiting for a job on a fiber thread, continue running jobs
		if (currThread == thread)
		{
			while (handle.counter.Load() != 0)
			{
				RunNext(i);
			}
			DeallocJobHandle(handle);
			return;
		}
	}

	// Waiting on a non fiber thread, spin
	while (handle.counter.Load() != 0) {}
	DeallocJobHandle(handle);
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
	threadID := fibers.threadIDs[index]@;
	thread := Thread.Create(::int32(index: *void) {
		RunFiber(index as uint);
		return 0;
	}, index as *void, threadID);

	return thread;
}

RunMainFiber()
{
	//log "Starting main fiber thread: ", GetCurrentThreadID();
	
	while (fibers.running)
	{
		job := Job();
		fibers.mainLock.Lock();
		{
			if (fibers.jobsMain.count)
			{
				job = fibers.jobsMain.Dequeue();
			}
		}
		fibers.mainLock.Unlock();	
		
		if (job.func)
		{
			job.func(job.data);
		}
	}
}

RunOnMainFiber(func: ::(*any), data: *any)
{
	job := Job();
	job.func = func;
	job.data = data;

	fibers.mainLock.Lock();
	{
		fibers.jobsMain.Enqueue(job);
	}
	fibers.mainLock.Unlock();	
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

RunNext(index: uint)
{
	job := GetNextJob(index);
	if (job.func)
	{
		job.func(job.data);
		if (job.handle)
		{
			job.handle.counter.Sub(uint32(1), MemoryOrder.Relaxed);
		}
	}
}

RunFiber(index: uint)
{
	//log "Starting fiber thread", index;
	
	while (fibers.running)
	{
		RunNext(index);
	}
}
