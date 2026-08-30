package Utils

import ECS
import ImGui
import Thread
import FixedRingBuffer
import Mutex
import SparseSet

ProfilerCallstackDepth := 16;
ProfilerFrameHistorySize := 180;
ProfilerMaxVisibleThreads := 256;

state Callstack
{
	functions: FixedRingBuffer<*_Function, 16>,
	sampleCount: uint32,
	lastFunction: *_Function
}

Callstack::()
{
	this.functions.Init(null);
	this.sampleCount = 0;
	this.lastFunction = null;
}

state ProfilerState
{
	frameTimesMs: [ProfilerFrameHistorySize]float32,
	fpsHistory: [ProfilerFrameHistorySize]float32,
	frameHistoryNext: uint32,
	frameHistoryCount: uint32,
	selectedThreadID: uint32,
	pauseHistory: bool,
	autoSelectThread: bool
}

ProfilerState::()
{
	for (i .. ProfilerFrameHistorySize)
	{
		this.frameTimesMs[i] = float32(0.0);
		this.fpsHistory[i] = float32(0.0);
	}

	this.frameHistoryNext = 0;
	this.frameHistoryCount = 0;
	this.selectedThreadID = uint32(-1);
	this.pauseHistory = false;
	this.autoSelectThread = true;
}

state ThreadProfilerSnapshot
{
	threadID: uint32,
	sampleCount: uint32,
	lastFunction: *_Function,
	functionCount: uint32,
	functions: [ProfilerCallstackDepth]*_Function
}

threadToCallstack := SparseSet<Callstack>();
lock := Mutex();
profilerState := ProfilerState();
profilerRegistered := false;

UpdateFrameHistory()
{
	if (profilerState.pauseHistory) return;

	io := ImGui_GetIO();
	index := profilerState.frameHistoryNext;

	profilerState.frameTimesMs[index] = io.DeltaTime * float32(1000.0);
	profilerState.fpsHistory[index] = io.Framerate;

	profilerState.frameHistoryNext = (index + 1) % ProfilerFrameHistorySize;
	if (profilerState.frameHistoryCount < ProfilerFrameHistorySize)
	{
		profilerState.frameHistoryCount += 1;
	}
}

float32 GetFrameHistoryMax(values: [ProfilerFrameHistorySize]float32, count: uint32, minimum: float32)
{
	maxValue := minimum;

	for (i .. count)
	{
		value := values[i];
		if (value > maxValue) maxValue = value;
	}

	return maxValue;
}

bool RegisterCallStackExtension()
{
	if (profilerRegistered) return true;

	registered := RegisterInterpreterExtension(
		::(func: *_Function, params: *_Interop_Vector<_Operand>, threadID: int32)
		{
			if (!threadToCallstack.Has(threadID))
			{
				lock.Lock();
				defer lock.Unlock();
				threadToCallstack.Insert(threadID, Callstack());
			}

			callstack := threadToCallstack.Get(threadID);
			callstack.functions.Insert(func);
			callstack.sampleCount += 1;
			callstack.lastFunction = func;
		}
	);

	if (registered) profilerRegistered = true;
	return registered;
}

