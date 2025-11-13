extends HBoxContainer
class_name ChemistrisConditionBadge

const _FALLBACK_SIZE := 16

@onready var icon_rect: TextureRect = $Icon
@onready var name_label: Label = $NameLabel

var _symbol := ""
var _readable_name := ""
var _icon: Texture2D
var _color := Color.WHITE
var _colorblind_mode := false
var _fallback_texture: Texture2D

func _ready() -> void:
	_ensure_nodes()
	_ensure_fallback_texture()
	_update_visuals()

func set_condition(symbol: String, readable_name: String, icon: Texture2D, color: Color, colorblind_enabled: bool) -> void:
	_symbol = symbol
	_readable_name = readable_name
	_icon = icon
	_color = color
	_colorblind_mode = colorblind_enabled
	_update_visuals()

func apply_colorblind_mode(enabled: bool) -> void:
	_colorblind_mode = enabled
	_update_visuals()

func _update_visuals() -> void:
	_ensure_nodes()
	_ensure_fallback_texture()
	if _symbol == "":
		return
	name_label.text = "%s • %s" % [_symbol, _readable_name]
	var texture_to_use: Texture2D = _icon if _icon != null else _fallback_texture
	icon_rect.texture = texture_to_use
	if _colorblind_mode:
		icon_rect.self_modulate = _color
	else:
		icon_rect.self_modulate = Color.WHITE

func _ensure_nodes() -> void:
	if icon_rect == null:
		icon_rect = $Icon
	if name_label == null:
		name_label = $NameLabel

func _ensure_fallback_texture() -> void:
	if _fallback_texture != null:
		return
	var image := Image.create(_FALLBACK_SIZE, _FALLBACK_SIZE, false, Image.FORMAT_RGBA8)
	image.fill(Color.WHITE)
	_fallback_texture = ImageTexture.create_from_image(image)
