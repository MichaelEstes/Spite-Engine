package EditorPanels

import EditorWindow
import ECS
import ImGui
import Time
import Mutex
import SparseSet

FlameEventCapacity := 4096;
FlameMaxFunctionTotals := 256;
FlameTotalRowsShown := 15;

threadLabelStr := "Thread ";

state FlameEvent
{
	func: *_Function,
	ticks: int64
}

state FlameThreadTrack
{
	events: [FlameEventCapacity]FlameEvent,
	next: uint32,
	count: uint32
}

FlameThreadTrack::()
{
	this.next = 0;
	this.count = 0;
}

state FlameGraphState
{
	viewDurationMs: float32,
	panOffsetMs: float32,
	showTotals: bool
}

FlameGraphState::()
{
	this.viewDurationMs = float32(16.0);
	this.panOffsetMs = float32(0.0);
	this.showTotals = false;
}

state FlameFunctionTotal
{
	func: *_Function,
	totalTicks: int64,
	calls: uint32
}

flameThreadTracks := SparseSet<FlameThreadTrack>();
flameLock := Mutex();
flameState := FlameGraphState();
flameCapturePaused := false;
flameRegistered := false;

bool RegisterFlameGraphExtension()
{
	if (flameRegistered) return true;

	registered := RegisterInterpreterExtension(
		::(func: *_Function, params: *_Interop_Vector<_Operand>, threadID: int32)
		{
			if (flameCapturePaused) return;

			if (!flameThreadTracks.Has(threadID))
			{
				flameLock.Lock();
				defer flameLock.Unlock();
				flameThreadTracks.Insert(threadID, FlameThreadTrack());
			}

			track := flameThreadTracks.Get(threadID);
			track.events[track.next] = {func, Time.Ticks()} as FlameEvent;
			track.next = (track.next + 1) % FlameEventCapacity;
			if (track.count < FlameEventCapacity) track.count += 1;
		}
	);

	if (registered) flameRegistered = true;
	return registered;
}

uint32 FlameFunctionColor(func: *_Function)
{
	hash := (((func as uint) >> 6) as uint32) * uint32(2654435761);
	r := (hash & uint32(0xFF)) | uint32(0x60);
	g := ((hash >> 8) & uint32(0xFF)) | uint32(0x60);
	b := ((hash >> 16) & uint32(0xFF)) | uint32(0x60);
	return uint32(0xFF000000) | (b << 16) | (g << 8) | r;
}

int64 FlameMsToTicks(ms: float32) => ((ms as float64) * (Time.Frequency as float64) / float64(1000.0)) as int64;

int64 FlameTicksToUs(ticks: int64) => (ticks * int64(1000000)) / Time.Frequency;