AddProfilerToWindow(scene: *Scene, imGuiWindowEntity: Entity)
{
	if (!RegisterCallStackExtension()) return;

	log "Registered profiler extension";

	imGuiWindow := scene.GetComponent<ImGuiWindow>(imGuiWindowEntity);

	imGuiWindow.renderFuncs.Add(
		::(window: *ImGuiWindow, data: *any)
		{
			UpdateFrameHistory();

			windowOpen := true;
			if (!ImGui_Begin("Profiler"[0], windowOpen@, 0))
			{
				ImGui_End();
				return;
			}

			io := ImGui_GetIO();
			frameMs := (io.DeltaTime * float32(1000.0)) as int32;
			fps := io.Framerate as int32;

			ImGui_SeparatorText("Frame"[0]);

			fpsText := "FPS: " + IntToString(fps);
			defer delete fpsText;
			ImGui_Text(fpsText[0]);

			ImGui_SameLine();

			frameText := "Frame: " + IntToString(frameMs) + " ms";
			defer delete frameText;
			ImGui_Text(frameText[0]);

			ImGui_SameLine();
			ImGui_Checkbox("Pause History"[0], profilerState.pauseHistory@);

			renderStatsText := "Windows: " + IntToString(io.MetricsActiveWindows) +
				" | Vtx: " + IntToString(io.MetricsRenderVertices) +
				" | Idx: " + IntToString(io.MetricsRenderIndices);
			defer delete renderStatsText;
			ImGui_TextDisabled(renderStatsText[0]);

			if (profilerState.frameHistoryCount > 0)
			{
				frameHistoryMax := GetFrameHistoryMax(profilerState.frameTimesMs, profilerState.frameHistoryCount, float32(16.0));
				fpsHistoryMax := GetFrameHistoryMax(profilerState.fpsHistory, profilerState.frameHistoryCount, float32(60.0));

				ImGui_PlotLinesEx(
					"Frame ms"[0],
					profilerState.frameTimesMs[0]@,
					profilerState.frameHistoryCount as int32,
					profilerState.frameHistoryNext as int32,
					null,
					float32(0.0),
					frameHistoryMax,
					{float32(0.0), float32(80.0)},
					#sizeof float32
				);

				ImGui_PlotLinesEx(
					"FPS"[0],
					profilerState.fpsHistory[0]@,
					profilerState.frameHistoryCount as int32,
					profilerState.frameHistoryNext as int32,
					null,
					float32(0.0),
					fpsHistoryMax,
					{float32(0.0), float32(80.0)},
					#sizeof float32
				);
			}

			snapshots := [ProfilerMaxVisibleThreads]ThreadProfilerSnapshot;
			threadCount := uint32(0);

			lock.Lock();

			for (kv in threadToCallstack)
			{
				if (threadCount >= ProfilerMaxVisibleThreads) break;

				callstack := kv.value;
				snapshot := snapshots[threadCount]@;

				snapshot.threadID = kv.key;
				snapshot.sampleCount = callstack.sampleCount;
				snapshot.lastFunction = callstack.lastFunction;
				snapshot.functionCount = 0;

				// for (i .. ProfilerCallstackDepth)
				// {
				// 	func := callstack.functions[i];
				// 	snapshot.functions[i] = func;
				// 	if (func) snapshot.functionCount += 1;
				// }

				threadCount += 1;
			}

			lock.Unlock();

			selectedThreadFound := false;
			selectedThreadIndex := uint32(0);

			for (i .. threadCount)
			{
				if (snapshots[i].threadID == profilerState.selectedThreadID)
				{
					selectedThreadFound = true;
					selectedThreadIndex = i;
					break;
				}
			}

			if (!selectedThreadFound && threadCount > 0)
			{
				if (profilerState.autoSelectThread || profilerState.selectedThreadID == uint32(-1))
				{
					profilerState.selectedThreadID = snapshots[0].threadID;
					selectedThreadFound = true;
					selectedThreadIndex = 0;
				}
			}

			ImGui_SeparatorText("Threads"[0]);
			ImGui_Checkbox("Auto Select First Thread"[0], profilerState.autoSelectThread@);

			if (!threadCount)
			{
				ImGui_TextDisabled("No thread samples captured yet."[0]);
				ImGui_End();
				return;
			}

			if (ImGui_BeginTable("ProfilerThreads"[0], 3,
				ImGuiTableFlags_.ImGuiTableFlags_Borders |
				ImGuiTableFlags_.ImGuiTableFlags_RowBg |
				ImGuiTableFlags_.ImGuiTableFlags_Resizable |
				ImGuiTableFlags_.ImGuiTableFlags_SizingStretchSame))
			{
				ImGui_TableSetupColumn("Thread"[0], 0);
				ImGui_TableSetupColumn("Samples"[0], 0);
				ImGui_TableSetupColumn("Last Function"[0], 0);
				ImGui_TableHeadersRow();

				for (i .. threadCount)
				{
					snapshot := snapshots[i]@;
					isSelected := profilerState.selectedThreadID == snapshot.threadID;

					ImGui_TableNextRow();
					ImGui_TableSetColumnIndex(0);

					threadLabel := "Thread " + UIntToString(snapshot.threadID);
					defer delete threadLabel;

					if (ImGui_SelectableEx(
						threadLabel[0],
						isSelected,
						ImGuiSelectableFlags_.ImGuiSelectableFlags_SpanAllColumns,
						{float32(0.0), float32(0.0)}
					))
					{
						profilerState.selectedThreadID = snapshot.threadID;
						selectedThreadFound = true;
						selectedThreadIndex = i;
					}

					ImGui_TableSetColumnIndex(1);
					sampleText := UIntToString(snapshot.sampleCount);
					defer delete sampleText;
					ImGui_Text(sampleText[0]);

					ImGui_TableSetColumnIndex(2);
					if (snapshot.lastFunction)
					{
						lastFunctionName := snapshot.lastFunction.name.ToString();
						defer delete lastFunctionName;
						ImGui_Text(lastFunctionName[0]);
					}
					else
					{
						ImGui_TextDisabled("No samples"[0]);
					}
				}

				ImGui_EndTable();
			}

			ImGui_SeparatorText("Trace"[0]);

			if (!selectedThreadFound)
			{
				ImGui_TextDisabled("Select a thread to inspect its latest trace."[0]);
				ImGui_End();
				return;
			}

			selectedSnapshot := snapshots[selectedThreadIndex]@;

			selectedThreadText := "Thread " + UIntToString(selectedSnapshot.threadID) +
				" | Samples: " + UIntToString(selectedSnapshot.sampleCount);
			defer delete selectedThreadText;
			ImGui_Text(selectedThreadText[0]);

			if (selectedSnapshot.lastFunction)
			{
				lastFunctionText := "Latest function: " + selectedSnapshot.lastFunction.name.ToString();
				defer delete lastFunctionText;
				ImGui_TextDisabled(lastFunctionText[0]);
			}

			ImGui_TextDisabled("Depth 0 is the most recent sampled function."[0]);

			if (ImGui_BeginTable("ProfilerTrace"[0], 2,
				ImGuiTableFlags_.ImGuiTableFlags_Borders |
				ImGuiTableFlags_.ImGuiTableFlags_RowBg |
				ImGuiTableFlags_.ImGuiTableFlags_Resizable |
				ImGuiTableFlags_.ImGuiTableFlags_SizingStretchProp))
			{
				ImGui_TableSetupColumn("Depth"[0], 0);
				ImGui_TableSetupColumn("Function"[0], 0);
				ImGui_TableHeadersRow();

				for (i .. ProfilerCallstackDepth)
				{
					func := selectedSnapshot.functions[i];
					if (!func) continue;

					ImGui_TableNextRow();

					ImGui_TableSetColumnIndex(0);
					depthText := IntToString(i);
					defer delete depthText;
					ImGui_Text(depthText[0]);

					ImGui_TableSetColumnIndex(1);
					functionName := func.name.ToString();
					defer delete functionName;
					ImGui_Text(functionName[0]);
				}

				ImGui_EndTable();
			}

			ImGui_End();
		}
	);
}
