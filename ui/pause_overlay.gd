extends Control
class_name ChemistrisPauseOverlay

signal resume_requested
signal exit_to_menu_requested

@onready var resume_button: Button = %ResumeButton
@onready var exit_button: Button = %ExitButton

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	resume_button.pressed.connect(func(): resume_requested.emit())
	exit_button.pressed.connect(func(): exit_to_menu_requested.emit())
	GameState.ui_scale_changed.connect(_on_ui_scale_changed)
	_on_ui_scale_changed(GameState.ui_scale)

func _on_ui_scale_changed(scale: float) -> void:
	self.scale = Vector2.ONE * clampf(scale, 0.75, 1.5)
