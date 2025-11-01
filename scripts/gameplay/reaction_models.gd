class_name ReactionModels

class ReactionTrigger:
	var equation_code: String
	var trigger_molecule_id: int = -1
	var trigger_condition: String = ""
	var grid_state: ReactionGridState

	func _init(equation_code: String, grid_state: ReactionGridState, trigger_molecule_id := -1, trigger_condition := ""):
		self.equation_code = equation_code
		self.grid_state = grid_state
		self.trigger_molecule_id = trigger_molecule_id
		self.trigger_condition = trigger_condition

class ReactionGridState:
	var molecules: Dictionary = {}

	func add_molecule(molecule_state: MoleculeState) -> void:
		molecules[molecule_state.id] = molecule_state

	func get_molecule(id: int) -> MoleculeState:
		return molecules.get(id, null)

	func neighbors_of(id: int) -> Array[int]:
		var state: MoleculeState = molecules.get(id)
		return [] if state == null else state.neighbors

	func molecule_ids() -> Array[int]:
		return molecules.keys()

class MoleculeState:
	var id: int
	var molecule_code: String
	var neighbors: Array[int]
	var atoms: Array[AtomState]

	func _init(id: int, molecule_code: String, neighbors: Array[int]=[], atoms: Array[AtomState]=[]):
		self.id = id
		self.molecule_code = molecule_code
		self.neighbors = neighbors.duplicate()
		self.atoms = atoms.duplicate()

class AtomState:
	var id: int
	var symbol: String
	var cell: CellState

	func _init(id: int, symbol: String, cell: CellState):
		self.id = id
		self.symbol = symbol
		self.cell = cell

class CellState:
	var position: Vector2i

	func _init(position: Vector2i):
		self.position = position

class ReactionRequirements:
	var molecule_counts: Dictionary = {}
	var condition_symbols: Array[String] = []

	func increment(symbol: String) -> void:
		molecule_counts[symbol] = molecule_counts.get(symbol, 0) + 1

	func satisfied_by(counts: Dictionary) -> bool:
		for key in molecule_counts.keys():
			if counts.get(key, 0) < molecule_counts[key]:
				return false
		return true

class ReactionResult:
	var consumed_ids: Array[int] = []
	var product_counts: Dictionary = {}
	var produced_molecules: Array[String] = []

	func _init(consumed_ids: Array[int], product_counts: Dictionary, produced_molecules: Array[String]):
		self.consumed_ids = consumed_ids.duplicate()
		self.product_counts = product_counts.duplicate()
		self.produced_molecules = produced_molecules.duplicate()
