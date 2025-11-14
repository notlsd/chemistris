extends Node2D
class_name ChemistrisCondition

const SPRITE_MAP := {
	"₳": preload("res://assets/sprites/spr_heat/spr_heat_00.png"),
	"₼": preload("res://assets/sprites/spr_fire/spr_fire_00.png"),
	"¤": preload("res://assets/sprites/spr_light/spr_light_00.png"),
	"₪": preload("res://assets/sprites/spr_elec/spr_elec_00.png"),
	"¥": preload("res://assets/sprites/spr_HT/spr_HT_00.png"),
	"₩": preload("res://assets/sprites/spr_HTHP/spr_HTHP.png"),
}

@export var condition_type := ""
@export var grid_position := Vector2i.ZERO

@onready var sprite: Sprite2D = $Sprite

func _ready() -> void:
	if condition_type == "":
		push_warning("Condition: condition_type not set; assign during spawn.")
		return
	_apply_texture()

func _apply_texture() -> void:
	if sprite == null:
		return
	var texture: Texture2D = SPRITE_MAP.get(condition_type, null)
	if texture == null:
		sprite.texture = null
		return
	sprite.texture = texture
	sprite.centered = false
