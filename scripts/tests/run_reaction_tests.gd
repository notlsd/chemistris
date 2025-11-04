
extends SceneTree

const Models := preload("res://scripts/gameplay/reaction_models.gd")
const ReactionController := preload("res://scripts/gameplay/reaction_controller.gd")

func _init() -> void:
	DataService.load_catalog()
	_test_basic_reaction()
	_test_failure_when_neighbors_missing()
	_test_condition_requirement()
	print("ReactionController tests passed.")
	quit()

func _test_basic_reaction() -> void:
	var controller := ReactionController.new()
	var grid_state := _build_grid_state([
		{"id": 1, "code": "H2", "cell": Vector2i(0, 0), "neighbors": [2, 3]},
		{"id": 2, "code": "H2", "cell": Vector2i(1, 0), "neighbors": [1, 3]},
		{"id": 3, "code": "O2", "cell": Vector2i(2, 0), "neighbors": [1, 2]},
	])
	var trigger := Models.ReactionTrigger.new("飞流直下三千尺", grid_state, 1)
	var result := controller.attempt_reaction(trigger)
	_assert(result != null, "Expected reaction result for 飞流直下三千尺")
	_assert(result.product_counts.get("H2O", 0) == 2, "Expected 2 H2O to be produced")

func _test_failure_when_neighbors_missing() -> void:
	var controller := ReactionController.new()
	var grid_state := _build_grid_state([
		{"id": 1, "code": "H2", "cell": Vector2i(0, 0), "neighbors": []},
		{"id": 2, "code": "H2", "cell": Vector2i(5, 0), "neighbors": []},
		{"id": 3, "code": "O2", "cell": Vector2i(10, 0), "neighbors": []},
	])
	var trigger := Models.ReactionTrigger.new("飞流直下三千尺", grid_state, 1)
	var result := controller.attempt_reaction(trigger)
	_assert(result == null, "Reaction should fail when molecules are not adjacent")

func _test_condition_requirement() -> void:
	var controller := ReactionController.new()
	var grid_state := _build_grid_state([
		{"id": 1, "code": "H2O", "cell": Vector2i(0, 0), "neighbors": [2]},
		{"id": 2, "code": "H2O", "cell": Vector2i(1, 0), "neighbors": [1]},
	])
	var trigger := Models.ReactionTrigger.new("疑是银河上九天", grid_state, 1, "₪")
	var result := controller.attempt_reaction(trigger)
	_assert(result != null, "Condition reaction should succeed with trigger symbol")
	_assert(result.product_counts.get("H2", 0) == 2, "Expected H2 output for condition reaction")

func _build_grid_state(entries: Array) -> Models.ReactionGridState:
	var state := Models.ReactionGridState.new()
	for entry in entries:
		var cell_state := Models.CellState.new(entry["cell"])
		var atom := Models.AtomState.new(entry["id"] * 10, entry["code"], cell_state)
		var molecule := Models.MoleculeState.new(entry["id"], entry["code"], entry["neighbors"], [atom])
		state.add_molecule(molecule)
	return state

func _assert(condition: bool, message: String) -> void:
	if not condition:
		push_error(message)
		quit(1)
