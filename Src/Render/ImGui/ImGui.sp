package ImGui

extern
{
	#link windows "./extern/ImGui";

	uint64 ImTextureRef_GetTexID(self: *ImTextureRef_t);
	*ImGuiContext_t ImGui_CreateContext(shared_font_atlas: *ImFontAtlas_t);
	void ImGui_DestroyContext(ctx: *ImGuiContext_t);
	*ImGuiContext_t ImGui_GetCurrentContext();
	void ImGui_SetCurrentContext(ctx: *ImGuiContext_t);
	*ImGuiIO_t ImGui_GetIO();
	*ImGuiPlatformIO_t ImGui_GetPlatformIO();
	*ImGuiStyle_t ImGui_GetStyle();
	void ImGui_NewFrame();
	void ImGui_EndFrame();
	void ImGui_Render();
	*ImDrawData_t ImGui_GetDrawData();
	void ImGui_ShowDemoWindow(p_open: *bool);
	void ImGui_ShowMetricsWindow(p_open: *bool);
	void ImGui_ShowDebugLogWindow(p_open: *bool);
	void ImGui_ShowIDStackToolWindow();
	void ImGui_ShowIDStackToolWindowEx(p_open: *bool);
	void ImGui_ShowAboutWindow(p_open: *bool);
	void ImGui_ShowStyleEditor(styleRef: *ImGuiStyle_t);
	bool ImGui_ShowStyleSelector(label: *byte);
	void ImGui_ShowFontSelector(label: *byte);
	void ImGui_ShowUserGuide();
	*byte ImGui_GetVersion();
	void ImGui_StyleColorsDark(dst: *ImGuiStyle_t);
	void ImGui_StyleColorsLight(dst: *ImGuiStyle_t);
	void ImGui_StyleColorsClassic(dst: *ImGuiStyle_t);
	bool ImGui_Begin(name: *byte, p_open: *bool, flags: int32);
	void ImGui_End();
	bool ImGui_BeginChild(str_id: *byte, size: ImVec2_t, child_flags: int32, window_flags: int32);
	bool ImGui_BeginChildID(id: uint32, size: ImVec2_t, child_flags: int32, window_flags: int32);
	void ImGui_EndChild();
	bool ImGui_IsWindowAppearing();
	bool ImGui_IsWindowCollapsed();
	bool ImGui_IsWindowFocused(flags: int32);
	bool ImGui_IsWindowHovered(flags: int32);
	*ImDrawList_t ImGui_GetWindowDrawList();
	ImVec2_t ImGui_GetWindowPos();
	ImVec2_t ImGui_GetWindowSize();
	float32 ImGui_GetWindowWidth();
	float32 ImGui_GetWindowHeight();
	void ImGui_SetNextWindowPos(pos: ImVec2_t, cond: int32);
	void ImGui_SetNextWindowPosEx(pos: ImVec2_t, cond: int32, pivot: ImVec2_t);
	void ImGui_SetNextWindowSize(size: ImVec2_t, cond: int32);
	void ImGui_SetNextWindowSizeConstraints(size_min: ImVec2_t, size_max: ImVec2_t, custom_callback: ::(), custom_callback_data: *void);
	void ImGui_SetNextWindowContentSize(size: ImVec2_t);
	void ImGui_SetNextWindowCollapsed(collapsed: bool, cond: int32);
	void ImGui_SetNextWindowFocus();
	void ImGui_SetNextWindowScroll(scroll: ImVec2_t);
	void ImGui_SetNextWindowBgAlpha(alpha: float32);
	void ImGui_SetWindowPos(pos: ImVec2_t, cond: int32);
	void ImGui_SetWindowSize(size: ImVec2_t, cond: int32);
	void ImGui_SetWindowCollapsed(collapsed: bool, cond: int32);
	void ImGui_SetWindowFocus();
	void ImGui_SetWindowPosStr(name: *byte, pos: ImVec2_t, cond: int32);
	void ImGui_SetWindowSizeStr(name: *byte, size: ImVec2_t, cond: int32);
	void ImGui_SetWindowCollapsedStr(name: *byte, collapsed: bool, cond: int32);
	void ImGui_SetWindowFocusStr(name: *byte);
	float32 ImGui_GetScrollX();
	float32 ImGui_GetScrollY();
	void ImGui_SetScrollX(scroll_x: float32);
	void ImGui_SetScrollY(scroll_y: float32);
	float32 ImGui_GetScrollMaxX();
	float32 ImGui_GetScrollMaxY();
	void ImGui_SetScrollHereX(center_x_ratio: float32);
	void ImGui_SetScrollHereY(center_y_ratio: float32);
	void ImGui_SetScrollFromPosX(local_x: float32, center_x_ratio: float32);
	void ImGui_SetScrollFromPosY(local_y: float32, center_y_ratio: float32);
	void ImGui_PushFontFloat(font: *ImFont_t, font_size_base_unscaled: float32);
	void ImGui_PopFont();
	*ImFont_t ImGui_GetFont();
	float32 ImGui_GetFontSize();
	*ImFontBaked_t ImGui_GetFontBaked();
	void ImGui_PushStyleColor(idx: int32, col: uint32);
	void ImGui_PushStyleColorImVec4(idx: int32, col: ImVec4_t);
	void ImGui_PopStyleColor();
	void ImGui_PopStyleColorEx(count: int32);
	void ImGui_PushStyleVar(idx: int32, val: float32);
	void ImGui_PushStyleVarImVec2(idx: int32, val: ImVec2_t);
	void ImGui_PushStyleVarX(idx: int32, val_x: float32);
	void ImGui_PushStyleVarY(idx: int32, val_y: float32);
	void ImGui_PopStyleVar();
	void ImGui_PopStyleVarEx(count: int32);
	void ImGui_PushItemFlag(option: int32, enabled: bool);
	void ImGui_PopItemFlag();
	void ImGui_PushItemWidth(item_width: float32);
	void ImGui_PopItemWidth();
	void ImGui_SetNextItemWidth(item_width: float32);
	float32 ImGui_CalcItemWidth();
	void ImGui_PushTextWrapPos(wrap_local_pos_x: float32);
	void ImGui_PopTextWrapPos();
	ImVec2_t ImGui_GetFontTexUvWhitePixel();
	uint32 ImGui_GetColorU32(idx: int32);
	uint32 ImGui_GetColorU32Ex(idx: int32, alpha_mul: float32);
	uint32 ImGui_GetColorU32ImVec4(col: ImVec4_t);
	uint32 ImGui_GetColorU32ImU32(col: uint32);
	uint32 ImGui_GetColorU32ImU32Ex(col: uint32, alpha_mul: float32);
	*ImVec4_t ImGui_GetStyleColorVec4(idx: int32);
	ImVec2_t ImGui_GetCursorScreenPos();
	void ImGui_SetCursorScreenPos(pos: ImVec2_t);
	ImVec2_t ImGui_GetContentRegionAvail();
	ImVec2_t ImGui_GetCursorPos();
	float32 ImGui_GetCursorPosX();
	float32 ImGui_GetCursorPosY();
	void ImGui_SetCursorPos(local_pos: ImVec2_t);
	void ImGui_SetCursorPosX(local_x: float32);
	void ImGui_SetCursorPosY(local_y: float32);
	ImVec2_t ImGui_GetCursorStartPos();
	void ImGui_Separator();
	void ImGui_SameLine();
	void ImGui_SameLineEx(offset_from_start_x: float32, spacing: float32);
	void ImGui_NewLine();
	void ImGui_Spacing();
	void ImGui_Dummy(size: ImVec2_t);
	void ImGui_Indent();
	void ImGui_IndentEx(indent_w: float32);
	void ImGui_Unindent();
	void ImGui_UnindentEx(indent_w: float32);
	void ImGui_BeginGroup();
	void ImGui_EndGroup();
	void ImGui_AlignTextToFramePadding();
	float32 ImGui_GetTextLineHeight();
	float32 ImGui_GetTextLineHeightWithSpacing();
	float32 ImGui_GetFrameHeight();
	float32 ImGui_GetFrameHeightWithSpacing();
	void ImGui_PushID(str_id: *byte);
	void ImGui_PushIDStr(str_id_begin: *byte, str_id_end: *byte);
	void ImGui_PushIDPtr(ptr_id: *void);
	void ImGui_PushIDInt(int_id: int32);
	void ImGui_PopID();
	uint32 ImGui_GetID(str_id: *byte);
	uint32 ImGui_GetIDStr(str_id_begin: *byte, str_id_end: *byte);
	uint32 ImGui_GetIDPtr(ptr_id: *void);
	uint32 ImGui_GetIDInt(int_id: int32);
	void ImGui_TextUnformatted(text: *byte);
	void ImGui_TextUnformattedEx(text: *byte, text_end: *byte);
	void ImGui_Text(fmt: *byte);
	void ImGui_TextV(fmt: *byte, args: any);
	void ImGui_TextColored(col: ImVec4_t, fmt: *byte);
	void ImGui_TextColoredUnformatted(col: ImVec4_t, text: *byte);
	void ImGui_TextColoredV(col: ImVec4_t, fmt: *byte, args: any);
	void ImGui_TextDisabled(fmt: *byte);
	void ImGui_TextDisabledUnformatted(text: *byte);
	void ImGui_TextDisabledV(fmt: *byte, args: any);
	void ImGui_TextWrapped(fmt: *byte);
	void ImGui_TextWrappedUnformatted(text: *byte);
	void ImGui_TextWrappedV(fmt: *byte, args: any);
	void ImGui_LabelText(label: *byte, fmt: *byte);
	void ImGui_LabelTextUnformatted(label: *byte, text: *byte);
	void ImGui_LabelTextV(label: *byte, fmt: *byte, args: any);
	void ImGui_BulletText(fmt: *byte);
	void ImGui_BulletTextUnformatted(text: *byte);
	void ImGui_BulletTextV(fmt: *byte, args: any);
	void ImGui_SeparatorText(label: *byte);
	bool ImGui_Button(label: *byte);
	bool ImGui_ButtonEx(label: *byte, size: ImVec2_t);
	bool ImGui_SmallButton(label: *byte);
	bool ImGui_InvisibleButton(str_id: *byte, size: ImVec2_t, flags: int32);
	bool ImGui_ArrowButton(str_id: *byte, dir: int32);
	bool ImGui_Checkbox(label: *byte, v: *bool);
	bool ImGui_CheckboxFlagsIntPtr(label: *byte, flags: *int32, flags_value: int32);
	bool ImGui_CheckboxFlagsUintPtr(label: *byte, flags: *uint32, flags_value: uint32);
	bool ImGui_RadioButton(label: *byte, active: bool);
	bool ImGui_RadioButtonIntPtr(label: *byte, v: *int32, v_button: int32);
	void ImGui_ProgressBar(fraction: float32, size_arg: ImVec2_t, overlay: *byte);
	void ImGui_Bullet();
	bool ImGui_TextLink(label: *byte);
	bool ImGui_TextLinkOpenURL(label: *byte);
	bool ImGui_TextLinkOpenURLEx(label: *byte, url: *byte);
	void ImGui_Image(tex_ref: ImTextureRef_t, image_size: ImVec2_t);
	void ImGui_ImageEx(tex_ref: ImTextureRef_t, image_size: ImVec2_t, uv0: ImVec2_t, uv1: ImVec2_t);
	void ImGui_ImageWithBg(tex_ref: ImTextureRef_t, image_size: ImVec2_t);
	void ImGui_ImageWithBgEx(tex_ref: ImTextureRef_t, image_size: ImVec2_t, uv0: ImVec2_t, uv1: ImVec2_t, bg_col: ImVec4_t, tint_col: ImVec4_t);
	bool ImGui_ImageButton(str_id: *byte, tex_ref: ImTextureRef_t, image_size: ImVec2_t);
	bool ImGui_ImageButtonEx(str_id: *byte, tex_ref: ImTextureRef_t, image_size: ImVec2_t, uv0: ImVec2_t, uv1: ImVec2_t, bg_col: ImVec4_t, tint_col: ImVec4_t);
	bool ImGui_BeginCombo(label: *byte, preview_value: *byte, flags: int32);
	void ImGui_EndCombo();
	bool ImGui_ComboChar(label: *byte, current_item: *int32, items: **byte, items_count: int32);
	bool ImGui_ComboCharEx(label: *byte, current_item: *int32, items: **byte, items_count: int32, popup_max_height_in_items: int32);
	bool ImGui_Combo(label: *byte, current_item: *int32, items_separated_by_zeros: *byte);
	bool ImGui_ComboEx(label: *byte, current_item: *int32, items_separated_by_zeros: *byte, popup_max_height_in_items: int32);
	bool ImGui_ComboCallback(label: *byte, current_item: *int32, getter: ::(), user_data: *void, items_count: int32);
	bool ImGui_ComboCallbackEx(label: *byte, current_item: *int32, getter: ::(), user_data: *void, items_count: int32, popup_max_height_in_items: int32);
	bool ImGui_DragFloat(label: *byte, v: *float32);
	bool ImGui_DragFloatEx(label: *byte, v: *float32, v_speed: float32, v_min: float32, v_max: float32, format: *byte, flags: int32);
	bool ImGui_DragFloat2(label: *byte, v: [2]float32);
	bool ImGui_DragFloat2Ex(label: *byte, v: [2]float32, v_speed: float32, v_min: float32, v_max: float32, format: *byte, flags: int32);
	bool ImGui_DragFloat3(label: *byte, v: [3]float32);
	bool ImGui_DragFloat3Ex(label: *byte, v: [3]float32, v_speed: float32, v_min: float32, v_max: float32, format: *byte, flags: int32);
	bool ImGui_DragFloat4(label: *byte, v: [4]float32);
	bool ImGui_DragFloat4Ex(label: *byte, v: [4]float32, v_speed: float32, v_min: float32, v_max: float32, format: *byte, flags: int32);
	bool ImGui_DragFloatRange2(label: *byte, v_current_min: *float32, v_current_max: *float32);
	bool ImGui_DragFloatRange2Ex(label: *byte, v_current_min: *float32, v_current_max: *float32, v_speed: float32, v_min: float32, v_max: float32, format: *byte, format_max: *byte, flags: int32);
	bool ImGui_DragInt(label: *byte, v: *int32);
	bool ImGui_DragIntEx(label: *byte, v: *int32, v_speed: float32, v_min: int32, v_max: int32, format: *byte, flags: int32);
	bool ImGui_DragInt2(label: *byte, v: [2]int32);
	bool ImGui_DragInt2Ex(label: *byte, v: [2]int32, v_speed: float32, v_min: int32, v_max: int32, format: *byte, flags: int32);
	bool ImGui_DragInt3(label: *byte, v: [3]int32);
	bool ImGui_DragInt3Ex(label: *byte, v: [3]int32, v_speed: float32, v_min: int32, v_max: int32, format: *byte, flags: int32);
	bool ImGui_DragInt4(label: *byte, v: [4]int32);
	bool ImGui_DragInt4Ex(label: *byte, v: [4]int32, v_speed: float32, v_min: int32, v_max: int32, format: *byte, flags: int32);
	bool ImGui_DragIntRange2(label: *byte, v_current_min: *int32, v_current_max: *int32);
	bool ImGui_DragIntRange2Ex(label: *byte, v_current_min: *int32, v_current_max: *int32, v_speed: float32, v_min: int32, v_max: int32, format: *byte, format_max: *byte, flags: int32);
	bool ImGui_DragScalar(label: *byte, data_type: int32, p_data: *void);
	bool ImGui_DragScalarEx(label: *byte, data_type: int32, p_data: *void, v_speed: float32, p_min: *void, p_max: *void, format: *byte, flags: int32);
	bool ImGui_DragScalarN(label: *byte, data_type: int32, p_data: *void, components: int32);
	bool ImGui_DragScalarNEx(label: *byte, data_type: int32, p_data: *void, components: int32, v_speed: float32, p_min: *void, p_max: *void, format: *byte, flags: int32);
	bool ImGui_SliderFloat(label: *byte, v: *float32, v_min: float32, v_max: float32);
	bool ImGui_SliderFloatEx(label: *byte, v: *float32, v_min: float32, v_max: float32, format: *byte, flags: int32);
	bool ImGui_SliderFloat2(label: *byte, v: [2]float32, v_min: float32, v_max: float32);
	bool ImGui_SliderFloat2Ex(label: *byte, v: [2]float32, v_min: float32, v_max: float32, format: *byte, flags: int32);
	bool ImGui_SliderFloat3(label: *byte, v: [3]float32, v_min: float32, v_max: float32);
	bool ImGui_SliderFloat3Ex(label: *byte, v: [3]float32, v_min: float32, v_max: float32, format: *byte, flags: int32);
	bool ImGui_SliderFloat4(label: *byte, v: [4]float32, v_min: float32, v_max: float32);
	bool ImGui_SliderFloat4Ex(label: *byte, v: [4]float32, v_min: float32, v_max: float32, format: *byte, flags: int32);
	bool ImGui_SliderAngle(label: *byte, v_rad: *float32);
	bool ImGui_SliderAngleEx(label: *byte, v_rad: *float32, v_degrees_min: float32, v_degrees_max: float32, format: *byte, flags: int32);
	bool ImGui_SliderInt(label: *byte, v: *int32, v_min: int32, v_max: int32);
	bool ImGui_SliderIntEx(label: *byte, v: *int32, v_min: int32, v_max: int32, format: *byte, flags: int32);
	bool ImGui_SliderInt2(label: *byte, v: [2]int32, v_min: int32, v_max: int32);
	bool ImGui_SliderInt2Ex(label: *byte, v: [2]int32, v_min: int32, v_max: int32, format: *byte, flags: int32);
	bool ImGui_SliderInt3(label: *byte, v: [3]int32, v_min: int32, v_max: int32);
	bool ImGui_SliderInt3Ex(label: *byte, v: [3]int32, v_min: int32, v_max: int32, format: *byte, flags: int32);
	bool ImGui_SliderInt4(label: *byte, v: [4]int32, v_min: int32, v_max: int32);
	bool ImGui_SliderInt4Ex(label: *byte, v: [4]int32, v_min: int32, v_max: int32, format: *byte, flags: int32);
	bool ImGui_SliderScalar(label: *byte, data_type: int32, p_data: *void, p_min: *void, p_max: *void);
	bool ImGui_SliderScalarEx(label: *byte, data_type: int32, p_data: *void, p_min: *void, p_max: *void, format: *byte, flags: int32);
	bool ImGui_SliderScalarN(label: *byte, data_type: int32, p_data: *void, components: int32, p_min: *void, p_max: *void);
	bool ImGui_SliderScalarNEx(label: *byte, data_type: int32, p_data: *void, components: int32, p_min: *void, p_max: *void, format: *byte, flags: int32);
	bool ImGui_VSliderFloat(label: *byte, size: ImVec2_t, v: *float32, v_min: float32, v_max: float32);
	bool ImGui_VSliderFloatEx(label: *byte, size: ImVec2_t, v: *float32, v_min: float32, v_max: float32, format: *byte, flags: int32);
	bool ImGui_VSliderInt(label: *byte, size: ImVec2_t, v: *int32, v_min: int32, v_max: int32);
	bool ImGui_VSliderIntEx(label: *byte, size: ImVec2_t, v: *int32, v_min: int32, v_max: int32, format: *byte, flags: int32);
	bool ImGui_VSliderScalar(label: *byte, size: ImVec2_t, data_type: int32, p_data: *void, p_min: *void, p_max: *void);
	bool ImGui_VSliderScalarEx(label: *byte, size: ImVec2_t, data_type: int32, p_data: *void, p_min: *void, p_max: *void, format: *byte, flags: int32);
	bool ImGui_InputText(label: *byte, buf: *byte, buf_size: uint64, flags: int32);
	bool ImGui_InputTextEx(label: *byte, buf: *byte, buf_size: uint64, flags: int32, callback: ::(), user_data: *void);
	bool ImGui_InputTextMultiline(label: *byte, buf: *byte, buf_size: uint64);
	bool ImGui_InputTextMultilineEx(label: *byte, buf: *byte, buf_size: uint64, size: ImVec2_t, flags: int32, callback: ::(), user_data: *void);
	bool ImGui_InputTextWithHint(label: *byte, hint: *byte, buf: *byte, buf_size: uint64, flags: int32);
	bool ImGui_InputTextWithHintEx(label: *byte, hint: *byte, buf: *byte, buf_size: uint64, flags: int32, callback: ::(), user_data: *void);
	bool ImGui_InputFloat(label: *byte, v: *float32);
	bool ImGui_InputFloatEx(label: *byte, v: *float32, step: float32, step_fast: float32, format: *byte, flags: int32);
	bool ImGui_InputFloat2(label: *byte, v: [2]float32);
	bool ImGui_InputFloat2Ex(label: *byte, v: [2]float32, format: *byte, flags: int32);
	bool ImGui_InputFloat3(label: *byte, v: [3]float32);
	bool ImGui_InputFloat3Ex(label: *byte, v: [3]float32, format: *byte, flags: int32);
	bool ImGui_InputFloat4(label: *byte, v: [4]float32);
	bool ImGui_InputFloat4Ex(label: *byte, v: [4]float32, format: *byte, flags: int32);
	bool ImGui_InputInt(label: *byte, v: *int32);
	bool ImGui_InputIntEx(label: *byte, v: *int32, step: int32, step_fast: int32, flags: int32);
	bool ImGui_InputInt2(label: *byte, v: [2]int32, flags: int32);
	bool ImGui_InputInt3(label: *byte, v: [3]int32, flags: int32);
	bool ImGui_InputInt4(label: *byte, v: [4]int32, flags: int32);
	bool ImGui_InputDouble(label: *byte, v: *float64);
	bool ImGui_InputDoubleEx(label: *byte, v: *float64, step: float64, step_fast: float64, format: *byte, flags: int32);
	bool ImGui_InputScalar(label: *byte, data_type: int32, p_data: *void);
	bool ImGui_InputScalarEx(label: *byte, data_type: int32, p_data: *void, p_step: *void, p_step_fast: *void, format: *byte, flags: int32);
	bool ImGui_InputScalarN(label: *byte, data_type: int32, p_data: *void, components: int32);
	bool ImGui_InputScalarNEx(label: *byte, data_type: int32, p_data: *void, components: int32, p_step: *void, p_step_fast: *void, format: *byte, flags: int32);
	bool ImGui_ColorEdit3(label: *byte, col: [3]float32, flags: int32);
	bool ImGui_ColorEdit4(label: *byte, col: [4]float32, flags: int32);
	bool ImGui_ColorPicker3(label: *byte, col: [3]float32, flags: int32);
	bool ImGui_ColorPicker4(label: *byte, col: [4]float32, flags: int32, ref_col: *float32);
	bool ImGui_ColorButton(desc_id: *byte, col: ImVec4_t, flags: int32);
	bool ImGui_ColorButtonEx(desc_id: *byte, col: ImVec4_t, flags: int32, size: ImVec2_t);
	void ImGui_SetColorEditOptions(flags: int32);
	bool ImGui_TreeNode(label: *byte);
	bool ImGui_TreeNodeStr(str_id: *byte, fmt: *byte);
	bool ImGui_TreeNodeStrUnformatted(str_id: *byte, text: *byte);
	bool ImGui_TreeNodePtr(ptr_id: *void, fmt: *byte);
	bool ImGui_TreeNodePtrUnformatted(ptr_id: *void, text: *byte);
	bool ImGui_TreeNodeV(str_id: *byte, fmt: *byte, args: any);
	bool ImGui_TreeNodeVPtr(ptr_id: *void, fmt: *byte, args: any);
	bool ImGui_TreeNodeEx(label: *byte, flags: int32);
	bool ImGui_TreeNodeExStr(str_id: *byte, flags: int32, fmt: *byte);
	bool ImGui_TreeNodeExStrUnformatted(str_id: *byte, flags: int32, text: *byte);
	bool ImGui_TreeNodeExPtr(ptr_id: *void, flags: int32, fmt: *byte);
	bool ImGui_TreeNodeExPtrUnformatted(ptr_id: *void, flags: int32, text: *byte);
	bool ImGui_TreeNodeExV(str_id: *byte, flags: int32, fmt: *byte, args: any);
	bool ImGui_TreeNodeExVPtr(ptr_id: *void, flags: int32, fmt: *byte, args: any);
	void ImGui_TreePush(str_id: *byte);
	void ImGui_TreePushPtr(ptr_id: *void);
	void ImGui_TreePop();
	float32 ImGui_GetTreeNodeToLabelSpacing();
	bool ImGui_CollapsingHeader(label: *byte, flags: int32);
	bool ImGui_CollapsingHeaderBoolPtr(label: *byte, p_visible: *bool, flags: int32);
	void ImGui_SetNextItemOpen(is_open: bool, cond: int32);
	void ImGui_SetNextItemStorageID(storage_id: uint32);
	bool ImGui_Selectable(label: *byte);
	bool ImGui_SelectableEx(label: *byte, selected: bool, flags: int32, size: ImVec2_t);
	bool ImGui_SelectableBoolPtr(label: *byte, p_selected: *bool, flags: int32);
	bool ImGui_SelectableBoolPtrEx(label: *byte, p_selected: *bool, flags: int32, size: ImVec2_t);
	*ImGuiMultiSelectIO_t ImGui_BeginMultiSelect(flags: int32);
	*ImGuiMultiSelectIO_t ImGui_BeginMultiSelectEx(flags: int32, selection_size: int32, items_count: int32);
	*ImGuiMultiSelectIO_t ImGui_EndMultiSelect();
	void ImGui_SetNextItemSelectionUserData(selection_user_data: int64);
	bool ImGui_IsItemToggledSelection();
	bool ImGui_BeginListBox(label: *byte, size: ImVec2_t);
	void ImGui_EndListBox();
	bool ImGui_ListBox(label: *byte, current_item: *int32, items: **byte, items_count: int32, height_in_items: int32);
	bool ImGui_ListBoxCallback(label: *byte, current_item: *int32, getter: ::(), user_data: *void, items_count: int32);
	bool ImGui_ListBoxCallbackEx(label: *byte, current_item: *int32, getter: ::(), user_data: *void, items_count: int32, height_in_items: int32);
	void ImGui_PlotLines(label: *byte, values: *float32, values_count: int32);
	void ImGui_PlotLinesEx(label: *byte, values: *float32, values_count: int32, values_offset: int32, overlay_text: *byte, scale_min: float32, scale_max: float32, graph_size: ImVec2_t, stride: int32);
	void ImGui_PlotLinesCallback(label: *byte, values_getter: ::(), data: *void, values_count: int32);
	void ImGui_PlotLinesCallbackEx(label: *byte, values_getter: ::(), data: *void, values_count: int32, values_offset: int32, overlay_text: *byte, scale_min: float32, scale_max: float32, graph_size: ImVec2_t);
	void ImGui_PlotHistogram(label: *byte, values: *float32, values_count: int32);
	void ImGui_PlotHistogramEx(label: *byte, values: *float32, values_count: int32, values_offset: int32, overlay_text: *byte, scale_min: float32, scale_max: float32, graph_size: ImVec2_t, stride: int32);
	void ImGui_PlotHistogramCallback(label: *byte, values_getter: ::(), data: *void, values_count: int32);
	void ImGui_PlotHistogramCallbackEx(label: *byte, values_getter: ::(), data: *void, values_count: int32, values_offset: int32, overlay_text: *byte, scale_min: float32, scale_max: float32, graph_size: ImVec2_t);
	bool ImGui_BeginMenuBar();
	void ImGui_EndMenuBar();
	bool ImGui_BeginMainMenuBar();
	void ImGui_EndMainMenuBar();
	bool ImGui_BeginMenu(label: *byte);
	bool ImGui_BeginMenuEx(label: *byte, enabled: bool);
	void ImGui_EndMenu();
	bool ImGui_MenuItem(label: *byte);
	bool ImGui_MenuItemEx(label: *byte, shortcut: *byte, selected: bool, enabled: bool);
	bool ImGui_MenuItemBoolPtr(label: *byte, shortcut: *byte, p_selected: *bool, enabled: bool);
	bool ImGui_BeginTooltip();
	void ImGui_EndTooltip();
	void ImGui_SetTooltip(fmt: *byte);
	void ImGui_SetTooltipUnformatted(text: *byte);
	void ImGui_SetTooltipV(fmt: *byte, args: any);
	bool ImGui_BeginItemTooltip();
	void ImGui_SetItemTooltip(fmt: *byte);
	void ImGui_SetItemTooltipUnformatted(text: *byte);
	void ImGui_SetItemTooltipV(fmt: *byte, args: any);
	bool ImGui_BeginPopup(str_id: *byte, flags: int32);
	bool ImGui_BeginPopupModal(name: *byte, p_open: *bool, flags: int32);
	void ImGui_EndPopup();
	void ImGui_OpenPopup(str_id: *byte, popup_flags: int32);
	void ImGui_OpenPopupID(id: uint32, popup_flags: int32);
	void ImGui_OpenPopupOnItemClick(str_id: *byte, popup_flags: int32);
	void ImGui_CloseCurrentPopup();
	bool ImGui_BeginPopupContextItem();
	bool ImGui_BeginPopupContextItemEx(str_id: *byte, popup_flags: int32);
	bool ImGui_BeginPopupContextWindow();
	bool ImGui_BeginPopupContextWindowEx(str_id: *byte, popup_flags: int32);
	bool ImGui_BeginPopupContextVoid();
	bool ImGui_BeginPopupContextVoidEx(str_id: *byte, popup_flags: int32);
	bool ImGui_IsPopupOpen(str_id: *byte, flags: int32);
	bool ImGui_BeginTable(str_id: *byte, columns: int32, flags: int32);
	bool ImGui_BeginTableEx(str_id: *byte, columns: int32, flags: int32, outer_size: ImVec2_t, inner_width: float32);
	void ImGui_EndTable();
	void ImGui_TableNextRow();
	void ImGui_TableNextRowEx(row_flags: int32, min_row_height: float32);
	bool ImGui_TableNextColumn();
	bool ImGui_TableSetColumnIndex(column_n: int32);
	void ImGui_TableSetupColumn(label: *byte, flags: int32);
	void ImGui_TableSetupColumnEx(label: *byte, flags: int32, init_width_or_weight: float32, user_id: uint32);
	void ImGui_TableSetupScrollFreeze(cols: int32, rows: int32);
	void ImGui_TableHeader(label: *byte);
	void ImGui_TableHeadersRow();
	void ImGui_TableAngledHeadersRow();
	*ImGuiTableSortSpecs_t ImGui_TableGetSortSpecs();
	int32 ImGui_TableGetColumnCount();
	int32 ImGui_TableGetColumnIndex();
	int32 ImGui_TableGetRowIndex();
	*byte ImGui_TableGetColumnName(column_n: int32);
	int32 ImGui_TableGetColumnFlags(column_n: int32);
	void ImGui_TableSetColumnEnabled(column_n: int32, v: bool);
	int32 ImGui_TableGetHoveredColumn();
	void ImGui_TableSetBgColor(target: int32, color: uint32, column_n: int32);
	void ImGui_Columns();
	void ImGui_ColumnsEx(count: int32, id: *byte, borders: bool);
	void ImGui_NextColumn();
	int32 ImGui_GetColumnIndex();
	float32 ImGui_GetColumnWidth(column_index: int32);
	void ImGui_SetColumnWidth(column_index: int32, width: float32);
	float32 ImGui_GetColumnOffset(column_index: int32);
	void ImGui_SetColumnOffset(column_index: int32, offset_x: float32);
	int32 ImGui_GetColumnsCount();
	bool ImGui_BeginTabBar(str_id: *byte, flags: int32);
	void ImGui_EndTabBar();
	bool ImGui_BeginTabItem(label: *byte, p_open: *bool, flags: int32);
	void ImGui_EndTabItem();
	bool ImGui_TabItemButton(label: *byte, flags: int32);
	void ImGui_SetTabItemClosed(tab_or_docked_window_label: *byte);
	void ImGui_LogToTTY(auto_open_depth: int32);
	void ImGui_LogToFile(auto_open_depth: int32, filename: *byte);
	void ImGui_LogToClipboard(auto_open_depth: int32);
	void ImGui_LogFinish();
	void ImGui_LogButtons();
	void ImGui_LogText(fmt: *byte);
	void ImGui_LogTextUnformatted(text: *byte);
	void ImGui_LogTextV(fmt: *byte, args: any);
	bool ImGui_BeginDragDropSource(flags: int32);
	bool ImGui_SetDragDropPayload(type: *byte, data: *void, sz: uint64, cond: int32);
	void ImGui_EndDragDropSource();
	bool ImGui_BeginDragDropTarget();
	*ImGuiPayload_t ImGui_AcceptDragDropPayload(type: *byte, flags: int32);
	void ImGui_EndDragDropTarget();
	*ImGuiPayload_t ImGui_GetDragDropPayload();
	void ImGui_BeginDisabled(disabled: bool);
	void ImGui_EndDisabled();
	void ImGui_PushClipRect(clip_rect_min: ImVec2_t, clip_rect_max: ImVec2_t, intersect_with_current_clip_rect: bool);
	void ImGui_PopClipRect();
	void ImGui_SetItemDefaultFocus();
	void ImGui_SetKeyboardFocusHere();
	void ImGui_SetKeyboardFocusHereEx(offset: int32);
	void ImGui_SetNavCursorVisible(visible: bool);
	void ImGui_SetNextItemAllowOverlap();
	bool ImGui_IsItemHovered(flags: int32);
	bool ImGui_IsItemActive();
	bool ImGui_IsItemFocused();
	bool ImGui_IsItemClicked();
	bool ImGui_IsItemClickedEx(mouse_button: int32);
	bool ImGui_IsItemVisible();
	bool ImGui_IsItemEdited();
	bool ImGui_IsItemActivated();
	bool ImGui_IsItemDeactivated();
	bool ImGui_IsItemDeactivatedAfterEdit();
	bool ImGui_IsItemToggledOpen();
	bool ImGui_IsAnyItemHovered();
	bool ImGui_IsAnyItemActive();
	bool ImGui_IsAnyItemFocused();
	uint32 ImGui_GetItemID();
	ImVec2_t ImGui_GetItemRectMin();
	ImVec2_t ImGui_GetItemRectMax();
	ImVec2_t ImGui_GetItemRectSize();
	*ImGuiViewport_t ImGui_GetMainViewport();
	*ImDrawList_t ImGui_GetBackgroundDrawList();
	*ImDrawList_t ImGui_GetForegroundDrawList();
	bool ImGui_IsRectVisibleBySize(size: ImVec2_t);
	bool ImGui_IsRectVisible(rect_min: ImVec2_t, rect_max: ImVec2_t);
	float64 ImGui_GetTime();
	int32 ImGui_GetFrameCount();
	*ImDrawListSharedData_t ImGui_GetDrawListSharedData();
	*byte ImGui_GetStyleColorName(idx: int32);
	void ImGui_SetStateStorage(storage: *ImGuiStorage_t);
	*ImGuiStorage_t ImGui_GetStateStorage();
	ImVec2_t ImGui_CalcTextSize(text: *byte);
	ImVec2_t ImGui_CalcTextSizeEx(text: *byte, text_end: *byte, hide_text_after_double_hash: bool, wrap_width: float32);
	ImVec4_t ImGui_ColorConvertU32ToFloat4(val: uint32);
	uint32 ImGui_ColorConvertFloat4ToU32(val: ImVec4_t);
	void ImGui_ColorConvertRGBtoHSV(r: float32, g: float32, b: float32, out_h: *float32, out_s: *float32, out_v: *float32);
	void ImGui_ColorConvertHSVtoRGB(h: float32, s: float32, v: float32, out_r: *float32, out_g: *float32, out_b: *float32);
	bool ImGui_IsKeyDown(key: int32);
	bool ImGui_IsKeyPressed(key: int32);
	bool ImGui_IsKeyPressedEx(key: int32, repeat: bool);
	bool ImGui_IsKeyReleased(key: int32);
	bool ImGui_IsKeyChordPressed(key_chord: int32);
	int32 ImGui_GetKeyPressedAmount(key: int32, repeat_delay: float32, rate: float32);
	*byte ImGui_GetKeyName(key: int32);
	void ImGui_SetNextFrameWantCaptureKeyboard(want_capture_keyboard: bool);
	bool ImGui_Shortcut(key_chord: int32, flags: int32);
	void ImGui_SetNextItemShortcut(key_chord: int32, flags: int32);
	void ImGui_SetItemKeyOwner(key: int32);
	bool ImGui_IsMouseDown(button: int32);
	bool ImGui_IsMouseClicked(button: int32);
	bool ImGui_IsMouseClickedEx(button: int32, repeat: bool);
	bool ImGui_IsMouseReleased(button: int32);
	bool ImGui_IsMouseDoubleClicked(button: int32);
	bool ImGui_IsMouseReleasedWithDelay(button: int32, delay: float32);
	int32 ImGui_GetMouseClickedCount(button: int32);
	bool ImGui_IsMouseHoveringRect(r_min: ImVec2_t, r_max: ImVec2_t);
	bool ImGui_IsMouseHoveringRectEx(r_min: ImVec2_t, r_max: ImVec2_t, clip: bool);
	bool ImGui_IsMousePosValid(mouse_pos: *ImVec2_t);
	bool ImGui_IsAnyMouseDown();
	ImVec2_t ImGui_GetMousePos();
	ImVec2_t ImGui_GetMousePosOnOpeningCurrentPopup();
	bool ImGui_IsMouseDragging(button: int32, lock_threshold: float32);
	ImVec2_t ImGui_GetMouseDragDelta(button: int32, lock_threshold: float32);
	void ImGui_ResetMouseDragDelta();
	void ImGui_ResetMouseDragDeltaEx(button: int32);
	int32 ImGui_GetMouseCursor();
	void ImGui_SetMouseCursor(cursor_type: int32);
	void ImGui_SetNextFrameWantCaptureMouse(want_capture_mouse: bool);
	*byte ImGui_GetClipboardText();
	void ImGui_SetClipboardText(text: *byte);
	void ImGui_LoadIniSettingsFromDisk(ini_filename: *byte);
	void ImGui_LoadIniSettingsFromMemory(ini_data: *byte, ini_size: uint64);
	void ImGui_SaveIniSettingsToDisk(ini_filename: *byte);
	*byte ImGui_SaveIniSettingsToMemory(out_ini_size: *uint64);
	void ImGui_DebugTextEncoding(text: *byte);
	void ImGui_DebugFlashStyleColor(idx: int32);
	void ImGui_DebugStartItemPicker();
	bool ImGui_DebugCheckVersionAndDataLayout(version_str: *byte, sz_io: uint64, sz_style: uint64, sz_vec2: uint64, sz_vec4: uint64, sz_drawvert: uint64, sz_drawidx: uint64);
	void ImGui_DebugLog(fmt: *byte);
	void ImGui_DebugLogUnformatted(text: *byte);
	void ImGui_DebugLogV(fmt: *byte, args: any);
	void ImGui_SetAllocatorFunctions(alloc_func: ::(), free_func: ::(), user_data: *void);
	void ImGui_GetAllocatorFunctions(p_alloc_func: *::(), p_free_func: *::(), p_user_data: **void);
	*void ImGui_MemAlloc(size: uint64);
	void ImGui_MemFree(ptr: *void);
	void ImVector_Construct(vector: *void);
	void ImVector_Destruct(vector: *void);
	void ImGuiStyle_ScaleAllSizes(self: *ImGuiStyle_t, scale_factor: float32);
	void ImGuiIO_AddKeyEvent(self: *ImGuiIO_t, key: int32, down: bool);
	void ImGuiIO_AddKeyAnalogEvent(self: *ImGuiIO_t, key: int32, down: bool, v: float32);
	void ImGuiIO_AddMousePosEvent(self: *ImGuiIO_t, x: float32, y: float32);
	void ImGuiIO_AddMouseButtonEvent(self: *ImGuiIO_t, button: int32, down: bool);
	void ImGuiIO_AddMouseWheelEvent(self: *ImGuiIO_t, wheel_x: float32, wheel_y: float32);
	void ImGuiIO_AddMouseSourceEvent(self: *ImGuiIO_t, source: int32);
	void ImGuiIO_AddFocusEvent(self: *ImGuiIO_t, focused: bool);
	void ImGuiIO_AddInputCharacter(self: *ImGuiIO_t, c: uint32);
	void ImGuiIO_AddInputCharacterUTF16(self: *ImGuiIO_t, c: uint16);
	void ImGuiIO_AddInputCharactersUTF8(self: *ImGuiIO_t, str: *byte);
	void ImGuiIO_SetKeyEventNativeData(self: *ImGuiIO_t, key: int32, native_keycode: int32, native_scancode: int32);
	void ImGuiIO_SetKeyEventNativeDataEx(self: *ImGuiIO_t, key: int32, native_keycode: int32, native_scancode: int32, native_legacy_index: int32);
	void ImGuiIO_SetAppAcceptingEvents(self: *ImGuiIO_t, accepting_events: bool);
	void ImGuiIO_ClearEventsQueue(self: *ImGuiIO_t);
	void ImGuiIO_ClearInputKeys(self: *ImGuiIO_t);
	void ImGuiIO_ClearInputMouse(self: *ImGuiIO_t);
	void ImGuiInputTextCallbackData_DeleteChars(self: *ImGuiInputTextCallbackData_t, pos: int32, bytes_count: int32);
	void ImGuiInputTextCallbackData_InsertChars(self: *ImGuiInputTextCallbackData_t, pos: int32, text: *byte, text_end: *byte);
	void ImGuiInputTextCallbackData_SelectAll(self: *ImGuiInputTextCallbackData_t);
	void ImGuiInputTextCallbackData_ClearSelection(self: *ImGuiInputTextCallbackData_t);
	bool ImGuiInputTextCallbackData_HasSelection(self: *ImGuiInputTextCallbackData_t);
	void ImGuiPayload_Clear(self: *ImGuiPayload_t);
	bool ImGuiPayload_IsDataType(self: *ImGuiPayload_t, type: *byte);
	bool ImGuiPayload_IsPreview(self: *ImGuiPayload_t);
	bool ImGuiPayload_IsDelivery(self: *ImGuiPayload_t);
	bool ImGuiTextFilter_ImGuiTextRange_empty(self: *ImGuiTextFilter_ImGuiTextRange_t);
	void ImGuiTextFilter_ImGuiTextRange_split(self: *ImGuiTextFilter_ImGuiTextRange_t, separator: byte, out: *ImVector_ImGuiTextRange_t);
	bool ImGuiTextFilter_Draw(self: *ImGuiTextFilter_t, label: *byte, width: float32);
	bool ImGuiTextFilter_PassFilter(self: *ImGuiTextFilter_t, text: *byte, text_end: *byte);
	void ImGuiTextFilter_Build(self: *ImGuiTextFilter_t);
	void ImGuiTextFilter_Clear(self: *ImGuiTextFilter_t);
	bool ImGuiTextFilter_IsActive(self: *ImGuiTextFilter_t);
	*byte ImGuiTextBuffer_begin(self: *ImGuiTextBuffer_t);
	*byte ImGuiTextBuffer_end(self: *ImGuiTextBuffer_t);
	int32 ImGuiTextBuffer_size(self: *ImGuiTextBuffer_t);
	bool ImGuiTextBuffer_empty(self: *ImGuiTextBuffer_t);
	void ImGuiTextBuffer_clear(self: *ImGuiTextBuffer_t);
	void ImGuiTextBuffer_resize(self: *ImGuiTextBuffer_t, size: int32);
	void ImGuiTextBuffer_reserve(self: *ImGuiTextBuffer_t, capacity: int32);
	*byte ImGuiTextBuffer_c_str(self: *ImGuiTextBuffer_t);
	void ImGuiTextBuffer_append(self: *ImGuiTextBuffer_t, str: *byte, str_end: *byte);
	void ImGuiTextBuffer_appendf(self: *ImGuiTextBuffer_t, fmt: *byte);
	void ImGuiTextBuffer_appendfv(self: *ImGuiTextBuffer_t, fmt: *byte, args: any);
	void ImGuiStorage_Clear(self: *ImGuiStorage_t);
	int32 ImGuiStorage_GetInt(self: *ImGuiStorage_t, key: uint32, default_val: int32);
	void ImGuiStorage_SetInt(self: *ImGuiStorage_t, key: uint32, val: int32);
	bool ImGuiStorage_GetBool(self: *ImGuiStorage_t, key: uint32, default_val: bool);
	void ImGuiStorage_SetBool(self: *ImGuiStorage_t, key: uint32, val: bool);
	float32 ImGuiStorage_GetFloat(self: *ImGuiStorage_t, key: uint32, default_val: float32);
	void ImGuiStorage_SetFloat(self: *ImGuiStorage_t, key: uint32, val: float32);
	*void ImGuiStorage_GetVoidPtr(self: *ImGuiStorage_t, key: uint32);
	void ImGuiStorage_SetVoidPtr(self: *ImGuiStorage_t, key: uint32, val: *void);
	*int32 ImGuiStorage_GetIntRef(self: *ImGuiStorage_t, key: uint32, default_val: int32);
	*bool ImGuiStorage_GetBoolRef(self: *ImGuiStorage_t, key: uint32, default_val: bool);
	*float32 ImGuiStorage_GetFloatRef(self: *ImGuiStorage_t, key: uint32, default_val: float32);
	**void ImGuiStorage_GetVoidPtrRef(self: *ImGuiStorage_t, key: uint32, default_val: *void);
	void ImGuiStorage_BuildSortByKey(self: *ImGuiStorage_t);
	void ImGuiStorage_SetAllInt(self: *ImGuiStorage_t, val: int32);
	void ImGuiListClipper_Begin(self: *ImGuiListClipper_t, items_count: int32, items_height: float32);
	void ImGuiListClipper_End(self: *ImGuiListClipper_t);
	bool ImGuiListClipper_Step(self: *ImGuiListClipper_t);
	void ImGuiListClipper_IncludeItemByIndex(self: *ImGuiListClipper_t, item_index: int32);
	void ImGuiListClipper_IncludeItemsByIndex(self: *ImGuiListClipper_t, item_begin: int32, item_end: int32);
	void ImGuiListClipper_SeekCursorForItem(self: *ImGuiListClipper_t, item_index: int32);
	void ImColor_SetHSV(self: *ImColor_t, h: float32, s: float32, v: float32, a: float32);
	ImColor_t ImColor_HSV(h: float32, s: float32, v: float32, a: float32);
	void ImGuiSelectionBasicStorage_ApplyRequests(self: *ImGuiSelectionBasicStorage_t, ms_io: *ImGuiMultiSelectIO_t);
	bool ImGuiSelectionBasicStorage_Contains(self: *ImGuiSelectionBasicStorage_t, id: uint32);
	void ImGuiSelectionBasicStorage_Clear(self: *ImGuiSelectionBasicStorage_t);
	void ImGuiSelectionBasicStorage_Swap(self: *ImGuiSelectionBasicStorage_t, r: *ImGuiSelectionBasicStorage_t);
	void ImGuiSelectionBasicStorage_SetItemSelected(self: *ImGuiSelectionBasicStorage_t, id: uint32, selected: bool);
	bool ImGuiSelectionBasicStorage_GetNextSelectedItem(self: *ImGuiSelectionBasicStorage_t, opaque_it: **void, out_id: *uint32);
	uint32 ImGuiSelectionBasicStorage_GetStorageIdFromIndex(self: *ImGuiSelectionBasicStorage_t, idx: int32);
	void ImGuiSelectionExternalStorage_ApplyRequests(self: *ImGuiSelectionExternalStorage_t, ms_io: *ImGuiMultiSelectIO_t);
	uint64 ImDrawCmd_GetTexID(self: *ImDrawCmd_t);
	void ImDrawListSplitter_Clear(self: *ImDrawListSplitter_t);
	void ImDrawListSplitter_ClearFreeMemory(self: *ImDrawListSplitter_t);
	void ImDrawListSplitter_Split(self: *ImDrawListSplitter_t, draw_list: *ImDrawList_t, count: int32);
	void ImDrawListSplitter_Merge(self: *ImDrawListSplitter_t, draw_list: *ImDrawList_t);
	void ImDrawListSplitter_SetCurrentChannel(self: *ImDrawListSplitter_t, draw_list: *ImDrawList_t, channel_idx: int32);
	void ImDrawList_PushClipRect(self: *ImDrawList_t, clip_rect_min: ImVec2_t, clip_rect_max: ImVec2_t, intersect_with_current_clip_rect: bool);
	void ImDrawList_PushClipRectFullScreen(self: *ImDrawList_t);
	void ImDrawList_PopClipRect(self: *ImDrawList_t);
	void ImDrawList_PushTexture(self: *ImDrawList_t, tex_ref: ImTextureRef_t);
	void ImDrawList_PopTexture(self: *ImDrawList_t);
	ImVec2_t ImDrawList_GetClipRectMin(self: *ImDrawList_t);
	ImVec2_t ImDrawList_GetClipRectMax(self: *ImDrawList_t);
	void ImDrawList_AddLine(self: *ImDrawList_t, p1: ImVec2_t, p2: ImVec2_t, col: uint32);
	void ImDrawList_AddLineEx(self: *ImDrawList_t, p1: ImVec2_t, p2: ImVec2_t, col: uint32, thickness: float32);
	void ImDrawList_AddRect(self: *ImDrawList_t, p_min: ImVec2_t, p_max: ImVec2_t, col: uint32);
	void ImDrawList_AddRectEx(self: *ImDrawList_t, p_min: ImVec2_t, p_max: ImVec2_t, col: uint32, rounding: float32, flags: int32, thickness: float32);
	void ImDrawList_AddRectFilled(self: *ImDrawList_t, p_min: ImVec2_t, p_max: ImVec2_t, col: uint32);
	void ImDrawList_AddRectFilledEx(self: *ImDrawList_t, p_min: ImVec2_t, p_max: ImVec2_t, col: uint32, rounding: float32, flags: int32);
	void ImDrawList_AddRectFilledMultiColor(self: *ImDrawList_t, p_min: ImVec2_t, p_max: ImVec2_t, col_upr_left: uint32, col_upr_right: uint32, col_bot_right: uint32, col_bot_left: uint32);
	void ImDrawList_AddQuad(self: *ImDrawList_t, p1: ImVec2_t, p2: ImVec2_t, p3: ImVec2_t, p4: ImVec2_t, col: uint32);
	void ImDrawList_AddQuadEx(self: *ImDrawList_t, p1: ImVec2_t, p2: ImVec2_t, p3: ImVec2_t, p4: ImVec2_t, col: uint32, thickness: float32);
	void ImDrawList_AddQuadFilled(self: *ImDrawList_t, p1: ImVec2_t, p2: ImVec2_t, p3: ImVec2_t, p4: ImVec2_t, col: uint32);
	void ImDrawList_AddTriangle(self: *ImDrawList_t, p1: ImVec2_t, p2: ImVec2_t, p3: ImVec2_t, col: uint32);
	void ImDrawList_AddTriangleEx(self: *ImDrawList_t, p1: ImVec2_t, p2: ImVec2_t, p3: ImVec2_t, col: uint32, thickness: float32);
	void ImDrawList_AddTriangleFilled(self: *ImDrawList_t, p1: ImVec2_t, p2: ImVec2_t, p3: ImVec2_t, col: uint32);
	void ImDrawList_AddCircle(self: *ImDrawList_t, center: ImVec2_t, radius: float32, col: uint32);
	void ImDrawList_AddCircleEx(self: *ImDrawList_t, center: ImVec2_t, radius: float32, col: uint32, num_segments: int32, thickness: float32);
	void ImDrawList_AddCircleFilled(self: *ImDrawList_t, center: ImVec2_t, radius: float32, col: uint32, num_segments: int32);
	void ImDrawList_AddNgon(self: *ImDrawList_t, center: ImVec2_t, radius: float32, col: uint32, num_segments: int32);
	void ImDrawList_AddNgonEx(self: *ImDrawList_t, center: ImVec2_t, radius: float32, col: uint32, num_segments: int32, thickness: float32);
	void ImDrawList_AddNgonFilled(self: *ImDrawList_t, center: ImVec2_t, radius: float32, col: uint32, num_segments: int32);
	void ImDrawList_AddEllipse(self: *ImDrawList_t, center: ImVec2_t, radius: ImVec2_t, col: uint32);
	void ImDrawList_AddEllipseEx(self: *ImDrawList_t, center: ImVec2_t, radius: ImVec2_t, col: uint32, rot: float32, num_segments: int32, thickness: float32);
	void ImDrawList_AddEllipseFilled(self: *ImDrawList_t, center: ImVec2_t, radius: ImVec2_t, col: uint32);
	void ImDrawList_AddEllipseFilledEx(self: *ImDrawList_t, center: ImVec2_t, radius: ImVec2_t, col: uint32, rot: float32, num_segments: int32);
	void ImDrawList_AddText(self: *ImDrawList_t, pos: ImVec2_t, col: uint32, text_begin: *byte);
	void ImDrawList_AddTextEx(self: *ImDrawList_t, pos: ImVec2_t, col: uint32, text_begin: *byte, text_end: *byte);
	void ImDrawList_AddTextImFontPtr(self: *ImDrawList_t, font: *ImFont_t, font_size: float32, pos: ImVec2_t, col: uint32, text_begin: *byte);
	void ImDrawList_AddTextImFontPtrEx(self: *ImDrawList_t, font: *ImFont_t, font_size: float32, pos: ImVec2_t, col: uint32, text_begin: *byte, text_end: *byte, wrap_width: float32, cpu_fine_clip_rect: *ImVec4_t);
	void ImDrawList_AddBezierCubic(self: *ImDrawList_t, p1: ImVec2_t, p2: ImVec2_t, p3: ImVec2_t, p4: ImVec2_t, col: uint32, thickness: float32, num_segments: int32);
	void ImDrawList_AddBezierQuadratic(self: *ImDrawList_t, p1: ImVec2_t, p2: ImVec2_t, p3: ImVec2_t, col: uint32, thickness: float32, num_segments: int32);
	void ImDrawList_AddPolyline(self: *ImDrawList_t, points: *ImVec2_t, num_points: int32, col: uint32, flags: int32, thickness: float32);
	void ImDrawList_AddConvexPolyFilled(self: *ImDrawList_t, points: *ImVec2_t, num_points: int32, col: uint32);
	void ImDrawList_AddConcavePolyFilled(self: *ImDrawList_t, points: *ImVec2_t, num_points: int32, col: uint32);
	void ImDrawList_AddImage(self: *ImDrawList_t, tex_ref: ImTextureRef_t, p_min: ImVec2_t, p_max: ImVec2_t);
	void ImDrawList_AddImageEx(self: *ImDrawList_t, tex_ref: ImTextureRef_t, p_min: ImVec2_t, p_max: ImVec2_t, uv_min: ImVec2_t, uv_max: ImVec2_t, col: uint32);
	void ImDrawList_AddImageQuad(self: *ImDrawList_t, tex_ref: ImTextureRef_t, p1: ImVec2_t, p2: ImVec2_t, p3: ImVec2_t, p4: ImVec2_t);
	void ImDrawList_AddImageQuadEx(self: *ImDrawList_t, tex_ref: ImTextureRef_t, p1: ImVec2_t, p2: ImVec2_t, p3: ImVec2_t, p4: ImVec2_t, uv1: ImVec2_t, uv2: ImVec2_t, uv3: ImVec2_t, uv4: ImVec2_t, col: uint32);
	void ImDrawList_AddImageRounded(self: *ImDrawList_t, tex_ref: ImTextureRef_t, p_min: ImVec2_t, p_max: ImVec2_t, uv_min: ImVec2_t, uv_max: ImVec2_t, col: uint32, rounding: float32, flags: int32);
	void ImDrawList_PathClear(self: *ImDrawList_t);
	void ImDrawList_PathLineTo(self: *ImDrawList_t, pos: ImVec2_t);
	void ImDrawList_PathLineToMergeDuplicate(self: *ImDrawList_t, pos: ImVec2_t);
	void ImDrawList_PathFillConvex(self: *ImDrawList_t, col: uint32);
	void ImDrawList_PathFillConcave(self: *ImDrawList_t, col: uint32);
	void ImDrawList_PathStroke(self: *ImDrawList_t, col: uint32, flags: int32, thickness: float32);
	void ImDrawList_PathArcTo(self: *ImDrawList_t, center: ImVec2_t, radius: float32, a_min: float32, a_max: float32, num_segments: int32);
	void ImDrawList_PathArcToFast(self: *ImDrawList_t, center: ImVec2_t, radius: float32, a_min_of_12: int32, a_max_of_12: int32);
	void ImDrawList_PathEllipticalArcTo(self: *ImDrawList_t, center: ImVec2_t, radius: ImVec2_t, rot: float32, a_min: float32, a_max: float32);
	void ImDrawList_PathEllipticalArcToEx(self: *ImDrawList_t, center: ImVec2_t, radius: ImVec2_t, rot: float32, a_min: float32, a_max: float32, num_segments: int32);
	void ImDrawList_PathBezierCubicCurveTo(self: *ImDrawList_t, p2: ImVec2_t, p3: ImVec2_t, p4: ImVec2_t, num_segments: int32);
	void ImDrawList_PathBezierQuadraticCurveTo(self: *ImDrawList_t, p2: ImVec2_t, p3: ImVec2_t, num_segments: int32);
	void ImDrawList_PathRect(self: *ImDrawList_t, rect_min: ImVec2_t, rect_max: ImVec2_t, rounding: float32, flags: int32);
	void ImDrawList_AddCallback(self: *ImDrawList_t, callback: ::(), userdata: *void);
	void ImDrawList_AddCallbackEx(self: *ImDrawList_t, callback: ::(), userdata: *void, userdata_size: uint64);
	void ImDrawList_AddDrawCmd(self: *ImDrawList_t);
	*ImDrawList_t ImDrawList_CloneOutput(self: *ImDrawList_t);
	void ImDrawList_ChannelsSplit(self: *ImDrawList_t, count: int32);
	void ImDrawList_ChannelsMerge(self: *ImDrawList_t);
	void ImDrawList_ChannelsSetCurrent(self: *ImDrawList_t, n: int32);
	void ImDrawList_PrimReserve(self: *ImDrawList_t, idx_count: int32, vtx_count: int32);
	void ImDrawList_PrimUnreserve(self: *ImDrawList_t, idx_count: int32, vtx_count: int32);
	void ImDrawList_PrimRect(self: *ImDrawList_t, a: ImVec2_t, b: ImVec2_t, col: uint32);
	void ImDrawList_PrimRectUV(self: *ImDrawList_t, a: ImVec2_t, b: ImVec2_t, uv_a: ImVec2_t, uv_b: ImVec2_t, col: uint32);
	void ImDrawList_PrimQuadUV(self: *ImDrawList_t, a: ImVec2_t, b: ImVec2_t, c: ImVec2_t, d: ImVec2_t, uv_a: ImVec2_t, uv_b: ImVec2_t, uv_c: ImVec2_t, uv_d: ImVec2_t, col: uint32);
	void ImDrawList_PrimWriteVtx(self: *ImDrawList_t, pos: ImVec2_t, uv: ImVec2_t, col: uint32);
	void ImDrawList_PrimWriteIdx(self: *ImDrawList_t, idx: uint16);
	void ImDrawList_PrimVtx(self: *ImDrawList_t, pos: ImVec2_t, uv: ImVec2_t, col: uint32);
	void ImDrawList_PushTextureID(self: *ImDrawList_t, tex_ref: ImTextureRef_t);
	void ImDrawList_PopTextureID(self: *ImDrawList_t);
	void ImDrawList__SetDrawListSharedData(self: *ImDrawList_t, data: *ImDrawListSharedData_t);
	void ImDrawList__ResetForNewFrame(self: *ImDrawList_t);
	void ImDrawList__ClearFreeMemory(self: *ImDrawList_t);
	void ImDrawList__PopUnusedDrawCmd(self: *ImDrawList_t);
	void ImDrawList__TryMergeDrawCmds(self: *ImDrawList_t);
	void ImDrawList__OnChangedClipRect(self: *ImDrawList_t);
	void ImDrawList__OnChangedTexture(self: *ImDrawList_t);
	void ImDrawList__OnChangedVtxOffset(self: *ImDrawList_t);
	void ImDrawList__SetTexture(self: *ImDrawList_t, tex_ref: ImTextureRef_t);
	int32 ImDrawList__CalcCircleAutoSegmentCount(self: *ImDrawList_t, radius: float32);
	void ImDrawList__PathArcToFastEx(self: *ImDrawList_t, center: ImVec2_t, radius: float32, a_min_sample: int32, a_max_sample: int32, a_step: int32);
	void ImDrawList__PathArcToN(self: *ImDrawList_t, center: ImVec2_t, radius: float32, a_min: float32, a_max: float32, num_segments: int32);
	void ImDrawData_Clear(self: *ImDrawData_t);
	void ImDrawData_AddDrawList(self: *ImDrawData_t, draw_list: *ImDrawList_t);
	void ImDrawData_DeIndexAllBuffers(self: *ImDrawData_t);
	void ImDrawData_ScaleClipRects(self: *ImDrawData_t, fb_scale: ImVec2_t);
	void ImTextureData_Create(self: *ImTextureData_t, format: ImTextureFormat, w: int32, h: int32);
	void ImTextureData_DestroyPixels(self: *ImTextureData_t);
	*void ImTextureData_GetPixels(self: *ImTextureData_t);
	*void ImTextureData_GetPixelsAt(self: *ImTextureData_t, x: int32, y: int32);
	int32 ImTextureData_GetSizeInBytes(self: *ImTextureData_t);
	int32 ImTextureData_GetPitch(self: *ImTextureData_t);
	ImTextureRef_t ImTextureData_GetTexRef(self: *ImTextureData_t);
	uint64 ImTextureData_GetTexID(self: *ImTextureData_t);
	void ImTextureData_SetTexID(self: *ImTextureData_t, tex_id: uint64);
	void ImTextureData_SetStatus(self: *ImTextureData_t, status: ImTextureStatus);
	void ImFontGlyphRangesBuilder_Clear(self: *ImFontGlyphRangesBuilder_t);
	bool ImFontGlyphRangesBuilder_GetBit(self: *ImFontGlyphRangesBuilder_t, n: uint64);
	void ImFontGlyphRangesBuilder_SetBit(self: *ImFontGlyphRangesBuilder_t, n: uint64);
	void ImFontGlyphRangesBuilder_AddChar(self: *ImFontGlyphRangesBuilder_t, c: uint16);
	void ImFontGlyphRangesBuilder_AddText(self: *ImFontGlyphRangesBuilder_t, text: *byte, text_end: *byte);
	void ImFontGlyphRangesBuilder_AddRanges(self: *ImFontGlyphRangesBuilder_t, ranges: *uint16);
	void ImFontGlyphRangesBuilder_BuildRanges(self: *ImFontGlyphRangesBuilder_t, out_ranges: *ImVector_ImWchar_t);
	*ImFont_t ImFontAtlas_AddFont(self: *ImFontAtlas_t, font_cfg: *ImFontConfig_t);
	*ImFont_t ImFontAtlas_AddFontDefault(self: *ImFontAtlas_t, font_cfg: *ImFontConfig_t);
	*ImFont_t ImFontAtlas_AddFontFromFileTTF(self: *ImFontAtlas_t, filename: *byte, size_pixels: float32, font_cfg: *ImFontConfig_t, glyph_ranges: *uint16);
	*ImFont_t ImFontAtlas_AddFontFromMemoryTTF(self: *ImFontAtlas_t, font_data: *void, font_data_size: int32, size_pixels: float32, font_cfg: *ImFontConfig_t, glyph_ranges: *uint16);
	*ImFont_t ImFontAtlas_AddFontFromMemoryCompressedTTF(self: *ImFontAtlas_t, compressed_font_data: *void, compressed_font_data_size: int32, size_pixels: float32, font_cfg: *ImFontConfig_t, glyph_ranges: *uint16);
	*ImFont_t ImFontAtlas_AddFontFromMemoryCompressedBase85TTF(self: *ImFontAtlas_t, compressed_font_data_base85: *byte, size_pixels: float32, font_cfg: *ImFontConfig_t, glyph_ranges: *uint16);
	void ImFontAtlas_RemoveFont(self: *ImFontAtlas_t, font: *ImFont_t);
	void ImFontAtlas_Clear(self: *ImFontAtlas_t);
	void ImFontAtlas_CompactCache(self: *ImFontAtlas_t);
	void ImFontAtlas_SetFontLoader(self: *ImFontAtlas_t, font_loader: *ImFontLoader_t);
	void ImFontAtlas_ClearInputData(self: *ImFontAtlas_t);
	void ImFontAtlas_ClearFonts(self: *ImFontAtlas_t);
	void ImFontAtlas_ClearTexData(self: *ImFontAtlas_t);
	bool ImFontAtlas_Build(self: *ImFontAtlas_t);
	void ImFontAtlas_GetTexDataAsAlpha8(self: *ImFontAtlas_t, out_pixels: **ubyte, out_width: *int32, out_height: *int32, out_bytes_per_pixel: *int32);
	void ImFontAtlas_GetTexDataAsRGBA32(self: *ImFontAtlas_t, out_pixels: **ubyte, out_width: *int32, out_height: *int32, out_bytes_per_pixel: *int32);
	void ImFontAtlas_SetTexID(self: *ImFontAtlas_t, id: uint64);
	void ImFontAtlas_SetTexIDImTextureRef(self: *ImFontAtlas_t, id: ImTextureRef_t);
	bool ImFontAtlas_IsBuilt(self: *ImFontAtlas_t);
	*uint16 ImFontAtlas_GetGlyphRangesDefault(self: *ImFontAtlas_t);
	*uint16 ImFontAtlas_GetGlyphRangesGreek(self: *ImFontAtlas_t);
	*uint16 ImFontAtlas_GetGlyphRangesKorean(self: *ImFontAtlas_t);
	*uint16 ImFontAtlas_GetGlyphRangesJapanese(self: *ImFontAtlas_t);
	*uint16 ImFontAtlas_GetGlyphRangesChineseFull(self: *ImFontAtlas_t);
	*uint16 ImFontAtlas_GetGlyphRangesChineseSimplifiedCommon(self: *ImFontAtlas_t);
	*uint16 ImFontAtlas_GetGlyphRangesCyrillic(self: *ImFontAtlas_t);
	*uint16 ImFontAtlas_GetGlyphRangesThai(self: *ImFontAtlas_t);
	*uint16 ImFontAtlas_GetGlyphRangesVietnamese(self: *ImFontAtlas_t);
	int32 ImFontAtlas_AddCustomRect(self: *ImFontAtlas_t, width: int32, height: int32, out_r: *ImFontAtlasRect_t);
	void ImFontAtlas_RemoveCustomRect(self: *ImFontAtlas_t, id: int32);
	bool ImFontAtlas_GetCustomRect(self: *ImFontAtlas_t, id: int32, out_r: *ImFontAtlasRect_t);
	int32 ImFontAtlas_AddCustomRectRegular(self: *ImFontAtlas_t, w: int32, h: int32);
	*ImFontAtlasRect_t ImFontAtlas_GetCustomRectByIndex(self: *ImFontAtlas_t, id: int32);
	void ImFontAtlas_CalcCustomRectUV(self: *ImFontAtlas_t, r: *ImFontAtlasRect_t, out_uv_min: *ImVec2_t, out_uv_max: *ImVec2_t);
	int32 ImFontAtlas_AddCustomRectFontGlyph(self: *ImFontAtlas_t, font: *ImFont_t, codepoint: uint16, w: int32, h: int32, advance_x: float32, offset: ImVec2_t);
	int32 ImFontAtlas_AddCustomRectFontGlyphForSize(self: *ImFontAtlas_t, font: *ImFont_t, font_size: float32, codepoint: uint16, w: int32, h: int32, advance_x: float32, offset: ImVec2_t);
	void ImFontBaked_ClearOutputData(self: *ImFontBaked_t);
	*ImFontGlyph_t ImFontBaked_FindGlyph(self: *ImFontBaked_t, c: uint16);
	*ImFontGlyph_t ImFontBaked_FindGlyphNoFallback(self: *ImFontBaked_t, c: uint16);
	float32 ImFontBaked_GetCharAdvance(self: *ImFontBaked_t, c: uint16);
	bool ImFontBaked_IsGlyphLoaded(self: *ImFontBaked_t, c: uint16);
	bool ImFont_IsGlyphInFont(self: *ImFont_t, c: uint16);
	bool ImFont_IsLoaded(self: *ImFont_t);
	*byte ImFont_GetDebugName(self: *ImFont_t);
	*ImFontBaked_t ImFont_GetFontBaked(self: *ImFont_t, font_size: float32);
	*ImFontBaked_t ImFont_GetFontBakedEx(self: *ImFont_t, font_size: float32, density: float32);
	ImVec2_t ImFont_CalcTextSizeA(self: *ImFont_t, size: float32, max_width: float32, wrap_width: float32, text_begin: *byte);
	ImVec2_t ImFont_CalcTextSizeAEx(self: *ImFont_t, size: float32, max_width: float32, wrap_width: float32, text_begin: *byte, text_end: *byte, out_remaining: **byte);
	*byte ImFont_CalcWordWrapPosition(self: *ImFont_t, size: float32, text: *byte, text_end: *byte, wrap_width: float32);
	void ImFont_RenderChar(self: *ImFont_t, draw_list: *ImDrawList_t, size: float32, pos: ImVec2_t, col: uint32, c: uint16);
	void ImFont_RenderCharEx(self: *ImFont_t, draw_list: *ImDrawList_t, size: float32, pos: ImVec2_t, col: uint32, c: uint16, cpu_fine_clip: *ImVec4_t);
	void ImFont_RenderText(self: *ImFont_t, draw_list: *ImDrawList_t, size: float32, pos: ImVec2_t, col: uint32, clip_rect: ImVec4_t, text_begin: *byte, text_end: *byte, wrap_width: float32, flags: int32);
	*byte ImFont_CalcWordWrapPositionA(self: *ImFont_t, scale: float32, text: *byte, text_end: *byte, wrap_width: float32);
	void ImFont_ClearOutputData(self: *ImFont_t);
	void ImFont_AddRemapChar(self: *ImFont_t, from_codepoint: uint16, to_codepoint: uint16);
	bool ImFont_IsGlyphRangeUnused(self: *ImFont_t, c_begin: uint32, c_last: uint32);
	ImVec2_t ImGuiViewport_GetCenter(self: *ImGuiViewport_t);
	ImVec2_t ImGuiViewport_GetWorkCenter(self: *ImGuiViewport_t);
	void ImGuiPlatformIO_ClearPlatformHandlers(self: *ImGuiPlatformIO_t);
	void ImGuiPlatformIO_ClearRendererHandlers(self: *ImGuiPlatformIO_t);
	void ImGui_PushFont(font: *ImFont_t);
	void ImGui_SetWindowFontScale(scale: float32);
	void ImGui_ImageImVec4(tex_ref: ImTextureRef_t, image_size: ImVec2_t, uv0: ImVec2_t, uv1: ImVec2_t, tint_col: ImVec4_t, border_col: ImVec4_t);
	void ImGui_PushButtonRepeat(repeat: bool);
	void ImGui_PopButtonRepeat();
	void ImGui_PushTabStop(tab_stop: bool);
	void ImGui_PopTabStop();
	ImVec2_t ImGui_GetContentRegionMax();
	ImVec2_t ImGui_GetWindowContentRegionMin();
	ImVec2_t ImGui_GetWindowContentRegionMax();
	bool ImGui_BeginChildFrame(id: uint32, size: ImVec2_t);
	bool ImGui_BeginChildFrameEx(id: uint32, size: ImVec2_t, window_flags: int32);
	void ImGui_EndChildFrame();
	void ImGui_ShowStackToolWindow(p_open: *bool);
	bool ImGui_ComboObsolete(label: *byte, current_item: *int32, old_callback: ::(), user_data: *void, items_count: int32);
	bool ImGui_ComboObsoleteEx(label: *byte, current_item: *int32, old_callback: ::(), user_data: *void, items_count: int32, popup_max_height_in_items: int32);
	bool ImGui_ListBoxObsolete(label: *byte, current_item: *int32, old_callback: ::(), user_data: *void, items_count: int32);
	bool ImGui_ListBoxObsoleteEx(label: *byte, current_item: *int32, old_callback: ::(), user_data: *void, items_count: int32, height_in_items: int32);
}

