package Tracy

extern
{
	#link windows "./extern/TracyClient";

	void ___tracy_startup_profiler();
	void ___tracy_shutdown_profiler();
	int32 ___tracy_profiler_started();

	int32 ___tracy_connected();
	int64 ___tracy_get_time();

	void ___tracy_set_thread_name(name: *byte);

	int32 ___tracy_begin_sampling_profiling();
	void ___tracy_end_sampling_profiling();

	uint64 ___tracy_alloc_srcloc(line: uint32, source: *byte, sourceSz: uint,
								 function: *byte, functionSz: uint, color: uint32);
	uint64 ___tracy_alloc_srcloc_name(line: uint32, source: *byte, sourceSz: uint,
									  function: *byte, functionSz: uint,
									  name: *byte, nameSz: uint, color: uint32);

	ZoneContext ___tracy_emit_zone_begin(srcloc: *SourceLocationData, active: int32);
	ZoneContext ___tracy_emit_zone_begin_callstack(srcloc: *SourceLocationData, depth: int32, active: int32);
	ZoneContext ___tracy_emit_zone_begin_alloc(srcloc: uint64, active: int32);
	ZoneContext ___tracy_emit_zone_begin_alloc_callstack(srcloc: uint64, depth: int32, active: int32);
	void ___tracy_emit_zone_end(ctx: ZoneContext);
	void ___tracy_emit_zone_text(ctx: ZoneContext, txt: *byte, size: uint);
	void ___tracy_emit_zone_name(ctx: ZoneContext, txt: *byte, size: uint);
	void ___tracy_emit_zone_color(ctx: ZoneContext, color: uint32);
	void ___tracy_emit_zone_value(ctx: ZoneContext, value: uint64);

	void ___tracy_emit_frame_mark(name: *byte);
	void ___tracy_emit_frame_mark_start(name: *byte);
	void ___tracy_emit_frame_mark_end(name: *byte);
	void ___tracy_emit_frame_image(image: *void, w: uint16, h: uint16, offset: ubyte, flip: int32);

	void ___tracy_emit_plot(name: *byte, val: float64);
	void ___tracy_emit_plot_float(name: *byte, val: float32);
	void ___tracy_emit_plot_int(name: *byte, val: int64);
	void ___tracy_emit_plot_config(name: *byte, type: int32, step: int32, fill: int32, color: uint32);
	void ___tracy_emit_message_appinfo(txt: *byte, size: uint);

	void ___tracy_emit_logString(severity: byte, color: int32, callstackDepth: int32, size: uint, txt: *byte);
	void ___tracy_emit_logStringL(severity: byte, color: int32, callstackDepth: int32, txt: *byte);

	void ___tracy_emit_memory_alloc(ptr: *void, size: uint);
	void ___tracy_emit_memory_alloc_callstack(ptr: *void, size: uint, depth: int32);
	void ___tracy_emit_memory_free(ptr: *void);
	void ___tracy_emit_memory_free_callstack(ptr: *void, depth: int32);
	void ___tracy_emit_memory_alloc_named(ptr: *void, size: uint, name: *byte);
	void ___tracy_emit_memory_alloc_callstack_named(ptr: *void, size: uint, depth: int32, name: *byte);
	void ___tracy_emit_memory_free_named(ptr: *void, name: *byte);
	void ___tracy_emit_memory_free_callstack_named(ptr: *void, depth: int32, name: *byte);
	void ___tracy_emit_memory_discard(name: *byte);
	void ___tracy_emit_memory_discard_callstack(name: *byte, depth: int32);

	void ___tracy_emit_gpu_zone_begin(data: GpuZoneBeginData);
	void ___tracy_emit_gpu_zone_begin_callstack(data: GpuZoneBeginCallstackData);
	void ___tracy_emit_gpu_zone_begin_alloc(data: GpuZoneBeginData);
	void ___tracy_emit_gpu_zone_begin_alloc_callstack(data: GpuZoneBeginCallstackData);
	void ___tracy_emit_gpu_zone_end(data: GpuZoneEndData);
	void ___tracy_emit_gpu_time(data: GpuTimeData);
	void ___tracy_emit_gpu_new_context(data: GpuNewContextData);
	void ___tracy_emit_gpu_context_name(data: GpuContextNameData);
	void ___tracy_emit_gpu_calibration(data: GpuCalibrationData);
	void ___tracy_emit_gpu_time_sync(data: GpuTimeSyncData);

	void ___tracy_emit_gpu_zone_begin_serial(data: GpuZoneBeginData);
	void ___tracy_emit_gpu_zone_begin_callstack_serial(data: GpuZoneBeginCallstackData);
	void ___tracy_emit_gpu_zone_begin_alloc_serial(data: GpuZoneBeginData);
	void ___tracy_emit_gpu_zone_begin_alloc_callstack_serial(data: GpuZoneBeginCallstackData);
	void ___tracy_emit_gpu_zone_end_serial(data: GpuZoneEndData);
	void ___tracy_emit_gpu_time_serial(data: GpuTimeData);
	void ___tracy_emit_gpu_new_context_serial(data: GpuNewContextData);
	void ___tracy_emit_gpu_context_name_serial(data: GpuContextNameData);
	void ___tracy_emit_gpu_calibration_serial(data: GpuCalibrationData);
	void ___tracy_emit_gpu_time_sync_serial(data: GpuTimeSyncData);

	*void ___tracy_announce_lockable_ctx(srcloc: *SourceLocationData);
	void ___tracy_terminate_lockable_ctx(lockdata: *void);
	int32 ___tracy_before_lock_lockable_ctx(lockdata: *void);
	void ___tracy_after_lock_lockable_ctx(lockdata: *void);
	void ___tracy_after_unlock_lockable_ctx(lockdata: *void);
	void ___tracy_after_try_lock_lockable_ctx(lockdata: *void, acquired: int32);
	void ___tracy_mark_lockable_ctx(lockdata: *void, srcloc: *SourceLocationData);
	void ___tracy_custom_name_lockable_ctx(lockdata: *void, name: *byte, nameSz: uint);

	*void ___tracy_announce_shared_lockable_ctx(srcloc: *SourceLocationData);
	void ___tracy_terminate_shared_lockable_ctx(lockdata: *void);
	int32 ___tracy_before_lock_shared_lockable_ctx(lockdata: *void);
	void ___tracy_after_lock_shared_lockable_ctx(lockdata: *void);
	void ___tracy_after_unlock_shared_lockable_ctx(lockdata: *void);
	void ___tracy_after_try_lock_shared_lockable_ctx(lockdata: *void, acquired: int32);
	int32 ___tracy_before_lock_shared_shared_lockable_ctx(lockdata: *void);
	void ___tracy_after_lock_shared_shared_lockable_ctx(lockdata: *void);
	void ___tracy_after_unlock_shared_shared_lockable_ctx(lockdata: *void);
	void ___tracy_after_try_lock_shared_shared_lockable_ctx(lockdata: *void, acquired: int32);
	void ___tracy_mark_shared_lockable_ctx(lockdata: *void, srcloc: *SourceLocationData);
	void ___tracy_custom_name_shared_lockable_ctx(lockdata: *void, name: *byte, nameSz: uint);
}

