extends Node
class_name ChemistrisGameState

signal level_started(level_id: String)
signal level_completed(level_id: String)
signal level_selected(level_id: String)
signal ui_scale_changed(scale: float)
signal colorblind_mode_changed(enabled: bool)

var current_level_id := ""
var selected_level_id := ""
var unlocked_levels: Array[String] = []
var ui_scale := 1.0
var colorblind_mode := false

func set_current_level(level_id: String) -> void:
	if level_id == "":
		return
	current_level_id = level_id
	select_level(level_id)
	level_started.emit(level_id)

func select_level(level_id: String) -> void:
	if level_id == "":
		return
	selected_level_id = level_id
	if not unlocked_levels.has(level_id):
		unlocked_levels.append(level_id)
	level_selected.emit(level_id)

func mark_level_complete(level_id: String) -> void:
	if level_id == "":
		return
	if not unlocked_levels.has(level_id):
		unlocked_levels.append(level_id)
	level_completed.emit(level_id)

func set_ui_scale(scale: float) -> void:
	var clamped := clampf(scale, 0.75, 1.5)
	if is_equal_approx(ui_scale, clamped):
		return
	ui_scale = clamped
	ui_scale_changed.emit(ui_scale)

func set_colorblind_mode(enabled: bool) -> void:
	if colorblind_mode == enabled:
		return
	colorblind_mode = enabled
	colorblind_mode_changed.emit(colorblind_mode)