enum ImGuiWindowFlags_: uint32
{
	ImGuiWindowFlags_None = 0,
	ImGuiWindowFlags_NoTitleBar = 1,
	ImGuiWindowFlags_NoResize = 2,
	ImGuiWindowFlags_NoMove = 4,
	ImGuiWindowFlags_NoScrollbar = 8,
	ImGuiWindowFlags_NoScrollWithMouse = 16,
	ImGuiWindowFlags_NoCollapse = 32,
	ImGuiWindowFlags_AlwaysAutoResize = 64,
	ImGuiWindowFlags_NoBackground = 128,
	ImGuiWindowFlags_NoSavedSettings = 256,
	ImGuiWindowFlags_NoMouseInputs = 512,
	ImGuiWindowFlags_MenuBar = 1024,
	ImGuiWindowFlags_HorizontalScrollbar = 2048,
	ImGuiWindowFlags_NoFocusOnAppearing = 4096,
	ImGuiWindowFlags_NoBringToFrontOnFocus = 8192,
	ImGuiWindowFlags_AlwaysVerticalScrollbar = 16384,
	ImGuiWindowFlags_AlwaysHorizontalScrollbar = 32768,
	ImGuiWindowFlags_NoNavInputs = 65536,
	ImGuiWindowFlags_NoNavFocus = 131072,
	ImGuiWindowFlags_UnsavedDocument = 262144,
	ImGuiWindowFlags_NoNav = 196608,
	ImGuiWindowFlags_NoDecoration = 43,
	ImGuiWindowFlags_NoInputs = 197120,
	ImGuiWindowFlags_ChildWindow = 16777216,
	ImGuiWindowFlags_Tooltip = 33554432,
	ImGuiWindowFlags_Popup = 67108864,
	ImGuiWindowFlags_Modal = 134217728,
	ImGuiWindowFlags_ChildMenu = 268435456
}