enum PlotFormat: int32
{
	Number = 0,
	Memory = 1,
	Percentage = 2,
	Watt = 3
}

enum MessageSeverity: byte
{
	Trace = 0,
	Debug = 1,
	Info = 2,
	Warning = 3,
	Error = 4,
	Fatal = 5
}

state SourceLocationData
{
	name: *byte,
	function: *byte,
	file: *byte,
	line: uint32,
	color: uint32
}

state ZoneContext
{
	id: uint32,
	active: int32
}

state GpuTimeData
{
	gpuTime: int64,
	queryId: uint16,
	context: ubyte
}

state GpuZoneBeginData
{
	srcloc: uint64,
	queryId: uint16,
	context: ubyte
}

state GpuZoneBeginCallstackData
{
	srcloc: uint64,
	depth: int32,
	queryId: uint16,
	context: ubyte
}

state GpuZoneEndData
{
	queryId: uint16,
	context: ubyte
}

state GpuNewContextData
{
	gpuTime: int64,
	period: float32,
	context: ubyte,
	flags: ubyte,
	type: ubyte
}

state GpuContextNameData
{
	context: ubyte,
	name: *byte,
	len: uint16
}

state GpuCalibrationData
{
	gpuTime: int64,
	cpuDelta: int64,
	context: ubyte
}

