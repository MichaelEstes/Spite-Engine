package SpinLock

import Atomic

state SpinLock
{
	lock: Atomic<bool>
}

SpinLock::()
{
	this.lock.Init(false);
}

SpinLock::Lock()
{
	while (!this.TryLock()) {}
}

bool SpinLock::TryLock()
{
	return this.lock.Exchange(true, MemoryOrder.Acquire);
}

SpinLock::Unlock()
{
	this.lock.Store(false, MemoryOrder.Release);
}