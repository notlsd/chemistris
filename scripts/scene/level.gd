
extends Node2D

const Models := preload("res://scripts/gameplay/reaction_models.gd")
const ReactionController := preload("res://scripts/gameplay/reaction_controller.gd")
const MoleculeScene := preload("res://scenes/Molecule.tscn")
const ReactionDisplayScene := preload("res://scenes/ReactionDisplay.tscn")
const ConditionScene := preload("res://scenes/Condition.tscn")
const LevelHudScene := preload("res://ui/level_hud.tscn")

const CONDITION_ASSETS := {
	"₳": {"name": "Heat / 加热", "icon": preload("res://assets/sprites/spr_heat/spr_heat_00.png")},
	"₼": {"name": "Ignite / 点燃", "icon": preload("res://assets/sprites/spr_fire/spr_fire_00.png")},
	"¤": {"name": "Light / 光照", "icon": preload("res://assets/sprites/spr_light/spr_light_00.png")},
	"₪": {"name": "Electric / 放电", "icon": preload("res://assets/sprites/spr_elec/spr_elec_00.png")},
	"¥": {"name": "High Temp / 高温", "icon": preload("res://assets/sprites/spr_HT/spr_HT_00.png")},
	"₩": {"name": "High Temp+Pressure / 高温高压", "icon": preload("res://assets/sprites/spr_HTHP/spr_HTHP.png")},
	"@": {"name": "Catalyst / 催化剂", "icon": null},
}

@export var level_id := ""

@onready var grid_root := $GridRoot
@onready var board_tile_map := $GridRoot/BoardTileMap
@onready var molecule_layer := $GridRoot/MoleculeLayer
@onready var condition_layer := $GridRoot/ConditionLayer
@onready var reaction_layer := $ReactionLayer
@onready var hud_canvas := $HudCanvas

var _controller := ReactionController.new()
var _equation_codes: Array[String] = []
var _level_row: Dictionary = {}
var _hud: ChemistrisLevelHud = null
var _successful_reactions := 0

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
	_level_row = found_row
	_ensure_hud()
	_setup_grid()
	_equation_codes = _parse_equation_codes(found_row)
	_spawn_initial_entities()
	_refresh_hud_for_level()

func _ensure_hud() -> void:
	if _hud != null:
		return
	for child in hud_canvas.get_children():
		child.queue_free()
	var hud_instance: ChemistrisLevelHud = LevelHudScene.instantiate() as ChemistrisLevelHud
	_hud = hud_instance
	if _hud == null:
		push_error("Level: unable to instantiate LevelHud scene.")
		return
	hud_canvas.add_child(_hud)

func _setup_grid() -> void:
	var tile_set: TileSet = board_tile_map.tile_set
	if tile_set == null:
		return
	var cell_size := Vector2i(int(GridHelper.CELL_SIZE.x), int(GridHelper.CELL_SIZE.y))
	tile_set.tile_size = cell_size

func _parse_equation_codes(row: Dictionary) -> Array[String]:
	var code_string := str(row.get("L1_CODE", ""))
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
			_successful_reactions += 1
			if _hud != null:
				var summary := _format_product_counts(result.product_counts)
				_hud.record_reaction(true, "Success -> %s" % summary)
		else:
			print("Reaction failed")
			if _hud != null:
				_hud.record_reaction(false, "Requirements not met for %s" % _equation_codes[0])

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
	var instance: ChemistrisCondition = ConditionScene.instantiate() as ChemistrisCondition
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

func _refresh_hud_for_level() -> void:
	if _hud == null or _level_row.is_empty():
		return
	var level_name := str(_level_row.get("L0_LEVEL", ""))
	var chapter := str(_level_row.get("L3_CHAP", ""))
	var objective := str(_level_row.get("L2_COUNT", ""))
	var banned := str(_level_row.get("L5_BAN", ""))
	_hud.set_level_metadata(level_name, chapter, objective, banned)
	_hud.set_equations(_equation_codes)
	var condition_symbols := _collect_condition_symbols()
	_hud.set_condition_symbols(condition_symbols, CONDITION_ASSETS)
	_hud.show_hint("Press Enter to attempt \"%s\"." % (_equation_codes[0] if _equation_codes.size() > 0 else level_name))

func _collect_condition_symbols() -> Array[String]:
	var seen := {}
	var result: Array[String] = []
	for code in _equation_codes:
		var reactants := DataService.get_reactant_array(code, true)
		for symbol in reactants:
			if DataService.is_condition_symbol(symbol) and not seen.has(symbol):
				seen[symbol] = true
				result.append(symbol)
	return result

func _format_product_counts(counts: Dictionary) -> String:
	var parts: Array[String] = []
	for key in counts.keys():
		parts.append("%s × %d" % [key, int(counts[key])])
	return ", ".join(parts)
