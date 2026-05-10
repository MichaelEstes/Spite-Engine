package Fiber

import FixedArray
import Array
import Thread
import SystemInfo
import MultipleConsumerQueue
import Atomic
import BucketAllocator
import Mutex
import BitSet

state JobHandle 
{
	counter: Atomic<uint32>
}

JobHandle::(initial: uint32)
{
	this.counter.Init(initial);
}

uint32 JobHandle::Increment(count: uint32) => this.counter.Add(count);
uint32 JobHandle::Decrement(count: uint32) => this.counter.Sub(count);
bool JobHandle::Completed() => this.counter.Load() == uint32(0);

state FiberJob
{
	id: uint64,
	func: ::(*any),
	data: *void,
	handle: *JobHandle
}

FiberJob::()
{
	this.id = 0;
	this.func = null;
	this.data = null;
	this.handle = null;
}

FiberJob::(id: uint64, func: ::(*any), data: *void, handle: *JobHandle)
{
	this.id = id;
	this.func = func;
	this.data = data;
	this.handle = handle;
}

string FiberJob::JobName()
{
	return (this.func as *_Function)~.name.ToString();
}

state Fibers
{
	mainThreadJobs: MultipleConsumerQueue<FiberJob>,

	jobQueueArr: FixedArray<MultipleConsumerQueue<FiberJob>>,
	threadIDs: FixedArray<uint32>,
	threadHandles: FixedArray<uint>,
	fiberEnabled: FixedArray<bool>,

	handleAllocator: BucketAllocator,
	nextJobID: Atomic<uint>,
	currentIndex: Atomic<uint32>,
	mainThreadID: uint32,
	fiberCount: uint32
}

fibers := Fibers();

FiberJobCount := 128;

InitalizeFibers()
{
	sysInfo := GetSystemInfo();
	// - 3 - executable start thread, main (IO) fiber thread, OS scheduling thread
	fibers.fiberCount = Math.Max(sysInfo.processorCount - 3, 2);

	fibers.handleAllocator = BucketAllocator(#sizeof JobHandle, FiberJobCount, fibers.fiberCount + 1);

	fibers.jobQueueArr = FixedArray<MultipleConsumerQueue<FiberJob>>(fibers.fiberCount);
	fibers.threadIDs = FixedArray<uint32>(fibers.fiberCount);
	fibers.threadHandles = FixedArray<uint>(fibers.fiberCount);
	fibers.fiberEnabled = FixedArray<bool>(fibers.fiberCount);

	for (i: uint .. fibers.fiberCount)
	{
		log "Creating Fiber state: " +  UIntToString(i);
		fibers.fiberEnabled[i]~ = true;
		fibers.jobQueueArr[i]~ = MultipleConsumerQueue<FiberJob>(FiberJobCount);
	}
	
	for (i: uint .. fibers.fiberCount)
	{
		fibers.threadHandles[i]~ = Thread.Create(RunFiber, i as *void, fibers.threadIDs[i]);
	}

	fibers.mainThreadJobs = MultipleConsumerQueue<FiberJob>(FiberJobCount);
	fibers.mainThreadID = GetCurrentThreadID();

	fibers.currentIndex.Init(0);
	fibers.nextJobID.Init(0);
}

int32 GetCurrentFiberIndex()
{
	id := GetCurrentThreadID();
	for (i .. fibers.fiberCount)
	{
		if (id == fibers.threadIDs[i]~) return i;
	}

	return -1;
}

*JobHandle AllocJobHandle(index: int32, initialCount: uint32)
{
	handle := fibers.handleAllocator.Alloc(index) as *JobHandle;
	handle~ = JobHandle(initialCount);
	return handle;
}

DeallocJobHandle(handle: *JobHandle)
{
	fibers.handleAllocator.Dealloc(handle);
}

*JobHandle InitJobHandle(handleRef: **JobHandle, count: uint32)
{
	if (!handleRef) return null;

	handle := handleRef~;
	if (!handle)
	{
		index := GetCurrentFiberIndex();
		if (index == int32(-1)) index = fibers.fiberCount;

		handle = AllocJobHandle(index, count);
		handleRef~ = handle;
	}
	else
	{
		handle.Increment(count);
	}

	return handle;
}

AddJob(func: ::(*any), data: *any, handle: **JobHandle = null)
{
	jobHandle := InitJobHandle(handle, uint32(1));
	jobID := fibers.nextJobID.Add(1);
	job := FiberJob(jobID, func, data, jobHandle);

	index := fibers.currentIndex.Add(1) % fibers.fiberCount;
	fibers.jobQueueArr[index].Enqueue(job);
}

bool CurrentThreadIsMainThread() => GetCurrentThreadID() == fibers.mainThreadID;

RunOnMainThread(func: ::(*any), data: *any, handle: **JobHandle = null)
{
	jobHandle := InitJobHandle(handle, uint32(1));
	jobID := fibers.nextJobID.Add(1);
	job := FiberJob(jobID, func, data, jobHandle);

	if (CurrentThreadIsMainThread())
	{
		RunFiberJob(job);	
	}
	else
	{
		fibers.mainThreadJobs.Enqueue(job);
	}
}

RunFiberJob(job: FiberJob) => 
{
	job.func(job.data);
	if (job.handle)
	{
		job.handle.Decrement(1);
	}
}

uint32 RunFiber(data: *void)
{
	index := data as uint;
	log "Starting fiber: " +  UIntToString(index);

	while (fibers.fiberEnabled[index]~)
	{
		job := fibers.jobQueueArr[index].Dequeue();
		RunFiberJob(job);
	}

	return 0;
}

FlushMainThreadJobs()
{
	job := FiberJob();
	while (fibers.mainThreadJobs.TryDequeue(job@))
	{
		RunFiberJob(job);
	}
}

WaitForHandle(handle: *JobHandle)
{
	assert handle != null, "Cannot wait for a null handle";

	defer DeallocJobHandle(handle);

	index := GetCurrentFiberIndex();
	if (index != -1)
	{
		while (!handle.Completed())
		{
			job := FiberJob();
			if (fibers.jobQueueArr[index].TryDequeue(job@))
			{
				RunFiberJob(job);
			}
		}
		return;
	}

	if (GetCurrentThreadID() == fibers.mainThreadID)
	{
		while (!handle.Completed())
		{
			FlushMainThreadJobs();
		}
		return;
	}

	while (!handle.Completed()) {}
}
