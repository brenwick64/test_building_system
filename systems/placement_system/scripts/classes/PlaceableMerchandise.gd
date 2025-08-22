class_name PlaceableMerchandise
extends PlaceableBase

var merchandise_data: RItemData
var tile_coords: Vector2i
var is_valid_placement: bool = true

func remove() -> void:
	super.remove()

func show_outline() -> void:
	var shader_material: ShaderMaterial = sprite.material
	shader_material.set_shader_parameter("width", 0.55)  
	shader_material.set_shader_parameter("pattern", 1)
	
func hide_outline() -> void:
	var shader_material: ShaderMaterial = sprite.material
	shader_material.set_shader_parameter("width", 0)
	shader_material.set_shader_parameter("pattern", 1)
