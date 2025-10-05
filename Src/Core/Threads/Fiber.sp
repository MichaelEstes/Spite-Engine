package Fiber

import FixedArray
import Thread
import SystemInfo
import SingleConsumerQueue
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

uint32 JobHandle::Decrement() => this.counter.Sub(1);

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

	// Jobs indexed by priority
	jobs := [
		FixedArray<SingleConsumerQueue<Job>>(), 
		FixedArray<SingleConsumerQueue<Job>>(), 
		FixedArray<SingleConsumerQueue<Job>>()
	],
	
	// Jobs to run on the main thread
	mainThreadJobs := SingleConsumerQueue<Job>(),
	mainThreadID: uint32,

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
	fibers.mainThreadID = GetCurrentThreadID();

	sysInfo := GetSystemInfo();
	// - 3 - executable start thread, main (IO) fiber thread, OS scheduling thread
	fibers.processCount = Math.Max(sysInfo.processorCount - 3, 1);
	totalProcessCount := fibers.processCount + 1;
	fibers.handleAllocator = BucketAllocator(#sizeof JobHandle, 32, totalProcessCount);

	fibers.threads = FixedArray<uint>(totalProcessCount);
	fibers.threadIDs = FixedArray<uint32>(totalProcessCount);

	for (jobArr in fibers.jobs)
	{
		jobArr = FixedArray<SingleConsumerQueue<Job>>(totalProcessCount);
		for (i .. totalProcessCount)
		{
			jobArr[i]~ = SingleConsumerQueue<Job>();
		}
	}

	for (i .. totalProcessCount)
	{
		thread := CreateFiberThread(i);
		fibers.threads[i]~ = thread;
	}
}

*JobHandle CreateJobHandle(count: uint32, index: uint32)
{
	handle := fibers.handleAllocator.Alloc(index) as *JobHandle;
	assert handle != null, "Failed to allocate job handle";
	
	handle~ = JobHandle(count);
	return handle;
}

*JobHandle GetJobHandle(count: uint32, handleRef: **JobHandle, index: uint32)
{
	if (!handleRef) return null;

	handle := handleRef~;
	if (handle)
	{
		handle.Add(count);
		return handle;
	}

	createdHandle := CreateJobHandle(count, index);
	handleRef~ = createdHandle;
	return createdHandle;
}

DeallocJobHandle(handle: *JobHandle)
{
	fibers.handleAllocator.Dealloc(handle);
}

AddJobForIndex(job: Job, priority: JobPriority, index: uint32)
{
	fibers.jobs[priority][index].Enqueue(job);
}

uint32 GetNextFiberIndex() => fibers.currentProcess.Add(1) % fibers.processCount;

AddJob(func: ::(*any), data: *any = null, handle: **JobHandle = null, priority: JobPriority = JobPriority.Medium)
{
	index := GetNextFiberIndex();
	jobHandle := GetJobHandle(1, handle, index);
	job := {func, data, jobHandle} as Job;

	AddJobForIndex(job, priority, index);
}

AddJobs(funcs: []::(*any), data: []*any, handle: **JobHandle = null, priority: JobPriority = JobPriority.Medium)
{
	index := GetNextFiberIndex();
	count := funcs.count;
	jobHandle := GetJobHandle(count, handle, index);

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

	currThreadID := GetCurrentThreadID();
	
	for (i .. fibers.processCount + 1)
	{
		threadID := fibers.threadIDs[i]~;
		
		// Waiting for a job on a fiber thread, continue running jobs
		if (currThreadID == threadID)
		{
			while (!handle.Finished())
			{
				//log "Waiting Fiber thread";
				RunNext(i);
			}
			return;
		}
	}

	// Don't stall main thread
	if (currThreadID == fibers.mainThreadID)
	{
		while (!handle.Finished()) 
		{
			FlushMainThreadJobs();
		}
		return;
	}

	// Waiting on a non fiber thread, spin
	while (!handle.Finished()) 
	{
		//log "Waiting Non Fiber thread", handle;
		Thread.Sleep(1);
	}
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
	mainIndex := fibers.processCount;
	jobHandle := GetJobHandle(1, handle, mainIndex);
	job := {func, data, jobHandle} as Job;

	AddJobForIndex(job, priority, mainIndex);
}

RunOnMainThread(func: ::(*any), data: *any, handle: **JobHandle = null)
{
	jobHandle := GetJobHandle(1, handle, 0);
	job := {func, data, jobHandle} as Job;

	fibers.mainThreadJobs.Enqueue(job);
}

FlushMainThreadJobs()
{
	count := fibers.mainThreadJobs.count.Load();
	for (i .. count)
	{
		job := fibers.mainThreadJobs.Dequeue();
		job.func(job.data);
		if (job.handle)
		{
			job.handle.Decrement();
		}
	}
}

Job GetNextJob(index: uint)
{
	job := Job();

	for (jobArr in fibers.jobs)
	{
		jobQueue := jobArr[index];
		if (jobQueue.count.Load())
		{
			job = jobQueue.Dequeue();
			break;
		}
	}

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
			job.handle.Decrement();
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