state GpuTimeSyncData
{
	gpuTime: int64,
	context: ubyte
}

StartupProfiler() => ___tracy_startup_profiler();
ShutdownProfiler() => ___tracy_shutdown_profiler();
int32 IsProfilerStarted() => ___tracy_profiler_started();

int32 IsConnected() => ___tracy_connected();
int64 GetTime() => ___tracy_get_time();

SetThreadName(name: *byte) => ___tracy_set_thread_name(name);

int32 BeginSamplingProfiling() => ___tracy_begin_sampling_profiling();
EndSamplingProfiling() => ___tracy_end_sampling_profiling();

uint64 AllocSrcLoc(line: uint32, source: *byte, sourceSz: uint,
				   function: *byte, functionSz: uint, color: uint32)
				   => ___tracy_alloc_srcloc(line, source, sourceSz, function, functionSz, color);
uint64 AllocSrcLocName(line: uint32, source: *byte, sourceSz: uint,
					   function: *byte, functionSz: uint,
					   name: *byte, nameSz: uint, color: uint32)
					   => ___tracy_alloc_srcloc_name(line, source, sourceSz, function, functionSz,
													 name, nameSz, color);

ZoneContext ZoneBegin(srcloc: *SourceLocationData, active: int32)
					  => ___tracy_emit_zone_begin(srcloc, active);
ZoneContext ZoneBeginCallstack(srcloc: *SourceLocationData, depth: int32, active: int32)
							   => ___tracy_emit_zone_begin_callstack(srcloc, depth, active);
ZoneContext ZoneBeginAlloc(srcloc: uint64, active: int32)
						   => ___tracy_emit_zone_begin_alloc(srcloc, active);
ZoneContext ZoneBeginAllocCallstack(srcloc: uint64, depth: int32, active: int32)
									=> ___tracy_emit_zone_begin_alloc_callstack(srcloc, depth, active);
ZoneEnd(ctx: ZoneContext) => ___tracy_emit_zone_end(ctx);
ZoneText(ctx: ZoneContext, txt: *byte, size: uint) => ___tracy_emit_zone_text(ctx, txt, size);
ZoneName(ctx: ZoneContext, txt: *byte, size: uint) => ___tracy_emit_zone_name(ctx, txt, size);
ZoneColor(ctx: ZoneContext, color: uint32) => ___tracy_emit_zone_color(ctx, color);
ZoneValue(ctx: ZoneContext, value: uint64) => ___tracy_emit_zone_value(ctx, value);

FrameMark(name: *byte) => ___tracy_emit_frame_mark(name);
FrameMarkStart(name: *byte) => ___tracy_emit_frame_mark_start(name);
FrameMarkEnd(name: *byte) => ___tracy_emit_frame_mark_end(name);
FrameImage(image: *void, w: uint16, h: uint16, offset: ubyte, flip: int32)
		   => ___tracy_emit_frame_image(image, w, h, offset, flip);

Plot(name: *byte, val: float64) => ___tracy_emit_plot(name, val);
PlotFloat(name: *byte, val: float32) => ___tracy_emit_plot_float(name, val);
PlotInt(name: *byte, val: int64) => ___tracy_emit_plot_int(name, val);
PlotConfig(name: *byte, format: PlotFormat, step: int32, fill: int32, color: uint32)
		   => ___tracy_emit_plot_config(name, format, step, fill, color);
