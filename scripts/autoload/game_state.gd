extends Node
class_name ChemistrisGameState

signal level_started(level_id: String)
signal level_completed(level_id: String)

var current_level_id := ""
var unlocked_levels: Array[String] = []

func set_current_level(level_id: String) -> void:
	current_level_id = level_id
	emit_signal("level_started", level_id)

func mark_level_complete(level_id: String) -> void:
	if not unlocked_levels.has(level_id):
		unlocked_levels.append(level_id)
	emit_signal("level_completed", level_id)
