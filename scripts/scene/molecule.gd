extends Node2D

signal landed(cell: Vector2i)
signal reacted(reaction_code: String)

@export var molecule_id := ""
@export var fall_speed := 72.0

func _ready() -> void:
	# Placeholder sprite until animation system is wired.
	if get_node_or_null("SpriteRoot/MoleculeSprite") == null:
		push_warning("Molecule: placeholder sprite missing; add AnimatedSprite2D in Phase 4.")

func apply_drop(delta: float) -> void:
	position.y += fall_speed * delta