ImGuiRenderFunc CreateFlameGraphPanel(panel: EditorPanel, entity: Entity, scene: *Scene)
{
	RegisterFlameGraphExtension();

	return ImGuiRenderFunc(::(window: *ImGuiWindow, data: *any)
	{
		windowOpen := true;
		if (!ImGui_Begin("Flame Graph"[0], windowOpen@, 0))
		{
			ImGui_End();
			return;
		}

		if (!flameRegistered)
		{
			ImGui_TextDisabled("Failed to register interpreter extension."[0]);
			ImGui_End();
			return;
		}

		ImGui_Checkbox("Pause Capture"[0], flameCapturePaused@);
		ImGui_SameLine();
		ImGui_Checkbox("Function Totals"[0], flameState.showTotals@);
		ImGui_SameLine();
		if (ImGui_SmallButton("Reset View"[0]))
		{
			flameState.viewDurationMs = float32(16.0);
			flameState.panOffsetMs = float32(0.0);
		}

		ImGui_SliderFloat("View Width (ms)"[0], flameState.viewDurationMs@, float32(0.1), float32(500.0));
		ImGui_TextDisabled("Scroll to zoom, drag to pan. A span ends when its thread enters the next function."[0]);

		threadCount := flameThreadTracks.count;
		if (!threadCount)
		{
			ImGui_TextDisabled("No samples captured yet."[0]);
			ImGui_End();
			return;
		}

		laneHeight := float32(24.0);
		lanePad := float32(4.0);

		canvasPos := ImGui_GetCursorScreenPos();
		avail := ImGui_GetContentRegionAvail();
		canvasHeight := (threadCount as float32) * (laneHeight + lanePad);

		ImGui_InvisibleButton("FlameCanvas"[0], {avail.x, canvasHeight}, 0);

		io := ImGui_GetIO();
		hovered := ImGui_IsItemHovered(0);

		if (hovered && io.MouseWheel != float32(0.0))
		{
			mouseFrac := (io.MousePos.x - canvasPos.x) / avail.x;
			oldDuration := flameState.viewDurationMs;

			if (io.MouseWheel > float32(0.0)) flameState.viewDurationMs = oldDuration / float32(1.25);
			else flameState.viewDurationMs = oldDuration * float32(1.25);

			if (flameState.viewDurationMs < float32(0.05)) flameState.viewDurationMs = float32(0.05);
			if (flameState.viewDurationMs > float32(1000.0)) flameState.viewDurationMs = float32(1000.0);

			flameState.panOffsetMs += (float32(1.0) - mouseFrac) * (oldDuration - flameState.viewDurationMs);
		}

		if (ImGui_IsItemActive())
		{
			flameState.panOffsetMs += (io.MouseDelta.x / avail.x) * flameState.viewDurationMs;
		}

		if (flameState.panOffsetMs < float32(0.0)) flameState.panOffsetMs = float32(0.0);

		drawList := ImGui_GetWindowDrawList();
		ImDrawList_AddRectFilled(
			drawList,
			canvasPos,
			{canvasPos.x + avail.x, canvasPos.y + canvasHeight},
			uint32(0xFF161616)
		);

		capacity := FlameEventCapacity as uint32;
		durTicks := FlameMsToTicks(flameState.viewDurationMs);
		fontOffset := (laneHeight - ImGui_GetFontSize()) * float32(0.5);

		totals := [FlameMaxFunctionTotals]FlameFunctionTotal;
		totalCount := uint32(0);

		flameLock.Lock();

		latest := int64(0);
		for (kv in flameThreadTracks)
		{
			track := kv.value;
			if (!track.count) continue;

			lastTicks := track.events[(track.next + capacity - 1) % capacity].ticks;
			if (lastTicks > latest) latest = lastTicks;
		}

		if (!latest)
		{
			flameLock.Unlock();
			ImGui_TextDisabled("No samples captured yet."[0]);
			ImGui_End();
			return;
		}

		viewEnd := latest - FlameMsToTicks(flameState.panOffsetMs);
		viewStart := viewEnd - durTicks;
		scale := (avail.x as float64) / (durTicks as float64);

		laneIndex := uint32(0);
		for (kv in flameThreadTracks)
		{
			track := kv.value;
			laneTop := canvasPos.y + (laneIndex as float32) * (laneHeight + lanePad);
			laneBottom := laneTop + laneHeight;
			laneIndex += 1;

			// Walk newest to oldest so fully off-view history breaks out early
			nextTicks := latest;
			for (i .. track.count)
			{
				event := track.events[(track.next + capacity - 1 - i) % capacity]@;
				spanEnd := nextTicks;
				nextTicks = event.ticks;

				if (event.ticks > viewEnd) continue;
				if (spanEnd < viewStart) break;

				clampedStart := event.ticks;
				if (clampedStart < viewStart) clampedStart = viewStart;
				clampedEnd := spanEnd;
				if (clampedEnd > viewEnd) clampedEnd = viewEnd;

				if (flameState.showTotals)
				{
					visibleTicks := clampedEnd - clampedStart;
					found := false;
					for (t .. totalCount)
					{
						total := totals[t]@;
						if (total.func == event.func)
						{
							total.totalTicks += visibleTicks;
							total.calls += 1;
							found = true;
							break;
						}
					}

					if (!found && totalCount < FlameMaxFunctionTotals)
					{
						totals[totalCount] = {event.func, visibleTicks, uint32(1)} as FlameFunctionTotal;
						totalCount += 1;
					}
				}

				x0 := canvasPos.x + (((clampedStart - viewStart) as float64) * scale) as float32;
				x1 := canvasPos.x + (((clampedEnd - viewStart) as float64) * scale) as float32;
				if (x1 - x0 < float32(0.25)) continue;

				ImDrawList_AddRectFilled(drawList, {x0, laneTop}, {x1, laneBottom}, FlameFunctionColor(event.func));

				if (hovered && ImGui_IsMouseHoveringRect({x0, laneTop}, {x1, laneBottom}))
				{
					durationStr := IntToString(FlameTicksToUs(spanEnd - event.ticks) as int);
					tooltip := event.func.name.ToString().Copy();
					defer {
						delete durationStr;
						delete tooltip;
					}

					tooltip.AppendIn(" | ");
					tooltip.AppendIn(durationStr);
					tooltip.AppendIn(" us");

					if (ImGui_BeginTooltip())
					{
						ImGui_Text(tooltip[0]);
						ImGui_EndTooltip();
					}
				}

				if (x1 - x0 > float32(32.0))
				{
					name := event.func.name.ToString();
					ImDrawList_PushClipRect(drawList, {x0, laneTop}, {x1, laneBottom}, true);
					ImDrawList_AddText(drawList, {x0 + float32(4.0), laneTop + fontOffset}, uint32(0xFFFFFFFF), name[0]);
					ImDrawList_PopClipRect(drawList);
				}
			}

			threadIDStr := UIntToString(kv.key);
			threadLabel := threadLabelStr.Copy();
			defer {
				delete threadIDStr;
				delete threadLabel;
			}

			threadLabel.AppendIn(threadIDStr);
			ImDrawList_AddText(drawList, {canvasPos.x + float32(4.0), laneTop + fontOffset}, uint32(0xFFAAAAAA), threadLabel[0]);
		}

		flameLock.Unlock();

		if (flameState.showTotals && totalCount)
		{
			ImGui_SeparatorText("Function Totals"[0]);

			shown := totalCount;
			if (shown > FlameTotalRowsShown) shown = FlameTotalRowsShown;

			for (i .. shown)
			{
				maxIndex := i;
				for (j .. totalCount)
				{
					if (j <= i) continue;
					if (totals[j].totalTicks > totals[maxIndex].totalTicks) maxIndex = j;
				}

				if (maxIndex != i)
				{
					temp := totals[i];
					totals[i] = totals[maxIndex];
					totals[maxIndex] = temp;
				}
			}

			if (ImGui_BeginTable("FlameTotals"[0], 4,
				ImGuiTableFlags_.ImGuiTableFlags_Borders |
				ImGuiTableFlags_.ImGuiTableFlags_RowBg |
				ImGuiTableFlags_.ImGuiTableFlags_Resizable |
				ImGuiTableFlags_.ImGuiTableFlags_SizingStretchProp))
			{
				ImGui_TableSetupColumn("Function"[0], 0);
				ImGui_TableSetupColumn("Calls"[0], 0);
				ImGui_TableSetupColumn("Time (us)"[0], 0);
				ImGui_TableSetupColumn("% of View"[0], 0);
				ImGui_TableHeadersRow();

				for (i .. shown)
				{
					total := totals[i]@;

					ImGui_TableNextRow();

					ImGui_TableSetColumnIndex(0);
					name := total.func.name.ToString();
					ImGui_Text(name[0]);

					ImGui_TableSetColumnIndex(1);
					callsText := UIntToString(total.calls);
					defer delete callsText;
					ImGui_Text(callsText[0]);

					ImGui_TableSetColumnIndex(2);
					timeText := IntToString(FlameTicksToUs(total.totalTicks) as int);
					defer delete timeText;
					ImGui_Text(timeText[0]);

					ImGui_TableSetColumnIndex(3);
					percentText := IntToString(((total.totalTicks * int64(100)) / durTicks) as int);
					defer delete percentText;
					ImGui_Text(percentText[0]);
				}

				ImGui_EndTable();
			}
		}

		ImGui_End();
	});
}

FlameGraphPanel := RegisterEditorPanel(EditorPanel("Flame Graph", CreateFlameGraphPanel));
