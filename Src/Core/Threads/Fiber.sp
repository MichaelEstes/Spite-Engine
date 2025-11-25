package Fiber

import FixedArray
import Thread
import SystemInfo
import SingleConsumerQueue
import Atomic
import BucketAllocator
import Mutex

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

uint32 JobHandle::Add(count: uint32) => this.counter.Add(count, MemoryOrder.Relaxed);

uint32 JobHandle::Decrement() => this.counter.Sub(uint32(1), MemoryOrder.Relaxed);

state Job
{
	func: ::(*any),
	data: *any,
	handle: *JobHandle
}

Job::(func: ::(*any), data: *any, handle: *JobHandle)
{
	this.func = func;
	this.data = data;
	this.handle = handle;
}

JobQueueCount := 128;

state Fibers
{
	threads: FixedArray<uint>,
	threadIDs: FixedArray<uint32>,

	jobQueues: FixedArray<SingleConsumerQueue<Job>>,
	
	// Jobs to run on the main thread
	mainThreadJobs := SingleConsumerQueue<Job>(JobQueueCount),
	mainThreadID: uint32,

	handleAllocator: BucketAllocator,

	currentProcess: Atomic<uint32>,
	processCount: uint32,

	jobsAdded: Atomic<uint32>,
	jobsFinished: Atomic<uint32>,
	jobsRun: Atomic<uint32>,
	threadRunningJob: FixedArray<bool>

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
	//fibers.processCount = Math.Max(sysInfo.processorCount - 3, 1);
	fibers.processCount = 1;
	totalProcessCount := fibers.processCount + 1;
	fibers.handleAllocator = BucketAllocator(#sizeof JobHandle, 32, totalProcessCount);

	fibers.threads = FixedArray<uint>(totalProcessCount);
	fibers.threadIDs = FixedArray<uint32>(totalProcessCount);

	fibers.threadRunningJob = FixedArray<bool>(totalProcessCount + 1);
	
	fibers.jobQueues = FixedArray<SingleConsumerQueue<Job>>(totalProcessCount);
	for (i .. totalProcessCount)
	{
		fibers.jobQueues[i]~ = SingleConsumerQueue<Job>(JobQueueCount);
	}

	for (i .. totalProcessCount)
	{
		thread := CreateFiberThread(i);
		fibers.threads[i]~ = thread;
	}
}

int32 GetFiberIndex()
{
	currThreadID := GetCurrentThreadID();
	
	for (i .. fibers.processCount + 1)
	{
		threadID := fibers.threadIDs[i]~;
		if (currThreadID == threadID)
		{
			return i;
		}
	}

	return -1;
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
	assert count != 0;
	if (!handleRef) return null;

	fibers.jobsAdded.Add(count);
	handle := handleRef~;
	if (handle)
	{
		handle.Add(count);
		return handle;
	}

	createdHandle := CreateJobHandle(count, index);
	if (handleRef) handleRef~ = createdHandle;
	return createdHandle;
}

DeallocJobHandle(handle: *JobHandle)
{
	fibers.handleAllocator.Dealloc(handle);
}

AddJobForIndex(job: Job, index: uint32)
{
	fibers.jobQueues[index].Enqueue(job);
}

uint32 GetNextFiberIndex() => fibers.currentProcess.Add(1) % fibers.processCount;

AddJob(func: ::(*any), data: *any = null, handle: **JobHandle = null)
{
	index := GetNextFiberIndex();
	jobHandle := GetJobHandle(1, handle, index);
	job := Job(func, data, jobHandle);

	AddJobForIndex(job, index);
}

AddJobs(funcs: []::(*any), data: []*any, handle: **JobHandle = null)
{
	index := GetNextFiberIndex();
	count := funcs.count;
	jobHandle := GetJobHandle(count, handle, index);

	for (i .. count)
	{
		func := funcs[i];
		dataItem := data[i];
		job := Job(func, dataItem, jobHandle);

		AddJobForIndex(job, (index + i) % fibers.processCount);
	}
}

LogFiberDebug(waitKind: uint32, handle: *JobHandle)
{
	msg := "";
	handleStr := UIntToString(handle.counter.Load());
	jobsAddedStr := UIntToString(fibers.jobsAdded.Load());
	jobsFinishedStr := UIntToString(fibers.jobsFinished.Load());
	jobsRunStr := UIntToString(fibers.jobsRun.Load());

	if (waitKind == 0)
	{
		msg = "Waiting Fiber thread, handle count: ";
	}
	else if (waitKind == 1)
	{
		msg = "Waiting Main thread, handle count: ";
	}
	else if (waitKind == 2)
	{
		msg = "Waiting Non Fiber thread, handle count: ";
	}
	msg = msg.Append(handleStr);

	msg = msg.Append("\nJobs Added: ");
	msg = msg.Append(jobsAddedStr);

	msg = msg.Append("\nJobs Finished: ");
	msg = msg.Append(jobsFinishedStr);

	msg = msg.Append("\nJobs Run: ");
	msg = msg.Append(jobsRunStr);
	
	log msg;
	log "Threads Running Job", fibers.threadRunningJob;
}

WaitForHandle(handle: *JobHandle)
{
	assert handle != null, "Cannot wait for a null handle";

	defer DeallocJobHandle(handle);
	defer log "Wait finished", handle;

	fiberIndex := GetFiberIndex();
	if (fiberIndex != -1)
	{
		// Waiting for a job on a fiber thread, continue running jobs
		while (!handle.Finished())
		{
			LogFiberDebug(0, handle);
			RunNext(fiberIndex, true);
		}
		return;
	}

	currThreadID := GetCurrentThreadID();
	// Don't stall main thread
	if (currThreadID == fibers.mainThreadID)
	{
		while (!handle.Finished())
		{
			LogFiberDebug(1, handle);
			FlushMainThreadJobs();
		}
		return;
	}

	// Waiting on a non fiber thread, spin
	while (!handle.Finished()) 
	{
		LogFiberDebug(2, handle);
		//Thread.Sleep(1);
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

RunOnMainFiber(func: ::(*any), data: *any, handle: **JobHandle = null)
{
	mainIndex := fibers.processCount;
	jobHandle := GetJobHandle(1, handle, mainIndex);
	job := Job(func, data, jobHandle);

	AddJobForIndex(job, mainIndex);
}

RunOnMainThread(func: ::(*any), data: *any, handle: **JobHandle = null)
{
	jobHandle := GetJobHandle(1, handle, 0);
	job := Job(func, data, jobHandle);

	fibers.mainThreadJobs.Enqueue(job);
}

RunJob(job: Job, index: uint)
{
	fibers.threadRunningJob[index]~ = true;
	job.func(job.data);
	fibers.jobsRun.Add(1);

	if (job.handle)
	{
		job.handle.Decrement();
		fibers.jobsFinished.Add(1);
	}
	
	fibers.threadRunningJob[index]~ = false;
}

FlushMainThreadJobs()
{
	index := fibers.processCount + 2;
	job := fibers.mainThreadJobs.Dequeue(true);
	while (job.func)
	{
		RunJob(job, index);
		job = fibers.mainThreadJobs.Dequeue(true);
	}
}

Job GetNextJob(index: uint, ret: bool)
{
	job := Job();

	jobQueue :=  fibers.jobQueues[index];
	job = jobQueue.Dequeue(ret);

	return job;
}

RunNext(index: uint, ret: bool = false)
{
	job := GetNextJob(index, ret);
	if (job.func)
	{
		RunJob(job, index);
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
