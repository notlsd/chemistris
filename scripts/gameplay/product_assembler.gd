extends Node
class_name ProductAssembler

const Models := preload("res://scripts/gameplay/reaction_models.gd")

func assemble_products(equation_code: String, molecules: Array) -> Dictionary:
	var product_map: Dictionary = DataService.get_product_map()
	if not product_map.has(equation_code):
		return {}
	var products: Dictionary = product_map[equation_code]
	var produced_list: Array[String] = []
	for name in products.keys():
		var qty: int = int(products[name])
		for _i in range(qty):
			produced_list.append(str(name))
	return {
		"counts": products.duplicate(),
		"list": produced_list
	}
