extends Node
class_name ChemistrisGridHelper

const CELL_SIZE := Vector2(72, 72)
const HIDDEN_ROWS := 5

func world_to_cell(world_pos: Vector2) -> Vector2i:
	return Vector2i(floor(world_pos.x / CELL_SIZE.x), floor(world_pos.y / CELL_SIZE.y))

func cell_to_world(cell: Vector2i, center := false) -> Vector2:
	var base := Vector2(cell.x * CELL_SIZE.x, cell.y * CELL_SIZE.y)
	return base + (CELL_SIZE / 2.0) if center else base

func cell_in_bounds(cell: Vector2i, width: int, height: int) -> bool:
	return cell.x >= 0 and cell.x < width and cell.y >= -HIDDEN_ROWS and cell.y < height

func neighbors(cell: Vector2i) -> Array[Vector2i]:
	return [
		cell + Vector2i(1, 0),
		cell + Vector2i(-1, 0),
		cell + Vector2i(0, 1),
		cell + Vector2i(0, -1),
	]
