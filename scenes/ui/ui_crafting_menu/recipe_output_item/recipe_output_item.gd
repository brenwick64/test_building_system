class_name UIRecipeOutputItem
extends MarginContainer

signal pressed

var grayscale_shader: Shader = preload("res://shaders/grayscale.gdshader")

@export var texture_min_size: int = 50
@export var texture: Texture
@export var item_id: int

@onready var button: Button = $Button
@onready var center_container: CenterContainer = $Button/CenterContainer

## -- methods --
func check_input_items(input_items: Array[UIRecipeInputItem]) -> void:
	for input_item: UIRecipeInputItem in input_items:
		if not input_item.player_has_items:
			_disable_ui()
			return
	_enable_ui()

func _ready() -> void:
	var texture_rect: TextureRect = _create_texture_rect(texture, texture_min_size)
	center_container.add_child(texture_rect)

## -- helper functions --
func _enable_ui() -> void:
	button.disabled = false
	if center_container.get_children():
		center_container.get_children()[0].material.set_shader_parameter("use_grayscale", false)

func _disable_ui() -> void:
	button.disabled = true
	if center_container.get_children():
		center_container.get_children()[0].material.set_shader_parameter("use_grayscale", true)

func _calculate_texture_size(tex: Texture) -> Vector2:
	var tex_size: Vector2 = tex.get_size()
	var max_size: float = max(tex_size.x, tex_size.y)
	if max_size < texture_min_size:
		var percent_difference: float = max_size / texture_min_size
		var trimmed_percent_difference = round(percent_difference * 100) / 100
		var scalar_amount = 1 + (1 - trimmed_percent_difference)
		# smooth out pixels by flooring to integer
		return Vector2(floori(tex_size.x * scalar_amount), floori(tex_size.y * scalar_amount))
	return tex_size

func _create_texture_rect(tex: Texture2D, _min_size: int) -> TextureRect:
	var texture_rect: TextureRect = TextureRect.new()
	var shader_material: ShaderMaterial = ShaderMaterial.new()
	shader_material.shader = grayscale_shader
	texture_rect.material = shader_material
	texture_rect.custom_minimum_size = _calculate_texture_size(tex)
	texture_rect.texture = tex
	return texture_rect

## -- signals --
func _on_button_pressed() -> void:
	pressed.emit()