enum ImGuiChildFlags_: uint32
{
	ImGuiChildFlags_None = 0,
	ImGuiChildFlags_Borders = 1,
	ImGuiChildFlags_AlwaysUseWindowPadding = 2,
	ImGuiChildFlags_ResizeX = 4,
	ImGuiChildFlags_ResizeY = 8,
	ImGuiChildFlags_AutoResizeX = 16,
	ImGuiChildFlags_AutoResizeY = 32,
	ImGuiChildFlags_AlwaysAutoResize = 64,
	ImGuiChildFlags_FrameStyle = 128,
	ImGuiChildFlags_NavFlattened = 256
}

enum ImGuiItemFlags_: uint32
{
	ImGuiItemFlags_None = 0,
	ImGuiItemFlags_NoTabStop = 1,
	ImGuiItemFlags_NoNav = 2,
	ImGuiItemFlags_NoNavDefaultFocus = 4,
	ImGuiItemFlags_ButtonRepeat = 8,
	ImGuiItemFlags_AutoClosePopups = 16,
	ImGuiItemFlags_AllowDuplicateId = 32
}

enum ImGuiInputTextFlags_: uint32
{
	ImGuiInputTextFlags_None = 0,
	ImGuiInputTextFlags_CharsDecimal = 1,
	ImGuiInputTextFlags_CharsHexadecimal = 2,
	ImGuiInputTextFlags_CharsScientific = 4,
	ImGuiInputTextFlags_CharsUppercase = 8,
	ImGuiInputTextFlags_CharsNoBlank = 16,
	ImGuiInputTextFlags_AllowTabInput = 32,
	ImGuiInputTextFlags_EnterReturnsTrue = 64,
	ImGuiInputTextFlags_EscapeClearsAll = 128,
	ImGuiInputTextFlags_CtrlEnterForNewLine = 256,
	ImGuiInputTextFlags_ReadOnly = 512,
	ImGuiInputTextFlags_Password = 1024,
	ImGuiInputTextFlags_AlwaysOverwrite = 2048,
	ImGuiInputTextFlags_AutoSelectAll = 4096,
	ImGuiInputTextFlags_ParseEmptyRefVal = 8192,
	ImGuiInputTextFlags_DisplayEmptyRefVal = 16384,
	ImGuiInputTextFlags_NoHorizontalScroll = 32768,
	ImGuiInputTextFlags_NoUndoRedo = 65536,
	ImGuiInputTextFlags_ElideLeft = 131072,
	ImGuiInputTextFlags_CallbackCompletion = 262144,
	ImGuiInputTextFlags_CallbackHistory = 524288,
	ImGuiInputTextFlags_CallbackAlways = 1048576,
	ImGuiInputTextFlags_CallbackCharFilter = 2097152,
	ImGuiInputTextFlags_CallbackResize = 4194304,
	ImGuiInputTextFlags_CallbackEdit = 8388608,
	ImGuiInputTextFlags_WordWrap = 16777216
}

