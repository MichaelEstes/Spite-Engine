package Fiber

import Array
import Thread
import SystemInfo
import Queue
import Atomic
import BucketAllocator
import Mutex

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
	locks := Array<Mutex>(),

	handleAllocator: BucketAllocator,

	currentProcess := Atomic<uint32>(0),
	processCount: uint32,

	running := true
}

fibers: *Fibers = null;

InitalizeFibers()
{
	fibers = new Fibers();

	sysInfo := GetSystemInfo();
	// - 2, executable start thread, main (IO) fiber thread
	fibers.processCount = Math.Max(sysInfo.processorCount - 2, 1);
	totalProcessCount := fibers.processCount + 1;
	fibers.handleAllocator = BucketAllocator(#sizeof JobHandle, 32, totalProcessCount);

	for (i .. totalProcessCount)
	{
		for (jobArr in fibers.jobs)
		{
			jobArr.Add(Queue<Job>());
		}

		fibers.locks.Add(Mutex());

		fibers.threadIDs.Add(0);
		thread := CreateFiberThread(i);
		fibers.threads.Add(thread);
	}
}

*JobHandle CreateJobHandle(count: uint32)
{
	handle := fibers.handleAllocator.Alloc() as *JobHandle;
	assert handle != null, "Failed to allocate job handle";
	
	handle.counter = Atomic<uint32>(count);
	return handle;
}

*JobHandle GetJobHandle(count: uint32, handleRef: **JobHandle)
{
	if (!handleRef) return null;

	handle := handleRef~;
	if (handle)
	{
		handle.counter.Add(count);
		return handle;
	}

	createdHandle := CreateJobHandle(count);
	handleRef~ = createdHandle;
	return createdHandle;
}

DeallocJobHandle(handle: *JobHandle)
{
	fibers.handleAllocator.Dealloc(handle);
}

AddJobForIndex(job: Job, priority: JobPriority, index: uint32)
{
	fibers.locks[index].Lock();
	{
		fibers.jobs[priority][index].Enqueue(job);
	}
	fibers.locks[index].Unlock();
}

AddJob(func: ::(*any), data: *any = null, handle: **JobHandle = null, priority: JobPriority = JobPriority.Medium)
{
	jobHandle := GetJobHandle(1, handle);
	job := {func, data, jobHandle} as Job;

	index := fibers.currentProcess.Add(1) % fibers.processCount;
	
	AddJobForIndex(job, priority, index);
}

AddJobs(funcs: []::(*any), data: []*any, handle: **JobHandle = null, priority: JobPriority = JobPriority.Medium)
{
	count := funcs.count;
	jobHandle := GetJobHandle(count, handle);

	for (i .. count)
	{
		func := funcs[i];
		dataItem := data[i];
		job := {func, dataItem, jobHandle} as Job;

		index := fibers.currentProcess.Add(1) % fibers.processCount;

		AddJobForIndex(job, priority, index);
	}
}

WaitForHandle(handle: *JobHandle)
{
	assert handle != null, "Cannot wait for a null handle";

	defer DeallocJobHandle(handle);

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
			return;
		}
	}

	// Waiting on a non fiber thread, spin
	while (handle.counter.Load() != 0) {}
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

RunOnMainFiber(func: ::(*any), data: *any, handle: **JobHandle = null, priority: JobPriority = JobPriority.Medium)
{
	mainIndex := fibers.threads.count - 1;
	jobHandle := GetJobHandle(1, handle);
	job := {func, data, jobHandle} as Job;

	AddJobForIndex(job, priority, mainIndex);
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
			job.handle.counter.Sub(1);
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
