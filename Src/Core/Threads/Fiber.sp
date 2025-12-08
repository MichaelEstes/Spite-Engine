package Fiber

import FixedArray
import Thread
import SystemInfo
import SingleConsumerQueue
import Atomic
import BucketAllocator
import Mutex
import BitSet

state JobHandle 
{
	counter: Atomic<uint32>
}

JobHandle::()
{
	this.counter.Init(uint32(0));
}

uint32 JobHandle::Increment(amount: uint32) => this.counter.Add(amount);
uint32 JobHandle::Decrement(amount: uint32) => this.counter.Sub(amount);
bool JobHandle::Completed() => this.counter.Load() == 0;

state FiberJob
{
	func: ::(*any),
	data: *void,
	handle: *JobHandle
}

FiberJob::(func: ::(*any), data: *void, handle: *JobHandle)
{
	this.func = func;
	this.data = data;
	this.handle = handle;
}

state Fibers
{
	mainThreadJobs: SingleConsumerQueue<FiberJob>,

	jobQueueArr: FixedArray<SingleConsumerQueue<FiberJob>>,
	threadIDs: FixedArray<uint32>,
	threadHandles: FixedArray<uint>,
	threadEnabled: FixedArray<bool>,

	handleAllocator: BucketAllocator,
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
	fibers.fiberCount = Math.Max(sysInfo.processorCount - 3, 1);
	
	fibers.handleAllocator = BucketAllocator(#sizeof JobHandle, FiberJobCount, fibers.fiberCount + 1);

	fibers.jobQueueArr = FixedArray<SingleConsumerQueue<FiberJob>>(fibers.fiberCount);
	fibers.threadIDs = FixedArray<uint>(fibers.fiberCount);
	fibers.threadHandles = FixedArray<uint>(fibers.fiberCount);
	fibers.threadEnabled = FixedArray<bool>(fibers.fiberCount);


	for (i: uint .. fibers.fiberCount)
	{
		fibers.threadEnabled[i]~ = true;
		fibers.jobQueueArr[i]~ = SingleConsumerQueue<FiberJob>(FiberJobCount);
		fibers.threadHandles[i]~ = Thread.Create(RunFiber, i as *void, fibers.threadIDs[i]);
	}

	fibers.mainThreadJobs = SingleConsumerQueue<FiberJob>(FiberJobCount);
	fibers.mainThreadID = GetCurrentThreadID();

	fibers.currentIndex.Init(0);
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

*JobHandle AllocJobHandle(index: int32)
{
	handle := fibers.handleAllocator.Alloc(index) as *JobHandle;
	handle~ = JobHandle();
	return handle;
}

DeallocJobHandle(handle: *JobHandle)
{
	fibers.handleAllocator.Dealloc(handle);
}

*JobHandle InitJobHandle(handleRef: **JobHandle, amount: uint32)
{
	if (!handleRef) return null;

	handle := handleRef~;
	if (!handle)
	{
		index := GetCurrentFiberIndex();
		if (index == int32(-1)) index = fibers.fiberCount;

		handle = AllocJobHandle(index);
	}
	
	handle.Increment(amount);
	handleRef~ = handle;
	return handle;
}

uint32 GetNextFiberIndex()
{
	index := fibers.currentIndex.Add(1) % fibers.fiberCount;
	if (index == GetCurrentFiberIndex()) index += 1;
	return index;
}

AddJob(func: ::(*any), data: *any, handle: **JobHandle = null)
{
	jobHandle := InitJobHandle(handle, uint32(1));
	job := FiberJob(func, data, jobHandle);

	index := GetNextFiberIndex();
	fibers.jobQueueArr[index].Enqueue(job);
}

bool CurrentThreadIsMainThread() => GetCurrentThreadID() == fibers.mainThreadID;

RunOnMainThread(func: ::(*any), data: *any, handle: **JobHandle = null)
{
	jobHandle := InitJobHandle(handle, uint32(1));
	job := FiberJob(func, data, jobHandle);

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

RunNextFiberJob(queue: *SingleConsumerQueue<FiberJob>)
{
	job := queue.Dequeue();
	RunFiberJob(job);
}

uint32 RunFiber(data: *void)
{
	index := data as uint;
	queue := fibers.jobQueueArr[index];

	while (fibers.threadEnabled[index]~)
	{
		RunNextFiberJob(queue);
	}

	return 0;
}

FlushMainThreadJobs()
{
	queue := fibers.mainThreadJobs;
	job := queue.Dequeue(true);
	while (job.func)
	{
		RunFiberJob(job);
		job = queue.Dequeue(true);
	}
}

WaitForHandle(handle: *JobHandle)
{
	assert handle != null, "Cannot wait for a null handle";

	defer DeallocJobHandle(handle);

	index := GetCurrentFiberIndex();
	if (index != -1)
	{
		queue := fibers.jobQueueArr[index];
		while (!handle.Completed())
		{
			RunNextFiberJob(queue);
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