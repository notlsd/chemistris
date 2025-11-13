extends Node2D
class_name ChemistrisCondition

@export var condition_type := ""
@export var grid_position := Vector2i.ZERO

func _ready() -> void:
	if condition_type == "":
		push_warning("Condition: condition_type not set; assign during spawn.")