enum ImGuiTreeNodeFlags_: uint32
{
	ImGuiTreeNodeFlags_None = 0,
	ImGuiTreeNodeFlags_Selected = 1,
	ImGuiTreeNodeFlags_Framed = 2,
	ImGuiTreeNodeFlags_AllowOverlap = 4,
	ImGuiTreeNodeFlags_NoTreePushOnOpen = 8,
	ImGuiTreeNodeFlags_NoAutoOpenOnLog = 16,
	ImGuiTreeNodeFlags_DefaultOpen = 32,
	ImGuiTreeNodeFlags_OpenOnDoubleClick = 64,
	ImGuiTreeNodeFlags_OpenOnArrow = 128,
	ImGuiTreeNodeFlags_Leaf = 256,
	ImGuiTreeNodeFlags_Bullet = 512,
	ImGuiTreeNodeFlags_FramePadding = 1024,
	ImGuiTreeNodeFlags_SpanAvailWidth = 2048,
	ImGuiTreeNodeFlags_SpanFullWidth = 4096,
	ImGuiTreeNodeFlags_SpanLabelWidth = 8192,
	ImGuiTreeNodeFlags_SpanAllColumns = 16384,
	ImGuiTreeNodeFlags_LabelSpanAllColumns = 32768,
	ImGuiTreeNodeFlags_NavLeftJumpsToParent = 131072,
	ImGuiTreeNodeFlags_CollapsingHeader = 26,
	ImGuiTreeNodeFlags_DrawLinesNone = 262144,
	ImGuiTreeNodeFlags_DrawLinesFull = 524288,
	ImGuiTreeNodeFlags_DrawLinesToNodes = 1048576,
	ImGuiTreeNodeFlags_NavLeftJumpsBackHere = 131072,
	ImGuiTreeNodeFlags_SpanTextWidth = 8192
}