AppInfo(txt: *byte, size: uint) => ___tracy_emit_message_appinfo(txt, size);

LogString(severity: MessageSeverity, color: int32, callstackDepth: int32, size: uint, txt: *byte)
		  => ___tracy_emit_logString(severity, color, callstackDepth, size, txt);
LogStringLiteral(severity: MessageSeverity, color: int32, callstackDepth: int32, txt: *byte)
				 => ___tracy_emit_logStringL(severity, color, callstackDepth, txt);

MemoryAlloc(ptr: *void, size: uint) => ___tracy_emit_memory_alloc(ptr, size);
MemoryAllocCallstack(ptr: *void, size: uint, depth: int32)
					 => ___tracy_emit_memory_alloc_callstack(ptr, size, depth);
MemoryFree(ptr: *void) => ___tracy_emit_memory_free(ptr);
MemoryFreeCallstack(ptr: *void, depth: int32) => ___tracy_emit_memory_free_callstack(ptr, depth);
MemoryAllocNamed(ptr: *void, size: uint, name: *byte)
				 => ___tracy_emit_memory_alloc_named(ptr, size, name);
MemoryAllocCallstackNamed(ptr: *void, size: uint, depth: int32, name: *byte)
						  => ___tracy_emit_memory_alloc_callstack_named(ptr, size, depth, name);
MemoryFreeNamed(ptr: *void, name: *byte) => ___tracy_emit_memory_free_named(ptr, name);
MemoryFreeCallstackNamed(ptr: *void, depth: int32, name: *byte)
						 => ___tracy_emit_memory_free_callstack_named(ptr, depth, name);
MemoryDiscard(name: *byte) => ___tracy_emit_memory_discard(name);
MemoryDiscardCallstack(name: *byte, depth: int32) => ___tracy_emit_memory_discard_callstack(name, depth);

GpuZoneBegin(data: GpuZoneBeginData) => ___tracy_emit_gpu_zone_begin(data);
GpuZoneBeginCallstack(data: GpuZoneBeginCallstackData) => ___tracy_emit_gpu_zone_begin_callstack(data);
GpuZoneBeginAlloc(data: GpuZoneBeginData) => ___tracy_emit_gpu_zone_begin_alloc(data);
GpuZoneBeginAllocCallstack(data: GpuZoneBeginCallstackData)
						   => ___tracy_emit_gpu_zone_begin_alloc_callstack(data);
GpuZoneEnd(data: GpuZoneEndData) => ___tracy_emit_gpu_zone_end(data);
GpuTime(data: GpuTimeData) => ___tracy_emit_gpu_time(data);
GpuNewContext(data: GpuNewContextData) => ___tracy_emit_gpu_new_context(data);
GpuContextName(data: GpuContextNameData) => ___tracy_emit_gpu_context_name(data);
GpuCalibration(data: GpuCalibrationData) => ___tracy_emit_gpu_calibration(data);
GpuTimeSync(data: GpuTimeSyncData) => ___tracy_emit_gpu_time_sync(data);

GpuZoneBeginSerial(data: GpuZoneBeginData) => ___tracy_emit_gpu_zone_begin_serial(data);
GpuZoneBeginCallstackSerial(data: GpuZoneBeginCallstackData)
							=> ___tracy_emit_gpu_zone_begin_callstack_serial(data);
GpuZoneBeginAllocSerial(data: GpuZoneBeginData) => ___tracy_emit_gpu_zone_begin_alloc_serial(data);
GpuZoneBeginAllocCallstackSerial(data: GpuZoneBeginCallstackData)
								 => ___tracy_emit_gpu_zone_begin_alloc_callstack_serial(data);
