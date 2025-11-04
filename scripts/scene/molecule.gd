extends Node2D

const Models := preload("res://scripts/gameplay/reaction_models.gd")

signal landed(cell: Vector2i)
signal reacted(reaction_code: String)

@export var molecule_id := ""
@export var fall_speed := 72.0
@export var allows_input := true

var velocity := Vector2.ZERO
var grid_position := Vector2i.ZERO

func _ready() -> void:
	# Placeholder sprite until animation system is wired.
	if get_node_or_null("SpriteRoot/MoleculeSprite") == null:
		push_warning("Molecule: placeholder sprite missing; add AnimatedSprite2D in Phase 4.")

func apply_drop(delta: float) -> void:
	position.y += fall_speed * delta

func _physics_process(delta: float) -> void:
	velocity.y = fall_speed
	position += velocity * delta
	grid_position = GridHelper.world_to_cell(position)

func _unhandled_input(event: InputEvent) -> void:
	if not allows_input:
		return
	if event.is_action_pressed("move_left"):
		position.x -= GridHelper.CELL_SIZE.x
	elif event.is_action_pressed("move_right"):
		position.x += GridHelper.CELL_SIZE.x
	elif event.is_action_pressed("soft_drop"):
		position.y += GridHelper.CELL_SIZE.y


func get_grid_state() -> Models.MoleculeState:
	var cell := GridHelper.world_to_cell(position)
	var cell_state := Models.CellState.new(cell)
	var atom := Models.AtomState.new(get_instance_id() * 10, molecule_id, cell_state)
	var molecule_state := Models.MoleculeState.new(get_instance_id(), molecule_id, [], [atom])
	return molecule_state