enum ImGuiPopupFlags_: uint32
{
	ImGuiPopupFlags_None = 0,
	ImGuiPopupFlags_MouseButtonLeft = 0,
	ImGuiPopupFlags_MouseButtonRight = 1,
	ImGuiPopupFlags_MouseButtonMiddle = 2,
	ImGuiPopupFlags_MouseButtonMask_ = 31,
	ImGuiPopupFlags_MouseButtonDefault_ = 1,
	ImGuiPopupFlags_NoReopen = 32,
	ImGuiPopupFlags_NoOpenOverExistingPopup = 128,
	ImGuiPopupFlags_NoOpenOverItems = 256,
	ImGuiPopupFlags_AnyPopupId = 1024,
	ImGuiPopupFlags_AnyPopupLevel = 2048,
	ImGuiPopupFlags_AnyPopup = 3072
}

enum ImGuiSelectableFlags_: uint32
{
	ImGuiSelectableFlags_None = 0,
	ImGuiSelectableFlags_NoAutoClosePopups = 1,
	ImGuiSelectableFlags_SpanAllColumns = 2,
	ImGuiSelectableFlags_AllowDoubleClick = 4,
	ImGuiSelectableFlags_Disabled = 8,
	ImGuiSelectableFlags_AllowOverlap = 16,
	ImGuiSelectableFlags_Highlight = 32,
	ImGuiSelectableFlags_SelectOnNav = 64,
	ImGuiSelectableFlags_DontClosePopups = 1
}

enum ImGuiComboFlags_: uint32
{
	ImGuiComboFlags_None = 0,
	ImGuiComboFlags_PopupAlignLeft = 1,
	ImGuiComboFlags_HeightSmall = 2,
	ImGuiComboFlags_HeightRegular = 4,
	ImGuiComboFlags_HeightLarge = 8,
	ImGuiComboFlags_HeightLargest = 16,
	ImGuiComboFlags_NoArrowButton = 32,
	ImGuiComboFlags_NoPreview = 64,
	ImGuiComboFlags_WidthFitPreview = 128,
	ImGuiComboFlags_HeightMask_ = 30
}

enum ImGuiTabBarFlags_: uint32
{
	ImGuiTabBarFlags_None = 0,
	ImGuiTabBarFlags_Reorderable = 1,
	ImGuiTabBarFlags_AutoSelectNewTabs = 2,
	ImGuiTabBarFlags_TabListPopupButton = 4,
	ImGuiTabBarFlags_NoCloseWithMiddleMouseButton = 8,
	ImGuiTabBarFlags_NoTabListScrollingButtons = 16,
	ImGuiTabBarFlags_NoTooltip = 32,
	ImGuiTabBarFlags_DrawSelectedOverline = 64,
	ImGuiTabBarFlags_FittingPolicyMixed = 128,
	ImGuiTabBarFlags_FittingPolicyShrink = 256,
	ImGuiTabBarFlags_FittingPolicyScroll = 512,
	ImGuiTabBarFlags_FittingPolicyMask_ = 896,
	ImGuiTabBarFlags_FittingPolicyDefault_ = 128,
	ImGuiTabBarFlags_FittingPolicyResizeDown = 256
}

enum ImGuiTabItemFlags_: uint32
{
	ImGuiTabItemFlags_None = 0,
	ImGuiTabItemFlags_UnsavedDocument = 1,
	ImGuiTabItemFlags_SetSelected = 2,
	ImGuiTabItemFlags_NoCloseWithMiddleMouseButton = 4,
	ImGuiTabItemFlags_NoPushId = 8,
	ImGuiTabItemFlags_NoTooltip = 16,
	ImGuiTabItemFlags_NoReorder = 32,
	ImGuiTabItemFlags_Leading = 64,
	ImGuiTabItemFlags_Trailing = 128,
	ImGuiTabItemFlags_NoAssumedClosure = 256
}

enum ImGuiFocusedFlags_: uint32
{
	ImGuiFocusedFlags_None = 0,
	ImGuiFocusedFlags_ChildWindows = 1,
	ImGuiFocusedFlags_RootWindow = 2,
	ImGuiFocusedFlags_AnyWindow = 4,
	ImGuiFocusedFlags_NoPopupHierarchy = 8,
	ImGuiFocusedFlags_RootAndChildWindows = 3
}

enum ImGuiHoveredFlags_: uint32
{
	ImGuiHoveredFlags_None = 0,
	ImGuiHoveredFlags_ChildWindows = 1,
	ImGuiHoveredFlags_RootWindow = 2,
	ImGuiHoveredFlags_AnyWindow = 4,
	ImGuiHoveredFlags_NoPopupHierarchy = 8,
	ImGuiHoveredFlags_AllowWhenBlockedByPopup = 32,
	ImGuiHoveredFlags_AllowWhenBlockedByActiveItem = 128,
	ImGuiHoveredFlags_AllowWhenOverlappedByItem = 256,
	ImGuiHoveredFlags_AllowWhenOverlappedByWindow = 512,
	ImGuiHoveredFlags_AllowWhenDisabled = 1024,
	ImGuiHoveredFlags_NoNavOverride = 2048,
	ImGuiHoveredFlags_AllowWhenOverlapped = 768,
	ImGuiHoveredFlags_RectOnly = 928,
	ImGuiHoveredFlags_RootAndChildWindows = 3,
	ImGuiHoveredFlags_ForTooltip = 4096,
	ImGuiHoveredFlags_Stationary = 8192,
	ImGuiHoveredFlags_DelayNone = 16384,
	ImGuiHoveredFlags_DelayShort = 32768,
	ImGuiHoveredFlags_DelayNormal = 65536,
	ImGuiHoveredFlags_NoSharedDelay = 131072
}

enum ImGuiDragDropFlags_: uint32
{
	ImGuiDragDropFlags_None = 0,
	ImGuiDragDropFlags_SourceNoPreviewTooltip = 1,
	ImGuiDragDropFlags_SourceNoDisableHover = 2,
	ImGuiDragDropFlags_SourceNoHoldToOpenOthers = 4,
	ImGuiDragDropFlags_SourceAllowNullID = 8,
	ImGuiDragDropFlags_SourceExtern = 16,
	ImGuiDragDropFlags_PayloadAutoExpire = 32,
	ImGuiDragDropFlags_PayloadNoCrossContext = 64,
	ImGuiDragDropFlags_PayloadNoCrossProcess = 128,
	ImGuiDragDropFlags_AcceptBeforeDelivery = 1024,
	ImGuiDragDropFlags_AcceptNoDrawDefaultRect = 2048,
	ImGuiDragDropFlags_AcceptNoPreviewTooltip = 4096,
	ImGuiDragDropFlags_AcceptDrawAsHovered = 8192,
	ImGuiDragDropFlags_AcceptPeekOnly = 3072,
	ImGuiDragDropFlags_SourceAutoExpirePayload = 32
}

enum ImGuiDataType_: uint32
{
	ImGuiDataType_S8 = 0,
	ImGuiDataType_U8 = 1,
	ImGuiDataType_S16 = 2,
	ImGuiDataType_U16 = 3,
	ImGuiDataType_S32 = 4,
	ImGuiDataType_U32 = 5,
	ImGuiDataType_S64 = 6,
	ImGuiDataType_U64 = 7,
	ImGuiDataType_Float = 8,
	ImGuiDataType_Double = 9,
	ImGuiDataType_Bool = 10,
	ImGuiDataType_String = 11,
	ImGuiDataType_COUNT = 12
}