GpuZoneEndSerial(data: GpuZoneEndData) => ___tracy_emit_gpu_zone_end_serial(data);
GpuTimeSerial(data: GpuTimeData) => ___tracy_emit_gpu_time_serial(data);
GpuNewContextSerial(data: GpuNewContextData) => ___tracy_emit_gpu_new_context_serial(data);
GpuContextNameSerial(data: GpuContextNameData) => ___tracy_emit_gpu_context_name_serial(data);
GpuCalibrationSerial(data: GpuCalibrationData) => ___tracy_emit_gpu_calibration_serial(data);
GpuTimeSyncSerial(data: GpuTimeSyncData) => ___tracy_emit_gpu_time_sync_serial(data);

*void LockAnnounce(srcloc: *SourceLocationData) => ___tracy_announce_lockable_ctx(srcloc);
LockTerminate(lockdata: *void) => ___tracy_terminate_lockable_ctx(lockdata);
int32 LockBeforeLock(lockdata: *void) => ___tracy_before_lock_lockable_ctx(lockdata);
LockAfterLock(lockdata: *void) => ___tracy_after_lock_lockable_ctx(lockdata);
LockAfterUnlock(lockdata: *void) => ___tracy_after_unlock_lockable_ctx(lockdata);
LockAfterTryLock(lockdata: *void, acquired: int32) => ___tracy_after_try_lock_lockable_ctx(lockdata, acquired);
LockMark(lockdata: *void, srcloc: *SourceLocationData) => ___tracy_mark_lockable_ctx(lockdata, srcloc);
LockCustomName(lockdata: *void, name: *byte, nameSz: uint)
			   => ___tracy_custom_name_lockable_ctx(lockdata, name, nameSz);

*void SharedLockAnnounce(srcloc: *SourceLocationData) => ___tracy_announce_shared_lockable_ctx(srcloc);
SharedLockTerminate(lockdata: *void) => ___tracy_terminate_shared_lockable_ctx(lockdata);
int32 SharedLockBeforeLock(lockdata: *void) => ___tracy_before_lock_shared_lockable_ctx(lockdata);
SharedLockAfterLock(lockdata: *void) => ___tracy_after_lock_shared_lockable_ctx(lockdata);
SharedLockAfterUnlock(lockdata: *void) => ___tracy_after_unlock_shared_lockable_ctx(lockdata);
SharedLockAfterTryLock(lockdata: *void, acquired: int32)
					   => ___tracy_after_try_lock_shared_lockable_ctx(lockdata, acquired);
int32 SharedLockBeforeSharedLock(lockdata: *void) => ___tracy_before_lock_shared_shared_lockable_ctx(lockdata);
SharedLockAfterSharedLock(lockdata: *void) => ___tracy_after_lock_shared_shared_lockable_ctx(lockdata);
SharedLockAfterSharedUnlock(lockdata: *void) => ___tracy_after_unlock_shared_shared_lockable_ctx(lockdata);
SharedLockAfterTrySharedLock(lockdata: *void, acquired: int32)
							 => ___tracy_after_try_lock_shared_shared_lockable_ctx(lockdata, acquired);
SharedLockMark(lockdata: *void, srcloc: *SourceLocationData)
			   => ___tracy_mark_shared_lockable_ctx(lockdata, srcloc);
SharedLockCustomName(lockdata: *void, name: *byte, nameSz: uint)
					 => ___tracy_custom_name_shared_lockable_ctx(lockdata, name, nameSz);

bool InitializeTracyInterpreterExt()
{
	registered := RegisterInterpreterExtension(
		::(func: *_Function, params: *_Interop_Vector<_Operand>, threadID: int32)
		{
			name := func.name.ToString();
			position := func.metadata.position;
			file := position.file.ToString();
			line := position.line as uint32;

			srcloc := AllocSrcLoc(line, file[0], file.count, name[0], name.count, 0);
			ZoneBeginAlloc(srcloc, 1);
		},
		::(func: *_Function, params: *_Interop_Vector<_Operand>, threadID: int32)
		{
			ctx := ZoneContext();
			ctx.id = 0;
			ctx.active = 1;
			ZoneEnd(ctx);
		}
	);
	return registered;
}