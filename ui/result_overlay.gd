extends Control
class_name ChemistrisResultOverlay

signal replay_requested
signal exit_to_menu_requested

@onready var title_label: Label = %Title
@onready var message_label: Label = %Message
@onready var action_button: Button = %ActionButton
@onready var exit_button: Button = %ExitButton

var _is_success := true

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	action_button.pressed.connect(func(): replay_requested.emit())
	exit_button.pressed.connect(func(): exit_to_menu_requested.emit())
	GameState.ui_scale_changed.connect(_on_ui_scale_changed)
	_on_ui_scale_changed(GameState.ui_scale)

func show_result(is_success: bool, message: String) -> void:
	_is_success = is_success
	title_label.text = "Success" if is_success else "Try Again"
	message_label.text = message
	var color := Color.from_string("#22C55E", Color.WHITE) if is_success else Color.from_string("#F97316", Color.ORANGE)
	title_label.add_theme_color_override("font_color", color)
	action_button.text = "Replay Level" if is_success else "Retry Reaction"

func _on_ui_scale_changed(scale: float) -> void:
	self.scale = Vector2.ONE * clampf(scale, 0.75, 1.5)