enum ImGuiDir_: uint32
{
	ImGuiDir_None = 4294967295,
	ImGuiDir_Left = 0,
	ImGuiDir_Right = 1,
	ImGuiDir_Up = 2,
	ImGuiDir_Down = 3,
	ImGuiDir_COUNT = 4
}

enum ImGuiSortDirection_: uint32
{
	ImGuiSortDirection_None = 0,
	ImGuiSortDirection_Ascending = 1,
	ImGuiSortDirection_Descending = 2
}

enum ImGuiKey_: uint32
{
	ImGuiKey_None = 0,
	ImGuiKey_NamedKey_BEGIN = 512,
	ImGuiKey_Tab = 512,
	ImGuiKey_LeftArrow = 513,
	ImGuiKey_RightArrow = 514,
	ImGuiKey_UpArrow = 515,
	ImGuiKey_DownArrow = 516,
	ImGuiKey_PageUp = 517,
	ImGuiKey_PageDown = 518,
	ImGuiKey_Home = 519,
	ImGuiKey_End = 520,
	ImGuiKey_Insert = 521,
	ImGuiKey_Delete = 522,
	ImGuiKey_Backspace = 523,
	ImGuiKey_Space = 524,
	ImGuiKey_Enter = 525,
	ImGuiKey_Escape = 526,
	ImGuiKey_LeftCtrl = 527,
	ImGuiKey_LeftShift = 528,
	ImGuiKey_LeftAlt = 529,
	ImGuiKey_LeftSuper = 530,
	ImGuiKey_RightCtrl = 531,
	ImGuiKey_RightShift = 532,
	ImGuiKey_RightAlt = 533,
	ImGuiKey_RightSuper = 534,
	ImGuiKey_Menu = 535,
	ImGuiKey_0 = 536,
	ImGuiKey_1 = 537,
	ImGuiKey_2 = 538,
	ImGuiKey_3 = 539,
	ImGuiKey_4 = 540,
	ImGuiKey_5 = 541,
	ImGuiKey_6 = 542,
	ImGuiKey_7 = 543,
	ImGuiKey_8 = 544,
	ImGuiKey_9 = 545,
	ImGuiKey_A = 546,
	ImGuiKey_B = 547,
	ImGuiKey_C = 548,
	ImGuiKey_D = 549,
	ImGuiKey_E = 550,
	ImGuiKey_F = 551,
	ImGuiKey_G = 552,
	ImGuiKey_H = 553,
	ImGuiKey_I = 554,
	ImGuiKey_J = 555,
	ImGuiKey_K = 556,
	ImGuiKey_L = 557,
	ImGuiKey_M = 558,
	ImGuiKey_N = 559,
	ImGuiKey_O = 560,
	ImGuiKey_P = 561,
	ImGuiKey_Q = 562,
	ImGuiKey_R = 563,
	ImGuiKey_S = 564,
	ImGuiKey_T = 565,
	ImGuiKey_U = 566,
	ImGuiKey_V = 567,
	ImGuiKey_W = 568,
	ImGuiKey_X = 569,
	ImGuiKey_Y = 570,
	ImGuiKey_Z = 571,
	ImGuiKey_F1 = 572,
	ImGuiKey_F2 = 573,
	ImGuiKey_F3 = 574,
	ImGuiKey_F4 = 575,
	ImGuiKey_F5 = 576,
	ImGuiKey_F6 = 577,
	ImGuiKey_F7 = 578,
	ImGuiKey_F8 = 579,
	ImGuiKey_F9 = 580,
	ImGuiKey_F10 = 581,
	ImGuiKey_F11 = 582,
	ImGuiKey_F12 = 583,
	ImGuiKey_F13 = 584,
	ImGuiKey_F14 = 585,
	ImGuiKey_F15 = 586,
	ImGuiKey_F16 = 587,
	ImGuiKey_F17 = 588,
	ImGuiKey_F18 = 589,
	ImGuiKey_F19 = 590,
	ImGuiKey_F20 = 591,
	ImGuiKey_F21 = 592,
	ImGuiKey_F22 = 593,
	ImGuiKey_F23 = 594,
	ImGuiKey_F24 = 595,
	ImGuiKey_Apostrophe = 596,
	ImGuiKey_Comma = 597,
	ImGuiKey_Minus = 598,
	ImGuiKey_Period = 599,
	ImGuiKey_Slash = 600,
	ImGuiKey_Semicolon = 601,
	ImGuiKey_Equal = 602,
	ImGuiKey_LeftBracket = 603,
	ImGuiKey_Backslash = 604,
	ImGuiKey_RightBracket = 605,
	ImGuiKey_GraveAccent = 606,
	ImGuiKey_CapsLock = 607,
	ImGuiKey_ScrollLock = 608,
	ImGuiKey_NumLock = 609,
	ImGuiKey_PrintScreen = 610,
	ImGuiKey_Pause = 611,
	ImGuiKey_Keypad0 = 612,
	ImGuiKey_Keypad1 = 613,
	ImGuiKey_Keypad2 = 614,
	ImGuiKey_Keypad3 = 615,
	ImGuiKey_Keypad4 = 616,
	ImGuiKey_Keypad5 = 617,
	ImGuiKey_Keypad6 = 618,
	ImGuiKey_Keypad7 = 619,
	ImGuiKey_Keypad8 = 620,
	ImGuiKey_Keypad9 = 621,
	ImGuiKey_KeypadDecimal = 622,
	ImGuiKey_KeypadDivide = 623,
	ImGuiKey_KeypadMultiply = 624,
	ImGuiKey_KeypadSubtract = 625,
	ImGuiKey_KeypadAdd = 626,
	ImGuiKey_KeypadEnter = 627,
	ImGuiKey_KeypadEqual = 628,
	ImGuiKey_AppBack = 629,
	ImGuiKey_AppForward = 630,
	ImGuiKey_Oem102 = 631,
	ImGuiKey_GamepadStart = 632,
	ImGuiKey_GamepadBack = 633,
	ImGuiKey_GamepadFaceLeft = 634,
	ImGuiKey_GamepadFaceRight = 635,
	ImGuiKey_GamepadFaceUp = 636,
	ImGuiKey_GamepadFaceDown = 637,
	ImGuiKey_GamepadDpadLeft = 638,
	ImGuiKey_GamepadDpadRight = 639,
	ImGuiKey_GamepadDpadUp = 640,
	ImGuiKey_GamepadDpadDown = 641,
	ImGuiKey_GamepadL1 = 642,
	ImGuiKey_GamepadR1 = 643,
	ImGuiKey_GamepadL2 = 644,
	ImGuiKey_GamepadR2 = 645,
	ImGuiKey_GamepadL3 = 646,
	ImGuiKey_GamepadR3 = 647,
	ImGuiKey_GamepadLStickLeft = 648,
	ImGuiKey_GamepadLStickRight = 649,
	ImGuiKey_GamepadLStickUp = 650,
	ImGuiKey_GamepadLStickDown = 651,
	ImGuiKey_GamepadRStickLeft = 652,
	ImGuiKey_GamepadRStickRight = 653,
	ImGuiKey_GamepadRStickUp = 654,
	ImGuiKey_GamepadRStickDown = 655,
	ImGuiKey_MouseLeft = 656,
	ImGuiKey_MouseRight = 657,
	ImGuiKey_MouseMiddle = 658,
	ImGuiKey_MouseX1 = 659,
	ImGuiKey_MouseX2 = 660,
	ImGuiKey_MouseWheelX = 661,
	ImGuiKey_MouseWheelY = 662,
	ImGuiKey_ReservedForModCtrl = 663,
	ImGuiKey_ReservedForModShift = 664,
	ImGuiKey_ReservedForModAlt = 665,
	ImGuiKey_ReservedForModSuper = 666,
	ImGuiKey_NamedKey_END = 667,
	ImGuiKey_NamedKey_COUNT = 155,
	ImGuiMod_None = 0,
	ImGuiMod_Ctrl = 4096,
	ImGuiMod_Shift = 8192,
	ImGuiMod_Alt = 16384,
	ImGuiMod_Super = 32768,
	ImGuiMod_Mask_ = 61440,
	ImGuiKey_COUNT = 667,
	ImGuiMod_Shortcut = 4096
}

enum ImGuiInputFlags_: uint32
{
	ImGuiInputFlags_None = 0,
	ImGuiInputFlags_Repeat = 1,
	ImGuiInputFlags_RouteActive = 1024,
	ImGuiInputFlags_RouteFocused = 2048,
	ImGuiInputFlags_RouteGlobal = 4096,
	ImGuiInputFlags_RouteAlways = 8192,
	ImGuiInputFlags_RouteOverFocused = 16384,
	ImGuiInputFlags_RouteOverActive = 32768,
	ImGuiInputFlags_RouteUnlessBgFocused = 65536,
	ImGuiInputFlags_RouteFromRootWindow = 131072,
	ImGuiInputFlags_Tooltip = 262144
}

enum ImGuiConfigFlags_: uint32
{
	ImGuiConfigFlags_None = 0,
	ImGuiConfigFlags_NavEnableKeyboard = 1,
	ImGuiConfigFlags_NavEnableGamepad = 2,
	ImGuiConfigFlags_NoMouse = 16,
	ImGuiConfigFlags_NoMouseCursorChange = 32,
	ImGuiConfigFlags_NoKeyboard = 64,
	ImGuiConfigFlags_IsSRGB = 1048576,
	ImGuiConfigFlags_IsTouchScreen = 2097152,
	ImGuiConfigFlags_NavEnableSetMousePos = 4,
	ImGuiConfigFlags_NavNoCaptureKeyboard = 8
}

enum ImGuiBackendFlags_: uint32
{
	ImGuiBackendFlags_None = 0,
	ImGuiBackendFlags_HasGamepad = 1,
	ImGuiBackendFlags_HasMouseCursors = 2,
	ImGuiBackendFlags_HasSetMousePos = 4,
	ImGuiBackendFlags_RendererHasVtxOffset = 8,
	ImGuiBackendFlags_RendererHasTextures = 16
}

enum ImGuiCol_: uint32
{
	ImGuiCol_Text = 0,
	ImGuiCol_TextDisabled = 1,
	ImGuiCol_WindowBg = 2,
	ImGuiCol_ChildBg = 3,
	ImGuiCol_PopupBg = 4,
	ImGuiCol_Border = 5,
	ImGuiCol_BorderShadow = 6,
	ImGuiCol_FrameBg = 7,
	ImGuiCol_FrameBgHovered = 8,
	ImGuiCol_FrameBgActive = 9,
	ImGuiCol_TitleBg = 10,
	ImGuiCol_TitleBgActive = 11,
	ImGuiCol_TitleBgCollapsed = 12,
	ImGuiCol_MenuBarBg = 13,
	ImGuiCol_ScrollbarBg = 14,
	ImGuiCol_ScrollbarGrab = 15,
	ImGuiCol_ScrollbarGrabHovered = 16,
	ImGuiCol_ScrollbarGrabActive = 17,
	ImGuiCol_CheckMark = 18,
	ImGuiCol_SliderGrab = 19,
	ImGuiCol_SliderGrabActive = 20,
	ImGuiCol_Button = 21,
	ImGuiCol_ButtonHovered = 22,
	ImGuiCol_ButtonActive = 23,
	ImGuiCol_Header = 24,
	ImGuiCol_HeaderHovered = 25,
	ImGuiCol_HeaderActive = 26,
	ImGuiCol_Separator = 27,
	ImGuiCol_SeparatorHovered = 28,
	ImGuiCol_SeparatorActive = 29,
	ImGuiCol_ResizeGrip = 30,
	ImGuiCol_ResizeGripHovered = 31,
	ImGuiCol_ResizeGripActive = 32,
	ImGuiCol_InputTextCursor = 33,
	ImGuiCol_TabHovered = 34,
	ImGuiCol_Tab = 35,
	ImGuiCol_TabSelected = 36,
	ImGuiCol_TabSelectedOverline = 37,
	ImGuiCol_TabDimmed = 38,
	ImGuiCol_TabDimmedSelected = 39,
	ImGuiCol_TabDimmedSelectedOverline = 40,
	ImGuiCol_PlotLines = 41,
	ImGuiCol_PlotLinesHovered = 42,
	ImGuiCol_PlotHistogram = 43,
	ImGuiCol_PlotHistogramHovered = 44,
	ImGuiCol_TableHeaderBg = 45,
	ImGuiCol_TableBorderStrong = 46,
	ImGuiCol_TableBorderLight = 47,
	ImGuiCol_TableRowBg = 48,
	ImGuiCol_TableRowBgAlt = 49,
	ImGuiCol_TextLink = 50,
	ImGuiCol_TextSelectedBg = 51,
	ImGuiCol_TreeLines = 52,
	ImGuiCol_DragDropTarget = 53,
	ImGuiCol_DragDropTargetBg = 54,
	ImGuiCol_UnsavedMarker = 55,
	ImGuiCol_NavCursor = 56,
	ImGuiCol_NavWindowingHighlight = 57,
	ImGuiCol_NavWindowingDimBg = 58,
	ImGuiCol_ModalWindowDimBg = 59,
	ImGuiCol_COUNT = 60,
	ImGuiCol_TabActive = 36,
	ImGuiCol_TabUnfocused = 38,
	ImGuiCol_TabUnfocusedActive = 39,
	ImGuiCol_NavHighlight = 56
}

enum ImGuiStyleVar_: uint32
{
	ImGuiStyleVar_Alpha = 0,
	ImGuiStyleVar_DisabledAlpha = 1,
	ImGuiStyleVar_WindowPadding = 2,
	ImGuiStyleVar_WindowRounding = 3,
	ImGuiStyleVar_WindowBorderSize = 4,
	ImGuiStyleVar_WindowMinSize = 5,
	ImGuiStyleVar_WindowTitleAlign = 6,
	ImGuiStyleVar_ChildRounding = 7,
	ImGuiStyleVar_ChildBorderSize = 8,
	ImGuiStyleVar_PopupRounding = 9,
	ImGuiStyleVar_PopupBorderSize = 10,
	ImGuiStyleVar_FramePadding = 11,
	ImGuiStyleVar_FrameRounding = 12,
	ImGuiStyleVar_FrameBorderSize = 13,
	ImGuiStyleVar_ItemSpacing = 14,
	ImGuiStyleVar_ItemInnerSpacing = 15,
	ImGuiStyleVar_IndentSpacing = 16,
	ImGuiStyleVar_CellPadding = 17,
	ImGuiStyleVar_ScrollbarSize = 18,
	ImGuiStyleVar_ScrollbarRounding = 19,
	ImGuiStyleVar_ScrollbarPadding = 20,
	ImGuiStyleVar_GrabMinSize = 21,
	ImGuiStyleVar_GrabRounding = 22,
	ImGuiStyleVar_ImageBorderSize = 23,
	ImGuiStyleVar_TabRounding = 24,
	ImGuiStyleVar_TabBorderSize = 25,
	ImGuiStyleVar_TabMinWidthBase = 26,
	ImGuiStyleVar_TabMinWidthShrink = 27,
	ImGuiStyleVar_TabBarBorderSize = 28,
	ImGuiStyleVar_TabBarOverlineSize = 29,
	ImGuiStyleVar_TableAngledHeadersAngle = 30,
	ImGuiStyleVar_TableAngledHeadersTextAlign = 31,
	ImGuiStyleVar_TreeLinesSize = 32,
	ImGuiStyleVar_TreeLinesRounding = 33,
	ImGuiStyleVar_ButtonTextAlign = 34,
	ImGuiStyleVar_SelectableTextAlign = 35,
	ImGuiStyleVar_SeparatorTextBorderSize = 36,
	ImGuiStyleVar_SeparatorTextAlign = 37,
	ImGuiStyleVar_SeparatorTextPadding = 38,
	ImGuiStyleVar_COUNT = 39
}

enum ImGuiButtonFlags_: uint32
{
	ImGuiButtonFlags_None = 0,
	ImGuiButtonFlags_MouseButtonLeft = 1,
	ImGuiButtonFlags_MouseButtonRight = 2,
	ImGuiButtonFlags_MouseButtonMiddle = 4,
	ImGuiButtonFlags_MouseButtonMask_ = 7,
	ImGuiButtonFlags_EnableNav = 8
}

enum ImGuiColorEditFlags_: uint32
{
	ImGuiColorEditFlags_None = 0,
	ImGuiColorEditFlags_NoAlpha = 2,
	ImGuiColorEditFlags_NoPicker = 4,
	ImGuiColorEditFlags_NoOptions = 8,
	ImGuiColorEditFlags_NoSmallPreview = 16,
	ImGuiColorEditFlags_NoInputs = 32,
	ImGuiColorEditFlags_NoTooltip = 64,
	ImGuiColorEditFlags_NoLabel = 128,
	ImGuiColorEditFlags_NoSidePreview = 256,
	ImGuiColorEditFlags_NoDragDrop = 512,
	ImGuiColorEditFlags_NoBorder = 1024,
	ImGuiColorEditFlags_AlphaOpaque = 2048,
	ImGuiColorEditFlags_AlphaNoBg = 4096,
	ImGuiColorEditFlags_AlphaPreviewHalf = 8192,
	ImGuiColorEditFlags_AlphaBar = 65536,
	ImGuiColorEditFlags_HDR = 524288,
	ImGuiColorEditFlags_DisplayRGB = 1048576,
	ImGuiColorEditFlags_DisplayHSV = 2097152,
	ImGuiColorEditFlags_DisplayHex = 4194304,
	ImGuiColorEditFlags_Uint8 = 8388608,
	ImGuiColorEditFlags_Float = 16777216,
	ImGuiColorEditFlags_PickerHueBar = 33554432,
	ImGuiColorEditFlags_PickerHueWheel = 67108864,
	ImGuiColorEditFlags_InputRGB = 134217728,
	ImGuiColorEditFlags_InputHSV = 268435456,
	ImGuiColorEditFlags_DefaultOptions_ = 177209344,
	ImGuiColorEditFlags_AlphaMask_ = 14338,
	ImGuiColorEditFlags_DisplayMask_ = 7340032,
	ImGuiColorEditFlags_DataTypeMask_ = 25165824,
	ImGuiColorEditFlags_PickerMask_ = 100663296,
	ImGuiColorEditFlags_InputMask_ = 402653184,
	ImGuiColorEditFlags_AlphaPreview = 0
}

