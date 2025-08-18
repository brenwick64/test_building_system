extends PanelContainer

@export var texture_min_size: int = 50
@export var texture: Texture
@export var amount: int

@onready var label: Label = $CirclePanel/Label
@onready var center_container: CenterContainer = $MarginContainer/Panel/CenterContainer

func _calculate_texture_size(texture: Texture) -> Vector2:
	var tex_size: Vector2 = texture.get_size()
	var max_size: float = max(tex_size.x, tex_size.y)
	if max_size < texture_min_size:
		var percent_difference: float = max_size / texture_min_size
		var trimmed_percent_difference = round(percent_difference * 100) / 100
		var scalar_amount = 1 + (1 - trimmed_percent_difference)
		# smooth out pixels by flooring to integer
		return Vector2(floori(tex_size.x * scalar_amount), floori(tex_size.y * scalar_amount))
	return tex_size
	
func _create_texture_rect(texture: Texture2D, min_size: int) -> TextureRect:
	var texture_rect: TextureRect = TextureRect.new()
	texture_rect.custom_minimum_size = _calculate_texture_size(texture)
	texture_rect.texture = texture
	return texture_rect

func _ready() -> void:
	label.text = str(amount)
	var texture_rect: TextureRect = _create_texture_rect(texture, texture_min_size)
	center_container.add_child(texture_rect)
