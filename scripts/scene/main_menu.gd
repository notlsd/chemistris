extends Control

signal start_level_requested(level_id: String)

const LEVEL_SCENE_PATH := "res://scenes/Level.tscn"

@export var default_level_id := ""

func _ready() -> void:
	# Placeholder wiring until phase 4 implements dynamic chapter listings.
	if default_level_id.is_empty():
		var level_rows := DataService.get_level_rows()
		if level_rows.size() > 0:
			default_level_id = level_rows[0].get("L0_LEVEL", "")

func _on_start_button_pressed() -> void:
	if default_level_id.is_empty():
		push_warning("MainMenu: default_level_id not configured; ignoring start request.")
		return
	start_level_requested.emit(default_level_id)
	GameState.set_current_level(default_level_id)
	var err := get_tree().change_scene_to_file(LEVEL_SCENE_PATH)
	if err != OK:
		push_error("MainMenu: failed to load %s (error %s)" % [LEVEL_SCENE_PATH, err])
