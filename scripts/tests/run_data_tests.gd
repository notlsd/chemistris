extends SceneTree

func _init() -> void:
	var service := ChemistrisDataService.new()
	service.load_catalog()

	var reactants := service.get_reactant_map()
	_assert(reactants.has("飞流直下三千尺"), "Missing key 飞流直下三千尺 in reactant map")
	_assert(reactants["飞流直下三千尺"].get("H2", 0) == 2, "Expected 2 H2 in 飞流直下三千尺")
	_assert(reactants["飞流直下三千尺"].get("O2", 0) == 1, "Expected 1 O2 in 飞流直下三千尺")

	var products := service.get_product_map()
	_assert(products.has("飞流直下三千尺"), "Missing key 飞流直下三千尺 in product map")
	_assert(products["飞流直下三千尺"].get("H2O", 0) == 2, "Expected 2 H2O in 飞流直下三千尺 products")

	_assert(service.validate_stoichiometry(), "Stoichiometry validation failed")

	print("DataService tests passed.")
	quit()

func _assert(condition: bool, message: String) -> void:
	if not condition:
		push_error(message)
		quit(1)