enum ImGuiSliderFlags_: uint32
{
	ImGuiSliderFlags_None = 0,
	ImGuiSliderFlags_Logarithmic = 32,
	ImGuiSliderFlags_NoRoundToFormat = 64,
	ImGuiSliderFlags_NoInput = 128,
	ImGuiSliderFlags_WrapAround = 256,
	ImGuiSliderFlags_ClampOnInput = 512,
	ImGuiSliderFlags_ClampZeroRange = 1024,
	ImGuiSliderFlags_NoSpeedTweaks = 2048,
	ImGuiSliderFlags_AlwaysClamp = 1536,
	ImGuiSliderFlags_InvalidMask_ = 1879048207
}

enum ImGuiMouseButton_: uint32
{
	ImGuiMouseButton_Left = 0,
	ImGuiMouseButton_Right = 1,
	ImGuiMouseButton_Middle = 2,
	ImGuiMouseButton_COUNT = 5
}

enum ImGuiMouseCursor_: uint32
{
	ImGuiMouseCursor_None = 4294967295,
	ImGuiMouseCursor_Arrow = 0,
	ImGuiMouseCursor_TextInput = 1,
	ImGuiMouseCursor_ResizeAll = 2,
	ImGuiMouseCursor_ResizeNS = 3,
	ImGuiMouseCursor_ResizeEW = 4,
	ImGuiMouseCursor_ResizeNESW = 5,
	ImGuiMouseCursor_ResizeNWSE = 6,
	ImGuiMouseCursor_Hand = 7,
	ImGuiMouseCursor_Wait = 8,
	ImGuiMouseCursor_Progress = 9,
	ImGuiMouseCursor_NotAllowed = 10,
	ImGuiMouseCursor_COUNT = 11
}

enum ImGuiMouseSource_: uint32
{
	ImGuiMouseSource_Mouse = 0,
	ImGuiMouseSource_TouchScreen = 1,
	ImGuiMouseSource_Pen = 2,
	ImGuiMouseSource_COUNT = 3
}

enum ImGuiCond_: uint32
{
	ImGuiCond_None = 0,
	ImGuiCond_Always = 1,
	ImGuiCond_Once = 2,
	ImGuiCond_FirstUseEver = 4,
	ImGuiCond_Appearing = 8
}

enum ImGuiTableFlags_: uint32
{
	ImGuiTableFlags_None = 0,
	ImGuiTableFlags_Resizable = 1,
	ImGuiTableFlags_Reorderable = 2,
	ImGuiTableFlags_Hideable = 4,
	ImGuiTableFlags_Sortable = 8,
	ImGuiTableFlags_NoSavedSettings = 16,
	ImGuiTableFlags_ContextMenuInBody = 32,
	ImGuiTableFlags_RowBg = 64,
	ImGuiTableFlags_BordersInnerH = 128,
	ImGuiTableFlags_BordersOuterH = 256,
	ImGuiTableFlags_BordersInnerV = 512,
	ImGuiTableFlags_BordersOuterV = 1024,
	ImGuiTableFlags_BordersH = 384,
	ImGuiTableFlags_BordersV = 1536,
	ImGuiTableFlags_BordersInner = 640,
	ImGuiTableFlags_BordersOuter = 1280,
	ImGuiTableFlags_Borders = 1920,
	ImGuiTableFlags_NoBordersInBody = 2048,
	ImGuiTableFlags_NoBordersInBodyUntilResize = 4096,
	ImGuiTableFlags_SizingFixedFit = 8192,
	ImGuiTableFlags_SizingFixedSame = 16384,
	ImGuiTableFlags_SizingStretchProp = 24576,
	ImGuiTableFlags_SizingStretchSame = 32768,
	ImGuiTableFlags_NoHostExtendX = 65536,
	ImGuiTableFlags_NoHostExtendY = 131072,
	ImGuiTableFlags_NoKeepColumnsVisible = 262144,
	ImGuiTableFlags_PreciseWidths = 524288,
	ImGuiTableFlags_NoClip = 1048576,
	ImGuiTableFlags_PadOuterX = 2097152,
	ImGuiTableFlags_NoPadOuterX = 4194304,
	ImGuiTableFlags_NoPadInnerX = 8388608,
	ImGuiTableFlags_ScrollX = 16777216,
	ImGuiTableFlags_ScrollY = 33554432,
	ImGuiTableFlags_SortMulti = 67108864,
	ImGuiTableFlags_SortTristate = 134217728,
	ImGuiTableFlags_HighlightHoveredColumn = 268435456,
	ImGuiTableFlags_SizingMask_ = 57344
}

enum ImGuiTableColumnFlags_: uint32
{
	ImGuiTableColumnFlags_None = 0,
	ImGuiTableColumnFlags_Disabled = 1,
	ImGuiTableColumnFlags_DefaultHide = 2,
	ImGuiTableColumnFlags_DefaultSort = 4,
	ImGuiTableColumnFlags_WidthStretch = 8,
	ImGuiTableColumnFlags_WidthFixed = 16,
	ImGuiTableColumnFlags_NoResize = 32,
	ImGuiTableColumnFlags_NoReorder = 64,
	ImGuiTableColumnFlags_NoHide = 128,
	ImGuiTableColumnFlags_NoClip = 256,
	ImGuiTableColumnFlags_NoSort = 512,
	ImGuiTableColumnFlags_NoSortAscending = 1024,
	ImGuiTableColumnFlags_NoSortDescending = 2048,
	ImGuiTableColumnFlags_NoHeaderLabel = 4096,
	ImGuiTableColumnFlags_NoHeaderWidth = 8192,
	ImGuiTableColumnFlags_PreferSortAscending = 16384,
	ImGuiTableColumnFlags_PreferSortDescending = 32768,
	ImGuiTableColumnFlags_IndentEnable = 65536,
	ImGuiTableColumnFlags_IndentDisable = 131072,
	ImGuiTableColumnFlags_AngledHeader = 262144,
	ImGuiTableColumnFlags_IsEnabled = 16777216,
	ImGuiTableColumnFlags_IsVisible = 33554432,
	ImGuiTableColumnFlags_IsSorted = 67108864,
	ImGuiTableColumnFlags_IsHovered = 134217728,
	ImGuiTableColumnFlags_WidthMask_ = 24,
	ImGuiTableColumnFlags_IndentMask_ = 196608,
	ImGuiTableColumnFlags_StatusMask_ = 251658240,
	ImGuiTableColumnFlags_NoDirectResize_ = 1073741824
}

enum ImGuiTableRowFlags_: uint32
{
	ImGuiTableRowFlags_None = 0,
	ImGuiTableRowFlags_Headers = 1
}

enum ImGuiTableBgTarget_: uint32
{
	ImGuiTableBgTarget_None = 0,
	ImGuiTableBgTarget_RowBg0 = 1,
	ImGuiTableBgTarget_RowBg1 = 2,
	ImGuiTableBgTarget_CellBg = 3
}

enum ImGuiListClipperFlags_: uint32
{
	ImGuiListClipperFlags_None = 0,
	ImGuiListClipperFlags_NoSetTableRowCounters = 1
}

enum ImGuiMultiSelectFlags_: uint32
{
	ImGuiMultiSelectFlags_None = 0,
	ImGuiMultiSelectFlags_SingleSelect = 1,
	ImGuiMultiSelectFlags_NoSelectAll = 2,
	ImGuiMultiSelectFlags_NoRangeSelect = 4,
	ImGuiMultiSelectFlags_NoAutoSelect = 8,
	ImGuiMultiSelectFlags_NoAutoClear = 16,
	ImGuiMultiSelectFlags_NoAutoClearOnReselect = 32,
	ImGuiMultiSelectFlags_BoxSelect1d = 64,
	ImGuiMultiSelectFlags_BoxSelect2d = 128,
	ImGuiMultiSelectFlags_BoxSelectNoScroll = 256,
	ImGuiMultiSelectFlags_ClearOnEscape = 512,
	ImGuiMultiSelectFlags_ClearOnClickVoid = 1024,
	ImGuiMultiSelectFlags_ScopeWindow = 2048,
	ImGuiMultiSelectFlags_ScopeRect = 4096,
	ImGuiMultiSelectFlags_SelectOnClick = 8192,
	ImGuiMultiSelectFlags_SelectOnClickRelease = 16384,
	ImGuiMultiSelectFlags_NavWrapX = 65536,
	ImGuiMultiSelectFlags_NoSelectOnRightClick = 131072
}

enum ImGuiSelectionRequestType: uint32
{
	ImGuiSelectionRequestType_None = 0,
	ImGuiSelectionRequestType_SetAll = 1,
	ImGuiSelectionRequestType_SetRange = 2
}

enum ImDrawFlags_: uint32
{
	ImDrawFlags_None = 0,
	ImDrawFlags_Closed = 1,
	ImDrawFlags_RoundCornersTopLeft = 16,
	ImDrawFlags_RoundCornersTopRight = 32,
	ImDrawFlags_RoundCornersBottomLeft = 64,
	ImDrawFlags_RoundCornersBottomRight = 128,
	ImDrawFlags_RoundCornersNone = 256,
	ImDrawFlags_RoundCornersTop = 48,
	ImDrawFlags_RoundCornersBottom = 192,
	ImDrawFlags_RoundCornersLeft = 80,
	ImDrawFlags_RoundCornersRight = 160,
	ImDrawFlags_RoundCornersAll = 240,
	ImDrawFlags_RoundCornersDefault_ = 240,
	ImDrawFlags_RoundCornersMask_ = 496
}

enum ImDrawListFlags_: uint32
{
	ImDrawListFlags_None = 0,
	ImDrawListFlags_AntiAliasedLines = 1,
	ImDrawListFlags_AntiAliasedLinesUseTex = 2,
	ImDrawListFlags_AntiAliasedFill = 4,
	ImDrawListFlags_AllowVtxOffset = 8
}

enum ImTextureFormat: uint32
{
	ImTextureFormat_RGBA32 = 0,
	ImTextureFormat_Alpha8 = 1
}

enum ImTextureStatus: uint32
{
	ImTextureStatus_OK = 0,
	ImTextureStatus_Destroyed = 1,
	ImTextureStatus_WantCreate = 2,
	ImTextureStatus_WantUpdates = 3,
	ImTextureStatus_WantDestroy = 4
}

enum ImFontAtlasFlags_: uint32
{
	ImFontAtlasFlags_None = 0,
	ImFontAtlasFlags_NoPowerOfTwoHeight = 1,
	ImFontAtlasFlags_NoMouseCursors = 2,
	ImFontAtlasFlags_NoBakedLines = 4
}

enum ImFontFlags_: uint32
{
	ImFontFlags_None = 0,
	ImFontFlags_NoLoadError = 2,
	ImFontFlags_NoLoadGlyphs = 4,
	ImFontFlags_LockBakedSizes = 8
}

enum ImGuiViewportFlags_: uint32
{
	ImGuiViewportFlags_None = 0,
	ImGuiViewportFlags_IsPlatformWindow = 1,
	ImGuiViewportFlags_IsPlatformMonitor = 2,
	ImGuiViewportFlags_OwnedByApp = 4
}

state ImVec2_t
{
	x: float32,
	y: float32
}

state ImVec4_t
{
	x: float32,
	y: float32,
	z: float32,
	w: float32
}

state ImTextureRef_t
{
	_TexData: *ImTextureData_t,
	_TexID: uint64
}

state ImGuiTableSortSpecs_t
{
	Specs: *ImGuiTableColumnSortSpecs_t,
	SpecsCount: int32,
	SpecsDirty: bool
}

state ImGuiTableColumnSortSpecs_t
{
	ColumnUserID: uint32,
	ColumnIndex: int16,
	SortOrder: int16,
	SortDirection: ubyte
}

state ImVector_ImGuiTextRange_t
{
	Size: int32,
	Capacity: int32,
	Data: *ImGuiTextFilter_ImGuiTextRange_t
}

state ImVector_char_t
{
	Size: int32,
	Capacity: int32,
	Data: *byte
}

state ImVector_ImGuiStoragePair_t
{
	Size: int32,
	Capacity: int32,
	Data: *ImGuiStoragePair_t
}

state ImVector_ImGuiSelectionRequest_t
{
	Size: int32,
	Capacity: int32,
	Data: *ImGuiSelectionRequest_t
}

state ImVector_ImDrawChannel_t
{
	Size: int32,
	Capacity: int32,
	Data: *ImDrawChannel_t
}

state ImVector_ImDrawCmd_t
{
	Size: int32,
	Capacity: int32,
	Data: *ImDrawCmd_t
}

state ImVector_ImDrawIdx_t
{
	Size: int32,
	Capacity: int32,
	Data: *uint16
}

state ImVector_ImDrawVert_t
{
	Size: int32,
	Capacity: int32,
	Data: *ImDrawVert_t
}

state ImVector_ImVec2_t
{
	Size: int32,
	Capacity: int32,
	Data: *ImVec2_t
}

state ImVector_ImVec4_t
{
	Size: int32,
	Capacity: int32,
	Data: *ImVec4_t
}

state ImVector_ImTextureRef_t
{
	Size: int32,
	Capacity: int32,
	Data: *ImTextureRef_t
}

state ImVector_ImU8_t
{
	Size: int32,
	Capacity: int32,
	Data: *ubyte
}

state ImVector_ImDrawListPtr_t
{
	Size: int32,
	Capacity: int32,
	Data: **ImDrawList_t
}

state ImVector_ImTextureRect_t
{
	Size: int32,
	Capacity: int32,
	Data: *ImTextureRect_t
}

state ImVector_ImU32_t
{
	Size: int32,
	Capacity: int32,
	Data: *uint32
}

state ImVector_ImWchar_t
{
	Size: int32,
	Capacity: int32,
	Data: *uint16
}

state ImVector_ImFontPtr_t
{
	Size: int32,
	Capacity: int32,
	Data: **ImFont_t
}

state ImVector_ImFontConfig_t
{
	Size: int32,
	Capacity: int32,
	Data: *ImFontConfig_t
}

state ImVector_ImDrawListSharedDataPtr_t
{
	Size: int32,
	Capacity: int32,
	Data: **ImDrawListSharedData_t
}

state ImVector_float_t
{
	Size: int32,
	Capacity: int32,
	Data: *float32
}

state ImVector_ImU16_t
{
	Size: int32,
	Capacity: int32,
	Data: *uint16
}

state ImVector_ImFontGlyph_t
{
	Size: int32,
	Capacity: int32,
	Data: *ImFontGlyph_t
}

state ImVector_ImFontConfigPtr_t
{
	Size: int32,
	Capacity: int32,
	Data: **ImFontConfig_t
}

state ImVector_ImTextureDataPtr_t
{
	Size: int32,
	Capacity: int32,
	Data: **ImTextureData_t
}

state ImGuiStyle_t
{
	FontSizeBase: float32,
	FontScaleMain: float32,
	FontScaleDpi: float32,
	Alpha: float32,
	DisabledAlpha: float32,
	WindowPadding: ImVec2_t,
	WindowRounding: float32,
	WindowBorderSize: float32,
	WindowBorderHoverPadding: float32,
	WindowMinSize: ImVec2_t,
	WindowTitleAlign: ImVec2_t,
	WindowMenuButtonPosition: int32,
	ChildRounding: float32,
	ChildBorderSize: float32,
	PopupRounding: float32,
	PopupBorderSize: float32,
	FramePadding: ImVec2_t,
	FrameRounding: float32,
	FrameBorderSize: float32,
	ItemSpacing: ImVec2_t,
	ItemInnerSpacing: ImVec2_t,
	CellPadding: ImVec2_t,
	TouchExtraPadding: ImVec2_t,
	IndentSpacing: float32,
	ColumnsMinSpacing: float32,
	ScrollbarSize: float32,
	ScrollbarRounding: float32,
	ScrollbarPadding: float32,
	GrabMinSize: float32,
	GrabRounding: float32,
	LogSliderDeadzone: float32,
	ImageBorderSize: float32,
	TabRounding: float32,
	TabBorderSize: float32,
	TabMinWidthBase: float32,
	TabMinWidthShrink: float32,
	TabCloseButtonMinWidthSelected: float32,
	TabCloseButtonMinWidthUnselected: float32,
	TabBarBorderSize: float32,
	TabBarOverlineSize: float32,
	TableAngledHeadersAngle: float32,
	TableAngledHeadersTextAlign: ImVec2_t,
	TreeLinesFlags: int32,
	TreeLinesSize: float32,
	TreeLinesRounding: float32,
	DragDropTargetRounding: float32,
	DragDropTargetBorderSize: float32,
	DragDropTargetPadding: float32,
	ColorButtonPosition: int32,
	ButtonTextAlign: ImVec2_t,
	SelectableTextAlign: ImVec2_t,
	SeparatorTextBorderSize: float32,
	SeparatorTextAlign: ImVec2_t,
	SeparatorTextPadding: ImVec2_t,
	DisplayWindowPadding: ImVec2_t,
	DisplaySafeAreaPadding: ImVec2_t,
	MouseCursorScale: float32,
	AntiAliasedLines: bool,
	AntiAliasedLinesUseTex: bool,
	AntiAliasedFill: bool,
	CurveTessellationTol: float32,
	CircleTessellationMaxError: float32,
	Colors: [60]ImVec4_t,
	HoverStationaryDelay: float32,
	HoverDelayShort: float32,
	HoverDelayNormal: float32,
	HoverFlagsForTooltipMouse: int32,
	HoverFlagsForTooltipNav: int32,
	_MainScale: float32,
	_NextFrameFontSizeBase: float32
}

