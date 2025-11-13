
extends Node2D

const Models := preload("res://scripts/gameplay/reaction_models.gd")
const ReactionController := preload("res://scripts/gameplay/reaction_controller.gd")
const MoleculeScene := preload("res://scenes/Molecule.tscn")
const ReactionDisplayScene := preload("res://scenes/ReactionDisplay.tscn")
const ConditionScene := preload("res://scenes/Condition.tscn")

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
	if level_id.is_empty() and GameState.current_level_id != "":
		level_id = GameState.current_level_id
	if level_id.is_empty():
		push_warning("Level: level_id not provided; aborting load.")
		return
	_load_level(level_id)

func _load_level(id: String) -> void:
	var level_rows: Array[Dictionary] = DataService.get_level_rows()
	var found_row: Dictionary = {}
	for row in level_rows:
		if row.get("L0_LEVEL", "") == id:
			found_row = row
			break
	if found_row.is_empty():
		push_warning("Level: level id %s not found in data set" % id)
		return
	_setup_grid()
	_equation_codes = _parse_equation_codes(found_row)
	_spawn_initial_entities()

func _setup_grid() -> void:
	var tile_set: TileSet = board_tile_map.tile_set
	if tile_set == null:
		return
	var cell_size := Vector2i(int(GridHelper.CELL_SIZE.x), int(GridHelper.CELL_SIZE.y))
	tile_set.tile_size = cell_size

func _parse_equation_codes(row: Dictionary) -> Array[String]:
	var code_string: String = row.get("L1_CODE", "")
	if code_string == "":
		return []
	var parts := code_string.split("&", false)
	var codes: Array[String] = []
	for part in parts:
		codes.append(String(part))
	return codes

func _spawn_initial_entities() -> void:
	if _equation_codes.is_empty():
		return
	var column_offset: int = 0
	for eq_index in range(_equation_codes.size()):
		var equation_code := _equation_codes[eq_index]
		var molecules := DataService.get_reactant_array(equation_code, false)
		var reactants_with_conditions := DataService.get_reactant_array(equation_code, true)
		var row_cell: int = eq_index
		for i in range(molecules.size()):
			var cell := Vector2i(column_offset + i, row_cell)
			_spawn_molecule(molecules[i], cell)
		for symbol in reactants_with_conditions:
			if DataService.is_condition_symbol(symbol):
				var condition_cell := Vector2i(column_offset + molecules.size(), row_cell)
				_spawn_condition(symbol, condition_cell)
		column_offset += molecules.size() + 2

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
			var neighbor_id: int = cell_to_id.get(cell_pos + dir, -1)
			if neighbor_id != -1:
				neighbors.append(neighbor_id)
		molecule_state.neighbors = neighbors
	return state

func handle_reaction(trigger_id: int, equation_code: String, condition_symbol: String="") -> Models.ReactionResult:
	var grid_state := build_grid_state()
	var trigger := Models.ReactionTrigger.new(equation_code, grid_state, trigger_id, condition_symbol)
	return _controller.attempt_reaction(trigger)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm"):
		if molecule_layer.get_child_count() == 0 or _equation_codes.is_empty():
			return
		var first_molecule: Node = molecule_layer.get_child(0)
		var condition_symbol := _find_condition_symbol(_equation_codes[0])
		var result := handle_reaction(first_molecule.get_instance_id(), _equation_codes[0], condition_symbol)
		if result != null:
			_consume_condition(condition_symbol)
			_remove_consumed(result.consumed_ids)
			_show_reaction(result, _equation_codes[0])
		else:
			print("Reaction failed")

func _show_reaction(result: Models.ReactionResult, equation_code: String) -> void:
	var display: Control = ReactionDisplayScene.instantiate()
	display.show_reaction(equation_code, result.product_counts)
	reaction_layer.add_child(display)
	display.display_finished.connect(display.queue_free)


func _spawn_molecule(molecule_code: String, cell: Vector2i) -> void:
	var instance: Node2D = MoleculeScene.instantiate()
	instance.molecule_id = molecule_code
	instance.position = GridHelper.cell_to_world(cell, true)
	molecule_layer.add_child(instance)

func _spawn_condition(condition_symbol: String, cell: Vector2i) -> void:
	var instance := ConditionScene.instantiate() as ChemistrisCondition
	if instance == null:
		push_error("Level: Condition scene is missing ChemistrisCondition script.")
		return
	instance.condition_type = condition_symbol
	instance.position = GridHelper.cell_to_world(cell, true)
	condition_layer.add_child(instance)


func _find_condition_symbol(equation_code: String) -> String:
	var reactants := DataService.get_reactant_array(equation_code, true)
	for symbol in reactants:
		if DataService.is_condition_symbol(symbol):
			return symbol
	return ""

func _remove_consumed(ids: Array[int]) -> void:
	var id_set := ids.duplicate()
	for child in molecule_layer.get_children():
		if child.get_instance_id() in id_set:
			child.queue_free()

func _consume_condition(condition_symbol: String) -> void:
	if condition_symbol == "":
		return
	for child in condition_layer.get_children():
		var condition := child as ChemistrisCondition
		if condition == null:
			continue
		if condition.condition_type == condition_symbol:
			condition.queue_free()
			break
