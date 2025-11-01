extends Node
class_name ReactionController

const Models := preload("res://scripts/gameplay/reaction_models.gd")
const ReactantFinder := preload("res://scripts/gameplay/reactant_finder.gd")
const ProductAssembler := preload("res://scripts/gameplay/product_assembler.gd")

var _finder: ReactantFinder
var _assembler: ProductAssembler

func _init() -> void:
	_finder = ReactantFinder.new()
	_assembler = ProductAssembler.new()

func attempt_reaction(trigger: Models.ReactionTrigger) -> Models.ReactionResult:
	var requirements := _build_requirements(trigger.equation_code)
	if requirements == null:
		return null
	if not _conditions_satisfied(trigger, requirements):
		return null
	var combos := _finder.find_reactant_combinations(trigger.trigger_molecule_id, requirements, trigger.grid_state)
	for combo in combos:
		var molecules: Array = []
		for id in combo:
			var state := trigger.grid_state.get_molecule(id)
			if state == null:
				molecules = []
				break
			molecules.append(state)
		if molecules.is_empty():
			continue
		var product_data := _assembler.assemble_products(trigger.equation_code, molecules)
		if product_data.is_empty():
			continue
		return Models.ReactionResult.new(combo, product_data["counts"], product_data["list"])
	return null

func _build_requirements(equation_code: String) -> Models.ReactionRequirements:
	var reactants_with_conditions := DataService.get_reactant_array(equation_code, true)
	var reactants_without_conditions := DataService.get_reactant_array(equation_code, false)
	if reactants_without_conditions.is_empty():
		return null
	var requirements := Models.ReactionRequirements.new()
	for molecule in reactants_without_conditions:
		requirements.increment(molecule)
	for symbol in reactants_with_conditions:
		if symbol not in reactants_without_conditions and DataService.is_condition_symbol(symbol):
			requirements.condition_symbols.append(symbol)
	return requirements

func _conditions_satisfied(trigger: Models.ReactionTrigger, requirements: Models.ReactionRequirements) -> bool:
	if requirements.condition_symbols.is_empty():
		return true
	if trigger.trigger_condition in requirements.condition_symbols:
		return true
	return false