state ImGuiKeyData_t
{
	Down: bool,
	DownDuration: float32,
	DownDurationPrev: float32,
	AnalogValue: float32
}

state ImGuiIO_t
{
	ConfigFlags: int32,
	BackendFlags: int32,
	DisplaySize: ImVec2_t,
	DisplayFramebufferScale: ImVec2_t,
	DeltaTime: float32,
	IniSavingRate: float32,
	IniFilename: *byte,
	LogFilename: *byte,
	UserData: *void,
	Fonts: *ImFontAtlas_t,
	FontDefault: *ImFont_t,
	FontAllowUserScaling: bool,
	ConfigNavSwapGamepadButtons: bool,
	ConfigNavMoveSetMousePos: bool,
	ConfigNavCaptureKeyboard: bool,
	ConfigNavEscapeClearFocusItem: bool,
	ConfigNavEscapeClearFocusWindow: bool,
	ConfigNavCursorVisibleAuto: bool,
	ConfigNavCursorVisibleAlways: bool,
	MouseDrawCursor: bool,
	ConfigMacOSXBehaviors: bool,
	ConfigInputTrickleEventQueue: bool,
	ConfigInputTextCursorBlink: bool,
	ConfigInputTextEnterKeepActive: bool,
	ConfigDragClickToInputText: bool,
	ConfigWindowsResizeFromEdges: bool,
	ConfigWindowsMoveFromTitleBarOnly: bool,
	ConfigWindowsCopyContentsWithCtrlC: bool,
	ConfigScrollbarScrollByPage: bool,
	ConfigMemoryCompactTimer: float32,
	MouseDoubleClickTime: float32,
	MouseDoubleClickMaxDist: float32,
	MouseDragThreshold: float32,
	KeyRepeatDelay: float32,
	KeyRepeatRate: float32,
	ConfigErrorRecovery: bool,
	ConfigErrorRecoveryEnableAssert: bool,
	ConfigErrorRecoveryEnableDebugLog: bool,
	ConfigErrorRecoveryEnableTooltip: bool,
	ConfigDebugIsDebuggerPresent: bool,
	ConfigDebugHighlightIdConflicts: bool,
	ConfigDebugHighlightIdConflictsShowItemPicker: bool,
	ConfigDebugBeginReturnValueOnce: bool,
	ConfigDebugBeginReturnValueLoop: bool,
	ConfigDebugIgnoreFocusLoss: bool,
	ConfigDebugIniSettings: bool,
	BackendPlatformName: *byte,
	BackendRendererName: *byte,
	BackendPlatformUserData: *void,
	BackendRendererUserData: *void,
	BackendLanguageUserData: *void,
	WantCaptureMouse: bool,
	WantCaptureKeyboard: bool,
	WantTextInput: bool,
	WantSetMousePos: bool,
	WantSaveIniSettings: bool,
	NavActive: bool,
	NavVisible: bool,
	Framerate: float32,
	MetricsRenderVertices: int32,
	MetricsRenderIndices: int32,
	MetricsRenderWindows: int32,
	MetricsActiveWindows: int32,
	MouseDelta: ImVec2_t,
	Ctx: *ImGuiContext_t,
	MousePos: ImVec2_t,
	MouseDown: [5]bool,
	MouseWheel: float32,
	MouseWheelH: float32,
	MouseSource: int32,
	KeyCtrl: bool,
	KeyShift: bool,
	KeyAlt: bool,
	KeySuper: bool,
	KeyMods: int32,
	KeysData: [155]ImGuiKeyData_t,
	WantCaptureMouseUnlessPopupClose: bool,
	MousePosPrev: ImVec2_t,
	MouseClickedPos: [5]ImVec2_t,
	MouseClickedTime: [5]float64,
	MouseClicked: [5]bool,
	MouseDoubleClicked: [5]bool,
	MouseClickedCount: [5]uint16,
	MouseClickedLastCount: [5]uint16,
	MouseReleased: [5]bool,
	MouseReleasedTime: [5]float64,
	MouseDownOwned: [5]bool,
	MouseDownOwnedUnlessPopupClose: [5]bool,
	MouseWheelRequestAxisSwap: bool,
	MouseCtrlLeftAsRightClick: bool,
	MouseDownDuration: [5]float32,
	MouseDownDurationPrev: [5]float32,
	MouseDragMaxDistanceSqr: [5]float32,
	PenPressure: float32,
	AppFocusLost: bool,
	AppAcceptingEvents: bool,
	InputQueueSurrogate: uint16,
	InputQueueCharacters: ImVector_ImWchar_t,
	FontGlobalScale: float32,
	GetClipboardTextFn: ::(),
	SetClipboardTextFn: ::(),
	ClipboardUserData: *void
}

state ImGuiInputTextCallbackData_t
{
	Ctx: *ImGuiContext_t,
	EventFlag: int32,
	Flags: int32,
	UserData: *void,
	EventChar: uint16,
	EventKey: int32,
	Buf: *byte,
	BufTextLen: int32,
	BufSize: int32,
	BufDirty: bool,
	CursorPos: int32,
	SelectionStart: int32,
	SelectionEnd: int32
}

state ImGuiSizeCallbackData_t
{
	UserData: *void,
	Pos: ImVec2_t,
	CurrentSize: ImVec2_t,
	DesiredSize: ImVec2_t
}

state ImGuiPayload_t
{
	Data: *void,
	DataSize: int32,
	SourceId: uint32,
	SourceParentId: uint32,
	DataFrameCount: int32,
	DataType: [33]byte,
	Preview: bool,
	Delivery: bool
}

state ImGuiTextFilter_ImGuiTextRange_t
{
	b: *byte,
	e: *byte
}

state ImGuiTextFilter_t
{
	InputBuf: [256]byte,
	Filters: ImVector_ImGuiTextRange_t,
	CountGrep: int32
}

state ImGuiTextBuffer_t
{
	Buf: ImVector_char_t
}

state ImGuiStoragePair_t
{
	key: uint32,
	vals: ?{
		val_i: int32,
		val_f: float32,
		val_p: *void
	}
}

state ImGuiStorage_t
{
	Data: ImVector_ImGuiStoragePair_t
}

state ImGuiListClipper_t
{
	Ctx: *ImGuiContext_t,
	DisplayStart: int32,
	DisplayEnd: int32,
	ItemsCount: int32,
	ItemsHeight: float32,
	StartPosY: float64,
	StartSeekOffsetY: float64,
	TempData: *void,
	Flags: int32
}

state ImColor_t
{
	Value: ImVec4_t
}

state ImGuiMultiSelectIO_t
{
	Requests: ImVector_ImGuiSelectionRequest_t,
	RangeSrcItem: int64,
	NavIdItem: int64,
	NavIdSelected: bool,
	RangeSrcReset: bool,
	ItemsCount: int32
}

state ImGuiSelectionRequest_t
{
	Type: ImGuiSelectionRequestType,
	Selected: bool,
	RangeDirection: byte,
	RangeFirstItem: int64,
	RangeLastItem: int64
}

state ImGuiSelectionBasicStorage_t
{
	Size: int32,
	PreserveOrder: bool,
	UserData: *void,
	AdapterIndexToStorageId: ::(),
	_SelectionOrder: int32,
	_Storage: ImGuiStorage_t
}

state ImGuiSelectionExternalStorage_t
{
	UserData: *void,
	AdapterSetItemSelected: ::()
}

state ImDrawCmd_t
{
	ClipRect: ImVec4_t,
	TexRef: ImTextureRef_t,
	VtxOffset: uint32,
	IdxOffset: uint32,
	ElemCount: uint32,
	UserCallback: ::(),
	UserCallbackData: *void,
	UserCallbackDataSize: int32,
	UserCallbackDataOffset: int32
}

state ImDrawVert_t
{
	pos: ImVec2_t,
	uv: ImVec2_t,
	col: uint32
}

state ImDrawCmdHeader_t
{
	ClipRect: ImVec4_t,
	TexRef: ImTextureRef_t,
	VtxOffset: uint32
}

state ImDrawChannel_t
{
	_CmdBuffer: ImVector_ImDrawCmd_t,
	_IdxBuffer: ImVector_ImDrawIdx_t
}

state ImDrawListSplitter_t
{
	_Current: int32,
	_Count: int32,
	_Channels: ImVector_ImDrawChannel_t
}

state ImDrawList_t
{
	CmdBuffer: ImVector_ImDrawCmd_t,
	IdxBuffer: ImVector_ImDrawIdx_t,
	VtxBuffer: ImVector_ImDrawVert_t,
	Flags: int32,
	_VtxCurrentIdx: uint32,
	_Data: *ImDrawListSharedData_t,
	_VtxWritePtr: *ImDrawVert_t,
	_IdxWritePtr: *uint16,
	_Path: ImVector_ImVec2_t,
	_CmdHeader: ImDrawCmdHeader_t,
	_Splitter: ImDrawListSplitter_t,
	_ClipRectStack: ImVector_ImVec4_t,
	_TextureStack: ImVector_ImTextureRef_t,
	_CallbacksDataBuf: ImVector_ImU8_t,
	_FringeScale: float32,
	_OwnerName: *byte
}

state ImDrawData_t
{
	Valid: bool,
	CmdListsCount: int32,
	TotalIdxCount: int32,
	TotalVtxCount: int32,
	CmdLists: ImVector_ImDrawListPtr_t,
	DisplayPos: ImVec2_t,
	DisplaySize: ImVec2_t,
	FramebufferScale: ImVec2_t,
	OwnerViewport: *ImGuiViewport_t,
	Textures: *ImVector_ImTextureDataPtr_t
}

state ImTextureRect_t
{
	x: uint16,
	y: uint16,
	w: uint16,
	h: uint16
}

state ImTextureData_t
{
	UniqueID: int32,
	Status: ImTextureStatus,
	BackendUserData: *void,
	TexID: uint64,
	Format: ImTextureFormat,
	Width: int32,
	Height: int32,
	BytesPerPixel: int32,
	Pixels: *ubyte,
	UsedRect: ImTextureRect_t,
	UpdateRect: ImTextureRect_t,
	Updates: ImVector_ImTextureRect_t,
	UnusedFrames: int32,
	RefCount: uint16,
	UseColors: bool,
	WantDestroyNextFrame: bool
}

state ImFontConfig_t
{
	Name: [40]byte,
	FontData: *void,
	FontDataSize: int32,
	FontDataOwnedByAtlas: bool,
	MergeMode: bool,
	PixelSnapH: bool,
	PixelSnapV: bool,
	OversampleH: byte,
	OversampleV: byte,
	EllipsisChar: uint16,
	SizePixels: float32,
	GlyphRanges: *uint16,
	GlyphExcludeRanges: *uint16,
	GlyphOffset: ImVec2_t,
	GlyphMinAdvanceX: float32,
	GlyphMaxAdvanceX: float32,
	GlyphExtraAdvanceX: float32,
	FontNo: uint32,
	FontLoaderFlags: uint32,
	RasterizerMultiply: float32,
	RasterizerDensity: float32,
	Flags: int32,
	DstFont: *ImFont_t,
	FontLoader: *ImFontLoader_t,
	FontLoaderData: *void
}

state ImFontGlyph_t
{
	//unsigned int Colored : 1;     // Flag to indicate glyph is colored and should generally ignore tinting (make it usable with no shift on little-endian as this is used in loops)
    //unsigned int Visible : 1;     // Flag to indicate glyph has no visible pixels (e.g. space). Allow early out when rendering.
    //unsigned int SourceIdx : 4;   // Index of source in parent font
    //unsigned int Codepoint : 26;  // 0x0000..0x10FFFF
	Bits: uint32,
	AdvanceX: float32,
	X0: float32,
	Y0: float32,
	X1: float32,
	Y1: float32,
	U0: float32,
	V0: float32,
	U1: float32,
	V1: float32,
	PackId: int32
}

state ImFontGlyphRangesBuilder_t
{
	UsedChars: ImVector_ImU32_t
}

state ImFontAtlasRect_t
{
	x: uint16,
	y: uint16,
	w: uint16,
	h: uint16,
	uv0: ImVec2_t,
	uv1: ImVec2_t
}

state ImFontAtlas_t
{
	Flags: int32,
	TexDesiredFormat: ImTextureFormat,
	TexGlyphPadding: int32,
	TexMinWidth: int32,
	TexMinHeight: int32,
	TexMaxWidth: int32,
	TexMaxHeight: int32,
	UserData: *void,
	TexRef: ImTextureRef_t,
	TexData: *ImTextureData_t,
	TexList: ImVector_ImTextureDataPtr_t,
	Locked: bool,
	RendererHasTextures: bool,
	TexIsBuilt: bool,
	TexPixelsUseColors: bool,
	TexUvScale: ImVec2_t,
	TexUvWhitePixel: ImVec2_t,
	Fonts: ImVector_ImFontPtr_t,
	Sources: ImVector_ImFontConfig_t,
	TexUvLines: [33]ImVec4_t,
	TexNextUniqueID: int32,
	FontNextUniqueID: int32,
	DrawListSharedDatas: ImVector_ImDrawListSharedDataPtr_t,
	Builder: *ImFontAtlasBuilder_t,
	FontLoader: *ImFontLoader_t,
	FontLoaderName: *byte,
	FontLoaderData: *void,
	FontLoaderFlags: uint32,
	RefCount: int32,
	OwnerContext: *ImGuiContext_t,
	TempRect: ImFontAtlasRect_t
}

state ImFontBaked_t
{
	IndexAdvanceX: ImVector_float_t,
	FallbackAdvanceX: float32,
	Size: float32,
	RasterizerDensity: float32,
	IndexLookup: ImVector_ImU16_t,
	Glyphs: ImVector_ImFontGlyph_t,
	FallbackGlyphIndex: int32,
	Ascent: float32,
	Descent: float32,
	//unsigned int         MetricsTotalSurface : 26;  // 3  // out // Total surface in pixels to get an idea of the font rasterization/texture cost (not exact, we approximate the cost of padding between glyphs)
    //unsigned int         WantDestroy : 1;           // 0  //     // Queued for destroy
    //unsigned int         LoadNoFallback : 1;        // 0  //     // Disable loading fallback in lower-level calls.
    //unsigned int         LoadNoRenderOnLayout : 1;  // 0  //     // Enable a two-steps mode where CalcTextSize() calls will load AdvanceX *without* rendering/packing glyphs. Only advantagous if you know that the glyph is unlikely to actually be rendered, otherwise it is slower because we'd do one query on the first CalcTextSize and one query on the first Draw.
	Bits: uint32,
	LastUsedFrame: int32,
	BakedId: uint32,
	OwnerFont: *ImFont_t,
	FontLoaderDatas: *void
}

state ImFont_t
{
	LastBaked: *ImFontBaked_t,
	OwnerAtlas: *ImFontAtlas_t,
	Flags: int32,
	CurrentRasterizerDensity: float32,
	FontId: uint32,
	LegacySize: float32,
	Sources: ImVector_ImFontConfigPtr_t,
	EllipsisChar: uint16,
	FallbackChar: uint16,
	Used8kPagesMap: [1]ubyte,
	EllipsisAutoBake: bool,
	RemapPairs: ImGuiStorage_t,
	Scale: float32
}

state ImGuiViewport_t
{
	ID: uint32,
	Flags: int32,
	Pos: ImVec2_t,
	Size: ImVec2_t,
	FramebufferScale: ImVec2_t,
	WorkPos: ImVec2_t,
	WorkSize: ImVec2_t,
	PlatformHandle: *void,
	PlatformHandleRaw: *void
}

state ImGuiPlatformIO_t
{
	Platform_GetClipboardTextFn: ::(),
	Platform_SetClipboardTextFn: ::(),
	Platform_ClipboardUserData: *void,
	Platform_OpenInShellFn: ::(),
	Platform_OpenInShellUserData: *void,
	Platform_SetImeDataFn: ::(),
	Platform_ImeUserData: *void,
	Platform_LocaleDecimalPoint: uint16,
	Renderer_TextureMaxWidth: int32,
	Renderer_TextureMaxHeight: int32,
	Renderer_RenderState: *void,
	Textures: ImVector_ImTextureDataPtr_t
}

state ImGuiPlatformImeData_t
{
	WantVisible: bool,
	WantTextInput: bool,
	InputPos: ImVec2_t,
	InputLineHeight: float32,
	ViewportId: uint32
}

