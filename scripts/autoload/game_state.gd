extends Node
class_name ChemistrisGameState

signal level_started(level_id: String)
signal level_completed(level_id: String)
signal level_selected(level_id: String)

var current_level_id := ""
var selected_level_id := ""
var unlocked_levels: Array[String] = []

func set_current_level(level_id: String) -> void:
	if level_id == "":
		return
	current_level_id = level_id
	select_level(level_id)
	emit_signal("level_started", level_id)

func select_level(level_id: String) -> void:
	if level_id == "":
		return
	selected_level_id = level_id
	if not unlocked_levels.has(level_id):
		unlocked_levels.append(level_id)
	emit_signal("level_selected", level_id)

func mark_level_complete(level_id: String) -> void:
	if level_id == "":
		return
	if not unlocked_levels.has(level_id):
		unlocked_levels.append(level_id)
	emit_signal("level_completed", level_id)
