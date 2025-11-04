
extends Node2D

const Models := preload("res://scripts/gameplay/reaction_models.gd")
const ReactionController := preload("res://scripts/gameplay/reaction_controller.gd")
const MoleculeScene := preload("res://scenes/Molecule.tscn")
const ReactionDisplayScene := preload("res://scenes/ReactionDisplay.tscn")

@export var level_id := ""

@onready var grid_root := $GridRoot
@onready var board_tile_map := $GridRoot/BoardTileMap
@onready var molecule_layer := $GridRoot/MoleculeLayer
@onready var condition_layer := $GridRoot/ConditionLayer
@onready var reaction_layer := $ReactionLayer
@onready var hud_canvas := $HudCanvas

var _controller := ReactionController.new()
var _equation_codes: Array[String] = []

func _ready() -> void:
	if level_id.is_empty():
		return
	_load_level(level_id)

func _load_level(id: String) -> void:
	var level_rows := DataService.get_level_rows()
	var record := level_rows.filter(func(row): return row.get("L0_LEVEL", "") == id)
	if record.is_empty():
		push_warning("Level: level id %s not found in data set" % id)
		return
	var row: Dictionary = record[0]
	_setup_grid()
	_equation_codes = _parse_equation_codes(row)
	_spawn_initial_entities()

func _setup_grid() -> void:
	board_tile_map.cell_size = Vector2i(GridHelper.CELL_SIZE)

func _parse_equation_codes(row: Dictionary) -> Array[String]:
	var code_string: String = row.get("L1_CODE", "")
	if code_string == "":
		return []
	return code_string.split("&", false)

func _spawn_initial_entities() -> void:
	if _equation_codes.is_empty():
		return
	var reactants := DataService.get_reactant_array(_equation_codes[0], false)
	var start_cell := Vector2i.ZERO
	for i in range(reactants.size()):
		var scene_instance: Node2D = MoleculeScene.instantiate()
		scene_instance.molecule_id = reactants[i]
		var cell := start_cell + Vector2i(i, 0)
		scene_instance.position = GridHelper.cell_to_world(cell, true)
		molecule_layer.add_child(scene_instance)

func build_grid_state() -> Models.ReactionGridState:
	var state := Models.ReactionGridState.new()
	var cell_to_id: Dictionary = {}
	for molecule_node in molecule_layer.get_children():
		if molecule_node.has_method("get_grid_state"):
			var molecule_state: Models.MoleculeState = molecule_node.get_grid_state()
			state.add_molecule(molecule_state)
			cell_to_id[molecule_state.atoms[0].cell.position] = molecule_state.id
	var directions := [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]
	for id in state.molecule_ids():
		var molecule_state := state.get_molecule(id)
		var cell_pos := molecule_state.atoms[0].cell.position
		var neighbors: Array[int] = []
		for dir in directions:
			var neighbor_id := cell_to_id.get(cell_pos + dir, null)
			if neighbor_id != null:
				neighbors.append(neighbor_id)
		molecule_state.neighbors = neighbors
	return state

func handle_reaction(trigger_id: int, equation_code: String) -> Models.ReactionResult:
	var grid_state := build_grid_state()
	var trigger := Models.ReactionTrigger.new(equation_code, grid_state, trigger_id)
	return _controller.attempt_reaction(trigger)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm"):
		if molecule_layer.get_child_count() == 0 or _equation_codes.is_empty():
			return
		var first_molecule: Node = molecule_layer.get_child(0)
		var result := handle_reaction(first_molecule.get_instance_id(), _equation_codes[0])
		if result != null:
			_show_reaction(result, _equation_codes[0])
		else:
			print("Reaction failed")

func _show_reaction(result: Models.ReactionResult, equation_code: String) -> void:
	var display: Control = ReactionDisplayScene.instantiate()
	display.show_reaction(equation_code, result.product_counts)
	reaction_layer.add_child(display)
	display.display_finished.connect(display.queue_free)
