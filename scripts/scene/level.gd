extends Node2D

@export var level_id := ""

@onready var grid_root := $GridRoot
@onready var board_tile_map := $GridRoot/BoardTileMap
@onready var molecule_layer := $GridRoot/MoleculeLayer
@onready var condition_layer := $GridRoot/ConditionLayer
@onready var reaction_layer := $ReactionLayer
@onready var hud_canvas := $HudCanvas

func _ready() -> void:
	if level_id.is_empty():
		return
	_load_level(level_id)

func _load_level(id: String) -> void:
	var level_rows := ChemistrisDataService.get_level_rows()
	var record := level_rows.filter(func(row): return row.get("L0_LEVEL", "") == id)
	if record.is_empty():
		push_warning("Level: level id %s not found in data set" % id)
		return
	var row: Dictionary = record[0]
	_setup_grid()
	_spawn_initial_entities(row)

func _setup_grid() -> void:
	# Placeholder: configure tilemap cell size to 72px grid once a TileSet resource exists.
	if board_tile_map.tile_set == null:
		board_tile_map.cell_size = Vector2i(72, 72)

func _spawn_initial_entities(row: Dictionary) -> void:
	# Placeholder hook until reaction logic (Phase 4) is ported.
	pass
