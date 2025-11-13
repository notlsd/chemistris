extends HBoxContainer
class_name ChemistrisConditionBadge

@onready var icon_rect: TextureRect = $Icon
@onready var name_label: Label = $NameLabel

func set_condition(symbol: String, readable_name: String, icon: Texture2D) -> void:
	# Display the Unicode symbol alongside its localized name so players learn them together.
	name_label.text = "%s • %s" % [symbol, readable_name]
	icon_rect.texture = icon
