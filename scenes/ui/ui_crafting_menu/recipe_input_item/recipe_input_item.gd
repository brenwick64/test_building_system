class_name UIRecipeInputItem
extends PanelContainer

var grayscale_shader: Shader = preload("res://shaders/grayscale.gdshader")

@export var texture_min_size: int = 50
@export var texture: Texture
@export var amount: int
@export var item_id: String

@onready var panel: Panel = $MarginContainer/Panel
@onready var circle_panel: Panel = $CirclePanel
@onready var label: Label = $CirclePanel/CenterContainer/Label

@onready var center_container: CenterContainer = $MarginContainer/Panel/CenterContainer

var player_has_items: bool = true

## -- methods --
func check_inventory(inventory_items: Array[RInventoryItem]) -> void:
	var has_enough: bool = inventory_items.any(
		func(inv_item: RInventoryItem) -> bool:
			return inv_item.item.item_id == item_id and inv_item.count >= amount)
	if has_enough: _enable_ui()
	else: _disable_ui()

## -- overrides --
func _ready() -> void:
	label.text = str(amount)
	var texture_rect: TextureRect = _create_texture_rect(texture, texture_min_size)
	center_container.add_child(texture_rect)

## -- helper functions --
func _enable_ui() -> void:
	player_has_items = true
	panel.theme_type_variation = "SubPanel"
	circle_panel.theme_type_variation = "CirclePanel"
	if center_container.get_children():
		center_container.get_children()[0].material.set_shader_parameter("use_grayscale", false)

func _disable_ui() -> void:
	player_has_items = false
	panel.theme_type_variation = "SubPanelDisabled"
	circle_panel.theme_type_variation = "CirclePanelDisabled"
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
