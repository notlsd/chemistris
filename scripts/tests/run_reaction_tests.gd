extends SceneTree

const Models := preload("res://scripts/gameplay/reaction_models.gd")
const ReactionController := preload("res://scripts/gameplay/reaction_controller.gd")

func _init() -> void:
	DataService.load_catalog()
	var controller := ReactionController.new()
	var grid_state := _build_sample_grid()
	var trigger := Models.ReactionTrigger.new("飞流直下三千尺", grid_state, 1)
	var result := controller.attempt_reaction(trigger)
	_assert(result != null, "Expected reaction result")
	_assert(result.consumed_ids.size() == 3, "Expected three molecules to be consumed")
	_assert(result.product_counts.get("H2O", 0) == 2, "Expected 2 H2O to be produced")
	print("ReactionController tests passed.")
	quit()

func _build_sample_grid() -> Models.ReactionGridState:
	var grid_state := Models.ReactionGridState.new()
	var cell := Models.CellState.new(Vector2i.ZERO)
	var h2_atoms1 := [Models.AtomState.new(1, "H", cell), Models.AtomState.new(2, "H", cell)]
	var h2_atoms2 := [Models.AtomState.new(5, "H", cell), Models.AtomState.new(6, "H", cell)]
	var o2_atoms := [Models.AtomState.new(3, "O", cell), Models.AtomState.new(4, "O", cell)]
	var m1 := Models.MoleculeState.new(1, "H2", [2, 3], h2_atoms1)
	var m2 := Models.MoleculeState.new(2, "H2", [1, 3], h2_atoms2)
	var m3 := Models.MoleculeState.new(3, "O2", [1, 2], o2_atoms)
	grid_state.add_molecule(m1)
	grid_state.add_molecule(m2)
	grid_state.add_molecule(m3)
	return grid_state

func _assert(condition: bool, message: String) -> void:
	if not condition:
		push_error(message)
		quit(1)
