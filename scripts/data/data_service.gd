extends Node
class_name ChemistrisDataService

const CATALOG_PATH := "res://data/catalog.json"
const DATA_DIR := "res://data/csv"

var _catalog: Dictionary = {}
var _dataset_cache: Dictionary = {}
var _reactant_cache: Dictionary = {}
var _product_cache: Dictionary = {}
var _level_rows_cache: Array[Dictionary] = []

func _ready() -> void:
	# Autoload hook: preload catalog so the first gameplay scene can query data immediately.
	load_catalog()

func load_catalog(path: String = CATALOG_PATH) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("DataService: unable to open catalog at %s" % path)
		return
	var parsed: Variant = JSON.parse_string(file.get_as_text())
	file.close()
	if typeof(parsed) != TYPE_DICTIONARY:
		push_error("DataService: catalog JSON malformed (%s)" % path)
		return
	_catalog = parsed
	_dataset_cache.clear()
	_reactant_cache.clear()
	_product_cache.clear()
	_level_rows_cache.clear()

func get_reactant_map() -> Dictionary:
	if _reactant_cache.is_empty():
		_reactant_cache = _build_equation_molecule_map("reactant")
	return _reactant_cache

func get_product_map() -> Dictionary:
	if _product_cache.is_empty():
		_product_cache = _build_equation_molecule_map("product")
	return _product_cache

func get_level_rows() -> Array[Dictionary]:
	if _level_rows_cache.is_empty():
		var dataset := _load_dataset("level")
		var header: Array = dataset.get("header", [])
		var rows: Array = dataset.get("rows", [])
		for row_value in rows:
			var row: Array = row_value
			var entry: Dictionary = {}
			for i in range(header.size()):
				entry[header[i]] = row[i]
			_level_rows_cache.append(entry)
	return _level_rows_cache

func get_equation_codes() -> Array:
	return get_reactant_map().keys()

func validate_stoichiometry() -> bool:
	var react_map := get_reactant_map()
	var product_map := get_product_map()
	for code in react_map.keys():
		if not product_map.has(code):
			push_error("DataService: equation %s missing from product map" % code)
			return false
		var left := _collapse_to_atoms(react_map[code])
		var right := _collapse_to_atoms(product_map[code])
		if left != right:
			push_error("DataService: stoichiometry mismatch for %s -> %s vs %s" % [code, left, right])
			return false
	return true

func _build_equation_molecule_map(catalog_key: String) -> Dictionary:
	var dataset := _load_dataset(catalog_key)
	var header: Array = dataset.get("header", [])
	var rows: Array = dataset.get("rows", [])
	if header.is_empty():
		return {}
	var idx_code := header.find("RT_CODE")
	var idx_mole := header.find("RT_MOLECULE")
	var idx_qty := header.find("RT_QUANTITY")
	var map: Dictionary = {}
	for row_value in rows:
		var row: Array = row_value
		var code: String = row[idx_code]
		var molecule: String = row[idx_mole]
		var qty_text: String = row[idx_qty]
		var qty: int = 1 if qty_text.is_empty() else int(qty_text)
		if not map.has(code):
			map[code] = {}
		var molecules_for_code: Dictionary = map[code]
		molecules_for_code[molecule] = qty
	return map

func _load_dataset(catalog_key: String) -> Dictionary:
	if _dataset_cache.has(catalog_key):
		return _dataset_cache[catalog_key]
	if not _catalog.has(catalog_key):
		push_error("DataService: unknown catalog key %s" % catalog_key)
		return {}
	var filename: String = _catalog[catalog_key].get("filename", "")
	var path := "%s/%s" % [DATA_DIR, filename]
	var parsed := _parse_csv(path)
	_dataset_cache[catalog_key] = parsed
	return parsed

func _parse_csv(path: String) -> Dictionary:
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		push_error("DataService: unable to read csv at %s" % path)
		return {}
	var text: String = file.get_as_text()
	file.close()
	var lines := text.strip_edges().split("\n", false)
	if lines.is_empty():
		return {}
	var header := _split_csv_line(lines[0])
	var rows: Array = []
	for i in range(1, lines.size()):
		var line_text := lines[i].strip_edges()
		if line_text == "":
			continue
		rows.append(_split_csv_line(line_text))
	return {"header": header, "rows": rows}

func _split_csv_line(line: String) -> Array:
	var parts: Array = []
	var current := ""
	for ch in line:
		if ch == ',':
			parts.append(current)
			current = ""
		else:
			current += ch
	parts.append(current)
	return parts

func _collapse_to_atoms(molecule_map: Dictionary) -> Dictionary:
	var totals: Dictionary = {}
	for molecule in molecule_map.keys():
		if molecule.is_empty():
			continue
		var molecule_str: String = str(molecule)
		var code_point: int = molecule_str.unicode_at(0)
		if not _is_chemical_symbol_start(code_point):
			continue
		var per_molecule: Dictionary = _parse_molecule(molecule)
		var count: int = int(molecule_map[molecule])
		for atom in per_molecule.keys():
			var contribution: int = int(per_molecule[atom]) * count
			totals[atom] = totals.get(atom, 0) + contribution
	return totals

func _parse_molecule(formula: String) -> Dictionary:
	var atoms: Dictionary = {}
	var i := 0
	while i < formula.length():
		var ch := formula[i]
		if not _is_uppercase_letter(ch):
			i += 1
			continue
		var symbol := ch
		i += 1
		if i < formula.length():
			var next_ch := formula[i]
			if _is_lowercase_letter(next_ch):
				symbol += next_ch
				i += 1
		var digits := ""
		while i < formula.length():
			var digit_ch := formula[i]
			if not _is_digit(digit_ch):
				break
			digits += digit_ch
			i += 1
		var qty := 1 if digits == "" else int(digits)
		atoms[symbol] = atoms.get(symbol, 0) + qty
	return atoms

func _is_chemical_symbol_start(code_point: int) -> bool:
	return code_point >= 0x41 and code_point <= 0x5A

func _is_uppercase_letter(ch: String) -> bool:
	return ch.length() == 1 and ch >= "A" and ch <= "Z"

func _is_lowercase_letter(ch: String) -> bool:
	return ch.length() == 1 and ch >= "a" and ch <= "z"

func _is_digit(ch: String) -> bool:
	return ch.length() == 1 and ch >= "0" and ch <= "9"
