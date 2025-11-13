extends Control

signal start_level_requested(level_id: String)

const LEVEL_SCENE_PATH := "res://scenes/Level.tscn"
const CONDITION_LABELS := {
	"₳": "Heat / 加热",
	"₼": "Ignite / 点燃",
	"¤": "Light / 光照",
	"₪": "Electric / 放电",
	"¥": "High Temp / 高温",
	"₩": "High Temp+Pressure / 高温高压",
	"@": "Catalyst / 催化剂"
}

@export var default_level_id := ""

@onready var level_list: VBoxContainer = %LevelList
@onready var selected_level_title: Label = %SelectedLevelTitle
@onready var selected_details: RichTextLabel = %SelectedDetails
@onready var status_label: Label = %StatusLabel
@onready var start_button: Button = %StartButton
@onready var scale_slider: HSlider = %ScaleSlider
@onready var colorblind_toggle: CheckButton = %ColorblindToggle

var _level_rows: Array[Dictionary] = []
var _level_lookup: Dictionary = {}
var _level_buttons: Dictionary = {}
var _selected_button: Button = null

func _ready() -> void:
	GameState.ui_scale_changed.connect(_on_ui_scale_changed)
	GameState.colorblind_mode_changed.connect(_on_colorblind_mode_changed)
	_on_ui_scale_changed(GameState.ui_scale)
	_cache_level_rows()
	if default_level_id.is_empty() and _level_rows.size() > 0:
		default_level_id = str(_level_rows[0].get("L0_LEVEL", ""))
	_populate_level_list()
	var initial_selection := GameState.selected_level_id if GameState.selected_level_id != "" else default_level_id
	_select_level(initial_selection, false)
	GameState.level_selected.connect(_on_game_state_selection)
	scale_slider.value = GameState.ui_scale
	scale_slider.value_changed.connect(_on_scale_slider_changed)
	colorblind_toggle.button_pressed = GameState.colorblind_mode
	colorblind_toggle.toggled.connect(_on_colorblind_toggled)

func _cache_level_rows() -> void:
	_level_rows = DataService.get_level_rows()
	_level_lookup.clear()
	for level_row: Dictionary in _level_rows:
		var level_name := str(level_row.get("L0_LEVEL", ""))
		_level_lookup[level_name] = level_row

func _populate_level_list() -> void:
	for child in level_list.get_children():
		child.queue_free()
	_level_buttons.clear()
	for level_row: Dictionary in _level_rows:
		var button := Button.new()
		var level_name := str(level_row.get("L0_LEVEL", ""))
		var chapter := str(level_row.get("L3_CHAP", ""))
		button.text = "%s  •  Chapter %s" % [level_name, chapter if chapter != "" else "—"]
		button.toggle_mode = true
		button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		var unlocked := _is_level_unlocked(level_name)
		button.disabled = not unlocked
		if not unlocked:
			button.text += "  (Locked)"
		button.pressed.connect(Callable(self, "_on_level_button_pressed").bind(level_name))
		level_list.add_child(button)
		_level_buttons[level_name] = button

func _on_level_button_pressed(level_id: String) -> void:
	if not _is_level_unlocked(level_id):
		status_label.text = "Locked: finish earlier objectives to unlock."
		var button: Button = _level_buttons.get(level_id, null)
		if button:
			button.button_pressed = false
		return
	_select_level(level_id)

func _select_level(level_id: String, propagate := true) -> void:
	if level_id == "":
		return
	var row: Dictionary = _level_lookup.get(level_id, {})
	if row.is_empty():
		status_label.text = "Unknown level selection."
		return
	if _selected_button:
		_selected_button.button_pressed = false
	var button: Button = _level_buttons.get(level_id, null)
	if button:
		button.button_pressed = true
		_selected_button = button
	if propagate:
		GameState.select_level(level_id)
	_update_selected_details(row)
	status_label.text = "Ready to launch %s." % level_id
	start_button.disabled = false

func _update_selected_details(row: Dictionary) -> void:
	var level_name := str(row.get("L0_LEVEL", ""))
	var chapter := str(row.get("L3_CHAP", ""))
	var poem := str(row.get("L1_CODE", ""))
	var targets := str(row.get("L2_COUNT", ""))
	var banned := str(row.get("L5_BAN", ""))
	var conditions := _describe_conditions(row)
	selected_level_title.text = level_name
	var lines := []
	lines.append("Chapter: %s" % (chapter if chapter != "" else "—"))
	lines.append("Poetry Code: %s" % poem)
	lines.append("Targets: %s" % (targets if targets != "" else "See CSV"))
	lines.append("Conditions: %s" % conditions)
	lines.append("Banned: %s" % (banned if banned != "" else "None"))
	selected_details.text = "\n".join(lines)

func _describe_conditions(row: Dictionary) -> String:
	var codes := _parse_codes(str(row.get("L1_CODE", "")))
	var symbols := []
	var seen := {}
	for code in codes:
		var reactants := DataService.get_reactant_array(code, true)
		for symbol in reactants:
			if DataService.is_condition_symbol(symbol) and not seen.has(symbol):
				seen[symbol] = true
				symbols.append(symbol)
	if symbols.is_empty():
		return "None"
	var readable: Array[String] = []
	for symbol in symbols:
		readable.append("%s (%s)" % [CONDITION_LABELS.get(symbol, "Cond"), symbol])
	return ", ".join(readable)

func _parse_codes(text: String) -> Array[String]:
	if text == "":
		return []
	var parts := text.split("&", false)
	var codes: Array[String] = []
	for part in parts:
		codes.append(String(part))
	return codes

func _is_level_unlocked(level_id: String) -> bool:
	if GameState.unlocked_levels.is_empty():
		return _level_rows.size() > 0 and level_id == str(_level_rows[0].get("L0_LEVEL", ""))
	return GameState.unlocked_levels.has(level_id)

func _on_start_button_pressed() -> void:
	var level_id := GameState.selected_level_id if GameState.selected_level_id != "" else default_level_id
	if level_id == "":
		push_warning("MainMenu: no level selected.")
		return
	if not _is_level_unlocked(level_id):
		status_label.text = "Cannot start locked level."
		return
	start_level_requested.emit(level_id)
	GameState.set_current_level(level_id)
	var err := get_tree().change_scene_to_file(LEVEL_SCENE_PATH)
	if err != OK:
		push_error("MainMenu: failed to load %s (error %s)" % [LEVEL_SCENE_PATH, err])

func _on_game_state_selection(level_id: String) -> void:
	if not is_inside_tree():
		return
	_select_level(level_id, false)

func _on_scale_slider_changed(value: float) -> void:
	GameState.set_ui_scale(value)

func _on_colorblind_toggled(pressed: bool) -> void:
	GameState.set_colorblind_mode(pressed)

func _on_ui_scale_changed(scale: float) -> void:
	self.scale = Vector2.ONE * clampf(scale, 0.75, 1.5)
	if not is_equal_approx(scale_slider.value, scale):
		scale_slider.value = scale

func _on_colorblind_mode_changed(enabled: bool) -> void:
	if colorblind_toggle.button_pressed != enabled:
		colorblind_toggle.button_pressed = enabled
