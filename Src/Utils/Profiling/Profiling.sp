package Utils

import ECS
import ImGui
import Thread
import FixedRingBuffer
import Mutex
import SparseSet
import Math

state Callstack
{
	functions: FixedRingBuffer<*_Function, 16>
}

Callstack::()
{
	this.functions.Init(null);
}

threadToCallstack := SparseSet<Callstack>();
lock := Mutex();

bool RegisterCallStackExtension()
{
	return RegisterInterpreterExtension(
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
		}
	);
}

AddProfilerToWindow(scene: *Scene, imGuiWindowEntity: Entity)
{
	if (!RegisterCallStackExtension()) return;

	imGuiWindow := scene.GetComponent<ImGuiWindow>(imGuiWindowEntity);

	imGuiWindow.renderFuncs.Add(
		::(window: *ImGuiWindow, data: *any)
		{
			ImGui_Begin("Callstacks"[0], true@, 0);

			ImGui_BeginTable("Threads"[0], threadToCallstack.count, 0);

			callstacks := [256]*Callstack;
			callstackCount := 0;

			for (kv in threadToCallstack)
			{
				threadID := kv.key;
				callstack := kv.value;

				threadStr := "Thread: " + UIntToString(threadID);
				defer delete threadStr;

				ImGui_TableSetupColumn(threadStr[0], 0);

				callstacks[callstackCount] = callstack;
				callstackCount += 1;
			}

			ImGui_TableHeadersRow();

			for (row .. 16)
			{
				ImGui_TableNextRow();
				for (column .. callstackCount)
				{
					callstack := callstacks[column];
					ImGui_TableSetColumnIndex(column);

					func := callstack.functions[row];
					if (func)
					{
						ImGui_Text(func.name.ToString()[0]);
					}
				}
			}

			ImGui_EndTable();

			ImGui_End();
		}
	);
}