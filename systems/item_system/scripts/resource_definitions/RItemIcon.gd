class_name RItemIcon
extends Resource

var item_id: String

@export var texture: AtlasTexture
@export var icon_scale_multiplier: float = 1.0

func new_icon_scene() -> TextureRect:
	var texture_rect: TextureRect = TextureRect.new()
	texture_rect.texture = texture
	texture_rect.set_anchors_preset(Control.LayoutPreset.PRESET_CENTER)
	# manual centering
	texture_rect.size = texture.get_size()
	texture_rect.position -= (texture_rect.size / 2) * icon_scale_multiplier
	texture_rect.scale = Vector2(icon_scale_multiplier, icon_scale_multiplier)
	return texture_rect
