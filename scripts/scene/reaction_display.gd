extends Control

signal display_finished

@export var display_time := 3.0

@onready var timer: Timer = $Timer
@onready var equation_label: RichTextLabel = $Panel/EquationLabel

func show_reaction(equation_code: String, product_counts: Dictionary) -> void:
	equation_label.text = _format_text(equation_code, product_counts)
	timer.start(display_time)

func _format_text(equation_code: String, product_counts: Dictionary) -> String:
	var lines: Array[String] = [equation_code]
	for product in product_counts.keys():
		lines.append("%s × %d" % [product, int(product_counts[product])])
	return "\n".join(lines)

func _on_timer_timeout() -> void:
	display_finished.emit()
