extends Control
class_name ChemistrisLevelHud

const ConditionBadgeScene := preload("res://ui/condition_badge.tscn")

@onready var level_title: Label = $Margin/VBox/Header/LevelTitle
@onready var chapter_label: Label = $Margin/VBox/Header/ChapterLabel
@onready var objective_label: Label = $Margin/VBox/ObjectiveLabel
@onready var banned_label: Label = $Margin/VBox/BannedLabel
@onready var equation_label: RichTextLabel = $Margin/VBox/EquationPanel/EquationLabel
@onready var reaction_label: Label = $Margin/VBox/StatusPanel/StatusVBox/ReactionStatus
@onready var hint_label: Label = $Margin/VBox/StatusPanel/StatusVBox/HintLabel
@onready var condition_container: HBoxContainer = $Margin/VBox/ConditionPanel/ConditionVBox/ConditionContainer
@onready var condition_placeholder: Label = $Margin/VBox/ConditionPanel/ConditionVBox/ConditionPlaceholder

var _reaction_attempts := 0

func set_level_metadata(level_name: String, chapter: String, objective: String, banned: String) -> void:
	level_title.text = level_name
	chapter_label.text = "Chapter %s" % (chapter if chapter != "" else "—")
	objective_label.text = "Objective: %s" % (objective if objective != "" else "Refer to CSV row")
	banned_label.text = "Banned: %s" % (banned if banned != "" else "None")

func set_equations(codes: Array[String]) -> void:
	var text := ""
	for code in codes:
		text += "- %s\n" % code
	equation_label.text = text.strip_edges()

func set_condition_symbols(symbols: Array[String], condition_data: Dictionary) -> void:
	for child in condition_container.get_children():
		child.queue_free()
	if symbols.is_empty():
		condition_placeholder.show()
		return
	condition_placeholder.hide()
	for symbol in symbols:
		var badge: ChemistrisConditionBadge = ConditionBadgeScene.instantiate() as ChemistrisConditionBadge
		if badge == null:
			continue
		var descriptor: Dictionary = condition_data.get(symbol, {})
		var display_name: String = str(descriptor.get("name", "Unknown"))
		var icon_value: Variant = descriptor.get("icon", null)
		var icon: Texture2D = icon_value as Texture2D
		badge.set_condition(symbol, display_name, icon)
		condition_container.add_child(badge)

func record_reaction(success: bool, message: String) -> void:
	_reaction_attempts += 1
	var status := "Attempt %d: %s" % [_reaction_attempts, message]
	reaction_label.text = status
	if success:
		hint_label.text = "Products generated successfully."
	else:
		hint_label.text = "Reaction failed. Adjust adjacency or condition tokens."

func show_hint(text: String) -> void:
	hint_label.text = text
