package Fiber

import FixedArray
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

JobHandle::(count: uint32)
{
	this.counter.Init(count);
}

bool JobHandle::Finished()
{
	return this.counter.Load() == uint32(0);
}

uint32 JobHandle::Add(count: uint32) => this.counter.Add(count);

uint32 JobHandle::Remove() => this.counter.Sub(1);

state Job
{
	func: ::(*any),
	data: *any,
	handle: *JobHandle
}

state Fibers
{
	threads: FixedArray<uint>,
	threadIDs: FixedArray<uint32>,
	locks: FixedArray<Mutex>,

	// Jobs indexed by priority
	jobs := [FixedArray<Queue<Job>>(), FixedArray<Queue<Job>>(), FixedArray<Queue<Job>>()],
	
	// Jobs to run on the main thread
	mainThreadJobs := Queue<Job>(),
	mainLock := Mutex(),

	handleAllocator: BucketAllocator,

	currentProcess: Atomic<uint32>,
	processCount: uint32,

	running := true
}

fibers: *Fibers = null;

InitalizeFibers()
{
	fibers = new Fibers();
	fibers.currentProcess.Init(0);

	sysInfo := GetSystemInfo();
	// - 2, executable start thread, main (IO) fiber thread
	fibers.processCount = Math.Max(sysInfo.processorCount - 2, 1);
	totalProcessCount := fibers.processCount + 1;
	fibers.handleAllocator = BucketAllocator(#sizeof JobHandle, 32, totalProcessCount);

	fibers.threads = FixedArray<uint>(totalProcessCount);
	fibers.threadIDs = FixedArray<uint32>(totalProcessCount);
	fibers.locks = FixedArray<Mutex>(totalProcessCount);

	for (jobArr in fibers.jobs)
	{
		jobArr = FixedArray<Queue<Job>>(totalProcessCount);
		for (i .. totalProcessCount)
		{
			jobArr[i]~ = Queue<Job>();
		}
	}

	for (i .. totalProcessCount)
	{
		fibers.locks[i]~ = Mutex();

		thread := CreateFiberThread(i);
		fibers.threads[i]~ = thread;
	}
}

*JobHandle CreateJobHandle(count: uint32)
{
	handle := fibers.handleAllocator.Alloc() as *JobHandle;
	assert handle != null, "Failed to allocate job handle";
	
	handle~ = JobHandle(count);
	return handle;
}

*JobHandle GetJobHandle(count: uint32, handleRef: **JobHandle)
{
	if (!handleRef) return null;

	handle := handleRef~;
	if (handle)
	{
		handle.Add(count);
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

uint32 GetNextFiberIndex() => fibers.currentProcess.Add(1) % fibers.processCount;


AddJob(func: ::(*any), data: *any = null, handle: **JobHandle = null, priority: JobPriority = JobPriority.Medium)
{
	jobHandle := GetJobHandle(1, handle);
	job := {func, data, jobHandle} as Job;

	index := GetNextFiberIndex();
	
	AddJobForIndex(job, priority, index);
}

AddJobs(funcs: []::(*any), data: []*any, handle: **JobHandle = null, priority: JobPriority = JobPriority.Medium)
{
	count := funcs.count;
	jobHandle := GetJobHandle(count, handle);
	index := GetNextFiberIndex();

	for (i .. count)
	{
		func := funcs[i];
		dataItem := data[i];
		job := {func, dataItem, jobHandle} as Job;


		AddJobForIndex(job, priority, (index + i) % fibers.processCount);
	}
}

WaitForHandle(handle: *JobHandle)
{
	assert handle != null, "Cannot wait for a null handle";

	defer DeallocJobHandle(handle);

	currThread := GetCurrentThreadID();
	
	for (i .. fibers.processCount + 1)
	{
		thread := fibers.threadIDs[i];
		
		// Waiting for a job on a fiber thread, continue running jobs
		if (currThread == thread)
		{
			while (!handle.Finished())
			{
				RunNext(i);
			}
			return;
		}
	}

	// Waiting on a non fiber thread, spin
	while (!handle.Finished()) {}
}

uint CreateFiberThread(index: uint)
{
	threadID := fibers.threadIDs[index];
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

RunOnMainThread(func: ::(*any), data: *any)
{
	job := {func, data, null} as Job;

	fibers.mainLock.Lock();
	{
		fibers.mainThreadJobs.Enqueue(job);
	}
	fibers.mainLock.Unlock();
}

FlushMainThreadJobs()
{
	if (!fibers.mainThreadJobs.count) return;

	fibers.mainLock.Lock();
	{
		while (fibers.mainThreadJobs.count)
		{
			job := fibers.mainThreadJobs.Dequeue();
			if (job.func)
			{
				job.func(job.data);
			}
		}
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
			job.handle.Remove();
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
