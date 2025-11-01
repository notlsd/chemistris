extends Control

signal display_finished

@export var display_time := 3.0

@onready var timer: Timer = $Timer
@onready var equation_label: RichTextLabel = $Panel/EquationLabel

func show_reaction(equation_text: String) -> void:
	equation_label.text = equation_text
	timer.start(display_time)

func _on_timer_timeout() -> void:
	display_finished.emit()
