package SpinLock

import Atomic

state SpinLock
{
	lock := Atomic<bool>(false);
}

SpinLock::Lock()
{
	while (!this.TryLock()) {}
}

bool SpinLock::TryLock()
{
	return this.lock.Exchange(true);
}

SpinLock::Unlock()
{
	this.lock.Store(false);
}